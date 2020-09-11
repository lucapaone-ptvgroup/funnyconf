CREATE OR REPLACE VIEW public.alerts_view
 AS
 WITH rkpi_cut AS (
         SELECT rkpi_1.simu,
            rkpi_1.valu,
            rkpi_1.valn,
            rkpi_1.kpi_id,
            rkpi_1.start_time
           FROM rkpi rkpi_1
          WHERE rkpi_1.start_time >= (now() - '01:00:00'::interval)
        )
 SELECT DISTINCT ON (rkpi.kpi_id) rkpi.valu,
    rkpi.kpi_id,
    rkpi.start_time,
    kpi_instance.name,
    kpi_instance.improving_direction,
    kpi_instance.quality_threshold,
    btrim(split_part(kpi_instance.quality_threshold::text, ','::text, 1))::double precision AS low_field,
    btrim(split_part(kpi_instance.quality_threshold::text, ','::text, 2))::double precision AS high_field,
        CASE
            WHEN kpi_instance.improving_direction::text = 'DECREASING'::text THEN btrim(split_part(kpi_instance.quality_threshold::text, ','::text, 2))::double precision
            WHEN kpi_instance.improving_direction::text = 'INCREASING'::text THEN btrim(split_part(kpi_instance.quality_threshold::text, ','::text, 1))::double precision
            ELSE NULL::double precision
        END AS alert_th,
        CASE
            WHEN kpi_instance.improving_direction::text = 'DECREASING'::text THEN rkpi.valu > btrim(split_part(kpi_instance.quality_threshold::text, ','::text, 2))::double precision
            WHEN kpi_instance.improving_direction::text = 'INCREASING'::text THEN rkpi.valu < btrim(split_part(kpi_instance.quality_threshold::text, ','::text, 1))::double precision
            ELSE NULL::boolean
        END AS alert_active
   FROM rkpi_cut rkpi,
    kpi_instance
  WHERE rkpi.kpi_id = kpi_instance.id AND kpi_instance.quality_threshold IS NOT NULL AND rkpi.valu IS NOT NULL
  ORDER BY rkpi.kpi_id, rkpi.start_time DESC;

ALTER TABLE public.alerts_view
    OWNER TO postgres;

