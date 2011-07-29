Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:50010 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291Ab1G2K5F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:05 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id E6A6D18B03D
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:01 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkX-0007pD-R5
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:01 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 46/59] V4L: ov2640: remove superfluous soc-camera client operations
Date: Fri, 29 Jul 2011 12:56:46 +0200
Message-Id: <1311937019-29914-47-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that all soc-camera hosts have been ported to use V4L2 subdevice
mediabus-config operations and soc-camera client bus-parameter operations
have been made optional, they can be removed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/ov2640.c |   40 ----------------------------------------
 1 files changed, 0 insertions(+), 40 deletions(-)

diff --git a/drivers/media/video/ov2640.c b/drivers/media/video/ov2640.c
index 31f361e..2826aff 100644
--- a/drivers/media/video/ov2640.c
+++ b/drivers/media/video/ov2640.c
@@ -701,44 +701,6 @@ static int ov2640_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-static int ov2640_set_bus_param(struct soc_camera_device *icd,
-				unsigned long flags)
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
-	 * Without board specific bus width settings we support only the
-	 * sensors native bus width witch are tested working
-	 */
-	if (width_flag & (SOCAM_DATAWIDTH_10 | SOCAM_DATAWIDTH_8))
-		return 0;
-
-	return 0;
-}
-
-static unsigned long ov2640_query_bus_param(struct soc_camera_device *icd)
-{
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
-	unsigned long flags = SOCAM_PCLK_SAMPLE_RISING | SOCAM_MASTER |
-		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_HIGH |
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
 static int ov2640_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
 	struct i2c_client  *client = v4l2_get_subdevdata(sd);
@@ -1067,8 +1029,6 @@ err:
 }
 
 static struct soc_camera_ops ov2640_ops = {
-	.set_bus_param		= ov2640_set_bus_param,
-	.query_bus_param	= ov2640_query_bus_param,
 	.controls		= ov2640_controls,
 	.num_controls		= ARRAY_SIZE(ov2640_controls),
 };
-- 
1.7.2.5

