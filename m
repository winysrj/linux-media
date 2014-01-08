Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:54147 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932525AbaAHWNK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 17:13:10 -0500
Received: by mail-ea0-f173.google.com with SMTP id o10so1078683eaj.32
        for <linux-media@vger.kernel.org>; Wed, 08 Jan 2014 14:13:09 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 2/2] libdvbv5: service location descriptor support
Date: Wed,  8 Jan 2014 23:12:47 +0100
Message-Id: <1389219167-23293-2-git-send-email-neolynx@gmail.com>
In-Reply-To: <1389219167-23293-1-git-send-email-neolynx@gmail.com>
References: <1389219167-23293-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- implement the service location descriptor (0xa1)
- small cleanups

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/descriptors.h                        |  4 +-
 lib/include/descriptors/desc_service_location.h  | 68 ++++++++++++++++++++
 lib/libdvbv5/descriptors/desc_service_location.c | 79 ++++++++++++++++++++++++
 3 files changed, 150 insertions(+), 1 deletion(-)
 create mode 100644 lib/include/descriptors/desc_service_location.h
 create mode 100644 lib/libdvbv5/descriptors/desc_service_location.c

diff --git a/lib/include/descriptors.h b/lib/include/descriptors.h
index 35eab1c..6f89aeb 100644
--- a/lib/include/descriptors.h
+++ b/lib/include/descriptors.h
@@ -1,4 +1,4 @@
-  /*
+/*
  * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
  *
  * This program is free software; you can redistribute it and/or
@@ -222,6 +222,8 @@ enum descriptors {
 	/* SCTE 35 2004 */
 	CUE_identifier_descriptor			= 0x8a,
 
+	extended_channel_name				= 0xa0,
+	service_location				= 0xa1,
 	/* From http://www.etherguidesystems.com/Help/SDOs/ATSC/Semantics/Descriptors/Default.aspx */
 	component_name_descriptor			= 0xa3,
 
diff --git a/lib/include/descriptors/desc_service_location.h b/lib/include/descriptors/desc_service_location.h
new file mode 100644
index 0000000..78490bd
--- /dev/null
+++ b/lib/include/descriptors/desc_service_location.h
@@ -0,0 +1,68 @@
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
+#ifndef _SERVICE_LOCATION_H
+#define _SERVICE_LOCATION_H
+
+#include <stdint.h>
+
+struct dvb_desc_service_location_element {
+	uint8_t stream_type;
+	union {
+		uint16_t bitfield;
+		struct {
+			uint16_t elementary_pid:13;
+			uint16_t reserved:3;
+		} __attribute__((packed));
+	} __attribute__((packed));
+	uint8_t language[4];
+} __attribute__((packed));
+
+struct dvb_desc_service_location {
+	uint8_t type;
+	uint8_t length;
+	struct dvb_desc *next;
+
+	union {
+		uint16_t bitfield;
+		struct {
+			uint16_t pcr_pid:13;
+			uint16_t reserved:3;
+		} __attribute__((packed));
+	} __attribute__((packed));
+	uint8_t elements;
+	struct dvb_desc_service_location_element *element;
+} __attribute__((packed));
+
+struct dvb_v5_fe_parms;
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+void dvb_desc_service_location_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+void dvb_desc_service_location_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+void dvb_desc_service_location_free (struct dvb_desc *desc);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/libdvbv5/descriptors/desc_service_location.c b/lib/libdvbv5/descriptors/desc_service_location.c
new file mode 100644
index 0000000..187a8ac
--- /dev/null
+++ b/lib/libdvbv5/descriptors/desc_service_location.c
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
+#include "descriptors/desc_service_location.h"
+#include "dvb-fe.h"
+
+void dvb_desc_service_location_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+{
+	struct dvb_desc_service_location *service_location = (struct dvb_desc_service_location *) desc;
+	uint8_t *endbuf = buf + desc->length;
+	ssize_t size = sizeof(struct dvb_desc_service_location) - sizeof(struct dvb_desc);
+	struct dvb_desc_service_location_element *element;
+	int i;
+
+	if (buf + size > endbuf) {
+		dvb_logerr("%s: short read %d/%zd bytes", __FUNCTION__, endbuf - buf, size);
+		return;
+	}
+
+	memcpy(desc->data, buf, size);
+	bswap16(service_location->bitfield);
+	buf += size;
+
+	if (service_location->elements == 0)
+		return;
+
+	size = service_location->elements * sizeof(struct dvb_desc_service_location_element);
+	if (buf + size > endbuf) {
+		dvb_logerr("%s: short read %d/%zd bytes", __FUNCTION__, endbuf - buf, size);
+		return;
+	}
+	service_location->element = malloc(size);
+	element = service_location->element;
+	for (i = 0; i < service_location->elements; i++) {
+		memcpy(element, buf, sizeof(struct dvb_desc_service_location_element) - 1); /* no \0 in lang */
+		buf += sizeof(struct dvb_desc_service_location_element) - 1;
+		element->language[3] = '\0';
+		bswap16(element->bitfield);
+		element++;
+	}
+}
+
+void dvb_desc_service_location_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
+{
+	const struct dvb_desc_service_location *service_location = (const struct dvb_desc_service_location *) desc;
+	struct dvb_desc_service_location_element *element = service_location->element;
+	int i;
+
+	dvb_log("|    pcr pid      %d", service_location->pcr_pid);
+	dvb_log("|    streams:");
+	for (i = 0; i < service_location->elements; i++)
+		dvb_log("|      pid %d, type %d: %s", element[i].elementary_pid, element[i].stream_type, element[i].language);
+	dvb_log("| 	%d elements", service_location->elements);
+}
+
+void dvb_desc_service_location_free(struct dvb_desc *desc)
+{
+	const struct dvb_desc_service_location *service_location = (const struct dvb_desc_service_location *) desc;
+
+	free(service_location->element);
+}
+
-- 
1.8.3.2

