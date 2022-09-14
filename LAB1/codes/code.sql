
CREATE TABLE Admin
(
 "ID"   serial NOT NULL,
 Name varchar(50) NOT NULL,
 CONSTRAINT PK_122 PRIMARY KEY ( "ID" )
);





CREATE TABLE "User"
(
 "ID"      serial NOT NULL,
 Name    varchar(50) NOT NULL,
 Email   json NOT NULL,
 Phone   json NOT NULL,
 Address json NOT NULL,
 CONSTRAINT PK_5 PRIMARY KEY ( "ID" )
);




CREATE TABLE Employer
(
 "ID"               serial NOT NULL,
 Subscription_end date NOT NULL,
 "Seconder)ID"      serial NOT NULL,
 CONSTRAINT PK_40 PRIMARY KEY ( "ID" ),
 CONSTRAINT FK_126 FOREIGN KEY ( "Seconder)ID" ) REFERENCES Admin ( "ID" ),
 CONSTRAINT FK_12 FOREIGN KEY ( "ID" ) REFERENCES "User" ( "ID" )
);

CREATE INDEX fkIdx_128 ON Employer
(
 "Seconder)ID"
);

CREATE INDEX fkIdx_14 ON Employer
(
 "ID"
);




CREATE TABLE Representer
(
 Employer_ID serial NOT NULL,
 "ID"          serial NOT NULL,
 CONSTRAINT PK_131 PRIMARY KEY ( "ID" ),
 CONSTRAINT FK_43 FOREIGN KEY ( "ID" ) REFERENCES "User" ( "ID" ),
 CONSTRAINT FK_90 FOREIGN KEY ( Employer_ID ) REFERENCES Employer ( "ID" )
);

CREATE INDEX fkIdx_45 ON Representer
(
 "ID"
);

CREATE INDEX fkIdx_92 ON Representer
(
 Employer_ID
);



CREATE TABLE Worker
(
 "ID"         serial NOT NULL,
 Education  json NULL,
 Expertise  json NULL,
 Experience json NULL,
 CONSTRAINT PK_41 PRIMARY KEY ( "ID" ),
 CONSTRAINT FK_20 FOREIGN KEY ( "ID" ) REFERENCES "User" ( "ID" )
);

CREATE INDEX fkIdx_22 ON Worker
(
 "ID"
);



CREATE TABLE Job
(
 Employer_ID     serial NOT NULL,
 Title           varchar(50) NOT NULL,
 Priority        varchar(50) NOT NULL,
 Expiration_date date NOT NULL,
 Type            varchar(50) NOT NULL,
 Description     varchar(200) NOT NULL,
 Min_salary      integer NOT NULL,
 Min_experience  integer NOT NULL,
 Creation_date   date NOT NULL,
 Status          varchar(50) NOT NULL,
 Payment_code    varchar(50) NOT NULL,
 "ID"              uuid NOT NULL,
 CONSTRAINT PK_132 PRIMARY KEY ( "ID" ),
 CONSTRAINT FK_51 FOREIGN KEY ( Employer_ID ) REFERENCES Employer ( "ID" )
);

CREATE INDEX fkIdx_53 ON Job
(
 Employer_ID
);



CREATE TABLE Requests
(
 WorkerID    serial NOT NULL,
 JobID       uuid NOT NULL,
 "Date"        date NOT NULL,
 Description varchar(200) NOT NULL,
 Status      varchar(50) NOT NULL,
 CONSTRAINT PK_106 PRIMARY KEY ( WorkerID, JobID ),
 CONSTRAINT FK_103 FOREIGN KEY ( JobID ) REFERENCES Job ( "ID" ),
 CONSTRAINT FK_94 FOREIGN KEY ( WorkerID ) REFERENCES Worker ( "ID" )
);

CREATE INDEX fkIdx_105 ON Requests
(
 JobID
);

CREATE INDEX fkIdx_96 ON Requests
(
 WorkerID
);




CREATE TABLE SupportRequest
(
 "ID"          uuid NOT NULL,
 Title       varchar(50) NOT NULL,
 Replier_ID  serial NOT NULL,
 User_ID     serial NOT NULL,
 Description varchar(250) NOT NULL,
 "Date"        date NOT NULL,
 Reply       varchar(250) NOT NULL,
 CONSTRAINT PK_135 PRIMARY KEY ( "ID" ),
 CONSTRAINT FK_139 FOREIGN KEY ( User_ID ) REFERENCES "User" ( "ID" ),
 CONSTRAINT FK_142 FOREIGN KEY ( Replier_ID ) REFERENCES Admin ( "ID" )
);

CREATE INDEX fkIdx_141 ON SupportRequest
(
 User_ID
);

CREATE INDEX fkIdx_144 ON SupportRequest
(
 Replier_ID
);


CREATE TABLE Views
(
 JobID    uuid NOT NULL,
 WorkerID serial NOT NULL,
 CONSTRAINT PK_119 PRIMARY KEY ( JobID, WorkerID ),
 CONSTRAINT FK_111 FOREIGN KEY ( JobID ) REFERENCES Job ( "ID" ),
 CONSTRAINT FK_116 FOREIGN KEY ( WorkerID ) REFERENCES Worker ( "ID" )
);

CREATE INDEX fkIdx_113 ON Views
(
 JobID
);

CREATE INDEX fkIdx_118 ON Views
(
 WorkerID
);