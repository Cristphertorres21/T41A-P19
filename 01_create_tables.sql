CREATE TABLE IF NOT EXISTS roles (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre TEXT NOT NULL UNIQUE,
    descripcion TEXT
);

CREATE TABLE IF NOT EXISTS usuarios (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username TEXT NOT NULL UNIQUE,
    nombre TEXT,
    email TEXT UNIQUE,
    password_hash TEXT,
    rol_id INT NOT NULL REFERENCES roles(id),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT now(),
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS materia_prima (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    numero_parte TEXT NOT NULL UNIQUE,
    descripcion TEXT,
    ancho NUMERIC(12,4) NOT NULL,
    alto NUMERIC(12,4) NOT NULL,
    espesor NUMERIC(12,4),
    unidad TEXT DEFAULT 'mm',
    fecha_ingreso TIMESTAMP WITH TIME ZONE DEFAULT now(),
    metadata JSONB,
    disponible BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS productos (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    numero_parte TEXT NOT NULL UNIQUE,
    nombre TEXT NOT NULL,
    descripcion TEXT,
    cantidad_por_producto INT NOT NULL DEFAULT 1,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE TABLE IF NOT EXISTS piezas (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    producto_id INT NOT NULL REFERENCES productos(id) ON DELETE CASCADE,
    nombre TEXT,
    numero_parte TEXT,
    cantidad INT NOT NULL DEFAULT 1,
    area NUMERIC(14,6),
    geometria JSONB NOT NULL,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT now(),
    ultima_modificacion TIMESTAMP WITH TIME ZONE
);

CREATE TABLE IF NOT EXISTS geometrias (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pieza_id INT NOT NULL REFERENCES piezas(id) ON DELETE CASCADE,
    version INT NOT NULL DEFAULT 1,
    data JSONB NOT NULL,
    area_calculada NUMERIC(14,6),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT now(),
    UNIQUE (pieza_id, version)
);

CREATE TABLE IF NOT EXISTS colocaciones (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    materia_id INT NOT NULL REFERENCES materia_prima(id) ON DELETE CASCADE,
    pieza_id INT NOT NULL REFERENCES piezas(id),
    x NUMERIC(14,6) NOT NULL,
    y NUMERIC(14,6) NOT NULL,
    angulo NUMERIC(10,4) DEFAULT 0,
    escalado NUMERIC(12,6) DEFAULT 1.0,
    rotacion_aplicada BOOLEAN DEFAULT TRUE,
    estado TEXT DEFAULT 'propuesta',
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_colocaciones_materia_estado ON colocaciones(materia_id, estado);

CREATE TABLE IF NOT EXISTS eventos (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    entidad_tipo TEXT NOT NULL,
    entidad_id INT NOT NULL,
    usuario_id INT REFERENCES usuarios(id),
    accion TEXT NOT NULL,
    datos JSONB,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_eventos_entidad ON eventos(entidad_tipo, entidad_id);

CREATE TABLE IF NOT EXISTS configuracion (
    clave TEXT PRIMARY KEY,
    valor JSONB,
    descripcion TEXT
);

CREATE TABLE IF NOT EXISTS reglas_distancia (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre TEXT NOT NULL UNIQUE,
    distancia_minima NUMERIC(12,6) NOT NULL,
    descripcion TEXT
);

CREATE TABLE IF NOT EXISTS resultados_aprovechamiento (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    materia_id INT NOT NULL REFERENCES materia_prima(id) ON DELETE CASCADE,
    porcentaje NUMERIC(6,3) NOT NULL,
    area_total NUMERIC(14,6) NOT NULL,
    area_usada NUMERIC(14,6) NOT NULL,
    generado_en TIMESTAMP WITH TIME ZONE DEFAULT now()
);
