Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:46833 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaC3QV5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Mar 2014 12:21:57 -0400
Received: by mail-ee0-f51.google.com with SMTP id c13so5837919eek.10
        for <linux-media@vger.kernel.org>; Sun, 30 Mar 2014 09:21:56 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 5/8] libdvbv5: descriptor parser return int
Date: Sun, 30 Mar 2014 18:21:15 +0200
Message-Id: <1396196478-996-5-git-send-email-neolynx@gmail.com>
In-Reply-To: <1396196478-996-1-git-send-email-neolynx@gmail.com>
References: <1396196478-996-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If parsing a descriptor fails, let the outside world know.
Returning 0 means success, negative values indicate a parsing
error.
Free allocated memory on error.

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/libdvbv5/desc_atsc_service_location.h     |  2 +-
 lib/include/libdvbv5/desc_ca.h                        |  2 +-
 lib/include/libdvbv5/desc_ca_identifier.h             |  2 +-
 lib/include/libdvbv5/desc_cable_delivery.h            |  2 +-
 lib/include/libdvbv5/desc_event_extended.h            |  2 +-
 lib/include/libdvbv5/desc_event_short.h               |  2 +-
 lib/include/libdvbv5/desc_extension.h                 |  4 ++--
 lib/include/libdvbv5/desc_frequency_list.h            |  2 +-
 lib/include/libdvbv5/desc_hierarchy.h                 |  2 +-
 lib/include/libdvbv5/desc_isdbt_delivery.h            |  2 +-
 lib/include/libdvbv5/desc_language.h                  |  2 +-
 lib/include/libdvbv5/desc_logical_channel.h           |  2 +-
 lib/include/libdvbv5/desc_network_name.h              |  2 +-
 lib/include/libdvbv5/desc_partial_reception.h         |  2 +-
 lib/include/libdvbv5/desc_sat.h                       |  2 +-
 lib/include/libdvbv5/desc_service.h                   |  2 +-
 lib/include/libdvbv5/desc_service_list.h              |  2 +-
 lib/include/libdvbv5/desc_service_location.h          |  2 +-
 lib/include/libdvbv5/desc_t2_delivery.h               |  2 +-
 lib/include/libdvbv5/desc_terrestrial_delivery.h      |  2 +-
 lib/include/libdvbv5/desc_ts_info.h                   |  2 +-
 lib/include/libdvbv5/descriptors.h                    |  4 ++--
 lib/libdvbv5/descriptors.c                            | 19 ++++++++++++-------
 lib/libdvbv5/descriptors/desc_atsc_service_location.c |  5 +++--
 lib/libdvbv5/descriptors/desc_ca.c                    |  3 ++-
 lib/libdvbv5/descriptors/desc_ca_identifier.c         |  5 +++--
 lib/libdvbv5/descriptors/desc_cable_delivery.c        |  3 ++-
 lib/libdvbv5/descriptors/desc_event_extended.c        |  3 ++-
 lib/libdvbv5/descriptors/desc_event_short.c           |  3 ++-
 lib/libdvbv5/descriptors/desc_extension.c             |  9 ++++++---
 lib/libdvbv5/descriptors/desc_frequency_list.c        |  3 ++-
 lib/libdvbv5/descriptors/desc_hierarchy.c             |  3 ++-
 lib/libdvbv5/descriptors/desc_isdbt_delivery.c        |  7 ++++---
 lib/libdvbv5/descriptors/desc_language.c              |  3 ++-
 lib/libdvbv5/descriptors/desc_logical_channel.c       |  5 +++--
 lib/libdvbv5/descriptors/desc_network_name.c          |  3 ++-
 lib/libdvbv5/descriptors/desc_partial_reception.c     |  5 +++--
 lib/libdvbv5/descriptors/desc_sat.c                   |  4 +++-
 lib/libdvbv5/descriptors/desc_service.c               |  3 ++-
 lib/libdvbv5/descriptors/desc_service_list.c          |  7 +++++--
 lib/libdvbv5/descriptors/desc_service_location.c      |  9 +++++----
 lib/libdvbv5/descriptors/desc_t2_delivery.c           | 11 ++++++-----
 lib/libdvbv5/descriptors/desc_terrestrial_delivery.c  |  3 ++-
 lib/libdvbv5/descriptors/desc_ts_info.c               |  3 ++-
 44 files changed, 99 insertions(+), 68 deletions(-)

diff --git a/lib/include/libdvbv5/desc_atsc_service_location.h b/lib/include/libdvbv5/desc_atsc_service_location.h
index ebe11b7..310efa3 100644
--- a/lib/include/libdvbv5/desc_atsc_service_location.h
+++ b/lib/include/libdvbv5/desc_atsc_service_location.h
@@ -57,7 +57,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void atsc_desc_service_location_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+int atsc_desc_service_location_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
 void atsc_desc_service_location_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
 void atsc_desc_service_location_free(struct dvb_desc *desc);
 
diff --git a/lib/include/libdvbv5/desc_ca.h b/lib/include/libdvbv5/desc_ca.h
index 49d346b..34723d7 100644
--- a/lib/include/libdvbv5/desc_ca.h
+++ b/lib/include/libdvbv5/desc_ca.h
@@ -49,7 +49,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_desc_ca_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+int dvb_desc_ca_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
 void dvb_desc_ca_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
 void dvb_desc_ca_free (struct dvb_desc *desc);
 
diff --git a/lib/include/libdvbv5/desc_ca_identifier.h b/lib/include/libdvbv5/desc_ca_identifier.h
index 1136a84..a4b8537 100644
--- a/lib/include/libdvbv5/desc_ca_identifier.h
+++ b/lib/include/libdvbv5/desc_ca_identifier.h
@@ -41,7 +41,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_desc_ca_identifier_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+int dvb_desc_ca_identifier_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
 void dvb_desc_ca_identifier_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
 void dvb_desc_ca_identifier_free (struct dvb_desc *desc);
 
diff --git a/lib/include/libdvbv5/desc_cable_delivery.h b/lib/include/libdvbv5/desc_cable_delivery.h
index 8f5355a..b6ffaea 100644
--- a/lib/include/libdvbv5/desc_cable_delivery.h
+++ b/lib/include/libdvbv5/desc_cable_delivery.h
@@ -52,7 +52,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_desc_cable_delivery_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+int dvb_desc_cable_delivery_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
 void dvb_desc_cable_delivery_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
 
 extern const unsigned dvbc_modulation_table[];
diff --git a/lib/include/libdvbv5/desc_event_extended.h b/lib/include/libdvbv5/desc_event_extended.h
index b15e551..6e07064 100644
--- a/lib/include/libdvbv5/desc_event_extended.h
+++ b/lib/include/libdvbv5/desc_event_extended.h
@@ -46,7 +46,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_desc_event_extended_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+int dvb_desc_event_extended_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
 void dvb_desc_event_extended_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
 void dvb_desc_event_extended_free (struct dvb_desc *desc);
 
diff --git a/lib/include/libdvbv5/desc_event_short.h b/lib/include/libdvbv5/desc_event_short.h
index 836e1b6..eac7e96 100644
--- a/lib/include/libdvbv5/desc_event_short.h
+++ b/lib/include/libdvbv5/desc_event_short.h
@@ -40,7 +40,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_desc_event_short_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+int dvb_desc_event_short_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
 void dvb_desc_event_short_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
 void dvb_desc_event_short_free (struct dvb_desc *desc);
 
diff --git a/lib/include/libdvbv5/desc_extension.h b/lib/include/libdvbv5/desc_extension.h
index c19ec70..8b2606a 100644
--- a/lib/include/libdvbv5/desc_extension.h
+++ b/lib/include/libdvbv5/desc_extension.h
@@ -49,7 +49,7 @@ struct dvb_extension_descriptor {
 } __attribute__((packed));
 
 
-typedef void (*dvb_desc_ext_init_func) (struct dvb_v5_fe_parms *parms,
+typedef int  (*dvb_desc_ext_init_func) (struct dvb_v5_fe_parms *parms,
 					const uint8_t *buf,
 					struct dvb_extension_descriptor *ext,
 					void *desc);
@@ -71,7 +71,7 @@ struct dvb_ext_descriptor {
 extern "C" {
 #endif
 
-void extension_descriptor_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+int extension_descriptor_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
 void extension_descriptor_free(struct dvb_desc *descriptor);
 void extension_descriptor_print(struct dvb_v5_fe_parms *parms,
 				const struct dvb_desc *desc);
diff --git a/lib/include/libdvbv5/desc_frequency_list.h b/lib/include/libdvbv5/desc_frequency_list.h
index 7278971..b974fc8 100644
--- a/lib/include/libdvbv5/desc_frequency_list.h
+++ b/lib/include/libdvbv5/desc_frequency_list.h
@@ -45,7 +45,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_desc_frequency_list_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+int dvb_desc_frequency_list_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
 void dvb_desc_frequency_list_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
 
 #ifdef __cplusplus
diff --git a/lib/include/libdvbv5/desc_hierarchy.h b/lib/include/libdvbv5/desc_hierarchy.h
index fe8e772..51075c0 100644
--- a/lib/include/libdvbv5/desc_hierarchy.h
+++ b/lib/include/libdvbv5/desc_hierarchy.h
@@ -46,7 +46,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_desc_hierarchy_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+int dvb_desc_hierarchy_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
 void dvb_desc_hierarchy_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
 
 #ifdef __cplusplus
diff --git a/lib/include/libdvbv5/desc_isdbt_delivery.h b/lib/include/libdvbv5/desc_isdbt_delivery.h
index ae23475..5131d1a 100644
--- a/lib/include/libdvbv5/desc_isdbt_delivery.h
+++ b/lib/include/libdvbv5/desc_isdbt_delivery.h
@@ -46,7 +46,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void isdbt_desc_delivery_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+int isdbt_desc_delivery_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
 void isdbt_desc_delivery_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
 void isdbt_desc_delivery_free(struct dvb_desc *desc);
 
diff --git a/lib/include/libdvbv5/desc_language.h b/lib/include/libdvbv5/desc_language.h
index 0872bdd..6272680 100644
--- a/lib/include/libdvbv5/desc_language.h
+++ b/lib/include/libdvbv5/desc_language.h
@@ -37,7 +37,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_desc_language_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+int dvb_desc_language_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
 void dvb_desc_language_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
 
 #ifdef __cplusplus
diff --git a/lib/include/libdvbv5/desc_logical_channel.h b/lib/include/libdvbv5/desc_logical_channel.h
index 28a6ac4..83d44e5 100644
--- a/lib/include/libdvbv5/desc_logical_channel.h
+++ b/lib/include/libdvbv5/desc_logical_channel.h
@@ -51,7 +51,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_desc_logical_channel_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+int dvb_desc_logical_channel_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
 void dvb_desc_logical_channel_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
 void dvb_desc_logical_channel_free(struct dvb_desc *desc);
 
diff --git a/lib/include/libdvbv5/desc_network_name.h b/lib/include/libdvbv5/desc_network_name.h
index 6b6dcbc..7ab2296 100644
--- a/lib/include/libdvbv5/desc_network_name.h
+++ b/lib/include/libdvbv5/desc_network_name.h
@@ -37,7 +37,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_desc_network_name_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+int dvb_desc_network_name_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
 void dvb_desc_network_name_free (struct dvb_desc *desc);
 void dvb_desc_network_name_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
 
diff --git a/lib/include/libdvbv5/desc_partial_reception.h b/lib/include/libdvbv5/desc_partial_reception.h
index 3f40e5f..05230e7 100644
--- a/lib/include/libdvbv5/desc_partial_reception.h
+++ b/lib/include/libdvbv5/desc_partial_reception.h
@@ -43,7 +43,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void isdb_desc_partial_reception_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+int isdb_desc_partial_reception_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
 void isdb_desc_partial_reception_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
 void isdb_desc_partial_reception_free(struct dvb_desc *desc);
 
diff --git a/lib/include/libdvbv5/desc_sat.h b/lib/include/libdvbv5/desc_sat.h
index 391ab44..86d9cfb 100644
--- a/lib/include/libdvbv5/desc_sat.h
+++ b/lib/include/libdvbv5/desc_sat.h
@@ -49,7 +49,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_desc_sat_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+int dvb_desc_sat_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
 void dvb_desc_sat_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
 
 extern const unsigned dvbs_dvbc_dvbs_freq_inner[];
diff --git a/lib/include/libdvbv5/desc_service.h b/lib/include/libdvbv5/desc_service.h
index 57964d3..da4423c 100644
--- a/lib/include/libdvbv5/desc_service.h
+++ b/lib/include/libdvbv5/desc_service.h
@@ -40,7 +40,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_desc_service_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+int dvb_desc_service_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
 void dvb_desc_service_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
 void dvb_desc_service_free (struct dvb_desc *desc);
 
diff --git a/lib/include/libdvbv5/desc_service_list.h b/lib/include/libdvbv5/desc_service_list.h
index 33b9b67..e71e321 100644
--- a/lib/include/libdvbv5/desc_service_list.h
+++ b/lib/include/libdvbv5/desc_service_list.h
@@ -41,7 +41,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_desc_service_list_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+int dvb_desc_service_list_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
 void dvb_desc_service_list_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
 
 #ifdef __cplusplus
diff --git a/lib/include/libdvbv5/desc_service_location.h b/lib/include/libdvbv5/desc_service_location.h
index 958dd04..af3379b 100644
--- a/lib/include/libdvbv5/desc_service_location.h
+++ b/lib/include/libdvbv5/desc_service_location.h
@@ -55,7 +55,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_desc_service_location_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+int dvb_desc_service_location_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
 void dvb_desc_service_location_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
 void dvb_desc_service_location_free (struct dvb_desc *desc);
 
diff --git a/lib/include/libdvbv5/desc_t2_delivery.h b/lib/include/libdvbv5/desc_t2_delivery.h
index ed0d7a3..55c967d 100644
--- a/lib/include/libdvbv5/desc_t2_delivery.h
+++ b/lib/include/libdvbv5/desc_t2_delivery.h
@@ -59,7 +59,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_desc_t2_delivery_init(struct dvb_v5_fe_parms *parms,
+int dvb_desc_t2_delivery_init(struct dvb_v5_fe_parms *parms,
 			       const uint8_t *buf,
 			       struct dvb_extension_descriptor *ext,
 			       void *desc);
diff --git a/lib/include/libdvbv5/desc_terrestrial_delivery.h b/lib/include/libdvbv5/desc_terrestrial_delivery.h
index 592305a..1c71189 100644
--- a/lib/include/libdvbv5/desc_terrestrial_delivery.h
+++ b/lib/include/libdvbv5/desc_terrestrial_delivery.h
@@ -51,7 +51,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_desc_terrestrial_delivery_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+int dvb_desc_terrestrial_delivery_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
 void dvb_desc_terrestrial_delivery_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
 extern const unsigned dvbt_bw[];
 extern const unsigned dvbt_modulation[];
diff --git a/lib/include/libdvbv5/desc_ts_info.h b/lib/include/libdvbv5/desc_ts_info.h
index 60eed5d..a34a721 100644
--- a/lib/include/libdvbv5/desc_ts_info.h
+++ b/lib/include/libdvbv5/desc_ts_info.h
@@ -52,7 +52,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_desc_ts_info_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+int dvb_desc_ts_info_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
 void dvb_desc_ts_info_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
 void dvb_desc_ts_info_free(struct dvb_desc *desc);
 
diff --git a/lib/include/libdvbv5/descriptors.h b/lib/include/libdvbv5/descriptors.h
index cc67a38..e81a05d 100644
--- a/lib/include/libdvbv5/descriptors.h
+++ b/lib/include/libdvbv5/descriptors.h
@@ -81,7 +81,7 @@ uint32_t bcd(uint32_t bcd);
 
 void hexdump(struct dvb_v5_fe_parms *parms, const char *prefix, const unsigned char *buf, int len);
 
-void dvb_parse_descriptors(struct dvb_v5_fe_parms *parms, const uint8_t *buf, uint16_t section_length, struct dvb_desc **head_desc);
+int dvb_parse_descriptors(struct dvb_v5_fe_parms *parms, const uint8_t *buf, uint16_t section_length, struct dvb_desc **head_desc);
 void dvb_free_descriptors(struct dvb_desc **list);
 void dvb_print_descriptors(struct dvb_v5_fe_parms *parms, struct dvb_desc *desc);
 
@@ -91,7 +91,7 @@ void dvb_print_descriptors(struct dvb_v5_fe_parms *parms, struct dvb_desc *desc)
 
 struct dvb_v5_fe_parms;
 
-typedef void (*dvb_desc_init_func) (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+typedef int (*dvb_desc_init_func) (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
 typedef void (*dvb_desc_print_func)(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
 typedef void (*dvb_desc_free_func) (struct dvb_desc *desc);
 
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index 22fb7c4..6fd8691 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -66,9 +66,10 @@ static void dvb_desc_init(uint8_t type, uint8_t length, struct dvb_desc *desc)
 	desc->next   = NULL;
 }
 
-static void dvb_desc_default_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+static int dvb_desc_default_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	memcpy(desc->data, buf, desc->length);
+	return 0;
 }
 
 static void dvb_desc_default_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
@@ -97,7 +98,7 @@ const struct dvb_table_init dvb_table_initializers[] = {
 char *default_charset = "iso-8859-1";
 char *output_charset = "utf-8";
 
-void dvb_parse_descriptors(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
+int dvb_parse_descriptors(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			   uint16_t buflen, struct dvb_desc **head_desc)
 {
 	const uint8_t *ptr = buf, *endbuf = buf + buflen;
@@ -116,7 +117,7 @@ void dvb_parse_descriptors(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		if (ptr + desc_len > endbuf) {
 			dvb_logerr("short read of %zd/%d bytes parsing descriptor %#02x",
 				   endbuf - ptr, desc_len, desc_type);
-			return;
+			return -1;
 		}
 
 		switch (parms->verbose) {
@@ -143,16 +144,19 @@ void dvb_parse_descriptors(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		}
 		if (!size) {
 			dvb_logerr("descriptor type 0x%02x has no size defined", desc_type);
-			return;
+			return -2;
 		}
 
 		current = calloc(1, size);
 		if (!current) {
-			dvb_perror("Out of memory");
-			return;
+			dvb_logerr("%s: out of memory", __func__);
+			return -3;
 		}
 		dvb_desc_init(desc_type, desc_len, current); /* initialize the standard header */
-		init(parms, ptr, current);
+		if (init(parms, ptr, current) != 0) {
+			free(current);
+			return -4;
+		}
 		if (!*head_desc)
 			*head_desc = current;
 		if (last)
@@ -160,6 +164,7 @@ void dvb_parse_descriptors(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		last = current;
 		ptr += current->length;     /* standard descriptor header plus descriptor length */
 	}
+	return 0;
 }
 
 void dvb_print_descriptors(struct dvb_v5_fe_parms *parms, struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_atsc_service_location.c b/lib/libdvbv5/descriptors/desc_atsc_service_location.c
index 6da43b6..d47eee0 100644
--- a/lib/libdvbv5/descriptors/desc_atsc_service_location.c
+++ b/lib/libdvbv5/descriptors/desc_atsc_service_location.c
@@ -22,7 +22,7 @@
 #include <libdvbv5/desc_atsc_service_location.h>
 #include <libdvbv5/dvb-fe.h>
 
-void atsc_desc_service_location_init(struct dvb_v5_fe_parms *parms,
+int atsc_desc_service_location_init(struct dvb_v5_fe_parms *parms,
 				     const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct atsc_desc_service_location *s_loc = (struct atsc_desc_service_location *)desc;
@@ -41,7 +41,7 @@ void atsc_desc_service_location_init(struct dvb_v5_fe_parms *parms,
 		s_loc->elementary = malloc(s_loc->number_elements * sizeof(*s_loc->elementary));
 		if (!s_loc->elementary) {
 			dvb_perror("Can't allocate space for ATSC service location elementary data");
-			return;
+			return -1;
 		}
 
 		el = s_loc->elementary;
@@ -56,6 +56,7 @@ void atsc_desc_service_location_init(struct dvb_v5_fe_parms *parms,
 	} else {
 		s_loc->elementary = NULL;
 	}
+	return 0;
 }
 
 void atsc_desc_service_location_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_ca.c b/lib/libdvbv5/descriptors/desc_ca.c
index 40edfde..01d3b8c 100644
--- a/lib/libdvbv5/descriptors/desc_ca.c
+++ b/lib/libdvbv5/descriptors/desc_ca.c
@@ -23,7 +23,7 @@
 #include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 
-void dvb_desc_ca_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+int dvb_desc_ca_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	size_t size = offsetof(struct dvb_desc_ca, dvb_desc_ca_field_last) - offsetof(struct dvb_desc_ca, dvb_desc_ca_field_first);
 	struct dvb_desc_ca *d = (struct dvb_desc_ca *) desc;
@@ -43,6 +43,7 @@ void dvb_desc_ca_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct
 	}
 	/*hexdump(parms, "desc ca ", buf, desc->length);*/
 	/*dvb_desc_ca_print(parms, desc);*/
+	return 0;
 }
 
 void dvb_desc_ca_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_ca_identifier.c b/lib/libdvbv5/descriptors/desc_ca_identifier.c
index 95e0569..c986ac7 100644
--- a/lib/libdvbv5/descriptors/desc_ca_identifier.c
+++ b/lib/libdvbv5/descriptors/desc_ca_identifier.c
@@ -23,7 +23,7 @@
 #include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 
-void dvb_desc_ca_identifier_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+int dvb_desc_ca_identifier_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_ca_identifier *d = (struct dvb_desc_ca_identifier *) desc;
 	int i;
@@ -32,12 +32,13 @@ void dvb_desc_ca_identifier_init(struct dvb_v5_fe_parms *parms, const uint8_t *b
 	d->caids = malloc(d->length);
 	if (!d->caids) {
 		dvb_logerr("dvb_desc_ca_identifier_init: out of memory");
-		return;
+		return -1;
 	}
 	for (i = 0; i < d->caid_count; i++) {
 		d->caids[i] = ((uint16_t *) buf)[i];
 		bswap16(d->caids[i]);
 	}
+	return 0;
 }
 
 void dvb_desc_ca_identifier_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_cable_delivery.c b/lib/libdvbv5/descriptors/desc_cable_delivery.c
index 2214133..63583eb 100644
--- a/lib/libdvbv5/descriptors/desc_cable_delivery.c
+++ b/lib/libdvbv5/descriptors/desc_cable_delivery.c
@@ -24,7 +24,7 @@
 #include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 
-void dvb_desc_cable_delivery_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+int dvb_desc_cable_delivery_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_cable_delivery *cable = (struct dvb_desc_cable_delivery *) desc;
 	/* copy only the data - length already initialize */
@@ -36,6 +36,7 @@ void dvb_desc_cable_delivery_init(struct dvb_v5_fe_parms *parms, const uint8_t *
 	bswap32(cable->bitfield2);
 	cable->frequency   = bcd(cable->frequency) * 100;
 	cable->symbol_rate = bcd(cable->symbol_rate) * 100;
+	return 0;
 }
 
 void dvb_desc_cable_delivery_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_event_extended.c b/lib/libdvbv5/descriptors/desc_event_extended.c
index c3bfc33..9d7c6e3 100644
--- a/lib/libdvbv5/descriptors/desc_event_extended.c
+++ b/lib/libdvbv5/descriptors/desc_event_extended.c
@@ -24,7 +24,7 @@
 #include <libdvbv5/dvb-fe.h>
 #include <parse_string.h>
 
-void dvb_desc_event_extended_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+int dvb_desc_event_extended_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_event_extended *event = (struct dvb_desc_event_extended *) desc;
 	uint8_t len;  /* the length of the string in the input data */
@@ -62,6 +62,7 @@ void dvb_desc_event_extended_init(struct dvb_v5_fe_parms *parms, const uint8_t *
 	buf++;
 	parse_string(parms, &event->text, &event->text_emph, buf, len1, default_charset, output_charset);
 	buf += len;
+	return 0;
 }
 
 void dvb_desc_event_extended_free(struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_event_short.c b/lib/libdvbv5/descriptors/desc_event_short.c
index 81f7b36..d28e5f0 100644
--- a/lib/libdvbv5/descriptors/desc_event_short.c
+++ b/lib/libdvbv5/descriptors/desc_event_short.c
@@ -24,7 +24,7 @@
 #include <libdvbv5/dvb-fe.h>
 #include <parse_string.h>
 
-void dvb_desc_event_short_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+int dvb_desc_event_short_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_event_short *event = (struct dvb_desc_event_short *) desc;
 	uint8_t len;        /* the length of the string in the input data */
@@ -53,6 +53,7 @@ void dvb_desc_event_short_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf
 	buf++;
 	parse_string(parms, &event->text, &event->text_emph, buf, len2, default_charset, output_charset);
 	buf += len;
+	return 0;
 }
 
 void dvb_desc_event_short_free(struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_extension.c b/lib/libdvbv5/descriptors/desc_extension.c
index 0adf9c0..91748bb 100644
--- a/lib/libdvbv5/descriptors/desc_extension.c
+++ b/lib/libdvbv5/descriptors/desc_extension.c
@@ -117,7 +117,7 @@ const struct dvb_ext_descriptor dvb_ext_descriptors[] = {
 	},
 };
 
-void extension_descriptor_init(struct dvb_v5_fe_parms *parms,
+int extension_descriptor_init(struct dvb_v5_fe_parms *parms,
 				     const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_extension_descriptor *ext = (void *)desc;
@@ -153,10 +153,13 @@ void extension_descriptor_init(struct dvb_v5_fe_parms *parms,
 
 	ext->descriptor = calloc(1, size);
 
-	if (init)
-		init(parms, p, ext, ext->descriptor);
+	if (init) {
+		if (init(parms, p, ext, ext->descriptor) != 0)
+			return -1;
+	}
 	else
 		memcpy(ext->descriptor, p, size);
+	return 0;
 }
 
 void extension_descriptor_free(struct dvb_desc *descriptor)
diff --git a/lib/libdvbv5/descriptors/desc_frequency_list.c b/lib/libdvbv5/descriptors/desc_frequency_list.c
index fa6d2cd..9643015 100644
--- a/lib/libdvbv5/descriptors/desc_frequency_list.c
+++ b/lib/libdvbv5/descriptors/desc_frequency_list.c
@@ -23,7 +23,7 @@
 #include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 
-void dvb_desc_frequency_list_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+int dvb_desc_frequency_list_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_frequency_list *d = (struct dvb_desc_frequency_list *) desc;
 	size_t len;
@@ -54,6 +54,7 @@ void dvb_desc_frequency_list_init(struct dvb_v5_fe_parms *parms, const uint8_t *
 				break;
 		}
 	}
+	return 0;
 }
 
 void dvb_desc_frequency_list_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_hierarchy.c b/lib/libdvbv5/descriptors/desc_hierarchy.c
index cf14824..0d8ac66 100644
--- a/lib/libdvbv5/descriptors/desc_hierarchy.c
+++ b/lib/libdvbv5/descriptors/desc_hierarchy.c
@@ -23,13 +23,14 @@
 #include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 
-void dvb_desc_hierarchy_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+int dvb_desc_hierarchy_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_hierarchy *hierarchy = (struct dvb_desc_hierarchy *) desc;
 	/* copy from .length */
 	memcpy(((uint8_t *) hierarchy ) + sizeof(hierarchy->type) + sizeof(hierarchy->length) + sizeof(hierarchy->next),
 		buf,
 		hierarchy->length);
+	return 0;
 }
 
 void dvb_desc_hierarchy_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_isdbt_delivery.c b/lib/libdvbv5/descriptors/desc_isdbt_delivery.c
index bd22456..9ef5df4 100644
--- a/lib/libdvbv5/descriptors/desc_isdbt_delivery.c
+++ b/lib/libdvbv5/descriptors/desc_isdbt_delivery.c
@@ -22,7 +22,7 @@
 #include <libdvbv5/desc_isdbt_delivery.h>
 #include <libdvbv5/dvb-fe.h>
 
-void isdbt_desc_delivery_init(struct dvb_v5_fe_parms *parms,
+int isdbt_desc_delivery_init(struct dvb_v5_fe_parms *parms,
 			      const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct isdbt_desc_terrestrial_delivery_system *d = (void *)desc;
@@ -38,16 +38,17 @@ void isdbt_desc_delivery_init(struct dvb_v5_fe_parms *parms,
 
 	d->num_freqs = d->length / 2;
 	if (!len)
-		return;
+		return -1;
 	d->frequency = malloc(d->num_freqs * sizeof(*d->frequency));
 	if (!d->frequency) {
 		dvb_perror("Can't allocate space for ISDB-T frequencies");
-		return;
+		return -2;
 	}
 	memcpy(d->frequency, p, d->num_freqs * sizeof(*d->frequency));
 
 	for (i = 0; i < d->num_freqs; i++)
 		bswap16(d->frequency[i]);
+	return 0;
 }
 
 static const char *interval_name[] = {
diff --git a/lib/libdvbv5/descriptors/desc_language.c b/lib/libdvbv5/descriptors/desc_language.c
index dfdf40f..91646c7 100644
--- a/lib/libdvbv5/descriptors/desc_language.c
+++ b/lib/libdvbv5/descriptors/desc_language.c
@@ -23,7 +23,7 @@
 #include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 
-void dvb_desc_language_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+int dvb_desc_language_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_language *lang = (struct dvb_desc_language *) desc;
 
@@ -32,6 +32,7 @@ void dvb_desc_language_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, s
 	lang->language[2] = buf[2];
 	lang->language[3] = '\0';
 	lang->audio_type  = buf[3];
+	return 0;
 }
 
 void dvb_desc_language_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_logical_channel.c b/lib/libdvbv5/descriptors/desc_logical_channel.c
index d3edbd9..6ebea03 100644
--- a/lib/libdvbv5/descriptors/desc_logical_channel.c
+++ b/lib/libdvbv5/descriptors/desc_logical_channel.c
@@ -27,7 +27,7 @@
 #include <libdvbv5/dvb-fe.h>
 #include <parse_string.h>
 
-void dvb_desc_logical_channel_init(struct dvb_v5_fe_parms *parms,
+int dvb_desc_logical_channel_init(struct dvb_v5_fe_parms *parms,
 			      const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_logical_channel *d = (void *)desc;
@@ -38,7 +38,7 @@ void dvb_desc_logical_channel_init(struct dvb_v5_fe_parms *parms,
 	d->lcn = malloc(d->length);
 	if (!d->lcn) {
 		dvb_perror("Out of memory!");
-		return;
+		return -1;
 	}
 
 	memcpy(d->lcn, p, d->length);
@@ -49,6 +49,7 @@ void dvb_desc_logical_channel_init(struct dvb_v5_fe_parms *parms,
 		bswap16(d->lcn[i].service_id);
 		bswap16(d->lcn[i].bitfield);
 	}
+	return 0;
 }
 
 void dvb_desc_logical_channel_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_network_name.c b/lib/libdvbv5/descriptors/desc_network_name.c
index b48cec1..6a6cb09 100644
--- a/lib/libdvbv5/descriptors/desc_network_name.c
+++ b/lib/libdvbv5/descriptors/desc_network_name.c
@@ -24,7 +24,7 @@
 #include <libdvbv5/dvb-fe.h>
 #include "parse_string.h"
 
-void dvb_desc_network_name_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+int dvb_desc_network_name_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_network_name *net = (struct dvb_desc_network_name *) desc;
 	uint8_t len;  /* the length of the string in the input data */
@@ -36,6 +36,7 @@ void dvb_desc_network_name_init(struct dvb_v5_fe_parms *parms, const uint8_t *bu
 	net->network_name_emph = NULL;
 	parse_string(parms, &net->network_name, &net->network_name_emph, buf, len1, default_charset, output_charset);
 	buf += len;
+	return 0;
 }
 
 void dvb_desc_network_name_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_partial_reception.c b/lib/libdvbv5/descriptors/desc_partial_reception.c
index 58d3fe6..4d19f14 100644
--- a/lib/libdvbv5/descriptors/desc_partial_reception.c
+++ b/lib/libdvbv5/descriptors/desc_partial_reception.c
@@ -24,7 +24,7 @@
 #include <libdvbv5/dvb-fe.h>
 #include <parse_string.h>
 
-void isdb_desc_partial_reception_init(struct dvb_v5_fe_parms *parms,
+int isdb_desc_partial_reception_init(struct dvb_v5_fe_parms *parms,
 			      const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct isdb_desc_partial_reception *d = (void *)desc;
@@ -35,7 +35,7 @@ void isdb_desc_partial_reception_init(struct dvb_v5_fe_parms *parms,
 	d->partial_reception = malloc(d->length);
 	if (!d->partial_reception) {
 		dvb_perror("Out of memory!");
-		return;
+		return -1;
 	}
 
 	memcpy(d->partial_reception, p, d->length);
@@ -44,6 +44,7 @@ void isdb_desc_partial_reception_init(struct dvb_v5_fe_parms *parms,
 
 	for (i = 0; i < len; i++)
 		bswap16(d->partial_reception[i].service_id);
+	return 0;
 }
 
 void isdb_desc_partial_reception_free(struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_sat.c b/lib/libdvbv5/descriptors/desc_sat.c
index 510de25..3084435 100644
--- a/lib/libdvbv5/descriptors/desc_sat.c
+++ b/lib/libdvbv5/descriptors/desc_sat.c
@@ -23,7 +23,7 @@
 #include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 
-void dvb_desc_sat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+int dvb_desc_sat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_sat *sat = (struct dvb_desc_sat *) desc;
 	/* copy from .length */
@@ -36,6 +36,8 @@ void dvb_desc_sat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct
 	sat->orbit = bcd(sat->orbit);
 	sat->frequency   = bcd(sat->frequency) * 10;
 	sat->symbol_rate = bcd(sat->symbol_rate) * 100;
+
+	return 0;
 }
 
 void dvb_desc_sat_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_service.c b/lib/libdvbv5/descriptors/desc_service.c
index c86de91..c356b7f 100644
--- a/lib/libdvbv5/descriptors/desc_service.c
+++ b/lib/libdvbv5/descriptors/desc_service.c
@@ -24,7 +24,7 @@
 #include <libdvbv5/dvb-fe.h>
 #include <parse_string.h>
 
-void dvb_desc_service_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+int dvb_desc_service_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_service *service = (struct dvb_desc_service *) desc;
 	uint8_t len;        /* the length of the string in the input data */
@@ -48,6 +48,7 @@ void dvb_desc_service_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, st
 	buf++;
 	parse_string(parms, &service->name, &service->name_emph, buf, len2, default_charset, output_charset);
 	buf += len;
+	return 0;
 }
 
 void dvb_desc_service_free(struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_service_list.c b/lib/libdvbv5/descriptors/desc_service_list.c
index f3c5c79..58d4f2d 100644
--- a/lib/libdvbv5/descriptors/desc_service_list.c
+++ b/lib/libdvbv5/descriptors/desc_service_list.c
@@ -23,7 +23,9 @@
 #include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 
-void dvb_desc_service_list_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+/* FIXME: implement */
+
+int dvb_desc_service_list_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	/*struct dvb_desc_service_list *slist = (struct dvb_desc_service_list *) desc;*/
 
@@ -38,7 +40,8 @@ void dvb_desc_service_list_init(struct dvb_v5_fe_parms *parms, const uint8_t *bu
 	/*}*/
 
 	/*return sizeof(struct dvb_desc_service_list) + slist->length + sizeof(struct dvb_desc_service_list_table);*/
-	//FIXME: make linked list
+	/* FIXME: make linked list */
+	return 0;
 }
 
 void dvb_desc_service_list_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_service_location.c b/lib/libdvbv5/descriptors/desc_service_location.c
index f386f57..3a571fd 100644
--- a/lib/libdvbv5/descriptors/desc_service_location.c
+++ b/lib/libdvbv5/descriptors/desc_service_location.c
@@ -22,7 +22,7 @@
 #include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 
-void dvb_desc_service_location_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+int dvb_desc_service_location_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_service_location *service_location = (struct dvb_desc_service_location *) desc;
 	const uint8_t *endbuf = buf + desc->length;
@@ -32,7 +32,7 @@ void dvb_desc_service_location_init(struct dvb_v5_fe_parms *parms, const uint8_t
 
 	if (buf + size > endbuf) {
 		dvb_logerr("%s: short read %zd/%zd bytes", __FUNCTION__, endbuf - buf, size);
-		return;
+		return -1;
 	}
 
 	memcpy(desc->data, buf, size);
@@ -40,12 +40,12 @@ void dvb_desc_service_location_init(struct dvb_v5_fe_parms *parms, const uint8_t
 	buf += size;
 
 	if (service_location->elements == 0)
-		return;
+		return 0;
 
 	size = service_location->elements * sizeof(struct dvb_desc_service_location_element);
 	if (buf + size > endbuf) {
 		dvb_logerr("%s: short read %zd/%zd bytes", __FUNCTION__, endbuf - buf, size);
-		return;
+		return -2;
 	}
 	service_location->element = malloc(size);
 	element = service_location->element;
@@ -56,6 +56,7 @@ void dvb_desc_service_location_init(struct dvb_v5_fe_parms *parms, const uint8_t
 		bswap16(element->bitfield);
 		element++;
 	}
+	return 0;
 }
 
 void dvb_desc_service_location_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_t2_delivery.c b/lib/libdvbv5/descriptors/desc_t2_delivery.c
index 31c6974..b7f2d0b 100644
--- a/lib/libdvbv5/descriptors/desc_t2_delivery.c
+++ b/lib/libdvbv5/descriptors/desc_t2_delivery.c
@@ -24,7 +24,7 @@
 #include <libdvbv5/desc_t2_delivery.h>
 #include <libdvbv5/dvb-fe.h>
 
-void dvb_desc_t2_delivery_init(struct dvb_v5_fe_parms *parms,
+int dvb_desc_t2_delivery_init(struct dvb_v5_fe_parms *parms,
 			       const uint8_t *buf,
 			       struct dvb_extension_descriptor *ext,
 			       void *desc)
@@ -39,7 +39,7 @@ void dvb_desc_t2_delivery_init(struct dvb_v5_fe_parms *parms,
 
 	if (desc_len < len) {
 		dvb_logwarn("T2 delivery descriptor is too small");
-		return;
+		return -1;
 	}
 	if (desc_len < len2) {
 		memcpy(p, buf, len);
@@ -48,7 +48,7 @@ void dvb_desc_t2_delivery_init(struct dvb_v5_fe_parms *parms,
 		if (desc_len != len)
 			dvb_logwarn("T2 delivery descriptor is truncated");
 
-		return;
+		return -2;
 	}
 	memcpy(p, buf, len2);
 	p += len2;
@@ -68,7 +68,7 @@ void dvb_desc_t2_delivery_init(struct dvb_v5_fe_parms *parms,
 				     sizeof(*d->centre_frequency));
 	if (!d->centre_frequency) {
 		dvb_perror("Out of memory");
-		return;
+		return -3;
 	}
 
 	memcpy(d->centre_frequency, p, sizeof(*d->centre_frequency) * d->frequency_loop_length);
@@ -83,12 +83,13 @@ void dvb_desc_t2_delivery_init(struct dvb_v5_fe_parms *parms,
 	d->subcell = calloc(d->subcel_info_loop_length, sizeof(*d->subcell));
 	if (!d->subcell) {
 		dvb_perror("Out of memory");
-		return;
+		return -4;
 	}
 	memcpy(d->subcell, p, sizeof(*d->subcell) * d->subcel_info_loop_length);
 
 	for (i = 0; i < d->subcel_info_loop_length; i++)
 		bswap16(d->subcell[i].transposer_frequency);
+	return 0;
 }
 
 void dvb_desc_t2_delivery_print(struct dvb_v5_fe_parms *parms,
diff --git a/lib/libdvbv5/descriptors/desc_terrestrial_delivery.c b/lib/libdvbv5/descriptors/desc_terrestrial_delivery.c
index 2cb3a01..3bf478c 100644
--- a/lib/libdvbv5/descriptors/desc_terrestrial_delivery.c
+++ b/lib/libdvbv5/descriptors/desc_terrestrial_delivery.c
@@ -25,7 +25,7 @@
 #include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 
-void dvb_desc_terrestrial_delivery_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+int dvb_desc_terrestrial_delivery_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_terrestrial_delivery *tdel = (struct dvb_desc_terrestrial_delivery *) desc;
 	/* copy from .length */
@@ -34,6 +34,7 @@ void dvb_desc_terrestrial_delivery_init(struct dvb_v5_fe_parms *parms, const uin
 			tdel->length);
 	bswap32(tdel->centre_frequency);
 	bswap32(tdel->reserved_future_use2);
+	return 0;
 }
 
 void dvb_desc_terrestrial_delivery_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_ts_info.c b/lib/libdvbv5/descriptors/desc_ts_info.c
index 233d331..f2867e5 100644
--- a/lib/libdvbv5/descriptors/desc_ts_info.c
+++ b/lib/libdvbv5/descriptors/desc_ts_info.c
@@ -24,7 +24,7 @@
 #include <libdvbv5/dvb-fe.h>
 #include <parse_string.h>
 
-void dvb_desc_ts_info_init(struct dvb_v5_fe_parms *parms,
+int dvb_desc_ts_info_init(struct dvb_v5_fe_parms *parms,
 			      const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_ts_info *d = (void *)desc;
@@ -59,6 +59,7 @@ void dvb_desc_ts_info_init(struct dvb_v5_fe_parms *parms,
 		bswap16(d->service_id[i]);
 
 	p += sizeof(*d->service_id) * t->num_of_service;
+	return 0;
 }
 
 void dvb_desc_ts_info_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
-- 
1.8.3.2

