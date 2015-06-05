Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48280 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbbFEK3e (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2015 06:29:34 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] [media] vivid: don't use more than 1024 bytes of stack
Date: Fri,  5 Jun 2015 07:29:16 -0300
Message-Id: <9b65bac2413275a234ab904bedd08fdc4b03845e.1433500152.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the following compilation warnings:

	drivers/media/platform/vivid/vivid-tpg.c: In function 'tpg_gen_text':
	drivers/media/platform/vivid/vivid-tpg.c:1562:1: warning: the frame size of 1308 bytes is larger than 1024 bytes [-Wframe-larger-than=]
	 }
	 ^

This seems to be due to some bad optimization done by gcc.

Moving the for() loop to happen inside the macro solves the
issue.

While here, fix CodingStyle at the switch().

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index b1147f2df26c..7a3ed580626a 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -1492,12 +1492,10 @@ void tpg_gen_text(const struct tpg_data *tpg, u8 *basep[TPG_MAX_PLANES][2],
 	else if (tpg->field == V4L2_FIELD_SEQ_TB || tpg->field == V4L2_FIELD_SEQ_BT)
 		div = 2;
 
-	for (p = 0; p < tpg->planes; p++) {
-		unsigned vdiv = tpg->vdownsampling[p];
-		unsigned hdiv = tpg->hdownsampling[p];
-
-		/* Print text */
-#define PRINTSTR(PIXTYPE) do {	\
+	/* Print text */
+#define PRINTSTR(PIXTYPE) for (p = 0; p < tpg->planes; p++) {	\
+	unsigned vdiv = tpg->vdownsampling[p];	\
+	unsigned hdiv = tpg->hdownsampling[p];	\
 	PIXTYPE fg;	\
 	PIXTYPE bg;	\
 	memcpy(&fg, tpg->textfg[p], sizeof(PIXTYPE));	\
@@ -1548,16 +1546,19 @@ void tpg_gen_text(const struct tpg_data *tpg, u8 *basep[TPG_MAX_PLANES][2],
 	}	\
 } while (0)
 
-		switch (tpg->twopixelsize[p]) {
-		case 2:
-			PRINTSTR(u8); break;
-		case 4:
-			PRINTSTR(u16); break;
-		case 6:
-			PRINTSTR(x24); break;
-		case 8:
-			PRINTSTR(u32); break;
-		}
+	switch (tpg->twopixelsize[p]) {
+	case 2:
+		PRINTSTR(u8);
+		break;
+	case 4:
+		PRINTSTR(u16);
+		break;
+	case 6:
+		PRINTSTR(x24);
+		break;
+	case 8:
+		PRINTSTR(u32);
+		break;
 	}
 }
 
-- 
2.4.2

