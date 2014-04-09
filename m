Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:54114 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934113AbaDIW1Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 18:27:25 -0400
Received: by mail-ee0-f51.google.com with SMTP id c13so2412665eek.10
        for <linux-media@vger.kernel.org>; Wed, 09 Apr 2014 15:27:23 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 5/7] libdvbv5: cleanup table parsers
Date: Thu, 10 Apr 2014 00:26:58 +0200
Message-Id: <1397082420-31198-5-git-send-email-neolynx@gmail.com>
In-Reply-To: <1397082420-31198-1-git-send-email-neolynx@gmail.com>
References: <1397082420-31198-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- make the code look similar
- check for correct table ID
- ignore null packets with ID 0x1fff
- return table length, or:
- return error code on error
- update / fix Copyrights

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/libdvbv5/atsc_eit.h     |    1 -
 lib/include/libdvbv5/descriptors.h  |    1 +
 lib/include/libdvbv5/eit.h          |    3 +-
 lib/include/libdvbv5/mgt.h          |    1 -
 lib/include/libdvbv5/nit.h          |    2 +-
 lib/include/libdvbv5/pat.h          |    4 +-
 lib/include/libdvbv5/sdt.h          |    5 +-
 lib/include/libdvbv5/vct.h          |    1 -
 lib/libdvbv5/descriptors.c          |    9 +++-
 lib/libdvbv5/descriptors/atsc_eit.c |   35 +++++++------
 lib/libdvbv5/descriptors/cat.c      |   53 +++++++++++++------
 lib/libdvbv5/descriptors/eit.c      |   90 +++++++++++++++++++++------------
 lib/libdvbv5/descriptors/mgt.c      |   43 +++++++++-------
 lib/libdvbv5/descriptors/nit.c      |   71 ++++++++++++++------------
 lib/libdvbv5/descriptors/pat.c      |   73 ++++++++++++++++-----------
 lib/libdvbv5/descriptors/pmt.c      |   95 ++++++++++++++++++++++-------------
 lib/libdvbv5/descriptors/sdt.c      |   68 ++++++++++++++++++-------
 lib/libdvbv5/descriptors/vct.c      |   35 +++++++++----
 18 files changed, 374 insertions(+), 216 deletions(-)

diff --git a/lib/include/libdvbv5/atsc_eit.h b/lib/include/libdvbv5/atsc_eit.h
index 8b093de..93d9304 100644
--- a/lib/include/libdvbv5/atsc_eit.h
+++ b/lib/include/libdvbv5/atsc_eit.h
@@ -26,7 +26,6 @@
 #include <time.h>
 
 #include <libdvbv5/atsc_header.h>
-#include <libdvbv5/descriptors.h>
 
 #define ATSC_TABLE_EIT        0xCB
 
diff --git a/lib/include/libdvbv5/descriptors.h b/lib/include/libdvbv5/descriptors.h
index e81a05d..d08ab3e 100644
--- a/lib/include/libdvbv5/descriptors.h
+++ b/lib/include/libdvbv5/descriptors.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2011-2012 - Mauro Carvalho Chehab
+ * Copyright (c) 2012-2014 - Andre Roth <neolynx@gmail.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
diff --git a/lib/include/libdvbv5/eit.h b/lib/include/libdvbv5/eit.h
index fb5ce33..c959537 100644
--- a/lib/include/libdvbv5/eit.h
+++ b/lib/include/libdvbv5/eit.h
@@ -27,7 +27,6 @@
 #include <time.h>
 
 #include <libdvbv5/header.h>
-#include <libdvbv5/descriptors.h>
 
 #define DVB_TABLE_EIT        0x4E
 #define DVB_TABLE_EIT_OTHER  0x4F
@@ -47,7 +46,7 @@ struct dvb_table_eit_event {
 	union {
 		uint16_t bitfield2;
 		struct {
-			uint16_t section_length:12;
+			uint16_t desc_length:12;
 			uint16_t free_CA_mode:1;
 			uint16_t running_status:3;
 		} __attribute__((packed));
diff --git a/lib/include/libdvbv5/mgt.h b/lib/include/libdvbv5/mgt.h
index cb8d63a..d67ad33 100644
--- a/lib/include/libdvbv5/mgt.h
+++ b/lib/include/libdvbv5/mgt.h
@@ -25,7 +25,6 @@
 #include <unistd.h> /* ssize_t */
 
 #include <libdvbv5/atsc_header.h>
-#include <libdvbv5/descriptors.h>
 
 #define ATSC_TABLE_MGT 0xC7
 
diff --git a/lib/include/libdvbv5/nit.h b/lib/include/libdvbv5/nit.h
index 7477bd6..fdea7a7 100644
--- a/lib/include/libdvbv5/nit.h
+++ b/lib/include/libdvbv5/nit.h
@@ -46,7 +46,7 @@ struct dvb_table_nit_transport {
 	union {
 		uint16_t bitfield;
 		struct {
-			uint16_t section_length:12;
+			uint16_t desc_length:12;
 			uint16_t reserved:4;
 		} __attribute__((packed));
 	} __attribute__((packed));
diff --git a/lib/include/libdvbv5/pat.h b/lib/include/libdvbv5/pat.h
index cd99d3e..eb4aeef 100644
--- a/lib/include/libdvbv5/pat.h
+++ b/lib/include/libdvbv5/pat.h
@@ -27,8 +27,8 @@
 
 #include <libdvbv5/header.h>
 
-#define DVB_TABLE_PAT      0
-#define DVB_TABLE_PAT_PID  0
+#define DVB_TABLE_PAT      0x00
+#define DVB_TABLE_PAT_PID  0x0000
 
 struct dvb_table_pat_program {
 	uint16_t service_id;
diff --git a/lib/include/libdvbv5/sdt.h b/lib/include/libdvbv5/sdt.h
index f1503ea..9684fbc 100644
--- a/lib/include/libdvbv5/sdt.h
+++ b/lib/include/libdvbv5/sdt.h
@@ -26,11 +26,10 @@
 #include <unistd.h> /* ssize_t */
 
 #include <libdvbv5/header.h>
-#include <libdvbv5/descriptors.h>
 
 #define DVB_TABLE_SDT      0x42
 #define DVB_TABLE_SDT2     0x46
-#define DVB_TABLE_SDT_PID  0x11
+#define DVB_TABLE_SDT_PID  0x0011
 
 struct dvb_table_sdt_service {
 	uint16_t service_id;
@@ -40,7 +39,7 @@ struct dvb_table_sdt_service {
 	union {
 		uint16_t bitfield;
 		struct {
-			uint16_t section_length:12;
+			uint16_t desc_length:12;
 			uint16_t free_CA_mode:1;
 			uint16_t running_status:3;
 		} __attribute__((packed));
diff --git a/lib/include/libdvbv5/vct.h b/lib/include/libdvbv5/vct.h
index 83bad06..10ac301 100644
--- a/lib/include/libdvbv5/vct.h
+++ b/lib/include/libdvbv5/vct.h
@@ -26,7 +26,6 @@
 #include <unistd.h> /* ssize_t */
 
 #include <libdvbv5/atsc_header.h>
-#include <libdvbv5/descriptors.h>
 
 #define ATSC_TABLE_TVCT     0xc8
 #define ATSC_TABLE_CVCT     0xc9
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index 6fd8691..54ce933 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -112,11 +112,16 @@ int dvb_parse_descriptors(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		uint8_t desc_len  = ptr[1];
 		size_t size;
 
+		if (desc_type == 0xff ) {
+			dvb_logwarn("%s: stopping at invalid descriptor 0xff", __func__);
+			return 0;
+		}
+
 		ptr += 2; /* skip type and length */
 
 		if (ptr + desc_len > endbuf) {
-			dvb_logerr("short read of %zd/%d bytes parsing descriptor %#02x",
-				   endbuf - ptr, desc_len, desc_type);
+			dvb_logerr("%s: short read of %zd/%d bytes parsing descriptor %#02x",
+				   __func__, endbuf - ptr, desc_len, desc_type);
 			return -1;
 		}
 
diff --git a/lib/libdvbv5/descriptors/atsc_eit.c b/lib/libdvbv5/descriptors/atsc_eit.c
index 286748c..2b446bb 100644
--- a/lib/libdvbv5/descriptors/atsc_eit.c
+++ b/lib/libdvbv5/descriptors/atsc_eit.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
+ * Copyright (c) 2013-2014 - Andre Roth <neolynx@gmail.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -19,6 +19,7 @@
  */
 
 #include <libdvbv5/atsc_eit.h>
+#include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 
 ssize_t atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
@@ -26,16 +27,22 @@ ssize_t atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 {
 	const uint8_t *p = buf, *endbuf = buf + buflen - 4; /* minus CRC */;
 	struct atsc_table_eit_event **head;
+	size_t size;
 	int i = 0;
-	struct atsc_table_eit_event *last = NULL;
-	size_t size = offsetof(struct atsc_table_eit, event);
 
+	size = offsetof(struct atsc_table_eit, event);
 	if (p + size > endbuf) {
 		dvb_logerr("%s: short read %zd/%zd bytes", __func__,
-			   size, endbuf - p);
+			   endbuf - p, size);
 		return -1;
 	}
 
+	if (buf[0] != ATSC_TABLE_EIT) {
+		dvb_logerr("%s: invalid marker 0x%02x, sould be 0x%02x",
+				__func__, buf[0], ATSC_TABLE_EIT);
+		return -2;
+	}
+
 	if (*table_length > 0) {
 		memcpy(eit, p, size);
 
@@ -45,7 +52,6 @@ ssize_t atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			head = &(*head)->next;
 	} else {
 		memcpy(eit, p, size);
-		*table_length = sizeof(struct atsc_table_eit);
 
 		eit->event = NULL;
 		head = &eit->event;
@@ -59,10 +65,14 @@ ssize_t atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		size = offsetof(struct atsc_table_eit_event, descriptor);
 		if (p + size > endbuf) {
 			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
-				   size, endbuf - p);
+				   endbuf - p, size);
 			return -2;
 		}
 		event = (struct atsc_table_eit_event *) malloc(sizeof(struct atsc_table_eit_event));
+		if (!event) {
+			dvb_logerr("%s: out of memory", __func__);
+			return -3;
+		}
 		memcpy(event, p, size);
 		p += size;
 
@@ -74,15 +84,13 @@ ssize_t atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
                 atsc_time(event->start_time, &event->start);
 		event->source_id = eit->header.id;
 
-		if(!*head)
-			*head = event;
-		if(last)
-			last->next = event;
+		*head = event;
+		head = &(*head)->next;
 
 		size = event->title_length - 1;
 		if (p + size > endbuf) {
 			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
-				   size, endbuf - p);
+				   endbuf - p, size);
 			return -3;
 		}
                 /* TODO: parse title */
@@ -92,7 +100,7 @@ ssize_t atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		size = sizeof(union atsc_table_eit_desc_length);
 		if (p + size > endbuf) {
 			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
-				   size, endbuf - p);
+				   endbuf - p, size);
 			return -4;
 		}
 		memcpy(&dl, p, size);
@@ -102,13 +110,12 @@ ssize_t atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		size = dl.desc_length;
 		if (p + size > endbuf) {
 			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
-				   size, endbuf - p);
+				   endbuf - p, size);
 			return -5;
 		}
 		dvb_parse_descriptors(parms, p, size, &event->descriptor);
 
 		p += size;
-		last = event;
 	}
 
 	*table_length = p - buf;
diff --git a/lib/libdvbv5/descriptors/cat.c b/lib/libdvbv5/descriptors/cat.c
index b7e51e2..04b9416 100644
--- a/lib/libdvbv5/descriptors/cat.c
+++ b/lib/libdvbv5/descriptors/cat.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
+ * Copyright (c) 2013-2014 - Andre Roth <neolynx@gmail.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -23,37 +23,58 @@
 #include <libdvbv5/dvb-fe.h>
 
 ssize_t dvb_table_cat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
-			ssize_t buflen, struct dvb_table_cat *cat, ssize_t *table_length)
+		ssize_t buflen, struct dvb_table_cat *cat, ssize_t *table_length)
 {
-	struct dvb_desc **head_desc = &cat->descriptor;
 	const uint8_t *p = buf, *endbuf = buf + buflen - 4;
+	struct dvb_desc **head_desc;
 	size_t size;
 
-	if (buf[0] != DVB_TABLE_CAT) {
-		dvb_logerr("%s: invalid marker 0x%02x, sould be 0x%02x", __func__, buf[0], DVB_TABLE_CAT);
-		*table_length = 0;
+	size = offsetof(struct dvb_table_cat, descriptor);
+	if (p + size > endbuf) {
+		dvb_logerr("%s: short read %zd/%zd bytes", __func__,
+			   endbuf - p, size);
 		return -1;
 	}
 
+	if (buf[0] != DVB_TABLE_CAT) {
+		dvb_logerr("%s: invalid marker 0x%02x, sould be 0x%02x",
+				__func__, buf[0], DVB_TABLE_CAT);
+		return -2;
+	}
+
 	if (*table_length > 0) {
 		/* find end of current lists */
+		head_desc = &cat->descriptor;
 		while (*head_desc != NULL)
 			head_desc = &(*head_desc)->next;
-	}
-
-	size = offsetof(struct dvb_table_cat, descriptor);
-	if (p + size > endbuf) {
-		dvb_logerr("CAT table was truncated while filling dvb_table_cat. Need %zu bytes, but has only %zu.",
-			   size, buflen);
-		return -2;
+	} else {
+		head_desc = &cat->descriptor;
 	}
 
 	memcpy(cat, p, size);
 	p += size;
-	*table_length = sizeof(struct dvb_table_cat);
 
-	size = endbuf - p;
-	dvb_parse_descriptors(parms, p, size, head_desc);
+	size = cat->header.section_length + 3 - 4; /* plus header, minus CRC */
+	if (buf + size > endbuf) {
+		dvb_logerr("%s: short read %zd/%zd bytes", __func__,
+			   endbuf - buf, size);
+		return -3;
+	}
+	endbuf = buf + size;
+
+	/* parse the descriptors */
+	if (endbuf > p) {
+		uint16_t desc_length = endbuf - p;
+		if (dvb_parse_descriptors(parms, p, desc_length,
+				      head_desc) != 0) {
+			return -4;
+		}
+		p += desc_length;
+	}
+
+	if (endbuf - p)
+		dvb_logwarn("%s: %zu spurious bytes at the end",
+			   __func__, endbuf - p);
 
 	*table_length = p - buf;
 	return p - buf;
diff --git a/lib/libdvbv5/descriptors/eit.c b/lib/libdvbv5/descriptors/eit.c
index 86e2905..5197491 100644
--- a/lib/libdvbv5/descriptors/eit.c
+++ b/lib/libdvbv5/descriptors/eit.c
@@ -1,6 +1,5 @@
 /*
- * Copyright (c) 2011-2012 - Mauro Carvalho Chehab
- * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ * Copyright (c) 2012-2014 - Andre Roth <neolynx@gmail.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -20,12 +19,32 @@
  */
 
 #include <libdvbv5/eit.h>
+#include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 
-ssize_t dvb_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, struct dvb_table_eit *eit, ssize_t *table_length)
+ssize_t dvb_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
+		ssize_t buflen, struct dvb_table_eit *eit, ssize_t *table_length)
 {
-	const uint8_t *p = buf;
+	const uint8_t *p = buf, *endbuf = buf + buflen - 4; /* minus CRC */
 	struct dvb_table_eit_event **head;
+	size_t size;
+
+	size = offsetof(struct dvb_table_eit, event);
+	if (p + size > endbuf) {
+		dvb_logerr("%s: short read %zd/%zd bytes", __func__,
+			   endbuf - p, size);
+		return -1;
+	}
+
+	if ((buf[0] != DVB_TABLE_EIT && buf[0] != DVB_TABLE_EIT_OTHER) &&
+		!(buf[0] >= DVB_TABLE_EIT_SCHEDULE && buf[0] <= DVB_TABLE_EIT_SCHEDULE + 0xF) &&
+		!(buf[0] >= DVB_TABLE_EIT_SCHEDULE_OTHER && buf[0] <= DVB_TABLE_EIT_SCHEDULE_OTHER + 0xF)) {
+		dvb_logerr("%s: invalid marker 0x%02x, sould be 0x%02x, 0x%02x or between 0x%02x and 0x%02x or 0x%02x and 0x%02x",
+				__func__, buf[0], DVB_TABLE_EIT, DVB_TABLE_EIT_OTHER,
+				DVB_TABLE_EIT_SCHEDULE, DVB_TABLE_EIT_SCHEDULE + 0xF,
+				DVB_TABLE_EIT_SCHEDULE_OTHER, DVB_TABLE_EIT_SCHEDULE_OTHER + 0xF);
+		return -2;
+	}
 
 	if (*table_length > 0) {
 		memcpy(eit, p, sizeof(struct dvb_table_eit) - sizeof(eit->event));
@@ -39,7 +58,6 @@ ssize_t dvb_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ss
 			head = &(*head)->next;
 	} else {
 		memcpy(eit, p, sizeof(struct dvb_table_eit) - sizeof(eit->event));
-		*table_length = sizeof(struct dvb_table_eit);
 
 		bswap16(eit->transport_id);
 		bswap16(eit->network_id);
@@ -47,23 +65,20 @@ ssize_t dvb_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ss
 		eit->event = NULL;
 		head = &eit->event;
 	}
-	p += sizeof(struct dvb_table_eit) - sizeof(eit->event);
-
-	struct dvb_table_eit_event *last = NULL;
-	while ((uint8_t *) p < buf + buflen - 4) {
-		struct dvb_table_eit_event *event = (struct dvb_table_eit_event *) malloc(sizeof(struct dvb_table_eit_event));
-		memcpy(event, p, sizeof(struct dvb_table_eit_event) -
-				 sizeof(event->descriptor) -
-				 sizeof(event->next) -
-				 sizeof(event->start) -
-				 sizeof(event->duration) -
-				 sizeof(event->service_id));
-		p += sizeof(struct dvb_table_eit_event) -
-		     sizeof(event->descriptor) -
-		     sizeof(event->next) -
-		     sizeof(event->start) -
-		     sizeof(event->duration) -
-		     sizeof(event->service_id);
+	p += size;
+
+	/* get the event entries */
+	size = offsetof(struct dvb_table_eit_event, descriptor);
+	while (p + size <= endbuf) {
+		struct dvb_table_eit_event *event;
+
+		event = malloc(sizeof(struct dvb_table_eit_event));
+		if (!event) {
+			dvb_logerr("%s: out of memory", __func__);
+			return -3;
+		}
+		memcpy(event, p, size);
+		p += size;
 
 		bswap16(event->event_id);
 		bswap16(event->bitfield1);
@@ -77,18 +92,27 @@ ssize_t dvb_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ss
 
 		event->service_id = eit->header.id;
 
-		if(!*head)
-			*head = event;
-		if(last)
-			last->next = event;
-
-		/* get the descriptors for each program */
-		struct dvb_desc **head_desc = &event->descriptor;
-		dvb_parse_descriptors(parms, p, event->section_length, head_desc);
-
-		p += event->section_length;
-		last = event;
+		*head = event;
+		head = &(*head)->next;
+
+		/* parse the descriptors */
+		if (event->desc_length > 0) {
+			uint16_t desc_length = event->desc_length;
+			if (p + desc_length > endbuf) {
+				dvb_logwarn("%s: decsriptors short read %zd/%d bytes", __func__,
+					   endbuf - p, desc_length);
+				desc_length = endbuf - p;
+			}
+			if (dvb_parse_descriptors(parms, p, desc_length,
+					      &event->descriptor) != 0) {
+				return -4;
+			}
+			p += desc_length;
+		}
 	}
+	if (p < endbuf)
+		dvb_logwarn("%s: %zu spurious bytes at the end",
+			   __func__, endbuf - p);
 	*table_length = p - buf;
 	return p - buf;
 }
diff --git a/lib/libdvbv5/descriptors/mgt.c b/lib/libdvbv5/descriptors/mgt.c
index 4d34740..b12d586 100644
--- a/lib/libdvbv5/descriptors/mgt.c
+++ b/lib/libdvbv5/descriptors/mgt.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
+ * Copyright (c) 2013-2014 - Andre Roth <neolynx@gmail.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -19,25 +19,36 @@
  */
 
 #include <libdvbv5/mgt.h>
+#include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 
 ssize_t atsc_table_mgt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		ssize_t buflen, struct atsc_table_mgt *mgt, ssize_t *table_length)
 {
 	const uint8_t *p = buf, *endbuf = buf + buflen - 4; /* minus CRC */
-	struct dvb_desc **head_desc;
 	struct atsc_table_mgt_table **head;
+	struct dvb_desc **head_desc;
+	size_t size;
 	int i = 0;
-	struct atsc_table_mgt_table *last = NULL;
-	size_t size = offsetof(struct atsc_table_mgt, table);
 
+	size = offsetof(struct atsc_table_mgt, table);
 	if (p + size > endbuf) {
 		dvb_logerr("%s: short read %zd/%zd bytes", __func__,
-			   size, endbuf - p);
+			   endbuf - p, size);
 		return -1;
 	}
 
+	if (buf[0] != ATSC_TABLE_MGT) {
+		dvb_logerr("%s: invalid marker 0x%02x, sould be 0x%02x",
+				__func__, buf[0], ATSC_TABLE_MGT);
+		return -2;
+	}
+
 	if (*table_length > 0) {
+		memcpy(mgt, p, size);
+
+		bswap16(mgt->tables);
+
 		/* find end of curent lists */
 		head_desc = &mgt->descriptor;
 		while (*head_desc != NULL)
@@ -45,11 +56,8 @@ ssize_t atsc_table_mgt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		head = &mgt->table;
 		while (*head != NULL)
 			head = &(*head)->next;
-
-		/* FIXME: read current mgt->tables for loop below */
 	} else {
 		memcpy(mgt, p, size);
-		*table_length = sizeof(struct atsc_table_mgt);
 
 		bswap16(mgt->tables);
 
@@ -66,10 +74,14 @@ ssize_t atsc_table_mgt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		size = offsetof(struct atsc_table_mgt_table, descriptor);
 		if (p + size > endbuf) {
 			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
-				   size, endbuf - p);
+				   endbuf - p, size);
 			return -2;
 		}
 		table = (struct atsc_table_mgt_table *) malloc(sizeof(struct atsc_table_mgt_table));
+		if (!table) {
+			dvb_logerr("%s: out of memory", __func__);
+			return -3;
+		}
 		memcpy(table, p, size);
 		p += size;
 
@@ -80,22 +92,19 @@ ssize_t atsc_table_mgt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		table->descriptor = NULL;
 		table->next = NULL;
 
-		if(!*head)
-			*head = table;
-		if(last)
-			last->next = table;
+		*head = table;
+		head = &(*head)->next;
 
 		/* get the descriptors for each table */
 		size = table->desc_length;
 		if (p + size > endbuf) {
 			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
-				   size, endbuf - p);
+				   endbuf - p, size);
 			return -3;
 		}
 		dvb_parse_descriptors(parms, p, size, &table->descriptor);
 
 		p += size;
-		last = table;
 	}
 
 	/* TODO: parse MGT descriptors here into head_desc */
@@ -109,7 +118,7 @@ void atsc_table_mgt_free(struct atsc_table_mgt *mgt)
 	struct atsc_table_mgt_table *table = mgt->table;
 
 	dvb_free_descriptors((struct dvb_desc **) &mgt->descriptor);
-	while(table) {
+	while (table) {
 		struct atsc_table_mgt_table *tmp = table;
 
 		dvb_free_descriptors((struct dvb_desc **) &table->descriptor);
@@ -127,7 +136,7 @@ void atsc_table_mgt_print(struct dvb_v5_fe_parms *parms, struct atsc_table_mgt *
 	dvb_log("MGT");
 	ATSC_TABLE_HEADER_PRINT(parms, mgt);
 	dvb_log("| tables           %d", mgt->tables);
-	while(table) {
+	while (table) {
                 dvb_log("|- type %04x    %d", table->type, table->pid);
                 dvb_log("|  one          %d", table->one);
                 dvb_log("|  one2         %d", table->one2);
diff --git a/lib/libdvbv5/descriptors/nit.c b/lib/libdvbv5/descriptors/nit.c
index 7749ee1..aadebc0 100644
--- a/lib/libdvbv5/descriptors/nit.c
+++ b/lib/libdvbv5/descriptors/nit.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2011-2012 - Mauro Carvalho Chehab
- * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ * Copyright (c) 2012-2014 - Andre Roth <neolynx@gmail.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -26,50 +26,55 @@ ssize_t dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			ssize_t buflen, struct dvb_table_nit *nit, ssize_t *table_length)
 {
 	const uint8_t *p = buf, *endbuf = buf + buflen - 4;
-	struct dvb_desc **head_desc = &nit->descriptor;
-	struct dvb_table_nit_transport **head = &nit->transport;
+	struct dvb_table_nit_transport **head;
+	struct dvb_desc **head_desc;
 	size_t size;
 
+	size = offsetof(struct dvb_table_nit, descriptor);
+	if (p + size > endbuf) {
+		dvb_logerr("%s: short read %zd/%zd bytes", __func__,
+			   endbuf - p, size);
+		return -1;
+	}
+
+	if (buf[0] != DVB_TABLE_NIT) {
+		dvb_logerr("%s: invalid marker 0x%02x, sould be 0x%02x",
+				__func__, buf[0], DVB_TABLE_NIT);
+		return -2;
+	}
+
 	if (*table_length > 0) {
 		struct dvb_table_nit *t;
 
 		/* find end of current lists */
+		head_desc = &nit->descriptor;
 		while (*head_desc != NULL)
 			head_desc = &(*head_desc)->next;
+		head = &nit->transport;
 		while (*head != NULL)
 			head = &(*head)->next;
 
-		size = offsetof(struct dvb_table_nit, descriptor);
-		if (p + size > endbuf) {
-			dvb_logerr("NIT table (cont) was truncated");
-			return -1;
-		}
 		p += size;
 		t = (struct dvb_table_nit *)buf;
 
 		bswap16(t->bitfield);
 		size = t->desc_length;
 	} else {
-		size = offsetof(struct dvb_table_nit, descriptor);
-		if (p + size > endbuf) {
-			dvb_logerr("NIT table was truncated while filling dvb_table_nit. Need %zu bytes, but has only %zu.",
-				   size, buflen);
-			return -2;
-		}
 		memcpy(nit, p, size);
 		p += size;
 
-		*table_length = sizeof(struct dvb_table_nit);
+		head = &nit->transport;
 
 		nit->descriptor = NULL;
 		nit->transport = NULL;
 
 		bswap16(nit->bitfield);
 		size = nit->desc_length;
+		head_desc = &nit->descriptor;
 	}
 	if (p + size > endbuf) {
-		dvb_logerr("NIT table was truncated while getting NIT descriptors. Need %zu bytes, but has only %zu.",
-			   size, endbuf - p);
+		dvb_logerr("%s: short read %zd/%zd bytes", __func__,
+			   endbuf - p, size);
 		return -3;
 	}
 	dvb_parse_descriptors(parms, p, size, head_desc);
@@ -77,8 +82,8 @@ ssize_t dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 
 	size = sizeof(union dvb_table_nit_transport_header);
 	if (p + size > endbuf) {
-		dvb_logerr("NIT table was truncated while getting NIT transports. Need %zu bytes, but has only %zu.",
-			   size, endbuf - p);
+		dvb_logerr("%s: short read %zd/%zd bytes", __func__,
+			   endbuf - p, size);
 		return -4;
 	}
 	p += size;
@@ -89,7 +94,7 @@ ssize_t dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 
 		transport = malloc(sizeof(struct dvb_table_nit_transport));
 		if (!transport) {
-			dvb_perror(__func__);
+			dvb_logerr("%s: out of memory", __func__);
 			return -5;
 		}
 		memcpy(transport, p, size);
@@ -104,20 +109,24 @@ ssize_t dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		*head = transport;
 		head = &(*head)->next;
 
-		/* get the descriptors for each transport */
-		head_desc = &transport->descriptor;
-
-		if (p + transport->section_length > endbuf) {
-			dvb_logerr("NIT table was truncated while getting NIT transport descriptors. Need %u bytes, but has only %zu.",
-				   transport->section_length, endbuf - p);
-			return -6;
+		/* parse the descriptors */
+		if (transport->desc_length > 0) {
+			uint16_t desc_length = transport->desc_length;
+			if (p + desc_length > endbuf) {
+				dvb_logwarn("%s: decsriptors short read %zd/%d bytes", __func__,
+					   endbuf - p, desc_length);
+				desc_length = endbuf - p;
+			}
+			if (dvb_parse_descriptors(parms, p, desc_length,
+					      &transport->descriptor) != 0) {
+				return -6;
+			}
+			p += desc_length;
 		}
-		dvb_parse_descriptors(parms, p, transport->section_length, head_desc);
-		p += transport->section_length;
 	}
 	if (endbuf - p)
-		dvb_logerr("NIT table has %zu spurious bytes at the end.",
-			   endbuf - p);
+		dvb_logwarn("%s: %zu spurious bytes at the end",
+			   __func__, endbuf - p);
 	*table_length = p - buf;
 	return p - buf;
 }
diff --git a/lib/libdvbv5/descriptors/pat.c b/lib/libdvbv5/descriptors/pat.c
index 1bb7781..efa6811 100644
--- a/lib/libdvbv5/descriptors/pat.c
+++ b/lib/libdvbv5/descriptors/pat.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2011-2012 - Mauro Carvalho Chehab
- * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ * Copyright (c) 2012-2014 - Andre Roth <neolynx@gmail.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -26,64 +26,77 @@
 ssize_t dvb_table_pat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			ssize_t buflen, struct dvb_table_pat *pat, ssize_t *table_length)
 {
-	struct dvb_table_pat_program **head = &pat->program;
 	const uint8_t *p = buf, *endbuf = buf + buflen - 4;
+	struct dvb_table_pat_program **head;
 	size_t size;
 
+	size = offsetof(struct dvb_table_pat, programs);
+	if (p + size > endbuf) {
+		dvb_logerr("%s: short read %zd/%zd bytes", __func__,
+			   endbuf - p, size);
+		return -1;
+	}
+
+	if (buf[0] != DVB_TABLE_PAT) {
+		dvb_logerr("%s: invalid marker 0x%02x, sould be 0x%02x",
+				__func__, buf[0], DVB_TABLE_PAT);
+		return -2;
+	}
+
 	if (*table_length > 0) {
 		/* find end of current list */
+		head = &pat->program;
 		while (*head != NULL)
 			head = &(*head)->next;
 	} else {
-		size = offsetof(struct dvb_table_pat, programs);
-		if (p + size > endbuf) {
-			dvb_logerr("PAT table was truncated. Need %zu bytes, but has only %zu.",
-					size, buflen);
-			return -1;
-		}
 		memcpy(pat, buf, size);
 		p += size;
 		pat->programs = 0;
 		pat->program = NULL;
+		head = &pat->program;
 	}
-	*table_length = sizeof(struct dvb_table_pat_program);
 
 	size = offsetof(struct dvb_table_pat_program, next);
 	while (p + size <= endbuf) {
-		struct dvb_table_pat_program *pgm;
+		struct dvb_table_pat_program *prog;
 
-		pgm = malloc(sizeof(struct dvb_table_pat_program));
-		if (!pgm) {
+		prog = malloc(sizeof(struct dvb_table_pat_program));
+		if (!prog) {
 			dvb_perror("Out of memory");
-			return -2;
+			return -3;
 		}
 
-		memcpy(pgm, p, size);
+		memcpy(prog, p, size);
 		p += size;
 
-		bswap16(pgm->service_id);
-		bswap16(pgm->bitfield);
+		bswap16(prog->service_id);
+
+		if (prog->pid == 0x1fff) { /* ignore null packets */
+			free(prog);
+			break;
+		}
+		bswap16(prog->bitfield);
 		pat->programs++;
 
-		pgm->next = NULL;
+		prog->next = NULL;
 
-		*head = pgm;
+		*head = prog;
 		head = &(*head)->next;
 	}
 	if (endbuf - p)
-		dvb_logerr("PAT table has %zu spurious bytes at the end.",
-			   endbuf - p);
+		dvb_logwarn("%s: %zu spurious bytes at the end",
+			   __func__, endbuf - p);
 	*table_length = p - buf;
 	return p - buf;
 }
 
 void dvb_table_pat_free(struct dvb_table_pat *pat)
 {
-	struct dvb_table_pat_program *pgm = pat->program;
+	struct dvb_table_pat_program *prog = pat->program;
 
-	while (pgm) {
-		struct dvb_table_pat_program *tmp = pgm;
-		pgm = pgm->next;
+	while (prog) {
+		struct dvb_table_pat_program *tmp = prog;
+		prog = prog->next;
 		free(tmp);
 	}
 	free(pat);
@@ -91,15 +104,15 @@ void dvb_table_pat_free(struct dvb_table_pat *pat)
 
 void dvb_table_pat_print(struct dvb_v5_fe_parms *parms, struct dvb_table_pat *pat)
 {
-	struct dvb_table_pat_program *pgm = pat->program;
+	struct dvb_table_pat_program *prog = pat->program;
 
-	dvb_log("PAT");
+	dvb_loginfo("PAT");
 	dvb_table_header_print(parms, &pat->header);
-	dvb_log("|\\ %d program%s", pat->programs, pat->programs != 1 ? "s" : "");
+	dvb_loginfo("|\\ %d program pid%s", pat->programs, pat->programs != 1 ? "s" : "");
 
-	while (pgm) {
-		dvb_log("|- program 0x%04x  ->  service 0x%04x", pgm->pid, pgm->service_id);
-		pgm = pgm->next;
+	while (prog) {
+		dvb_loginfo("|  pid 0x%04x: service 0x%04x", prog->pid, prog->service_id);
+		prog = prog->next;
 	}
 }
 
diff --git a/lib/libdvbv5/descriptors/pmt.c b/lib/libdvbv5/descriptors/pmt.c
index 52bfa29..e1f07f8 100644
--- a/lib/libdvbv5/descriptors/pmt.c
+++ b/lib/libdvbv5/descriptors/pmt.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2011-2012 - Mauro Carvalho Chehab
- * Copyright (c) 2012-2013 - Andre Roth <neolynx@gmail.com>
+ * Copyright (c) 2012-2014 - Andre Roth <neolynx@gmail.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -29,46 +29,69 @@ ssize_t dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			ssize_t buflen, struct dvb_table_pmt *pmt, ssize_t *table_length)
 {
 	const uint8_t *p = buf, *endbuf = buf + buflen - 4;
-	struct dvb_table_pmt_stream **head = &pmt->stream;
+	struct dvb_table_pmt_stream **head;
+	struct dvb_desc **head_desc;
 	size_t size;
 
-	if (buf[0] != DVB_TABLE_PMT) {
-		dvb_logerr("%s: invalid marker 0x%02x, sould be 0x%02x", __func__, buf[0], DVB_TABLE_PMT);
-		*table_length = 0;
+	size = offsetof(struct dvb_table_pmt, dvb_pmt_field_last);
+	if (p + size > endbuf) {
+		dvb_logerr("%s: short read %zd/%zd bytes", __func__,
+			   endbuf - p, size);
 		return -1;
 	}
 
+	if (buf[0] != DVB_TABLE_PMT) {
+		dvb_logerr("%s: invalid marker 0x%02x, sould be 0x%02x",
+				__func__, buf[0], DVB_TABLE_PMT);
+		return -2;
+	}
+
 	if (*table_length > 0) {
+		memcpy(pmt, p, size);
+		bswap16(pmt->bitfield);
+		bswap16(pmt->bitfield2);
+
 		/* find end of current list */
+		head = &pmt->stream;
 		while (*head != NULL)
 			head = &(*head)->next;
+		head_desc = &pmt->descriptor;
+		while (*head_desc != NULL)
+			head_desc = &(*head_desc)->next;
 	} else {
-		size = offsetof(struct dvb_table_pmt, dvb_pmt_field_last);
-		if (p + size > endbuf) {
-			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
-				   size, endbuf - p);
-			return -2;
-		}
 		memcpy(pmt, p, size);
-		p += size;
-
 		bswap16(pmt->bitfield);
 		bswap16(pmt->bitfield2);
+
 		pmt->descriptor = NULL;
 		pmt->stream = NULL;
 
-		/* parse the descriptors */
-		if (pmt->desc_length > 0 ) {
-			size = pmt->desc_length;
-			if (p + size > endbuf) {
-				dvb_logwarn("%s: decsriptors short read %zd/%zd bytes", __func__,
-					   size, endbuf - p);
-				size = endbuf - p;
-			}
-			dvb_parse_descriptors(parms, p, size,
-					      &pmt->descriptor);
-			p += size;
+		head = &pmt->stream;
+		head_desc = &pmt->descriptor;
+	}
+	p += size;
+
+	size = pmt->header.section_length + 3 - 4; /* plus header, minus CRC */
+	if (buf + size > endbuf) {
+		dvb_logerr("%s: short read %zd/%zd bytes", __func__,
+			   endbuf - buf, size);
+		return -3;
+	}
+	endbuf = buf + size;
+
+	/* parse the descriptors */
+	if (pmt->desc_length > 0 ) {
+		uint16_t desc_length = pmt->desc_length;
+		if (p + desc_length > endbuf) {
+			dvb_logwarn("%s: decsriptors short read %d/%zd bytes", __func__,
+				   desc_length, endbuf - p);
+			desc_length = endbuf - p;
 		}
+		if (dvb_parse_descriptors(parms, p, desc_length,
+				      head_desc) != 0) {
+			return -3;
+		}
+		p += desc_length;
 	}
 
 	/* get the stream entries */
@@ -77,7 +100,10 @@ ssize_t dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		struct dvb_table_pmt_stream *stream;
 
 		stream = malloc(sizeof(struct dvb_table_pmt_stream));
-
+		if (!stream) {
+			dvb_logerr("%s: out of memory", __func__);
+			return -3;
+		}
 		memcpy(stream, p, size);
 		p += size;
 
@@ -91,16 +117,17 @@ ssize_t dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 
 		/* parse the descriptors */
 		if (stream->desc_length > 0) {
-			size = stream->desc_length;
-			if (p + size > endbuf) {
-				dvb_logwarn("%s: decsriptors short read %zd/%zd bytes", __func__,
-					   size, endbuf - p);
-				size = endbuf - p;
+			uint16_t desc_length = stream->desc_length;
+			if (p + desc_length > endbuf) {
+				dvb_logwarn("%s: decsriptors short read %zd/%d bytes", __func__,
+					   endbuf - p, desc_length);
+				desc_length = endbuf - p;
 			}
-			dvb_parse_descriptors(parms, p, size,
-					      &stream->descriptor);
-
-			p += size;
+			if (dvb_parse_descriptors(parms, p, desc_length,
+					      &stream->descriptor) != 0) {
+				return -4;
+			}
+			p += desc_length;
 		}
 	}
 	if (p < endbuf)
diff --git a/lib/libdvbv5/descriptors/sdt.c b/lib/libdvbv5/descriptors/sdt.c
index 4fb6826..8cee315 100644
--- a/lib/libdvbv5/descriptors/sdt.c
+++ b/lib/libdvbv5/descriptors/sdt.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2011-2012 - Mauro Carvalho Chehab
- * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ * Copyright (c) 2012-2014 - Andre Roth <neolynx@gmail.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -20,40 +20,64 @@
  */
 
 #include <libdvbv5/sdt.h>
+#include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 
 ssize_t dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			ssize_t buflen, struct dvb_table_sdt *sdt, ssize_t *table_length)
 {
 	const uint8_t *p = buf, *endbuf = buf + buflen - 4;
-	struct dvb_table_sdt_service **head = &sdt->service;
-	size_t size = offsetof(struct dvb_table_sdt, service);
+	struct dvb_table_sdt_service **head;
+	size_t size;
+
+	size = offsetof(struct dvb_table_sdt, service);
+	if (p + size > endbuf) {
+		dvb_logerr("%s: short read %zd/%zd bytes", __func__,
+			   endbuf - p, size);
+		return -1;
+	}
+
+	if (buf[0] != DVB_TABLE_SDT && buf[0] != DVB_TABLE_SDT2) {
+		dvb_logerr("%s: invalid marker 0x%02x, sould be 0x%02x or 0x%02x",
+				__func__, buf[0], DVB_TABLE_SDT, DVB_TABLE_SDT2);
+		return -2;
+	}
 
 	if (*table_length > 0) {
+		memcpy(sdt, p, size);
+		bswap16(sdt->network_id);
+
 		/* find end of curent list */
+		head = &sdt->service;
 		while (*head != NULL)
 			head = &(*head)->next;
 	} else {
-		if (p + size > endbuf) {
-			dvb_logerr("SDT table was truncated. Need %zu bytes, but has only %zu.",
-					size, buflen);
-			return -1;
-		}
 		memcpy(sdt, p, size);
-		*table_length = sizeof(struct dvb_table_sdt);
-
 		bswap16(sdt->network_id);
 
 		sdt->service = NULL;
+		head = &sdt->service;
 	}
 	p += size;
 
+	size = sdt->header.section_length + 3 - 4; /* plus header, minus CRC */
+	if (buf + size > endbuf) {
+		dvb_logerr("%s: short read %zd/%zd bytes", __func__,
+			   endbuf - buf, size);
+		return -3;
+	}
+	endbuf = buf + size;
+
+	/* get the event entries */
 	size = offsetof(struct dvb_table_sdt_service, descriptor);
 	while (p + size <= endbuf) {
 		struct dvb_table_sdt_service *service;
 
 		service = malloc(sizeof(struct dvb_table_sdt_service));
-
+		if (!service) {
+			dvb_logerr("%s: out of memory", __func__);
+			return -5;
+		}
 		memcpy(service, p, size);
 		p += size;
 
@@ -65,15 +89,25 @@ ssize_t dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		*head = service;
 		head = &(*head)->next;
 
-		/* get the descriptors for each program */
-		dvb_parse_descriptors(parms, p, service->section_length,
-				      &service->descriptor);
+		/* parse the descriptors */
+		if (service->desc_length > 0) {
+			uint16_t desc_length = service->desc_length;
+			if (p + desc_length > endbuf) {
+				dvb_logwarn("%s: decsriptors short read %zd/%d bytes", __func__,
+					   endbuf - p, desc_length);
+				desc_length = endbuf - p;
+			}
+			if (dvb_parse_descriptors(parms, p, desc_length,
+					      &service->descriptor) != 0) {
+				return -4;
+			}
+			p += desc_length;
+		}
 
-		p += service->section_length;
 	}
 	if (endbuf - p)
-		dvb_logerr("SDT table has %zu spurious bytes at the end.",
-			   endbuf - p);
+		dvb_logwarn("%s: %zu spurious bytes at the end",
+			   __func__, endbuf - p);
 
 	*table_length = p - buf;
 	return p - buf;
diff --git a/lib/libdvbv5/descriptors/vct.c b/lib/libdvbv5/descriptors/vct.c
index c0d531a..39d44f4 100644
--- a/lib/libdvbv5/descriptors/vct.c
+++ b/lib/libdvbv5/descriptors/vct.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2013 - Mauro Carvalho Chehab <m.chehab@samsung.com>
- * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
+ * Copyright (c) 2013-2014 - Andre Roth <neolynx@gmail.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -20,6 +20,7 @@
  */
 
 #include <libdvbv5/vct.h>
+#include <libdvbv5/descriptors.h>
 #include <libdvbv5/dvb-fe.h>
 #include <parse_string.h>
 
@@ -27,27 +28,35 @@ ssize_t atsc_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			ssize_t buflen, struct atsc_table_vct *vct, ssize_t *table_length)
 {
 	const uint8_t *p = buf, *endbuf = buf + buflen - 4;
-	struct atsc_table_vct_channel **head = &vct->channel;
+	struct atsc_table_vct_channel **head;
+	size_t size;
 	int i, n;
-	size_t size = offsetof(struct atsc_table_vct, channel);
 
+	size = offsetof(struct atsc_table_vct, channel);
 	if (p + size > endbuf) {
-		dvb_logerr("VCT table was truncated. Need %zu bytes, but has only %zu.",
-			   size, buflen);
+		dvb_logerr("%s: short read %zd/%zd bytes", __func__,
+			   endbuf - p, size);
 		return -1;
 	}
 
+	if (buf[0] != ATSC_TABLE_TVCT && buf[0] != ATSC_TABLE_CVCT) {
+		dvb_logerr("%s: invalid marker 0x%02x, sould be 0x%02x or 0x%02x",
+				__func__, buf[0], ATSC_TABLE_TVCT, ATSC_TABLE_CVCT);
+		return -2;
+	}
+
 	if (*table_length > 0) {
 		/* find end of curent list */
+		head = &vct->channel;
 		while (*head != NULL)
 			head = &(*head)->next;
 	} else {
 		memcpy(vct, p, size);
 
-		*table_length = sizeof(struct atsc_table_vct);
-
 		vct->channel = NULL;
 		vct->descriptor = NULL;
+
+		head = &vct->channel;
 	}
 	p += size;
 
@@ -56,13 +65,17 @@ ssize_t atsc_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 		struct atsc_table_vct_channel *channel;
 
 		if (p + size > endbuf) {
-			dvb_logerr("VCT channel table is missing %d elements",
-				   vct->num_channels_in_section - n + 1);
+			dvb_logerr("%s: channel table is missing %d elements",
+				   __func__, vct->num_channels_in_section - n + 1);
 			vct->num_channels_in_section = n;
 			break;
 		}
 
 		channel = malloc(sizeof(struct atsc_table_vct_channel));
+		if (!channel) {
+			dvb_logerr("%s: out of memory", __func__);
+			return -3;
+		}
 
 		memcpy(channel, p, size);
 		p += size;
@@ -123,8 +136,8 @@ ssize_t atsc_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 				      &vct->descriptor);
 	}
 	if (endbuf - p)
-		dvb_logerr("VCT table has %zu spurious bytes at the end.",
-			   endbuf - p);
+		dvb_logwarn("%s: %zu spurious bytes at the end",
+			   __func__, endbuf - p);
 	*table_length = p - buf;
 	return p - buf;
 }
-- 
1.7.10.4

