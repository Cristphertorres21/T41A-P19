INSERT INTO roles (nombre, descripcion)
VALUES ('Administrador', 'Acceso total'), ('Operador', 'Acceso limitado')
ON CONFLICT DO NOTHING;

INSERT INTO usuarios (username, nombre, email, password_hash, rol_id)
VALUES 
('admin', 'Administrador', 'admin@sistema.com', 'hash123', 1),
('oper1', 'Operador 1', 'oper1@sistema.com', 'hash456', 2)
ON CONFLICT DO NOTHING;

INSERT INTO materia_prima (numero_parte, descripcion, ancho, alto, espesor, unidad, metadata)
VALUES
('MP-001', 'Lam MDF 1200x2400', 1200, 2400, 18, 'mm', '{"color":"natural"}')
ON CONFLICT DO NOTHING;

INSERT INTO productos (numero_parte, nombre, descripcion, cantidad_por_producto)
VALUES
('PRD-001', 'Gabinete', 'Gabinete pequeño', 1)
ON CONFLICT DO NOTHING;

INSERT INTO piezas (producto_id, nombre, numero_parte, cantidad, area, geometria)
VALUES
(1, 'Frente', 'PZA-FR-001', 1, 60000, '{"tipo":"rect","ancho":300,"alto":200}'),
(1, 'Lateral', 'PZA-LT-001', 2, 48000, '{"tipo":"rect","ancho":240,"alto":200}')
ON CONFLICT DO NOTHING;

INSERT INTO geometrias (pieza_id, version, data, area_calculada)
VALUES
(1, 1, '{"tipo":"rect","ancho":300,"alto":200}', 60000),
(2, 1, '{"tipo":"rect","ancho":240,"alto":200}', 48000)
ON CONFLICT DO NOTHING;

INSERT INTO colocaciones (materia_id, pieza_id, x, y, angulo, estado)
VALUES
(1, 1, 50, 50, 0, 'propuesta'),
(1, 2, 400, 50, 0, 'propuesta')
ON CONFLICT DO NOTHING;

INSERT INTO reglas_distancia (nombre, distancia_minima, descripcion)
VALUES ('distancia_base', 10, 'Dist base')
ON CONFLICT DO NOTHING;

INSERT INTO configuracion (clave, valor, descripcion)
VALUES
('modo_operacion', '{"optimizar":true}', 'Modo'),
('dist_orilla', '{"minima":5}', 'Dist')
ON CONFLICT DO NOTHING;

INSERT INTO eventos (entidad_tipo, entidad_id, usuario_id, accion, datos)
VALUES
('pieza', 1, 1, 'crear', '{"detalle":"inicio"}');
