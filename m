Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45184 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab1IFKDM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 06:03:12 -0400
Received: by wyh22 with SMTP id 22so4271797wyh.19
        for <linux-media@vger.kernel.org>; Tue, 06 Sep 2011 03:03:11 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH] mt9p031: Do not use PLL if external frequency is the same as target frequency.
Date: Tue,  6 Sep 2011 12:03:00 +0200
Message-Id: <1315303380-20698-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a check to see whether ext_freq and target_freq are equal and,
if true, PLL won't be used.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/mt9p031.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/mt9p031.c b/drivers/media/video/mt9p031.c
index 5cfa39f..42b5d18 100644
--- a/drivers/media/video/mt9p031.c
+++ b/drivers/media/video/mt9p031.c
@@ -117,6 +117,7 @@ struct mt9p031 {
 	u16 xskip;
 	u16 yskip;
 
+	bool use_pll;
 	const struct mt9p031_pll_divs *pll;
 
 	/* Registers cache */
@@ -201,10 +202,16 @@ static int mt9p031_pll_get_divs(struct mt9p031 *mt9p031)
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9p031->subdev);
 	int i;
 
+	if (mt9p031->pdata->ext_freq == mt9p031->pdata->target_freq) {
+		mt9p031->use_pll = false;
+		return 0;
+	}
+
 	for (i = 0; i < ARRAY_SIZE(mt9p031_divs); i++) {
 		if (mt9p031_divs[i].ext_freq == mt9p031->pdata->ext_freq &&
 		  mt9p031_divs[i].target_freq == mt9p031->pdata->target_freq) {
 			mt9p031->pll = &mt9p031_divs[i];
+			mt9p031->use_pll = true;
 			return 0;
 		}
 	}
@@ -385,8 +392,10 @@ static int mt9p031_s_stream(struct v4l2_subdev *subdev, int enable)
 						 MT9P031_OUTPUT_CONTROL_CEN, 0);
 		if (ret < 0)
 			return ret;
-
-		return mt9p031_pll_disable(mt9p031);
+		if (mt9p031->use_pll)
+			return mt9p031_pll_disable(mt9p031);
+		else
+			return 0;
 	}
 
 	ret = mt9p031_set_params(mt9p031);
@@ -399,7 +408,10 @@ static int mt9p031_s_stream(struct v4l2_subdev *subdev, int enable)
 	if (ret < 0)
 		return ret;
 
-	return mt9p031_pll_enable(mt9p031);
+	if (mt9p031->use_pll)
+		return mt9p031_pll_enable(mt9p031);
+	else
+		return 0;
 }
 
 static int mt9p031_enum_mbus_code(struct v4l2_subdev *subdev,
-- 
1.7.0.4

