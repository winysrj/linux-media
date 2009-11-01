Return-path: <linux-media-owner@vger.kernel.org>
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:59758 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbZKARoR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Nov 2009 12:44:17 -0500
Message-ID: <4AEDC90A.7050005@cam.ac.uk>
Date: Sun, 01 Nov 2009 17:44:42 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
MIME-Version: 1.0
To: dean_go Zhang <dean_go@eledsn.com>
CC: linux-arm-kernel@lists.infradead.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Soc camera:Is there anyone dealing with ov9650chip?Let's talk
 about 	soc camera driver.
References: <65c69abb0910300528j2bffc2b8i8eb07254725f8de7@mail.gmail.com>
In-Reply-To: <65c69abb0910300528j2bffc2b8i8eb07254725f8de7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dean_go Zhang wrote:
> I'm reading to documentation in linux-2.6.30,and ov7670 driver ,and I'm
> trying to make a driver for ov9650.
> 
>     struct soc_camera_ops provides .probe and .remove methods, which are
>     called by
>     the soc-camera core, when a camera is matched against or removed
>     from a camera
>     host bus, .init, .release, .suspend, and .resume are called from the
>     camera host
>     driver as discussed above. Other members of this struct provide
>     respective V4L2
>     functionality.
> 
>  
> This is from the documentation,but I didn't find any thing about
> soc_camera_host_device in ov7670's driver code.
> Does anyone know how to make a v4l2 soc camera driver? 
This isn't really an arm related question.  Should really be asked on
linux-media. (now cc'd along with Guennadi)

Having said that...

The reason you aren't finding soc camera related stuff in the ov7670 driver
is that it isn't currently a soc camera driver.  There is ongoing work to
move the soc-camera framework fully over to using v4l2-subdevs thus allowing
drivers like this one to work both with soc-camera interfaces and others.

There are still a few elements being cleaned up (primarily to do with
negotiation of image formats) that make it tricky for a single driver to
directly support use through soc camera and without it. 

I would suggest looking in the linux-media archive for
Guennanadi Liakhovetski's latest imagebus patches for what still needs doing.

In meantime, the following patch against 2.6.32-rc5 adds soc camera support to the
ov7670 driver.  I've been posting updates tracking Guennadi's changes to soc camera
to linux-media (though I haven't had a chance to do the recent imagebus changes yet).

Unfortunately omnivision aren't exactly free with datasheets (I can get the ov9650 from
google but not the ov9640), so I can't check, but based purely on numbering how does
this chip compare to the ov9640 which as a driver in kernel (probably in a queue
for next merge window? - it's certainly in the tree Guennadi is using and has been
posted to linux-media)

Google did however give me this hit, which mentions an ov9650 driver
http://marex-hnd.blogspot.com/2009/08/omnivision-ov9640-hacking-part-iv.html
Perhaps Guennadi has more info on this?


>From 408902c5584796924f8f9903f6c7338db4a0fd0f Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <jic23@cam.ac.uk>
Date: Sat, 4 Jul 2009 13:25:06 +0000
Subject: [PATCH 02/10] ov7670: Temporary soc-camera support

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/media/video/ov7670.c |   50 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/ov7670.c b/drivers/media/video/ov7670.c
index 0e2184e..910a499 100644
--- a/drivers/media/video/ov7670.c
+++ b/drivers/media/video/ov7670.c
@@ -19,6 +19,8 @@
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-i2c-drv.h>
 
+#include <media/soc_camera.h>
+#include <linux/autoconf.h>
 
 MODULE_AUTHOR("Jonathan Corbet <corbet@lwn.net>");
 MODULE_DESCRIPTION("A low-level driver for OmniVision ov7670 sensors");
@@ -745,6 +747,10 @@ static int ov7670_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *fmt)
 	struct ov7670_info *info = to_state(sd);
 	unsigned char com7, clkrc = 0;
 
+	ret = ov7670_init(sd, 0);
+	if (ret)
+		return ret;
+
 	ret = ov7670_try_fmt_internal(sd, fmt, &ovfmt, &wsize);
 	if (ret)
 		return ret;
@@ -1239,6 +1245,41 @@ static const struct v4l2_subdev_ops ov7670_ops = {
 };
 
 /* ----------------------------------------------------------------------- */
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
+
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
 
 static int ov7670_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
@@ -1246,7 +1287,16 @@ static int ov7670_probe(struct i2c_client *client,
 	struct v4l2_subdev *sd;
 	struct ov7670_info *info;
 	int ret;
+	struct soc_camera_device *icd = client->dev.platform_data;
+
+	if (!icd) {
+		dev_err(&client->dev, "OV7670: missing soc-camera data!\n");
+		return -EINVAL;
+	}
 
+	icd->ops = &ov7670_soc_ops;
+	icd->formats = ov7670_soc_fmt_lists;
+	icd->num_formats = ARRAY_SIZE(ov7670_soc_fmt_lists);
 	info = kzalloc(sizeof(struct ov7670_info), GFP_KERNEL);
 	if (info == NULL)
 		return -ENOMEM;
-- 
1.6.3.3



