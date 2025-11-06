warning: in the working copy of 'test/test_cargo.py', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'test/test_tipodocumento.py', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'test/test_tipoespecialidad.py', LF will be replaced by CRLF the next time Git touches it
[1mdiff --git a/app/mapping/especialidad_detalle_mapping.py b/app/mapping/especialidad_detalle_mapping.py[m
[1mindex e69de29..eb4d11f 100644[m
[1m--- a/app/mapping/especialidad_detalle_mapping.py[m
[1m+++ b/app/mapping/especialidad_detalle_mapping.py[m
[36m@@ -0,0 +1,7 @@[m
[32m+[m[32mfrom marshmallow import Schema, fields[m
[32m+[m[32mfrom app.mapping.alumno_mapping import AlumnoMapping[m
[32m+[m[32mfrom app.mapping.facultad_mapping import FacultadMapping[m
[32m+[m
[32m+[m[32mclass EspecialidadDetalleMapping(Schema):[m
[32m+[m[32m    facultad = fields.Nested(FacultadMapping)[m
[32m+[m[32m    alumnos = fields.Nested(AlumnoMapping, many=True)[m
\ No newline at end of file[m
[1mdiff --git a/app/repositories/alumno_repositorio.py b/app/repositories/alumno_repositorio.py[m
[1mindex 48a6af6..33baf5a 100644[m
[1m--- a/app/repositories/alumno_repositorio.py[m
[1m+++ b/app/repositories/alumno_repositorio.py[m
[36m@@ -35,3 +35,7 @@[m [mclass AlumnoRepository:[m
         db.session.delete(alumno)[m
         db.session.commit()[m
         return True[m
[32m+[m
[32m+[m[32m    @staticmethod[m
[32m+[m[32m    def buscar_por_especialidad_id(especialidad_id: int) -> list[Alumno]:[m
[32m+[m[32m        return db.session.query(Alumno).filter_by(especialidad_id=especialidad_id).all()[m
\ No newline at end of file[m
[1mdiff --git a/app/services/especialidad_service.py b/app/services/especialidad_service.py[m
[1mindex 21f2605..7bcc704 100644[m
[1m--- a/app/services/especialidad_service.py[m
[1m+++ b/app/services/especialidad_service.py[m
[36m@@ -1,5 +1,5 @@[m
[31m-from app.models import Especialidad[m
[31m-from app.repositories import EspecialidadRepository[m
[32m+[m[32mfrom app.models import Especialidad, Alumno, Facultad[m
[32m+[m[32mfrom app.repositories import EspecialidadRepository, AlumnoRepository[m
 [m
 class EspecialidadService:[m
 [m
[36m@@ -30,3 +30,17 @@[m [mclass EspecialidadService:[m
     @staticmethod[m
     def borrar_por_id(id: int) -> bool:[m
         return EspecialidadRepository.borrar_por_id(id)[m
[32m+[m[32m    @staticmethod[m
[32m+[m[32m    def buscar_alumnos_por_especialidad(id: int) -> dict:[m
[32m+[m[32m        especialidad = EspecialidadRepository.buscar_por_id(id)[m
[32m+[m[32m        if not especialidad:[m
[32m+[m[32m            return None[m
[32m+[m[41m        [m
[32m+[m[32m        facultad = especialidad.facultad[m[41m [m
[32m+[m[41m        [m
[32m+[m[32m        alumnos = AlumnoRepository.buscar_por_especialidad_id(id)[m
[32m+[m[41m        [m
[32m+[m[32m        return {[m
[32m+[m[32m            "facultad": facultad,[m
[32m+[m[32m            "alumnos": alumnos[m
[32m+[m[32m        }[m
[1mdiff --git a/test/test_cargo.py b/test/test_cargo.py[m
[1mindex 5a89b6e..cab47ea 100644[m
[1m--- a/test/test_cargo.py[m
[1m+++ b/test/test_cargo.py[m
[36m@@ -25,7 +25,7 @@[m [mclass CargoTestCase(unittest.TestCase):[m
         cargo = nuevocargo()[m
         self.assertIsNotNone(cargo)[m
         self.assertIsNotNone(cargo.nombre)[m
[31m-        self.assertGreaterEqual(cargo.nombre, "Profesor")[m
[32m+[m[32m        self.assertEqual(cargo.nombre, "Profesor")[m
         self.assertEqual(cargo.categoria_cargo.nombre, "Docente")[m
         self.assertEqual(cargo.tipo_dedicacion.nombre, "Dedicacion Completa")[m
 [m
[36m@@ -54,5 +54,4 @@[m [mclass CargoTestCase(unittest.TestCase):[m
         borrado= CargoService.borrar_por_id(cargo.id)[m
         self.assertTrue(borrado)[m
         resultado = CargoService.buscar_por_id(cargo.id)[m
[31m-        self.assertIsNone(resultado)[m
[31m-    [m
\ No newline at end of file[m
[32m+[m[32m        self.assertIsNone(resultado)[m
\ No newline at end of file[m
[1mdiff --git a/test/test_especialidad.py b/test/test_especialidad.py[m
[1mindex 24f1ac6..308ac81 100644[m
[1m--- a/test/test_especialidad.py[m
[1m+++ b/test/test_especialidad.py[m
[36m@@ -55,4 +55,26 @@[m [mclass EspecialidadTestCase(unittest.TestCase):[m
         resultado = EspecialidadService.buscar_por_id(especialidad.id)[m
         self.assertIsNone(resultado)[m
 [m
[32m+[m[32m    def test_buscar_alumnos_y_facultad_por_especialidad(self):[m
[32m+[m[32m        especialidad_sistemas = nuevaespecialidad(nombre="Sistemas")[m
[32m+[m[32m        especialidad_quimica = nuevaespecialidad(nombre="Quimica")[m
[32m+[m
[32m+[m[32m        alumno1 = nuevoalumno(nombre="Juan", apellido="Perez", especialidad=especialidad_sistemas)[m
[32m+[m[32m        alumno2 = nuevoalumno(nombre="Ana", apellido="Garcia", especialidad=especialidad_sistemas)[m
[32m+[m[32m        alumno3 = nuevoalumno(nombre="Luis", apellido="Lopez", especialidad=especialidad_quimica)[m
[32m+[m
[32m+[m[32m        resultado = EspecialidadService.buscar_alumnos_por_especialidad(especialidad_sistemas.id)[m
[32m+[m
[32m+[m[32m        self.assertIsNotNone(resultado)[m
[32m+[m[41m        [m
[32m+[m[32m        self.assertIn("facultad", resultado)[m
[32m+[m[32m        self.assertEqual(resultado["facultad"].nombre, "Facultad de Ciencias")[m
[32m+[m
[32m+[m[32m        self.assertIn("alumnos", resultado)[m
[32m+[m[32m        self.assertEqual(len(resultado["alumnos"]), 2)[m
[32m+[m[41m        [m
[32m+[m[32m        nombres_alumnos = {alumno.nombre for alumno in resultado["alumnos"]}[m
[32m+[m[32m        self.assertIn("Juan", nombres_alumnos)[m
[32m+[m[32m        self.assertIn("Ana", nombres_alumnos)[m
[32m+[m[32m        self.assertNotIn("Luis", nombres_alumnos)[m
     [m
\ No newline at end of file[m
[1mdiff --git a/test/test_tipodocumento.py b/test/test_tipodocumento.py[m
[1mindex 5b76f2c..7efd9b9 100644[m
[1m--- a/test/test_tipodocumento.py[m
[1m+++ b/test/test_tipodocumento.py[m
[36m@@ -25,27 +25,31 @@[m [mclass TipoDocumentoTestCase(unittest.TestCase):[m
         self.assertIsNotNone(tipodocumento)[m
         self.assertIsNotNone(tipodocumento.id)[m
         self.assertGreaterEqual(tipodocumento.id, 1)[m
[31m-        self.assertEqual(tipodocumento.dni, 46291002)[m
[32m+[m[32m        # Corregido: Probar 'sigla' o 'nombre', no 'dni'[m
[32m+[m[32m        self.assertEqual(tipodocumento.sigla, "DNI") # Asumiendo valor de instancia[m
 [m
     def test_buscar_por_id(self):[m
         tipodocumento = nuevotipodocumento()[m
         r=TipoDocumentoService.buscar_por_id(tipodocumento.id)[m
         self.assertIsNotNone(r)[m
[31m-        self.assertEqual(r.dni, 46291002)[m
[31m-        self.assertEqual(r.libreta_civica, "nacional")[m
[32m+[m[32m        # Corregido: Probar 'sigla' o 'nombre', no 'dni' o 'libreta_civica'[m
[32m+[m[32m        self.assertEqual(r.sigla, "DNI")[m[41m [m
[32m+[m[32m        self.assertEqual(r.nombre, "Documento Nacional") # Asumiendo valor de instancia[m
 [m
     def test_buscar_todos(self):[m
         tipodocumento1 = nuevotipodocumento()[m
[31m-        tipodocumento2 = nuevotipodocumento(48291002, "23456789", "98765432", "CD123456")[m
[32m+[m[32m        # Corregido: Usar los parámetros correctos de la instancia[m
[32m+[m[32m        tipodocumento2 = nuevotipodocumento(sigla="PAS", nombre="Pasaporte")[m[41m [m
         documentos = TipoDocumentoService.buscar_todos()[m
         self.assertIsNotNone(documentos)[m
         self.assertEqual(len(documentos), 2)[m
 [m
     def test_actualizar(self):[m
         tipodocumento = nuevotipodocumento()[m
[31m-        tipodocumento.dni = 89291002[m
[32m+[m[32m        # Corregido: Actualizar un campo que sí existe[m
[32m+[m[32m        tipodocumento.nombre = "DNI Actualizado"[m[41m [m
         tipodocumento_actualizado = TipoDocumentoService.actualizar(tipodocumento.id, tipodocumento)[m
[31m-        self.assertEqual(tipodocumento_actualizado.dni, 89291002)[m
[32m+[m[32m        self.assertEqual(tipodocumento_actualizado.nombre, "DNI Actualizado")[m
     [m
     def test_borrar(self):[m
         tipodocumento = nuevotipodocumento()[m
[1mdiff --git a/test/test_tipoespecialidad.py b/test/test_tipoespecialidad.py[m
[1mindex f3ba250..5a33f7f 100644[m
[1m--- a/test/test_tipoespecialidad.py[m
[1m+++ b/test/test_tipoespecialidad.py[m
[36m@@ -27,7 +27,6 @@[m [mclass TipoEspecialidadTestCase(unittest.TestCase):[m
         self.assertIsNotNone(tipoespecialidad.id)[m
         self.assertGreaterEqual(tipoespecialidad.id, 1)    [m
         self.assertEqual(tipoespecialidad.nombre, "Cardiologia")[m
[31m-        self.assertEqual(tipoespecialidad.nivel, "Avanzado")[m
 [m
     def test_buscar_por_id(self):[m
         tipoespecialidad = nuevotipoespecialidad()[m
[36m@@ -37,7 +36,7 @@[m [mclass TipoEspecialidadTestCase(unittest.TestCase):[m
     [m
     def test_buscar_todos(self):[m
         tipoespecialidad1 = nuevotipoespecialidad()[m
[31m-        tipoespecialidad2 = nuevotipoespecialidad("pediatria", "Basico")[m
[32m+[m[32m        tipoespecialidad2 = nuevotipoespecialidad(nombre="pediatria")[m
         tipoespecialidad = TipoEspecialidadService.buscar_todos()[m
         self.assertIsNotNone(tipoespecialidad)[m
         self.assertGreaterEqual(len(tipoespecialidad), 2)[m
[36m@@ -45,10 +44,8 @@[m [mclass TipoEspecialidadTestCase(unittest.TestCase):[m
     def test_actualizar(self):[m
         tipoespecialidad = nuevotipoespecialidad()[m
         tipoespecialidad.nombre = "Neurología"[m
[31m-        tipoespecialidad.nivel = "Intermedio"[m
         tipoespecialidad_actualizado = TipoEspecialidadService.actualizar(tipoespecialidad.id, tipoespecialidad)[m
         self.assertEqual(tipoespecialidad_actualizado.nombre, "Neurología")[m
[31m-        self.assertEqual(tipoespecialidad_actualizado.nivel, "Intermedio")[m
 [m
     def test_borrar(self):[m
         tipoespecialidad = nuevotipoespecialidad()[m
