Return-path: <linux-media-owner@vger.kernel.org>
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:54067 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739AbZFRL6v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2009 07:58:51 -0400
Message-ID: <4A3A2C23.1040104@cam.ac.uk>
Date: Thu, 18 Jun 2009 11:59:31 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: OV7670: getting it working with soc-camera.
References: <4A392E31.4050705@cam.ac.uk> <Pine.LNX.4.64.0906172022570.4218@axis700.grange> <4A3A14E4.2000301@cam.ac.uk>
In-Reply-To: <4A3A14E4.2000301@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Updated temporary patch to get ov7670 working with soc camera.

---
Basically this is the original patch with the changes Guennadi
suggested. Again this is only for info, not a formal patch submission.


diff --git a/drivers/media/video/ov7670.c b/drivers/media/video/ov7670.c
index 0e2184e..9bea804 100644
--- a/drivers/media/video/ov7670.c
+++ b/drivers/media/video/ov7670.c
@@ -19,6 +19,12 @@
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-i2c-drv.h>
 
+#define OV7670_SOC
+
+
+#ifdef OV7670_SOC
+#include <media/soc_camera.h>
+#endif /* OV7670_SOC */
 
 MODULE_AUTHOR("Jonathan Corbet <corbet@lwn.net>");
 MODULE_DESCRIPTION("A low-level driver for OmniVision ov7670 sensors");
@@ -1239,13 +1245,58 @@ static const struct v4l2_subdev_ops ov7670_ops = {
 };
 
 /* ----------------------------------------------------------------------- */
+#ifdef OV7670_SOC
+
+static unsigned long ov7670_soc_query_bus_param(struct soc_camera_device *icd)
+{
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
+
+	unsigned long flags = SOCAM_PCLK_SAMPLE_RISING | SOCAM_MASTER |
+		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_HIGH |
+		SOCAM_DATAWIDTH_8 | SOCAM_DATA_ACTIVE_HIGH;
+
+	return soc_camera_apply_sensor_flags(icl, flags);
+}
+/* This device only supports one bus option */
+static int ov7670_soc_set_bus_param(struct soc_camera_device *icd,
+				    unsigned long flags)
+{
+	return 0;
+}
+
+static struct soc_camera_ops ov7670_soc_ops = {
+	.set_bus_param = ov7670_soc_set_bus_param,
+	.query_bus_param = ov7670_soc_query_bus_param,
+};
 
+#define SETFOURCC(type) .name = (#type), .fourcc = (V4L2_PIX_FMT_ ## type)
+static const struct soc_camera_data_format ov7670_soc_fmt_lists[] = {
+	{
+		SETFOURCC(YUYV),
+		.depth = 16,
+		.colorspace = V4L2_COLORSPACE_JPEG,
+	}, {
+		SETFOURCC(RGB565),
+		.depth = 16,
+		.colorspace = V4L2_COLORSPACE_SRGB,
+	},
+};
+
+#endif
 static int ov7670_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct v4l2_subdev *sd;
 	struct ov7670_info *info;
 	int ret;
+#ifdef OV7670_SOC
+	struct soc_camera_device *icd = client->dev.platform_data;
+	icd->ops = &ov7670_soc_ops;
+	icd->rect_max.width = VGA_WIDTH;
+	icd->rect_max.height = VGA_HEIGHT;
+	icd->formats = ov7670_soc_fmt_lists;
+	icd->num_formats = ARRAY_SIZE(ov7670_soc_fmt_lists);
+#endif
 
 	info = kzalloc(sizeof(struct ov7670_info), GFP_KERNEL);
 	if (info == NULL)
