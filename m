Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:64915 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190Ab1G2K5E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:04 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 9CD9C18B039
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:01 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkX-0007ov-Hn
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:01 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 40/59] V4L: mt9m001: remove superfluous soc-camera client operations
Date: Fri, 29 Jul 2011 12:56:40 +0200
Message-Id: <1311937019-29914-41-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that all soc-camera hosts have been ported to use V4L2 subdevice
mediabus-config operations and soc-camera client bus-parameter operations
have been made optional, they can be removed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9m001.c |   41 -----------------------------------------
 1 files changed, 0 insertions(+), 41 deletions(-)

diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index 750ce60..3555e85 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -166,45 +166,6 @@ static int mt9m001_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-static int mt9m001_set_bus_param(struct soc_camera_device *icd,
-				 unsigned long flags)
-{
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-	unsigned long width_flag = flags & SOCAM_DATAWIDTH_MASK;
-
-	/* Only one width bit may be set */
-	if (!is_power_of_2(width_flag))
-		return -EINVAL;
-
-	if (icl->set_bus_param)
-		return icl->set_bus_param(icl, width_flag);
-
-	/*
-	 * Without board specific bus width settings we only support the
-	 * sensors native bus width
-	 */
-	if (width_flag == SOCAM_DATAWIDTH_10)
-		return 0;
-
-	return -EINVAL;
-}
-
-static unsigned long mt9m001_query_bus_param(struct soc_camera_device *icd)
-{
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-	/* MT9M001 has all capture_format parameters fixed */
-	unsigned long flags = SOCAM_PCLK_SAMPLE_FALLING |
-		SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_HIGH |
-		SOCAM_DATA_ACTIVE_HIGH | SOCAM_MASTER;
-
-	if (icl->query_bus_param)
-		flags |= icl->query_bus_param(icl) & SOCAM_DATAWIDTH_MASK;
-	else
-		flags |= SOCAM_DATAWIDTH_10;
-
-	return soc_camera_apply_sensor_flags(icl, flags);
-}
-
 static int mt9m001_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -461,8 +422,6 @@ static const struct v4l2_queryctrl mt9m001_controls[] = {
 };
 
 static struct soc_camera_ops mt9m001_ops = {
-	.set_bus_param		= mt9m001_set_bus_param,
-	.query_bus_param	= mt9m001_query_bus_param,
 	.controls		= mt9m001_controls,
 	.num_controls		= ARRAY_SIZE(mt9m001_controls),
 };
-- 
1.7.2.5

