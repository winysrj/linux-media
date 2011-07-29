Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:60402 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014Ab1G2K5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:03 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 62E6A18B03C
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:00 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkW-0007nV-5j
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:00 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 11/59] V4L: mt9v022: support the new mbus-config subdev ops
Date: Fri, 29 Jul 2011 12:56:11 +0200
Message-Id: <1311937019-29914-12-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend the driver to also support [gs]_mbus_config() subdevice video
operations.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9v022.c |   76 ++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 75 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index 51b0fcc..2fc6ca2 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -14,9 +14,10 @@
 #include <linux/delay.h>
 #include <linux/log2.h>
 
+#include <media/soc_camera.h>
+#include <media/soc_mediabus.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-chip-ident.h>
-#include <media/soc_camera.h>
 
 /*
  * mt9v022 i2c address 0x48, 0x4c, 0x58, 0x5c
@@ -848,6 +849,77 @@ static int mt9v022_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
 	return 0;
 }
 
+static int mt9v022_g_mbus_config(struct v4l2_subdev *sd,
+				struct v4l2_mbus_config *cfg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_device *icd = client->dev.platform_data;
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
+
+	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_SLAVE |
+		V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_PCLK_SAMPLE_FALLING |
+		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_LOW |
+		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_LOW |
+		V4L2_MBUS_DATA_ACTIVE_HIGH;
+	cfg->type = V4L2_MBUS_PARALLEL;
+	cfg->flags = soc_camera_apply_board_flags(icl, cfg);
+
+	return 0;
+}
+
+static int mt9v022_s_mbus_config(struct v4l2_subdev *sd,
+				 const struct v4l2_mbus_config *cfg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_device *icd = client->dev.platform_data;
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct mt9v022 *mt9v022 = to_mt9v022(client);
+	unsigned long flags = soc_camera_apply_board_flags(icl, cfg);
+	unsigned int bps = soc_mbus_get_fmtdesc(icd->current_fmt->code)->bits_per_sample;
+	int ret;
+	u16 pixclk = 0;
+
+	dev_info(icd->pdev, "set %d: %s, %dbps\n", icd->current_fmt->code,
+		 icd->current_fmt->host_fmt->name, bps);
+
+	if (icl->set_bus_param) {
+		ret = icl->set_bus_param(icl, 1 << (bps - 1));
+		if (ret)
+			return ret;
+	} else if (bps != 10) {
+		/*
+		 * Without board specific bus width settings we only support the
+		 * sensors native bus width
+		 */
+		return -EINVAL;
+	}
+
+	if (flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
+		pixclk |= 0x10;
+
+	if (!(flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH))
+		pixclk |= 0x1;
+
+	if (!(flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH))
+		pixclk |= 0x2;
+
+	ret = reg_write(client, MT9V022_PIXCLK_FV_LV, pixclk);
+	if (ret < 0)
+		return ret;
+
+	if (!(flags & V4L2_MBUS_MASTER))
+		mt9v022->chip_control &= ~0x8;
+
+	ret = reg_write(client, MT9V022_CHIP_CONTROL, mt9v022->chip_control);
+	if (ret < 0)
+		return ret;
+
+	dev_dbg(&client->dev, "Calculated pixclk 0x%x, chip control 0x%x\n",
+		pixclk, mt9v022->chip_control);
+
+	return 0;
+}
+
 static struct v4l2_subdev_video_ops mt9v022_subdev_video_ops = {
 	.s_stream	= mt9v022_s_stream,
 	.s_mbus_fmt	= mt9v022_s_fmt,
@@ -857,6 +929,8 @@ static struct v4l2_subdev_video_ops mt9v022_subdev_video_ops = {
 	.g_crop		= mt9v022_g_crop,
 	.cropcap	= mt9v022_cropcap,
 	.enum_mbus_fmt	= mt9v022_enum_fmt,
+	.g_mbus_config	= mt9v022_g_mbus_config,
+	.s_mbus_config	= mt9v022_s_mbus_config,
 };
 
 static struct v4l2_subdev_sensor_ops mt9v022_subdev_sensor_ops = {
-- 
1.7.2.5

