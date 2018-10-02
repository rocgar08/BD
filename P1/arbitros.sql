DROP TABLE Personas CASCADE CONSTRAINTS;
DROP TABLE Arbitro CASCADE CONSTRAINTS;
DROP TABLE Entrenador CASCADE CONSTRAINTS;
DROP TABLE Equipo CASCADE CONSTRAINTS;
DROP TABLE Jugador CASCADE CONSTRAINTS;
DROP TABLE Partido CASCADE CONSTRAINTS;
DROP TABLE secundario CASCADE CONSTRAINTS;
DROP TABLE Acta CASCADE CONSTRAINTS;
DROP TABLE Incidencias CASCADE CONSTRAINTS;
DROP TABLE interv CASCADE CONSTRAINTS;

create table Personas(
  dni varchar2(10) Primary key,
  nombre varchar(50) not null
);

create table Arbitro(
  dniA varchar2(10),
  num_temp number(2),
  constraint Arl_FK foreign key(dniA) references Personas(dni)
);

create table Entrenador(
  dniE varchar2(10),
  constraint El_FK foreign key(dniE) references Personas(dni)
);

create table Equipo(
  NIF varchar2(10) Primary key,
  nombreE varchar2(50),
  presupuesto number(8),
  dniEnt varchar2(10),
  constraint Eq_FK foreign key(dniEnt) references Personas(dni)
);

create table Jugador(
  dniJ varchar2(10),
  dorsal number(2),
  ficha number(10),
  demarcacion varchar2(40),
  NIF_E varchar2(10),
  constraint Jl_FK foreign key(dniJ) references Personas(dni),
  constraint J2_FK foreign key(NIF_E) references Equipo(NIF)
);

create table Partido(
  jornada number(2) primary key,
  estadio varchar2(50),
  diaYhora date,
  NIF_Eq varchar2(10),
  dni_Ar varchar2(10),
  constraint Parl_FK foreign key(NIF_Eq) references Equipo(NIF),
  constraint Par2_FK foreign key(dni_Ar) references Personas(dni)
);

create table secundario(
  jornadaP number(2),
  dniArP varchar2(10),
  constraint secl_FK foreign key(jornadaP) references Partido(jornada),
  constraint sec2_FK foreign key(dniArP) references Personas(dni)
);

create table Acta(
  ident varchar2(7) primary key,
  dniArbi varchar2(10),
  jornadaPart number(2),
  constraint actl_FK foreign key(jornadaPart) references Partido(jornada),
  constraint act_FK foreign key(dniArbi) references Personas(dni)
);

create table Incidencias(
  idActa varchar2(7),
  tipo varchar2(30),
  explicacion varchar2(80),
  minuto number(3),
  constraint inc_FK foreign key(idActa) references Acta(ident)
);

create table interv(
  dniJug varchar2(10),
  id_Acta varchar2(7),
  sancion varchar2(10),
  constraint int1_FK foreign key(dniJug) references Personas(dni),
  constraint int2_FK foreign key(id_Acta) references Acta(ident)
);

--insert into  values();
--PERSONAS--
insert into Personas values('11111111A', 'David Perez Pallas');
insert into Personas values('22222222B','Alexandre Aleman Perez');
insert into Personas values('33333333C', 'Moises Mateo Montañes');
insert into Personas values('44444444D', 'Adrian Diaz Gonzalez');
insert into Personas values('55555555E', 'Juan Manuel Lopez Amaya');
insert into Personas values('66666666F', 'Ivan Gonzalez Gozalez');
insert into Personas values('77777777G','Jorge Figueroa Vazquez');

insert into Personas values('11111110A','Amancio Ortega');
insert into Personas values('22222221B','Fernando Torres');
insert into Personas values('33333332C','David Beckham');
insert into Personas values('44444443D','Luis Figo');
insert into Personas values('55555554E','Carles Puyol');
insert into Personas values('66666665E','Cristiano Ronaldo');
insert into Personas values('77777776G','Iker Casillas');

insert into Personas values('01111110A', 'Zinedine Zidane');
insert into Personas values('02222221B','Luis Enrique Martinez Garcia');
insert into Personas values('03333332C', 'Diego Simeone');

---ARBITROS---
insert into Arbitro values('111111111A', 10);
insert into Arbitro values('222222222B', 2);
insert into Arbitro values('333333333C', 5);
insert into Arbitro values('444444444D', 1);
insert into Arbitro values('555555555E', 23);
insert into Arbitro values('666666666F', 15);
insert into Arbitro values('777777777G', 3);

---JUGADORES--
insert into Jugador values('11111110A', 7,32000000,'Delantero','B84030576');
insert into Jugador values('22222221B', 19,6760000,'CentroCampista','B84030576');
insert into Jugador values('33333332C', 2,4000000,'Defensa','B84030576');
insert into Jugador values('44444443D', 3,5800000,'Defensa','G8266298');
insert into Jugador values('55555554E', 7,4000000,'CentroCampista','G8266298');
insert into Jugador values('66666665F', 19,1000000,'Defensa','A80373764');
insert into Jugador values('77777776G', 1,3500000,'Portero','A80373764');

--Entrenadores--
insert into Entrenador values('01111110A');
insert into Entrenador values('02222221B');
insert into Entrenador values('03333332C');

--Equipo--
insert into Equipo values('B84030576','Real Madrid C.F.',453000000,'01111110A');
insert into Equipo values('G8266298','F.C. Barcelona',157000000,'02222221B');
insert into Equipo values('A80373764','Atlético de Madrid',140000000,'03333332C');

--Partido--ojo hay que modificar la tabla para que acepte equipolocal y visitante
insert into Partido values(14,'Camp Nou','3/12/2016 16:15','G8266298','B84030576','11111111A');
insert into Partido values(11,'Vicente Calderón','A80373764','B84030576','66666666F');
insert into Partido values(11,'Ramón Sánchez Pizjuan','6/11/2016 20:45','A55662354','G8266298','33333333C');
insert into Partido values(24,'Vicente Calderón','25/02/2017 16:15','A80373764','G8266298','33333333C');
--insert into secundario values ('14',"111111111A");
