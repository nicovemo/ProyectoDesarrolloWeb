-- Script completo de base de datos para Plataforma Colegial
-- Ejecutar este script en MySQL para crear la base de datos y todas las tablas necesarias

-- =====================================
-- CREACIÓN DE BASE DE DATOS
-- =====================================

DROP DATABASE IF EXISTS dev1_db;
CREATE DATABASE dev1_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE dev1_db;

-- =====================================
-- CREACIÓN DE TABLAS
-- =====================================

-- Tabla de usuarios (base para todos los tipos de usuario)
CREATE TABLE usuarios (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    rol ENUM('ESTUDIANTE', 'PROFESOR', 'ADMINISTRATIVO') NOT NULL DEFAULT 'ESTUDIANTE',
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de profesores
CREATE TABLE profesor (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    correo VARCHAR(120) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    cedula VARCHAR(20),
    telefono VARCHAR(15),
    especialidad VARCHAR(100),
    activo BOOLEAN DEFAULT TRUE,
    usuario_id BIGINT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL
);

-- Tabla de estudiantes
CREATE TABLE estudiante (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    apellidos VARCHAR(120),
    correo VARCHAR(120) UNIQUE,
    cedula VARCHAR(20),
    telefono VARCHAR(15),
    fecha_nacimiento DATE,
    grado VARCHAR(20),
    seccion VARCHAR(10),
    activo BOOLEAN DEFAULT TRUE,
    usuario_id BIGINT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL
);

-- Tabla de administrativos
CREATE TABLE administrativo (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    correo VARCHAR(120) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    cedula VARCHAR(20),
    telefono VARCHAR(15),
    cargo VARCHAR(100),
    activo BOOLEAN DEFAULT TRUE,
    usuario_id BIGINT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL
);

-- Tabla de materias
CREATE TABLE materia (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    codigo VARCHAR(20) UNIQUE,
    especialidad VARCHAR(100),
    descripcion TEXT,
    profesor_id BIGINT,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (profesor_id) REFERENCES profesor(id) ON DELETE SET NULL
);

-- Tabla de recursos (archivos subidos por profesores)
CREATE TABLE recurso (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT,
    filename VARCHAR(255) NOT NULL,
    original_name VARCHAR(255) NOT NULL,
    content_type VARCHAR(100),
    size BIGINT,
    fecha_subida TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    materia_id BIGINT,
    profesor_id BIGINT,
    FOREIGN KEY (materia_id) REFERENCES materia(id) ON DELETE CASCADE,
    FOREIGN KEY (profesor_id) REFERENCES profesor(id) ON DELETE CASCADE
);

-- Tabla de biblioteca (recursos generales como libros, enlaces, etc.)
CREATE TABLE recursos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200),
    tipo VARCHAR(50),
    autor VARCHAR(150),
    enlace TEXT,
    descripcion TEXT
);

-- Tabla de comunicados
CREATE TABLE comunicado (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_publicacion TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,
    profesor_id BIGINT,
    FOREIGN KEY (profesor_id) REFERENCES profesor(id) ON DELETE SET NULL
);

-- Tabla de eventos de calendario
CREATE TABLE evento (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descripcion TEXT,
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME,
    todo_el_dia BOOLEAN DEFAULT FALSE,
    color VARCHAR(7) DEFAULT '#007bff',
    estado ENUM('PENDIENTE', 'COMPLETADO', 'CANCELADO') DEFAULT 'PENDIENTE',
    profesor_id BIGINT,
    FOREIGN KEY (profesor_id) REFERENCES profesor(id) ON DELETE SET NULL
);

-- Tabla de horarios
CREATE TABLE horario (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    dia_semana ENUM('LUNES', 'MARTES', 'MIÉRCOLES', 'JUEVES', 'VIERNES', 'SÁBADO', 'DOMINGO') NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    aula VARCHAR(20),
    materia_id BIGINT,
    profesor_id BIGINT,
    FOREIGN KEY (materia_id) REFERENCES materia(id) ON DELETE CASCADE,
    FOREIGN KEY (profesor_id) REFERENCES profesor(id) ON DELETE CASCADE
);

-- =====================================
-- INSERCIÓN DE DATOS DE PRUEBA
-- =====================================

-- Usuarios de prueba
INSERT INTO usuarios (username, email, password_hash, nombre, apellido, rol, activo) VALUES
-- Contraseña: secret (hash bcrypt)
('admin', 'admin@plataforma.edu', '$2a$10$YH9D2yf1XT7os0DIPpRWKeJsc0kmGDJ5QFWGjsdb0dA0s6UGjt7gq', 'Administrador', 'Sistema', 'ADMINISTRATIVO', TRUE),
('profesor', 'profesor@plataforma.edu', '$2a$10$YH9D2yf1XT7os0DIPpRWKeJsc0kmGDJ5QFWGjsdb0dA0s6UGjt7gq', 'Juan Carlos', 'Pérez', 'PROFESOR', TRUE),
('estudiante', 'estudiante@plataforma.edu', '$2a$10$YH9D2yf1XT7os0DIPpRWKeJsc0kmGDJ5QFWGjsdb0dA0s6UGjt7gq', 'María José', 'González', 'ESTUDIANTE', TRUE),
('profesor2', 'ana.lopez@plataforma.edu', '$2a$10$YH9D2yf1XT7os0DIPpRWKeJsc0kmGDJ5QFWGjsdb0dA0s6UGjt7gq', 'Ana María', 'López', 'PROFESOR', TRUE);

-- Profesores
INSERT INTO profesor (nombre, correo, password_hash, cedula, telefono, especialidad, activo, usuario_id) VALUES
('Juan Carlos Pérez', 'profesor@plataforma.edu', '$2a$10$YH9D2yf1XT7os0DIPpRWKeJsc0kmGDJ5QFWGjsdb0dA0s6UGjt7gq', '12345678', '88888888', 'Informática', TRUE, 2),
('Ana María López', 'ana.lopez@plataforma.edu', '$2a$10$YH9D2yf1XT7os0DIPpRWKeJsc0kmGDJ5QFWGjsdb0dA0s6UGjt7gq', '87654321', '77777777', 'Matemáticas', TRUE, 4);

-- Estudiantes
INSERT INTO estudiante (nombre, apellidos, correo, cedula, telefono, fecha_nacimiento, grado, seccion, activo, usuario_id) VALUES
('María José González', 'Rodríguez', 'estudiante@plataforma.edu', '11111111', '66666666', '2005-03-15', '11°', 'A', TRUE, 3),
('Carlos Eduardo', 'Martínez Silva', 'carlos.martinez@plataforma.edu', '22222222', '55555555', '2006-07-22', '10°', 'B', TRUE, NULL),
('Sofía Alejandra', 'Vargas Mora', 'sofia.vargas@plataforma.edu', '33333333', '44444444', '2005-11-08', '11°', 'A', TRUE, NULL);

-- Administrativos
INSERT INTO administrativo (nombre, correo, password_hash, cedula, telefono, cargo, activo, usuario_id) VALUES
('Administrador Sistema', 'admin@plataforma.edu', '$2a$10$YH9D2yf1XT7os0DIPpRWKeJsc0kmGDJ5QFWGjsdb0dA0s6UGjt7gq', '99999999', '99999999', 'Director de Sistemas', TRUE, 1);

-- Materias
INSERT INTO materia (nombre, codigo, especialidad, descripcion, profesor_id, activo) VALUES
('Programación Web', 'PRW-101', 'Desarrollo de Software', 'Materia para aprender desarrollo web con tecnologías modernas', 1, TRUE),
('Base de Datos', 'BD-201', 'Informática', 'Fundamentos de bases de datos relacionales y NoSQL', 1, TRUE),
('Matemática Avanzada', 'MAT-301', 'Matemáticas', 'Cálculo diferencial e integral aplicado', 2, TRUE),
('Álgebra Lineal', 'ALG-201', 'Matemáticas', 'Vectores, matrices y transformaciones lineales', 2, TRUE);

-- Recursos de biblioteca (enlaces y libros)
INSERT INTO recursos (titulo, tipo, autor, enlace, descripcion) VALUES
('Introducción a Java', 'LIBRO', 'Oracle Corporation', 'https://docs.oracle.com/javase/tutorial/', 'Tutorial oficial de Java de Oracle'),
('Spring Framework Documentation', 'ENLACE', 'Pivotal Software', 'https://spring.io/docs', 'Documentación oficial del framework Spring'),
('MySQL Reference Manual', 'ENLACE', 'Oracle Corporation', 'https://dev.mysql.com/doc/refman/8.0/en/', 'Manual de referencia completo de MySQL'),
('Programación en Python', 'LIBRO', 'Guido van Rossum', 'https://docs.python.org/3/', 'Documentación oficial de Python 3');

-- Comunicados de ejemplo
INSERT INTO comunicado (titulo, contenido, fecha_publicacion, activo, profesor_id) VALUES
('Bienvenida al nuevo período académico', 'Estimados estudiantes, les damos la bienvenida al nuevo período académico 2025. Este semestre tendremos nuevas materias y actividades emocionantes.', NOW(), TRUE, 1),
('Horarios de clases actualizados', 'Se han actualizado los horarios de las materias de programación. Por favor revisar el calendario para las nuevas fechas y horas.', NOW(), TRUE, 1),
('Examen de matemáticas', 'Recordatorio: El examen de matemática avanzada será el próximo viernes. Repasar los capítulos 1-5 del libro de texto.', NOW(), TRUE, 2);

-- Eventos de calendario
INSERT INTO evento (titulo, descripcion, fecha_inicio, fecha_fin, todo_el_dia, color, estado, profesor_id) VALUES
('Reunión de profesores', 'Reunión mensual del cuerpo docente', '2025-12-10 09:00:00', '2025-12-10 11:00:00', FALSE, '#28a745', 'PENDIENTE', NULL),
('Examen Programación Web', 'Evaluación final de la materia PRW-101', '2025-12-15 08:00:00', '2025-12-15 10:00:00', FALSE, '#dc3545', 'PENDIENTE', 1),
('Entrega de notas', 'Fecha límite para entrega de calificaciones', '2025-12-20 23:59:00', NULL, TRUE, '#ffc107', 'PENDIENTE', NULL),
('Clase de Matemáticas', 'Clase regular de matemática avanzada', '2025-12-08 10:00:00', '2025-12-08 11:30:00', FALSE, '#007bff', 'PENDIENTE', 2);

-- Horarios de ejemplo
INSERT INTO horario (dia_semana, hora_inicio, hora_fin, aula, materia_id, profesor_id) VALUES
('LUNES', '08:00:00', '09:30:00', 'LAB-A', 1, 1),
('LUNES', '10:00:00', '11:30:00', 'AULA-201', 3, 2),
('MARTES', '08:00:00', '09:30:00', 'LAB-B', 2, 1),
('MARTES', '10:00:00', '11:30:00', 'AULA-301', 4, 2),
('MIÉRCOLES', '08:00:00', '09:30:00', 'LAB-A', 1, 1),
('JUEVES', '10:00:00', '11:30:00', 'AULA-201', 3, 2),
('VIERNES', '08:00:00', '09:30:00', 'LAB-B', 2, 1);

-- =====================================
-- VERIFICACIÓN DE DATOS CREADOS
-- =====================================

-- Mostrar resumen de usuarios creados
SELECT '=== USUARIOS CREADOS ===' AS info;
SELECT id, username, email, CONCAT(nombre, ' ', apellido) AS nombre_completo, rol, activo 
FROM usuarios 
ORDER BY rol, nombre;

-- Mostrar profesores vinculados
SELECT '=== PROFESORES ===' AS info;
SELECT p.id, p.nombre, p.correo, p.especialidad, u.username AS usuario_vinculado
FROM profesor p 
LEFT JOIN usuarios u ON p.usuario_id = u.id
ORDER BY p.nombre;

-- Mostrar estudiantes
SELECT '=== ESTUDIANTES ===' AS info;
SELECT e.id, CONCAT(e.nombre, ' ', e.apellidos) AS nombre_completo, e.correo, e.grado, e.seccion
FROM estudiante e 
ORDER BY e.grado, e.seccion, e.nombre;

-- Mostrar materias con profesores
SELECT '=== MATERIAS ===' AS info;
SELECT m.id, m.nombre, m.codigo, m.especialidad, p.nombre AS profesor
FROM materia m 
LEFT JOIN profesor p ON m.profesor_id = p.id
ORDER BY m.nombre;

SELECT '=== CREDENCIALES DE ACCESO ===' AS info;
SELECT 
    'Todos los usuarios tienen la contraseña: secret' AS nota,
    'admin@plataforma.edu - Administrador' AS admin,
    'profesor@plataforma.edu - Profesor Juan Carlos' AS profesor1,
    'ana.lopez@plataforma.edu - Profesora Ana María' AS profesor2,
    'estudiante@plataforma.edu - Estudiante María José' AS estudiante;