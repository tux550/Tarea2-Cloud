#!/bin/bash
psql -U postgres -d BOSTON < /docker-entrypoint-initdb.d/db.sql