Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:57168 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933721AbaDIW1V (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 18:27:21 -0400
Received: by mail-ee0-f45.google.com with SMTP id d17so2354637eek.18
        for <linux-media@vger.kernel.org>; Wed, 09 Apr 2014 15:27:20 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 1/7] libdvbv5: reunite atsc_table_header and dvb_table_header
Date: Thu, 10 Apr 2014 00:26:54 +0200
Message-Id: <1397082420-31198-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

this solves the ambiguity when parsing the dvb/atsc header
in dvb-scan.c

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/libdvbv5/atsc_eit.h        |    2 +-
 lib/include/libdvbv5/atsc_header.h     |   39 ++++++--------------------
 lib/include/libdvbv5/header.h          |    5 ++--
 lib/include/libdvbv5/mgt.h             |    2 +-
 lib/include/libdvbv5/vct.h             |    2 +-
 lib/libdvbv5/Makefile.am               |    1 -
 lib/libdvbv5/descriptors/atsc_eit.c    |    2 +-
 lib/libdvbv5/descriptors/atsc_header.c |   47 --------------------------------
 lib/libdvbv5/descriptors/header.c      |    3 +-
 lib/libdvbv5/descriptors/mgt.c         |    2 +-
 lib/libdvbv5/descriptors/vct.c         |    2 +-
 11 files changed, 17 insertions(+), 90 deletions(-)
 delete mode 100644 lib/libdvbv5/descriptors/atsc_header.c

diff --git a/lib/include/libdvbv5/atsc_eit.h b/lib/include/libdvbv5/atsc_eit.h
index c527b1d..8b093de 100644
--- a/lib/include/libdvbv5/atsc_eit.h
+++ b/lib/include/libdvbv5/atsc_eit.h
@@ -64,7 +64,7 @@ union atsc_table_eit_desc_length {
 } __attribute__((packed));
 
 struct atsc_table_eit {
-	struct atsc_table_header header;
+	ATSC_HEADER();
 	uint8_t events;
 	struct atsc_table_eit_event *event;
 } __attribute__((packed));
diff --git a/lib/include/libdvbv5/atsc_header.h b/lib/include/libdvbv5/atsc_header.h
index 9685b37..12e7379 100644
--- a/lib/include/libdvbv5/atsc_header.h
+++ b/lib/include/libdvbv5/atsc_header.h
@@ -24,40 +24,17 @@
 #include <stdint.h>
 #include <unistd.h> /* ssize_t */
 
+#include <libdvbv5/header.h>
+
 #define ATSC_BASE_PID  0x1FFB
 
-struct atsc_table_header {
-	uint8_t  table_id;
-	union {
-		uint16_t bitfield;
-		struct {
-			uint16_t section_length:12;
-			uint16_t one:2;
-			uint16_t priv:1;
-			uint16_t syntax:1;
-		} __attribute__((packed));
-	} __attribute__((packed));
-	uint16_t id;
-	uint8_t  current_next:1;
-	uint8_t  version:5;
-	uint8_t  one2:2;
-
-	uint8_t  section_id;
-	uint8_t  last_section;
-	uint8_t  protocol_version;
-} __attribute__((packed));
-
-struct dvb_v5_fe_parms;
-
-#ifdef __cplusplus
-extern "C" {
-#endif
+#define ATSC_HEADER() \
+	struct dvb_table_header header; \
+	uint8_t  protocol_version; \
 
-int  atsc_table_header_init (struct atsc_table_header *t);
-void atsc_table_header_print(struct dvb_v5_fe_parms *parms, const struct atsc_table_header *t);
+#define ATSC_TABLE_HEADER_PRINT(_parms, _table) \
+	dvb_table_header_print(_parms, &_table->header); \
+	dvb_log("| protocol_version %d", _table->protocol_version); \
 
-#ifdef __cplusplus
-}
-#endif
 
 #endif
diff --git a/lib/include/libdvbv5/header.h b/lib/include/libdvbv5/header.h
index 67b7694..dc85f46 100644
--- a/lib/include/libdvbv5/header.h
+++ b/lib/include/libdvbv5/header.h
@@ -50,10 +50,9 @@ struct dvb_table_header {
 	union {
 		uint16_t bitfield;
 		struct {
-			uint16_t section_length:10;
-			uint8_t  zero:2;
+			uint16_t section_length:12;
 			uint8_t  one:2;
-			uint8_t  zero2:1;
+			uint8_t  zero:1;
 			uint8_t  syntax:1;
 		} __attribute__((packed));
 	} __attribute__((packed));
diff --git a/lib/include/libdvbv5/mgt.h b/lib/include/libdvbv5/mgt.h
index 4ea905d..cb8d63a 100644
--- a/lib/include/libdvbv5/mgt.h
+++ b/lib/include/libdvbv5/mgt.h
@@ -53,7 +53,7 @@ struct atsc_table_mgt_table {
 } __attribute__((packed));
 
 struct atsc_table_mgt {
-	struct atsc_table_header header;
+	ATSC_HEADER();
         uint16_t tables;
         struct atsc_table_mgt_table *table;
 	struct dvb_desc *descriptor;
diff --git a/lib/include/libdvbv5/vct.h b/lib/include/libdvbv5/vct.h
index 6d41ac5..83bad06 100644
--- a/lib/include/libdvbv5/vct.h
+++ b/lib/include/libdvbv5/vct.h
@@ -85,7 +85,7 @@ struct atsc_table_vct_channel {
 } __attribute__((packed));
 
 struct atsc_table_vct {
-	struct atsc_table_header header;
+	ATSC_HEADER();
 
 	uint8_t num_channels_in_section;
 
diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
index 667a1af..df67544 100644
--- a/lib/libdvbv5/Makefile.am
+++ b/lib/libdvbv5/Makefile.am
@@ -69,7 +69,6 @@ libdvbv5_la_SOURCES = \
 	dvb-scan.c	\
 	descriptors.c	\
 	descriptors/header.c		\
-	descriptors/atsc_header.c	\
 	descriptors/pat.c		\
 	descriptors/pmt.c		\
 	descriptors/nit.c		\
diff --git a/lib/libdvbv5/descriptors/atsc_eit.c b/lib/libdvbv5/descriptors/atsc_eit.c
index 9e1397d..286748c 100644
--- a/lib/libdvbv5/descriptors/atsc_eit.c
+++ b/lib/libdvbv5/descriptors/atsc_eit.c
@@ -132,7 +132,7 @@ void atsc_table_eit_free(struct atsc_table_eit *eit)
 void atsc_table_eit_print(struct dvb_v5_fe_parms *parms, struct atsc_table_eit *eit)
 {
 	dvb_log("EIT");
-	atsc_table_header_print(parms, &eit->header);
+	ATSC_TABLE_HEADER_PRINT(parms, eit);
 	const struct atsc_table_eit_event *event = eit->event;
 	uint16_t events = 0;
 
diff --git a/lib/libdvbv5/descriptors/atsc_header.c b/lib/libdvbv5/descriptors/atsc_header.c
deleted file mode 100644
index 06d1bb1..0000000
--- a/lib/libdvbv5/descriptors/atsc_header.c
+++ /dev/null
@@ -1,47 +0,0 @@
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
-#include <libdvbv5/atsc_header.h>
-#include <libdvbv5/descriptors.h>
-#include <libdvbv5/dvb-fe.h>
-
-int atsc_table_header_init(struct atsc_table_header *t)
-{
-	bswap16(t->bitfield);
-	bswap16(t->id);
-	return 0;
-}
-
-void atsc_table_header_print(struct dvb_v5_fe_parms *parms, const struct atsc_table_header *t)
-{
-	dvb_log("| table_id         %02x", t->table_id);
-	dvb_log("| section_length   %d", t->section_length);
-	dvb_log("| syntax           %d", t->syntax);
-	dvb_log("| priv             %d", t->priv);
-	dvb_log("| one              %d", t->one);
-	dvb_log("| id               %d", t->id);
-	dvb_log("| one2             %d", t->one2);
-	dvb_log("| version          %d", t->version);
-	dvb_log("| current_next     %d", t->current_next);
-	dvb_log("| section_id       %d", t->section_id);
-	dvb_log("| last_section     %d", t->last_section);
-	dvb_log("| protocol_version %d", t->protocol_version);
-}
-
diff --git a/lib/libdvbv5/descriptors/header.c b/lib/libdvbv5/descriptors/header.c
index da3f970..3df73af 100644
--- a/lib/libdvbv5/descriptors/header.c
+++ b/lib/libdvbv5/descriptors/header.c
@@ -34,9 +34,8 @@ void dvb_table_header_print(struct dvb_v5_fe_parms *parms, const struct dvb_tabl
 {
 	dvb_log("| table_id            %d", t->table_id);
 	dvb_log("| section_length      %d", t->section_length);
-	dvb_log("| zero                %d", t->zero);
 	dvb_log("| one                 %d", t->one);
-	dvb_log("| zero2               %d", t->zero2);
+	dvb_log("| zero                %d", t->zero);
 	dvb_log("| syntax              %d", t->syntax);
 	dvb_log("| transport_stream_id %d", t->id);
 	dvb_log("| current_next        %d", t->current_next);
diff --git a/lib/libdvbv5/descriptors/mgt.c b/lib/libdvbv5/descriptors/mgt.c
index b445294..4d34740 100644
--- a/lib/libdvbv5/descriptors/mgt.c
+++ b/lib/libdvbv5/descriptors/mgt.c
@@ -125,7 +125,7 @@ void atsc_table_mgt_print(struct dvb_v5_fe_parms *parms, struct atsc_table_mgt *
 	uint16_t tables = 0;
 
 	dvb_log("MGT");
-	atsc_table_header_print(parms, &mgt->header);
+	ATSC_TABLE_HEADER_PRINT(parms, mgt);
 	dvb_log("| tables           %d", mgt->tables);
 	while(table) {
                 dvb_log("|- type %04x    %d", table->type, table->pid);
diff --git a/lib/libdvbv5/descriptors/vct.c b/lib/libdvbv5/descriptors/vct.c
index 8606d7e..c0d531a 100644
--- a/lib/libdvbv5/descriptors/vct.c
+++ b/lib/libdvbv5/descriptors/vct.c
@@ -150,7 +150,7 @@ void atsc_table_vct_print(struct dvb_v5_fe_parms *parms, struct atsc_table_vct *
 	else
 		dvb_log("TVCT");
 
-	atsc_table_header_print(parms, &vct->header);
+	ATSC_TABLE_HEADER_PRINT(parms, vct);
 
 	dvb_log("|- #channels        %d", vct->num_channels_in_section);
 	dvb_log("|\\  channel_id");
-- 
1.7.10.4

