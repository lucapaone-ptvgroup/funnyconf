CREATE TABLE public.alert_list
(
    version integer,
    "groupKey" text COLLATE pg_catalog."default",
    "truncatedAlerts" text COLLATE pg_catalog."default",
    status text COLLATE pg_catalog."default",
    receiver text COLLATE pg_catalog."default",
    "groupLabels" json,
    "commonLabels" json,
    "commonAnnotations" json,
    "externalURL" text COLLATE pg_catalog."default",
    alerts json[],
    receivedattime timestamp with time zone DEFAULT now()
)
WITH (
    OIDS = FALSE
)


