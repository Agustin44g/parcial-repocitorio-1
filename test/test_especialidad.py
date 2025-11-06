import unittest
import os
from flask import current_app
from app import create_app
from app.models import Especialidad, TipoEspecialidad
from app.services import EspecialidadService, TipoEspecialidadService
from test.instancias import nuevaespecialidad, nuevotipoespecialidad
from app import db

class EspecialidadTestCase(unittest.TestCase):
    def setUp(self):
        os.environ['FLASK_CONTEXT'] = 'testing'
        self.app = create_app()
        self.app_context = self.app.app_context()
        self.app_context.push()
        db.create_all()

    def tearDown(self):
        db.session.remove()
        db.drop_all()
        self.app_context.pop()

    def test_crear(self):
        especialidad= nuevaespecialidad()
        self.assertIsNotNone(especialidad)
        self.assertIsNotNone(especialidad.id)
        self.assertGreaterEqual(especialidad.id,1)
        self.assertEqual(especialidad.nombre, "Matematicas")
        self.assertEqual(especialidad.tipoespecialidad.nombre, "Cardiologia")

    def test_buscar_por_id(self):
        especialidad = nuevaespecialidad()
        r=EspecialidadService.buscar_por_id(especialidad.id)
        self.assertIsNotNone(r)
        self.assertEqual(r.nombre, "Matematicas")
        self.assertEqual(r.letra, "A")

    def test_buscar_todos(self):
        especialidad1 =nuevaespecialidad()
        especialidad2 =nuevaespecialidad()
        especialidades = EspecialidadService.buscar_todos()
        self.assertIsNotNone(especialidades)
        self.assertEqual(len(especialidades),2)

    def test_actualizar(self):
        especialidad = nuevaespecialidad()
        especialidad.nombre = "matematica actualizada"
        especialidad_actualizada = EspecialidadService.actualizar(especialidad.id, especialidad)
        self.assertEqual(especialidad_actualizada.nombre, "matematica actualizada")

    def test_borrar(self):
        especialidad = nuevaespecialidad()
        borrado = EspecialidadService.borrar_por_id(especialidad.id)
        self.assertTrue(borrado)
        resultado = EspecialidadService.buscar_por_id(especialidad.id)
        self.assertIsNone(resultado)

    def test_buscar_alumnos_y_facultad_por_especialidad(self):
        especialidad_sistemas = nuevaespecialidad(nombre="Sistemas")
        especialidad_quimica = nuevaespecialidad(nombre="Quimica")

        alumno1 = nuevoalumno(nombre="Juan", apellido="Perez", especialidad=especialidad_sistemas)
        alumno2 = nuevoalumno(nombre="Ana", apellido="Garcia", especialidad=especialidad_sistemas)
        alumno3 = nuevoalumno(nombre="Luis", apellido="Lopez", especialidad=especialidad_quimica)

        resultado = EspecialidadService.buscar_alumnos_por_especialidad(especialidad_sistemas.id)

        self.assertIsNotNone(resultado)
        
        self.assertIn("facultad", resultado)
        self.assertEqual(resultado["facultad"].nombre, "Facultad de Ciencias")

        self.assertIn("alumnos", resultado)
        self.assertEqual(len(resultado["alumnos"]), 2)
        
        nombres_alumnos = {alumno.nombre for alumno in resultado["alumnos"]}
        self.assertIn("Juan", nombres_alumnos)
        self.assertIn("Ana", nombres_alumnos)
        self.assertNotIn("Luis", nombres_alumnos)
    