from marshmallow import Schema, fields
from app.mapping.alumno_mapping import AlumnoMapping
from app.mapping.facultad_mapping import FacultadMapping

class EspecialidadDetalleMapping(Schema):
    facultad = fields.Nested(FacultadMapping)
    alumnos = fields.Nested(AlumnoMapping, many=True)