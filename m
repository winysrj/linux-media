Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:53999 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab1LUPxx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Dec 2011 10:53:53 -0500
Date: Wed, 21 Dec 2011 16:53:51 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 2/3] V4L: mt9m111: power down most circuits when suspended
In-Reply-To: <Pine.LNX.4.64.1112211649070.30646@axis700.grange>
Message-ID: <Pine.LNX.4.64.1112211652440.30646@axis700.grange>
References: <Pine.LNX.4.64.1112211649070.30646@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9m111.c |   34 ++++++++++++++++++----------------
 1 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 54edb6b4..797660b 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -226,7 +226,6 @@ struct mt9m111 {
 	const struct mt9m111_datafmt *fmt;
 	int lastpage;	/* PageMap cache value */
 	unsigned char datawidth;
-	unsigned int powered:1;
 };
 
 static struct mt9m111 *to_mt9m111(const struct i2c_client *client)
@@ -360,12 +359,7 @@ static int mt9m111_setup_rect(struct mt9m111 *mt9m111,
 static int mt9m111_enable(struct mt9m111 *mt9m111)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
-	int ret;
-
-	ret = reg_set(RESET, MT9M111_RESET_CHIP_ENABLE);
-	if (!ret)
-		mt9m111->powered = 1;
-	return ret;
+	return reg_write(RESET, MT9M111_RESET_CHIP_ENABLE);
 }
 
 static int mt9m111_reset(struct mt9m111 *mt9m111)
@@ -751,9 +745,20 @@ static int mt9m111_s_ctrl(struct v4l2_ctrl *ctrl)
 
 static int mt9m111_suspend(struct mt9m111 *mt9m111)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
+	int ret;
+
 	v4l2_ctrl_s_ctrl(mt9m111->gain, mt9m111_get_global_gain(mt9m111));
 
-	return 0;
+	ret = reg_set(RESET, MT9M111_RESET_RESET_MODE);
+	if (!ret)
+		ret = reg_set(RESET, MT9M111_RESET_RESET_SOC |
+			      MT9M111_RESET_OUTPUT_DISABLE |
+			      MT9M111_RESET_ANALOG_STANDBY);
+	if (!ret)
+		ret = reg_clear(RESET, MT9M111_RESET_CHIP_ENABLE);
+
+	return ret;
 }
 
 static void mt9m111_restore_state(struct mt9m111 *mt9m111)
@@ -766,15 +771,12 @@ static void mt9m111_restore_state(struct mt9m111 *mt9m111)
 
 static int mt9m111_resume(struct mt9m111 *mt9m111)
 {
-	int ret = 0;
+	int ret = mt9m111_enable(mt9m111);
+	if (!ret)
+		ret = mt9m111_reset(mt9m111);
+	if (!ret)
+		mt9m111_restore_state(mt9m111);
 
-	if (mt9m111->powered) {
-		ret = mt9m111_enable(mt9m111);
-		if (!ret)
-			ret = mt9m111_reset(mt9m111);
-		if (!ret)
-			mt9m111_restore_state(mt9m111);
-	}
 	return ret;
 }
 
-- 
1.7.2.5

