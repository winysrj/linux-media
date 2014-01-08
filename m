Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:56526 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160AbaAHLXz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 06:23:55 -0500
Received: by mail-ea0-f177.google.com with SMTP id n15so745796ead.36
        for <linux-media@vger.kernel.org>; Wed, 08 Jan 2014 03:23:54 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 3/3] libdvbv5: implement ATSC EIT
Date: Wed,  8 Jan 2014 12:23:28 +0100
Message-Id: <1389180208-3458-3-git-send-email-neolynx@gmail.com>
In-Reply-To: <1389180208-3458-1-git-send-email-neolynx@gmail.com>
References: <1389180208-3458-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ATSC has a different EIT table then DVB. This implements
the parser according to secifications defined in A/65:2009.

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/descriptors/atsc_eit.h  |  90 +++++++++++++++++++
 lib/libdvbv5/Makefile.am            |   4 +-
 lib/libdvbv5/descriptors.c          |   1 +
 lib/libdvbv5/descriptors/atsc_eit.c | 170 ++++++++++++++++++++++++++++++++++++
 4 files changed, 264 insertions(+), 1 deletion(-)
 create mode 100644 lib/include/descriptors/atsc_eit.h
 create mode 100644 lib/libdvbv5/descriptors/atsc_eit.c

diff --git a/lib/include/descriptors/atsc_eit.h b/lib/include/descriptors/atsc_eit.h
new file mode 100644
index 0000000..3bc5df6
--- /dev/null
+++ b/lib/include/descriptors/atsc_eit.h
@@ -0,0 +1,90 @@
+/*
+ * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
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
+#ifndef _ATSC_EIT_H
+#define _ATSC_EIT_H
+
+#include <stdint.h>
+#include <unistd.h> /* ssize_t */
+#include <time.h>
+
+#include "descriptors/atsc_header.h"
+#include "descriptors.h"
+
+#define ATSC_TABLE_EIT        0xCB
+
+struct atsc_table_eit_event {
+	union {
+		uint16_t bitfield;
+		struct {
+	          uint16_t event_id:14;
+	          uint16_t one:2;
+		} __attribute__((packed));
+	} __attribute__((packed));
+	uint32_t start_time;
+	union {
+		uint32_t bitfield2;
+		struct {
+			uint32_t title_length:8;
+			uint32_t duration:20;
+			uint32_t etm:2;
+			uint32_t one2:2;
+			uint32_t :2;
+		} __attribute__((packed));
+	} __attribute__((packed));
+	struct dvb_desc *descriptor;
+	struct atsc_table_eit_event *next;
+	struct tm start;
+	uint16_t source_id;
+} __attribute__((packed));
+
+union atsc_table_eit_desc_length {
+	uint16_t bitfield;
+	struct {
+		uint16_t desc_length:12;
+		uint16_t reserved:4;
+	} __attribute__((packed));
+} __attribute__((packed));
+
+struct atsc_table_eit {
+	struct atsc_table_header header;
+	uint8_t events;
+	struct atsc_table_eit_event *event;
+} __attribute__((packed));
+
+#define atsc_eit_event_foreach(_event, _eit) \
+	for( struct atsc_table_eit_event *_event = _eit->event; _event; _event = _event->next ) \
+
+struct dvb_v5_fe_parms;
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+void atsc_table_eit_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
+void atsc_table_eit_free(struct atsc_table_eit *eit);
+void atsc_table_eit_print(struct dvb_v5_fe_parms *parms, struct atsc_table_eit *eit);
+void atsc_time(const uint32_t start_time, struct tm *tm);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
index 44f68d4..c6d2a42 100644
--- a/lib/libdvbv5/Makefile.am
+++ b/lib/libdvbv5/Makefile.am
@@ -48,8 +48,10 @@ libdvbv5_la_SOURCES = \
   descriptors/nit.c  ../include/descriptors/nit.h \
   descriptors/sdt.c  ../include/descriptors/sdt.h \
   descriptors/vct.c  ../include/descriptors/vct.h \
-  descriptors/eit.c  ../include/descriptors/eit.h \
+  descriptors/atsc_header.c ../include/descriptors/atsc_header.h \
   descriptors/mgt.c  ../include/descriptors/mgt.h \
+  descriptors/eit.c  ../include/descriptors/eit.h \
+  descriptors/atsc_eit.c  ../include/descriptors/atsc_eit.h
 
 libdvbv5_la_CPPFLAGS = $(ENFORCE_LIBDVBV5_STATIC)
 libdvbv5_la_LDFLAGS = $(LIBDVBV5_VERSION) $(ENFORCE_LIBDVBV5_STATIC) -lm
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index 7385027..aeace36 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -37,6 +37,7 @@
 #include "descriptors/eit.h"
 #include "descriptors/vct.h"
 #include "descriptors/mgt.h"
+#include "descriptors/atsc_eit.h"
 #include "descriptors/desc_language.h"
 #include "descriptors/desc_network_name.h"
 #include "descriptors/desc_cable_delivery.h"
diff --git a/lib/libdvbv5/descriptors/atsc_eit.c b/lib/libdvbv5/descriptors/atsc_eit.c
new file mode 100644
index 0000000..f8afc76
--- /dev/null
+++ b/lib/libdvbv5/descriptors/atsc_eit.c
@@ -0,0 +1,170 @@
+/*
+ * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
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
+#include "descriptors/atsc_eit.h"
+#include "dvb-fe.h"
+
+void atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length)
+{
+	const uint8_t *p = buf, *endbuf = buf + buflen - 4; /* minus CRC */;
+	struct atsc_table_eit *eit = (struct atsc_table_eit *) table;
+	struct atsc_table_eit_event **head;
+	int i = 0;
+	struct atsc_table_eit_event *last = NULL;
+	size_t size = offsetof(struct atsc_table_eit, event);
+
+	if (p + size > endbuf) {
+		dvb_logerr("%s: short read %zd/%zd bytes", __func__,
+			   size, endbuf - p);
+		return;
+	}
+
+	if (*table_length > 0) {
+		memcpy(eit, p, size);
+
+		/* find end of curent list */
+		head = &eit->event;
+		while (*head != NULL)
+			head = &(*head)->next;
+	} else {
+		memcpy(eit, p, size);
+		*table_length = sizeof(struct atsc_table_eit);
+
+		eit->event = NULL;
+		head = &eit->event;
+	}
+	p += size;
+
+	while (i++ < eit->events && p < endbuf) {
+		struct atsc_table_eit_event *event;
+                union atsc_table_eit_desc_length dl;
+
+		size = offsetof(struct atsc_table_eit_event, descriptor);
+		if (p + size > endbuf) {
+			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
+				   size, endbuf - p);
+			return;
+		}
+		event = (struct atsc_table_eit_event *) malloc(sizeof(struct atsc_table_eit_event));
+		memcpy(event, p, size);
+		p += size;
+
+		bswap16(event->bitfield);
+		bswap32(event->start_time);
+		bswap32(event->bitfield2);
+		event->descriptor = NULL;
+		event->next = NULL;
+                atsc_time(event->start_time, &event->start);
+		event->source_id = eit->header.id;
+
+		size = event->title_length - 1;
+		if (p + size > endbuf) {
+			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
+				   size, endbuf - p);
+			return;
+		}
+                /* TODO: parse title */
+                p += size;
+
+		if(!*head)
+			*head = event;
+		if(last)
+			last->next = event;
+
+		/* get the descriptors for each program */
+		size = sizeof(union atsc_table_eit_desc_length);
+		if (p + size > endbuf) {
+			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
+				   size, endbuf - p);
+			return;
+		}
+		memcpy(&dl, p, size);
+                p += size;
+                bswap16(dl.bitfield);
+
+		size = dl.desc_length;
+		if (p + size > endbuf) {
+			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
+				   size, endbuf - p);
+			return;
+		}
+		dvb_parse_descriptors(parms, p, size, &event->descriptor);
+
+		p += size;
+		last = event;
+	}
+}
+
+void atsc_table_eit_free(struct atsc_table_eit *eit)
+{
+	struct atsc_table_eit_event *event = eit->event;
+
+	while (event) {
+		struct atsc_table_eit_event *tmp = event;
+
+		dvb_free_descriptors((struct dvb_desc **) &event->descriptor);
+		event = event->next;
+		free(tmp);
+	}
+	free(eit);
+}
+
+void atsc_table_eit_print(struct dvb_v5_fe_parms *parms, struct atsc_table_eit *eit)
+{
+	dvb_log("EIT");
+	atsc_table_header_print(parms, &eit->header);
+	const struct atsc_table_eit_event *event = eit->event;
+	uint16_t events = 0;
+
+	while (event) {
+		char start[255];
+
+		strftime(start, sizeof(start), "%F %T", &event->start);
+		dvb_log("|-  event %7d", event->event_id);
+		dvb_log("|   Source                %d", event->source_id);
+		dvb_log("|   Starttime             %d", event->start_time);
+		dvb_log("|   Start                 %s UTC", start);
+		dvb_log("|   Duration              %dh %dm %ds", event->duration / 3600, (event->duration % 3600) / 60, event->duration % 60);
+		dvb_log("|   ETM                   %d", event->etm);
+		dvb_log("|   title length          %d", event->title_length);
+		dvb_print_descriptors(parms, event->descriptor);
+		event = event->next;
+		events++;
+	}
+	dvb_log("|_  %d events", events);
+}
+
+void atsc_time(const uint32_t start_time, struct tm *tm)
+{
+  tm->tm_sec   = 0;
+  tm->tm_min   = 0;
+  tm->tm_hour  = 0;
+  tm->tm_mday  = 6;
+  tm->tm_mon   = 0;
+  tm->tm_year  = 80;
+  tm->tm_isdst = -1;
+  tm->tm_wday  = 0;
+  tm->tm_yday  = 0;
+  mktime(tm);
+  tm->tm_sec += start_time;
+  mktime(tm);
+}
+
+
-- 
1.8.3.2

