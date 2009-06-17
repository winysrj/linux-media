Return-path: <linux-media-owner@vger.kernel.org>
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:51048 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbZFQRzV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 13:55:21 -0400
Message-ID: <4A392E31.4050705@cam.ac.uk>
Date: Wed, 17 Jun 2009 17:56:01 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: OV7670: getting it working with soc-camera.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is purely for info of anyone else wanting to use the ov7670
with Guennadi's recent work on converted soc-camera to v4l2-subdevs.

It may not be completely minimal, but it's letting me take pictures ;)

Couple of minor queries:

Currently it is assumed that there is a means of telling the chip to
use particular bus params.  In the case of this one it doesn't support
anything other than 8 bit. Stuff may get added down the line, but
in meantime does anyone mind if we make icd->ops->set_bus_param
optional in soc-camera?

Is there any reason (or advantage) in not specifying the i2c address
in the driver? Or for that matter why the address is right shifted by
1 in:

v4l_info(client, "chip found @ 0x%02x (%s)\n",
	 client->addr << 1, client->adapter->name);

Admittedly the data sheet uses an 'unusual' convention for the
address (separate write and read address which correspond to
a single address of 0x21 with the relevant write bit set as
appropriate).

As ever any comments welcome. Thanks to Guennadi Liakhovetski
for his soc-camera work and Hans Verkuil for conversion of the
ov7670 to soc-dev.

Tested against a merge of todays v4l-next tree and Linus' current
with the minor pxa-camera bug I posted earlier fixed and Guennadi's
extensive patch set applied (this requires a few hand merges, but
nothing too nasty).

---

diff --git a/include/media/ov7670_soc.h b/include/media/ov7670_soc.h
new file mode 100644
index 0000000..2f264b2
--- /dev/null
+++ b/include/media/ov7670_soc.h
@@ -0,0 +1,21 @@
+/* ov7670_soc Camera
+ *
+ * Copyright (C) 2009 Jonathan Cameron <jic23@cam.ac.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __OV7670_SOC_H__
+#define __OV7670_SOC_H__
+
+#include <media/soc_camera.h>
+
+struct ov7670_soc_camera_info {
+	int gpio_pwr;
+	int gpio_reset;
+	struct soc_camera_link link;
+};
+
+#endif
diff --git a/drivers/media/video/ov7670.c b/drivers/media/video/ov7670.c
index 0e2184e..51d432e 100644
--- a/drivers/media/video/ov7670.c
+++ b/drivers/media/video/ov7670.c
@@ -19,7 +19,14 @@
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-i2c-drv.h>
 
+#define OV7670_SOC
 
+
+#ifdef OV7670_SOC
+#include <media/ov7670_soc.h>
+#include <media/soc_camera.h>
+#include <linux/gpio.h>
+#endif /* OV7670_SOC */
 MODULE_AUTHOR("Jonathan Corbet <corbet@lwn.net>");
 MODULE_DESCRIPTION("A low-level driver for OmniVision ov7670 sensors");
 MODULE_LICENSE("GPL");
@@ -1239,19 +1246,94 @@ static const struct v4l2_subdev_ops ov7670_ops = {
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
+
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
 
+#endif
 static int ov7670_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
+#ifdef OV7670_SOC
+	struct soc_camera_device *icd = client->dev.platform_data;
+	struct soc_camera_link *icl;
+	struct ov7670_soc_camera_info *board_info;
+#endif
 	struct v4l2_subdev *sd;
 	struct ov7670_info *info;
+
 	int ret;
 
+#ifdef OV7670_SOC
+	icl = to_soc_camera_link(icd);
+	if (!icl)
+		return -EINVAL;
+	board_info = container_of(icl, struct ov7670_soc_camera_info, link);
+
+	gpio_request(board_info->gpio_reset, "ov7670 soc reset");
+	gpio_request(board_info->gpio_pwr, "ov7670 soc power");
+
+	/* reset high for normal mode */
+	gpio_direction_output(board_info->gpio_reset, 1);
+	/* power down normal mode. */
+	gpio_direction_output(board_info->gpio_pwr, 0);
+	/* perform a hard reset as per tinyos code */
+	gpio_set_value(board_info->gpio_pwr, 1);
+	gpio_set_value(board_info->gpio_reset, 1);
+	mdelay(2);
+	gpio_set_value(board_info->gpio_pwr, 0);
+	gpio_set_value(board_info->gpio_reset, 0);
+	mdelay(2);
+	gpio_set_value(board_info->gpio_reset, 1);
+	mdelay(5);
+#endif
 	info = kzalloc(sizeof(struct ov7670_info), GFP_KERNEL);
 	if (info == NULL)
 		return -ENOMEM;
+	/* JIC; whole load of reset code may be needed */
+
 	sd = &info->sd;
 	v4l2_i2c_subdev_init(sd, client, &ov7670_ops);
+#ifdef OV7670_SOC
+	icd->ops = &ov7670_soc_ops;
+	icd->rect_max.width = VGA_WIDTH;
+	icd->rect_max.height = VGA_HEIGHT;
+	icd->formats = ov7670_soc_fmt_lists;
+	icd->num_formats = ARRAY_SIZE(ov7670_soc_fmt_lists);
+#endif
 
 	/* Make sure it's an ov7670 */
 	ret = ov7670_detect(sd);
@@ -1282,7 +1364,11 @@ static int ov7670_remove(struct i2c_client *client)
 }
 
 static const struct i2c_device_id ov7670_id[] = {
-	{ "ov7670", 0 },
+#ifdef OV7670_SOC
+	{ "ov7670", 0x21 },
+#else
+  	{ "ov7670", 0 },
+#endif
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, ov7670_id);
@@ -1293,3 +1379,4 @@ static struct v4l2_i2c_driver_data v4l2_i2c_data = {
 	.remove = ov7670_remove,
 	.id_table = ov7670_id,
 };
+
