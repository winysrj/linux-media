Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:41933 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaADRIn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jan 2014 12:08:43 -0500
Received: by mail-ea0-f178.google.com with SMTP id d10so7359489eaj.9
        for <linux-media@vger.kernel.org>; Sat, 04 Jan 2014 09:08:42 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 04/11] libdvbv5: add parser for ca and ca_identifier descriptors
Date: Sat,  4 Jan 2014 18:07:54 +0100
Message-Id: <1388855282-19295-4-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388855282-19295-1-git-send-email-neolynx@gmail.com>
References: <1388855282-19295-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/libdvbv5/desc_ca.h                |   63 ++++++++++++++++++++++++
 lib/include/libdvbv5/desc_ca_identifier.h     |   55 +++++++++++++++++++++
 lib/libdvbv5/Makefile.am                      |   10 ++--
 lib/libdvbv5/descriptors.c                    |   18 +++----
 lib/libdvbv5/descriptors/desc_ca.c            |   64 +++++++++++++++++++++++++
 lib/libdvbv5/descriptors/desc_ca_identifier.c |   58 ++++++++++++++++++++++
 6 files changed, 257 insertions(+), 11 deletions(-)
 create mode 100644 lib/include/libdvbv5/desc_ca.h
 create mode 100644 lib/include/libdvbv5/desc_ca_identifier.h
 create mode 100644 lib/libdvbv5/descriptors/desc_ca.c
 create mode 100644 lib/libdvbv5/descriptors/desc_ca_identifier.c

diff --git a/lib/include/libdvbv5/desc_ca.h b/lib/include/libdvbv5/desc_ca.h
new file mode 100644
index 0000000..12f4ff3
--- /dev/null
+++ b/lib/include/libdvbv5/desc_ca.h
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
+ * Described at ETSI EN 300 468 V1.11.1 (2010-04)
+ */
+
+#ifndef _CA_H
+#define _CA_H
+
+#include <stdint.h>
+#include <unistd.h> /* ssize_t */
+
+struct dvb_desc_ca {
+	uint8_t type;
+	uint8_t length;
+	struct dvb_desc *next;
+
+	uint16_t ca_id;
+	union {
+		uint16_t bitfield1;
+		struct {
+			uint16_t ca_pid:13;
+			uint16_t reserved:3;
+		} __attribute__((packed));
+	} __attribute__((packed));
+
+	uint8_t *privdata;
+	uint8_t privdata_len;
+} __attribute__((packed));
+
+struct dvb_v5_fe_parms;
+
+#define dvb_desc_ca_field_first ca_id
+#define dvb_desc_ca_field_last  privdata
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+void dvb_desc_ca_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+void dvb_desc_ca_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+void dvb_desc_ca_free (struct dvb_desc *desc);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/include/libdvbv5/desc_ca_identifier.h b/lib/include/libdvbv5/desc_ca_identifier.h
new file mode 100644
index 0000000..18df191
--- /dev/null
+++ b/lib/include/libdvbv5/desc_ca_identifier.h
@@ -0,0 +1,55 @@
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
+ * Described at ETSI EN 300 468 V1.11.1 (2010-04)
+ */
+
+#ifndef _CA_IDENTIFIER_H
+#define _CA_IDENTIFIER_H
+
+#include <stdint.h>
+#include <unistd.h> /* ssize_t */
+
+struct dvb_desc_ca_identifier {
+	uint8_t type;
+	uint8_t length;
+	struct dvb_desc *next;
+
+	uint8_t caid_count;
+	uint16_t *caids;
+
+} __attribute__((packed));
+
+struct dvb_v5_fe_parms;
+
+#define dvb_desc_ca_identifier_field_first ca_id
+#define dvb_desc_ca_identifier_field_last  privdata
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+void dvb_desc_ca_identifier_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+void dvb_desc_ca_identifier_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+void dvb_desc_ca_identifier_free (struct dvb_desc *desc);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
index 0abe42d..667a1af 100644
--- a/lib/libdvbv5/Makefile.am
+++ b/lib/libdvbv5/Makefile.am
@@ -33,6 +33,9 @@ otherinclude_HEADERS = \
 	../include/libdvbv5/desc_logical_channel.h \
 	../include/libdvbv5/desc_ts_info.h \
 	../include/libdvbv5/desc_partial_reception.h \
+	../include/libdvbv5/desc_service_location.h \
+	../include/libdvbv5/desc_ca.h \
+	../include/libdvbv5/desc_ca_identifier.h \
 	../include/libdvbv5/nit.h \
 	../include/libdvbv5/sdt.h \
 	../include/libdvbv5/vct.h \
@@ -41,7 +44,6 @@ otherinclude_HEADERS = \
 	../include/libdvbv5/eit.h \
 	../include/libdvbv5/cat.h \
 	../include/libdvbv5/atsc_eit.h \
-	../include/libdvbv5/desc_service_location.h \
 	../include/libdvbv5/mpeg_ts.h \
 	../include/libdvbv5/mpeg_pes.h \
 	../include/libdvbv5/mpeg_es.h
@@ -96,8 +98,10 @@ libdvbv5_la_SOURCES = \
 	descriptors/desc_ts_info.c		\
 	descriptors/desc_partial_reception.c	\
 	descriptors/desc_service_location.c	\
-	descriptors/mpeg_ts.c		\
-	descriptors/mpeg_pes.c		\
+	descriptors/desc_ca.c			\
+	descriptors/desc_ca_identifier.c	\
+	descriptors/mpeg_ts.c			\
+	descriptors/mpeg_pes.c			\
 	descriptors/mpeg_es.c
 
 libdvbv5_la_CPPFLAGS = -I../.. $(ENFORCE_LIBDVBV5_STATIC)
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index e888123..93239e6 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -55,6 +55,8 @@
 #include <libdvbv5/desc_ts_info.h>
 #include <libdvbv5/desc_logical_channel.h>
 #include <libdvbv5/desc_partial_reception.h>
+#include <libdvbv5/desc_ca.h>
+#include <libdvbv5/desc_ca_identifier.h>
 #include <libdvbv5/desc_extension.h>
 
 static void dvb_desc_init(uint8_t type, uint8_t length, struct dvb_desc *desc)
@@ -243,10 +245,10 @@ const struct dvb_descriptor dvb_descriptors[] = {
 	},
 	[conditional_access_descriptor] = {
 		.name  = "conditional_access_descriptor",
-		.init  = NULL,
-		.print = NULL,
-		.free  = NULL,
-		.size  = 0,
+		.init  = dvb_desc_ca_init,
+		.print = dvb_desc_ca_print,
+		.free  = dvb_desc_ca_free,
+		.size  = sizeof(struct dvb_desc_ca),
 	},
 	[iso639_language_descriptor] = {
 		.name  = "iso639_language_descriptor",
@@ -572,10 +574,10 @@ const struct dvb_descriptor dvb_descriptors[] = {
 	},
 	[CA_identifier_descriptor] = {
 		.name  = "CA_identifier_descriptor",
-		.init  = NULL,
-		.print = NULL,
-		.free  = NULL,
-		.size  = 0,
+		.init  = dvb_desc_ca_identifier_init,
+		.print = dvb_desc_ca_identifier_print,
+		.free  = dvb_desc_ca_identifier_free,
+		.size  = sizeof(struct dvb_desc_ca_identifier),
 	},
 	[content_descriptor] = {
 		.name  = "content_descriptor",
diff --git a/lib/libdvbv5/descriptors/desc_ca.c b/lib/libdvbv5/descriptors/desc_ca.c
new file mode 100644
index 0000000..6b48175
--- /dev/null
+++ b/lib/libdvbv5/descriptors/desc_ca.c
@@ -0,0 +1,64 @@
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
+ * Described at ETSI EN 300 468 V1.11.1 (2010-04)
+ */
+
+#include <libdvbv5/desc_ca.h>
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/dvb-fe.h>
+
+void dvb_desc_ca_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+{
+	size_t size = offsetof(struct dvb_desc_ca, dvb_desc_ca_field_last) - offsetof(struct dvb_desc_ca, dvb_desc_ca_field_first);
+	struct dvb_desc_ca *d = (struct dvb_desc_ca *) desc;
+
+	memcpy(((uint8_t *) d ) + sizeof(struct dvb_desc), buf, size);
+	bswap16(d->ca_id);
+	bswap16(d->bitfield1);
+
+	if (d->length > size) {
+		size = d->length - size;
+		d->privdata = malloc(size);
+		d->privdata_len = size;
+		memcpy(d->privdata, buf + 4, size);
+	} else {
+		d->privdata = NULL;
+		d->privdata_len = 0;
+	}
+	/*hexdump(parms, "desc ca ", buf, desc->length);*/
+	/*dvb_desc_ca_print(parms, desc);*/
+}
+
+void dvb_desc_ca_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
+{
+	const struct dvb_desc_ca *d = (const struct dvb_desc_ca *) desc;
+	dvb_log("|           ca_id             %04x", d->ca_id);
+	dvb_log("|           ca_pid            %04x", d->ca_pid);
+	dvb_log("|           privdata length   %d", d->privdata_len);
+	if (d->privdata)
+		hexdump(parms, "|           privdata          ", d->privdata, d->privdata_len);
+}
+
+void dvb_desc_ca_free(struct dvb_desc *desc)
+{
+	struct dvb_desc_ca *d = (struct dvb_desc_ca *) desc;
+	if (d->privdata)
+		free(d->privdata);
+}
+
diff --git a/lib/libdvbv5/descriptors/desc_ca_identifier.c b/lib/libdvbv5/descriptors/desc_ca_identifier.c
new file mode 100644
index 0000000..4740a01
--- /dev/null
+++ b/lib/libdvbv5/descriptors/desc_ca_identifier.c
@@ -0,0 +1,58 @@
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
+ * Described at ETSI EN 300 468 V1.11.1 (2010-04)
+ */
+
+#include <libdvbv5/desc_ca_identifier.h>
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/dvb-fe.h>
+
+void dvb_desc_ca_identifier_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+{
+	struct dvb_desc_ca_identifier *d = (struct dvb_desc_ca_identifier *) desc;
+	int i;
+
+	d->caid_count = d->length >> 1; /* FIXME: warn if odd */
+	d->caids = malloc(d->length);
+	if (!d->caids) {
+		dvb_logerr("dvb_desc_ca_identifier_init: out of memory");
+		return;
+	}
+	for (i = 0; i < d->caid_count; i++) {
+		d->caids[i] = ((uint16_t *) buf)[i];
+		bswap16(d->caids[i]);
+	}
+}
+
+void dvb_desc_ca_identifier_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
+{
+	const struct dvb_desc_ca_identifier *d = (const struct dvb_desc_ca_identifier *) desc;
+	int i;
+
+	for (i = 0; i < d->caid_count; i++)
+		dvb_log("|           caid %d            %04x", i, d->caids[i]);
+}
+
+void dvb_desc_ca_identifier_free(struct dvb_desc *desc)
+{
+	struct dvb_desc_ca_identifier *d = (struct dvb_desc_ca_identifier *) desc;
+	if (d->caids)
+		free(d->caids);
+}
+
-- 
1.7.10.4

