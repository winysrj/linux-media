Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:63710 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbaAHLXy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 06:23:54 -0500
Received: by mail-ee0-f51.google.com with SMTP id b15so617291eek.10
        for <linux-media@vger.kernel.org>; Wed, 08 Jan 2014 03:23:53 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 2/3] libdvbv5: implement MGT table parser
Date: Wed,  8 Jan 2014 12:23:27 +0100
Message-Id: <1389180208-3458-2-git-send-email-neolynx@gmail.com>
In-Reply-To: <1389180208-3458-1-git-send-email-neolynx@gmail.com>
References: <1389180208-3458-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Master Guide Table is used in ATSC. Implementation
according to specs A/65:2009

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/descriptors/mgt.h  |  79 +++++++++++++++++++++++
 lib/libdvbv5/Makefile.am       |   3 +-
 lib/libdvbv5/descriptors.c     |   1 +
 lib/libdvbv5/descriptors/mgt.c | 140 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 222 insertions(+), 1 deletion(-)
 create mode 100644 lib/include/descriptors/mgt.h
 create mode 100644 lib/libdvbv5/descriptors/mgt.c

diff --git a/lib/include/descriptors/mgt.h b/lib/include/descriptors/mgt.h
new file mode 100644
index 0000000..9c583b4
--- /dev/null
+++ b/lib/include/descriptors/mgt.h
@@ -0,0 +1,79 @@
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
index 2ad5902..44f68d4 100644
--- a/lib/libdvbv5/Makefile.am
+++ b/lib/libdvbv5/Makefile.am
@@ -48,7 +48,8 @@ libdvbv5_la_SOURCES = \
   descriptors/nit.c  ../include/descriptors/nit.h \
   descriptors/sdt.c  ../include/descriptors/sdt.h \
   descriptors/vct.c  ../include/descriptors/vct.h \
-  descriptors/eit.c  ../include/descriptors/eit.h
+  descriptors/eit.c  ../include/descriptors/eit.h \
+  descriptors/mgt.c  ../include/descriptors/mgt.h \
 
 libdvbv5_la_CPPFLAGS = $(ENFORCE_LIBDVBV5_STATIC)
 libdvbv5_la_LDFLAGS = $(LIBDVBV5_VERSION) $(ENFORCE_LIBDVBV5_STATIC) -lm
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index d0887f4..7385027 100644
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
diff --git a/lib/libdvbv5/descriptors/mgt.c b/lib/libdvbv5/descriptors/mgt.c
new file mode 100644
index 0000000..7279982
--- /dev/null
+++ b/lib/libdvbv5/descriptors/mgt.c
@@ -0,0 +1,140 @@
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
+	const uint8_t *p = buf, *endbuf = buf + buflen - 4; /* minus CRC */
+	struct atsc_table_mgt *mgt = (struct atsc_table_mgt *) table;
+	struct dvb_desc **head_desc;
+	struct atsc_table_mgt_table **head;
+	int i = 0;
+	struct atsc_table_mgt_table *last = NULL;
+	size_t size = offsetof(struct atsc_table_mgt, table);
+
+	if (p + size > endbuf) {
+		dvb_logerr("%s: short read %zd/%zd bytes", __func__,
+			   size, endbuf - p);
+		return;
+	}
+
+	if (*table_length > 0) {
+		/* find end of curent lists */
+		head_desc = &mgt->descriptor;
+		while (*head_desc != NULL)
+			head_desc = &(*head_desc)->next;
+		head = &mgt->table;
+		while (*head != NULL)
+			head = &(*head)->next;
+
+		/* FIXME: read current mgt->tables for loop below */
+	} else {
+		memcpy(table, p, size);
+		*table_length = sizeof(struct atsc_table_mgt);
+
+		bswap16(mgt->tables);
+
+		mgt->descriptor = NULL;
+		mgt->table = NULL;
+		head_desc = &mgt->descriptor;
+		head = &mgt->table;
+	}
+	p += size;
+
+	while (i++ < mgt->tables && p < endbuf) {
+		struct atsc_table_mgt_table *table;
+
+		size = offsetof(struct atsc_table_mgt_table, descriptor);
+		if (p + size > endbuf) {
+			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
+				   size, endbuf - p);
+			return;
+		}
+		table = (struct atsc_table_mgt_table *) malloc(sizeof(struct atsc_table_mgt_table));
+		memcpy(table, p, size);
+		p += size;
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
+		size = table->desc_length;
+		if (p + size > endbuf) {
+			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
+				   size, endbuf - p);
+			return;
+		}
+		dvb_parse_descriptors(parms, p, size, &table->descriptor);
+
+		p += size;
+		last = table;
+	}
+	/* TODO: parse MGT descriptors here into head_desc */
+}
+
+void atsc_table_mgt_free(struct atsc_table_mgt *mgt)
+{
+	struct atsc_table_mgt_table *table = mgt->table;
+
+	dvb_free_descriptors((struct dvb_desc **) &mgt->descriptor);
+	while(table) {
+		struct atsc_table_mgt_table *tmp = table;
+
+		dvb_free_descriptors((struct dvb_desc **) &table->descriptor);
+		table = table->next;
+		free(tmp);
+	}
+	free(mgt);
+}
+
+void atsc_table_mgt_print(struct dvb_v5_fe_parms *parms, struct atsc_table_mgt *mgt)
+{
+	const struct atsc_table_mgt_table *table = mgt->table;
+	uint16_t tables = 0;
+
+	dvb_log("MGT");
+	atsc_table_header_print(parms, &mgt->header);
+	dvb_log("| tables           %d", mgt->tables);
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

