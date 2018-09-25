CREATE OR REPLACE VIEW material_info_view AS
SELECT material.id AS id, 
(SELECT material_key.material_key from material_key WHERE material_key.material_id = material.id) AS material_key, 
(SELECT
  GROUP_CONCAT(author.name SEPARATOR ', ') 
FROM material m1, material_has_author, author
    WHERE material_has_author.material_id = m1.id
    AND author.id = material_has_author.author_id
 AND m1.id = material.id
GROUP BY material.id) AS `Authors`,
(SELECT quality_assesment.quality_index from quality_assesment WHERE quality_assesment.material_id = material.id) AS quality_index, 
(SELECT quality_assesment.quality_index_comment from quality_assesment WHERE quality_assesment.material_id = material.id) AS quality_index_comment, 
(SELECT quality_assesment.risk_level from quality_assesment WHERE quality_assesment.material_id = material.id) AS risk_level, 
(SELECT quality_assesment.risk_level_comment from quality_assesment WHERE quality_assesment.material_id = material.id) AS risk_level_comment, 
(SELECT quality_assesment.actual_review_type from quality_assesment WHERE quality_assesment.material_id = material.id) AS actual_review_type, 
material.title AS title, 
material.year AS year, 
(SELECT review_type.name from review_type WHERE review_type.id = material.review_type_id) AS review_type, 
material.main_topic AS main_topic, 
material.geographic_focus AS georaphically_focussed, 
material.prisma_diagram_used AS prisma_diagram_used, 
material.timeframe_from AS study_focus_starts, 
material.timeframe_to AS study_focus_ends, 
material.screening_criteria AS screening_criteria, 
material.search_string AS search_string, 
material.no_of_original_sources AS number_of_original_sources, 
(SELECT synthesis_method.description from synthesis_method WHERE synthesis_method.id = material.systhesis_method_id) AS synthesis_method, 
material.quantitative_map AS quantitative_map_included,
material.conclusions AS comclusions, 
material.conflict_of_interest AS conflicts_of_interest, 
material.comments AS comments, 
(SELECT scale.description from scale WHERE scale.id = material.scale_id) AS scale, 
(SELECT material_type.description from material_type WHERE material_type.id = material.material_type_id) AS material_type,
(SELECT material_category.description from material_category, material_type WHERE material_category.id = material_type.material_category_id AND material_type.id = material.material_type_id) as material_category,
(SELECT additional_material_information.language FROM additional_material_information WHERE additional_material_information.material_id = material.id) AS language,
(SELECT additional_material_information.chapter_or_part FROM additional_material_information WHERE additional_material_information.material_id = material.id) AS chapter_or_part,
(SELECT additional_material_information.conference_date FROM additional_material_information WHERE additional_material_information.material_id = material.id) AS conference_date,
(SELECT additional_material_information.conference_place FROM additional_material_information WHERE additional_material_information.material_id = material.id) AS conference_venue,
(SELECT additional_material_information.date_published FROM additional_material_information WHERE additional_material_information.material_id = material.id) AS published_date,
(SELECT additional_material_information.edition FROM additional_material_information WHERE additional_material_information.material_id = material.id) AS edition,
(SELECT additional_material_information.issue FROM additional_material_information WHERE additional_material_information.material_id = material.id) AS issue,
(SELECT additional_material_information.journal_name FROM additional_material_information WHERE additional_material_information.material_id = material.id) AS journal,
(SELECT additional_material_information.pagination FROM additional_material_information WHERE additional_material_information.material_id = material.id) AS pagination,
(SELECT additional_material_information.peer_reviewed FROM additional_material_information WHERE additional_material_information.material_id = material.id) AS peer_reviewed,
(SELECT additional_material_information.publication_place FROM additional_material_information WHERE additional_material_information.material_id = material.id) AS publication_place,
(SELECT additional_material_information.publisher_name FROM additional_material_information WHERE additional_material_information.material_id = material.id) AS publisher,
(SELECT additional_material_information.school_or_department_or_centre FROM additional_material_information WHERE additional_material_information.material_id = material.id) AS school_department_or_centre,
(SELECT additional_material_information.series_sort_no FROM additional_material_information WHERE additional_material_information.material_id = material.id) AS series_sort_no,
(SELECT additional_material_information.series_title FROM additional_material_information WHERE additional_material_information.material_id = material.id) AS series_title,
(SELECT additional_material_information.series_volume_no FROM additional_material_information WHERE additional_material_information.material_id = material.id) AS series_volume_no,
(SELECT additional_material_information.volume FROM additional_material_information WHERE additional_material_information.material_id = material.id) AS volume,
(SELECT additional_material_information.website_owner FROM additional_material_information WHERE additional_material_information.material_id = material.id) AS website_owner
FROM material;

CREATE OR REPLACE VIEW author_join AS
SELECT material_has_author.material_id, material_has_author.author_id, material_has_author.primary_author, organisation_has_author.organisation_id
FROM  material_has_author JOIN organisation_has_author ON material_has_author.author_id = organisation_has_author.author_id;

CREATE OR REPLACE VIEW authors_of_material AS
SELECT material_id, primary_author as first_author,
(SELECT author.name from author WHERE author.id = author_id) AS name,
(SELECT author.email from author WHERE author.id = author_id) AS email,
(SELECT organisation.name FROM organisation  WHERE organisation.id = organisation_id) AS organisation,
(SELECT organisation.address FROM organisation WHERE organisation.id = organisation_id) AS address,
(SELECT country.name FROM country, organisation WHERE country.id = organisation.country_id AND organisation.id = organisation_id ) AS country
FROM  author_join 
ORDER BY author_id;


SELECT material_id,
(SELECT author.name from author WHERE author.id = author_id) AS name,
(SELECT author.email from author WHERE author.id = author_id) AS email,
(SELECT organisation.name FROM organisation  WHERE organisation.id = organisation_id) AS organisation,
(SELECT organisation.address FROM organisation WHERE organisation.id = organisation_id) AS address,
(SELECT country.name FROM country, organisation WHERE country.id = organisation.country_id AND organisation.id = organisation_id ) AS country

FROM  material_has_author JOIN organisation_has_author ON material_has_author.author_id = organisation_has_author.author_id




CREATE OR REPLACE VIEW funding_sources_of_material AS
SELECT material_has_funding_source.material_id AS material_id,
(SELECT funding_source.funding_source_name from funding_source WHERE funding_source.id = material_has_funding_source.funding_source_id) AS funding_source,
(SELECT funding_source.address from funding_source WHERE funding_source.id = material_has_funding_source.funding_source_id) AS address,
(SELECT country.name from country, funding_source WHERE country.id = funding_source.country_id AND funding_source.id = material_has_funding_source.funding_source_id) AS country,
material_has_funding_source.funded_year, 
material_has_funding_source.comments AS comments
FROM material_has_funding_source;

CREATE OR REPLACE VIEW search_sources_of_material AS
SELECT material_has_search_source.material_id AS material_id, 
(SELECT search_source.source_name from search_source WHERE search_source.id = material_has_search_source.search_source_id) AS sarch_source_name,
(SELECT search_source.weblink from search_source WHERE search_source.id = material_has_search_source.search_source_id) AS weblink,
(SELECT search_source.source_type from search_source WHERE search_source.id = material_has_search_source.search_source_id) AS source_type,
(SELECT search_source.comments from search_source WHERE search_source.id = material_has_search_source.search_source_id) AS comments
FROM material_has_search_source
;

CREATE OR REPLACE VIEW built_environment_types_of_material AS
SELECT material_has_built_environment_type.material_id AS material_id, 
(SELECT built_environment_type.description from built_environment_type WHERE built_environment_type.id = material_has_built_environment_type.built_environment_type_id) AS built_environment_type
FROM material_has_built_environment_type;

CREATE OR REPLACE VIEW keywords_of_material AS
SELECT material_has_keyword.material_id as material_id,
(SELECT keyword.description FROM keyword WHERE keyword.id = material_has_keyword.key_word_id) as keyword
FROM material_has_keyword
ORDER BY keyword ASC;

CREATE OR REPLACE VIEW copyrights_of_material AS
SELECT material_has_copyright.material_id AS material_id,
(SELECT copyright_type.description FROM copyright_type WHERE copyright_type.id = material_has_copyright.copyright_id) AS copyright
FROM material_has_copyright
;

CREATE OR REPLACE VIEW applications_of_material AS
SELECT material_has_application.material_id AS material_id, 
(SELECT application.description FROM application WHERE application.id = material_has_application.application_id) as application
FROM material_has_application
;

CREATE OR REPLACE VIEW identifiers_of_material AS
SELECT material_has_identifier.material_id AS material_id,
(SELECT identifier_type.description from identifier_type WHERE identifier_type.id = material_has_identifier.identifier_type_id) as identifier_type,
material_has_identifier.identification as identification
FROM material_has_identifier
;

CREATE OR REPLACE VIEW subjects_of_material AS
SELECT material_has_subject.material_id AS material_id,
(SELECT subject.description FROM subject WHERE subject.id = material_has_subject.subject_id) as subject
FROM material_has_subject
;

CREATE OR REPLACE VIEW built_environment_scale_of_material AS
SELECT material_has_built_environment_scale.material_id AS material_id,
(SELECT built_environment_scale.description FROM built_environment_scale WHERE built_environment_scale.id = material_has_built_environment_scale.built_environment_scale_id) as built_environment_scale
FROM material_has_built_environment_scale
;

CREATE OR REPLACE VIEW subjects_areas_of_material AS
SELECT material_has_subject_area.material_id AS material_id,
(SELECT subject_area.description FROM subject_area WHERE subject_area.id = material_has_subject_area.subject_area_id) as subject_area
FROM material_has_subject_area
;

CREATE OR REPLACE VIEW systems_of_material AS
SELECT material_has_systems.material_id AS material_id,
(SELECT systems.description FROM systems WHERE systems.id = material_has_systems.systems_id) as systems
FROM material_has_systems
;

CREATE OR REPLACE VIEW license_of_material AS
SELECT material_has_licence.material_id AS material_id,
(SELECT license_type.description FROM license_type WHERE license_type.id = material_has_licence.licence_type_id) as license_type,
material_has_licence.licence_no AS license_no
FROM material_has_licence
;

CREATE OR REPLACE VIEW subjects_vs_bets AS
SELECT ms.material_id, ms.subject_id, mb.built_environment_type_id
FROM material_has_subject ms, material_has_built_environment_type mb
WHERE mb.material_id = ms.material_id;


CREATE OR REPLACE VIEW applications_vs_bets AS
SELECT ma.material_id, ma.application_id, mb.built_environment_type_id
FROM material_has_application ma, material_has_built_environment_type mb
WHERE mb.material_id = ma.material_id;

CREATE OR REPLACE VIEW applications_vs_subjects AS
SELECT ma.material_id, ma.application_id, ms.subject_id
FROM material_has_application ma, material_has_subject ms
WHERE ms.material_id = ma.material_id;

CREATE OR REPLACE VIEW subject_area_vs_built_environment_scale AS
SELECT sa.material_id, sa.subject_area_id, bes.built_environment_scale_id
FROM material_has_subject_area sa, material_has_built_environment_scale bes
WHERE sa.material_id = bes.material_id;

CREATE OR REPLACE VIEW subject_area_vs_application AS
SELECT sa.material_id, sa.subject_area_id, a.application_id
FROM material_has_subject_area sa, material_has_application a
WHERE sa.material_id = a.material_id;

CREATE OR REPLACE VIEW bet_scale_vs_application AS
SELECT bes.material_id, bes.built_environment_scale_id, a.application_id
FROM material_has_built_environment_scale bes, material_has_application a
WHERE bes.material_id = a.material_id;


CREATE OR REPLACE VIEW countries_of_first_authors AS
SELECT c.name as country, c.code as country_code, count(*) as number_of_articles
FROM material_has_author ma, organisation_has_author oa, organisation o, country c, author a
WHERE ma.primary_author = 1
AND ma.author_id = a.id
AND a.id = oa.author_id
AND o.id = oa.organisation_id
AND o.country_id = c.id
GROUP BY c.name
ORDER BY c.name;



CREATE OR REPLACE VIEW countries_of_organisations AS
SELECT c.name as country, c.code as country_code, count(*) as number_of_organisations
FROM organisation o, country c
WHERE o.country_id = c.id
GROUP BY c.name
ORDER BY c.name;


CREATE OR REPLACE VIEW articles_by_year AS
SELECT material.year as year, count(*) as articles 
FROM material
GROUP BY year;

CREATE OR REPLACE VIEW search_source_usage AS
SELECT ss.source_name as source_name, ss.weblink AS weblink, ss.source_type AS source_type, ss.comments AS comments, count(*) as percentage_usage
FROM material_has_search_source mhs, search_source ss
WHERE mhs.search_source_id = ss.id
GROUP BY source_name, weblink, source_type, comments
ORDER BY percentage_usage DESC
LIMIT 10;


CREATE OR REPLACE VIEW search_sources_per_paper AS
SELECT m.id, count(*) as search_sources
FROM material m, material_has_search_source mhs
WHERE m.id = mhs.material_id
GROUP BY material_id;

CREATE OR REPLACE VIEW top_built_environments AS
SELECT built_environment_type, count(*) AS articles
FROM built_environment_types_of_material
GROUP BY built_environment_type
ORDER BY articles DESC
LIMIT 10;

CREATE OR REPLACE VIEW top_subjects AS
SELECT subject, count(*) AS articles
FROM subjects_of_material
GROUP BY subject
ORDER BY articles DESC
LIMIT 10;

CREATE OR REPLACE VIEW top_applications AS
SELECT application, count(*) AS articles
FROM applications_of_material
GROUP BY application
ORDER BY articles DESC
LIMIT 10;

CREATE OR REPLACE VIEW top_systems AS
SELECT systems, count(*) AS articles
FROM systems_of_material
GROUP BY systems
ORDER BY articles DESC
LIMIT 10;

CREATE OR REPLACE VIEW distinct_search_keywords AS
SELECT DISTINCT description  
FROM keyword
ORDER BY description ASC;

CREATE OR REPLACE VIEW materials_per_application AS
SELECT a.description as application, COUNT(*) as materials
FROM material_has_application ma, application a
WHERE a.id = ma.application_id
GROUP BY ma.application_id
ORDER BY materials DESC

CREATE OR REPLACE VIEW materials_per_subject_area AS
SELECT sa.description as subject_area, COUNT(*) as materials
FROM material_has_subject_area msa, subject_area sa
WHERE sa.id = msa.subject_area_id
GROUP BY msa.subject_area_id
ORDER BY materials DESC

CREATE OR REPLACE VIEW materials_per_bet_scale AS
SELECT bes.description as built_environment_scale, COUNT(*) as materials
FROM material_has_built_environment_scale mbes, built_environment_scale bes
WHERE bes.id = mbes.built_environment_scale_id
GROUP BY mbes.built_environment_scale_id
ORDER BY materials DESC

CREATE OR REPLACE VIEW quality_assessment_view AS
SELECT qa.material_id as material_id,
(SELECT qss.question FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '1') AS qa_1_question,
(SELECT IF (qa.qa_1 = '1', qss.yes, IF (qa.qa_1 = '0', qss.no, IF (qa.qa_1 = '0.5', qss.cannot_answer, 'N/A')))FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '1') AS qa_1_score,
qa.qa_1_details AS qa_1_details,
(SELECT qss.question FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '2') AS qa_2_question,
(SELECT IF (qa.qa_2 = '1', qss.yes, IF (qa.qa_2 = '0', qss.no, IF (qa.qa_2 = '0.5', qss.cannot_answer, 'N/A')))FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '1') AS qa_2_score,
qa.qa_2_details AS qa_2_details,
(SELECT qss.question FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '3') AS qa_3_question,
(SELECT IF (qa.qa_3 = '1', qss.yes, IF (qa.qa_3 = '0', qss.no, IF (qa.qa_3 = '0.5', qss.cannot_answer, 'N/A')))FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '3') AS qa_3_score,
qa.qa_3_details AS qa_3_details,
(SELECT qss.question FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '4') AS qa_4_question,
(SELECT IF (qa.qa_4 = '1', qss.yes, IF (qa.qa_4 = '0', qss.no, IF (qa.qa_4 = '0.5', qss.cannot_answer, 'N/A')))FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '4') AS qa_4_score,
qa.qa_4_details AS qa_4_details,
(SELECT qss.question FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '5') AS qa_5_question,
(SELECT IF (qa.qa_5 = '1', qss.yes, IF (qa.qa_5 = '0', qss.no, IF (qa.qa_5 = '0.5', qss.cannot_answer, 'N/A')))FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '5') AS qa_5_score,
qa.qa_5_details AS qa_5_details,
(SELECT qss.question FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '6') AS qa_6_question,
(SELECT IF (qa.qa_6 = '1', qss.yes, IF (qa.qa_6 = '0', qss.no, IF (qa.qa_6 = '0.5', qss.cannot_answer, 'N/A')))FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '6') AS qa_6_score,
qa.qa_6_details AS qa_6_details,
(SELECT qss.question FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '7') AS qa_7_question,
(SELECT IF (qa.qa_7 = '1', qss.yes, IF (qa.qa_7 = '0', qss.no, IF (qa.qa_7 = '0.5', qss.cannot_answer, 'N/A')))FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '7') AS qa_7_score,
qa.qa_7_details AS qa_7_details,
(SELECT qss.question FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '8') AS qa_8_question,
(SELECT IF (qa.qa_8 = '1', qss.yes, IF (qa.qa_8 = '0', qss.no, IF (qa.qa_8 = '0.5', qss.cannot_answer, 'N/A')))FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '8') AS qa_8_score,
qa.qa_8_details AS qa_8_details,
(SELECT qss.question FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '9') AS qa_9_question,
(SELECT IF (qa.qa_9 = '1', qss.yes, IF (qa.qa_9 = '0', qss.no, IF (qa.qa_9 = '0.5', qss.cannot_answer, 'N/A')))FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '9') AS qa_9_score,
qa.qa_9_details AS qa_9_details,
(SELECT qss.question FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '10') AS qa_10_question,
(SELECT IF (qa.qa_10 = '1', qss.yes, IF (qa.qa_10 = '0', qss.no, IF (qa.qa_10 = '0.5', qss.cannot_answer, 'N/A')))FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '10') AS qa_10_score,
qa.qa_10_details AS qa_10_details,
(SELECT qss.question FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '11') AS qa_11_question,
(SELECT IF (qa.qa_11 = '1', qss.yes, IF (qa.qa_11 = '0', qss.no, IF (qa.qa_11 = '0.5', qss.cannot_answer, 'N/A')))FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '11') AS qa_11_score,
qa.qa_11_details AS qa_11_details,
(SELECT qss.question FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '12') AS qa_12_question,
(SELECT IF (qa.qa_12 = '1', qss.yes, IF (qa.qa_12 = '0', qss.no, IF (qa.qa_12 = '0.5', qss.cannot_answer, 'N/A')))FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '12') AS qa_12_score,
qa.qa_12_details AS qa_12_details,
(SELECT qss.question FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '13') AS qa_13_question,
(SELECT IF (qa.qa_13 = '1', qss.yes, IF (qa.qa_13 = '0', qss.no, IF (qa.qa_13 = '0.5', qss.cannot_answer, 'N/A')))FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '13') AS qa_13_score,
qa.qa_13_details AS qa_13_details,
(SELECT qss.question FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '14') AS qa_14_question,
(SELECT IF (qa.qa_14 = '1', qss.yes, IF (qa.qa_14 = '0', qss.no, IF (qa.qa_14 = '0.5', qss.cannot_answer, 'N/A')))FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '14') AS qa_14_score,
qa.qa_14_details AS qa_14_details,
(SELECT qss.question FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '15') AS qa_15_question,
(SELECT IF (qa.qa_15 = '1', qss.yes, IF (qa.qa_15 = '0', qss.no, IF (qa.qa_15 = '0.5', qss.cannot_answer, 'N/A')))FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '15') AS qa_15_score,
qa.qa_15_details AS qa_15_details,
(SELECT qss.question FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '16') AS qa_16_question,
(SELECT IF (qa.qa_16 = '1', qss.yes, IF (qa.qa_16 = '0', qss.no, IF (qa.qa_16 = '0.5', qss.cannot_answer, 'N/A')))FROM qality_assesment_scheme qss WHERE qss.qa_question_id = '16') AS qa_16_score,
qa.qa_16_details AS qa_16_details
FROM quality_assesment qa;


CREATE OR REPLACE VIEW qa_zeros AS
SELECT 0 AS score,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_1 = '0') AS qa_1,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_2 = '0') AS qa_2,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_3 = '0') AS qa_3,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_4 = '0') AS qa_4,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_5 = '0') AS qa_5,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_6 = '0') AS qa_6,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_7 = '0') AS qa_7,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_8 = '0') AS qa_8,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_9 = '0') AS qa_9,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_10 = '0') AS qa_10,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_11 = '0') AS qa_11,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_12 = '0') AS qa_12,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_13 = '0') AS qa_13,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_14 = '0') AS qa_14,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_15 = '0') AS qa_15,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_16 = '0') AS qa_16;

CREATE OR REPLACE VIEW qa_halves AS
SELECT 0.5 AS score,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_1 = '0.5') AS qa_1,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_2 = '0.5') AS qa_2,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_3 = '0.5') AS qa_3,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_4 = '0.5') AS qa_4,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_5 = '0.5') AS qa_5,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_6 = '0.5') AS qa_6,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_7 = '0.5') AS qa_7,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_8 = '0.5') AS qa_8,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_9 = '0.5') AS qa_9,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_10 = '0.5') AS qa_10,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_11 = '0.5') AS qa_11,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_12 = '0.5') AS qa_12,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_13 = '0.5') AS qa_13,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_14 = '0.5') AS qa_14,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_15 = '0.5') AS qa_15,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_16 = '0.5') AS qa_16;


CREATE OR REPLACE VIEW qa_ones AS
SELECT 1 AS score,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_1 = '1') AS qa_1,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_2 = '1') AS qa_2,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_3 = '1') AS qa_3,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_4 = '1') AS qa_4,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_5 = '1') AS qa_5,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_6 = '1') AS qa_6,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_7 = '1') AS qa_7,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_8 = '1') AS qa_8,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_9 = '1') AS qa_9,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_10 = '1') AS qa_10,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_11 = '1') AS qa_11,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_12 = '1') AS qa_12,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_13 = '1') AS qa_13,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_14 = '1') AS qa_14,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_15 = '1') AS qa_15,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_16 = '1') AS qa_16;

CREATE OR REPLACE VIEW qa_nas AS
SELECT 'NA' AS score,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_1 = 'NA') AS qa_1,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_2 = 'NA') AS qa_2,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_3 = 'NA') AS qa_3,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_4 = 'NA') AS qa_4,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_5 = 'NA') AS qa_5,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_6 = 'NA') AS qa_6,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_7 = 'NA') AS qa_7,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_8 = 'NA') AS qa_8,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_9 = 'NA') AS qa_9,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_10 = 'NA') AS qa_10,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_11 = 'NA') AS qa_11,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_12 = 'NA') AS qa_12,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_13 = 'NA') AS qa_13,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_14 = 'NA') AS qa_14,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_15 = 'NA') AS qa_15,
(SELECT COUNT(*) FROM quality_assesment WHERE qa_16 = 'NA') AS qa_16;


CREATE OR REPLACE VIEW temp_qas AS
SELECT * FROM qa_zeros 
UNION
SELECT * FROM qa_halves
UNION
SELECT * FROM qa_ones
UNION 
SELECT * FROM qa_nas;


CREATE OR REPLACE VIEW review_types_of_material AS
SELECT material.id AS material_id, review_type.name AS claimed_review_type, quality_assesment.actual_review_type AS actual_review_type
FROM material, review_type, quality_assesment
WHERE material.review_type_id = review_type.id
AND quality_assesment.material_id = material.id;


CREATE OR REPLACE VIEW quality_assessment_scheme AS
SELECT * FROM qality_assesment_scheme
ORDER BY cast(qality_assesment_scheme.qa_question_id as unsigned);


CREATE OR REPLACE VIEW search_sources_per_material AS
SELECT mhss.material_id AS material_id, count(*) AS search_sources
FROM material_has_search_source mhss
GROUP BY mhss.material_id;

CREATE OR REPLACE VIEW subject_area_built_environment_scale_names AS
SELECT sabes.material_id AS material_id, sa.description AS subject_area, bes.description AS built_environment_scale 
FROM subject_area_vs_built_environment_scale sabes, subject_area sa, built_environment_scale bes
WHERE sabes.subject_area_id = sa.id
AND sabes.built_environment_scale_id = bes.id;

CREATE OR REPLACE VIEW subject_area_application_names AS
SELECT saas.material_id AS material_id, sa.description AS subject_area, a.description AS application 
FROM subject_area_vs_application saas, subject_area sa, application a
WHERE saas.subject_area_id = sa.id
AND saas.application_id = a.id;

CREATE OR REPLACE VIEW application_built_environment_scale_names AS
SELECT besa.material_id AS material_id, a.description AS application, bes.description AS built_environment_scale 
FROM bet_scale_vs_application besa, application a, built_environment_scale bes
WHERE besa.application_id = a.id
AND besa.built_environment_scale_id = bes.id;



CREATE OR REPLACE VIEW country_codes_of_first_authors AS
SELECT mha.material_id AS material_id, c.name AS country, c.code AS country_code
FROM material_has_author mha, organisation_has_author oha, organisation o, country c
WHERE mha.primary_author = 1
AND mha.author_id = oha.author_id
AND oha.organisation_id = o.id
AND o.country_id = c.id
ORDER BY material_id;



