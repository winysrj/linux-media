Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41272 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab2HCK1p (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2012 06:27:45 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so517484wgb.1
        for <linux-media@vger.kernel.org>; Fri, 03 Aug 2012 03:27:44 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 6/6] libdvbv5: reworked table allocation/freeing
Date: Fri,  3 Aug 2012 12:26:59 +0200
Message-Id: <1343989619-12928-6-git-send-email-neolynx@gmail.com>
In-Reply-To: <1343989619-12928-1-git-send-email-neolynx@gmail.com>
References: <1343989619-12928-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/descriptors.h                      |    7 +-
 lib/include/descriptors/desc_event_extended.h  |   60 +++++
 lib/include/descriptors/desc_event_short.h     |    3 +
 lib/include/descriptors/desc_service.h         |    3 +
 lib/include/descriptors/eit.h                  |   20 ++-
 lib/include/descriptors/nit.h                  |    3 +-
 lib/include/descriptors/pat.h                  |    3 +-
 lib/include/descriptors/pmt.h                  |    3 +-
 lib/include/descriptors/sdt.h                  |    3 +-
 lib/include/dvb-scan.h                         |    8 +-
 lib/libdvbv5/Makefile.am                       |    1 +
 lib/libdvbv5/descriptors.c                     |  315 ++++++++++++-----------
 lib/libdvbv5/descriptors/desc_event_extended.c |   81 ++++++
 lib/libdvbv5/descriptors/desc_event_short.c    |   49 ++---
 lib/libdvbv5/descriptors/desc_service.c        |   46 ++---
 lib/libdvbv5/descriptors/eit.c                 |  110 ++++++---
 lib/libdvbv5/descriptors/nit.c                 |   79 +++---
 lib/libdvbv5/descriptors/pat.c                 |   55 +++--
 lib/libdvbv5/descriptors/pmt.c                 |   99 ++++----
 lib/libdvbv5/descriptors/sdt.c                 |   55 ++--
 lib/libdvbv5/dvb-scan.c                        |  150 +++++++-----
 21 files changed, 694 insertions(+), 459 deletions(-)
 create mode 100644 lib/include/descriptors/desc_event_extended.h
 create mode 100644 lib/libdvbv5/descriptors/desc_event_extended.c

diff --git a/lib/include/descriptors.h b/lib/include/descriptors.h
index 0493e80..9e3d49b 100644
--- a/lib/include/descriptors.h
+++ b/lib/include/descriptors.h
@@ -35,7 +35,7 @@
 
 struct dvb_v5_fe_parms;
 
-typedef void (*dvb_table_init_func)(struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize_t size, uint8_t **buf, ssize_t *buflen);
+typedef void (*dvb_table_init_func)(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
 
 struct dvb_table_init {
 	dvb_table_init_func init;
@@ -77,18 +77,21 @@ uint32_t bcd(uint32_t bcd);
 
 void hexdump(struct dvb_v5_fe_parms *parms, const char *prefix, const unsigned char *buf, int len);
 
-ssize_t dvb_parse_descriptors(struct dvb_v5_fe_parms *parms, const uint8_t *buf, uint8_t *dest, uint16_t section_length, struct dvb_desc **head_desc);
+void dvb_parse_descriptors(struct dvb_v5_fe_parms *parms, const uint8_t *buf, uint16_t section_length, struct dvb_desc **head_desc);
+void dvb_free_descriptors(struct dvb_desc **list);
 void dvb_print_descriptors(struct dvb_v5_fe_parms *parms, struct dvb_desc *desc);
 
 struct dvb_v5_fe_parms;
 
 typedef ssize_t (*dvb_desc_init_func)(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
 typedef void (*dvb_desc_print_func)(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+typedef void (*dvb_desc_free_func)(struct dvb_desc *desc);
 
 struct dvb_descriptor {
 	const char *name;
 	dvb_desc_init_func init;
 	dvb_desc_print_func print;
+	dvb_desc_free_func free;
 	ssize_t desc_size;
 };
 
diff --git a/lib/include/descriptors/desc_event_extended.h b/lib/include/descriptors/desc_event_extended.h
new file mode 100644
index 0000000..05a83f3
--- /dev/null
+++ b/lib/include/descriptors/desc_event_extended.h
@@ -0,0 +1,60 @@
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
+#ifndef _DESC_EVENT_EXTENDED_H
+#define _DESC_EVENT_EXTENDED_H
+
+#include <stdint.h>
+#include <unistd.h> /* ssize_t */
+
+struct dvb_desc_event_extended {
+	uint8_t type;
+	uint8_t length;
+	struct dvb_desc *next;
+
+	union {
+		struct {
+			uint8_t last_id:4;
+			uint8_t id:4;
+		};
+		uint8_t ids;
+	};
+
+	unsigned char language[4];
+	char *text;
+	char *text_emph;
+} __attribute__((packed));
+
+struct dvb_v5_fe_parms;
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+ssize_t dvb_desc_event_extended_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+void dvb_desc_event_extended_print  (struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+void dvb_desc_event_extended_free   (struct dvb_desc *desc);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/include/descriptors/desc_event_short.h b/lib/include/descriptors/desc_event_short.h
index 1809ffb..d597977 100644
--- a/lib/include/descriptors/desc_event_short.h
+++ b/lib/include/descriptors/desc_event_short.h
@@ -32,7 +32,9 @@ struct dvb_desc_event_short {
 
 	unsigned char language[4];
 	char *name;
+	char *name_emph;
 	char *text;
+	char *text_emph;
 } __attribute__((packed));
 
 struct dvb_v5_fe_parms;
@@ -43,6 +45,7 @@ extern "C" {
 
 ssize_t dvb_desc_event_short_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
 void dvb_desc_event_short_print  (struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+void dvb_desc_event_short_free   (struct dvb_desc *desc);
 
 #ifdef __cplusplus
 }
diff --git a/lib/include/descriptors/desc_service.h b/lib/include/descriptors/desc_service.h
index a89b3ed..f3ce977 100644
--- a/lib/include/descriptors/desc_service.h
+++ b/lib/include/descriptors/desc_service.h
@@ -32,7 +32,9 @@ struct dvb_desc_service {
 
 	uint8_t service_type;
 	char *name;
+	char *name_emph;
 	char *provider;
+	char *provider_emph;
 } __attribute__((packed));
 
 struct dvb_v5_fe_parms;
@@ -43,6 +45,7 @@ extern "C" {
 
 ssize_t dvb_desc_service_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
 void dvb_desc_service_print  (struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+void dvb_desc_service_free   (struct dvb_desc *desc);
 
 #ifdef __cplusplus
 }
diff --git a/lib/include/descriptors/eit.h b/lib/include/descriptors/eit.h
index 4cf7cc1..2af9696 100644
--- a/lib/include/descriptors/eit.h
+++ b/lib/include/descriptors/eit.h
@@ -24,6 +24,7 @@
 
 #include <stdint.h>
 #include <unistd.h> /* ssize_t */
+#include <time.h>
 
 #include "descriptors/header.h"
 #include "descriptors.h"
@@ -38,18 +39,23 @@
 
 struct dvb_table_eit_event {
 	uint16_t event_id;
-	uint8_t start[5];
-	uint8_t duration[3];
 	union {
 		uint16_t bitfield;
+		uint8_t dvbstart[5];
+	} __attribute__((packed));
+	uint8_t dvbduration[3];
+	union {
+		uint16_t bitfield2;
 		struct {
 			uint16_t section_length:12;
 			uint16_t free_CA_mode:1;
 			uint16_t running_status:3;
 		} __attribute__((packed));
-	};
+	} __attribute__((packed));
 	struct dvb_desc *descriptor;
 	struct dvb_table_eit_event *next;
+	struct tm start;
+	uint32_t duration;
 } __attribute__((packed));
 
 struct dvb_table_eit {
@@ -61,17 +67,21 @@ struct dvb_table_eit {
 	struct dvb_table_eit_event *event;
 } __attribute__((packed));
 
-#define dvb_eit_service_foreach(_event, _eit) \
+#define dvb_eit_event_foreach(_event, _eit) \
 	for( struct dvb_table_eit_event *_event = _eit->event; _event; _event = _event->next ) \
 
 struct dvb_v5_fe_parms;
 
+extern const char *dvb_eit_running_status_name[8];
+
 #ifdef __cplusplus
 extern "C" {
 #endif
 
-void dvb_table_eit_init (struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize_t size, uint8_t **buf, ssize_t *buflen);
+void dvb_table_eit_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
+void dvb_table_eit_free(struct dvb_table_eit *eit);
 void dvb_table_eit_print(struct dvb_v5_fe_parms *parms, struct dvb_table_eit *eit);
+void dvb_time(const uint8_t data[5], struct tm *tm);
 
 #ifdef __cplusplus
 }
diff --git a/lib/include/descriptors/nit.h b/lib/include/descriptors/nit.h
index 013a842..8a0b488 100644
--- a/lib/include/descriptors/nit.h
+++ b/lib/include/descriptors/nit.h
@@ -76,7 +76,8 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_table_nit_init (struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize_t size, uint8_t **buf, ssize_t *buflen);
+void dvb_table_nit_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
+void dvb_table_nit_free(struct dvb_table_nit *nit);
 void dvb_table_nit_print(struct dvb_v5_fe_parms *parms, struct dvb_table_nit *nit);
 
 #ifdef __cplusplus
diff --git a/lib/include/descriptors/pat.h b/lib/include/descriptors/pat.h
index ae7bbc5..b37ae40 100644
--- a/lib/include/descriptors/pat.h
+++ b/lib/include/descriptors/pat.h
@@ -57,7 +57,8 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_table_pat_init (struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize_t size, uint8_t **buf, ssize_t *buflen);
+void dvb_table_pat_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
+void dvb_table_pat_free(struct dvb_table_pat *pat);
 void dvb_table_pat_print(struct dvb_v5_fe_parms *parms, struct dvb_table_pat *t);
 
 #ifdef __cplusplus
diff --git a/lib/include/descriptors/pmt.h b/lib/include/descriptors/pmt.h
index b923677..504ae67 100644
--- a/lib/include/descriptors/pmt.h
+++ b/lib/include/descriptors/pmt.h
@@ -80,7 +80,8 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_table_pmt_init (struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize_t size, uint8_t **buf, ssize_t *buflen);
+void dvb_table_pmt_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
+void dvb_table_pmt_free(struct dvb_table_pmt *pmt);
 void dvb_table_pmt_print(struct dvb_v5_fe_parms *parms, const struct dvb_table_pmt *pmt);
 
 #ifdef __cplusplus
diff --git a/lib/include/descriptors/sdt.h b/lib/include/descriptors/sdt.h
index a968ac5..5c76498 100644
--- a/lib/include/descriptors/sdt.h
+++ b/lib/include/descriptors/sdt.h
@@ -64,7 +64,8 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_table_sdt_init (struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize_t size, uint8_t **buf, ssize_t *buflen);
+void dvb_table_sdt_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
+void dvb_table_sdt_free(struct dvb_table_sdt *sdt);
 void dvb_table_sdt_print(struct dvb_v5_fe_parms *parms, struct dvb_table_sdt *sdt);
 
 #ifdef __cplusplus
diff --git a/lib/include/dvb-scan.h b/lib/include/dvb-scan.h
index 9f4b914..7451a4a 100644
--- a/lib/include/dvb-scan.h
+++ b/lib/include/dvb-scan.h
@@ -26,13 +26,17 @@
 
 /* According with ISO/IEC 13818-1:2007 */
 
+#define MAX_TABLE_SIZE 1024 * 1024
 
 #ifdef __cplusplus
 extern "C" {
 #endif
 
-int dvb_read_section(struct dvb_v5_fe_parms *parms, int dmx_fd, unsigned char table, uint16_t pid, unsigned char **buf,
-		unsigned *length, unsigned timeout);
+int dvb_read_section(struct dvb_v5_fe_parms *parms, int dmx_fd, unsigned char tid, uint16_t pid, unsigned char **table,
+		unsigned timeout);
+
+int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd, unsigned char tid, uint16_t pid, int id, uint8_t **table,
+		unsigned timeout);
 
 struct dvb_v5_descriptors *dvb_get_ts_tables(struct dvb_v5_fe_parms *parms, int dmx_fd,
 					  uint32_t delivery_system,
diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
index d2041f5..ff6b863 100644
--- a/lib/libdvbv5/Makefile.am
+++ b/lib/libdvbv5/Makefile.am
@@ -35,6 +35,7 @@ libdvbv5_la_SOURCES = \
   descriptors/desc_frequency_list.c  ../include/descriptors/desc_frequency_list.h \
   descriptors/desc_service_list.c  ../include/descriptors/desc_service_list.h \
   descriptors/desc_event_short.c  ../include/descriptors/desc_event_short.h \
+  descriptors/desc_event_extended.c  ../include/descriptors/desc_event_extended.h \
   descriptors/nit.c  ../include/descriptors/nit.h \
   descriptors/sdt.c  ../include/descriptors/sdt.h \
   descriptors/eit.c  ../include/descriptors/eit.h
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index e580b09..d4fab9a 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -44,6 +44,7 @@
 #include "descriptors/desc_service_list.h"
 #include "descriptors/desc_frequency_list.h"
 #include "descriptors/desc_event_short.h"
+#include "descriptors/desc_event_extended.h"
 
 ssize_t dvb_desc_init(const uint8_t *buf, struct dvb_desc *desc)
 {
@@ -71,6 +72,7 @@ const struct dvb_table_init dvb_table_initializers[] = {
 	[DVB_TABLE_NIT] = { dvb_table_nit_init },
 	[DVB_TABLE_SDT] = { dvb_table_sdt_init },
 	[DVB_TABLE_EIT] = { dvb_table_eit_init },
+	[DVB_TABLE_EIT_SCHEDULE] = { dvb_table_eit_init },
 };
 
 char *default_charset = "iso-8859-1";
@@ -83,29 +85,26 @@ static char *table[] = {
 	[SDT] = "SDT",
 };
 
-ssize_t dvb_parse_descriptors(struct dvb_v5_fe_parms *parms, const uint8_t *buf, uint8_t *dest, uint16_t section_length, struct dvb_desc **head_desc)
+void dvb_parse_descriptors(struct dvb_v5_fe_parms *parms, const uint8_t *buf, uint16_t section_length, struct dvb_desc **head_desc)
 {
 	const uint8_t *ptr = buf;
-	ssize_t length = 0;
 	struct dvb_desc *current = NULL;
 	struct dvb_desc *last = NULL;
 	while (ptr < buf + section_length) {
-		current = (struct dvb_desc *) dest;
+		current = (struct dvb_desc *) malloc(section_length << 2);
 		ptr += dvb_desc_init(ptr, current); /* the standard header was read */
 		dvb_desc_init_func init = dvb_descriptors[current->type].init;
 		if (!init)
 			init = dvb_desc_default_init;
 		ssize_t len = init(parms, ptr, current);
+		current = (struct dvb_desc *) realloc(current, len);
 		if(!*head_desc)
 			*head_desc = current;
 		if (last)
 			last->next = current;
 		last = current;
-		dest += len;
-		length += len;
 		ptr += current->length;     /* standard descriptor header plus descriptor length */
 	}
-	return length;
 }
 
 void dvb_print_descriptors(struct dvb_v5_fe_parms *parms, struct dvb_desc *desc)
@@ -119,156 +118,170 @@ void dvb_print_descriptors(struct dvb_v5_fe_parms *parms, struct dvb_desc *desc)
 	}
 }
 
+void dvb_free_descriptors(struct dvb_desc **list)
+{
+	struct dvb_desc *desc = *list;
+	while (desc) {
+		struct dvb_desc *tmp = desc;
+		desc = desc->next;
+		if (dvb_descriptors[tmp->type].free)
+			dvb_descriptors[tmp->type].free(tmp);
+		else
+			free(tmp);
+	}
+	*list = NULL;
+}
+
 const struct dvb_descriptor dvb_descriptors[] = {
-	[0 ...255 ] = { "Unknown descriptor", NULL, NULL },
-	[video_stream_descriptor] = { "video_stream_descriptor", NULL, NULL },
-	[audio_stream_descriptor] = { "audio_stream_descriptor", NULL, NULL },
-	[hierarchy_descriptor] = { "hierarchy_descriptor", NULL, NULL },
-	[dvbpsi_registration_descriptor] = { "dvbpsi_registration_descriptor", NULL, NULL },
-	[ds_alignment_descriptor] = { "ds_alignment_descriptor", NULL, NULL },
-	[target_background_grid_descriptor] = { "target_background_grid_descriptor", NULL, NULL },
-	[video_window_descriptor] = { "video_window_descriptor", NULL, NULL },
-	[conditional_access_descriptor] = { "conditional_access_descriptor", NULL, NULL },
-	[iso639_language_descriptor] = { "iso639_language_descriptor", dvb_desc_language_init, dvb_desc_language_print },
-	[system_clock_descriptor] = { "system_clock_descriptor", NULL, NULL },
-	[multiplex_buffer_utilization_descriptor] = { "multiplex_buffer_utilization_descriptor", NULL, NULL },
-	[copyright_descriptor] = { "copyright_descriptor", NULL, NULL },
-	[maximum_bitrate_descriptor] = { "maximum_bitrate_descriptor", NULL, NULL },
-	[private_data_indicator_descriptor] = { "private_data_indicator_descriptor", NULL, NULL },
-	[smoothing_buffer_descriptor] = { "smoothing_buffer_descriptor", NULL, NULL },
-	[std_descriptor] = { "std_descriptor", NULL, NULL },
-	[ibp_descriptor] = { "ibp_descriptor", NULL, NULL },
-	[mpeg4_video_descriptor] = { "mpeg4_video_descriptor", NULL, NULL },
-	[mpeg4_audio_descriptor] = { "mpeg4_audio_descriptor", NULL, NULL },
-	[iod_descriptor] = { "iod_descriptor", NULL, NULL },
-	[sl_descriptor] = { "sl_descriptor", NULL, NULL },
-	[fmc_descriptor] = { "fmc_descriptor", NULL, NULL },
-	[external_es_id_descriptor] = { "external_es_id_descriptor", NULL, NULL },
-	[muxcode_descriptor] = { "muxcode_descriptor", NULL, NULL },
-	[fmxbuffersize_descriptor] = { "fmxbuffersize_descriptor", NULL, NULL },
-	[multiplexbuffer_descriptor] = { "multiplexbuffer_descriptor", NULL, NULL },
-	[content_labeling_descriptor] = { "content_labeling_descriptor", NULL, NULL },
-	[metadata_pointer_descriptor] = { "metadata_pointer_descriptor", NULL, NULL },
-	[metadata_descriptor] = { "metadata_descriptor", NULL, NULL },
-	[metadata_std_descriptor] = { "metadata_std_descriptor", NULL, NULL },
-	[AVC_video_descriptor] = { "AVC_video_descriptor", NULL, NULL },
-	[ipmp_descriptor] = { "ipmp_descriptor", NULL, NULL },
-	[AVC_timing_and_HRD_descriptor] = { "AVC_timing_and_HRD_descriptor", NULL, NULL },
-	[mpeg2_aac_audio_descriptor] = { "mpeg2_aac_audio_descriptor", NULL, NULL },
-	[flexmux_timing_descriptor] = { "flexmux_timing_descriptor", NULL, NULL },
-	[network_name_descriptor] = { "network_name_descriptor", dvb_desc_network_name_init, dvb_desc_network_name_print },
-	[service_list_descriptor] = { "service_list_descriptor", dvb_desc_service_list_init, dvb_desc_service_list_print },
-	[stuffing_descriptor] = { "stuffing_descriptor", NULL, NULL },
-	[satellite_delivery_system_descriptor] = { "satellite_delivery_system_descriptor", dvb_desc_sat_init, dvb_desc_sat_print },
-	[cable_delivery_system_descriptor] = { "cable_delivery_system_descriptor", dvb_desc_cable_delivery_init, dvb_desc_cable_delivery_print },
-	[VBI_data_descriptor] = { "VBI_data_descriptor", NULL, NULL },
-	[VBI_teletext_descriptor] = { "VBI_teletext_descriptor", NULL, NULL },
-	[bouquet_name_descriptor] = { "bouquet_name_descriptor", NULL, NULL },
-	[service_descriptor] = { "service_descriptor", dvb_desc_service_init, dvb_desc_service_print },
-	[country_availability_descriptor] = { "country_availability_descriptor", NULL, NULL },
-	[linkage_descriptor] = { "linkage_descriptor", NULL, NULL },
-	[NVOD_reference_descriptor] = { "NVOD_reference_descriptor", NULL, NULL },
-	[time_shifted_service_descriptor] = { "time_shifted_service_descriptor", NULL, NULL },
-	[short_event_descriptor] = { "short_event_descriptor", dvb_desc_event_short_init, dvb_desc_event_short_print },
-	[extended_event_descriptor] = { "extended_event_descriptor", NULL, NULL },
-	[time_shifted_event_descriptor] = { "time_shifted_event_descriptor", NULL, NULL },
-	[component_descriptor] = { "component_descriptor", NULL, NULL },
-	[mosaic_descriptor] = { "mosaic_descriptor", NULL, NULL },
-	[stream_identifier_descriptor] = { "stream_identifier_descriptor", NULL, NULL },
-	[CA_identifier_descriptor] = { "CA_identifier_descriptor", NULL, NULL },
-	[content_descriptor] = { "content_descriptor", NULL, NULL },
-	[parental_rating_descriptor] = { "parental_rating_descriptor", NULL, NULL },
-	[teletext_descriptor] = { "teletext_descriptor", NULL, NULL },
-	[telephone_descriptor] = { "telephone_descriptor", NULL, NULL },
-	[local_time_offset_descriptor] = { "local_time_offset_descriptor", NULL, NULL },
-	[subtitling_descriptor] = { "subtitling_descriptor", NULL, NULL },
-	[terrestrial_delivery_system_descriptor] = { "terrestrial_delivery_system_descriptor", dvb_desc_terrestrial_delivery_init, dvb_desc_terrestrial_delivery_print },
-	[multilingual_network_name_descriptor] = { "multilingual_network_name_descriptor", NULL, NULL },
-	[multilingual_bouquet_name_descriptor] = { "multilingual_bouquet_name_descriptor", NULL, NULL },
-	[multilingual_service_name_descriptor] = { "multilingual_service_name_descriptor", NULL, NULL },
-	[multilingual_component_descriptor] = { "multilingual_component_descriptor", NULL, NULL },
-	[private_data_specifier_descriptor] = { "private_data_specifier_descriptor", NULL, NULL },
-	[service_move_descriptor] = { "service_move_descriptor", NULL, NULL },
-	[short_smoothing_buffer_descriptor] = { "short_smoothing_buffer_descriptor", NULL, NULL },
-	[frequency_list_descriptor] = { "frequency_list_descriptor", dvb_desc_frequency_list_init, dvb_desc_frequency_list_print },
-	[partial_transport_stream_descriptor] = { "partial_transport_stream_descriptor", NULL, NULL },
-	[data_broadcast_descriptor] = { "data_broadcast_descriptor", NULL, NULL },
-	[scrambling_descriptor] = { "scrambling_descriptor", NULL, NULL },
-	[data_broadcast_id_descriptor] = { "data_broadcast_id_descriptor", NULL, NULL },
-	[transport_stream_descriptor] = { "transport_stream_descriptor", NULL, NULL },
-	[DSNG_descriptor] = { "DSNG_descriptor", NULL, NULL },
-	[PDC_descriptor] = { "PDC_descriptor", NULL, NULL },
-	[AC_3_descriptor] = { "AC_3_descriptor", NULL, NULL },
-	[ancillary_data_descriptor] = { "ancillary_data_descriptor", NULL, NULL },
-	[cell_list_descriptor] = { "cell_list_descriptor", NULL, NULL },
-	[cell_frequency_link_descriptor] = { "cell_frequency_link_descriptor", NULL, NULL },
-	[announcement_support_descriptor] = { "announcement_support_descriptor", NULL, NULL },
-	[application_signalling_descriptor] = { "application_signalling_descriptor", NULL, NULL },
-	[adaptation_field_data_descriptor] = { "adaptation_field_data_descriptor", NULL, NULL },
-	[service_identifier_descriptor] = { "service_identifier_descriptor", NULL, NULL },
-	[service_availability_descriptor] = { "service_availability_descriptor", NULL, NULL },
-	[default_authority_descriptor] = { "default_authority_descriptor", NULL, NULL },
-	[related_content_descriptor] = { "related_content_descriptor", NULL, NULL },
-	[TVA_id_descriptor] = { "TVA_id_descriptor", NULL, NULL },
-	[content_identifier_descriptor] = { "content_identifier_descriptor", NULL, NULL },
-	[time_slice_fec_identifier_descriptor] = { "time_slice_fec_identifier_descriptor", NULL, NULL },
-	[ECM_repetition_rate_descriptor] = { "ECM_repetition_rate_descriptor", NULL, NULL },
-	[S2_satellite_delivery_system_descriptor] = { "S2_satellite_delivery_system_descriptor", NULL, NULL },
-	[enhanced_AC_3_descriptor] = { "enhanced_AC_3_descriptor", NULL, NULL },
-	[DTS_descriptor] = { "DTS_descriptor", NULL, NULL },
-	[AAC_descriptor] = { "AAC_descriptor", NULL, NULL },
-	[XAIT_location_descriptor] = { "XAIT_location_descriptor", NULL, NULL },
-	[FTA_content_management_descriptor] = { "FTA_content_management_descriptor", NULL, NULL },
-	[extension_descriptor] = { "extension_descriptor", NULL, NULL },
-
-	[CUE_identifier_descriptor] = { "CUE_identifier_descriptor", NULL, NULL },
-
-	[component_name_descriptor] = { "component_name_descriptor", NULL, NULL },
-	[logical_channel_number_descriptor] = { "logical_channel_number_descriptor", NULL, NULL },
-
-	[carousel_id_descriptor] = { "carousel_id_descriptor", NULL, NULL },
-	[association_tag_descriptor] = { "association_tag_descriptor", NULL, NULL },
-	[deferred_association_tags_descriptor] = { "deferred_association_tags_descriptor", NULL, NULL },
-
-	[hierarchical_transmission_descriptor] = { "hierarchical_transmission_descriptor", NULL, NULL },
-	[digital_copy_control_descriptor] = { "digital_copy_control_descriptor", NULL, NULL },
-	[network_identifier_descriptor] = { "network_identifier_descriptor", NULL, NULL },
-	[partial_transport_stream_time_descriptor] = { "partial_transport_stream_time_descriptor", NULL, NULL },
-	[audio_component_descriptor] = { "audio_component_descriptor", NULL, NULL },
-	[hyperlink_descriptor] = { "hyperlink_descriptor", NULL, NULL },
-	[target_area_descriptor] = { "target_area_descriptor", NULL, NULL },
-	[data_contents_descriptor] = { "data_contents_descriptor", NULL, NULL },
-	[video_decode_control_descriptor] = { "video_decode_control_descriptor", NULL, NULL },
-	[download_content_descriptor] = { "download_content_descriptor", NULL, NULL },
-	[CA_EMM_TS_descriptor] = { "CA_EMM_TS_descriptor", NULL, NULL },
-	[CA_contract_information_descriptor] = { "CA_contract_information_descriptor", NULL, NULL },
-	[CA_service_descriptor] = { "CA_service_descriptor", NULL, NULL },
-	[TS_Information_descriptior] = { "TS_Information_descriptior", NULL, NULL },
-	[extended_broadcaster_descriptor] = { "extended_broadcaster_descriptor", NULL, NULL },
-	[logo_transmission_descriptor] = { "logo_transmission_descriptor", NULL, NULL },
-	[basic_local_event_descriptor] = { "basic_local_event_descriptor", NULL, NULL },
-	[reference_descriptor] = { "reference_descriptor", NULL, NULL },
-	[node_relation_descriptor] = { "node_relation_descriptor", NULL, NULL },
-	[short_node_information_descriptor] = { "short_node_information_descriptor", NULL, NULL },
-	[STC_reference_descriptor] = { "STC_reference_descriptor", NULL, NULL },
-	[series_descriptor] = { "series_descriptor", NULL, NULL },
-	[event_group_descriptor] = { "event_group_descriptor", NULL, NULL },
-	[SI_parameter_descriptor] = { "SI_parameter_descriptor", NULL, NULL },
-	[broadcaster_Name_Descriptor] = { "broadcaster_Name_Descriptor", NULL, NULL },
-	[component_group_descriptor] = { "component_group_descriptor", NULL, NULL },
-	[SI_prime_TS_descriptor] = { "SI_prime_TS_descriptor", NULL, NULL },
-	[board_information_descriptor] = { "board_information_descriptor", NULL, NULL },
-	[LDT_linkage_descriptor] = { "LDT_linkage_descriptor", NULL, NULL },
-	[connected_transmission_descriptor] = { "connected_transmission_descriptor", NULL, NULL },
-	[content_availability_descriptor] = { "content_availability_descriptor", NULL, NULL },
-	[service_group_descriptor] = { "service_group_descriptor", NULL, NULL },
-	[carousel_compatible_composite_Descriptor] = { "carousel_compatible_composite_Descriptor", NULL, NULL },
-	[conditional_playback_descriptor] = { "conditional_playback_descriptor", NULL, NULL },
-	[ISDBT_delivery_system_descriptor] = { "ISDBT_delivery_system_descriptor", NULL, NULL },
-	[partial_reception_descriptor] = { "partial_reception_descriptor", NULL, NULL },
-	[emergency_information_descriptor] = { "emergency_information_descriptor", NULL, NULL },
-	[data_component_descriptor] = { "data_component_descriptor", NULL, NULL },
-	[system_management_descriptor] = { "system_management_descriptor", NULL, NULL },
+	[0 ...255 ] = { "Unknown descriptor", NULL, NULL, NULL },
+	[video_stream_descriptor] = { "video_stream_descriptor", NULL, NULL, NULL },
+	[audio_stream_descriptor] = { "audio_stream_descriptor", NULL, NULL, NULL },
+	[hierarchy_descriptor] = { "hierarchy_descriptor", NULL, NULL, NULL },
+	[dvbpsi_registration_descriptor] = { "dvbpsi_registration_descriptor", NULL, NULL, NULL },
+	[ds_alignment_descriptor] = { "ds_alignment_descriptor", NULL, NULL, NULL },
+	[target_background_grid_descriptor] = { "target_background_grid_descriptor", NULL, NULL, NULL },
+	[video_window_descriptor] = { "video_window_descriptor", NULL, NULL, NULL },
+	[conditional_access_descriptor] = { "conditional_access_descriptor", NULL, NULL, NULL },
+	[iso639_language_descriptor] = { "iso639_language_descriptor", dvb_desc_language_init, dvb_desc_language_print, NULL },
+	[system_clock_descriptor] = { "system_clock_descriptor", NULL, NULL, NULL },
+	[multiplex_buffer_utilization_descriptor] = { "multiplex_buffer_utilization_descriptor", NULL, NULL, NULL },
+	[copyright_descriptor] = { "copyright_descriptor", NULL, NULL, NULL },
+	[maximum_bitrate_descriptor] = { "maximum_bitrate_descriptor", NULL, NULL, NULL },
+	[private_data_indicator_descriptor] = { "private_data_indicator_descriptor", NULL, NULL, NULL },
+	[smoothing_buffer_descriptor] = { "smoothing_buffer_descriptor", NULL, NULL, NULL },
+	[std_descriptor] = { "std_descriptor", NULL, NULL, NULL },
+	[ibp_descriptor] = { "ibp_descriptor", NULL, NULL, NULL },
+	[mpeg4_video_descriptor] = { "mpeg4_video_descriptor", NULL, NULL, NULL },
+	[mpeg4_audio_descriptor] = { "mpeg4_audio_descriptor", NULL, NULL, NULL },
+	[iod_descriptor] = { "iod_descriptor", NULL, NULL, NULL },
+	[sl_descriptor] = { "sl_descriptor", NULL, NULL, NULL },
+	[fmc_descriptor] = { "fmc_descriptor", NULL, NULL, NULL },
+	[external_es_id_descriptor] = { "external_es_id_descriptor", NULL, NULL, NULL },
+	[muxcode_descriptor] = { "muxcode_descriptor", NULL, NULL, NULL },
+	[fmxbuffersize_descriptor] = { "fmxbuffersize_descriptor", NULL, NULL, NULL },
+	[multiplexbuffer_descriptor] = { "multiplexbuffer_descriptor", NULL, NULL, NULL },
+	[content_labeling_descriptor] = { "content_labeling_descriptor", NULL, NULL, NULL },
+	[metadata_pointer_descriptor] = { "metadata_pointer_descriptor", NULL, NULL, NULL },
+	[metadata_descriptor] = { "metadata_descriptor", NULL, NULL, NULL },
+	[metadata_std_descriptor] = { "metadata_std_descriptor", NULL, NULL, NULL },
+	[AVC_video_descriptor] = { "AVC_video_descriptor", NULL, NULL, NULL },
+	[ipmp_descriptor] = { "ipmp_descriptor", NULL, NULL, NULL },
+	[AVC_timing_and_HRD_descriptor] = { "AVC_timing_and_HRD_descriptor", NULL, NULL, NULL },
+	[mpeg2_aac_audio_descriptor] = { "mpeg2_aac_audio_descriptor", NULL, NULL, NULL },
+	[flexmux_timing_descriptor] = { "flexmux_timing_descriptor", NULL, NULL, NULL },
+	[network_name_descriptor] = { "network_name_descriptor", dvb_desc_network_name_init, dvb_desc_network_name_print, NULL },
+	[service_list_descriptor] = { "service_list_descriptor", dvb_desc_service_list_init, dvb_desc_service_list_print, NULL },
+	[stuffing_descriptor] = { "stuffing_descriptor", NULL, NULL, NULL },
+	[satellite_delivery_system_descriptor] = { "satellite_delivery_system_descriptor", dvb_desc_sat_init, dvb_desc_sat_print, NULL },
+	[cable_delivery_system_descriptor] = { "cable_delivery_system_descriptor", dvb_desc_cable_delivery_init, dvb_desc_cable_delivery_print, NULL },
+	[VBI_data_descriptor] = { "VBI_data_descriptor", NULL, NULL, NULL },
+	[VBI_teletext_descriptor] = { "VBI_teletext_descriptor", NULL, NULL, NULL },
+	[bouquet_name_descriptor] = { "bouquet_name_descriptor", NULL, NULL, NULL },
+	[service_descriptor] = { "service_descriptor", dvb_desc_service_init, dvb_desc_service_print, dvb_desc_service_free },
+	[country_availability_descriptor] = { "country_availability_descriptor", NULL, NULL, NULL },
+	[linkage_descriptor] = { "linkage_descriptor", NULL, NULL, NULL },
+	[NVOD_reference_descriptor] = { "NVOD_reference_descriptor", NULL, NULL, NULL },
+	[time_shifted_service_descriptor] = { "time_shifted_service_descriptor", NULL, NULL, NULL },
+	[short_event_descriptor] = { "short_event_descriptor", dvb_desc_event_short_init, dvb_desc_event_short_print, dvb_desc_event_short_free },
+	[extended_event_descriptor] = { "extended_event_descriptor", dvb_desc_event_extended_init, dvb_desc_event_extended_print, dvb_desc_event_extended_free },
+	[time_shifted_event_descriptor] = { "time_shifted_event_descriptor", NULL, NULL, NULL },
+	[component_descriptor] = { "component_descriptor", NULL, NULL, NULL },
+	[mosaic_descriptor] = { "mosaic_descriptor", NULL, NULL, NULL },
+	[stream_identifier_descriptor] = { "stream_identifier_descriptor", NULL, NULL, NULL },
+	[CA_identifier_descriptor] = { "CA_identifier_descriptor", NULL, NULL, NULL },
+	[content_descriptor] = { "content_descriptor", NULL, NULL, NULL },
+	[parental_rating_descriptor] = { "parental_rating_descriptor", NULL, NULL, NULL },
+	[teletext_descriptor] = { "teletext_descriptor", NULL, NULL, NULL },
+	[telephone_descriptor] = { "telephone_descriptor", NULL, NULL, NULL },
+	[local_time_offset_descriptor] = { "local_time_offset_descriptor", NULL, NULL, NULL },
+	[subtitling_descriptor] = { "subtitling_descriptor", NULL, NULL, NULL },
+	[terrestrial_delivery_system_descriptor] = { "terrestrial_delivery_system_descriptor", dvb_desc_terrestrial_delivery_init, dvb_desc_terrestrial_delivery_print, NULL },
+	[multilingual_network_name_descriptor] = { "multilingual_network_name_descriptor", NULL, NULL, NULL },
+	[multilingual_bouquet_name_descriptor] = { "multilingual_bouquet_name_descriptor", NULL, NULL, NULL },
+	[multilingual_service_name_descriptor] = { "multilingual_service_name_descriptor", NULL, NULL, NULL },
+	[multilingual_component_descriptor] = { "multilingual_component_descriptor", NULL, NULL, NULL },
+	[private_data_specifier_descriptor] = { "private_data_specifier_descriptor", NULL, NULL, NULL },
+	[service_move_descriptor] = { "service_move_descriptor", NULL, NULL, NULL },
+	[short_smoothing_buffer_descriptor] = { "short_smoothing_buffer_descriptor", NULL, NULL, NULL },
+	[frequency_list_descriptor] = { "frequency_list_descriptor", dvb_desc_frequency_list_init, dvb_desc_frequency_list_print, NULL },
+	[partial_transport_stream_descriptor] = { "partial_transport_stream_descriptor", NULL, NULL, NULL },
+	[data_broadcast_descriptor] = { "data_broadcast_descriptor", NULL, NULL, NULL },
+	[scrambling_descriptor] = { "scrambling_descriptor", NULL, NULL, NULL },
+	[data_broadcast_id_descriptor] = { "data_broadcast_id_descriptor", NULL, NULL, NULL },
+	[transport_stream_descriptor] = { "transport_stream_descriptor", NULL, NULL, NULL },
+	[DSNG_descriptor] = { "DSNG_descriptor", NULL, NULL, NULL },
+	[PDC_descriptor] = { "PDC_descriptor", NULL, NULL, NULL },
+	[AC_3_descriptor] = { "AC_3_descriptor", NULL, NULL, NULL },
+	[ancillary_data_descriptor] = { "ancillary_data_descriptor", NULL, NULL, NULL },
+	[cell_list_descriptor] = { "cell_list_descriptor", NULL, NULL, NULL },
+	[cell_frequency_link_descriptor] = { "cell_frequency_link_descriptor", NULL, NULL, NULL },
+	[announcement_support_descriptor] = { "announcement_support_descriptor", NULL, NULL, NULL },
+	[application_signalling_descriptor] = { "application_signalling_descriptor", NULL, NULL, NULL },
+	[adaptation_field_data_descriptor] = { "adaptation_field_data_descriptor", NULL, NULL, NULL },
+	[service_identifier_descriptor] = { "service_identifier_descriptor", NULL, NULL, NULL },
+	[service_availability_descriptor] = { "service_availability_descriptor", NULL, NULL, NULL },
+	[default_authority_descriptor] = { "default_authority_descriptor", NULL, NULL, NULL },
+	[related_content_descriptor] = { "related_content_descriptor", NULL, NULL, NULL },
+	[TVA_id_descriptor] = { "TVA_id_descriptor", NULL, NULL, NULL },
+	[content_identifier_descriptor] = { "content_identifier_descriptor", NULL, NULL, NULL },
+	[time_slice_fec_identifier_descriptor] = { "time_slice_fec_identifier_descriptor", NULL, NULL, NULL },
+	[ECM_repetition_rate_descriptor] = { "ECM_repetition_rate_descriptor", NULL, NULL, NULL },
+	[S2_satellite_delivery_system_descriptor] = { "S2_satellite_delivery_system_descriptor", NULL, NULL, NULL },
+	[enhanced_AC_3_descriptor] = { "enhanced_AC_3_descriptor", NULL, NULL, NULL },
+	[DTS_descriptor] = { "DTS_descriptor", NULL, NULL, NULL },
+	[AAC_descriptor] = { "AAC_descriptor", NULL, NULL, NULL },
+	[XAIT_location_descriptor] = { "XAIT_location_descriptor", NULL, NULL, NULL },
+	[FTA_content_management_descriptor] = { "FTA_content_management_descriptor", NULL, NULL, NULL },
+	[extension_descriptor] = { "extension_descriptor", NULL, NULL, NULL },
+
+	[CUE_identifier_descriptor] = { "CUE_identifier_descriptor", NULL, NULL, NULL },
+
+	[component_name_descriptor] = { "component_name_descriptor", NULL, NULL, NULL },
+	[logical_channel_number_descriptor] = { "logical_channel_number_descriptor", NULL, NULL, NULL },
+
+	[carousel_id_descriptor] = { "carousel_id_descriptor", NULL, NULL, NULL },
+	[association_tag_descriptor] = { "association_tag_descriptor", NULL, NULL, NULL },
+	[deferred_association_tags_descriptor] = { "deferred_association_tags_descriptor", NULL, NULL, NULL },
+
+	[hierarchical_transmission_descriptor] = { "hierarchical_transmission_descriptor", NULL, NULL, NULL },
+	[digital_copy_control_descriptor] = { "digital_copy_control_descriptor", NULL, NULL, NULL },
+	[network_identifier_descriptor] = { "network_identifier_descriptor", NULL, NULL, NULL },
+	[partial_transport_stream_time_descriptor] = { "partial_transport_stream_time_descriptor", NULL, NULL, NULL },
+	[audio_component_descriptor] = { "audio_component_descriptor", NULL, NULL, NULL },
+	[hyperlink_descriptor] = { "hyperlink_descriptor", NULL, NULL, NULL },
+	[target_area_descriptor] = { "target_area_descriptor", NULL, NULL, NULL },
+	[data_contents_descriptor] = { "data_contents_descriptor", NULL, NULL, NULL },
+	[video_decode_control_descriptor] = { "video_decode_control_descriptor", NULL, NULL, NULL },
+	[download_content_descriptor] = { "download_content_descriptor", NULL, NULL, NULL },
+	[CA_EMM_TS_descriptor] = { "CA_EMM_TS_descriptor", NULL, NULL, NULL },
+	[CA_contract_information_descriptor] = { "CA_contract_information_descriptor", NULL, NULL, NULL },
+	[CA_service_descriptor] = { "CA_service_descriptor", NULL, NULL, NULL },
+	[TS_Information_descriptior] = { "TS_Information_descriptior", NULL, NULL, NULL },
+	[extended_broadcaster_descriptor] = { "extended_broadcaster_descriptor", NULL, NULL, NULL },
+	[logo_transmission_descriptor] = { "logo_transmission_descriptor", NULL, NULL, NULL },
+	[basic_local_event_descriptor] = { "basic_local_event_descriptor", NULL, NULL, NULL },
+	[reference_descriptor] = { "reference_descriptor", NULL, NULL, NULL },
+	[node_relation_descriptor] = { "node_relation_descriptor", NULL, NULL, NULL },
+	[short_node_information_descriptor] = { "short_node_information_descriptor", NULL, NULL, NULL },
+	[STC_reference_descriptor] = { "STC_reference_descriptor", NULL, NULL, NULL },
+	[series_descriptor] = { "series_descriptor", NULL, NULL, NULL },
+	[event_group_descriptor] = { "event_group_descriptor", NULL, NULL, NULL },
+	[SI_parameter_descriptor] = { "SI_parameter_descriptor", NULL, NULL, NULL },
+	[broadcaster_Name_Descriptor] = { "broadcaster_Name_Descriptor", NULL, NULL, NULL },
+	[component_group_descriptor] = { "component_group_descriptor", NULL, NULL, NULL },
+	[SI_prime_TS_descriptor] = { "SI_prime_TS_descriptor", NULL, NULL, NULL },
+	[board_information_descriptor] = { "board_information_descriptor", NULL, NULL, NULL },
+	[LDT_linkage_descriptor] = { "LDT_linkage_descriptor", NULL, NULL, NULL },
+	[connected_transmission_descriptor] = { "connected_transmission_descriptor", NULL, NULL, NULL },
+	[content_availability_descriptor] = { "content_availability_descriptor", NULL, NULL, NULL },
+	[service_group_descriptor] = { "service_group_descriptor", NULL, NULL, NULL },
+	[carousel_compatible_composite_Descriptor] = { "carousel_compatible_composite_Descriptor", NULL, NULL, NULL },
+	[conditional_playback_descriptor] = { "conditional_playback_descriptor", NULL, NULL, NULL },
+	[ISDBT_delivery_system_descriptor] = { "ISDBT_delivery_system_descriptor", NULL, NULL, NULL },
+	[partial_reception_descriptor] = { "partial_reception_descriptor", NULL, NULL, NULL },
+	[emergency_information_descriptor] = { "emergency_information_descriptor", NULL, NULL, NULL },
+	[data_component_descriptor] = { "data_component_descriptor", NULL, NULL, NULL },
+	[system_management_descriptor] = { "system_management_descriptor", NULL, NULL, NULL },
 };
 
 static const char *extension_descriptors[] = {
diff --git a/lib/libdvbv5/descriptors/desc_event_extended.c b/lib/libdvbv5/descriptors/desc_event_extended.c
new file mode 100644
index 0000000..acd012c
--- /dev/null
+++ b/lib/libdvbv5/descriptors/desc_event_extended.c
@@ -0,0 +1,81 @@
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
+#include "descriptors/desc_event_extended.h"
+#include "descriptors.h"
+#include "dvb-fe.h"
+#include "parse_string.h"
+
+ssize_t dvb_desc_event_extended_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+{
+	struct dvb_desc_event_extended *event = (struct dvb_desc_event_extended *) desc;
+	uint8_t len;  /* the length of the string in the input data */
+	uint8_t len1; /* the lenght of the output strings */
+
+	/*hexdump(parms, "event extended desc: ", buf - 2, desc->length + 2);*/
+
+	event->ids = buf[0];
+	event->language[0] = buf[1];
+	event->language[1] = buf[2];
+	event->language[2] = buf[3];
+	event->language[3] = '\0';
+
+	uint8_t items = buf[4];
+	buf += 5;
+
+	int i;
+	for (i = 0; i < items; i++) {
+		dvb_logwarn("dvb_desc_event_extended: items not implemented");
+		uint8_t desc_len = *buf;
+		buf++;
+
+		buf += desc_len;
+
+		uint8_t item_len = *buf;
+		buf++;
+
+		buf += item_len;
+	}
+
+	event->text = NULL;
+	event->text_emph = NULL;
+	len = *buf;
+	len1 = len;
+	buf++;
+	parse_string(parms, &event->text, &event->text_emph, buf, len1, default_charset, output_charset);
+	buf += len;
+
+	return sizeof(struct dvb_desc_event_extended);
+}
+
+void dvb_desc_event_extended_free(struct dvb_desc *desc)
+{
+	struct dvb_desc_event_extended *event = (struct dvb_desc_event_extended *) desc;
+	free(event->text);
+	free(event->text_emph);
+}
+
+void dvb_desc_event_extended_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
+{
+	const struct dvb_desc_event_extended *event = (const struct dvb_desc_event_extended *) desc;
+	dvb_log("|   Description   '%s'", event->text);
+}
+
diff --git a/lib/libdvbv5/descriptors/desc_event_short.c b/lib/libdvbv5/descriptors/desc_event_short.c
index 2962d83..03d197c 100644
--- a/lib/libdvbv5/descriptors/desc_event_short.c
+++ b/lib/libdvbv5/descriptors/desc_event_short.c
@@ -27,7 +27,6 @@
 ssize_t dvb_desc_event_short_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_event_short *event = (struct dvb_desc_event_short *) desc;
-	char *string, *emph;
 	uint8_t len;        /* the length of the string in the input data */
 	uint8_t len1, len2; /* the lenght of the output strings */
 
@@ -39,51 +38,39 @@ ssize_t dvb_desc_event_short_init(struct dvb_v5_fe_parms *parms, const uint8_t *
 	event->language[3] = '\0';
 	buf += 3;
 
-	event->name = ((char *) desc) + sizeof(struct dvb_desc_event_short);
+	event->name = NULL;
+	event->name_emph = NULL;
 	len = buf[0];
 	buf++;
 	len1 = len;
-	string = NULL;
-	emph   = NULL;
-	parse_string(parms, &string, &emph, buf, len1, default_charset, output_charset);
+	parse_string(parms, &event->name, &event->name_emph, buf, len1, default_charset, output_charset);
 	buf += len;
-	if (emph)
-		free(emph);
-	if (string) {
-		len1 = strlen(string);
-		memcpy(event->name, string, len1);
-		free(string);
-	} else {
-		memcpy(event->name, buf, len1);
-	}
-	event->name[len1] = '\0';
 
-	event->text = event->name + len1 + 1;
+	event->text = NULL;
+	event->text_emph = NULL;
 	len = buf[0];
 	len2 = len;
 	buf++;
-	string = NULL;
-	emph   = NULL;
-	parse_string(parms, &string, &emph, buf, len2, default_charset, output_charset);
+	parse_string(parms, &event->text, &event->text_emph, buf, len2, default_charset, output_charset);
 	buf += len;
-	if (emph)
-		free(emph);
-	if (string) {
-		len2 = strlen(string);
-		memcpy(event->text, string, len2);
-		free(string);
-	} else {
-		memcpy(event->text, buf, len2);
-	}
-	event->text[len2] = '\0';
 
-	return sizeof(struct dvb_desc_event_short) + len1 + 1 + len2 + 1;
+	return sizeof(struct dvb_desc_event_short);
+}
+
+void dvb_desc_event_short_free(struct dvb_desc *desc)
+{
+	struct dvb_desc_event_short *event = (struct dvb_desc_event_short *) desc;
+	free(event->name);
+	free(event->name_emph);
+	free(event->text);
+	free(event->text_emph);
 }
 
 void dvb_desc_event_short_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
 {
 	const struct dvb_desc_event_short *event = (const struct dvb_desc_event_short *) desc;
-	dvb_log("|   Event         '%s'", event->name);
+	dvb_log("|   Name          '%s'", event->name);
+	dvb_log("|   Language      '%s'", event->language);
 	dvb_log("|   Description   '%s'", event->text);
 }
 
diff --git a/lib/libdvbv5/descriptors/desc_service.c b/lib/libdvbv5/descriptors/desc_service.c
index c3d4727..e921790 100644
--- a/lib/libdvbv5/descriptors/desc_service.c
+++ b/lib/libdvbv5/descriptors/desc_service.c
@@ -27,7 +27,6 @@
 ssize_t dvb_desc_service_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_service *service = (struct dvb_desc_service *) desc;
-	char *name, *emph;
 	uint8_t len;        /* the length of the string in the input data */
 	uint8_t len1, len2; /* the lenght of the output strings */
 
@@ -35,45 +34,32 @@ ssize_t dvb_desc_service_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 	service->service_type = buf[0];
 	buf++;
 
-	service->provider = ((char *) desc) + sizeof(struct dvb_desc_service);
+	service->provider = NULL;
+	service->provider_emph = NULL;
 	len = buf[0];
 	buf++;
 	len1 = len;
-	name = NULL;
-	emph = NULL;
-	parse_string(parms, &name, &emph, buf, len1, default_charset, output_charset);
+	parse_string(parms, &service->provider, &service->provider_emph, buf, len1, default_charset, output_charset);
 	buf += len;
-	if (emph)
-		free(emph);
-	if (name) {
-		len1 = strlen(name);
-		memcpy(service->provider, name, len1);
-		free(name);
-	} else {
-		memcpy(service->provider, buf, len1);
-	}
-	service->provider[len1] = '\0';
 
-	service->name = service->provider + len1 + 1;
+	service->name = NULL;
+	service->name_emph = NULL;
 	len = buf[0];
 	len2 = len;
 	buf++;
-	name = NULL;
-	emph = NULL;
-	parse_string(parms, &name, &emph, buf, len2, default_charset, output_charset);
+	parse_string(parms, &service->name, &service->name_emph, buf, len2, default_charset, output_charset);
 	buf += len;
-	if (emph)
-		free(emph);
-	if (name) {
-		len2 = strlen(name);
-		memcpy(service->name, name, len2);
-		free(name);
-	} else {
-		memcpy(service->name, buf, len2);
-	}
-	service->name[len2] = '\0';
 
-	return sizeof(struct dvb_desc_service) + len1 + 1 + len2 + 1;
+	return sizeof(struct dvb_desc_service);
+}
+
+void dvb_desc_service_free(struct dvb_desc *desc)
+{
+	struct dvb_desc_service *service = (struct dvb_desc_service *) desc;
+	free(service->provider);
+	free(service->provider_emph);
+	free(service->name);
+	free(service->name_emph);
 }
 
 void dvb_desc_service_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/eit.c b/lib/libdvbv5/descriptors/eit.c
index 1551272..ccfe1a6 100644
--- a/lib/libdvbv5/descriptors/eit.c
+++ b/lib/libdvbv5/descriptors/eit.c
@@ -22,52 +22,44 @@
 #include "descriptors/eit.h"
 #include "dvb-fe.h"
 
-void dvb_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize_t size, uint8_t **buf, ssize_t *buflen)
+void dvb_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length)
 {
-	uint8_t *d;
-	const uint8_t *p = ptr;
-	struct dvb_table_eit *eit = (struct dvb_table_eit *) ptr;
+	const uint8_t *p = buf;
+	struct dvb_table_eit *eit = (struct dvb_table_eit *) table;
 	struct dvb_table_eit_event **head;
 
-	bswap16(eit->transport_id);
-	bswap16(eit->network_id);
-
-	if (!*buf) {
-		d = malloc(DVB_MAX_PAYLOAD_PACKET_SIZE * 2);
-		*buf = d;
-		*buflen = 0;
-		eit = (struct dvb_table_eit *) d;
-		memcpy(eit, p, sizeof(struct dvb_table_eit) - sizeof(eit->event));
-		*buflen += sizeof(struct dvb_table_eit);
-
-		eit->event = NULL;
-		head = &eit->event;
-	} else {
-		// should realloc d
-		d = *buf;
-
+	if (*table_length > 0) {
 		/* find end of curent list */
-		eit = (struct dvb_table_eit *) d;
 		head = &eit->event;
 		while (*head != NULL)
 			head = &(*head)->next;
+	} else {
+		memcpy(eit, p, sizeof(struct dvb_table_eit) - sizeof(eit->event));
+		*table_length = sizeof(struct dvb_table_eit);
 
-		/* read new table */
-		eit = (struct dvb_table_eit *) p;
+		bswap16(eit->transport_id);
+		bswap16(eit->network_id);
+
+		eit->event = NULL;
+		head = &eit->event;
 	}
 	p += sizeof(struct dvb_table_eit) - sizeof(eit->event);
 
 	struct dvb_table_eit_event *last = NULL;
-	while ((uint8_t *) p < ptr + size - 4) {
-		struct dvb_table_eit_event *event = (struct dvb_table_eit_event *) (d + *buflen);
-		memcpy(d + *buflen, p, sizeof(struct dvb_table_eit_event) - sizeof(event->descriptor) - sizeof(event->next));
-		p += sizeof(struct dvb_table_eit_event) - sizeof(event->descriptor) - sizeof(event->next);
-		*buflen += sizeof(struct dvb_table_eit_event);
+	while ((uint8_t *) p < buf + buflen - 4) {
+		struct dvb_table_eit_event *event = (struct dvb_table_eit_event *) malloc(sizeof(struct dvb_table_eit_event));
+		memcpy(event, p, sizeof(struct dvb_table_eit_event) - sizeof(event->descriptor) - sizeof(event->next) - sizeof(event->start) - sizeof(event->duration));
+		p += sizeof(struct dvb_table_eit_event) - sizeof(event->descriptor) - sizeof(event->next) - sizeof(event->start) - sizeof(event->duration);
 
 		bswap16(event->event_id);
 		bswap16(event->bitfield);
+		bswap16(event->bitfield2);
 		event->descriptor = NULL;
 		event->next = NULL;
+		dvb_time(event->dvbstart, &event->start);
+		event->duration = bcd(event->dvbduration[0]) * 3600 +
+				  bcd(event->dvbduration[1]) * 60 +
+				  bcd(event->dvbduration[2]);
 
 		if(!*head)
 			*head = event;
@@ -76,13 +68,25 @@ void dvb_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize
 
 		/* get the descriptors for each program */
 		struct dvb_desc **head_desc = &event->descriptor;
-		*buflen += dvb_parse_descriptors(parms, p, d + *buflen, event->section_length, head_desc);
+		dvb_parse_descriptors(parms, p, event->section_length, head_desc);
 
 		p += event->section_length;
 		last = event;
 	}
 }
 
+void dvb_table_eit_free(struct dvb_table_eit *eit)
+{
+	struct dvb_table_eit_event *event = eit->event;
+	while (event) {
+		dvb_free_descriptors((struct dvb_desc **) &event->descriptor);
+		struct dvb_table_eit_event *tmp = event;
+		event = event->next;
+		free(tmp);
+	}
+	free(eit);
+}
+
 void dvb_table_eit_print(struct dvb_v5_fe_parms *parms, struct dvb_table_eit *eit)
 {
 	dvb_log("EIT");
@@ -94,10 +98,14 @@ void dvb_table_eit_print(struct dvb_v5_fe_parms *parms, struct dvb_table_eit *ei
 	dvb_log("|\\  event_id");
 	const struct dvb_table_eit_event *event = eit->event;
 	uint16_t events = 0;
-	while(event) {
+	while (event) {
+		char start[255];
+		strftime(start, sizeof(start), "%F %T", &event->start);
 		dvb_log("|- %7d", event->event_id);
+		dvb_log("|   Start                 %s UTC", start);
+		dvb_log("|   Duration              %dh %dm %ds", event->duration / 3600, (event->duration % 3600) / 60, event->duration % 60);
 		dvb_log("|   free CA mode          %d", event->free_CA_mode);
-		dvb_log("|   running status        %d", event->running_status);
+		dvb_log("|   running status        %d: %s", event->running_status, dvb_eit_running_status_name[event->running_status] );
 		dvb_print_descriptors(parms, event->descriptor);
 		event = event->next;
 		events++;
@@ -105,3 +113,41 @@ void dvb_table_eit_print(struct dvb_v5_fe_parms *parms, struct dvb_table_eit *ei
 	dvb_log("|_  %d events", events);
 }
 
+void dvb_time(const uint8_t data[5], struct tm *tm)
+{
+  /* ETSI EN 300 468 V1.4.1 */
+  int year, month, day, hour, min, sec;
+  int k = 0;
+  uint16_t mjd;
+
+  mjd   = *(uint16_t *) data;
+  hour  = bcd(data[2]);
+  min   = bcd(data[3]);
+  sec   = bcd(data[4]);
+  year  = ((mjd - 15078.2) / 365.25);
+  month = ((mjd - 14956.1 - (int) (year * 365.25)) / 30.6001);
+  day   = mjd - 14956 - (int) (year * 365.25) - (int) (month * 30.6001);
+  if (month == 14 || month == 15) k = 1;
+  year += k;
+  month = month - 1 - k * 12;
+
+  tm->tm_sec   = sec;
+  tm->tm_min   = min;
+  tm->tm_hour  = hour;
+  tm->tm_mday  = day;
+  tm->tm_mon   = month - 1;
+  tm->tm_year  = year;
+  tm->tm_isdst = -1;
+  tm->tm_wday  = 0;
+  tm->tm_yday  = 0;
+}
+
+
+const char *dvb_eit_running_status_name[8] = {
+	[0] = "Undefined",
+	[1] = "Not running",
+	[2] = "Starts in a few seconds",
+	[3] = "Pausing",
+	[4] = "Running",
+        [5 ... 7] = "Reserved"
+};
diff --git a/lib/libdvbv5/descriptors/nit.c b/lib/libdvbv5/descriptors/nit.c
index 6b4ebae..f0e7714 100644
--- a/lib/libdvbv5/descriptors/nit.c
+++ b/lib/libdvbv5/descriptors/nit.c
@@ -22,57 +22,50 @@
 #include "descriptors/nit.h"
 #include "dvb-fe.h"
 
-void dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize_t size, uint8_t **buf, ssize_t *buflen)
+void dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length)
 {
-	uint8_t *d;
-	const uint8_t *p = ptr;
-	struct dvb_table_nit *nit = (struct dvb_table_nit *) ptr;
+	const uint8_t *p = buf;
+	struct dvb_table_nit *nit = (struct dvb_table_nit *) table;
 	struct dvb_desc **head_desc;
 	struct dvb_table_nit_transport **head;
+	int desc_length;
 
-	bswap16(nit->bitfield);
+	if (*table_length > 0) {
+		/* find end of curent lists */
+		head_desc = &nit->descriptor;
+		while (*head_desc != NULL)
+			head_desc = &(*head_desc)->next;
+		head = &nit->transport;
+		while (*head != NULL)
+			head = &(*head)->next;
 
-	if (!*buf) {
-		d = malloc(DVB_MAX_PAYLOAD_PACKET_SIZE * 4);
-		*buf = d;
-		*buflen = 0;
-		nit = (struct dvb_table_nit *) d;
+		struct dvb_table_nit *t = (struct dvb_table_nit *) buf;
+		bswap16(t->bitfield);
+		desc_length = t->desc_length;
 
-		memcpy(d + *buflen, p, sizeof(struct dvb_table_nit) - sizeof(nit->descriptor) - sizeof(nit->transport));
-		*buflen += sizeof(struct dvb_table_nit);
+	} else {
+		memcpy(table, p, sizeof(struct dvb_table_nit) - sizeof(nit->descriptor) - sizeof(nit->transport));
+		*table_length = sizeof(struct dvb_table_nit);
 
+		bswap16(nit->bitfield);
 		nit->descriptor = NULL;
 		nit->transport = NULL;
 		head_desc = &nit->descriptor;
 		head = &nit->transport;
-	} else {
-		// should realloc d
-		d = *buf;
-
-		// find end of curent list
-		nit = (struct dvb_table_nit *) d;
-		head_desc = &nit->descriptor;
-		while (*head_desc != NULL)
-			head_desc = &(*head_desc)->next;
-		head = &nit->transport;
-		while (*head != NULL)
-			head = &(*head)->next;
-		// read new table
-		nit = (struct dvb_table_nit *) p; // FIXME: should be copied to tmp, cause bswap in const
+		desc_length = nit->desc_length;
 	}
 	p += sizeof(struct dvb_table_nit) - sizeof(nit->descriptor) - sizeof(nit->transport);
 
-	*buflen += dvb_parse_descriptors(parms, p, d + *buflen, nit->desc_length, head_desc);
-	p += nit->desc_length;
+	dvb_parse_descriptors(parms, p, desc_length, head_desc);
+	p += desc_length;
 
 	p += sizeof(union dvb_table_nit_transport_header);
 
 	struct dvb_table_nit_transport *last = NULL;
-	while ((uint8_t *) p < ptr + size - 4) {
-		struct dvb_table_nit_transport *transport = (struct dvb_table_nit_transport *) (d + *buflen);
-		memcpy(d + *buflen, p, sizeof(struct dvb_table_nit_transport) - sizeof(transport->descriptor) - sizeof(transport->next));
+	while ((uint8_t *) p < buf + buflen - 4) {
+		struct dvb_table_nit_transport *transport = (struct dvb_table_nit_transport *) malloc(sizeof(struct dvb_table_nit_transport));
+		memcpy(transport, p, sizeof(struct dvb_table_nit_transport) - sizeof(transport->descriptor) - sizeof(transport->next));
 		p += sizeof(struct dvb_table_nit_transport) - sizeof(transport->descriptor) - sizeof(transport->next);
-		*buflen += sizeof(struct dvb_table_nit_transport);
 
 		bswap16(transport->transport_id);
 		bswap16(transport->network_id);
@@ -87,24 +80,32 @@ void dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize
 
 		/* get the descriptors for each transport */
 		struct dvb_desc **head_desc = &transport->descriptor;
-		*buflen += dvb_parse_descriptors(parms, p, d + *buflen, transport->section_length, head_desc);
+		dvb_parse_descriptors(parms, p, transport->section_length, head_desc);
 
 		p += transport->section_length;
 		last = transport;
 	}
 }
 
+void dvb_table_nit_free(struct dvb_table_nit *nit)
+{
+	struct dvb_table_nit_transport *transport = nit->transport;
+	dvb_free_descriptors((struct dvb_desc **) &nit->descriptor);
+	while(transport) {
+		dvb_free_descriptors((struct dvb_desc **) &transport->descriptor);
+		struct dvb_table_nit_transport *tmp = transport;
+		transport = transport->next;
+		free(tmp);
+	}
+	free(nit);
+}
+
 void dvb_table_nit_print(struct dvb_v5_fe_parms *parms, struct dvb_table_nit *nit)
 {
 	dvb_log("NIT");
 	dvb_table_header_print(parms, &nit->header);
 	dvb_log("| desc_length   %d", nit->desc_length);
-	struct dvb_desc *desc = nit->descriptor;
-	while (desc) {
-		if (dvb_descriptors[desc->type].print)
-			dvb_descriptors[desc->type].print(parms, desc);
-		desc = desc->next;
-	}
+	dvb_print_descriptors(parms, nit->descriptor);
 	const struct dvb_table_nit_transport *transport = nit->transport;
 	uint16_t transports = 0;
 	while(transport) {
diff --git a/lib/libdvbv5/descriptors/pat.c b/lib/libdvbv5/descriptors/pat.c
index 781dedd..6b5a03b 100644
--- a/lib/libdvbv5/descriptors/pat.c
+++ b/lib/libdvbv5/descriptors/pat.c
@@ -23,40 +23,43 @@
 #include "descriptors.h"
 #include "dvb-fe.h"
 
-void dvb_table_pat_init(struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize_t size, uint8_t **buf, ssize_t *buflen)
+void dvb_table_pat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length)
 {
-	uint8_t *d;
-	struct dvb_table_pat *pat;
-	if (!*buf) {
-		d = malloc(size + sizeof(uint16_t));
-		*buf = d;
-		*buflen = size + sizeof(uint16_t);
-		pat = (struct dvb_table_pat *) d;
-		memcpy(pat, ptr, sizeof(struct dvb_table_pat) - sizeof(uint16_t));
-
-		struct dvb_table_pat_program *p = (struct dvb_table_pat_program *)
-			                          (ptr + sizeof(struct dvb_table_pat) - sizeof(uint16_t));
-		pat->programs = 0;
-		while ((uint8_t *) p < ptr + size - 4) {
-			memcpy(pat->program + pat->programs, p, sizeof(struct dvb_table_pat_program));
-			bswap16(pat->program[pat->programs].service_id);
-			bswap16(pat->program[pat->programs].bitfield);
-			p++;
-			pat->programs++;
-		}
-	} else {
+	if (*table_length > 0) {
 		dvb_logerr("multisection PAT table not implemented");
+		return;
 	}
+
+	const uint8_t *p = buf;
+	memcpy(table, buf, sizeof(struct dvb_table_pat) - sizeof(uint16_t));
+	p += sizeof(struct dvb_table_pat) - sizeof(uint16_t);
+	*table_length = buflen + sizeof(uint16_t);
+
+	struct dvb_table_pat *pat = (struct dvb_table_pat *) table;
+	pat->programs = 0;
+
+	while (p < buf + buflen - 4) {
+		memcpy(pat->program + pat->programs, p, sizeof(struct dvb_table_pat_program));
+		bswap16(pat->program[pat->programs].service_id);
+		bswap16(pat->program[pat->programs].bitfield);
+		p += sizeof(struct dvb_table_pat_program);
+		pat->programs++;
+	}
+}
+
+void dvb_table_pat_free(struct dvb_table_pat *pat)
+{
+	free(pat);
 }
 
-void dvb_table_pat_print(struct dvb_v5_fe_parms *parms, struct dvb_table_pat *t)
+void dvb_table_pat_print(struct dvb_v5_fe_parms *parms, struct dvb_table_pat *pat)
 {
 	dvb_log("PAT");
-	dvb_table_header_print(parms, &t->header);
-	dvb_log("|\\  program  service (%d programs)", t->programs);
+	dvb_table_header_print(parms, &pat->header);
+	dvb_log("|\\  program  service (%d programs)", pat->programs);
 	int i;
-	for (i = 0; i < t->programs; i++) {
-		dvb_log("|- %7d %7d", t->program[i].pid, t->program[i].service_id);
+	for (i = 0; i < pat->programs; i++) {
+		dvb_log("|- %7d %7d", pat->program[i].pid, pat->program[i].service_id);
 	}
 }
 
diff --git a/lib/libdvbv5/descriptors/pmt.c b/lib/libdvbv5/descriptors/pmt.c
index 7b14b3f..bf8f87c 100644
--- a/lib/libdvbv5/descriptors/pmt.c
+++ b/lib/libdvbv5/descriptors/pmt.c
@@ -25,60 +25,63 @@
 
 #include <string.h> /* memcpy */
 
-void dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize_t size, uint8_t **buf, ssize_t *buflen)
+void dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length)
 {
-	uint8_t *d;
-	const uint8_t *p = ptr;
-	struct dvb_table_pmt *pmt = (struct dvb_table_pmt *) ptr;
+	if (*table_length > 0) {
+		dvb_logerr("multisecttion PMT table not implemented");
+		return;
+	}
+
+	const uint8_t *p = buf;
+	struct dvb_table_pmt *pmt = (struct dvb_table_pmt *) table;
+	memcpy(table, p, sizeof(struct dvb_table_pmt) - sizeof(pmt->stream));
+	p += sizeof(struct dvb_table_pmt) - sizeof(pmt->stream);
+	*table_length = sizeof(struct dvb_table_pmt);
 
 	bswap16(pmt->bitfield);
 	bswap16(pmt->bitfield2);
+	pmt->stream = NULL;
+
+	/* skip prog section */
+	p += pmt->prog_length;
+
+	/* get the stream entries */
+	struct dvb_table_pmt_stream *last = NULL;
+	struct dvb_table_pmt_stream **head = &pmt->stream;
+	while (p < buf + buflen - 4) {
+		struct dvb_table_pmt_stream *stream = (struct dvb_table_pmt_stream *) malloc(sizeof(struct dvb_table_pmt_stream));
+		memcpy(stream, p, sizeof(struct dvb_table_pmt_stream) - sizeof(stream->descriptor) - sizeof(stream->next));
+		p += sizeof(struct dvb_table_pmt_stream) - sizeof(stream->descriptor) - sizeof(stream->next);
+
+		bswap16(stream->bitfield);
+		bswap16(stream->bitfield2);
+		stream->descriptor = NULL;
+		stream->next = NULL;
+
+		if(!*head)
+			*head = stream;
+		if(last)
+			last->next = stream;
+
+		/* get the descriptors for each program */
+		struct dvb_desc **head_desc = &stream->descriptor;
+		dvb_parse_descriptors(parms, p, stream->section_length, head_desc);
+
+		p += stream->section_length;
+		last = stream;
+	}
+}
 
-	if (!*buf) {
-		d = malloc(DVB_MAX_PAYLOAD_PACKET_SIZE * 2);
-		*buf = d;
-		*buflen = 0;
-		pmt = (struct dvb_table_pmt *) d;
-
-		memcpy(d + *buflen, p, sizeof(struct dvb_table_pmt) - sizeof(pmt->stream));
-		p += sizeof(struct dvb_table_pmt) - sizeof(pmt->stream);
-		*buflen += sizeof(struct dvb_table_pmt);
-
-		pmt->stream = NULL;
-
-		/* skip prog section */
-		p += pmt->prog_length;
-
-		/* get the stream entries */
-		struct dvb_table_pmt_stream *last = NULL;
-		struct dvb_table_pmt_stream **head = &pmt->stream;
-		while (p < ptr + size - 4) {
-			struct dvb_table_pmt_stream *stream = (struct dvb_table_pmt_stream *) (d + *buflen);
-			memcpy(d + *buflen, p, sizeof(struct dvb_table_pmt_stream) - sizeof(stream->descriptor) - sizeof(stream->next));
-			p += sizeof(struct dvb_table_pmt_stream) - sizeof(stream->descriptor) - sizeof(stream->next);
-			*buflen += sizeof(struct dvb_table_pmt_stream);
-
-			bswap16(stream->bitfield);
-			bswap16(stream->bitfield2);
-			stream->descriptor = NULL;
-			stream->next = NULL;
-
-			if(!*head)
-				*head = stream;
-			if(last)
-				last->next = stream;
-
-			/* get the descriptors for each program */
-			struct dvb_desc **head_desc = &stream->descriptor;
-			*buflen += dvb_parse_descriptors(parms, p, d + *buflen, stream->section_length, head_desc);
-
-			p += stream->section_length;
-			last = stream;
-		}
-
-	} else {
-		dvb_logerr("multisecttion PMT table not implemented");
+void dvb_table_pmt_free(struct dvb_table_pmt *pmt)
+{
+	struct dvb_table_pmt_stream *stream = pmt->stream;
+	while(stream) {
+		dvb_free_descriptors((struct dvb_desc **) &stream->descriptor);
+		struct dvb_table_pmt_stream *tmp = stream;
+		stream = stream->next;
+		free(tmp);
 	}
+	free(pmt);
 }
 
 void dvb_table_pmt_print(struct dvb_v5_fe_parms *parms, const struct dvb_table_pmt *pmt)
diff --git a/lib/libdvbv5/descriptors/sdt.c b/lib/libdvbv5/descriptors/sdt.c
index 5248274..81fb192 100644
--- a/lib/libdvbv5/descriptors/sdt.c
+++ b/lib/libdvbv5/descriptors/sdt.c
@@ -22,46 +22,33 @@
 #include "descriptors/sdt.h"
 #include "dvb-fe.h"
 
-void dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize_t size, uint8_t **buf, ssize_t *buflen)
+void dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length)
 {
-	uint8_t *d;
-	const uint8_t *p = ptr;
-	struct dvb_table_sdt *sdt = (struct dvb_table_sdt *) ptr;
+	const uint8_t *p = buf;
+	struct dvb_table_sdt *sdt = (struct dvb_table_sdt *) table;
 	struct dvb_table_sdt_service **head;
 
-	bswap16(sdt->network_id);
-
-	if (!*buf) {
-		d = malloc(DVB_MAX_PAYLOAD_PACKET_SIZE * 2);
-		*buf = d;
-		*buflen = 0;
-		sdt = (struct dvb_table_sdt *) d;
-		memcpy(sdt, p, sizeof(struct dvb_table_sdt) - sizeof(sdt->service));
-		*buflen += sizeof(struct dvb_table_sdt);
-
-		sdt->service = NULL;
-		head = &sdt->service;
-	} else {
-		// should realloc d
-		d = *buf;
-
+	if (*table_length > 0) {
 		/* find end of curent list */
-		sdt = (struct dvb_table_sdt *) d;
 		head = &sdt->service;
 		while (*head != NULL)
 			head = &(*head)->next;
+	} else {
+		memcpy(sdt, p, sizeof(struct dvb_table_sdt) - sizeof(sdt->service));
+		*table_length = sizeof(struct dvb_table_sdt);
 
-		/* read new table */
-		sdt = (struct dvb_table_sdt *) p;
+		bswap16(sdt->network_id);
+
+		sdt->service = NULL;
+		head = &sdt->service;
 	}
 	p += sizeof(struct dvb_table_sdt) - sizeof(sdt->service);
 
 	struct dvb_table_sdt_service *last = NULL;
-	while ((uint8_t *) p < ptr + size - 4) {
-		struct dvb_table_sdt_service *service = (struct dvb_table_sdt_service *) (d + *buflen);
-		memcpy(d + *buflen, p, sizeof(struct dvb_table_sdt_service) - sizeof(service->descriptor) - sizeof(service->next));
+	while ((uint8_t *) p < buf + buflen - 4) {
+		struct dvb_table_sdt_service *service = (struct dvb_table_sdt_service *) malloc(sizeof(struct dvb_table_sdt_service));
+		memcpy(service, p, sizeof(struct dvb_table_sdt_service) - sizeof(service->descriptor) - sizeof(service->next));
 		p += sizeof(struct dvb_table_sdt_service) - sizeof(service->descriptor) - sizeof(service->next);
-		*buflen += sizeof(struct dvb_table_sdt_service);
 
 		bswap16(service->service_id);
 		bswap16(service->bitfield);
@@ -75,13 +62,25 @@ void dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize
 
 		/* get the descriptors for each program */
 		struct dvb_desc **head_desc = &service->descriptor;
-		*buflen += dvb_parse_descriptors(parms, p, d + *buflen, service->section_length, head_desc);
+		dvb_parse_descriptors(parms, p, service->section_length, head_desc);
 
 		p += service->section_length;
 		last = service;
 	}
 }
 
+void dvb_table_sdt_free(struct dvb_table_sdt *sdt)
+{
+	struct dvb_table_sdt_service *service = sdt->service;
+	while(service) {
+		dvb_free_descriptors((struct dvb_desc **) &service->descriptor);
+		struct dvb_table_sdt_service *tmp = service;
+		service = service->next;
+		free(tmp);
+	}
+	free(sdt);
+}
+
 void dvb_table_sdt_print(struct dvb_v5_fe_parms *parms, struct dvb_table_sdt *sdt)
 {
 	dvb_log("SDT");
diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index 33b0fa8..a49ad80 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -32,6 +32,7 @@
 #include "crc32.h"
 #include "dvb-fe.h"
 #include "dvb-log.h"
+#include "dvb-demux.h"
 #include "descriptors/header.h"
 
 #include <errno.h>
@@ -277,7 +278,7 @@ static void parse_sdt(struct dvb_v5_fe_parms *parms, struct dvb_v5_descriptors *
 	sdt_table->service_table_len = n;
 }
 
-static int poll(int filedes, unsigned int seconds)
+static int poll(struct dvb_v5_fe_parms *parms, int fd, unsigned int seconds)
 {
 	fd_set set;
 	struct timeval timeout;
@@ -285,114 +286,141 @@ static int poll(int filedes, unsigned int seconds)
 
 	/* Initialize the file descriptor set. */
 	FD_ZERO (&set);
-	FD_SET (filedes, &set);
+	FD_SET (fd, &set);
 
 	/* Initialize the timeout data structure. */
 	timeout.tv_sec = seconds;
 	timeout.tv_usec = 0;
 
-	/* `select' returns 0 if timeout, 1 if input available, -1 if error. */
+	/* `select' logfuncreturns 0 if timeout, 1 if input available, -1 if error. */
 	do ret = select (FD_SETSIZE, &set, NULL, NULL, &timeout);
-	while (ret == -1 && errno == EINTR);
+	while (!parms->abort && ret == -1 && errno == EINTR);
 
 	return ret;
 }
 
 
-int dvb_read_section(struct dvb_v5_fe_parms *parms, int dmx_fd, unsigned char table, uint16_t pid, uint8_t **buf,
-		unsigned *length, unsigned timeout)
+int dvb_read_section(struct dvb_v5_fe_parms *parms, int dmx_fd, unsigned char tid, uint16_t pid, uint8_t **table,
+		unsigned timeout)
 {
-	int available;
-	ssize_t count;
-	struct dmx_sct_filter_params f;
-	uint8_t *tmp = NULL;
-	uint64_t sections_read = 0;
-	uint64_t sections_total = 0;
+	return dvb_read_section_with_id(parms, dmx_fd, tid, pid, -1, table, timeout);
+}
+
+
+int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd, unsigned char tid, uint16_t pid, int id, uint8_t **table,
+		unsigned timeout)
+{
+	if (!table)
+		return -4;
+	*table = NULL;
 	ssize_t table_length = 0;
+
+	int first_section = -1;
+	int last_section = -1;
 	int table_id = -1;
+	int sections = 0;
 
 	// FIXME: verify known table
-	*buf = NULL;
 
+	/* table cannot be reallocated due to linked lists */
+	uint8_t *tbl = NULL;
+
+	struct dmx_sct_filter_params f;
 	memset(&f, 0, sizeof(f));
 	f.pid = pid;
-	f.filter.filter[0] = table;
+	f.filter.filter[0] = tid;
 	f.filter.mask[0] = 0xff;
 	f.timeout = 0;
-	f.flags = DMX_IMMEDIATE_START | DMX_CHECK_CRC;
+	f.flags = DMX_IMMEDIATE_START; // | DMX_CHECK_CRC;
 	if (ioctl(dmx_fd, DMX_SET_FILTER, &f) == -1) {
 		dvb_perror("dvb_read_section: ioctl DMX_SET_FILTER failed");
 		return -1;
 	}
 
-	do {
-		count = 0;
+	while (1) {
+		int available;
+
+		uint8_t *buf = NULL;
+		ssize_t buf_length = 0;
+
 		do {
-			available = poll(dmx_fd, timeout);
+			available = poll(parms, dmx_fd, timeout);
 		} while (available < 0 && errno == EOVERFLOW);
+		if (parms->abort)
+			return 0; // FIXME: free tbl
 		if (available <= 0) {
 			dvb_logerr("dvb_read_section: no data read" );
 			return -1;
 		}
-		tmp = malloc(DVB_MAX_PAYLOAD_PACKET_SIZE);
-		count = read(dmx_fd, tmp, DVB_MAX_PAYLOAD_PACKET_SIZE);
-		if (!count) {
+		buf = malloc(DVB_MAX_PAYLOAD_PACKET_SIZE);
+		buf_length = read(dmx_fd, buf, DVB_MAX_PAYLOAD_PACKET_SIZE);
+		if (!buf_length) {
 			dvb_logerr("dvb_read_section: no data read" );
-			free(tmp);
+			free(buf);
 			return -1;
 		}
-		if (count < 0) {
+		if (buf_length < 0) {
 			dvb_perror("dvb_read_section: read error");
-			free(tmp);
+			free(buf);
 			return -2;
 		}
 
-		uint32_t crc = crc32(tmp, count, 0xFFFFFFFF);
+		buf = realloc(buf, buf_length);
+
+		uint32_t crc = crc32(buf, buf_length, 0xFFFFFFFF);
 		if (crc != 0) {
 			dvb_logerr("dvb_read_section: crc error");
-			free(tmp);
+			free(buf);
 			return -3;
 		}
 
-		//ARRAY_SIZE(vb_table_initializers) >= table
-
-		struct dvb_table_header *h = (struct dvb_table_header *) tmp;
+		struct dvb_table_header *h = (struct dvb_table_header *) buf;
 		dvb_table_header_init(h);
-		if (table_id == -1)
-			table_id = h->id;
-		else if (h->id != table_id) {
-			dvb_logwarn("Table ID mismatch reading multi section table: %d != %d", h->id, table_id);
-			free(tmp);
-			tmp = NULL;
+		if (id != -1 && h->id != id) { /* search for a specific table id */
+			free(buf);
 			continue;
-		}
-		/*dvb_log("dvb_read_section: got section %d/%d", h->section_id + 1, h->last_section + 1);*/
-		if (!sections_total) {
-			if (h->last_section + 1 > 32) {
-				dvb_logerr("dvb_read_section: cannot read more than 32 sections, %d requested", h->last_section);
-				h->last_section = 31;
+		} else {
+			if (table_id == -1)
+				table_id = h->id;
+			else if (h->id != table_id) {
+				dvb_logwarn("dvb_read_section: table ID mismatch reading multi section table: %d != %d", h->id, table_id);
+				free(buf);
+				continue;
 			}
-			sections_total = (1 << (h->last_section + 1)) - 1;
 		}
-		if (sections_read & (1 << h->section_id)) {
-			dvb_logwarn("dvb_read_section: section %d already read", h->section_id);
+
+		dvb_logwarn("section %d/%d", h->section_id, h->last_section);
+
+		/* handle the sections */
+		if (first_section == -1)
+			first_section = h->section_id;
+		else if (h->section_id == first_section)
+		{
+			free(buf);
+			break;
 		}
-		sections_read  |= 1 << h->section_id;
-		/*if (sections_read != sections_total)*/
-			/*dvb_logwarn("dvb_read_section: sections are missing: %d != %d", sections_read, sections_total);*/
-
-		if (dvb_table_initializers[table].init)
-			dvb_table_initializers[table].init(parms, tmp, count, buf, &table_length);
-		else
-			dvb_logerr("no initializer for table %d", table);
-
-		free(tmp);
-		tmp = NULL;
-	} while(sections_read != sections_total);
-	// FIXME: log incomplete sections
-
-	if (length)
-		*length = table_length;
+		if (last_section == -1)
+			last_section = h->last_section;
+
+		//ARRAY_SIZE(vb_table_initializers) >= table
+		if (!tbl)
+			tbl = malloc(MAX_TABLE_SIZE);
+
+		if (dvb_table_initializers[tid].init) {
+			dvb_table_initializers[tid].init(parms, buf, buf_length, tbl, &table_length);
+			tbl = realloc(tbl, table_length);
+		} else
+			dvb_logerr("dvb_read_section: no initializer for table %d", tid);
+
+		free(buf);
+
+		if (++sections == last_section + 1)
+			break;
+	}
+
+	dvb_dmx_stop(dmx_fd);
+
+	*table = tbl;
 	return 0;
 }
 
@@ -419,7 +447,7 @@ static int read_section(struct dvb_v5_fe_parms *parms, int dmx_fd, struct dvb_v5
 
 	do {
 		do {
-			count = poll(dmx_fd, timeout);
+			count = poll(parms, dmx_fd, timeout);
 			if (count > 0)
 				count = read(dmx_fd, buf, sizeof(buf));
 		} while (count < 0 && errno == EOVERFLOW);
-- 
1.7.2.5

