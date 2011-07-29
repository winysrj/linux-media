Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:58333 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260Ab1G2K5F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:05 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 0D44D18B03C
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:02 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkX-0007pJ-UI
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:01 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 48/59] V4L: ov6650: remove superfluous soc-camera client operations
Date: Fri, 29 Jul 2011 12:56:48 +0200
Message-Id: <1311937019-29914-49-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that all soc-camera hosts have been ported to use V4L2 subdevice
mediabus-config operations and soc-camera client bus-parameter operations
have been made optional, they can be removed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/ov6650.c |   50 +----------------------------------------
 1 files changed, 2 insertions(+), 48 deletions(-)

diff --git a/drivers/media/video/ov6650.c b/drivers/media/video/ov6650.c
index a26734d..654b2f5 100644
--- a/drivers/media/video/ov6650.c
+++ b/drivers/media/video/ov6650.c
@@ -419,52 +419,6 @@ static int ov6650_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-/* Alter bus settings on camera side */
-static int ov6650_set_bus_param(struct soc_camera_device *icd,
-				unsigned long flags)
-{
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	int ret;
-
-	flags = soc_camera_apply_sensor_flags(icl, flags);
-
-	if (flags & SOCAM_PCLK_SAMPLE_RISING)
-		ret = ov6650_reg_rmw(client, REG_COMJ, COMJ_PCLK_RISING, 0);
-	else
-		ret = ov6650_reg_rmw(client, REG_COMJ, 0, COMJ_PCLK_RISING);
-	if (ret)
-		return ret;
-
-	if (flags & SOCAM_HSYNC_ACTIVE_LOW)
-		ret = ov6650_reg_rmw(client, REG_COMF, COMF_HREF_LOW, 0);
-	else
-		ret = ov6650_reg_rmw(client, REG_COMF, 0, COMF_HREF_LOW);
-	if (ret)
-		return ret;
-
-	if (flags & SOCAM_VSYNC_ACTIVE_HIGH)
-		ret = ov6650_reg_rmw(client, REG_COMJ, COMJ_VSYNC_HIGH, 0);
-	else
-		ret = ov6650_reg_rmw(client, REG_COMJ, 0, COMJ_VSYNC_HIGH);
-
-	return ret;
-}
-
-/* Request bus settings on camera side */
-static unsigned long ov6650_query_bus_param(struct soc_camera_device *icd)
-{
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-
-	unsigned long flags = SOCAM_MASTER |
-		SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING |
-		SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_LOW |
-		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_LOW |
-		SOCAM_DATA_ACTIVE_HIGH | SOCAM_DATAWIDTH_8;
-
-	return soc_camera_apply_sensor_flags(icl, flags);
-}
-
 /* Get status of additional camera capabilities */
 static int ov6650_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
@@ -1095,8 +1049,6 @@ static int ov6650_video_probe(struct soc_camera_device *icd,
 }
 
 static struct soc_camera_ops ov6650_ops = {
-	.set_bus_param		= ov6650_set_bus_param,
-	.query_bus_param	= ov6650_query_bus_param,
 	.controls		= ov6650_controls,
 	.num_controls		= ARRAY_SIZE(ov6650_controls),
 };
@@ -1111,6 +1063,7 @@ static struct v4l2_subdev_core_ops ov6650_core_ops = {
 #endif
 };
 
+/* Request bus settings on camera side */
 static int ov6650_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
@@ -1129,6 +1082,7 @@ static int ov6650_g_mbus_config(struct v4l2_subdev *sd,
 	return 0;
 }
 
+/* Alter bus settings on camera side */
 static int ov6650_s_mbus_config(struct v4l2_subdev *sd,
 				const struct v4l2_mbus_config *cfg)
 {
-- 
1.7.2.5

