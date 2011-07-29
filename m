Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:50650 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118Ab1G2K5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:03 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id E5BC118B048
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:00 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkW-0007o8-Oe
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:00 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 24/59] V4L: tw9910: support the new mbus-config subdev ops
Date: Fri, 29 Jul 2011 12:56:24 +0200
Message-Id: <1311937019-29914-25-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend the driver to also support [gs]_mbus_config() subdevice video
operations.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/tw9910.c |   49 ++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index 686512e..4f9fbf2 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -23,10 +23,12 @@
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/videodev2.h>
-#include <media/v4l2-chip-ident.h>
-#include <media/v4l2-subdev.h>
+
 #include <media/soc_camera.h>
+#include <media/soc_mediabus.h>
 #include <media/tw9910.h>
+#include <media/v4l2-chip-ident.h>
+#include <media/v4l2-subdev.h>
 
 #define GET_ID(val)  ((val & 0xF8) >> 3)
 #define GET_REV(val) (val & 0x07)
@@ -862,6 +864,47 @@ static int tw9910_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
 	return 0;
 }
 
+static int tw9910_g_mbus_config(struct v4l2_subdev *sd,
+				struct v4l2_mbus_config *cfg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_device *icd = client->dev.platform_data;
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
+
+	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
+		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_LOW |
+		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_LOW |
+		V4L2_MBUS_DATA_ACTIVE_HIGH;
+	cfg->type = V4L2_MBUS_PARALLEL;
+	cfg->flags = soc_camera_apply_board_flags(icl, cfg);
+
+	return 0;
+}
+
+static int tw9910_s_mbus_config(struct v4l2_subdev *sd,
+				const struct v4l2_mbus_config *cfg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct soc_camera_device *icd = client->dev.platform_data;
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	u8 val = VSSL_VVALID | HSSL_DVALID;
+	unsigned long flags = soc_camera_apply_board_flags(icl, cfg);
+
+	/*
+	 * set OUTCTR1
+	 *
+	 * We use VVALID and DVALID signals to control VSYNC and HSYNC
+	 * outputs, in this mode their polarity is inverted.
+	 */
+	if (flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
+		val |= HSP_HI;
+
+	if (flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
+		val |= VSP_HI;
+
+	return i2c_smbus_write_byte_data(client, OUTCTR1, val);
+}
+
 static struct v4l2_subdev_video_ops tw9910_subdev_video_ops = {
 	.s_stream	= tw9910_s_stream,
 	.g_mbus_fmt	= tw9910_g_fmt,
@@ -870,6 +913,8 @@ static struct v4l2_subdev_video_ops tw9910_subdev_video_ops = {
 	.cropcap	= tw9910_cropcap,
 	.g_crop		= tw9910_g_crop,
 	.enum_mbus_fmt	= tw9910_enum_fmt,
+	.g_mbus_config	= tw9910_g_mbus_config,
+	.s_mbus_config	= tw9910_s_mbus_config,
 };
 
 static struct v4l2_subdev_ops tw9910_subdev_ops = {
-- 
1.7.2.5

