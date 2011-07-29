Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:50004 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169Ab1G2K5E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:04 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id ABF1918B043
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:00 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkW-0007nq-Et
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:00 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 18/59] V4L: ov9740: support the new mbus-config subdev ops
Date: Fri, 29 Jul 2011 12:56:18 +0200
Message-Id: <1311937019-29914-19-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend the driver to also support [gs]_mbus_config() subdevice video
operations.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/ov9740.c |   33 ++++++++++++++++++++++++++-------
 1 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/ov9740.c b/drivers/media/video/ov9740.c
index edd1ffc..67b7020 100644
--- a/drivers/media/video/ov9740.c
+++ b/drivers/media/video/ov9740.c
@@ -14,8 +14,10 @@
 #include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
-#include <media/v4l2-chip-ident.h>
+
 #include <media/soc_camera.h>
+#include <media/soc_mediabus.h>
+#include <media/v4l2-chip-ident.h>
 
 #define to_ov9740(sd)		container_of(sd, struct ov9740_priv, subdev)
 
@@ -949,13 +951,30 @@ static struct soc_camera_ops ov9740_ops = {
 	.num_controls		= ARRAY_SIZE(ov9740_controls),
 };
 
+static int ov9740_g_mbus_config(struct v4l2_subdev *sd,
+				struct v4l2_mbus_config *cfg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_device *icd = client->dev.platform_data;
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
+
+	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
+		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
+		V4L2_MBUS_DATA_ACTIVE_HIGH;
+	cfg->type = V4L2_MBUS_PARALLEL;
+	cfg->flags = soc_camera_apply_board_flags(icl, cfg);
+
+	return 0;
+}
+
 static struct v4l2_subdev_video_ops ov9740_video_ops = {
-	.s_stream		= ov9740_s_stream,
-	.s_mbus_fmt		= ov9740_s_fmt,
-	.try_mbus_fmt		= ov9740_try_fmt,
-	.enum_mbus_fmt		= ov9740_enum_fmt,
-	.cropcap		= ov9740_cropcap,
-	.g_crop			= ov9740_g_crop,
+	.s_stream	= ov9740_s_stream,
+	.s_mbus_fmt	= ov9740_s_fmt,
+	.try_mbus_fmt	= ov9740_try_fmt,
+	.enum_mbus_fmt	= ov9740_enum_fmt,
+	.cropcap	= ov9740_cropcap,
+	.g_crop		= ov9740_g_crop,
+	.g_mbus_config	= ov9740_g_mbus_config,
 };
 
 static struct v4l2_subdev_core_ops ov9740_core_ops = {
-- 
1.7.2.5

