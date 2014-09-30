Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:63973 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaI3PRb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 11:17:31 -0400
Received: by mail-we0-f169.google.com with SMTP id w61so2530134wes.0
        for <linux-media@vger.kernel.org>; Tue, 30 Sep 2014 08:17:30 -0700 (PDT)
From: Gregor Jasny <gjasny@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Gregor Jasny <gjasny@googlemail.com>,
	Andre Roth <neolynx@gmail.com>
Subject: [PATCH 2/3] libdvbv5: remove service_location descriptor
Date: Tue, 30 Sep 2014 17:17:07 +0200
Message-Id: <1412090228-19996-3-git-send-email-gjasny@googlemail.com>
In-Reply-To: <1412090228-19996-1-git-send-email-gjasny@googlemail.com>
References: <1412090228-19996-1-git-send-email-gjasny@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CC: Andre Roth <neolynx@gmail.com>
Signed-off-by: Gregor Jasny <gjasny@googlemail.com>
---
 TODO.libdvbv5                                    |   1 +
 lib/include/libdvbv5/desc_service_location.h     | 107 -----------------------
 lib/libdvbv5/Makefile.am                         |   3 +-
 lib/libdvbv5/compat-soname.c                     |  36 ++++++++
 lib/libdvbv5/descriptors/desc_service_location.c |  80 -----------------
 5 files changed, 38 insertions(+), 189 deletions(-)
 delete mode 100644 lib/include/libdvbv5/desc_service_location.h
 create mode 100644 lib/libdvbv5/compat-soname.c
 delete mode 100644 lib/libdvbv5/descriptors/desc_service_location.c

diff --git a/TODO.libdvbv5 b/TODO.libdvbv5
index 21091c4..6fa294a 100644
--- a/TODO.libdvbv5
+++ b/TODO.libdvbv5
@@ -1,2 +1,3 @@
 - On next SONAME bump
   - clean up dvb_fe_open* and re-apply 9eaa2327da63fffd0dcaaa02b7641e66f881e20d
+  - remove content of compat-soname.c
\ No newline at end of file
diff --git a/lib/include/libdvbv5/desc_service_location.h b/lib/include/libdvbv5/desc_service_location.h
deleted file mode 100644
index ca09241..0000000
--- a/lib/include/libdvbv5/desc_service_location.h
+++ /dev/null
@@ -1,107 +0,0 @@
-/*
- * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation version 2
- * of the License.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
- * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
- *
- */
-
-/**
- * @file desc_service_location.h
- * @ingroup descriptors
- * @brief Provides the descriptors for the DVB service location
- * @copyright GNU General Public License version 2 (GPLv2)
- * @author Andre Roth
- *
- * @par Relevant specs
- * The descriptor described herein is defined at:
- *
- * @par Bug Report
- * Please submit bug reports and patches to linux-media@vger.kernel.org
- *
- * @todo DOES THIS DESCRIPTOR EXISTS? IF SO, WHERE?
- *
- * FIXME: this seems to be a duplicated copy of the ATSC service location.
- */
-
-#ifndef _SERVICE_LOCATION_H
-#define _SERVICE_LOCATION_H
-
-#include <libdvbv5/descriptors.h>
-
-/**
- * @struct dvb_desc_service_location_element
- * @ingroup descriptors
- * @brief
- *
- * @param stream_type	stream type
- * @param elementary_pid	elementary pid
- * @param language	language
- */
-struct dvb_desc_service_location_element {
-	uint8_t stream_type;
-	union {
-		uint16_t bitfield;
-		struct {
-			uint16_t elementary_pid:13;
-			uint16_t reserved:3;
-		} __attribute__((packed));
-	} __attribute__((packed));
-	uint8_t language[4];
-} __attribute__((packed));
-
-/**
- * @struct dvb_desc_service_location
- * @ingroup descriptors
- * @brief
- *
- * @param type	type
- * @param length	length
- * @param next	pointer to struct dvb_desc
- * @param pcr_pid	pcr pid
- * @param elements	elements
- * @param element	pointer to struct dvb_desc_service_location_element
- */
-struct dvb_desc_service_location {
-	uint8_t type;
-	uint8_t length;
-	struct dvb_desc *next;
-
-	union {
-		uint16_t bitfield;
-		struct {
-			uint16_t pcr_pid:13;
-			uint16_t reserved:3;
-		} __attribute__((packed));
-	} __attribute__((packed));
-	uint8_t elements;
-	struct dvb_desc_service_location_element *element;
-} __attribute__((packed));
-
-struct dvb_v5_fe_parms;
-
-#ifdef __cplusplus
-extern "C" {
-#endif
-
-int dvb_desc_service_location_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
-void dvb_desc_service_location_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
-void dvb_desc_service_location_free (struct dvb_desc *desc);
-
-#ifdef __cplusplus
-}
-#endif
-
-#endif
diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
index fd21236..037c153 100644
--- a/lib/libdvbv5/Makefile.am
+++ b/lib/libdvbv5/Makefile.am
@@ -34,7 +34,6 @@ otherinclude_HEADERS = \
 	../include/libdvbv5/desc_logical_channel.h \
 	../include/libdvbv5/desc_ts_info.h \
 	../include/libdvbv5/desc_partial_reception.h \
-	../include/libdvbv5/desc_service_location.h \
 	../include/libdvbv5/desc_ca.h \
 	../include/libdvbv5/desc_ca_identifier.h \
 	../include/libdvbv5/nit.h \
@@ -56,6 +55,7 @@ noinst_LTLIBRARIES = libdvbv5.la
 endif
 
 libdvbv5_la_SOURCES = \
+        compat-soname.c \
 	crc32.c \
 	dvb-legacy-channel-format.c \
 	dvb-zap-format.c \
@@ -104,7 +104,6 @@ libdvbv5_la_SOURCES = \
 	descriptors/desc_logical_channel.c	\
 	descriptors/desc_ts_info.c		\
 	descriptors/desc_partial_reception.c	\
-	descriptors/desc_service_location.c	\
 	descriptors/desc_ca.c			\
 	descriptors/desc_ca_identifier.c
 
diff --git a/lib/libdvbv5/compat-soname.c b/lib/libdvbv5/compat-soname.c
new file mode 100644
index 0000000..e9f534a
--- /dev/null
+++ b/lib/libdvbv5/compat-soname.c
@@ -0,0 +1,36 @@
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
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/dvb-fe.h>
+
+int dvb_desc_service_location_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+{
+	return -1;
+}
+
+void dvb_desc_service_location_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
+{
+}
+
+void dvb_desc_service_location_free(struct dvb_desc *desc)
+{
+}
+
diff --git a/lib/libdvbv5/descriptors/desc_service_location.c b/lib/libdvbv5/descriptors/desc_service_location.c
deleted file mode 100644
index 95cb342..0000000
--- a/lib/libdvbv5/descriptors/desc_service_location.c
+++ /dev/null
@@ -1,80 +0,0 @@
-/*
- * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation version 2
- * of the License.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
- * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
- *
- */
-
-#include <libdvbv5/desc_service_location.h>
-#include <libdvbv5/descriptors.h>
-#include <libdvbv5/dvb-fe.h>
-
-int dvb_desc_service_location_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
-{
-	struct dvb_desc_service_location *service_location = (struct dvb_desc_service_location *) desc;
-	const uint8_t *endbuf = buf + desc->length;
-	ssize_t size = sizeof(struct dvb_desc_service_location) - sizeof(struct dvb_desc);
-	struct dvb_desc_service_location_element *element;
-	int i;
-
-	if (buf + size > endbuf) {
-		dvb_logerr("%s: short read %zd/%zd bytes", __FUNCTION__, endbuf - buf, size);
-		return -1;
-	}
-
-	memcpy(desc->data, buf, size);
-	bswap16(service_location->bitfield);
-	buf += size;
-
-	if (service_location->elements == 0)
-		return 0;
-
-	size = service_location->elements * sizeof(struct dvb_desc_service_location_element);
-	if (buf + size > endbuf) {
-		dvb_logerr("%s: short read %zd/%zd bytes", __FUNCTION__, endbuf - buf, size);
-		return -2;
-	}
-	service_location->element = malloc(size);
-	element = service_location->element;
-	for (i = 0; i < service_location->elements; i++) {
-		memcpy(element, buf, sizeof(struct dvb_desc_service_location_element) - 1); /* no \0 in lang */
-		buf += sizeof(struct dvb_desc_service_location_element) - 1;
-		element->language[3] = '\0';
-		bswap16(element->bitfield);
-		element++;
-	}
-	return 0;
-}
-
-void dvb_desc_service_location_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
-{
-	const struct dvb_desc_service_location *service_location = (const struct dvb_desc_service_location *) desc;
-	struct dvb_desc_service_location_element *element = service_location->element;
-	int i;
-
-	dvb_loginfo("|    pcr pid      %d", service_location->pcr_pid);
-	dvb_loginfo("|    streams:");
-	for (i = 0; i < service_location->elements; i++)
-		dvb_loginfo("|      pid %d, type %d: %s", element[i].elementary_pid, element[i].stream_type, element[i].language);
-	dvb_loginfo("| 	%d elements", service_location->elements);
-}
-
-void dvb_desc_service_location_free(struct dvb_desc *desc)
-{
-	const struct dvb_desc_service_location *service_location = (const struct dvb_desc_service_location *) desc;
-
-	free(service_location->element);
-}
-- 
2.1.0

