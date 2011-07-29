Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:64223 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282Ab1G2K5F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:05 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id C21A8189B6D
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:01 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkX-0007p4-MZ
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:01 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 43/59] V4L: mt9t031: remove superfluous soc-camera client operations
Date: Fri, 29 Jul 2011 12:56:43 +0200
Message-Id: <1311937019-29914-44-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that all soc-camera hosts have been ported to use V4L2 subdevice
mediabus-config operations and soc-camera client bus-parameter operations
have been made optional, they can be removed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9t031.c |   31 -------------------------------
 1 files changed, 0 insertions(+), 31 deletions(-)

diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index c5adb23..25fb833 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -58,11 +58,6 @@
 #define MT9T031_COLUMN_SKIP		32
 #define MT9T031_ROW_SKIP		20
 
-#define MT9T031_BUS_PARAM	(SOCAM_PCLK_SAMPLE_RISING |	\
-	SOCAM_PCLK_SAMPLE_FALLING | SOCAM_HSYNC_ACTIVE_HIGH |	\
-	SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_DATA_ACTIVE_HIGH |	\
-	SOCAM_MASTER | SOCAM_DATAWIDTH_10)
-
 struct mt9t031 {
 	struct v4l2_subdev subdev;
 	struct v4l2_rect rect;	/* Sensor window */
@@ -180,30 +175,6 @@ static int mt9t031_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-static int mt9t031_set_bus_param(struct soc_camera_device *icd,
-				 unsigned long flags)
-{
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-
-	/* The caller should have queried our parameters, check anyway */
-	if (flags & ~MT9T031_BUS_PARAM)
-		return -EINVAL;
-
-	if (flags & SOCAM_PCLK_SAMPLE_FALLING)
-		reg_clear(client, MT9T031_PIXEL_CLOCK_CONTROL, 0x8000);
-	else
-		reg_set(client, MT9T031_PIXEL_CLOCK_CONTROL, 0x8000);
-
-	return 0;
-}
-
-static unsigned long mt9t031_query_bus_param(struct soc_camera_device *icd)
-{
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-
-	return soc_camera_apply_sensor_flags(icl, MT9T031_BUS_PARAM);
-}
-
 enum {
 	MT9T031_CTRL_VFLIP,
 	MT9T031_CTRL_HFLIP,
@@ -263,8 +234,6 @@ static const struct v4l2_queryctrl mt9t031_controls[] = {
 };
 
 static struct soc_camera_ops mt9t031_ops = {
-	.set_bus_param		= mt9t031_set_bus_param,
-	.query_bus_param	= mt9t031_query_bus_param,
 	.controls		= mt9t031_controls,
 	.num_controls		= ARRAY_SIZE(mt9t031_controls),
 };
-- 
1.7.2.5

