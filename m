Return-path: <linux-media-owner@vger.kernel.org>
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:39729 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbZIBSgZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Sep 2009 14:36:25 -0400
Message-ID: <4A9EBB30.8020801@cam.ac.uk>
Date: Wed, 02 Sep 2009 19:36:32 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: soc-camera: Handling hardware reset?
References: <4A9D6B98.5090003@cam.ac.uk> <Pine.LNX.4.64.0909021755391.6326@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0909021755391.6326@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski wrote:
> On Tue, 1 Sep 2009, Jonathan Cameron wrote:
> 
>> Dear all,
>>
>> With an ov7670 I have been using soc_camera_link.reset to pass in board specific
>> hardware reset of the sensor. (Is this a correct usage? The reset must occur
>> before the chip is used.)
>>
>> Unfortunately this function is called on every initialization of the camera
>> (so on probe and before taking images). Basically any call to open()
>>
>> This would be fine if the v4l2_subdev_core_ops.init  was called after every
>> call of this (ensuring valid state post reset). 
>>
>> Previously I was using the soc_camera_ops.init to call the core init function
>> thus putting the register values back before capturing, but now it's gone from
>> the interface.
>>
>> What is the right way to do this?
> 
> The idea is, that we're trying to save power, as long as noone is using 
> the camera, i.e., between the last close and the next open. But some 
> boards might not implement the power callback, so, to make the situation 
> equal for all, we also added a reset call on every first open. So, this is 
> exactly your case. Imagine, your camera driver has to work on a platform, 
> where power callbacks are implemented. So, in your .s_fmt() (or the new 
> .s_imgbus_fmt()) method, which is always called on the first open, you 
> have to be able to configure the chip after a fresh power-on.
In general that seems sensible.

I haven't looked at your imgbus patches yet (will do in a few days).

I've copied in those who might have an opinion on adding a rewrite
of all registers to s_fmt.  Current aim is to keep changes needed for
soc-camera support to an absolute minimum as I don't have access to
the other hardware that uses this driver.  So Jonathan / Hans,
would adding a call to ov7670_init inside s_fmt be alright with you?

The solution works, but seems like overkill to me, if soc-camera is
going to make a call to reset whilst other users don't then things
are going to get a little unpredictable.

> 
> (isn't this a job for runtime-pm?...)
Probably, but in that case you would have relevant call back in place
to ensure that all relevant registers were in place (rather than putting
it in the fmt setting code). I'm guessing moving over to that might leave
a lot of broken drivers.

For reference, current patch (against v4l-next of yesterday) is below.

Thanks,

Jonathan

---

diff --git a/drivers/media/video/ov7670.c b/drivers/media/video/ov7670.c
index 0e2184e..3f80932 100644
--- a/drivers/media/video/ov7670.c
+++ b/drivers/media/video/ov7670.c
@@ -19,6 +19,7 @@
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-i2c-drv.h>
 
+#include <media/soc_camera.h>
 
 MODULE_AUTHOR("Jonathan Corbet <corbet@lwn.net>");
 MODULE_DESCRIPTION("A low-level driver for OmniVision ov7670 sensors");
@@ -745,6 +746,10 @@ static int ov7670_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *fmt)
 	struct ov7670_info *info = to_state(sd);
 	unsigned char com7, clkrc = 0;
 
+	ret = ov7670_init(sd, 0);
+	if (ret)
+		return ret;
+
 	ret = ov7670_try_fmt_internal(sd, fmt, &ovfmt, &wsize);
 	if (ret)
 		return ret;
@@ -1239,6 +1244,43 @@ static const struct v4l2_subdev_ops ov7670_ops = {
 };
 
 /* ----------------------------------------------------------------------- */
+#ifdef CONFIG_SOC_CAMERA
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
+#endif
 
 static int ov7670_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
@@ -1246,7 +1288,18 @@ static int ov7670_probe(struct i2c_client *client,
 	struct v4l2_subdev *sd;
 	struct ov7670_info *info;
 	int ret;
+#ifdef CONFIG_SOC_CAMERA
+	struct soc_camera_device *icd = client->dev.platform_data;
 
+	if (!icd) {
+		dev_err(&client->dev, "OV7670: missing soc-camera data!\n");
+		return -EINVAL;
+	}
+
+	icd->ops = &ov7670_soc_ops;
+	icd->formats = ov7670_soc_fmt_lists;
+	icd->num_formats = ARRAY_SIZE(ov7670_soc_fmt_lists);
+#endif
 	info = kzalloc(sizeof(struct ov7670_info), GFP_KERNEL);
 	if (info == NULL)
 		return -ENOMEM;



