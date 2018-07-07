Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:36451 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753358AbeGGLVL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 7 Jul 2018 07:21:11 -0400
Received: by mail-ed1-f68.google.com with SMTP id t3-v6so10446580eds.3
        for <linux-media@vger.kernel.org>; Sat, 07 Jul 2018 04:21:11 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 4/4] libdvbv5: fix parsing section gaps
Date: Sat,  7 Jul 2018 13:20:57 +0200
Message-Id: <20180707112057.7235-4-neolynx@gmail.com>
In-Reply-To: <20180707112057.7235-1-neolynx@gmail.com>
References: <20180707112057.7235-1-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

use the priv->extensions list also when parsing no continuous sections.
also fixes memory allocation/initialization for the extensions list.

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/libdvbv5/dvb-scan.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index 7ff8ba4f..5c8aca96 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -218,6 +218,7 @@ static int dvb_parse_section(struct dvb_v5_fe_parms_priv *parms,
 		ext->first_section = h.section_id;
 		ext->last_section = h.last_section;
 		priv->extensions = ext;
+		priv->num_extensions = 1;
 		new = 1;
 	} else {
 		/* search for an specific TS ID */
@@ -239,10 +240,21 @@ static int dvb_parse_section(struct dvb_v5_fe_parms_priv *parms,
 				return -1;
 			}
 			ext += i;
+			memset(ext, 0, sizeof(struct dvb_table_filter_ext_priv));
+			ext->ext_id = h.id;
+			ext->first_section = h.section_id;
+			ext->last_section = h.last_section;
+			new = 1;
 		}
 	}
 
 	if (!new) { /* Check if the table was already parsed, but not on first pass */
+		if(ext->done) {
+			if (parms->p.verbose)
+				dvb_log(_("%s: extension already done, ignoring: 0x%04x"), __func__, ext->ext_id);
+			return 0;
+		}
+
 		if (!sect->allow_section_gaps && sect->ts_id == -1) {
 			if (test_bit(h.section_id, ext->is_read_bits))
 				return 0;
@@ -252,8 +264,8 @@ static int dvb_parse_section(struct dvb_v5_fe_parms_priv *parms,
 			 * table is reached.
 			 */
 			if (parms->p.verbose)
-				dvb_log(_("%s: section repeated on table 0x%02x, extension ID 0x%04x: done"),
-					__func__, h.table_id, h.id);
+				dvb_log(_("%s: section repeated on table 0x%02x, extension ID 0x%04x, section %d/%d: done"),
+					__func__, h.table_id, ext->ext_id, h.section_id, h.last_section);
 
 			ext->done = 1;
 
@@ -287,8 +299,12 @@ static int dvb_parse_section(struct dvb_v5_fe_parms_priv *parms,
 ret:
 	/* Check if all extensions are done */
 	for (ext = priv->extensions, i = 0; i < priv->num_extensions; i++, ext++) {
-		if (!ext->done)
+		if (!ext->done) {
+			if (parms->p.verbose)
+				dvb_log(_("%s: extension not completed yet: 0x%04x"),
+						__func__, ext->ext_id);
 			return 0;
+		}
 	}
 
 	/* Section was fully parsed */
-- 
2.14.1
