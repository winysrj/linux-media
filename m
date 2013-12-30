Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:62562 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685Ab3L3Mt0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Dec 2013 07:49:26 -0500
Received: by mail-ee0-f45.google.com with SMTP id d49so5056394eek.4
        for <linux-media@vger.kernel.org>; Mon, 30 Dec 2013 04:49:24 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 02/18] libdvbv5: service location descriptor support
Date: Mon, 30 Dec 2013 13:48:35 +0100
Message-Id: <1388407731-24369-2-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
References: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement the service location descriptor (0xa1), and small cleanups.

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/descriptors.h                        |  4 +-
 lib/include/descriptors/desc_service_location.h  | 69 +++++++++++++++++++++++
 lib/libdvbv5/Makefile.am                         |  3 +-
 lib/libdvbv5/descriptors.c                       |  2 +-
 lib/libdvbv5/descriptors/desc_service_location.c | 70 ++++++++++++++++++++++++
 5 files changed, 145 insertions(+), 3 deletions(-)
 create mode 100644 lib/include/descriptors/desc_service_location.h
 create mode 100644 lib/libdvbv5/descriptors/desc_service_location.c

diff --git a/lib/include/descriptors.h b/lib/include/descriptors.h
index 2e614f0..5ab29a0 100644
--- a/lib/include/descriptors.h
+++ b/lib/include/descriptors.h
@@ -1,4 +1,4 @@
-  /*
+/*
  * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
  *
  * This program is free software; you can redistribute it and/or
@@ -216,6 +216,8 @@ enum descriptors {
 	/* SCTE 35 2004 */
 	CUE_identifier_descriptor			= 0x8a,
 
+	extended_channel_name				= 0xa0,
+	service_location				= 0xa1,
 	/* From http://www.etherguidesystems.com/Help/SDOs/ATSC/Semantics/Descriptors/Default.aspx */
 	component_name_descriptor			= 0xa3,
 
diff --git a/lib/include/descriptors/desc_service_location.h b/lib/include/descriptors/desc_service_location.h
new file mode 100644
index 0000000..89ed055
--- /dev/null
+++ b/lib/include/descriptors/desc_service_location.h
@@ -0,0 +1,69 @@
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
+#include <unistd.h> /* ssize_t */
+
+struct dvb_desc_service_location_element {
+	uint8_t stream_type;
+	union {
+		uint16_t bitfield;
+		struct {
+			uint16_t elementary_pid:13;
+			uint16_t reserved:3;
+		};
+	};
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
+		};
+	};
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
diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
index 2ad5902..80e8adb 100644
--- a/lib/libdvbv5/Makefile.am
+++ b/lib/libdvbv5/Makefile.am
@@ -48,7 +48,8 @@ libdvbv5_la_SOURCES = \
   descriptors/nit.c  ../include/descriptors/nit.h \
   descriptors/sdt.c  ../include/descriptors/sdt.h \
   descriptors/vct.c  ../include/descriptors/vct.h \
-  descriptors/eit.c  ../include/descriptors/eit.h
+  descriptors/eit.c  ../include/descriptors/eit.h \
+  descriptors/desc_service_location.c  ../include/descriptors/desc_service_location.h
 
 libdvbv5_la_CPPFLAGS = $(ENFORCE_LIBDVBV5_STATIC)
 libdvbv5_la_LDFLAGS = $(LIBDVBV5_VERSION) $(ENFORCE_LIBDVBV5_STATIC) -lm
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index 5ce9241..437b2f4 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -69,7 +69,7 @@ void dvb_desc_default_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, st
 
 void dvb_desc_default_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
 {
-	dvb_log("|                   %s (0x%02x)", dvb_descriptors[desc->type].name, desc->type);
+	dvb_log("|                   %s (%#02x)", dvb_descriptors[desc->type].name, desc->type);
 	hexdump(parms, "|                       ", desc->data, desc->length);
 }
 
diff --git a/lib/libdvbv5/descriptors/desc_service_location.c b/lib/libdvbv5/descriptors/desc_service_location.c
new file mode 100644
index 0000000..3759665
--- /dev/null
+++ b/lib/libdvbv5/descriptors/desc_service_location.c
@@ -0,0 +1,70 @@
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
+#include "descriptors.h"
+#include "dvb-fe.h"
+
+void dvb_desc_service_location_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+{
+	struct dvb_desc_service_location *service_location = (struct dvb_desc_service_location *) desc;
+	/* copy from .next */
+	memcpy(((uint8_t *) service_location )
+			+ sizeof(service_location->type)
+			+ sizeof(service_location->length)
+			+ sizeof(service_location->next),
+		buf,
+		sizeof(service_location->bitfield) + sizeof(service_location->elements));
+	buf +=  sizeof(service_location->bitfield) + sizeof(service_location->elements);
+
+	bswap16(service_location->bitfield);
+
+	// FIXME: handle elements == 0
+	service_location->element = malloc(service_location->elements * sizeof(struct dvb_desc_service_location_element));
+	int i;
+	struct dvb_desc_service_location_element *element = service_location->element;
+	for(i = 0; i < service_location->elements; i++) {
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
+	dvb_log("|    pcr pid      %d", service_location->pcr_pid);
+	dvb_log("|    streams:");
+	int i;
+	struct dvb_desc_service_location_element *element = service_location->element;
+	for(i = 0; i < service_location->elements; i++) {
+		dvb_log("|      pid %d, type %d: %s", element[i].elementary_pid, element[i].stream_type, element[i].language);
+	}
+	dvb_log("| 	%d elements", service_location->elements);
+}
+
+void dvb_desc_service_location_free(struct dvb_desc *desc)
+{
+	const struct dvb_desc_service_location *service_location = (const struct dvb_desc_service_location *) desc;
+	free(service_location->element);
+}
+
-- 
1.8.3.2

