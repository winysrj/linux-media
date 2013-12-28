Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:45916 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237Ab3L1PqU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 10:46:20 -0500
Received: by mail-ee0-f44.google.com with SMTP id b57so4433532eek.31
        for <linux-media@vger.kernel.org>; Sat, 28 Dec 2013 07:46:17 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 01/13] libdvbv5: fix reading multisection tables
Date: Sat, 28 Dec 2013 16:45:49 +0100
Message-Id: <1388245561-8751-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/libdvbv5/dvb-scan.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index e9ccc72..af3a052 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -187,15 +187,19 @@ int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd,
 		dvb_table_header_init(h);
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
 
+		/*if (id != -1) {*/
+			/*if (table_id == -1)*/
+				/*table_id = h->id;*/
+			/*else if (h->id != table_id) {*/
+				/*dvb_logwarn("dvb_read_section: table ID mismatch reading multi section table: %d != %d", h->id, table_id);*/
+				/*free(buf);*/
+				/*continue;*/
+			/*}*/
+		/*}*/
+
+		dvb_logerr("dvb_read_section: got section %d, last %di, filter %d", h->section_id, h->last_section, id );
 		/* handle the sections */
 		if (first_section == -1)
 			first_section = h->section_id;
-- 
1.8.3.2

