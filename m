Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59938 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab2HCK1k (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2012 06:27:40 -0400
Received: by wibhm11 with SMTP id hm11so6042448wib.1
        for <linux-media@vger.kernel.org>; Fri, 03 Aug 2012 03:27:38 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 1/6] libdvbv5: EIT parser
Date: Fri,  3 Aug 2012 12:26:54 +0200
Message-Id: <1343989619-12928-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/descriptors/desc_event_short.h  |   51 +++++++++++++
 lib/include/descriptors/desc_language.h     |    4 +-
 lib/include/descriptors/desc_network_name.h |    4 +-
 lib/include/descriptors/eit.h               |   80 ++++++++++++++++++++
 lib/include/descriptors/pat.h               |    6 +-
 lib/include/descriptors/sdt.h               |    4 +-
 lib/libdvbv5/Makefile.am                    |    4 +-
 lib/libdvbv5/descriptors.c                  |   65 +++++++++++++---
 lib/libdvbv5/descriptors/desc_event_short.c |   89 ++++++++++++++++++++++
 lib/libdvbv5/descriptors/desc_service.c     |    8 +-
 lib/libdvbv5/descriptors/eit.c              |  107 +++++++++++++++++++++++++++
 lib/libdvbv5/descriptors/nit.c              |    5 +-
 lib/libdvbv5/descriptors/pat.c              |    8 +-
 lib/libdvbv5/descriptors/pmt.c              |   23 +++---
 lib/libdvbv5/descriptors/sdt.c              |   16 +++--
 lib/libdvbv5/dvb-scan.c                     |   14 +++-
 16 files changed, 439 insertions(+), 49 deletions(-)
 create mode 100644 lib/include/descriptors/desc_event_short.h
 create mode 100644 lib/include/descriptors/eit.h
 create mode 100644 lib/libdvbv5/descriptors/desc_event_short.c
 create mode 100644 lib/libdvbv5/descriptors/eit.c

diff --git a/lib/include/descriptors/desc_event_short.h b/lib/include/descriptors/desc_event_short.h
new file mode 100644
index 0000000..1809ffb
--- /dev/null
+++ b/lib/include/descriptors/desc_event_short.h
@@ -0,0 +1,51 @@
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
+#ifndef _DESC_EVENT_SHORT_H
+#define _DESC_EVENT_SHORT_H
+
+#include <stdint.h>
+#include <unistd.h> /* ssize_t */
+
+struct dvb_desc_event_short {
+	uint8_t type;
+	uint8_t length;
+	struct dvb_desc *next;
+
+	unsigned char language[4];
+	char *name;
+	char *text;
+} __attribute__((packed));
+
+struct dvb_v5_fe_parms;
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+ssize_t dvb_desc_event_short_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+void dvb_desc_event_short_print  (struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/include/descriptors/desc_language.h b/lib/include/descriptors/desc_language.h
index eca9cdb..8829bf1 100644
--- a/lib/include/descriptors/desc_language.h
+++ b/lib/include/descriptors/desc_language.h
@@ -19,8 +19,8 @@
  *
  */
 
-#ifndef _LANGUAGE_H
-#define _LANGUAGE_H
+#ifndef _DESC_LANGUAGE_H
+#define _DESC_LANGUAGE_H
 
 #include <stdint.h>
 #include <unistd.h> /* ssize_t */
diff --git a/lib/include/descriptors/desc_network_name.h b/lib/include/descriptors/desc_network_name.h
index 706b36c..ece0fd9 100644
--- a/lib/include/descriptors/desc_network_name.h
+++ b/lib/include/descriptors/desc_network_name.h
@@ -19,8 +19,8 @@
  *
  */
 
-#ifndef _NETWORK_NAME_H
-#define _NETWORK_NAME_H
+#ifndef _DESC_NETWORK_NAME_H
+#define _DESC_NETWORK_NAME_H
 
 #include <stdint.h>
 #include <unistd.h> /* ssize_t */
diff --git a/lib/include/descriptors/eit.h b/lib/include/descriptors/eit.h
new file mode 100644
index 0000000..4cf7cc1
--- /dev/null
+++ b/lib/include/descriptors/eit.h
@@ -0,0 +1,80 @@
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
+#ifndef _EIT_H
+#define _EIT_H
+
+#include <stdint.h>
+#include <unistd.h> /* ssize_t */
+
+#include "descriptors/header.h"
+#include "descriptors.h"
+
+#define DVB_TABLE_EIT        0x4E
+#define DVB_TABLE_EIT_OTHER  0x4F
+
+#define DVB_TABLE_EIT_SCHEDULE 0x50       /* - 0x5F */
+#define DVB_TABLE_EIT_SCHEDULE_OTHER 0x60 /* - 0x6F */
+
+#define DVB_TABLE_EIT_PID  0x12
+
+struct dvb_table_eit_event {
+	uint16_t event_id;
+	uint8_t start[5];
+	uint8_t duration[3];
+	union {
+		uint16_t bitfield;
+		struct {
+			uint16_t section_length:12;
+			uint16_t free_CA_mode:1;
+			uint16_t running_status:3;
+		} __attribute__((packed));
+	};
+	struct dvb_desc *descriptor;
+	struct dvb_table_eit_event *next;
+} __attribute__((packed));
+
+struct dvb_table_eit {
+	struct dvb_table_header header;
+	uint16_t transport_id;
+	uint16_t network_id;
+	uint8_t  last_segment;
+	uint8_t  last_table_id;
+	struct dvb_table_eit_event *event;
+} __attribute__((packed));
+
+#define dvb_eit_service_foreach(_event, _eit) \
+	for( struct dvb_table_eit_event *_event = _eit->event; _event; _event = _event->next ) \
+
+struct dvb_v5_fe_parms;
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+void dvb_table_eit_init (struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize_t size, uint8_t **buf, ssize_t *buflen);
+void dvb_table_eit_print(struct dvb_v5_fe_parms *parms, struct dvb_table_eit *eit);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/include/descriptors/pat.h b/lib/include/descriptors/pat.h
index 69e1956..ae7bbc5 100644
--- a/lib/include/descriptors/pat.h
+++ b/lib/include/descriptors/pat.h
@@ -31,7 +31,7 @@
 #define DVB_TABLE_PAT_PID  0
 
 struct dvb_table_pat_program {
-	uint16_t program_id;
+	uint16_t service_id;
 	union {
 		uint16_t bitfield;
 		struct {
@@ -47,6 +47,10 @@ struct dvb_table_pat {
 	struct dvb_table_pat_program program[];
 } __attribute__((packed));
 
+#define dvb_pat_program_foreach(_program, _pat) \
+	struct dvb_table_pat_program *_program; \
+	for(int _i = 0; _i < _pat->programs && (_program = _pat->program + _i); _i++) \
+
 struct dvb_v5_fe_parms;
 
 #ifdef __cplusplus
diff --git a/lib/include/descriptors/sdt.h b/lib/include/descriptors/sdt.h
index 877442a..a968ac5 100644
--- a/lib/include/descriptors/sdt.h
+++ b/lib/include/descriptors/sdt.h
@@ -56,7 +56,7 @@ struct dvb_table_sdt {
 } __attribute__((packed));
 
 #define dvb_sdt_service_foreach(_service, _sdt) \
-  for( struct dvb_table_sdt_service *_service = _sdt->service; _service; _service = _service->next ) \
+	for( struct dvb_table_sdt_service *_service = _sdt->service; _service; _service = _service->next ) \
 
 struct dvb_v5_fe_parms;
 
@@ -64,7 +64,7 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-void dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize_t size, uint8_t **buf, ssize_t *buflen);
+void dvb_table_sdt_init (struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize_t size, uint8_t **buf, ssize_t *buflen);
 void dvb_table_sdt_print(struct dvb_v5_fe_parms *parms, struct dvb_table_sdt *sdt);
 
 #ifdef __cplusplus
diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
index 1943ff2..d2041f5 100644
--- a/lib/libdvbv5/Makefile.am
+++ b/lib/libdvbv5/Makefile.am
@@ -34,8 +34,10 @@ libdvbv5_la_SOURCES = \
   descriptors/desc_service.c  ../include/descriptors/desc_service.h \
   descriptors/desc_frequency_list.c  ../include/descriptors/desc_frequency_list.h \
   descriptors/desc_service_list.c  ../include/descriptors/desc_service_list.h \
+  descriptors/desc_event_short.c  ../include/descriptors/desc_event_short.h \
   descriptors/nit.c  ../include/descriptors/nit.h \
-  descriptors/sdt.c  ../include/descriptors/sdt.h
+  descriptors/sdt.c  ../include/descriptors/sdt.h \
+  descriptors/eit.c  ../include/descriptors/eit.h
 
 libdvbv5_la_CPPFLAGS = $(ENFORCE_LIBDVBV5_STATIC)
 libdvbv5_la_LDFLAGS = -version-info 0 $(ENFORCE_LIBDVBV5_STATIC)
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index 46957a3..e580b09 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -32,6 +32,9 @@
 
 #include "descriptors/pat.h"
 #include "descriptors/pmt.h"
+#include "descriptors/nit.h"
+#include "descriptors/sdt.h"
+#include "descriptors/eit.h"
 #include "descriptors/desc_language.h"
 #include "descriptors/desc_network_name.h"
 #include "descriptors/desc_cable_delivery.h"
@@ -40,8 +43,7 @@
 #include "descriptors/desc_service.h"
 #include "descriptors/desc_service_list.h"
 #include "descriptors/desc_frequency_list.h"
-#include "descriptors/nit.h"
-#include "descriptors/sdt.h"
+#include "descriptors/desc_event_short.h"
 
 ssize_t dvb_desc_init(const uint8_t *buf, struct dvb_desc *desc)
 {
@@ -68,6 +70,7 @@ const struct dvb_table_init dvb_table_initializers[] = {
 	[DVB_TABLE_PMT] = { dvb_table_pmt_init },
 	[DVB_TABLE_NIT] = { dvb_table_nit_init },
 	[DVB_TABLE_SDT] = { dvb_table_sdt_init },
+	[DVB_TABLE_EIT] = { dvb_table_eit_init },
 };
 
 char *default_charset = "iso-8859-1";
@@ -166,7 +169,7 @@ const struct dvb_descriptor dvb_descriptors[] = {
 	[linkage_descriptor] = { "linkage_descriptor", NULL, NULL },
 	[NVOD_reference_descriptor] = { "NVOD_reference_descriptor", NULL, NULL },
 	[time_shifted_service_descriptor] = { "time_shifted_service_descriptor", NULL, NULL },
-	[short_event_descriptor] = { "short_event_descriptor", NULL, NULL },
+	[short_event_descriptor] = { "short_event_descriptor", dvb_desc_event_short_init, dvb_desc_event_short_print },
 	[extended_event_descriptor] = { "extended_event_descriptor", NULL, NULL },
 	[time_shifted_event_descriptor] = { "time_shifted_event_descriptor", NULL, NULL },
 	[component_descriptor] = { "component_descriptor", NULL, NULL },
@@ -969,20 +972,56 @@ int has_descriptor(struct dvb_v5_descriptors *dvb_desc,
 	return 0;
 }
 
-void hexdump(struct dvb_v5_fe_parms *parms, const char *prefix, const unsigned char *buf, int len)
+void hexdump(struct dvb_v5_fe_parms *parms, const char *prefix, const unsigned char *data, int length)
 {
-	int i, j;
-	char tmp[256];
-	/*printf("size %d", len);*/
-	for (i = 0, j = 0; i < len; i++, j++) {
-		if (i && !(i % 16)) {
-			dvb_log("%s%s", prefix, tmp);
+	if (!data)
+		return;
+	char ascii[17];
+	char hex[50];
+	int i, j = 0;
+	hex[0] = '\0';
+	for (i = 0; i < length; i++)
+	{
+		char t[4];
+		snprintf (t, sizeof(t), "%02x ", (unsigned int) data[i]);
+		strncat (hex, t, sizeof(hex));
+		if (data[i] > 31 && data[i] < 128 )
+			ascii[j] = data[i];
+		else
+			ascii[j] = '.';
+		j++;
+		if (j == 8)
+			strncat(hex, " ", sizeof(hex));
+		if (j == 16)
+		{
+			ascii[j] = '\0';
+			dvb_log("%s%s  %s", prefix, hex, ascii);
 			j = 0;
+			hex[0] = '\0';
 		}
-		sprintf( tmp + j * 3, "%02x ", (uint8_t) *(buf + i));
 	}
-	if (i && (i % 16))
-		dvb_log("%s%s", prefix, tmp);
+	if (j > 0 && j < 16)
+	{
+		char spaces[47];
+		spaces[0] = '\0';
+		for (i = strlen(hex); i < 49; i++)
+			strncat(spaces, " ", sizeof(spaces));
+		ascii[j] = '\0';
+		dvb_log("%s%s %s %s", prefix, hex, spaces, ascii);
+	}
+
+	/*int i, j;*/
+	/*char tmp[64];*/
+	/*char ascii[32];*/
+	/*for (i = 0, j = 0; i < len; i++, j++) {*/
+	/*if (i && !(i % 16)) {*/
+	/*dvb_log("%s%s", prefix, tmp);*/
+	/*j = 0;*/
+	/*}*/
+	/*sprintf( tmp + j * 3, "%02x ", (uint8_t) *(buf + i));*/
+	/*}*/
+	/*if (i && (i % 16))*/
+	/*dvb_log("%s%s", prefix, tmp);*/
 }
 
 #if 0
diff --git a/lib/libdvbv5/descriptors/desc_event_short.c b/lib/libdvbv5/descriptors/desc_event_short.c
new file mode 100644
index 0000000..2962d83
--- /dev/null
+++ b/lib/libdvbv5/descriptors/desc_event_short.c
@@ -0,0 +1,89 @@
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
+#include "descriptors/desc_event_short.h"
+#include "descriptors.h"
+#include "dvb-fe.h"
+#include "parse_string.h"
+
+ssize_t dvb_desc_event_short_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+{
+	struct dvb_desc_event_short *event = (struct dvb_desc_event_short *) desc;
+	char *string, *emph;
+	uint8_t len;        /* the length of the string in the input data */
+	uint8_t len1, len2; /* the lenght of the output strings */
+
+	/*hexdump(parms, "event short desc: ", buf - 2, desc->length + 2);*/
+
+	event->language[0] = buf[0];
+	event->language[1] = buf[1];
+	event->language[2] = buf[2];
+	event->language[3] = '\0';
+	buf += 3;
+
+	event->name = ((char *) desc) + sizeof(struct dvb_desc_event_short);
+	len = buf[0];
+	buf++;
+	len1 = len;
+	string = NULL;
+	emph   = NULL;
+	parse_string(parms, &string, &emph, buf, len1, default_charset, output_charset);
+	buf += len;
+	if (emph)
+		free(emph);
+	if (string) {
+		len1 = strlen(string);
+		memcpy(event->name, string, len1);
+		free(string);
+	} else {
+		memcpy(event->name, buf, len1);
+	}
+	event->name[len1] = '\0';
+
+	event->text = event->name + len1 + 1;
+	len = buf[0];
+	len2 = len;
+	buf++;
+	string = NULL;
+	emph   = NULL;
+	parse_string(parms, &string, &emph, buf, len2, default_charset, output_charset);
+	buf += len;
+	if (emph)
+		free(emph);
+	if (string) {
+		len2 = strlen(string);
+		memcpy(event->text, string, len2);
+		free(string);
+	} else {
+		memcpy(event->text, buf, len2);
+	}
+	event->text[len2] = '\0';
+
+	return sizeof(struct dvb_desc_event_short) + len1 + 1 + len2 + 1;
+}
+
+void dvb_desc_event_short_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
+{
+	const struct dvb_desc_event_short *event = (const struct dvb_desc_event_short *) desc;
+	dvb_log("|   Event         '%s'", event->name);
+	dvb_log("|   Description   '%s'", event->text);
+}
+
diff --git a/lib/libdvbv5/descriptors/desc_service.c b/lib/libdvbv5/descriptors/desc_service.c
index 78c8d63..c3d4727 100644
--- a/lib/libdvbv5/descriptors/desc_service.c
+++ b/lib/libdvbv5/descriptors/desc_service.c
@@ -78,9 +78,9 @@ ssize_t dvb_desc_service_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 
 void dvb_desc_service_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
 {
-	const struct dvb_desc_service *srv = (const struct dvb_desc_service *) desc;
-	dvb_log("|   service type     %d", srv->service_type);
-	dvb_log("|           name     '%s'", srv->name);
-	dvb_log("|           provider '%s'", srv->provider);
+	const struct dvb_desc_service *service = (const struct dvb_desc_service *) desc;
+	dvb_log("|   service type     %d", service->service_type);
+	dvb_log("|           name     '%s'", service->name);
+	dvb_log("|           provider '%s'", service->provider);
 }
 
diff --git a/lib/libdvbv5/descriptors/eit.c b/lib/libdvbv5/descriptors/eit.c
new file mode 100644
index 0000000..1551272
--- /dev/null
+++ b/lib/libdvbv5/descriptors/eit.c
@@ -0,0 +1,107 @@
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
+#include "descriptors/eit.h"
+#include "dvb-fe.h"
+
+void dvb_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize_t size, uint8_t **buf, ssize_t *buflen)
+{
+	uint8_t *d;
+	const uint8_t *p = ptr;
+	struct dvb_table_eit *eit = (struct dvb_table_eit *) ptr;
+	struct dvb_table_eit_event **head;
+
+	bswap16(eit->transport_id);
+	bswap16(eit->network_id);
+
+	if (!*buf) {
+		d = malloc(DVB_MAX_PAYLOAD_PACKET_SIZE * 2);
+		*buf = d;
+		*buflen = 0;
+		eit = (struct dvb_table_eit *) d;
+		memcpy(eit, p, sizeof(struct dvb_table_eit) - sizeof(eit->event));
+		*buflen += sizeof(struct dvb_table_eit);
+
+		eit->event = NULL;
+		head = &eit->event;
+	} else {
+		// should realloc d
+		d = *buf;
+
+		/* find end of curent list */
+		eit = (struct dvb_table_eit *) d;
+		head = &eit->event;
+		while (*head != NULL)
+			head = &(*head)->next;
+
+		/* read new table */
+		eit = (struct dvb_table_eit *) p;
+	}
+	p += sizeof(struct dvb_table_eit) - sizeof(eit->event);
+
+	struct dvb_table_eit_event *last = NULL;
+	while ((uint8_t *) p < ptr + size - 4) {
+		struct dvb_table_eit_event *event = (struct dvb_table_eit_event *) (d + *buflen);
+		memcpy(d + *buflen, p, sizeof(struct dvb_table_eit_event) - sizeof(event->descriptor) - sizeof(event->next));
+		p += sizeof(struct dvb_table_eit_event) - sizeof(event->descriptor) - sizeof(event->next);
+		*buflen += sizeof(struct dvb_table_eit_event);
+
+		bswap16(event->event_id);
+		bswap16(event->bitfield);
+		event->descriptor = NULL;
+		event->next = NULL;
+
+		if(!*head)
+			*head = event;
+		if(last)
+			last->next = event;
+
+		/* get the descriptors for each program */
+		struct dvb_desc **head_desc = &event->descriptor;
+		*buflen += dvb_parse_descriptors(parms, p, d + *buflen, event->section_length, head_desc);
+
+		p += event->section_length;
+		last = event;
+	}
+}
+
+void dvb_table_eit_print(struct dvb_v5_fe_parms *parms, struct dvb_table_eit *eit)
+{
+	dvb_log("EIT");
+	dvb_table_header_print(parms, &eit->header);
+	dvb_log("|- transport_id       %d", eit->transport_id);
+	dvb_log("|- network_id         %d", eit->network_id);
+	dvb_log("|- last segment       %d", eit->last_segment);
+	dvb_log("|- last table         %d", eit->last_table_id);
+	dvb_log("|\\  event_id");
+	const struct dvb_table_eit_event *event = eit->event;
+	uint16_t events = 0;
+	while(event) {
+		dvb_log("|- %7d", event->event_id);
+		dvb_log("|   free CA mode          %d", event->free_CA_mode);
+		dvb_log("|   running status        %d", event->running_status);
+		dvb_print_descriptors(parms, event->descriptor);
+		event = event->next;
+		events++;
+	}
+	dvb_log("|_  %d events", events);
+}
+
diff --git a/lib/libdvbv5/descriptors/nit.c b/lib/libdvbv5/descriptors/nit.c
index bf596fc..6b4ebae 100644
--- a/lib/libdvbv5/descriptors/nit.c
+++ b/lib/libdvbv5/descriptors/nit.c
@@ -26,10 +26,12 @@ void dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize
 {
 	uint8_t *d;
 	const uint8_t *p = ptr;
-	struct dvb_table_nit *nit;
+	struct dvb_table_nit *nit = (struct dvb_table_nit *) ptr;
 	struct dvb_desc **head_desc;
 	struct dvb_table_nit_transport **head;
 
+	bswap16(nit->bitfield);
+
 	if (!*buf) {
 		d = malloc(DVB_MAX_PAYLOAD_PACKET_SIZE * 4);
 		*buf = d;
@@ -58,7 +60,6 @@ void dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize
 		// read new table
 		nit = (struct dvb_table_nit *) p; // FIXME: should be copied to tmp, cause bswap in const
 	}
-	bswap16(nit->bitfield);
 	p += sizeof(struct dvb_table_nit) - sizeof(nit->descriptor) - sizeof(nit->transport);
 
 	*buflen += dvb_parse_descriptors(parms, p, d + *buflen, nit->desc_length, head_desc);
diff --git a/lib/libdvbv5/descriptors/pat.c b/lib/libdvbv5/descriptors/pat.c
index eb076fd..781dedd 100644
--- a/lib/libdvbv5/descriptors/pat.c
+++ b/lib/libdvbv5/descriptors/pat.c
@@ -39,13 +39,13 @@ void dvb_table_pat_init(struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize
 		pat->programs = 0;
 		while ((uint8_t *) p < ptr + size - 4) {
 			memcpy(pat->program + pat->programs, p, sizeof(struct dvb_table_pat_program));
-			bswap16(pat->program[pat->programs].program_id);
+			bswap16(pat->program[pat->programs].service_id);
 			bswap16(pat->program[pat->programs].bitfield);
 			p++;
 			pat->programs++;
 		}
 	} else {
-		dvb_logerr("multisecttion PAT table not implemented");
+		dvb_logerr("multisection PAT table not implemented");
 	}
 }
 
@@ -53,10 +53,10 @@ void dvb_table_pat_print(struct dvb_v5_fe_parms *parms, struct dvb_table_pat *t)
 {
 	dvb_log("PAT");
 	dvb_table_header_print(parms, &t->header);
-	dvb_log("|\\   pid     program_id (%d programs)", t->programs);
+	dvb_log("|\\  program  service (%d programs)", t->programs);
 	int i;
 	for (i = 0; i < t->programs; i++) {
-		dvb_log("|- %7d %7d", t->program[i].pid, t->program[i].program_id);
+		dvb_log("|- %7d %7d", t->program[i].pid, t->program[i].service_id);
 	}
 }
 
diff --git a/lib/libdvbv5/descriptors/pmt.c b/lib/libdvbv5/descriptors/pmt.c
index 9f4300c..7b14b3f 100644
--- a/lib/libdvbv5/descriptors/pmt.c
+++ b/lib/libdvbv5/descriptors/pmt.c
@@ -29,7 +29,10 @@ void dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize
 {
 	uint8_t *d;
 	const uint8_t *p = ptr;
-	struct dvb_table_pmt *pmt;
+	struct dvb_table_pmt *pmt = (struct dvb_table_pmt *) ptr;
+
+	bswap16(pmt->bitfield);
+	bswap16(pmt->bitfield2);
 
 	if (!*buf) {
 		d = malloc(DVB_MAX_PAYLOAD_PACKET_SIZE * 2);
@@ -41,8 +44,6 @@ void dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize
 		p += sizeof(struct dvb_table_pmt) - sizeof(pmt->stream);
 		*buflen += sizeof(struct dvb_table_pmt);
 
-		bswap16(pmt->bitfield);
-		bswap16(pmt->bitfield2);
 		pmt->stream = NULL;
 
 		/* skip prog section */
@@ -82,18 +83,18 @@ void dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize
 
 void dvb_table_pmt_print(struct dvb_v5_fe_parms *parms, const struct dvb_table_pmt *pmt)
 {
-	dvb_log( "PMT" );
+	dvb_log("PMT");
 	dvb_table_header_print(parms, &pmt->header);
-	dvb_log( "|- pcr_pid       %d", pmt->pcr_pid );
-	dvb_log( "|  reserved2     %d", pmt->reserved2 );
-	dvb_log( "|  prog length   %d", pmt->prog_length );
-	dvb_log( "|  zero3         %d", pmt->zero3 );
-	dvb_log( "|  reserved3     %d", pmt->reserved3 );
-	dvb_log("|\\  pid     len   type");
+	dvb_log("|- pcr_pid       %d", pmt->pcr_pid);
+	dvb_log("|  reserved2     %d", pmt->reserved2);
+	dvb_log("|  prog length   %d", pmt->prog_length);
+	dvb_log("|  zero3         %d", pmt->zero3);
+	dvb_log("|  reserved3     %d", pmt->reserved3);
+	dvb_log("|\\  pid     type");
 	const struct dvb_table_pmt_stream *stream = pmt->stream;
 	uint16_t streams = 0;
 	while(stream) {
-		dvb_log("|- %5d    %4d  %s (%d)", stream->elementary_pid, stream->section_length,
+		dvb_log("|- %5d   %s (%d)", stream->elementary_pid,
 				dvb_descriptors[stream->type].name, stream->type);
 		dvb_print_descriptors(parms, stream->descriptor);
 		stream = stream->next;
diff --git a/lib/libdvbv5/descriptors/sdt.c b/lib/libdvbv5/descriptors/sdt.c
index 2194703..5248274 100644
--- a/lib/libdvbv5/descriptors/sdt.c
+++ b/lib/libdvbv5/descriptors/sdt.c
@@ -26,9 +26,11 @@ void dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize
 {
 	uint8_t *d;
 	const uint8_t *p = ptr;
-	struct dvb_table_sdt *sdt;
+	struct dvb_table_sdt *sdt = (struct dvb_table_sdt *) ptr;
 	struct dvb_table_sdt_service **head;
 
+	bswap16(sdt->network_id);
+
 	if (!*buf) {
 		d = malloc(DVB_MAX_PAYLOAD_PACKET_SIZE * 2);
 		*buf = d;
@@ -39,18 +41,17 @@ void dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize
 
 		sdt->service = NULL;
 		head = &sdt->service;
-
 	} else {
 		// should realloc d
 		d = *buf;
 
-		// find end of curent list
+		/* find end of curent list */
 		sdt = (struct dvb_table_sdt *) d;
 		head = &sdt->service;
 		while (*head != NULL)
 			head = &(*head)->next;
 
-		// read new table
+		/* read new table */
 		sdt = (struct dvb_table_sdt *) p;
 	}
 	p += sizeof(struct dvb_table_sdt) - sizeof(sdt->service);
@@ -85,13 +86,16 @@ void dvb_table_sdt_print(struct dvb_v5_fe_parms *parms, struct dvb_table_sdt *sd
 {
 	dvb_log("SDT");
 	dvb_table_header_print(parms, &sdt->header);
+	dvb_log("|- network_id         %d", sdt->network_id);
 	dvb_log("|\\  service_id");
 	const struct dvb_table_sdt_service *service = sdt->service;
 	uint16_t services = 0;
 	while(service) {
 		dvb_log("|- %7d", service->service_id);
-		dvb_log("|   EIT_schedule: %d", service->EIT_schedule);
-		dvb_log("|   EIT_present_following: %d", service->EIT_present_following);
+		dvb_log("|   EIT schedule          %d", service->EIT_schedule);
+		dvb_log("|   EIT present following %d", service->EIT_present_following);
+		dvb_log("|   free CA mode          %d", service->free_CA_mode);
+		dvb_log("|   running status        %d", service->running_status);
 		dvb_print_descriptors(parms, service->descriptor);
 		service = service->next;
 		services++;
diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index 5b496bb..33b0fa8 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -309,6 +309,7 @@ int dvb_read_section(struct dvb_v5_fe_parms *parms, int dmx_fd, unsigned char ta
 	uint64_t sections_read = 0;
 	uint64_t sections_total = 0;
 	ssize_t table_length = 0;
+	int table_id = -1;
 
 	// FIXME: verify known table
 	*buf = NULL;
@@ -357,6 +358,14 @@ int dvb_read_section(struct dvb_v5_fe_parms *parms, int dmx_fd, unsigned char ta
 
 		struct dvb_table_header *h = (struct dvb_table_header *) tmp;
 		dvb_table_header_init(h);
+		if (table_id == -1)
+			table_id = h->id;
+		else if (h->id != table_id) {
+			dvb_logwarn("Table ID mismatch reading multi section table: %d != %d", h->id, table_id);
+			free(tmp);
+			tmp = NULL;
+			continue;
+		}
 		/*dvb_log("dvb_read_section: got section %d/%d", h->section_id + 1, h->last_section + 1);*/
 		if (!sections_total) {
 			if (h->last_section + 1 > 32) {
@@ -372,7 +381,10 @@ int dvb_read_section(struct dvb_v5_fe_parms *parms, int dmx_fd, unsigned char ta
 		/*if (sections_read != sections_total)*/
 			/*dvb_logwarn("dvb_read_section: sections are missing: %d != %d", sections_read, sections_total);*/
 
-		dvb_table_initializers[table].init(parms, tmp, count, buf, &table_length);
+		if (dvb_table_initializers[table].init)
+			dvb_table_initializers[table].init(parms, tmp, count, buf, &table_length);
+		else
+			dvb_logerr("no initializer for table %d", table);
 
 		free(tmp);
 		tmp = NULL;
-- 
1.7.2.5

