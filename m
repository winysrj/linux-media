Return-path: <mchehab@pedra>
Received: from mail.visioncatalog.de ([217.6.246.34]:45627 "EHLO
	root.phytec.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755952Ab1DFOGJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Apr 2011 10:06:09 -0400
Received: from idefix.phytec.de (idefix.phytec.de [172.16.0.10])
	by root.phytec.de (Postfix) with ESMTP id CB076BF08A
	for <linux-media@vger.kernel.org>; Wed,  6 Apr 2011 16:08:06 +0200 (CEST)
From: =?UTF-8?q?Teresa=20G=C3=A1mez?= <t.gamez@phytec.de>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Teresa=20G=C3=A1mez?= <t.gamez@phytec.de>
Subject: [PATCH 2/2] mt9m111: fix pixel clock
Date: Wed, 6 Apr 2011 16:01:55 +0200
Message-Id: <1302098515-12176-2-git-send-email-t.gamez@phytec.de>
In-Reply-To: <1302098515-12176-1-git-send-email-t.gamez@phytec.de>
References: <1302098515-12176-1-git-send-email-t.gamez@phytec.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This camera driver supports only rising edge, which is the default
setting of the device. The function mt9m111_setup_pixfmt() overwrites
this setting. So the driver actually uses falling edge.
This patch corrects that.

Signed-off-by: Teresa Gámez <t.gamez@phytec.de>
---
 drivers/media/video/mt9m111.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 53fa2a7..4040a96 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -315,10 +315,20 @@ static int mt9m111_setup_rect(struct i2c_client *client,
 static int mt9m111_setup_pixfmt(struct i2c_client *client, u16 outfmt)
 {
 	int ret;
+	u16 mask = MT9M111_OUTFMT_PROCESSED_BAYER | MT9M111_OUTFMT_RGB |
+		MT9M111_OUTFMT_BYPASS_IFP | MT9M111_OUTFMT_SWAP_RGB_EVEN |
+		MT9M111_OUTFMT_RGB565 | MT9M111_OUTFMT_RGB555 |
+		MT9M111_OUTFMT_SWAP_YCbCr_Cb_Cr |
+		MT9M111_OUTFMT_SWAP_YCbCr_C_Y;
 
-	ret = reg_write(OUTPUT_FORMAT_CTRL2_A, outfmt);
+	ret = reg_clear(OUTPUT_FORMAT_CTRL2_A, mask);
 	if (!ret)
-		ret = reg_write(OUTPUT_FORMAT_CTRL2_B, outfmt);
+		ret = reg_set(OUTPUT_FORMAT_CTRL2_A, outfmt);
+	if (!ret)
+		ret = reg_clear(OUTPUT_FORMAT_CTRL2_B, mask);
+	if (!ret)
+		ret = reg_set(OUTPUT_FORMAT_CTRL2_B, outfmt);
+
 	return ret;
 }
 
-- 
1.7.0.4

