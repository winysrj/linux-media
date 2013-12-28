Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:43717 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab3L1PqV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 10:46:21 -0500
Received: by mail-ea0-f180.google.com with SMTP id f15so4450870eak.11
        for <linux-media@vger.kernel.org>; Sat, 28 Dec 2013 07:46:18 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 02/13] libdvbv5: ATSC VCT table support
Date: Sat, 28 Dec 2013 16:45:50 +0100
Message-Id: <1388245561-8751-2-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388245561-8751-1-git-send-email-neolynx@gmail.com>
References: <1388245561-8751-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/descriptors.h                        |  4 +-
 lib/include/descriptors/desc_service_location.h  | 70 +++++++++++++++++++++++
 lib/include/descriptors/vct.h                    |  5 +-
 lib/libdvbv5/Makefile.am                         |  3 +-
 lib/libdvbv5/descriptors.c                       |  2 +-
 lib/libdvbv5/descriptors/desc_service_location.c | 71 ++++++++++++++++++++++++
 lib/libdvbv5/descriptors/vct.c                   |  1 +
 lib/libdvbv5/dvb-scan.c                          | 12 +++-
 8 files changed, 162 insertions(+), 6 deletions(-)
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
index 0000000..2e11cff
--- /dev/null
+++ b/lib/include/descriptors/desc_service_location.h
@@ -0,0 +1,70 @@
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
diff --git a/lib/include/descriptors/vct.h b/lib/include/descriptors/vct.h
index 6272b43..505a407 100644
--- a/lib/include/descriptors/vct.h
+++ b/lib/include/descriptors/vct.h
@@ -1,5 +1,6 @@
 /*
- * Copyright (c) 2013 - Mauro Carvalho Chehab <m.chehab@samsung.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -35,7 +36,7 @@ struct dvb_table_vct_channel {
 	uint16_t	__short_name[7];
 
 	union {
-		uint16_t bitfield1;
+		uint32_t bitfield;
 		struct {
 			uint32_t	modulation_mode:8;
 			uint32_t	minor_channel_number:10;
diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
index 2ad5902..400af39 100644
--- a/lib/libdvbv5/Makefile.am
+++ b/lib/libdvbv5/Makefile.am
@@ -48,7 +48,8 @@ libdvbv5_la_SOURCES = \
   descriptors/nit.c  ../include/descriptors/nit.h \
   descriptors/sdt.c  ../include/descriptors/sdt.h \
   descriptors/vct.c  ../include/descriptors/vct.h \
-  descriptors/eit.c  ../include/descriptors/eit.h
+  descriptors/vct.c  ../include/descriptors/vct.h \
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
index 0000000..94c34fa
--- /dev/null
+++ b/lib/libdvbv5/descriptors/desc_service_location.c
@@ -0,0 +1,71 @@
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
diff --git a/lib/libdvbv5/descriptors/vct.c b/lib/libdvbv5/descriptors/vct.c
index e703c52..e567f7a 100644
--- a/lib/libdvbv5/descriptors/vct.c
+++ b/lib/libdvbv5/descriptors/vct.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2013 - Mauro Carvalho Chehab <m.chehab@samsung.com>
+ * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index af3a052..76712d4 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -185,6 +185,15 @@ int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd,
 
 		h = (struct dvb_table_header *)buf;
 		dvb_table_header_init(h);
+
+		/* dvb_logdbg( "dvb_read_section: id %d, section %d/%d, current: %d", h->id, h->section_id, h->last_section, h->current_next ); */
+		if (start_id == h->id && start_section == h->section_id) {
+			dvb_logdbg( "dvb_read_section: section repeated, reading done" );
+			break;
+		}
+		if (start_id == -1) start_id = h->id;
+		if (start_section == -1) start_section = h->section_id;
+
 		if (id != -1 && h->id != id) { /* search for a specific table id */
 			continue;
 		}
@@ -232,7 +241,8 @@ int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd,
 		else
 			dvb_logerr("dvb_read_section: no initializer for table %d", tid);
 
-		if (++sections == last_section + 1)
+		if (id != -1 && ++sections == last_section + 1) {
+			dvb_logerr("dvb_read_section: ++sections == last_section + 1");
 			break;
 	}
 	free(buf);
-- 
1.8.3.2

