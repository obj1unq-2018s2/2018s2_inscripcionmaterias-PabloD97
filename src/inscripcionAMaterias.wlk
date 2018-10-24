



class Aprobo{
	var nota
	var materia 
}



class Estudiante{
	
	var property notasDeMaterias
	var property aprobadas
	var property creditos
	var property perteneceACarreras
	
	method materiasAprobadas(materia){
		aprobadas.add(materia)
		creditos += materia.creditos()
	}
	
	method agregarNota(aprobada){
		notasDeMaterias.add(aprobada)
	}
	
	method carrera(){
		return perteneceACarreras
	}
	
}



class MateriaNoPideNada {
	
	var property inscriptos
	var property cupo
	var property anio
	var property listaDeEspera
	var property carrera
	
	method hayCupo(){
		return self.inscriptos() < self.cupo()
	}
	
	method alumnoCumple(alumno){
		return alumno.carrera().contains(carrera)
	}
	method inscribir(alumno){
		inscriptos.add(alumno)
	}
	
	method agregarAListaDeEspera(alumno){
		listaDeEspera.add(alumno)
	}
}

class MateriaQuePideCorrelativas inherits MateriaNoPideNada{
	var property materiasCorrelativas
	
	method cumpleCorrelativas(alumno){
		return alumno.aprobadas().filter({ 
					materia=> materiasCorrelativas.contains(materia)
		}) == materiasCorrelativas
	}
	
	override method alumnoCumple(alumno){
		return super(alumno) and self.cumpleCorrelativas(alumno)
	}
}

class MateriaPideCreditos inherits MateriaNoPideNada{
	var property cantidadDeCreditos
	
		
	method cumpleConCreditos(alumno){
		return alumno.creditos() == cantidadDeCreditos
	}
	
	override method alumnoCumple(alumno){
		return super(alumno) and self.cumpleConCreditos(alumno)
	}
}

class MateriaPideMateriasDeAniosAnteriores inherits MateriaNoPideNada{
	
	method cumpleConMateriasDeAnios(alumno){
		return alumno.carreras().find({ carreras=> carreras == self.carrera() })
	}
		
	override method alumnoCumple(alumno){
		return super(alumno) and
		 self.cumpleConMateriasDeAnios(alumno).materiasDeAnio(self.anio() - 1)
	}
}



class Carrera{
	
	var property materias
	
	method materiasDe(anio){
		materias.filter({ materia=> materia.anio() == anio })
	}
}



object universidad{
	//1
	method alumnoPuedeCursar(alumno,materia){
		return  not alumno.aprobadas().contains(materia)
				and not materia.inscriptos().contains(alumno)
				and materia.alumnoCumple(alumno)
	}
	
	//2
	method registrarMateriaAprobada(alumno,aprobada,materia){
		alumno.agregarNota(aprobada)
		materia.inscriptos().remove(alumno)
	} 
	
	//3
	method alumnoPuedeInscribirse(alumno, materia){
		return self.alumnoPuedeCursar(alumno,materia) and materia.hayCupo()
	}
	
	method inscribirAlumno(alumno,materia){
		if( self.alumnoPuedeInscribirse(alumno, materia ) ){
			materia.inscribir(alumno)
		}
		else if( self.alumnoPuedeCursar(alumno,materia) ){
			materia.agregarAListaDeEspera(alumno)
		}
	}
	
	//4
	method darDeBajaAlumno(alumno,materia){
		materia.inscriptos().remove(alumno)
			if( materia.listaDeEspera().size() > 0){
				materia.inscribir( materia.listaDeEspera().get(1) )
			}
	}
	
	//5
	method resultadosDeInscripcion(){}
	
	
}












