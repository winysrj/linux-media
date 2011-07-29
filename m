Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:62140 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756269Ab1G2K5F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:05 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id D97B518B03B
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:01 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkX-0007pA-Pf
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:01 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 45/59] V4L: mt9v022: remove superfluous soc-camera client operations
Date: Fri, 29 Jul 2011 12:56:45 +0200
Message-Id: <1311937019-29914-46-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that all soc-camera hosts have been ported to use V4L2 subdevice
mediabus-config operations and soc-camera client bus-parameter operations
have been made optional, they can be removed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9v022.c |   74 -----------------------------------------
 1 files changed, 0 insertions(+), 74 deletions(-)

diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index ddc11d0..53149a7 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -200,78 +200,6 @@ static int mt9v022_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-static int mt9v022_set_bus_param(struct soc_camera_device *icd,
-				 unsigned long flags)
-{
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9v022 *mt9v022 = to_mt9v022(client);
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-	unsigned int width_flag = flags & SOCAM_DATAWIDTH_MASK;
-	int ret;
-	u16 pixclk = 0;
-
-	/* Only one width bit may be set */
-	if (!is_power_of_2(width_flag))
-		return -EINVAL;
-
-	if (icl->set_bus_param) {
-		ret = icl->set_bus_param(icl, width_flag);
-		if (ret)
-			return ret;
-	} else {
-		/*
-		 * Without board specific bus width settings we only support the
-		 * sensors native bus width
-		 */
-		if (width_flag != SOCAM_DATAWIDTH_10)
-			return -EINVAL;
-	}
-
-	flags = soc_camera_apply_sensor_flags(icl, flags);
-
-	if (flags & SOCAM_PCLK_SAMPLE_FALLING)
-		pixclk |= 0x10;
-
-	if (!(flags & SOCAM_HSYNC_ACTIVE_HIGH))
-		pixclk |= 0x1;
-
-	if (!(flags & SOCAM_VSYNC_ACTIVE_HIGH))
-		pixclk |= 0x2;
-
-	ret = reg_write(client, MT9V022_PIXCLK_FV_LV, pixclk);
-	if (ret < 0)
-		return ret;
-
-	if (!(flags & SOCAM_MASTER))
-		mt9v022->chip_control &= ~0x8;
-
-	ret = reg_write(client, MT9V022_CHIP_CONTROL, mt9v022->chip_control);
-	if (ret < 0)
-		return ret;
-
-	dev_dbg(&client->dev, "Calculated pixclk 0x%x, chip control 0x%x\n",
-		pixclk, mt9v022->chip_control);
-
-	return 0;
-}
-
-static unsigned long mt9v022_query_bus_param(struct soc_camera_device *icd)
-{
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-	unsigned int flags = SOCAM_MASTER | SOCAM_SLAVE |
-		SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING |
-		SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_LOW |
-		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_LOW |
-		SOCAM_DATA_ACTIVE_HIGH;
-
-	if (icl->query_bus_param)
-		flags |= icl->query_bus_param(icl) & SOCAM_DATAWIDTH_MASK;
-	else
-		flags |= SOCAM_DATAWIDTH_10;
-
-	return soc_camera_apply_sensor_flags(icl, flags);
-}
-
 static int mt9v022_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -558,8 +486,6 @@ static const struct v4l2_queryctrl mt9v022_controls[] = {
 };
 
 static struct soc_camera_ops mt9v022_ops = {
-	.set_bus_param		= mt9v022_set_bus_param,
-	.query_bus_param	= mt9v022_query_bus_param,
 	.controls		= mt9v022_controls,
 	.num_controls		= ARRAY_SIZE(mt9v022_controls),
 };
-- 
1.7.2.5

