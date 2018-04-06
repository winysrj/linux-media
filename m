Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:56774 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756729AbeDFOXd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 10:23:33 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 13/21] media: davinci: fix an inconsistent ident
Date: Fri,  6 Apr 2018 10:23:14 -0400
Message-Id: <ddcf1e62d55404715fbb474d730c170525c4e0d1.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/davinci/vpbe_osd.c:849 try_layer_config() warn: inconsistent indenting

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/davinci/vpbe_osd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_osd.c b/drivers/media/platform/davinci/vpbe_osd.c
index 99a4ec183ba9..7f610320426d 100644
--- a/drivers/media/platform/davinci/vpbe_osd.c
+++ b/drivers/media/platform/davinci/vpbe_osd.c
@@ -846,9 +846,10 @@ static int try_layer_config(struct osd_state *sd, enum osd_layer layer,
 
 	/* DM6446: */
 	/* only one OSD window at a time can use RGB pixel formats */
-	  if ((osd->vpbe_type == VPBE_VERSION_1) &&
-		  is_osd_win(layer) && is_rgb_pixfmt(lconfig->pixfmt)) {
+	if ((osd->vpbe_type == VPBE_VERSION_1) &&
+	    is_osd_win(layer) && is_rgb_pixfmt(lconfig->pixfmt)) {
 		enum osd_pix_format pixfmt;
+
 		if (layer == WIN_OSD0)
 			pixfmt = osd->win[WIN_OSD1].lconfig.pixfmt;
 		else
-- 
2.14.3
