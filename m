Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:38630 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbaADRIp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jan 2014 12:08:45 -0500
Received: by mail-ee0-f42.google.com with SMTP id e53so7231508eek.29
        for <linux-media@vger.kernel.org>; Sat, 04 Jan 2014 09:08:44 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 07/11] libdvbv5: use DVB_DESC_HEADER macro in all descriptors
Date: Sat,  4 Jan 2014 18:07:57 +0100
Message-Id: <1388855282-19295-7-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388855282-19295-1-git-send-email-neolynx@gmail.com>
References: <1388855282-19295-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/libdvbv5/desc_atsc_service_location.h |    7 ++-----
 lib/include/libdvbv5/desc_ca.h                    |    7 ++-----
 lib/include/libdvbv5/desc_ca_identifier.h         |    7 ++-----
 lib/include/libdvbv5/desc_cable_delivery.h        |    7 ++-----
 lib/include/libdvbv5/desc_event_extended.h        |    7 ++-----
 lib/include/libdvbv5/desc_event_short.h           |    7 ++-----
 lib/include/libdvbv5/desc_extension.h             |    7 ++-----
 lib/include/libdvbv5/desc_frequency_list.h        |    7 ++-----
 lib/include/libdvbv5/desc_hierarchy.h             |    6 ++----
 lib/include/libdvbv5/desc_isdbt_delivery.h        |    8 +++-----
 lib/include/libdvbv5/desc_language.h              |    7 ++-----
 lib/include/libdvbv5/desc_logical_channel.h       |    7 ++-----
 lib/include/libdvbv5/desc_network_name.h          |    7 ++-----
 lib/include/libdvbv5/desc_partial_reception.h     |    7 ++-----
 lib/include/libdvbv5/desc_sat.h                   |    7 ++-----
 lib/include/libdvbv5/desc_service.h               |    7 ++-----
 lib/include/libdvbv5/desc_service_list.h          |    7 ++-----
 lib/include/libdvbv5/desc_service_location.h      |    7 ++-----
 lib/include/libdvbv5/desc_t2_delivery.h           |    5 +++--
 lib/include/libdvbv5/desc_terrestrial_delivery.h  |    7 ++-----
 lib/include/libdvbv5/desc_ts_info.h               |    7 ++-----
 lib/include/libdvbv5/descriptors.h                |    9 ++++++---
 22 files changed, 50 insertions(+), 104 deletions(-)

diff --git a/lib/include/libdvbv5/desc_atsc_service_location.h b/lib/include/libdvbv5/desc_atsc_service_location.h
index 1ff2341..ebe11b7 100644
--- a/lib/include/libdvbv5/desc_atsc_service_location.h
+++ b/lib/include/libdvbv5/desc_atsc_service_location.h
@@ -21,8 +21,7 @@
 #ifndef _ATSC_SERVICE_LOCATION_H
 #define _ATSC_SERVICE_LOCATION_H
 
-#include <stdint.h>
-#include <unistd.h> /* ssize_t */
+#include <libdvbv5/descriptors.h>
 
 struct atsc_desc_service_location_elementary {
 	uint8_t stream_type;
@@ -37,9 +36,7 @@ struct atsc_desc_service_location_elementary {
 } __attribute__((packed));
 
 struct atsc_desc_service_location {
-	uint8_t type;
-	uint8_t length;
-	struct dvb_desc *next;
+	DVB_DESC_HEADER();
 
 	struct atsc_desc_service_location_elementary *elementary;
 
diff --git a/lib/include/libdvbv5/desc_ca.h b/lib/include/libdvbv5/desc_ca.h
index 12f4ff3..49d346b 100644
--- a/lib/include/libdvbv5/desc_ca.h
+++ b/lib/include/libdvbv5/desc_ca.h
@@ -22,13 +22,10 @@
 #ifndef _CA_H
 #define _CA_H
 
-#include <stdint.h>
-#include <unistd.h> /* ssize_t */
+#include <libdvbv5/descriptors.h>
 
 struct dvb_desc_ca {
-	uint8_t type;
-	uint8_t length;
-	struct dvb_desc *next;
+	DVB_DESC_HEADER();
 
 	uint16_t ca_id;
 	union {
diff --git a/lib/include/libdvbv5/desc_ca_identifier.h b/lib/include/libdvbv5/desc_ca_identifier.h
index 18df191..1136a84 100644
--- a/lib/include/libdvbv5/desc_ca_identifier.h
+++ b/lib/include/libdvbv5/desc_ca_identifier.h
@@ -22,13 +22,10 @@
 #ifndef _CA_IDENTIFIER_H
 #define _CA_IDENTIFIER_H
 
-#include <stdint.h>
-#include <unistd.h> /* ssize_t */
+#include <libdvbv5/descriptors.h>
 
 struct dvb_desc_ca_identifier {
-	uint8_t type;
-	uint8_t length;
-	struct dvb_desc *next;
+	DVB_DESC_HEADER();
 
 	uint8_t caid_count;
 	uint16_t *caids;
diff --git a/lib/include/libdvbv5/desc_cable_delivery.h b/lib/include/libdvbv5/desc_cable_delivery.h
index c2bab5a..25d6ab2 100644
--- a/lib/include/libdvbv5/desc_cable_delivery.h
+++ b/lib/include/libdvbv5/desc_cable_delivery.h
@@ -23,13 +23,10 @@
 #ifndef _CABLE_DELIVERY_H
 #define _CABLE_DELIVERY_H
 
-#include <stdint.h>
-#include <unistd.h> /* ssize_t */
+#include <libdvbv5/descriptors.h>
 
 struct dvb_desc_cable_delivery {
-	uint8_t type;
-	uint8_t length;
-	struct dvb_desc *next;
+	DVB_DESC_HEADER();
 
 	uint32_t frequency;
 	union {
diff --git a/lib/include/libdvbv5/desc_event_extended.h b/lib/include/libdvbv5/desc_event_extended.h
index 03fb1f1..f816a2a 100644
--- a/lib/include/libdvbv5/desc_event_extended.h
+++ b/lib/include/libdvbv5/desc_event_extended.h
@@ -22,13 +22,10 @@
 #ifndef _DESC_EVENT_EXTENDED_H
 #define _DESC_EVENT_EXTENDED_H
 
-#include <stdint.h>
-#include <unistd.h> /* ssize_t */
+#include <libdvbv5/descriptors.h>
 
 struct dvb_desc_event_extended {
-	uint8_t type;
-	uint8_t length;
-	struct dvb_desc *next;
+	DVB_DESC_HEADER();
 
 	union {
 		struct {
diff --git a/lib/include/libdvbv5/desc_event_short.h b/lib/include/libdvbv5/desc_event_short.h
index 521fbca..68c7f64 100644
--- a/lib/include/libdvbv5/desc_event_short.h
+++ b/lib/include/libdvbv5/desc_event_short.h
@@ -22,13 +22,10 @@
 #ifndef _DESC_EVENT_SHORT_H
 #define _DESC_EVENT_SHORT_H
 
-#include <stdint.h>
-#include <unistd.h> /* ssize_t */
+#include <libdvbv5/descriptors.h>
 
 struct dvb_desc_event_short {
-	uint8_t type;
-	uint8_t length;
-	struct dvb_desc *next;
+	DVB_DESC_HEADER();
 
 	unsigned char language[4];
 	char *name;
diff --git a/lib/include/libdvbv5/desc_extension.h b/lib/include/libdvbv5/desc_extension.h
index 5921cba..c19ec70 100644
--- a/lib/include/libdvbv5/desc_extension.h
+++ b/lib/include/libdvbv5/desc_extension.h
@@ -21,8 +21,7 @@
 #ifndef _EXTENSION_DESC_H
 #define _EXTENSION_DESC_H
 
-#include <stdint.h>
-#include <unistd.h> /* ssize_t */
+#include <libdvbv5/descriptors.h>
 
 struct dvb_v5_fe_parms;
 
@@ -42,9 +41,7 @@ enum extension_descriptors {
 };
 
 struct dvb_extension_descriptor {
-	uint8_t type;
-	uint8_t length;
-	struct dvb_desc *next;
+	DVB_DESC_HEADER();
 
 	uint8_t extension_code;
 
diff --git a/lib/include/libdvbv5/desc_frequency_list.h b/lib/include/libdvbv5/desc_frequency_list.h
index 55723c7..ca155fa 100644
--- a/lib/include/libdvbv5/desc_frequency_list.h
+++ b/lib/include/libdvbv5/desc_frequency_list.h
@@ -22,13 +22,10 @@
 #ifndef _DESC_FREQUENCY_LIST_H
 #define _DESC_FREQUENCY_LIST_H
 
-#include <stdint.h>
-#include <unistd.h> /* ssize_t */
+#include <libdvbv5/descriptors.h>
 
 struct dvb_desc_frequency_list {
-	uint8_t type;
-	uint8_t length;
-	struct dvb_desc *next;
+	DVB_DESC_HEADER();
 
 	uint8_t frequencies;
 	uint32_t *frequency;
diff --git a/lib/include/libdvbv5/desc_hierarchy.h b/lib/include/libdvbv5/desc_hierarchy.h
index 9dd44c2..3b08d66 100644
--- a/lib/include/libdvbv5/desc_hierarchy.h
+++ b/lib/include/libdvbv5/desc_hierarchy.h
@@ -22,12 +22,10 @@
 #ifndef _HIERARCHY_H
 #define _HIERARCHY_H
 
-#include <stdint.h>
+#include <libdvbv5/descriptors.h>
 
 struct dvb_desc_hierarchy {
-	uint8_t type;
-	uint8_t length;
-	struct dvb_desc *next;
+	DVB_DESC_HEADER();
 
 	uint8_t hierarchy_type:4;
 	uint8_t reserved:4;
diff --git a/lib/include/libdvbv5/desc_isdbt_delivery.h b/lib/include/libdvbv5/desc_isdbt_delivery.h
index 5bac178..ae23475 100644
--- a/lib/include/libdvbv5/desc_isdbt_delivery.h
+++ b/lib/include/libdvbv5/desc_isdbt_delivery.h
@@ -22,13 +22,11 @@
 #ifndef _ISDBT_DELIVERY_H
 #define _ISDBT_DELIVERY_H
 
-#include <stdint.h>
-#include <unistd.h> /* ssize_t */
+#include <libdvbv5/descriptors.h>
 
 struct isdbt_desc_terrestrial_delivery_system {
-	uint8_t type;
-	uint8_t length;
-	struct dvb_desc *next;
+	DVB_DESC_HEADER();
+
 	uint16_t *frequency;
 	unsigned num_freqs;
 
diff --git a/lib/include/libdvbv5/desc_language.h b/lib/include/libdvbv5/desc_language.h
index 44fe1a4..f8b9634 100644
--- a/lib/include/libdvbv5/desc_language.h
+++ b/lib/include/libdvbv5/desc_language.h
@@ -22,13 +22,10 @@
 #ifndef _DESC_LANGUAGE_H
 #define _DESC_LANGUAGE_H
 
-#include <stdint.h>
-#include <unistd.h> /* ssize_t */
+#include <libdvbv5/descriptors.h>
 
 struct dvb_desc_language {
-	uint8_t type;
-	uint8_t length;
-	struct dvb_desc *next;
+	DVB_DESC_HEADER();
 
 	unsigned char language[4];
 	uint8_t audio_type;
diff --git a/lib/include/libdvbv5/desc_logical_channel.h b/lib/include/libdvbv5/desc_logical_channel.h
index bbccb81..28a6ac4 100644
--- a/lib/include/libdvbv5/desc_logical_channel.h
+++ b/lib/include/libdvbv5/desc_logical_channel.h
@@ -25,8 +25,7 @@
 #ifndef _LCN_DESC_H
 #define _LCN_DESC_H
 
-#include <stdint.h>
-#include <unistd.h> /* ssize_t */
+#include <libdvbv5/descriptors.h>
 
 struct dvb_desc_logical_channel_number {
 	uint16_t service_id;
@@ -41,9 +40,7 @@ struct dvb_desc_logical_channel_number {
 } __attribute__((packed));
 
 struct dvb_desc_logical_channel {
-	uint8_t type;
-	uint8_t length;
-	struct dvb_desc *next;
+	DVB_DESC_HEADER();
 
 	struct dvb_desc_logical_channel_number *lcn;
 } __attribute__((packed));
diff --git a/lib/include/libdvbv5/desc_network_name.h b/lib/include/libdvbv5/desc_network_name.h
index 060b2e8..20e23a7 100644
--- a/lib/include/libdvbv5/desc_network_name.h
+++ b/lib/include/libdvbv5/desc_network_name.h
@@ -22,13 +22,10 @@
 #ifndef _DESC_NETWORK_NAME_H
 #define _DESC_NETWORK_NAME_H
 
-#include <stdint.h>
-#include <unistd.h> /* ssize_t */
+#include <libdvbv5/descriptors.h>
 
 struct dvb_desc_network_name {
-	uint8_t type;
-	uint8_t length;
-	struct dvb_desc *next;
+	DVB_DESC_HEADER();
 
 	char *network_name;
 	char *network_name_emph;
diff --git a/lib/include/libdvbv5/desc_partial_reception.h b/lib/include/libdvbv5/desc_partial_reception.h
index c6c45f7..3f40e5f 100644
--- a/lib/include/libdvbv5/desc_partial_reception.h
+++ b/lib/include/libdvbv5/desc_partial_reception.h
@@ -25,17 +25,14 @@
 #ifndef _PARTIAL_RECEPTION_H
 #define _PARTIAL_RECEPTION_H
 
-#include <stdint.h>
-#include <unistd.h> /* ssize_t */
+#include <libdvbv5/descriptors.h>
 
 struct isdb_partial_reception_service_id {
 	uint16_t service_id;
 } __attribute__((packed));
 
 struct isdb_desc_partial_reception {
-	uint8_t type;
-	uint8_t length;
-	struct dvb_desc *next;
+	DVB_DESC_HEADER();
 
 	struct isdb_partial_reception_service_id *partial_reception;
 } __attribute__((packed));
diff --git a/lib/include/libdvbv5/desc_sat.h b/lib/include/libdvbv5/desc_sat.h
index 9e192c6..8f2b1a6 100644
--- a/lib/include/libdvbv5/desc_sat.h
+++ b/lib/include/libdvbv5/desc_sat.h
@@ -22,13 +22,10 @@
 #ifndef _SAT_H
 #define _SAT_H
 
-#include <stdint.h>
-#include <unistd.h> /* ssize_t */
+#include <libdvbv5/descriptors.h>
 
 struct dvb_desc_sat {
-	uint8_t type;
-	uint8_t length;
-	struct dvb_desc *next;
+	DVB_DESC_HEADER();
 
 	uint32_t frequency;
 	uint16_t orbit;
diff --git a/lib/include/libdvbv5/desc_service.h b/lib/include/libdvbv5/desc_service.h
index 8f269aa..dc26eac 100644
--- a/lib/include/libdvbv5/desc_service.h
+++ b/lib/include/libdvbv5/desc_service.h
@@ -22,13 +22,10 @@
 #ifndef _DESC_SERVICE_H
 #define _DESC_SERVICE_H
 
-#include <stdint.h>
-#include <unistd.h> /* ssize_t */
+#include <libdvbv5/descriptors.h>
 
 struct dvb_desc_service {
-	uint8_t type;
-	uint8_t length;
-	struct dvb_desc *next;
+	DVB_DESC_HEADER();
 
 	uint8_t service_type;
 	char *name;
diff --git a/lib/include/libdvbv5/desc_service_list.h b/lib/include/libdvbv5/desc_service_list.h
index 8e7d73f..0dc34c0 100644
--- a/lib/include/libdvbv5/desc_service_list.h
+++ b/lib/include/libdvbv5/desc_service_list.h
@@ -22,8 +22,7 @@
 #ifndef _DESC_SERVICE_LIST_H
 #define _DESC_SERVICE_LIST_H
 
-#include <stdint.h>
-#include <unistd.h> /* ssize_t */
+#include <libdvbv5/descriptors.h>
 
 struct dvb_desc_service_list_table {
 	uint16_t service_id;
@@ -31,9 +30,7 @@ struct dvb_desc_service_list_table {
 } __attribute__((packed));
 
 struct dvb_desc_service_list {
-	uint8_t type;
-	uint8_t length;
-	struct dvb_desc *next;
+	DVB_DESC_HEADER();
 
 	//struct dvb_desc_service_list_table services[];
 } __attribute__((packed));
diff --git a/lib/include/libdvbv5/desc_service_location.h b/lib/include/libdvbv5/desc_service_location.h
index 046bedc..958dd04 100644
--- a/lib/include/libdvbv5/desc_service_location.h
+++ b/lib/include/libdvbv5/desc_service_location.h
@@ -21,8 +21,7 @@
 #ifndef _SERVICE_LOCATION_H
 #define _SERVICE_LOCATION_H
 
-#include <stdint.h>
-#include <unistd.h> /* ssize_t */
+#include <libdvbv5/descriptors.h>
 
 struct dvb_desc_service_location_element {
 	uint8_t stream_type;
@@ -37,9 +36,7 @@ struct dvb_desc_service_location_element {
 } __attribute__((packed));
 
 struct dvb_desc_service_location {
-	uint8_t type;
-	uint8_t length;
-	struct dvb_desc *next;
+	DVB_DESC_HEADER();
 
 	union {
 		uint16_t bitfield;
diff --git a/lib/include/libdvbv5/desc_t2_delivery.h b/lib/include/libdvbv5/desc_t2_delivery.h
index a51f897..ed0d7a3 100644
--- a/lib/include/libdvbv5/desc_t2_delivery.h
+++ b/lib/include/libdvbv5/desc_t2_delivery.h
@@ -22,8 +22,7 @@
 #ifndef _T2_DELIVERY_H
 #define _T2_DELIVERY_H
 
-#include <stdint.h>
-#include <unistd.h> /* ssize_t */
+#include <libdvbv5/descriptors.h>
 
 struct dvb_desc_t2_delivery_subcell {
 	uint8_t cell_id_extension;
@@ -31,6 +30,8 @@ struct dvb_desc_t2_delivery_subcell {
 } __attribute__((packed));
 
 struct dvb_desc_t2_delivery {
+	/* extended descriptor */
+
 	uint8_t plp_id;
 	uint16_t system_id;
 	union {
diff --git a/lib/include/libdvbv5/desc_terrestrial_delivery.h b/lib/include/libdvbv5/desc_terrestrial_delivery.h
index 9404169..72e449e 100644
--- a/lib/include/libdvbv5/desc_terrestrial_delivery.h
+++ b/lib/include/libdvbv5/desc_terrestrial_delivery.h
@@ -24,13 +24,10 @@
 #ifndef _TERRESTRIAL_DELIVERY_H
 #define _TERRESTRIAL_DELIVERY_H
 
-#include <stdint.h>
-#include <unistd.h> /* ssize_t */
+#include <libdvbv5/descriptors.h>
 
 struct dvb_desc_terrestrial_delivery {
-	uint8_t type;
-	uint8_t length;
-	struct dvb_desc *next;
+	DVB_DESC_HEADER();
 
 	uint32_t centre_frequency;
 	uint8_t reserved_future_use1:2;
diff --git a/lib/include/libdvbv5/desc_ts_info.h b/lib/include/libdvbv5/desc_ts_info.h
index 523aa04..60eed5d 100644
--- a/lib/include/libdvbv5/desc_ts_info.h
+++ b/lib/include/libdvbv5/desc_ts_info.h
@@ -22,8 +22,7 @@
 #ifndef _TS_INFO_H
 #define _TS_INFO_H
 
-#include <stdint.h>
-#include <unistd.h> /* ssize_t */
+#include <libdvbv5/descriptors.h>
 
 struct dvb_desc_ts_info_transmission_type {
 	uint8_t transmission_type_info;
@@ -31,9 +30,7 @@ struct dvb_desc_ts_info_transmission_type {
 } __attribute__((packed));
 
 struct dvb_desc_ts_info {
-	uint8_t type;
-	uint8_t length;
-	struct dvb_desc *next;
+	DVB_DESC_HEADER();
 
 	char *ts_name, *ts_name_emph;
 	struct dvb_desc_ts_info_transmission_type transmission_type;
diff --git a/lib/include/libdvbv5/descriptors.h b/lib/include/libdvbv5/descriptors.h
index 36bcc61..ae33fda 100644
--- a/lib/include/libdvbv5/descriptors.h
+++ b/lib/include/libdvbv5/descriptors.h
@@ -54,10 +54,13 @@ extern char *output_charset;
 	b = ntohl(b); \
 } while (0)
 
+#define DVB_DESC_HEADER() \
+	uint8_t type; \
+	uint8_t length; \
+	struct dvb_desc *next
+
 struct dvb_desc {
-	uint8_t type;
-	uint8_t length;
-	struct dvb_desc *next;
+	DVB_DESC_HEADER();
 
 	uint8_t data[];
 } __attribute__((packed));
-- 
1.7.10.4

