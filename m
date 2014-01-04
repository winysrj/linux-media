Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:43944 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbaADRIm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jan 2014 12:08:42 -0500
Received: by mail-ee0-f42.google.com with SMTP id e53so7237582eek.1
        for <linux-media@vger.kernel.org>; Sat, 04 Jan 2014 09:08:41 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 03/11] libdvbv5: add parser for CAT
Date: Sat,  4 Jan 2014 18:07:53 +0100
Message-Id: <1388855282-19295-3-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388855282-19295-1-git-send-email-neolynx@gmail.com>
References: <1388855282-19295-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/libdvbv5/cat.h     |   51 +++++++++++++++++++++++++++++++
 lib/libdvbv5/Makefile.am       |    2 ++
 lib/libdvbv5/descriptors.c     |    2 ++
 lib/libdvbv5/descriptors/cat.c |   66 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 121 insertions(+)
 create mode 100644 lib/include/libdvbv5/cat.h
 create mode 100644 lib/libdvbv5/descriptors/cat.c

diff --git a/lib/include/libdvbv5/cat.h b/lib/include/libdvbv5/cat.h
new file mode 100644
index 0000000..4c442a8
--- /dev/null
+++ b/lib/include/libdvbv5/cat.h
@@ -0,0 +1,51 @@
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
+#ifndef _CAT_H
+#define _CAT_H
+
+#include <stdint.h>
+#include <unistd.h> /* ssize_t */
+
+#include <libdvbv5/header.h>
+
+#define DVB_TABLE_CAT      0x01
+#define DVB_TABLE_CAT_PID  0x0001
+
+struct dvb_table_cat {
+	struct dvb_table_header header;
+	struct dvb_desc *descriptor;
+} __attribute__((packed));
+
+struct dvb_v5_fe_parms;
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+void dvb_table_cat_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
+void dvb_table_cat_free(struct dvb_table_cat *cat);
+void dvb_table_cat_print(struct dvb_v5_fe_parms *parms, struct dvb_table_cat *t);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
index 8f89531..0abe42d 100644
--- a/lib/libdvbv5/Makefile.am
+++ b/lib/libdvbv5/Makefile.am
@@ -39,6 +39,7 @@ otherinclude_HEADERS = \
 	../include/libdvbv5/atsc_header.h \
 	../include/libdvbv5/mgt.h \
 	../include/libdvbv5/eit.h \
+	../include/libdvbv5/cat.h \
 	../include/libdvbv5/atsc_eit.h \
 	../include/libdvbv5/desc_service_location.h \
 	../include/libdvbv5/mpeg_ts.h \
@@ -74,6 +75,7 @@ libdvbv5_la_SOURCES = \
 	descriptors/vct.c		\
 	descriptors/mgt.c		\
 	descriptors/eit.c		\
+	descriptors/cat.c		\
 	descriptors/atsc_eit.c		\
 	descriptors/desc_language.c		\
 	descriptors/desc_network_name.c		\
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index 626f81d..e888123 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -31,6 +31,7 @@
 #include <libdvbv5/dvb-log.h>
 
 #include <libdvbv5/pat.h>
+#include <libdvbv5/cat.h>
 #include <libdvbv5/pmt.h>
 #include <libdvbv5/nit.h>
 #include <libdvbv5/sdt.h>
@@ -78,6 +79,7 @@ void dvb_desc_default_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc
 
 const struct dvb_table_init dvb_table_initializers[] = {
 	[DVB_TABLE_PAT]          = { dvb_table_pat_init, sizeof(struct dvb_table_pat) },
+	[DVB_TABLE_CAT]          = { dvb_table_cat_init, sizeof(struct dvb_table_cat) },
 	[DVB_TABLE_PMT]          = { dvb_table_pmt_init, sizeof(struct dvb_table_pmt) },
 	[DVB_TABLE_NIT]          = { dvb_table_nit_init, sizeof(struct dvb_table_nit) },
 	[DVB_TABLE_SDT]          = { dvb_table_sdt_init, sizeof(struct dvb_table_sdt) },
diff --git a/lib/libdvbv5/descriptors/cat.c b/lib/libdvbv5/descriptors/cat.c
new file mode 100644
index 0000000..e6fc64e
--- /dev/null
+++ b/lib/libdvbv5/descriptors/cat.c
@@ -0,0 +1,66 @@
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
+#include <libdvbv5/cat.h>
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/dvb-fe.h>
+
+void dvb_table_cat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
+			ssize_t buflen, uint8_t *table, ssize_t *table_length)
+{
+	struct dvb_table_cat *cat = (void *)table;
+	struct dvb_desc **head_desc = &cat->descriptor;
+	const uint8_t *p = buf, *endbuf = buf + buflen - 4;
+	size_t size;
+
+	if (*table_length > 0) {
+		/* find end of current lists */
+		while (*head_desc != NULL)
+			head_desc = &(*head_desc)->next;
+	}
+
+	size = offsetof(struct dvb_table_cat, descriptor);
+	if (p + size > endbuf) {
+		dvb_logerr("CAT table was truncated while filling dvb_table_cat. Need %zu bytes, but has only %zu.",
+			   size, buflen);
+		return;
+	}
+
+	memcpy(table, p, size);
+	p += size;
+	*table_length = sizeof(struct dvb_table_cat);
+
+	size = endbuf - p;
+	dvb_parse_descriptors(parms, p, size, head_desc);
+}
+
+void dvb_table_cat_free(struct dvb_table_cat *cat)
+{
+	dvb_free_descriptors((struct dvb_desc **) &cat->descriptor);
+	free(cat);
+}
+
+void dvb_table_cat_print(struct dvb_v5_fe_parms *parms, struct dvb_table_cat *cat)
+{
+	dvb_log("cat");
+	dvb_table_header_print(parms, &cat->header);
+	dvb_print_descriptors(parms, cat->descriptor);
+}
+
-- 
1.7.10.4

