Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:50565 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956Ab1G2K5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:03 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 68CBC18B03E
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:00 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkW-0007nY-6n
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:00 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 12/59] V4L: ov2640: support the new mbus-config subdev ops
Date: Fri, 29 Jul 2011 12:56:12 +0200
Message-Id: <1311937019-29914-13-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend the driver to also support [gs]_mbus_config() subdevice video
operations.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/ov2640.c |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/ov2640.c b/drivers/media/video/ov2640.c
index 9ce2fa0..78bf602 100644
--- a/drivers/media/video/ov2640.c
+++ b/drivers/media/video/ov2640.c
@@ -19,10 +19,11 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/videodev2.h>
-#include <media/v4l2-chip-ident.h>
-#include <media/v4l2-subdev.h>
+
 #include <media/soc_camera.h>
 #include <media/soc_mediabus.h>
+#include <media/v4l2-chip-ident.h>
+#include <media/v4l2-subdev.h>
 
 #define VAL_SET(x, mask, rshift, lshift)  \
 		((((x) >> rshift) & mask) << lshift)
@@ -1083,6 +1084,22 @@ static struct v4l2_subdev_core_ops ov2640_subdev_core_ops = {
 #endif
 };
 
+static int ov2640_g_mbus_config(struct v4l2_subdev *sd,
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
 static struct v4l2_subdev_video_ops ov2640_subdev_video_ops = {
 	.s_stream	= ov2640_s_stream,
 	.g_mbus_fmt	= ov2640_g_fmt,
@@ -1091,6 +1108,7 @@ static struct v4l2_subdev_video_ops ov2640_subdev_video_ops = {
 	.cropcap	= ov2640_cropcap,
 	.g_crop		= ov2640_g_crop,
 	.enum_mbus_fmt	= ov2640_enum_fmt,
+	.g_mbus_config	= ov2640_g_mbus_config,
 };
 
 static struct v4l2_subdev_ops ov2640_subdev_ops = {
-- 
1.7.2.5

