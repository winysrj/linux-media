Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41102 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030302Ab2HHNxs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2012 09:53:48 -0400
Received: by wibhr14 with SMTP id hr14so726583wib.1
        for <linux-media@vger.kernel.org>; Wed, 08 Aug 2012 06:53:46 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 8/8] libdvbv5: descriptor allocation and freeing
Date: Wed,  8 Aug 2012 15:53:17 +0200
Message-Id: <1344433997-9832-2-git-send-email-neolynx@gmail.com>
In-Reply-To: <1344433997-9832-1-git-send-email-neolynx@gmail.com>
References: <1344433997-9832-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/descriptors.h                          |   10 +-
 lib/include/descriptors/desc_cable_delivery.h      |    4 +-
 lib/include/descriptors/desc_event_extended.h      |    6 +-
 lib/include/descriptors/desc_event_short.h         |    6 +-
 lib/include/descriptors/desc_frequency_list.h      |    8 +-
 lib/include/descriptors/desc_hierarchy.h           |   58 ++++
 lib/include/descriptors/desc_language.h            |    4 +-
 lib/include/descriptors/desc_network_name.h        |    8 +-
 lib/include/descriptors/desc_sat.h                 |    4 +-
 lib/include/descriptors/desc_service.h             |    6 +-
 lib/include/descriptors/desc_service_list.h        |    6 +-
 .../descriptors/desc_terrestrial_delivery.h        |    4 +-
 lib/include/descriptors/pmt.h                      |   28 ++
 lib/libdvbv5/Makefile.am                           |    1 +
 lib/libdvbv5/descriptors.c                         |  316 ++++++++++----------
 lib/libdvbv5/descriptors/desc_cable_delivery.c     |    4 +-
 lib/libdvbv5/descriptors/desc_event_extended.c     |    4 +-
 lib/libdvbv5/descriptors/desc_event_short.c        |    4 +-
 lib/libdvbv5/descriptors/desc_frequency_list.c     |   50 ++--
 lib/libdvbv5/descriptors/desc_hierarchy.c          |   44 +++
 lib/libdvbv5/descriptors/desc_language.c           |    4 +-
 lib/libdvbv5/descriptors/desc_network_name.c       |   21 +-
 lib/libdvbv5/descriptors/desc_sat.c                |    4 +-
 lib/libdvbv5/descriptors/desc_service.c            |    6 +-
 lib/libdvbv5/descriptors/desc_service_list.c       |   39 ++--
 .../descriptors/desc_terrestrial_delivery.c        |    4 +-
 lib/libdvbv5/descriptors/pmt.c                     |   28 ++-
 lib/libdvbv5/dvb-scan.c                            |    4 +-
 28 files changed, 413 insertions(+), 272 deletions(-)
 create mode 100644 lib/include/descriptors/desc_hierarchy.h
 create mode 100644 lib/libdvbv5/descriptors/desc_hierarchy.c

diff --git a/lib/include/descriptors.h b/lib/include/descriptors.h
index b1a8e84..9039014 100644
--- a/lib/include/descriptors.h
+++ b/lib/include/descriptors.h
@@ -61,7 +61,7 @@ struct dvb_desc {
 	uint8_t data[];
 } __attribute__((packed));
 
-ssize_t dvb_desc_default_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+void dvb_desc_default_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
 void dvb_desc_default_print  (struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
 
 #define dvb_desc_foreach( _desc, _tbl ) \
@@ -83,16 +83,16 @@ void dvb_print_descriptors(struct dvb_v5_fe_parms *parms, struct dvb_desc *desc)
 
 struct dvb_v5_fe_parms;
 
-typedef ssize_t (*dvb_desc_init_func)(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+typedef void (*dvb_desc_init_func) (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
 typedef void (*dvb_desc_print_func)(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
-typedef void (*dvb_desc_free_func)(struct dvb_desc *desc);
+typedef void (*dvb_desc_free_func) (struct dvb_desc *desc);
 
 struct dvb_descriptor {
 	const char *name;
 	dvb_desc_init_func init;
 	dvb_desc_print_func print;
 	dvb_desc_free_func free;
-	ssize_t desc_size;
+	ssize_t size;
 };
 
 extern const struct dvb_descriptor dvb_descriptors[];
@@ -257,7 +257,7 @@ enum descriptors {
 	connected_transmission_descriptor		= 0xdd,
 	content_availability_descriptor			= 0xde,
 	service_group_descriptor			= 0xe0,
-	carousel_compatible_composite_Descriptor	= 0xf7,
+	carousel_compatible_composite_descriptor	= 0xf7,
 	conditional_playback_descriptor			= 0xf8,
 	ISDBT_delivery_system_descriptor		= 0xfa,
 	partial_reception_descriptor			= 0xfb,
diff --git a/lib/include/descriptors/desc_cable_delivery.h b/lib/include/descriptors/desc_cable_delivery.h
index bdbe706..86f2caa 100644
--- a/lib/include/descriptors/desc_cable_delivery.h
+++ b/lib/include/descriptors/desc_cable_delivery.h
@@ -54,8 +54,8 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-ssize_t dvb_desc_cable_delivery_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
-void dvb_desc_cable_delivery_print  (struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+void dvb_desc_cable_delivery_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+void dvb_desc_cable_delivery_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
 
 #ifdef __cplusplus
 }
diff --git a/lib/include/descriptors/desc_event_extended.h b/lib/include/descriptors/desc_event_extended.h
index 05a83f3..a543590 100644
--- a/lib/include/descriptors/desc_event_extended.h
+++ b/lib/include/descriptors/desc_event_extended.h
@@ -49,9 +49,9 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-ssize_t dvb_desc_event_extended_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
-void dvb_desc_event_extended_print  (struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
-void dvb_desc_event_extended_free   (struct dvb_desc *desc);
+void dvb_desc_event_extended_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+void dvb_desc_event_extended_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+void dvb_desc_event_extended_free (struct dvb_desc *desc);
 
 #ifdef __cplusplus
 }
diff --git a/lib/include/descriptors/desc_event_short.h b/lib/include/descriptors/desc_event_short.h
index d597977..521fbca 100644
--- a/lib/include/descriptors/desc_event_short.h
+++ b/lib/include/descriptors/desc_event_short.h
@@ -43,9 +43,9 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-ssize_t dvb_desc_event_short_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
-void dvb_desc_event_short_print  (struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
-void dvb_desc_event_short_free   (struct dvb_desc *desc);
+void dvb_desc_event_short_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+void dvb_desc_event_short_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+void dvb_desc_event_short_free (struct dvb_desc *desc);
 
 #ifdef __cplusplus
 }
diff --git a/lib/include/descriptors/desc_frequency_list.h b/lib/include/descriptors/desc_frequency_list.h
index 80a7fb9..15f06de 100644
--- a/lib/include/descriptors/desc_frequency_list.h
+++ b/lib/include/descriptors/desc_frequency_list.h
@@ -37,8 +37,8 @@ struct dvb_desc_frequency_list {
 			uint8_t reserved:6;
 		};
 	};
-	uint8_t frequencies;
-	uint32_t frequency[];
+	//uint8_t frequencies; // FIXME: make linked list
+	//uint32_t *frequency[];
 } __attribute__((packed));
 
 struct dvb_v5_fe_parms;
@@ -47,8 +47,8 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-ssize_t dvb_desc_frequency_list_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
-void dvb_desc_frequency_list_print  (struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+void dvb_desc_frequency_list_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+void dvb_desc_frequency_list_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
 
 #ifdef __cplusplus
 }
diff --git a/lib/include/descriptors/desc_hierarchy.h b/lib/include/descriptors/desc_hierarchy.h
new file mode 100644
index 0000000..9dd44c2
--- /dev/null
+++ b/lib/include/descriptors/desc_hierarchy.h
@@ -0,0 +1,58 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#ifndef _HIERARCHY_H
+#define _HIERARCHY_H
+
+#include <stdint.h>
+
+struct dvb_desc_hierarchy {
+	uint8_t type;
+	uint8_t length;
+	struct dvb_desc *next;
+
+	uint8_t hierarchy_type:4;
+	uint8_t reserved:4;
+
+	uint8_t layer:6;
+	uint8_t reserved2:2;
+
+	uint8_t embedded_layer:6;
+	uint8_t reserved3:2;
+
+	uint8_t channel:6;
+	uint8_t reserved4:2;
+} __attribute__((packed));
+
+struct dvb_v5_fe_parms;
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+void dvb_desc_hierarchy_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+void dvb_desc_hierarchy_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/include/descriptors/desc_language.h b/lib/include/descriptors/desc_language.h
index 8829bf1..44fe1a4 100644
--- a/lib/include/descriptors/desc_language.h
+++ b/lib/include/descriptors/desc_language.h
@@ -40,8 +40,8 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-ssize_t dvb_desc_language_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
-void dvb_desc_language_print  (struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+void dvb_desc_language_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+void dvb_desc_language_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
 
 #ifdef __cplusplus
 }
diff --git a/lib/include/descriptors/desc_network_name.h b/lib/include/descriptors/desc_network_name.h
index ece0fd9..060b2e8 100644
--- a/lib/include/descriptors/desc_network_name.h
+++ b/lib/include/descriptors/desc_network_name.h
@@ -30,7 +30,8 @@ struct dvb_desc_network_name {
 	uint8_t length;
 	struct dvb_desc *next;
 
-	unsigned char network_name[];
+	char *network_name;
+	char *network_name_emph;
 } __attribute__((packed));
 
 struct dvb_v5_fe_parms;
@@ -39,8 +40,9 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-ssize_t dvb_desc_network_name_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
-void dvb_desc_network_name_print  (struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+void dvb_desc_network_name_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+void dvb_desc_network_name_free (struct dvb_desc *desc);
+void dvb_desc_network_name_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
 
 #ifdef __cplusplus
 }
diff --git a/lib/include/descriptors/desc_sat.h b/lib/include/descriptors/desc_sat.h
index 820d8f1..5e0b3cb 100644
--- a/lib/include/descriptors/desc_sat.h
+++ b/lib/include/descriptors/desc_sat.h
@@ -52,8 +52,8 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-ssize_t dvb_desc_sat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
-void dvb_desc_sat_print  (struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+void dvb_desc_sat_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+void dvb_desc_sat_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
 
 #ifdef __cplusplus
 }
diff --git a/lib/include/descriptors/desc_service.h b/lib/include/descriptors/desc_service.h
index f3ce977..8f269aa 100644
--- a/lib/include/descriptors/desc_service.h
+++ b/lib/include/descriptors/desc_service.h
@@ -43,9 +43,9 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-ssize_t dvb_desc_service_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
-void dvb_desc_service_print  (struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
-void dvb_desc_service_free   (struct dvb_desc *desc);
+void dvb_desc_service_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+void dvb_desc_service_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+void dvb_desc_service_free (struct dvb_desc *desc);
 
 #ifdef __cplusplus
 }
diff --git a/lib/include/descriptors/desc_service_list.h b/lib/include/descriptors/desc_service_list.h
index 919623f..8e7d73f 100644
--- a/lib/include/descriptors/desc_service_list.h
+++ b/lib/include/descriptors/desc_service_list.h
@@ -35,7 +35,7 @@ struct dvb_desc_service_list {
 	uint8_t length;
 	struct dvb_desc *next;
 
-	struct dvb_desc_service_list_table services[];
+	//struct dvb_desc_service_list_table services[];
 } __attribute__((packed));
 
 struct dvb_v5_fe_parms;
@@ -44,8 +44,8 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-ssize_t dvb_desc_service_list_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
-void dvb_desc_service_list_print  (struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+void dvb_desc_service_list_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+void dvb_desc_service_list_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
 
 #ifdef __cplusplus
 }
diff --git a/lib/include/descriptors/desc_terrestrial_delivery.h b/lib/include/descriptors/desc_terrestrial_delivery.h
index 482f4b0..c142844 100644
--- a/lib/include/descriptors/desc_terrestrial_delivery.h
+++ b/lib/include/descriptors/desc_terrestrial_delivery.h
@@ -52,8 +52,8 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-ssize_t dvb_desc_terrestrial_delivery_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
-void dvb_desc_terrestrial_delivery_print  (struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+void dvb_desc_terrestrial_delivery_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+void dvb_desc_terrestrial_delivery_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
 
 #ifdef __cplusplus
 }
diff --git a/lib/include/descriptors/pmt.h b/lib/include/descriptors/pmt.h
index 504ae67..3a585fa 100644
--- a/lib/include/descriptors/pmt.h
+++ b/lib/include/descriptors/pmt.h
@@ -29,6 +29,34 @@
 
 #define DVB_TABLE_PMT      2
 
+enum dvb_streams {
+	stream_reserved0	= 0x00, // ITU-T | ISO/IEC Reserved
+	stream_video		= 0x01, // ISO/IEC 11172 Video
+	stream_video_h262	= 0x02, // ITU-T Rec. H.262 | ISO/IEC 13818-2 Video or ISO/IEC 11172-2 constrained parameter video stream
+	stream_audio		= 0x03, // ISO/IEC 11172 Audio
+	stream_audio_13818_3	= 0x04, // ISO/IEC 13818-3 Audio
+	stream_private_sections	= 0x05, // ITU-T Rec. H.222.0 | ISO/IEC 13818-1 private_sections
+	stream_private_data	= 0x06, // ITU-T Rec. H.222.0 | ISO/IEC 13818-1 PES packets containing private data
+	stream_mheg		= 0x07, // ISO/IEC 13522 MHEG
+	stream_h222		= 0x08, // ITU-T Rec. H.222.0 | ISO/IEC 13818-1 Annex A DSM-CC
+	stream_h222_1		= 0x09, // ITU-T Rec. H.222.1
+	stream_13818_6_A	= 0x0A, // ISO/IEC 13818-6 type A
+	stream_13818_6_B	= 0x0B, // ISO/IEC 13818-6 type B
+	stream_13818_6_C	= 0x0C, // ISO/IEC 13818-6 type C
+	stream_13818_6_D	= 0x0D, // ISO/IEC 13818-6 type D
+	stream_h222_aux		= 0x0E, // ITU-T Rec. H.222.0 | ISO/IEC 13818-1 auxiliary
+	stream_audio_adts	= 0x0F, // ISO/IEC 13818-7 Audio with ADTS transport syntax
+	stream_video_14496_2	= 0x10, // ISO/IEC 14496-2 Visual
+	stream_audio_latm	= 0x11, // ISO/IEC 14496-3 Audio with the LATM transport syntax as defined in ISO/IEC 14496-3 / AMD 1
+	stream_14496_1_pes	= 0x12, // ISO/IEC 14496-1 SL-packetized stream or FlexMux stream carried in PES packets
+	stream_14496_1_iso	= 0x13, // ISO/IEC 14496-1 SL-packetized stream or FlexMux stream carried in ISO/IEC14496_sections.
+	stream_download		= 0x14, // ISO/IEC 13818-6 Synchronized Download Protocol
+	stream_reserved		= 0x15, // - 0x7F, ITU-T Rec. H.222.0 | ISO/IEC 13818-1 Reserved
+	stream_private		= 0x80  // - 0xFF, User Private
+};
+
+extern const char *pmt_stream_name[];
+
 struct dvb_table_pmt_stream {
 	uint8_t type;
 	union {
diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
index ff6b863..617074c 100644
--- a/lib/libdvbv5/Makefile.am
+++ b/lib/libdvbv5/Makefile.am
@@ -36,6 +36,7 @@ libdvbv5_la_SOURCES = \
   descriptors/desc_service_list.c  ../include/descriptors/desc_service_list.h \
   descriptors/desc_event_short.c  ../include/descriptors/desc_event_short.h \
   descriptors/desc_event_extended.c  ../include/descriptors/desc_event_extended.h \
+  descriptors/desc_hierarchy.c  ../include/descriptors/desc_hierarchy.h \
   descriptors/nit.c  ../include/descriptors/nit.h \
   descriptors/sdt.c  ../include/descriptors/sdt.h \
   descriptors/eit.c  ../include/descriptors/eit.h
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index 10a61a3..73338d8 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -45,6 +45,7 @@
 #include "descriptors/desc_frequency_list.h"
 #include "descriptors/desc_event_short.h"
 #include "descriptors/desc_event_extended.h"
+#include "descriptors/desc_hierarchy.h"
 
 ssize_t dvb_desc_init(const uint8_t *buf, struct dvb_desc *desc)
 {
@@ -54,10 +55,9 @@ ssize_t dvb_desc_init(const uint8_t *buf, struct dvb_desc *desc)
 	return 2;
 }
 
-ssize_t dvb_desc_default_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+void dvb_desc_default_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	memcpy(desc->data, buf, desc->length);
-	return sizeof(struct dvb_desc) + desc->length;
 }
 
 void dvb_desc_default_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
@@ -91,13 +91,23 @@ void dvb_parse_descriptors(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ui
 	struct dvb_desc *current = NULL;
 	struct dvb_desc *last = NULL;
 	while (ptr < buf + section_length) {
-		current = (struct dvb_desc *) malloc(section_length << 2);
-		ptr += dvb_desc_init(ptr, current); /* the standard header was read */
-		dvb_desc_init_func init = dvb_descriptors[current->type].init;
-		if (!init)
+		int desc_type = ptr[0];
+		int desc_len  = ptr[1];
+		size_t size;
+		dvb_desc_init_func init = dvb_descriptors[desc_type].init;
+		if (!init) {
 			init = dvb_desc_default_init;
-		ssize_t len = init(parms, ptr, current);
-		current = (struct dvb_desc *) realloc(current, len);
+			size = sizeof(struct dvb_desc) + desc_len;
+		} else {
+			size = dvb_descriptors[desc_type].size;
+		}
+		if (!size) {
+			dvb_logerr("descriptor type %d has no size defined", current->type);
+			size = 4096;
+		}
+		current = (struct dvb_desc *) malloc(size);
+		ptr += dvb_desc_init(ptr, current); /* the standard header was read */
+		init(parms, ptr, current);
 		if(!*head_desc)
 			*head_desc = current;
 		if (last)
@@ -133,155 +143,155 @@ void dvb_free_descriptors(struct dvb_desc **list)
 }
 
 const struct dvb_descriptor dvb_descriptors[] = {
-	[0 ...255 ] = { "Unknown descriptor", NULL, NULL, NULL },
-	[video_stream_descriptor] = { "video_stream_descriptor", NULL, NULL, NULL },
-	[audio_stream_descriptor] = { "audio_stream_descriptor", NULL, NULL, NULL },
-	[hierarchy_descriptor] = { "hierarchy_descriptor", NULL, NULL, NULL },
-	[registration_descriptor] = { "registration_descriptor", NULL, NULL, NULL },
-	[ds_alignment_descriptor] = { "ds_alignment_descriptor", NULL, NULL, NULL },
-	[target_background_grid_descriptor] = { "target_background_grid_descriptor", NULL, NULL, NULL },
-	[video_window_descriptor] = { "video_window_descriptor", NULL, NULL, NULL },
-	[conditional_access_descriptor] = { "conditional_access_descriptor", NULL, NULL, NULL },
-	[iso639_language_descriptor] = { "iso639_language_descriptor", dvb_desc_language_init, dvb_desc_language_print, NULL },
-	[system_clock_descriptor] = { "system_clock_descriptor", NULL, NULL, NULL },
-	[multiplex_buffer_utilization_descriptor] = { "multiplex_buffer_utilization_descriptor", NULL, NULL, NULL },
-	[copyright_descriptor] = { "copyright_descriptor", NULL, NULL, NULL },
-	[maximum_bitrate_descriptor] = { "maximum_bitrate_descriptor", NULL, NULL, NULL },
-	[private_data_indicator_descriptor] = { "private_data_indicator_descriptor", NULL, NULL, NULL },
-	[smoothing_buffer_descriptor] = { "smoothing_buffer_descriptor", NULL, NULL, NULL },
-	[std_descriptor] = { "std_descriptor", NULL, NULL, NULL },
-	[ibp_descriptor] = { "ibp_descriptor", NULL, NULL, NULL },
-	[mpeg4_video_descriptor] = { "mpeg4_video_descriptor", NULL, NULL, NULL },
-	[mpeg4_audio_descriptor] = { "mpeg4_audio_descriptor", NULL, NULL, NULL },
-	[iod_descriptor] = { "iod_descriptor", NULL, NULL, NULL },
-	[sl_descriptor] = { "sl_descriptor", NULL, NULL, NULL },
-	[fmc_descriptor] = { "fmc_descriptor", NULL, NULL, NULL },
-	[external_es_id_descriptor] = { "external_es_id_descriptor", NULL, NULL, NULL },
-	[muxcode_descriptor] = { "muxcode_descriptor", NULL, NULL, NULL },
-	[fmxbuffersize_descriptor] = { "fmxbuffersize_descriptor", NULL, NULL, NULL },
-	[multiplexbuffer_descriptor] = { "multiplexbuffer_descriptor", NULL, NULL, NULL },
-	[content_labeling_descriptor] = { "content_labeling_descriptor", NULL, NULL, NULL },
-	[metadata_pointer_descriptor] = { "metadata_pointer_descriptor", NULL, NULL, NULL },
-	[metadata_descriptor] = { "metadata_descriptor", NULL, NULL, NULL },
-	[metadata_std_descriptor] = { "metadata_std_descriptor", NULL, NULL, NULL },
-	[AVC_video_descriptor] = { "AVC_video_descriptor", NULL, NULL, NULL },
-	[ipmp_descriptor] = { "ipmp_descriptor", NULL, NULL, NULL },
-	[AVC_timing_and_HRD_descriptor] = { "AVC_timing_and_HRD_descriptor", NULL, NULL, NULL },
-	[mpeg2_aac_audio_descriptor] = { "mpeg2_aac_audio_descriptor", NULL, NULL, NULL },
-	[flexmux_timing_descriptor] = { "flexmux_timing_descriptor", NULL, NULL, NULL },
-	[network_name_descriptor] = { "network_name_descriptor", dvb_desc_network_name_init, dvb_desc_network_name_print, NULL },
-	[service_list_descriptor] = { "service_list_descriptor", dvb_desc_service_list_init, dvb_desc_service_list_print, NULL },
-	[stuffing_descriptor] = { "stuffing_descriptor", NULL, NULL, NULL },
-	[satellite_delivery_system_descriptor] = { "satellite_delivery_system_descriptor", dvb_desc_sat_init, dvb_desc_sat_print, NULL },
-	[cable_delivery_system_descriptor] = { "cable_delivery_system_descriptor", dvb_desc_cable_delivery_init, dvb_desc_cable_delivery_print, NULL },
-	[VBI_data_descriptor] = { "VBI_data_descriptor", NULL, NULL, NULL },
-	[VBI_teletext_descriptor] = { "VBI_teletext_descriptor", NULL, NULL, NULL },
-	[bouquet_name_descriptor] = { "bouquet_name_descriptor", NULL, NULL, NULL },
-	[service_descriptor] = { "service_descriptor", dvb_desc_service_init, dvb_desc_service_print, dvb_desc_service_free },
-	[country_availability_descriptor] = { "country_availability_descriptor", NULL, NULL, NULL },
-	[linkage_descriptor] = { "linkage_descriptor", NULL, NULL, NULL },
-	[NVOD_reference_descriptor] = { "NVOD_reference_descriptor", NULL, NULL, NULL },
-	[time_shifted_service_descriptor] = { "time_shifted_service_descriptor", NULL, NULL, NULL },
-	[short_event_descriptor] = { "short_event_descriptor", dvb_desc_event_short_init, dvb_desc_event_short_print, dvb_desc_event_short_free },
-	[extended_event_descriptor] = { "extended_event_descriptor", dvb_desc_event_extended_init, dvb_desc_event_extended_print, dvb_desc_event_extended_free },
-	[time_shifted_event_descriptor] = { "time_shifted_event_descriptor", NULL, NULL, NULL },
-	[component_descriptor] = { "component_descriptor", NULL, NULL, NULL },
-	[mosaic_descriptor] = { "mosaic_descriptor", NULL, NULL, NULL },
-	[stream_identifier_descriptor] = { "stream_identifier_descriptor", NULL, NULL, NULL },
-	[CA_identifier_descriptor] = { "CA_identifier_descriptor", NULL, NULL, NULL },
-	[content_descriptor] = { "content_descriptor", NULL, NULL, NULL },
-	[parental_rating_descriptor] = { "parental_rating_descriptor", NULL, NULL, NULL },
-	[teletext_descriptor] = { "teletext_descriptor", NULL, NULL, NULL },
-	[telephone_descriptor] = { "telephone_descriptor", NULL, NULL, NULL },
-	[local_time_offset_descriptor] = { "local_time_offset_descriptor", NULL, NULL, NULL },
-	[subtitling_descriptor] = { "subtitling_descriptor", NULL, NULL, NULL },
-	[terrestrial_delivery_system_descriptor] = { "terrestrial_delivery_system_descriptor", dvb_desc_terrestrial_delivery_init, dvb_desc_terrestrial_delivery_print, NULL },
-	[multilingual_network_name_descriptor] = { "multilingual_network_name_descriptor", NULL, NULL, NULL },
-	[multilingual_bouquet_name_descriptor] = { "multilingual_bouquet_name_descriptor", NULL, NULL, NULL },
-	[multilingual_service_name_descriptor] = { "multilingual_service_name_descriptor", NULL, NULL, NULL },
-	[multilingual_component_descriptor] = { "multilingual_component_descriptor", NULL, NULL, NULL },
-	[private_data_specifier_descriptor] = { "private_data_specifier_descriptor", NULL, NULL, NULL },
-	[service_move_descriptor] = { "service_move_descriptor", NULL, NULL, NULL },
-	[short_smoothing_buffer_descriptor] = { "short_smoothing_buffer_descriptor", NULL, NULL, NULL },
-	[frequency_list_descriptor] = { "frequency_list_descriptor", dvb_desc_frequency_list_init, dvb_desc_frequency_list_print, NULL },
-	[partial_transport_stream_descriptor] = { "partial_transport_stream_descriptor", NULL, NULL, NULL },
-	[data_broadcast_descriptor] = { "data_broadcast_descriptor", NULL, NULL, NULL },
-	[scrambling_descriptor] = { "scrambling_descriptor", NULL, NULL, NULL },
-	[data_broadcast_id_descriptor] = { "data_broadcast_id_descriptor", NULL, NULL, NULL },
-	[transport_stream_descriptor] = { "transport_stream_descriptor", NULL, NULL, NULL },
-	[DSNG_descriptor] = { "DSNG_descriptor", NULL, NULL, NULL },
-	[PDC_descriptor] = { "PDC_descriptor", NULL, NULL, NULL },
-	[AC_3_descriptor] = { "AC_3_descriptor", NULL, NULL, NULL },
-	[ancillary_data_descriptor] = { "ancillary_data_descriptor", NULL, NULL, NULL },
-	[cell_list_descriptor] = { "cell_list_descriptor", NULL, NULL, NULL },
-	[cell_frequency_link_descriptor] = { "cell_frequency_link_descriptor", NULL, NULL, NULL },
-	[announcement_support_descriptor] = { "announcement_support_descriptor", NULL, NULL, NULL },
-	[application_signalling_descriptor] = { "application_signalling_descriptor", NULL, NULL, NULL },
-	[adaptation_field_data_descriptor] = { "adaptation_field_data_descriptor", NULL, NULL, NULL },
-	[service_identifier_descriptor] = { "service_identifier_descriptor", NULL, NULL, NULL },
-	[service_availability_descriptor] = { "service_availability_descriptor", NULL, NULL, NULL },
-	[default_authority_descriptor] = { "default_authority_descriptor", NULL, NULL, NULL },
-	[related_content_descriptor] = { "related_content_descriptor", NULL, NULL, NULL },
-	[TVA_id_descriptor] = { "TVA_id_descriptor", NULL, NULL, NULL },
-	[content_identifier_descriptor] = { "content_identifier_descriptor", NULL, NULL, NULL },
-	[time_slice_fec_identifier_descriptor] = { "time_slice_fec_identifier_descriptor", NULL, NULL, NULL },
-	[ECM_repetition_rate_descriptor] = { "ECM_repetition_rate_descriptor", NULL, NULL, NULL },
-	[S2_satellite_delivery_system_descriptor] = { "S2_satellite_delivery_system_descriptor", NULL, NULL, NULL },
-	[enhanced_AC_3_descriptor] = { "enhanced_AC_3_descriptor", NULL, NULL, NULL },
-	[DTS_descriptor] = { "DTS_descriptor", NULL, NULL, NULL },
-	[AAC_descriptor] = { "AAC_descriptor", NULL, NULL, NULL },
-	[XAIT_location_descriptor] = { "XAIT_location_descriptor", NULL, NULL, NULL },
-	[FTA_content_management_descriptor] = { "FTA_content_management_descriptor", NULL, NULL, NULL },
-	[extension_descriptor] = { "extension_descriptor", NULL, NULL, NULL },
-
-	[CUE_identifier_descriptor] = { "CUE_identifier_descriptor", NULL, NULL, NULL },
-
-	[component_name_descriptor] = { "component_name_descriptor", NULL, NULL, NULL },
-	[logical_channel_number_descriptor] = { "logical_channel_number_descriptor", NULL, NULL, NULL },
-
-	[carousel_id_descriptor] = { "carousel_id_descriptor", NULL, NULL, NULL },
-	[association_tag_descriptor] = { "association_tag_descriptor", NULL, NULL, NULL },
-	[deferred_association_tags_descriptor] = { "deferred_association_tags_descriptor", NULL, NULL, NULL },
-
-	[hierarchical_transmission_descriptor] = { "hierarchical_transmission_descriptor", NULL, NULL, NULL },
-	[digital_copy_control_descriptor] = { "digital_copy_control_descriptor", NULL, NULL, NULL },
-	[network_identifier_descriptor] = { "network_identifier_descriptor", NULL, NULL, NULL },
-	[partial_transport_stream_time_descriptor] = { "partial_transport_stream_time_descriptor", NULL, NULL, NULL },
-	[audio_component_descriptor] = { "audio_component_descriptor", NULL, NULL, NULL },
-	[hyperlink_descriptor] = { "hyperlink_descriptor", NULL, NULL, NULL },
-	[target_area_descriptor] = { "target_area_descriptor", NULL, NULL, NULL },
-	[data_contents_descriptor] = { "data_contents_descriptor", NULL, NULL, NULL },
-	[video_decode_control_descriptor] = { "video_decode_control_descriptor", NULL, NULL, NULL },
-	[download_content_descriptor] = { "download_content_descriptor", NULL, NULL, NULL },
-	[CA_EMM_TS_descriptor] = { "CA_EMM_TS_descriptor", NULL, NULL, NULL },
-	[CA_contract_information_descriptor] = { "CA_contract_information_descriptor", NULL, NULL, NULL },
-	[CA_service_descriptor] = { "CA_service_descriptor", NULL, NULL, NULL },
-	[TS_Information_descriptior] = { "TS_Information_descriptior", NULL, NULL, NULL },
-	[extended_broadcaster_descriptor] = { "extended_broadcaster_descriptor", NULL, NULL, NULL },
-	[logo_transmission_descriptor] = { "logo_transmission_descriptor", NULL, NULL, NULL },
-	[basic_local_event_descriptor] = { "basic_local_event_descriptor", NULL, NULL, NULL },
-	[reference_descriptor] = { "reference_descriptor", NULL, NULL, NULL },
-	[node_relation_descriptor] = { "node_relation_descriptor", NULL, NULL, NULL },
-	[short_node_information_descriptor] = { "short_node_information_descriptor", NULL, NULL, NULL },
-	[STC_reference_descriptor] = { "STC_reference_descriptor", NULL, NULL, NULL },
-	[series_descriptor] = { "series_descriptor", NULL, NULL, NULL },
-	[event_group_descriptor] = { "event_group_descriptor", NULL, NULL, NULL },
-	[SI_parameter_descriptor] = { "SI_parameter_descriptor", NULL, NULL, NULL },
-	[broadcaster_Name_Descriptor] = { "broadcaster_Name_Descriptor", NULL, NULL, NULL },
-	[component_group_descriptor] = { "component_group_descriptor", NULL, NULL, NULL },
-	[SI_prime_TS_descriptor] = { "SI_prime_TS_descriptor", NULL, NULL, NULL },
-	[board_information_descriptor] = { "board_information_descriptor", NULL, NULL, NULL },
-	[LDT_linkage_descriptor] = { "LDT_linkage_descriptor", NULL, NULL, NULL },
-	[connected_transmission_descriptor] = { "connected_transmission_descriptor", NULL, NULL, NULL },
-	[content_availability_descriptor] = { "content_availability_descriptor", NULL, NULL, NULL },
-	[service_group_descriptor] = { "service_group_descriptor", NULL, NULL, NULL },
-	[carousel_compatible_composite_Descriptor] = { "carousel_compatible_composite_Descriptor", NULL, NULL, NULL },
-	[conditional_playback_descriptor] = { "conditional_playback_descriptor", NULL, NULL, NULL },
-	[ISDBT_delivery_system_descriptor] = { "ISDBT_delivery_system_descriptor", NULL, NULL, NULL },
-	[partial_reception_descriptor] = { "partial_reception_descriptor", NULL, NULL, NULL },
-	[emergency_information_descriptor] = { "emergency_information_descriptor", NULL, NULL, NULL },
-	[data_component_descriptor] = { "data_component_descriptor", NULL, NULL, NULL },
-	[system_management_descriptor] = { "system_management_descriptor", NULL, NULL, NULL },
+	[0 ...255 ] = { "Unknown descriptor", NULL, NULL, NULL, 0 },
+	[video_stream_descriptor] = { "video_stream_descriptor", NULL, NULL, NULL, 0 },
+	[audio_stream_descriptor] = { "audio_stream_descriptor", NULL, NULL, NULL, 0 },
+	[hierarchy_descriptor] = { "hierarchy_descriptor", dvb_desc_hierarchy_init, dvb_desc_hierarchy_print, NULL, sizeof(struct dvb_desc_hierarchy) },
+	[registration_descriptor] = { "registration_descriptor", NULL, NULL, NULL, 0 },
+	[ds_alignment_descriptor] = { "ds_alignment_descriptor", NULL, NULL, NULL, 0 },
+	[target_background_grid_descriptor] = { "target_background_grid_descriptor", NULL, NULL, NULL, 0 },
+	[video_window_descriptor] = { "video_window_descriptor", NULL, NULL, NULL, 0 },
+	[conditional_access_descriptor] = { "conditional_access_descriptor", NULL, NULL, NULL, 0 },
+	[iso639_language_descriptor] = { "iso639_language_descriptor", dvb_desc_language_init, dvb_desc_language_print, NULL, sizeof(struct dvb_desc_language) },
+	[system_clock_descriptor] = { "system_clock_descriptor", NULL, NULL, NULL, 0 },
+	[multiplex_buffer_utilization_descriptor] = { "multiplex_buffer_utilization_descriptor", NULL, NULL, NULL, 0 },
+	[copyright_descriptor] = { "copyright_descriptor", NULL, NULL, NULL, 0 },
+	[maximum_bitrate_descriptor] = { "maximum_bitrate_descriptor", NULL, NULL, NULL, 0 },
+	[private_data_indicator_descriptor] = { "private_data_indicator_descriptor", NULL, NULL, NULL, 0 },
+	[smoothing_buffer_descriptor] = { "smoothing_buffer_descriptor", NULL, NULL, NULL, 0 },
+	[std_descriptor] = { "std_descriptor", NULL, NULL, NULL, 0 },
+	[ibp_descriptor] = { "ibp_descriptor", NULL, NULL, NULL, 0 },
+	[mpeg4_video_descriptor] = { "mpeg4_video_descriptor", NULL, NULL, NULL, 0 },
+	[mpeg4_audio_descriptor] = { "mpeg4_audio_descriptor", NULL, NULL, NULL, 0 },
+	[iod_descriptor] = { "iod_descriptor", NULL, NULL, NULL, 0 },
+	[sl_descriptor] = { "sl_descriptor", NULL, NULL, NULL, 0 },
+	[fmc_descriptor] = { "fmc_descriptor", NULL, NULL, NULL, 0 },
+	[external_es_id_descriptor] = { "external_es_id_descriptor", NULL, NULL, NULL, 0 },
+	[muxcode_descriptor] = { "muxcode_descriptor", NULL, NULL, NULL, 0 },
+	[fmxbuffersize_descriptor] = { "fmxbuffersize_descriptor", NULL, NULL, NULL, 0 },
+	[multiplexbuffer_descriptor] = { "multiplexbuffer_descriptor", NULL, NULL, NULL, 0 },
+	[content_labeling_descriptor] = { "content_labeling_descriptor", NULL, NULL, NULL, 0 },
+	[metadata_pointer_descriptor] = { "metadata_pointer_descriptor", NULL, NULL, NULL, 0 },
+	[metadata_descriptor] = { "metadata_descriptor", NULL, NULL, NULL, 0 },
+	[metadata_std_descriptor] = { "metadata_std_descriptor", NULL, NULL, NULL, 0 },
+	[AVC_video_descriptor] = { "AVC_video_descriptor", NULL, NULL, NULL, 0 },
+	[ipmp_descriptor] = { "ipmp_descriptor", NULL, NULL, NULL, 0 },
+	[AVC_timing_and_HRD_descriptor] = { "AVC_timing_and_HRD_descriptor", NULL, NULL, NULL, 0 },
+	[mpeg2_aac_audio_descriptor] = { "mpeg2_aac_audio_descriptor", NULL, NULL, NULL, 0 },
+	[flexmux_timing_descriptor] = { "flexmux_timing_descriptor", NULL, NULL, NULL, 0 },
+	[network_name_descriptor] = { "network_name_descriptor", dvb_desc_network_name_init, dvb_desc_network_name_print, NULL, sizeof(struct dvb_desc_network_name) },
+	[service_list_descriptor] = { "service_list_descriptor", dvb_desc_service_list_init, dvb_desc_service_list_print, NULL, sizeof(struct dvb_desc_service_list) },
+	[stuffing_descriptor] = { "stuffing_descriptor", NULL, NULL, NULL, 0 },
+	[satellite_delivery_system_descriptor] = { "satellite_delivery_system_descriptor", dvb_desc_sat_init, dvb_desc_sat_print, NULL, sizeof(struct dvb_desc_sat) },
+	[cable_delivery_system_descriptor] = { "cable_delivery_system_descriptor", dvb_desc_cable_delivery_init, dvb_desc_cable_delivery_print, NULL, sizeof(struct dvb_desc_cable_delivery) },
+	[VBI_data_descriptor] = { "VBI_data_descriptor", NULL, NULL, NULL, 0 },
+	[VBI_teletext_descriptor] = { "VBI_teletext_descriptor", NULL, NULL, NULL, 0 },
+	[bouquet_name_descriptor] = { "bouquet_name_descriptor", NULL, NULL, NULL, 0 },
+	[service_descriptor] = { "service_descriptor", dvb_desc_service_init, dvb_desc_service_print, dvb_desc_service_free, sizeof(struct dvb_desc_service) },
+	[country_availability_descriptor] = { "country_availability_descriptor", NULL, NULL, NULL, 0 },
+	[linkage_descriptor] = { "linkage_descriptor", NULL, NULL, NULL, 0 },
+	[NVOD_reference_descriptor] = { "NVOD_reference_descriptor", NULL, NULL, NULL, 0 },
+	[time_shifted_service_descriptor] = { "time_shifted_service_descriptor", NULL, NULL, NULL, 0 },
+	[short_event_descriptor] = { "short_event_descriptor", dvb_desc_event_short_init, dvb_desc_event_short_print, dvb_desc_event_short_free, sizeof(struct dvb_desc_event_short) },
+	[extended_event_descriptor] = { "extended_event_descriptor", dvb_desc_event_extended_init, dvb_desc_event_extended_print, dvb_desc_event_extended_free, sizeof(struct dvb_desc_event_extended) },
+	[time_shifted_event_descriptor] = { "time_shifted_event_descriptor", NULL, NULL, NULL, 0 },
+	[component_descriptor] = { "component_descriptor", NULL, NULL, NULL, 0 },
+	[mosaic_descriptor] = { "mosaic_descriptor", NULL, NULL, NULL, 0 },
+	[stream_identifier_descriptor] = { "stream_identifier_descriptor", NULL, NULL, NULL, 0 },
+	[CA_identifier_descriptor] = { "CA_identifier_descriptor", NULL, NULL, NULL, 0 },
+	[content_descriptor] = { "content_descriptor", NULL, NULL, NULL, 0 },
+	[parental_rating_descriptor] = { "parental_rating_descriptor", NULL, NULL, NULL, 0 },
+	[teletext_descriptor] = { "teletext_descriptor", NULL, NULL, NULL, 0 },
+	[telephone_descriptor] = { "telephone_descriptor", NULL, NULL, NULL, 0 },
+	[local_time_offset_descriptor] = { "local_time_offset_descriptor", NULL, NULL, NULL, 0 },
+	[subtitling_descriptor] = { "subtitling_descriptor", NULL, NULL, NULL, 0 },
+	[terrestrial_delivery_system_descriptor] = { "terrestrial_delivery_system_descriptor", dvb_desc_terrestrial_delivery_init, dvb_desc_terrestrial_delivery_print, NULL, sizeof(struct dvb_desc_terrestrial_delivery) },
+	[multilingual_network_name_descriptor] = { "multilingual_network_name_descriptor", NULL, NULL, NULL, 0 },
+	[multilingual_bouquet_name_descriptor] = { "multilingual_bouquet_name_descriptor", NULL, NULL, NULL, 0 },
+	[multilingual_service_name_descriptor] = { "multilingual_service_name_descriptor", NULL, NULL, NULL, 0 },
+	[multilingual_component_descriptor] = { "multilingual_component_descriptor", NULL, NULL, NULL, 0 },
+	[private_data_specifier_descriptor] = { "private_data_specifier_descriptor", NULL, NULL, NULL, 0 },
+	[service_move_descriptor] = { "service_move_descriptor", NULL, NULL, NULL, 0 },
+	[short_smoothing_buffer_descriptor] = { "short_smoothing_buffer_descriptor", NULL, NULL, NULL, 0 },
+	[frequency_list_descriptor] = { "frequency_list_descriptor", dvb_desc_frequency_list_init, dvb_desc_frequency_list_print, NULL, sizeof(struct dvb_desc_frequency_list) },
+	[partial_transport_stream_descriptor] = { "partial_transport_stream_descriptor", NULL, NULL, NULL, 0 },
+	[data_broadcast_descriptor] = { "data_broadcast_descriptor", NULL, NULL, NULL, 0 },
+	[scrambling_descriptor] = { "scrambling_descriptor", NULL, NULL, NULL, 0 },
+	[data_broadcast_id_descriptor] = { "data_broadcast_id_descriptor", NULL, NULL, NULL, 0 },
+	[transport_stream_descriptor] = { "transport_stream_descriptor", NULL, NULL, NULL, 0 },
+	[DSNG_descriptor] = { "DSNG_descriptor", NULL, NULL, NULL, 0 },
+	[PDC_descriptor] = { "PDC_descriptor", NULL, NULL, NULL, 0 },
+	[AC_3_descriptor] = { "AC_3_descriptor", NULL, NULL, NULL, 0 },
+	[ancillary_data_descriptor] = { "ancillary_data_descriptor", NULL, NULL, NULL, 0 },
+	[cell_list_descriptor] = { "cell_list_descriptor", NULL, NULL, NULL, 0 },
+	[cell_frequency_link_descriptor] = { "cell_frequency_link_descriptor", NULL, NULL, NULL, 0 },
+	[announcement_support_descriptor] = { "announcement_support_descriptor", NULL, NULL, NULL, 0 },
+	[application_signalling_descriptor] = { "application_signalling_descriptor", NULL, NULL, NULL, 0 },
+	[adaptation_field_data_descriptor] = { "adaptation_field_data_descriptor", NULL, NULL, NULL, 0 },
+	[service_identifier_descriptor] = { "service_identifier_descriptor", NULL, NULL, NULL, 0 },
+	[service_availability_descriptor] = { "service_availability_descriptor", NULL, NULL, NULL, 0 },
+	[default_authority_descriptor] = { "default_authority_descriptor", NULL, NULL, NULL, 0 },
+	[related_content_descriptor] = { "related_content_descriptor", NULL, NULL, NULL, 0 },
+	[TVA_id_descriptor] = { "TVA_id_descriptor", NULL, NULL, NULL, 0 },
+	[content_identifier_descriptor] = { "content_identifier_descriptor", NULL, NULL, NULL, 0 },
+	[time_slice_fec_identifier_descriptor] = { "time_slice_fec_identifier_descriptor", NULL, NULL, NULL, 0 },
+	[ECM_repetition_rate_descriptor] = { "ECM_repetition_rate_descriptor", NULL, NULL, NULL, 0 },
+	[S2_satellite_delivery_system_descriptor] = { "S2_satellite_delivery_system_descriptor", NULL, NULL, NULL, 0 },
+	[enhanced_AC_3_descriptor] = { "enhanced_AC_3_descriptor", NULL, NULL, NULL, 0 },
+	[DTS_descriptor] = { "DTS_descriptor", NULL, NULL, NULL, 0 },
+	[AAC_descriptor] = { "AAC_descriptor", NULL, NULL, NULL, 0 },
+	[XAIT_location_descriptor] = { "XAIT_location_descriptor", NULL, NULL, NULL, 0 },
+	[FTA_content_management_descriptor] = { "FTA_content_management_descriptor", NULL, NULL, NULL, 0 },
+	[extension_descriptor] = { "extension_descriptor", NULL, NULL, NULL, 0 },
+
+	[CUE_identifier_descriptor] = { "CUE_identifier_descriptor", NULL, NULL, NULL, 0 },
+
+	[component_name_descriptor] = { "component_name_descriptor", NULL, NULL, NULL, 0 },
+	[logical_channel_number_descriptor] = { "logical_channel_number_descriptor", NULL, NULL, NULL, 0 },
+
+	[carousel_id_descriptor] = { "carousel_id_descriptor", NULL, NULL, NULL, 0 },
+	[association_tag_descriptor] = { "association_tag_descriptor", NULL, NULL, NULL, 0 },
+	[deferred_association_tags_descriptor] = { "deferred_association_tags_descriptor", NULL, NULL, NULL, 0 },
+
+	[hierarchical_transmission_descriptor] = { "hierarchical_transmission_descriptor", NULL, NULL, NULL, 0 },
+	[digital_copy_control_descriptor] = { "digital_copy_control_descriptor", NULL, NULL, NULL, 0 },
+	[network_identifier_descriptor] = { "network_identifier_descriptor", NULL, NULL, NULL, 0 },
+	[partial_transport_stream_time_descriptor] = { "partial_transport_stream_time_descriptor", NULL, NULL, NULL, 0 },
+	[audio_component_descriptor] = { "audio_component_descriptor", NULL, NULL, NULL, 0 },
+	[hyperlink_descriptor] = { "hyperlink_descriptor", NULL, NULL, NULL, 0 },
+	[target_area_descriptor] = { "target_area_descriptor", NULL, NULL, NULL, 0 },
+	[data_contents_descriptor] = { "data_contents_descriptor", NULL, NULL, NULL, 0 },
+	[video_decode_control_descriptor] = { "video_decode_control_descriptor", NULL, NULL, NULL, 0 },
+	[download_content_descriptor] = { "download_content_descriptor", NULL, NULL, NULL, 0 },
+	[CA_EMM_TS_descriptor] = { "CA_EMM_TS_descriptor", NULL, NULL, NULL, 0 },
+	[CA_contract_information_descriptor] = { "CA_contract_information_descriptor", NULL, NULL, NULL, 0 },
+	[CA_service_descriptor] = { "CA_service_descriptor", NULL, NULL, NULL, 0 },
+	[TS_Information_descriptior] = { "TS_Information_descriptior", NULL, NULL, NULL, 0 },
+	[extended_broadcaster_descriptor] = { "extended_broadcaster_descriptor", NULL, NULL, NULL, 0 },
+	[logo_transmission_descriptor] = { "logo_transmission_descriptor", NULL, NULL, NULL, 0 },
+	[basic_local_event_descriptor] = { "basic_local_event_descriptor", NULL, NULL, NULL, 0 },
+	[reference_descriptor] = { "reference_descriptor", NULL, NULL, NULL, 0 },
+	[node_relation_descriptor] = { "node_relation_descriptor", NULL, NULL, NULL, 0 },
+	[short_node_information_descriptor] = { "short_node_information_descriptor", NULL, NULL, NULL, 0 },
+	[STC_reference_descriptor] = { "STC_reference_descriptor", NULL, NULL, NULL, 0 },
+	[series_descriptor] = { "series_descriptor", NULL, NULL, NULL, 0 },
+	[event_group_descriptor] = { "event_group_descriptor", NULL, NULL, NULL, 0 },
+	[SI_parameter_descriptor] = { "SI_parameter_descriptor", NULL, NULL, NULL, 0 },
+	[broadcaster_Name_Descriptor] = { "broadcaster_Name_Descriptor", NULL, NULL, NULL, 0 },
+	[component_group_descriptor] = { "component_group_descriptor", NULL, NULL, NULL, 0 },
+	[SI_prime_TS_descriptor] = { "SI_prime_TS_descriptor", NULL, NULL, NULL, 0 },
+	[board_information_descriptor] = { "board_information_descriptor", NULL, NULL, NULL, 0 },
+	[LDT_linkage_descriptor] = { "LDT_linkage_descriptor", NULL, NULL, NULL, 0 },
+	[connected_transmission_descriptor] = { "connected_transmission_descriptor", NULL, NULL, NULL, 0 },
+	[content_availability_descriptor] = { "content_availability_descriptor", NULL, NULL, NULL, 0 },
+	[service_group_descriptor] = { "service_group_descriptor", NULL, NULL, NULL, 0 },
+	[carousel_compatible_composite_descriptor] = { "carousel_compatible_composite_descriptor", NULL, NULL, NULL, 0 },
+	[conditional_playback_descriptor] = { "conditional_playback_descriptor", NULL, NULL, NULL, 0 },
+	[ISDBT_delivery_system_descriptor] = { "ISDBT_delivery_system_descriptor", NULL, NULL, NULL, 0 },
+	[partial_reception_descriptor] = { "partial_reception_descriptor", NULL, NULL, NULL, 0 },
+	[emergency_information_descriptor] = { "emergency_information_descriptor", NULL, NULL, NULL, 0 },
+	[data_component_descriptor] = { "data_component_descriptor", NULL, NULL, NULL, 0 },
+	[system_management_descriptor] = { "system_management_descriptor", NULL, NULL, NULL, 0 },
 };
 
 static const char *extension_descriptors[] = {
diff --git a/lib/libdvbv5/descriptors/desc_cable_delivery.c b/lib/libdvbv5/descriptors/desc_cable_delivery.c
index 52c5f70..7de5f3b 100644
--- a/lib/libdvbv5/descriptors/desc_cable_delivery.c
+++ b/lib/libdvbv5/descriptors/desc_cable_delivery.c
@@ -23,7 +23,7 @@
 #include "descriptors.h"
 #include "dvb-fe.h"
 
-ssize_t dvb_desc_cable_delivery_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+void dvb_desc_cable_delivery_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_cable_delivery *cable = (struct dvb_desc_cable_delivery *) desc;
 	/* copy only the data - length already initialize */
@@ -35,8 +35,6 @@ ssize_t dvb_desc_cable_delivery_init(struct dvb_v5_fe_parms *parms, const uint8_
 	bswap32(cable->bitfield2);
 	cable->frequency   = bcd(cable->frequency) * 100;
 	cable->symbol_rate = bcd(cable->symbol_rate) * 100;
-
-	return sizeof(struct dvb_desc_cable_delivery);
 }
 
 void dvb_desc_cable_delivery_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_event_extended.c b/lib/libdvbv5/descriptors/desc_event_extended.c
index acd012c..0a92b3c 100644
--- a/lib/libdvbv5/descriptors/desc_event_extended.c
+++ b/lib/libdvbv5/descriptors/desc_event_extended.c
@@ -24,7 +24,7 @@
 #include "dvb-fe.h"
 #include "parse_string.h"
 
-ssize_t dvb_desc_event_extended_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+void dvb_desc_event_extended_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_event_extended *event = (struct dvb_desc_event_extended *) desc;
 	uint8_t len;  /* the length of the string in the input data */
@@ -62,8 +62,6 @@ ssize_t dvb_desc_event_extended_init(struct dvb_v5_fe_parms *parms, const uint8_
 	buf++;
 	parse_string(parms, &event->text, &event->text_emph, buf, len1, default_charset, output_charset);
 	buf += len;
-
-	return sizeof(struct dvb_desc_event_extended);
 }
 
 void dvb_desc_event_extended_free(struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_event_short.c b/lib/libdvbv5/descriptors/desc_event_short.c
index 03d197c..26f42e9 100644
--- a/lib/libdvbv5/descriptors/desc_event_short.c
+++ b/lib/libdvbv5/descriptors/desc_event_short.c
@@ -24,7 +24,7 @@
 #include "dvb-fe.h"
 #include "parse_string.h"
 
-ssize_t dvb_desc_event_short_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+void dvb_desc_event_short_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_event_short *event = (struct dvb_desc_event_short *) desc;
 	uint8_t len;        /* the length of the string in the input data */
@@ -53,8 +53,6 @@ ssize_t dvb_desc_event_short_init(struct dvb_v5_fe_parms *parms, const uint8_t *
 	buf++;
 	parse_string(parms, &event->text, &event->text_emph, buf, len2, default_charset, output_charset);
 	buf += len;
-
-	return sizeof(struct dvb_desc_event_short);
 }
 
 void dvb_desc_event_short_free(struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_frequency_list.c b/lib/libdvbv5/descriptors/desc_frequency_list.c
index acf8563..20107d2 100644
--- a/lib/libdvbv5/descriptors/desc_frequency_list.c
+++ b/lib/libdvbv5/descriptors/desc_frequency_list.c
@@ -23,41 +23,41 @@
 #include "descriptors.h"
 #include "dvb-fe.h"
 
-ssize_t dvb_desc_frequency_list_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+void dvb_desc_frequency_list_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_frequency_list *flist = (struct dvb_desc_frequency_list *) desc;
 
 	flist->bitfield = buf[0];
 
-	flist->frequencies = (flist->length - sizeof(flist->bitfield)) / sizeof(flist->frequency[0]);
-	int i;
-	for (i = 1; i <= flist->frequencies; i++) {
-		flist->frequency[i] = ((uint32_t *) buf)[i];
-		bswap32(flist->frequency[i]);
-		switch (flist->freq_type) {
-			case 1: /* satellite - to get kHz*/
-			case 3: /* terrestrial - to get Hz*/
-				flist->frequency[i] *= 10;
-				break;
-			case 2: /* cable - to get Hz */
-				flist->frequency[i] *= 100;
-				break;
-			case 0: /* not defined */
-			default:
-				break;
-		}
-	}
-
-	return sizeof(struct dvb_desc_frequency_list) + (flist->frequencies * sizeof(flist->frequency[0]));
+	/*flist->frequencies = (flist->length - sizeof(flist->bitfield)) / sizeof(flist->frequency[0]);*/
+	/*int i;*/
+	/*for (i = 1; i <= flist->frequencies; i++) {*/
+		/*flist->frequency[i] = ((uint32_t *) buf)[i];*/
+		/*bswap32(flist->frequency[i]);*/
+		/*switch (flist->freq_type) {*/
+			/*case 1: [> satellite - to get kHz<]*/
+			/*case 3: [> terrestrial - to get Hz<]*/
+				/*flist->frequency[i] *= 10;*/
+				/*break;*/
+			/*case 2: [> cable - to get Hz <]*/
+				/*flist->frequency[i] *= 100;*/
+				/*break;*/
+			/*case 0: [> not defined <]*/
+			/*default:*/
+				/*break;*/
+		/*}*/
+	/*}*/
+// FIXME: malloc list entires
+//	return sizeof(struct dvb_desc_frequency_list) + (flist->frequencies * sizeof(flist->frequency[0]));
 }
 
 void dvb_desc_frequency_list_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
 {
 	const struct dvb_desc_frequency_list *flist = (const struct dvb_desc_frequency_list *) desc;
 	dvb_log("|       frequency list type: %d", flist->freq_type);
-	int i = 0;
-	for (i = 0; i < flist->frequencies; i++) {
-		dvb_log("|       frequency : %d", flist->frequency[i]);
-	}
+	/*int i = 0;*/
+	/*for (i = 0; i < flist->frequencies; i++) {*/
+		/*dvb_log("|       frequency : %d", flist->frequency[i]);*/
+	/*}*/
 }
 
diff --git a/lib/libdvbv5/descriptors/desc_hierarchy.c b/lib/libdvbv5/descriptors/desc_hierarchy.c
new file mode 100644
index 0000000..1de9806
--- /dev/null
+++ b/lib/libdvbv5/descriptors/desc_hierarchy.c
@@ -0,0 +1,44 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#include "descriptors/desc_hierarchy.h"
+#include "descriptors.h"
+#include "dvb-fe.h"
+
+void dvb_desc_hierarchy_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+{
+	struct dvb_desc_hierarchy *hierarchy = (struct dvb_desc_hierarchy *) desc;
+	/* copy from .length */
+	memcpy(((uint8_t *) hierarchy ) + sizeof(hierarchy->type) + sizeof(hierarchy->length) + sizeof(hierarchy->next),
+		buf,
+		hierarchy->length);
+}
+
+void dvb_desc_hierarchy_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
+{
+	const struct dvb_desc_hierarchy *hierarchy = (const struct dvb_desc_hierarchy *) desc;
+	dvb_log("|	Hierarchy");
+	dvb_log("|           type           %d", hierarchy->hierarchy_type);
+	dvb_log("|           layer          %d", hierarchy->layer);
+	dvb_log("|           embedded_layer %d", hierarchy->embedded_layer);
+	dvb_log("|           channel        %d", hierarchy->channel);
+}
+
diff --git a/lib/libdvbv5/descriptors/desc_language.c b/lib/libdvbv5/descriptors/desc_language.c
index 686bcd4..d0c8acc 100644
--- a/lib/libdvbv5/descriptors/desc_language.c
+++ b/lib/libdvbv5/descriptors/desc_language.c
@@ -23,7 +23,7 @@
 #include "descriptors.h"
 #include "dvb-fe.h"
 
-ssize_t dvb_desc_language_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+void dvb_desc_language_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_language *lang = (struct dvb_desc_language *) desc;
 
@@ -32,8 +32,6 @@ ssize_t dvb_desc_language_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf
 	lang->language[2] = buf[2];
 	lang->language[3] = '\0';
 	lang->audio_type  = buf[3];
-
-	return sizeof(struct dvb_desc_language);
 }
 
 void dvb_desc_language_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_network_name.c b/lib/libdvbv5/descriptors/desc_network_name.c
index e89bd2d..9cf8a8b 100644
--- a/lib/libdvbv5/descriptors/desc_network_name.c
+++ b/lib/libdvbv5/descriptors/desc_network_name.c
@@ -24,31 +24,18 @@
 #include "dvb-fe.h"
 #include "parse_string.h"
 
-ssize_t dvb_desc_network_name_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+void dvb_desc_network_name_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_network_name *net = (struct dvb_desc_network_name *) desc;
-	char *name, *emph;
 	uint8_t len;  /* the length of the string in the input data */
 	uint8_t len1; /* the lenght of the output strings */
 
 	len = desc->length;
 	len1 = len;
-	name = NULL;
-	emph = NULL;
-	parse_string(parms, &name, &emph, buf, len1, default_charset, output_charset);
+	net->network_name = NULL;
+	net->network_name_emph = NULL;
+	parse_string(parms, &net->network_name, &net->network_name_emph, buf, len1, default_charset, output_charset);
 	buf += len;
-	if (emph)
-		free(emph);
-	if (name) {
-		len1 = strlen(name);
-		memcpy(net->network_name, name, len1);
-		free(name);
-	} else {
-		memcpy(net->network_name, buf, len1);
-	}
-	net->network_name[len1] = '\0';
-
-	return sizeof(struct dvb_desc_network_name) + len1 + 1;
 }
 
 void dvb_desc_network_name_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_sat.c b/lib/libdvbv5/descriptors/desc_sat.c
index e07ad1d..557d531 100644
--- a/lib/libdvbv5/descriptors/desc_sat.c
+++ b/lib/libdvbv5/descriptors/desc_sat.c
@@ -23,7 +23,7 @@
 #include "descriptors.h"
 #include "dvb-fe.h"
 
-ssize_t dvb_desc_sat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+void dvb_desc_sat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_sat *sat = (struct dvb_desc_sat *) desc;
 	/* copy from .length */
@@ -36,8 +36,6 @@ ssize_t dvb_desc_sat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, str
 	sat->orbit = bcd(sat->orbit);
 	sat->frequency   = bcd(sat->frequency) * 10;
 	sat->symbol_rate = bcd(sat->symbol_rate) * 100;
-
-	return sizeof(struct dvb_desc_sat);
 }
 
 void dvb_desc_sat_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_service.c b/lib/libdvbv5/descriptors/desc_service.c
index e921790..e4f8ec0 100644
--- a/lib/libdvbv5/descriptors/desc_service.c
+++ b/lib/libdvbv5/descriptors/desc_service.c
@@ -24,13 +24,13 @@
 #include "dvb-fe.h"
 #include "parse_string.h"
 
-ssize_t dvb_desc_service_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+void dvb_desc_service_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_service *service = (struct dvb_desc_service *) desc;
 	uint8_t len;        /* the length of the string in the input data */
 	uint8_t len1, len2; /* the lenght of the output strings */
 
-	/*hexdump(parms, "service desc: ", buf - 2, desc->length + 2);*/
+        /*hexdump(parms, "service desc: ", buf - 2, desc->length + 2);*/
 	service->service_type = buf[0];
 	buf++;
 
@@ -49,8 +49,6 @@ ssize_t dvb_desc_service_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	buf++;
 	parse_string(parms, &service->name, &service->name_emph, buf, len2, default_charset, output_charset);
 	buf += len;
-
-	return sizeof(struct dvb_desc_service);
 }
 
 void dvb_desc_service_free(struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_service_list.c b/lib/libdvbv5/descriptors/desc_service_list.c
index 41084bd..ab91622 100644
--- a/lib/libdvbv5/descriptors/desc_service_list.c
+++ b/lib/libdvbv5/descriptors/desc_service_list.c
@@ -23,31 +23,32 @@
 #include "descriptors.h"
 #include "dvb-fe.h"
 
-ssize_t dvb_desc_service_list_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+void dvb_desc_service_list_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
-	struct dvb_desc_service_list *slist = (struct dvb_desc_service_list *) desc;
+	/*struct dvb_desc_service_list *slist = (struct dvb_desc_service_list *) desc;*/
 
-	memcpy( slist->services, buf, slist->length);
-	/* close the list */
-	slist->services[slist->length / sizeof(struct dvb_desc_service_list_table)].service_id = 0;
-	slist->services[slist->length / sizeof(struct dvb_desc_service_list_table)].service_type = 0;
-	/* swap the ids */
-	int i;
-	for( i = 0; slist->services[i].service_id != 0; ++i) {
-		bswap16(slist->services[i].service_id);
-	}
+	/*memcpy( slist->services, buf, slist->length);*/
+	/*[> close the list <]*/
+	/*slist->services[slist->length / sizeof(struct dvb_desc_service_list_table)].service_id = 0;*/
+	/*slist->services[slist->length / sizeof(struct dvb_desc_service_list_table)].service_type = 0;*/
+	/*[> swap the ids <]*/
+	/*int i;*/
+	/*for( i = 0; slist->services[i].service_id != 0; ++i) {*/
+		/*bswap16(slist->services[i].service_id);*/
+	/*}*/
 
-	return sizeof(struct dvb_desc_service_list) + slist->length + sizeof(struct dvb_desc_service_list_table);
+	/*return sizeof(struct dvb_desc_service_list) + slist->length + sizeof(struct dvb_desc_service_list_table);*/
+	//FIXME: make linked list
 }
 
 void dvb_desc_service_list_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
 {
-	const struct dvb_desc_service_list *slist = (const struct dvb_desc_service_list *) desc;
-	int i = 0;
-	while(slist->services[i].service_id != 0) {
-		dvb_log("|           service id   : '%d'", slist->services[i].service_id);
-		dvb_log("|           service type : '%d'", slist->services[i].service_type);
-		++i;
-	}
+	/*const struct dvb_desc_service_list *slist = (const struct dvb_desc_service_list *) desc;*/
+	/*int i = 0;*/
+	/*while(slist->services[i].service_id != 0) {*/
+		/*dvb_log("|           service id   : '%d'", slist->services[i].service_id);*/
+		/*dvb_log("|           service type : '%d'", slist->services[i].service_type);*/
+		/*++i;*/
+	/*}*/
 }
 
diff --git a/lib/libdvbv5/descriptors/desc_terrestrial_delivery.c b/lib/libdvbv5/descriptors/desc_terrestrial_delivery.c
index 844b34c..28bef56 100644
--- a/lib/libdvbv5/descriptors/desc_terrestrial_delivery.c
+++ b/lib/libdvbv5/descriptors/desc_terrestrial_delivery.c
@@ -23,7 +23,7 @@
 #include "descriptors.h"
 #include "dvb-fe.h"
 
-ssize_t dvb_desc_terrestrial_delivery_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+void dvb_desc_terrestrial_delivery_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_terrestrial_delivery *tdel = (struct dvb_desc_terrestrial_delivery *) desc;
 	/* copy from .length */
@@ -32,8 +32,6 @@ ssize_t dvb_desc_terrestrial_delivery_init(struct dvb_v5_fe_parms *parms, const
 			tdel->length);
 	bswap32(tdel->centre_frequency);
 	bswap32(tdel->reserved_future_use2);
-
-	return sizeof(struct dvb_desc_terrestrial_delivery);
 }
 
 void dvb_desc_terrestrial_delivery_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/pmt.c b/lib/libdvbv5/descriptors/pmt.c
index bf8f87c..278e3ef 100644
--- a/lib/libdvbv5/descriptors/pmt.c
+++ b/lib/libdvbv5/descriptors/pmt.c
@@ -98,7 +98,7 @@ void dvb_table_pmt_print(struct dvb_v5_fe_parms *parms, const struct dvb_table_p
 	uint16_t streams = 0;
 	while(stream) {
 		dvb_log("|- %5d   %s (%d)", stream->elementary_pid,
-				dvb_descriptors[stream->type].name, stream->type);
+				pmt_stream_name[stream->type], stream->type);
 		dvb_print_descriptors(parms, stream->descriptor);
 		stream = stream->next;
 		streams++;
@@ -106,3 +106,29 @@ void dvb_table_pmt_print(struct dvb_v5_fe_parms *parms, const struct dvb_table_p
 	dvb_log("|_  %d streams", streams);
 }
 
+const char *pmt_stream_name[] = {
+	[stream_reserved0]         = "Reserved",
+	[stream_video]             = "Video ISO/IEC 11172",
+	[stream_video_h262]        = "Video ISO/IEC 13818-2",
+	[stream_audio]             = "Audio ISO/IEC 11172",
+	[stream_audio_13818_3]     = "Audio ISO/IEC 13818-3",
+	[stream_private_sections]  = "ISO/IEC 13818-1 Private Sections",
+	[stream_private_data]      = "ISO/IEC 13818-1 Private Data",
+	[stream_mheg]              = "ISO/IEC 13522 MHEG",
+	[stream_h222]              = "ISO/IEC 13818-1 Annex A DSM-CC",
+	[stream_h222_1]            = "ITU-T Rec. H.222.1",
+	[stream_13818_6_A]         = "ISO/IEC 13818-6 type A",
+	[stream_13818_6_B]         = "ISO/IEC 13818-6 type B",
+	[stream_13818_6_C]         = "ISO/IEC 13818-6 type C",
+	[stream_13818_6_D]         = "ISO/IEC 13818-6 type D",
+	[stream_h222_aux]          = "ISO/IEC 13818-1 auxiliary",
+	[stream_audio_adts]        = "Audio ISO/IEC 13818-7 ADTS",
+	[stream_video_14496_2]     = "Video ISO/IEC 14496-2",
+	[stream_audio_latm]        = "Audio ISO/IEC 14496-3 LATM",
+	[stream_14496_1_pes]       = "ISO/IEC 14496-1 PES",
+	[stream_14496_1_iso]       = "ISO/IEC 14496-1 ISO",
+	[stream_download]          = "ISO/IEC 13818-6 Synchronized Download Protocol",
+	[stream_reserved ... 0x7f] = "ISO/IEC 13818-1 Reserved",
+	[stream_private  ... 0xff] = "User Private"
+};
+
diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index a49ad80..22893c8 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -331,7 +331,7 @@ int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd, unsigned
 	f.filter.filter[0] = tid;
 	f.filter.mask[0] = 0xff;
 	f.timeout = 0;
-	f.flags = DMX_IMMEDIATE_START; // | DMX_CHECK_CRC;
+	f.flags = DMX_IMMEDIATE_START | DMX_CHECK_CRC;
 	if (ioctl(dmx_fd, DMX_SET_FILTER, &f) == -1) {
 		dvb_perror("dvb_read_section: ioctl DMX_SET_FILTER failed");
 		return -1;
@@ -389,8 +389,6 @@ int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd, unsigned
 			}
 		}
 
-		dvb_logwarn("section %d/%d", h->section_id, h->last_section);
-
 		/* handle the sections */
 		if (first_section == -1)
 			first_section = h->section_id;
-- 
1.7.2.5

