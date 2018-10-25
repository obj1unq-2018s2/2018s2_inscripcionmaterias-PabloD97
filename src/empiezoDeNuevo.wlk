
class MateriaAprobada{
	var nota
	var property materia
}

class Alumno{
	
	var property carreras
	
	var property materiasAprobadas
	
	var property creditos

	var property inscriptoEn
	
	var property esperaVacanteEn
	
	method aprobo(terminada){
		materiasAprobadas.add(terminada.materia() )
	}
}

class MateriaNoPideNada {
	
	var property  perteneceACarrera
	
	var property inscriptos
	
	var property anio
	
	var property cupo
	
	var property listaDeEspera
	
	method hayCupo(){
		return inscriptos.size() < cupo
	}
	
	method inscribir(alumno){
		inscriptos.add(alumno)
		alumno.inscriptoEn().add(self)
	}
	
	method agregarAListaDeEspera(alumno){
		listaDeEspera.add(alumno)
		alumno.esperaVacanteEn().add(self)
	}
	
	method cumpleRequisitos(alumno){
		return  alumno.carreras().contains(perteneceACarrera) 
				and
				not self.inscriptos().contains(alumno)
				and
				not alumno.materiasAprobadas().contains(self)
	}
}

class MateriaPideCorrelativas inherits MateriaNoPideNada{
	
	var property correlativas
	
	method cumpleCorrelativas(alumno){
		return alumno.materiasAprobadas().filter(
			{ materia=> correlativas.contains(materia) }
				) == correlativas
	}
	override method cumpleRequisitos(alumno){
		return super(alumno) and self.cumpleCorrelativas(alumno)
	}
}

class MateriaRequiereCreditos inherits MateriaNoPideNada{
	var creditosNecesarios
	
	method cumpleConCreditos(alumno){
		return alumno.creditos() >= creditosNecesarios
	}
	
	override method cumpleRequisitos(alumno){
		return super(alumno) and self.cumpleConCreditos(alumno)
	}
}

class MateriaPideAniosAnteriores inherits MateriaNoPideNada {
	
	
	method carreraDe(alumno){
		return alumno.carreras().find({ carrera=> carrera == perteneceACarrera })
	}
	
	method cumpleConMateriasDe(alumno){
		return self.carreraDe(alumno).materiasDe(anio - 1).asSet() 
			   == alumno.materiasAprobadas().filter({ materia=> materia.anio() == anio - 1 
			   		and materia.perteneceACarrera() == perteneceACarrera
			   			}).asSet()
	}
	
	override method cumpleRequisitos(alumno){
		return super(alumno) and self.cumpleConMateriasDe(alumno)
	}
}



class Carrera{
	var property materias
	
	method materiasDe(anio){
		return materias.filter({ materia=> materia.anio() == anio })
	}
}

object  universidad{
	//1
	method puedeCursar(alumno,materia){
		return materia.cumpleRequisitos(alumno)
	}
	//2
	method aproboMateria(alumno,materiaAprobada){
		var contador= 0
		if( contador <= 0 ){
			contador = 1
			return alumno.aprobo(materiaAprobada) 
		}
		else {
			 self.error("no se puede anotar 2 veces la nota")
		}
	}
	//3
	method alumnoPuedeInscribirse(alumno,materia){
		return self.puedeCursar(alumno,materia) and materia.hayCupo()
	}
	
	method inscribirAlumno(alumno, materia){
		if( self.alumnoPuedeInscribirse(alumno,materia) ){
			materia.inscribir(alumno)
		}
		else if( self.puedeCursar(alumno,materia) ){
			materia.agregarAListaDeEspera(alumno)	
		}
	}
	
	//4
	method darDeBaja(alumno,materia){
		materia.inscriptos().remove(alumno)
		if( materia.listaDeEspera().size() > 0 ){
			materia.inscriptos().add(materia.listaDeEspera().get(1))
		}
	}

	//5
	method estudiantesInscriptos(materia){
		return materia.inscriptos()
	}
	method estudiantesEnListaDeEspera(materia){
		return materia.listaDeEspera()
	}
	
	//6
	method materiasEnLasQueSePuedeAnotar(alumno,carrera){
		if( alumno.carreras().contains(carrera)  ){
			return carrera.materias().filter({
				materia=> materia.cumpleRequisitos(alumno) 
			})
		}
	}
	method materiasDe(alumno){
		return alumno.inscriptoEn()
	}
	
	method enListaDeEspera(alumno){
		return alumno.esperaVacanteEn()
	}
}




