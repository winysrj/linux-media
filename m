Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:44303 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab3L3Mta (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Dec 2013 07:49:30 -0500
Received: by mail-ea0-f169.google.com with SMTP id l9so4421913eaj.0
        for <linux-media@vger.kernel.org>; Mon, 30 Dec 2013 04:49:29 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 08/18] libdvbv5: implement MGT parser
Date: Mon, 30 Dec 2013 13:48:41 +0100
Message-Id: <1388407731-24369-8-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
References: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/descriptors/mgt.h  |  80 ++++++++++++++++++++++++++++
 lib/libdvbv5/Makefile.am       |   1 +
 lib/libdvbv5/descriptors.c     |   2 +
 lib/libdvbv5/descriptors/mgt.c | 117 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 200 insertions(+)
 create mode 100644 lib/include/descriptors/mgt.h
 create mode 100644 lib/libdvbv5/descriptors/mgt.c

diff --git a/lib/include/descriptors/mgt.h b/lib/include/descriptors/mgt.h
new file mode 100644
index 0000000..9eaac02
--- /dev/null
+++ b/lib/include/descriptors/mgt.h
@@ -0,0 +1,80 @@
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
+#ifndef _MGT_H
+#define _MGT_H
+
+#include <stdint.h>
+#include <unistd.h> /* ssize_t */
+
+#include "descriptors/atsc_header.h"
+#include "descriptors.h"
+
+#define ATSC_TABLE_MGT 0xC7
+
+struct atsc_table_mgt_table {
+	uint16_t type;
+	union {
+		uint16_t bitfield;
+		struct {
+			uint16_t pid:13;
+			uint16_t one:3;
+		} __attribute__((packed));
+	} __attribute__((packed));
+        uint8_t type_version:5;
+        uint8_t one2:3;
+        uint32_t size;
+	union {
+		uint16_t bitfield2;
+		struct {
+			uint16_t desc_length:12;
+			uint16_t one3:4;
+		} __attribute__((packed));
+	} __attribute__((packed));
+	struct dvb_desc *descriptor;
+	struct atsc_table_mgt_table *next;
+} __attribute__((packed));
+
+struct atsc_table_mgt {
+	struct atsc_table_header header;
+        uint16_t tables;
+        struct atsc_table_mgt_table *table;
+	struct dvb_desc *descriptor;
+} __attribute__((packed));
+
+
+#define atsc_mgt_table_foreach( _tran, _mgt ) \
+  for( struct atsc_table_mgt_table *_tran = _mgt->table; _tran; _tran = _tran->next ) \
+
+struct dvb_v5_fe_parms;
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+void atsc_table_mgt_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
+void atsc_table_mgt_free(struct atsc_table_mgt *mgt);
+void atsc_table_mgt_print(struct dvb_v5_fe_parms *parms, struct atsc_table_mgt *mgt);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
index 33693cc..7755e05 100644
--- a/lib/libdvbv5/Makefile.am
+++ b/lib/libdvbv5/Makefile.am
@@ -49,6 +49,7 @@ libdvbv5_la_SOURCES = \
   descriptors/sdt.c  ../include/descriptors/sdt.h \
   descriptors/vct.c  ../include/descriptors/vct.h \
   descriptors/eit.c  ../include/descriptors/eit.h \
+  descriptors/mgt.c  ../include/descriptors/mgt.h \
   descriptors/desc_service_location.c  ../include/descriptors/desc_service_location.h \
   descriptors/mpeg_ts.c  ../include/descriptors/mpeg_ts.h \
   descriptors/mpeg_pes.c  ../include/descriptors/mpeg_pes.h \
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index bc3d51a..7b9e9d0 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -36,6 +36,7 @@
 #include "descriptors/sdt.h"
 #include "descriptors/eit.h"
 #include "descriptors/vct.h"
+#include "descriptors/mgt.h"
 #include "descriptors/desc_language.h"
 #include "descriptors/desc_network_name.h"
 #include "descriptors/desc_cable_delivery.h"
@@ -84,6 +85,7 @@ const struct dvb_table_init dvb_table_initializers[] = {
 	[DVB_TABLE_TVCT] = { dvb_table_vct_init, sizeof(struct dvb_table_vct) },
 	[DVB_TABLE_CVCT] = { dvb_table_vct_init, sizeof(struct dvb_table_vct) },
 	[DVB_TABLE_EIT_SCHEDULE] = { dvb_table_eit_init, sizeof(struct dvb_table_eit) },
+	[ATSC_TABLE_MGT]         = { atsc_table_mgt_init, sizeof(struct atsc_table_mgt) },
 };
 
 char *default_charset = "iso-8859-1";
diff --git a/lib/libdvbv5/descriptors/mgt.c b/lib/libdvbv5/descriptors/mgt.c
new file mode 100644
index 0000000..09d1cf2
--- /dev/null
+++ b/lib/libdvbv5/descriptors/mgt.c
@@ -0,0 +1,117 @@
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
+#include "descriptors/mgt.h"
+#include "dvb-fe.h"
+
+void atsc_table_mgt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length)
+{
+	const uint8_t *p = buf;
+	struct atsc_table_mgt *mgt = (struct atsc_table_mgt *) table;
+	struct dvb_desc **head_desc;
+	struct atsc_table_mgt_table **head;
+	/*int desc_length;*/
+
+	if (*table_length > 0) {
+		/* find end of curent lists */
+		head_desc = &mgt->descriptor;
+		while (*head_desc != NULL)
+			head_desc = &(*head_desc)->next;
+		head = &mgt->table;
+		while (*head != NULL)
+			head = &(*head)->next;
+	} else {
+		memcpy(table, p, sizeof(struct atsc_table_mgt) - sizeof(mgt->descriptor) - sizeof(mgt->table));
+		*table_length = sizeof(struct atsc_table_mgt);
+
+		mgt->descriptor = NULL;
+		mgt->table = NULL;
+		head_desc = &mgt->descriptor;
+		head = &mgt->table;
+		bswap16(mgt->tables);
+	}
+	p += sizeof(struct atsc_table_mgt) - sizeof(mgt->descriptor) - sizeof(mgt->table);
+
+	/*dvb_parse_descriptors(parms, p, desc_length, head_desc);*/
+	/*p += desc_length;*/
+        int i = 0;
+	struct atsc_table_mgt_table *last = NULL;
+	while (i++ < mgt->tables && (uint8_t *) p < buf + buflen - 4) {
+		struct atsc_table_mgt_table *table = (struct atsc_table_mgt_table *) malloc(sizeof(struct atsc_table_mgt_table));
+		memcpy(table, p, sizeof(struct atsc_table_mgt_table) - sizeof(table->descriptor) - sizeof(table->next));
+		p += sizeof(struct atsc_table_mgt_table) - sizeof(table->descriptor) - sizeof(table->next);
+
+		bswap16(table->type);
+		bswap16(table->bitfield);
+		bswap16(table->bitfield2);
+		bswap32(table->size);
+		table->descriptor = NULL;
+		table->next = NULL;
+
+		if(!*head)
+			*head = table;
+		if(last)
+			last->next = table;
+
+		/* get the descriptors for each table */
+		struct dvb_desc **head_desc = &table->descriptor;
+		dvb_parse_descriptors(parms, p, table->desc_length, head_desc);
+
+		p += table->desc_length;
+		last = table;
+	}
+}
+
+void atsc_table_mgt_free(struct atsc_table_mgt *mgt)
+{
+	struct atsc_table_mgt_table *table = mgt->table;
+	dvb_free_descriptors((struct dvb_desc **) &mgt->descriptor);
+	while(table) {
+		dvb_free_descriptors((struct dvb_desc **) &table->descriptor);
+		struct atsc_table_mgt_table *tmp = table;
+		table = table->next;
+		free(tmp);
+	}
+	free(mgt);
+}
+
+void atsc_table_mgt_print(struct dvb_v5_fe_parms *parms, struct atsc_table_mgt *mgt)
+{
+	dvb_log("MGT");
+	atsc_table_header_print(parms, &mgt->header);
+	dvb_log("| tables           %d", mgt->tables);
+	/*dvb_print_descriptors(parms, mgt->descriptor);*/
+	const struct atsc_table_mgt_table *table = mgt->table;
+	uint16_t tables = 0;
+	while(table) {
+                dvb_log("|- type %04x    %d", table->type, table->pid);
+                dvb_log("|  one          %d", table->one);
+                dvb_log("|  one2         %d", table->one2);
+                dvb_log("|  type version %d", table->type_version);
+                dvb_log("|  size         %d", table->size);
+                dvb_log("|  one3         %d", table->one3);
+                dvb_log("|  desc_length  %d", table->desc_length);
+		dvb_print_descriptors(parms, table->descriptor);
+		table = table->next;
+		tables++;
+	}
+	dvb_log("|_  %d tables", tables);
+}
+
-- 
1.8.3.2

