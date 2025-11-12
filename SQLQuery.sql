CREATE DATABASE RANCHO_SAGRADO;
GO

USE RANCHO_SAGRADO;
GO


-- ============================================
-- TABLAS DE CLIENTE (3 tablas)
-- ============================================

-- Tabla CLIENTE_DIRECCION
CREATE TABLE CLIENTE_DIRECCION (
  IdDireccion INT IDENTITY PRIMARY KEY,
  Jiron VARCHAR(30),
  NumeroCasa INT,
  Lote INT,
  Manzana INT
);

-- Tabla CLIENTE
CREATE TABLE CLIENTE (
  IdCliente INT IDENTITY PRIMARY KEY,
  PrimerNombre VARCHAR(50) NOT NULL,
  SegundoNombre VARCHAR(50),
  ApellidoPaterno VARCHAR(50) NOT NULL,
  ApellidoMaterno VARCHAR(50) NOT NULL,
  FechaNacimiento DATE,
  DNI VARCHAR(8) UNIQUE,
  RUC VARCHAR(11) UNIQUE
);

-- Tabla CLIENTE_CONTACTO
CREATE TABLE CLIENTE_CONTACTO (
  IdContacto INT IDENTITY PRIMARY KEY,
  IdDireccion INT,
  IdCliente INT NOT NULL,
  Telefono VARCHAR(9),
  Email VARCHAR(100),
  FOREIGN KEY (IdDireccion) REFERENCES CLIENTE_DIRECCION(IdDireccion),
  FOREIGN KEY (IdCliente) REFERENCES CLIENTE(IdCliente)
);


-- ============================================
-- TABLAS DE EMPLEADO (5 tablas)
-- ============================================

-- Tabla DIRECCION (para empleados)
CREATE TABLE DIRECCION (
  IdDireccion INT IDENTITY PRIMARY KEY,
  Jiron VARCHAR(100),
  Manzana INT,
  NumeroCasa INT
);

-- Tabla CARGO
CREATE TABLE CARGO (
  IdCargo INT IDENTITY PRIMARY KEY,
  NombreCargo VARCHAR(50) NOT NULL UNIQUE,
  Salario VARCHAR(100)
);

-- Tabla EMPLEADO_CONTACTO
CREATE TABLE EMPLEADO_CONTACTO (
  IdEmpleadoContacto INT IDENTITY PRIMARY KEY,
  Telefono VARCHAR(9),
  Email VARCHAR(100)
);

-- Tabla EMPLEADO
CREATE TABLE EMPLEADO (
  IdEmpleado INT IDENTITY PRIMARY KEY,
  PrimerNombre VARCHAR(50) NOT NULL,
  SegundoNombre VARCHAR(50),
  ApellidoPaterno VARCHAR(50) NOT NULL,
  ApellidoMaterno VARCHAR(50) NOT NULL,
  Estado VARCHAR(15) DEFAULT 'Activo' CHECK(Estado IN ('Activo', 'Inactivo', 'Suspendido')),
  DNI VARCHAR(8) NOT NULL UNIQUE,
  IdDireccion INT,
  IdCargo INT NOT NULL,
  IdEmpleadoContacto INT,
  FOREIGN KEY (IdDireccion) REFERENCES DIRECCION(IdDireccion),
  FOREIGN KEY (IdCargo) REFERENCES CARGO(IdCargo),
  FOREIGN KEY (IdEmpleadoContacto) REFERENCES EMPLEADO_CONTACTO(IdEmpleadoContacto)
);

-- Tabla HISTORIAL_EMPLEADO
CREATE TABLE HISTORIAL_EMPLEADO (
  IdHistorial INT IDENTITY PRIMARY KEY,
  IdCargo INT NOT NULL,
  IdEmpleado INT NOT NULL,
  FechaIngreso DATE DEFAULT GETDATE(),
  FOREIGN KEY (IdCargo) REFERENCES CARGO(IdCargo),
  FOREIGN KEY (IdEmpleado) REFERENCES EMPLEADO(IdEmpleado)
);


-- ============================================
-- TABLAS DE CARTA Y PLATOS (4 tablas)
-- ============================================

-- Tabla CARTA
CREATE TABLE CARTA (
  IdCarta INT IDENTITY PRIMARY KEY,
  NombreCarta VARCHAR(100) NOT NULL,
  CantidadPlatos INT DEFAULT 0,
  Descripcion VARCHAR(100),
  Precio DECIMAL(8,2)
);

-- Tabla CATEGORIA
CREATE TABLE CATEGORIA (
  IdCategoria INT IDENTITY PRIMARY KEY,
  NombreCategoria VARCHAR(50) NOT NULL,
  Descripcion VARCHAR(100),
  IdCarta INT NOT NULL,
  FOREIGN KEY (IdCarta) REFERENCES CARTA(IdCarta)
);

-- Tabla PLATO_DETALLE
CREATE TABLE PLATO_DETALLE (
  IdPlatoDetalle INT IDENTITY PRIMARY KEY,
  Precio DECIMAL(5,2) NOT NULL CHECK(Precio > 0),
  Disponibilidad VARCHAR(20) DEFAULT 'Disponible' CHECK(Disponibilidad IN ('Disponible', 'Agotado', 'Suspendido'))
);

-- Tabla PLATO
CREATE TABLE PLATO (
  IdPlato INT IDENTITY PRIMARY KEY,
  NombrePlato VARCHAR(100) NOT NULL,
  Descripcion VARCHAR(255),
  TiempoPreparacion INT CHECK(TiempoPreparacion > 0),
  Precio DECIMAL(5,2) NOT NULL CHECK(Precio > 0),
  Disponibilidad VARCHAR(20) DEFAULT 'Disponible' CHECK(Disponibilidad IN ('Disponible', 'Agotado', 'Suspendido')),
  IdCategoria INT NOT NULL,
  IdPlatoDetalle INT,
  FOREIGN KEY (IdCategoria) REFERENCES CATEGORIA(IdCategoria),
  FOREIGN KEY (IdPlatoDetalle) REFERENCES PLATO_DETALLE(IdPlatoDetalle)
);


-- ============================================
-- TABLAS DE PROVEEDOR (5 tablas)
-- ============================================

-- Tabla UBICACION (para proveedores)
CREATE TABLE UBICACION (
  IdUbicacion INT IDENTITY PRIMARY KEY,
  Distrito VARCHAR(50),
  Provincia VARCHAR(50),
  Region VARCHAR(50)
);

-- Tabla DIRECCION_PROVEEDOR
CREATE TABLE DIRECCION_PROVEEDOR (
  IdDireccion INT IDENTITY PRIMARY KEY,
  Jiron VARCHAR(50),
  Manzana VARCHAR(50),
  Lote VARCHAR(50),
  IdUbicacion INT,
  FOREIGN KEY (IdUbicacion) REFERENCES UBICACION(IdUbicacion)
);

-- Tabla TIPO_SUMINISTRO
CREATE TABLE TIPO_SUMINISTRO (
  IdTipoSuministro INT IDENTITY PRIMARY KEY,
  Descripcion VARCHAR(200) NOT NULL
);

-- Tabla PROVEEDOR_CONTACTO
CREATE TABLE PROVEEDOR_CONTACTO (
  IdContacto INT IDENTITY PRIMARY KEY,
  Telefono VARCHAR(9),
  EmailContacto VARCHAR(50)
);

-- Tabla PROVEEDOR
CREATE TABLE PROVEEDOR (
  IdProveedor INT IDENTITY PRIMARY KEY,
  NombreEmpresa VARCHAR(50) NOT NULL,
  RUC VARCHAR(11) NOT NULL UNIQUE,
  Estado VARCHAR(50) DEFAULT 'Activo' CHECK(Estado IN ('Activo', 'Inactivo')),
  IdDireccion INT,
  IdTipoSuministro INT NOT NULL,
  IdContacto INT,
  FOREIGN KEY (IdDireccion) REFERENCES DIRECCION_PROVEEDOR(IdDireccion),
  FOREIGN KEY (IdTipoSuministro) REFERENCES TIPO_SUMINISTRO(IdTipoSuministro),
  FOREIGN KEY (IdContacto) REFERENCES PROVEEDOR_CONTACTO(IdContacto)
);


-- ============================================
-- TABLAS DE MESA (2 tablas)
-- ============================================

-- Tabla UBICACION_MESA
CREATE TABLE UBICACION_MESA (
  IdUbicacion INT IDENTITY PRIMARY KEY,
  NombreUbicacion VARCHAR(50) NOT NULL
);

-- Tabla MESA
CREATE TABLE MESA (
  IdMesa INT IDENTITY PRIMARY KEY,
  Capacidad INT NOT NULL CHECK(Capacidad > 0),
  NumeroMesa INT NOT NULL UNIQUE,
  Estado VARCHAR(20) DEFAULT 'Disponible' CHECK(Estado IN ('Disponible', 'Ocupada', 'Reservada')),
  IdUbicacion INT,
  FOREIGN KEY (IdUbicacion) REFERENCES UBICACION_MESA(IdUbicacion)
);


-- ============================================
-- TABLA DE RESERVACION (1 tabla)
-- ============================================

-- Tabla RESERVACION
CREATE TABLE RESERVACION (
  IdReservacion INT IDENTITY PRIMARY KEY,
  Fecha DATETIME NOT NULL,
  Hora TIME NOT NULL,
  NumeroPersonas INT NOT NULL CHECK(NumeroPersonas > 0),
  OcasionEspecial VARCHAR(100),
  EstadoReservacion VARCHAR(20) DEFAULT 'Pendiente' CHECK(EstadoReservacion IN ('Pendiente', 'Confirmada', 'Cancelada', 'Completada')),
  IdCliente INT NOT NULL,
  IdMesa INT NOT NULL,
  FOREIGN KEY (IdCliente) REFERENCES CLIENTE(IdCliente),
  FOREIGN KEY (IdMesa) REFERENCES MESA(IdMesa)
);


-- ============================================
-- TABLAS DE PEDIDO (2 tablas)
-- ============================================

-- Tabla PEDIDO
CREATE TABLE PEDIDO (
  IdPedido INT IDENTITY PRIMARY KEY,
  FechaPedido DATE DEFAULT GETDATE(),
  HoraPedido TIME DEFAULT CONVERT(TIME, GETDATE()),
  EstadoPedido VARCHAR(20) DEFAULT 'Pendiente' CHECK(EstadoPedido IN ('Pendiente', 'En Preparacion', 'Servido', 'Pagado', 'Cancelado')),
  IdCliente INT NOT NULL,
  IdMesa INT NOT NULL,
  IdEmpleado INT NOT NULL,
  FOREIGN KEY (IdCliente) REFERENCES CLIENTE(IdCliente),
  FOREIGN KEY (IdMesa) REFERENCES MESA(IdMesa),
  FOREIGN KEY (IdEmpleado) REFERENCES EMPLEADO(IdEmpleado)
);

-- Tabla DETALLE_PEDIDO
CREATE TABLE DETALLE_PEDIDO (
  IdDetallePedido INT IDENTITY PRIMARY KEY,
  Cantidad INT NOT NULL CHECK(Cantidad > 0),
  PrecioUnitario DECIMAL(8,2) NOT NULL CHECK(PrecioUnitario > 0),
  Observaciones VARCHAR(200),
  IdPedido INT NOT NULL,
  IdPlato INT NOT NULL,
  FOREIGN KEY (IdPedido) REFERENCES PEDIDO(IdPedido),
  FOREIGN KEY (IdPlato) REFERENCES PLATO(IdPlato)
);


-- ============================================
-- TABLAS DE COMPROBANTE Y PAGO (4 tablas)
-- ============================================

-- Tabla COMPROBANTE_PAGO
CREATE TABLE COMPROBANTE_PAGO (
  IdComprobante INT IDENTITY PRIMARY KEY,
  IdPedido INT NOT NULL UNIQUE,
  TipoComprobante VARCHAR(30) NOT NULL CHECK(TipoComprobante IN ('Boleta', 'Factura')),
  Serie VARCHAR(10) NOT NULL,
  FechaEmision DATETIME DEFAULT GETDATE(),
  SubTotal DECIMAL(10,2) NOT NULL CHECK(SubTotal >= 0),
  IGV DECIMAL(10,2) DEFAULT 0 CHECK(IGV >= 0),
  MontoTotal DECIMAL(10,2) NOT NULL CHECK(MontoTotal > 0),
  EstadoComprobante VARCHAR(30) DEFAULT 'Emitido' CHECK(EstadoComprobante IN ('Emitido', 'Anulado')),
  FOREIGN KEY (IdPedido) REFERENCES PEDIDO(IdPedido)
);

-- Tabla DETALLE_FACTURACION_CLIENTE
CREATE TABLE DETALLE_FACTURACION_CLIENTE (
  IdCliente INT PRIMARY KEY,
  RazonSocial VARCHAR(200),
  RUC VARCHAR(11),
  DireccionFiscal VARCHAR(200),
  FOREIGN KEY (IdCliente) REFERENCES CLIENTE(IdCliente)
);

-- Tabla PAGO
CREATE TABLE PAGO (
  IdPago INT IDENTITY PRIMARY KEY,
  FechaHoraPago DATETIME DEFAULT GETDATE(),
  Monto DECIMAL(10,2) NOT NULL CHECK(Monto > 0),
  MetodoPago VARCHAR(50) NOT NULL CHECK(MetodoPago IN ('Efectivo', 'Tarjeta Debito', 'Tarjeta Credito', 'Yape', 'Plin', 'Transferencia')),
  IdPedido INT NOT NULL,
  FOREIGN KEY (IdPedido) REFERENCES PEDIDO(IdPedido)
);

-- Tabla PAGO_TARJETA
CREATE TABLE PAGO_TARJETA (
  IdPagoTarjeta INT IDENTITY PRIMARY KEY,
  IdPago INT NOT NULL UNIQUE,
  TipoTarjeta VARCHAR(30),
  NumeroTarjeta VARCHAR(4),
  FOREIGN KEY (IdPago) REFERENCES PAGO(IdPago)
);


-- ============================================
-- TABLAS DE INGREDIENTE E INVENTARIO (2 tablas)
-- ============================================

-- Tabla INGREDIENTE
CREATE TABLE INGREDIENTE (
  IdIngrediente INT IDENTITY PRIMARY KEY,
  NombreIngrediente VARCHAR(100) NOT NULL,
  UnidadMedida VARCHAR(20) NOT NULL,
  Descripcion VARCHAR(100),
  CostoUnitario DECIMAL(10,2) CHECK(CostoUnitario >= 0),
  CategoriaIngrediente VARCHAR(50)
);

-- Tabla INVENTARIO
CREATE TABLE INVENTARIO (
  IdInventario INT IDENTITY PRIMARY KEY,
  CantidadStock INT NOT NULL CHECK(CantidadStock >= 0),
  FechaUltimaReposicion DATE DEFAULT GETDATE(),
  StockMinimo INT NOT NULL CHECK(StockMinimo >= 0),
  FechaVencimiento DATE,
  IdIngrediente INT NOT NULL,
  FOREIGN KEY (IdIngrediente) REFERENCES INGREDIENTE(IdIngrediente)
);


-- ============================================
-- TABLA DE TURNO (1 tabla)
-- ============================================

-- Tabla TURNO
CREATE TABLE TURNO (
  IdTurno INT IDENTITY PRIMARY KEY,
  NombreTurno VARCHAR(100) NOT NULL,
  HoraInicio TIME NOT NULL,
  HoraFin TIME NOT NULL,
  DiaSemana VARCHAR(15) NOT NULL
);


-- ============================================
-- TABLAS DE CONTRATO (2 tablas)
-- ============================================

-- Tabla CONTRATO
CREATE TABLE CONTRATO (
  IdContrato INT IDENTITY PRIMARY KEY,
  FechaInicio DATE NOT NULL,
  FechaFin DATE,
  TipoContrato VARCHAR(50) NOT NULL CHECK(TipoContrato IN ('Indefinido', 'Temporal', 'Servicios')),
  Salario DECIMAL(10,2) CHECK(Salario > 0),
  EstadoContrato VARCHAR(50) DEFAULT 'Vigente' CHECK(EstadoContrato IN ('Vigente', 'Finalizado', 'Suspendido')),
  IdEmpleado INT,
  IdProveedor INT,
  FOREIGN KEY (IdEmpleado) REFERENCES EMPLEADO(IdEmpleado),
  FOREIGN KEY (IdProveedor) REFERENCES PROVEEDOR(IdProveedor),
  CHECK ((IdEmpleado IS NOT NULL AND IdProveedor IS NULL) OR (IdEmpleado IS NULL AND IdProveedor IS NOT NULL))
);

-- Tabla CONTRATO_CLAUSULA
CREATE TABLE CONTRATO_CLAUSULA (
  IdContratoClausula INT IDENTITY PRIMARY KEY,
  IdContrato INT NOT NULL,
  DescripcionClausula VARCHAR(500),
  FOREIGN KEY (IdContrato) REFERENCES CONTRATO(IdContrato)
);


-- ============================================
-- TABLAS INTERMEDIAS (RELACIONES N:M) - 3 tablas
-- ============================================

-- Tabla EMPLEADO_TURNO
CREATE TABLE EMPLEADO_TURNO (
  IdEmpleadoTurno INT IDENTITY PRIMARY KEY,
  IdEmpleado INT NOT NULL,
  IdTurno INT NOT NULL,
  FechaAsignacion DATE DEFAULT GETDATE(),
  FOREIGN KEY (IdEmpleado) REFERENCES EMPLEADO(IdEmpleado),
  FOREIGN KEY (IdTurno) REFERENCES TURNO(IdTurno),
  UNIQUE(IdEmpleado, IdTurno)
);

-- Tabla PLATO_INGREDIENTE
CREATE TABLE PLATO_INGREDIENTE (
  IdPlatoIngrediente INT IDENTITY PRIMARY KEY,
  IdPlato INT NOT NULL,
  IdIngrediente INT NOT NULL,
  CantidadNecesaria DECIMAL(10,2) NOT NULL CHECK(CantidadNecesaria > 0),
  FOREIGN KEY (IdPlato) REFERENCES PLATO(IdPlato),
  FOREIGN KEY (IdIngrediente) REFERENCES INGREDIENTE(IdIngrediente),
  UNIQUE(IdPlato, IdIngrediente)
);

-- Tabla PROVEEDOR_INGREDIENTE
CREATE TABLE PROVEEDOR_INGREDIENTE (
  IdProveedorIngrediente INT IDENTITY PRIMARY KEY,
  IdProveedor INT NOT NULL,
  IdIngrediente INT NOT NULL,
  PrecioCompra DECIMAL(10,2) CHECK(PrecioCompra > 0),
  FechaUltimaCompra DATE,
  FOREIGN KEY (IdProveedor) REFERENCES PROVEEDOR(IdProveedor),
  FOREIGN KEY (IdIngrediente) REFERENCES INGREDIENTE(IdIngrediente),
  UNIQUE(IdProveedor, IdIngrediente)
);

GO







-- SEGURIDAD POR ROLES 

-- db_owner para Gerente (control total)
-- db_datareader + GRANT mínimo para otros roles

USE RANCHO_SAGRADO;
GO


-- 1. GERENTE/ADMINISTRADOR 

CREATE LOGIN login_gerente WITH PASSWORD = 'TempPass_Gerente_2025';
CREATE USER user_gerente FOR LOGIN login_gerente;
ALTER ROLE db_owner ADD MEMBER user_gerente;
GO


-- 2. CAJERO (Procesamiento de Pagos)

CREATE LOGIN login_cajero WITH PASSWORD = 'TempPass_Cajero_2025';
CREATE USER user_cajero FOR LOGIN login_cajero;

-- Base: lectura en todo
ALTER ROLE db_datareader ADD MEMBER user_cajero;

-- Permisos específicos para RF-03 (Facturación) y RF-01 (Pedidos)
GRANT INSERT, SELECT ON COMPROBANTE_PAGO TO user_cajero;
GRANT INSERT, SELECT ON PAGO TO user_cajero;
GRANT UPDATE ON PEDIDO TO user_cajero;  -- Cambiar estado a "Pagado"
GRANT UPDATE ON MESA TO user_cajero;     -- Cambiar estado a "Disponible"
GO


-- 3. MESERO (Toma de Pedidos y Reservas)

CREATE LOGIN login_mesero WITH PASSWORD = 'TempPass_Mesero_2025';
CREATE USER user_mesero FOR LOGIN login_mesero;

-- Base: lectura en todo
ALTER ROLE db_datareader ADD MEMBER user_mesero;

-- Permisos específicos para RF-01, RF-06, RF-07
GRANT INSERT ON PEDIDO TO user_mesero;
GRANT INSERT ON RESERVACION TO user_mesero;
GRANT UPDATE ON MESA TO user_mesero; -- Cambiar estado a "Ocupada" o "Reservada"
GO


-- 4. CHEF/COCINA (Gestión de Cocina e Inventario)

CREATE LOGIN login_chef WITH PASSWORD = 'TempPass_Chef_2025';
CREATE USER user_chef FOR LOGIN login_chef;

-- Base: lectura en todo
ALTER ROLE db_datareader ADD MEMBER user_chef;

-- Permisos específicos para RF-04 (Inventario)
GRANT UPDATE ON INVENTARIO TO user_chef;  -- Descontar stock
GRANT UPDATE ON INGREDIENTE TO user_chef; -- Registrar entradas
GO
