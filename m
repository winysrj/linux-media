Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:59606 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728Ab1G2K5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:03 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 3A2CD18B039
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:00 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkW-0007nH-0D
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:00 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 07/59] V4L: mt9m001: support the new mbus-config subdev ops
Date: Fri, 29 Jul 2011 12:56:07 +0200
Message-Id: <1311937019-29914-8-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend the driver to also support [gs]_mbus_config() subdevice video
operations.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9m001.c |   40 +++++++++++++++++++++++++++++++++++++++-
 1 files changed, 39 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index 4da9cca..7618b3c 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -13,9 +13,10 @@
 #include <linux/i2c.h>
 #include <linux/log2.h>
 
+#include <media/soc_camera.h>
+#include <media/soc_mediabus.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-chip-ident.h>
-#include <media/soc_camera.h>
 
 /*
  * mt9m001 i2c address 0x5d
@@ -710,6 +711,41 @@ static int mt9m001_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
 	return 0;
 }
 
+static int mt9m001_g_mbus_config(struct v4l2_subdev *sd,
+				struct v4l2_mbus_config *cfg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_device *icd = client->dev.platform_data;
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
+
+	/* MT9M001 has all capture_format parameters fixed */
+	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_FALLING |
+		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_HIGH |
+		V4L2_MBUS_DATA_ACTIVE_HIGH | V4L2_MBUS_MASTER;
+	cfg->type = V4L2_MBUS_PARALLEL;
+	cfg->flags = soc_camera_apply_board_flags(icl, cfg);
+
+	return 0;
+}
+
+static int mt9m001_s_mbus_config(struct v4l2_subdev *sd,
+				const struct v4l2_mbus_config *cfg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_device *icd = client->dev.platform_data;
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	unsigned int bps = soc_mbus_get_fmtdesc(icd->current_fmt->code)->bits_per_sample;
+
+	if (icl->set_bus_param)
+		return icl->set_bus_param(icl, 1 << (bps - 1));
+
+	/*
+	 * Without board specific bus width settings we only support the
+	 * sensors native bus width
+	 */
+	return bps == 10 ? 0 : -EINVAL;
+}
+
 static struct v4l2_subdev_video_ops mt9m001_subdev_video_ops = {
 	.s_stream	= mt9m001_s_stream,
 	.s_mbus_fmt	= mt9m001_s_fmt,
@@ -719,6 +755,8 @@ static struct v4l2_subdev_video_ops mt9m001_subdev_video_ops = {
 	.g_crop		= mt9m001_g_crop,
 	.cropcap	= mt9m001_cropcap,
 	.enum_mbus_fmt	= mt9m001_enum_fmt,
+	.g_mbus_config	= mt9m001_g_mbus_config,
+	.s_mbus_config	= mt9m001_s_mbus_config,
 };
 
 static struct v4l2_subdev_sensor_ops mt9m001_subdev_sensor_ops = {
-- 
1.7.2.5

