Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:51543 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbaAHLXy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 06:23:54 -0500
Received: by mail-ea0-f177.google.com with SMTP id n15so753076ead.8
        for <linux-media@vger.kernel.org>; Wed, 08 Jan 2014 03:23:52 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 1/3] libdvbv5: implement ATSC standard header
Date: Wed,  8 Jan 2014 12:23:26 +0100
Message-Id: <1389180208-3458-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ATSC standard header is slightly different from the one used
in DVB. This implements the parser for it, and will be used by
the VCT table for example.

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/descriptors/atsc_header.h  | 63 ++++++++++++++++++++++++++++++++++
 lib/libdvbv5/descriptors/atsc_header.c | 47 +++++++++++++++++++++++++
 2 files changed, 110 insertions(+)
 create mode 100644 lib/include/descriptors/atsc_header.h
 create mode 100644 lib/libdvbv5/descriptors/atsc_header.c

diff --git a/lib/include/descriptors/atsc_header.h b/lib/include/descriptors/atsc_header.h
new file mode 100644
index 0000000..1e7148e
--- /dev/null
+++ b/lib/include/descriptors/atsc_header.h
@@ -0,0 +1,63 @@
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
+#ifndef _ATSC_HEADER_H
+#define _ATSC_HEADER_H
+
+#include <stdint.h>
+#include <unistd.h> /* ssize_t */
+
+#define ATSC_BASE_PID  0x1FFB
+
+struct atsc_table_header {
+	uint8_t  table_id;
+	union {
+		uint16_t bitfield;
+		struct {
+			uint16_t section_length:12;
+			uint16_t one:2;
+			uint16_t priv:1;
+			uint16_t syntax:1;
+		} __attribute__((packed));
+	};
+	uint16_t id;
+	uint8_t  current_next:1;
+	uint8_t  version:5;
+	uint8_t  one2:2;
+
+	uint8_t  section_id;
+	uint8_t  last_section;
+	uint8_t  protocol_version;
+} __attribute__((packed));
+
+struct dvb_v5_fe_parms;
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+int  atsc_table_header_init (struct atsc_table_header *t);
+void atsc_table_header_print(struct dvb_v5_fe_parms *parms, const struct atsc_table_header *t);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/libdvbv5/descriptors/atsc_header.c b/lib/libdvbv5/descriptors/atsc_header.c
new file mode 100644
index 0000000..ed152ce
--- /dev/null
+++ b/lib/libdvbv5/descriptors/atsc_header.c
@@ -0,0 +1,47 @@
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
+#include "descriptors/atsc_header.h"
+#include "descriptors.h"
+#include "dvb-fe.h"
+
+int atsc_table_header_init(struct atsc_table_header *t)
+{
+	bswap16(t->bitfield);
+	bswap16(t->id);
+	return 0;
+}
+
+void atsc_table_header_print(struct dvb_v5_fe_parms *parms, const struct atsc_table_header *t)
+{
+	dvb_log("| table_id         %02x", t->table_id);
+	dvb_log("| section_length   %d", t->section_length);
+	dvb_log("| syntax           %d", t->syntax);
+	dvb_log("| priv             %d", t->priv);
+	dvb_log("| one              %d", t->one);
+	dvb_log("| id               %d", t->id);
+	dvb_log("| one2             %d", t->one2);
+	dvb_log("| version          %d", t->version);
+	dvb_log("| current_next     %d", t->current_next);
+	dvb_log("| section_id       %d", t->section_id);
+	dvb_log("| last_section     %d", t->last_section);
+	dvb_log("| protocol_version %d", t->protocol_version);
+}
+
-- 
1.8.3.2

