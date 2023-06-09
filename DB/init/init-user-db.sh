#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE USER dockeruser WITH PASSWORD 'dockerpassword';
	CREATE DATABASE dockerdb;
	GRANT ALL PRIVILEGES ON DATABASE dockerdb TO dockeruser;
EOSQL

psql -v ON_ERROR_STOP=1 --username "dockeruser" --dbname "dockerdb" <<-EOSQL

DROP TABLE IF EXISTS "ListEntry";
DROP SEQUENCE IF EXISTS "ListEntry_ID_seq";

CREATE SEQUENCE "ListEntry_ID_seq";

CREATE TABLE "public"."ListEntry" (
    "ID" integer DEFAULT nextval('"ListEntry_ID_seq"') NOT NULL,
    "Title" text NOT NULL,
    "Description" text NOT NULL,
    "Deadline" timestamp NOT NULL,
    CONSTRAINT "ListEntry_pkey" PRIMARY KEY ("ID")
) WITH (oids = false);
EOSQL
