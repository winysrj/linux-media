Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:40189 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932523AbaAHWNJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 17:13:09 -0500
Received: by mail-ea0-f177.google.com with SMTP id n15so1090067ead.8
        for <linux-media@vger.kernel.org>; Wed, 08 Jan 2014 14:13:08 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 1/2] libdvbv5: fix reading multisection tables
Date: Wed,  8 Jan 2014 23:12:46 +0100
Message-Id: <1389219167-23293-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Unfortunately the section ids are not granted to be incremented by one.
This means the last section id is not necessarily equal to the total
number of sections. The only way to know if everything has been parsed, is
to stop when a repeating section id has been found.

The sections do not need to contain the same table id. In EIT for example,
the id designates the corresponding service.
Thus, allow the table id to differ.

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/libdvbv5/dvb-scan.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index e69d852..95219fa 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -97,9 +98,12 @@ int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd,
 	uint8_t *buf = NULL;
 	uint8_t *tbl = NULL;
 	ssize_t table_length = 0;
+
+	/* variables for section handling */
+	int start_id = -1;
+	int start_section = -1;
 	int first_section = -1;
 	int last_section = -1;
-	int table_id = -1;
 	int sections = 0;
 	struct dmx_sct_filter_params f;
 	struct dvb_table_header *h;
@@ -186,24 +190,25 @@ int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd,
 
 		h = (struct dvb_table_header *)buf;
 		dvb_table_header_init(h);
+
+		if (start_id == h->id && start_section == h->section_id) {
+			dvb_logdbg( "dvb_read_section: section repeated, reading done" );
+			break;
+		}
+		if (start_id == -1) start_id = h->id;
+		if (start_section == -1) start_section = h->section_id;
+
 		if (id != -1 && h->id != id) { /* search for a specific table id */
 			continue;
-		} else {
-			if (table_id == -1)
-				table_id = h->id;
-			else if (h->id != table_id) {
-				dvb_logwarn("dvb_read_section: table ID mismatch reading multi section table: %d != %d", h->id, table_id);
-				continue;
-			}
 		}
 
 		/* handle the sections */
 		if (first_section == -1)
 			first_section = h->section_id;
-		else if (h->section_id == first_section)
+		else if (start_id == h->id && h->section_id == first_section)
 			break;
 
-		if (last_section == -1)
+		if (last_section == -1 || h->last_section > last_section)
 			last_section = h->last_section;
 
 		if (!tbl) {
@@ -229,8 +234,10 @@ int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd,
 		else
 			dvb_logerr("dvb_read_section: no initializer for table %d", tid);
 
-		if (++sections == last_section + 1)
+		if (id != -1 && ++sections == last_section + 1) {
+			dvb_logerr("dvb_read_section: read more sections than last section id: %d / %d", sections, last_section);
 			break;
+		}
 	}
 	free(buf);
 
-- 
1.8.3.2

