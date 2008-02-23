Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1NNxlhF017256
	for <video4linux-list@redhat.com>; Sat, 23 Feb 2008 18:59:47 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m1NNxFBh025866
	for <video4linux-list@redhat.com>; Sat, 23 Feb 2008 18:59:15 -0500
Date: Sun, 24 Feb 2008 00:59:23 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0802240055140.4445@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] Fix advertised pixel formats in mt9m001 and mt9v022
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Only advertise pixel formats, that we actually can support in the
present configuration.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

---

This is an incremental patch for v4l-dvb/devel

Thanks
Guennadi

diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index e3afc82..4ad8343 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -44,15 +44,23 @@
 #define MT9M001_CHIP_ENABLE		0xF1
 
 static const struct soc_camera_data_format mt9m001_colour_formats[] = {
+	/* Order important: first natively supported,
+	 * second supported with a GPIO extender */
 	{
-		.name		= "RGB Bayer (sRGB)",
-		.depth		= 16,
+		.name		= "Bayer (sRGB) 10 bit",
+		.depth		= 10,
+		.fourcc		= V4L2_PIX_FMT_SBGGR16,
+		.colorspace	= V4L2_COLORSPACE_SRGB,
+	}, {
+		.name		= "Bayer (sRGB) 8 bit",
+		.depth		= 8,
 		.fourcc		= V4L2_PIX_FMT_SBGGR8,
 		.colorspace	= V4L2_COLORSPACE_SRGB,
 	}
 };
 
 static const struct soc_camera_data_format mt9m001_monochrome_formats[] = {
+	/* Order important - see above */
 	{
 		.name		= "Monochrome 10 bit",
 		.depth		= 10,
@@ -547,7 +555,10 @@ static int mt9m001_video_probe(struct soc_camera_device *icd)
 	case 0x8421:
 		mt9m001->model = V4L2_IDENT_MT9M001C12ST;
 		mt9m001_ops.formats = mt9m001_colour_formats;
-		mt9m001_ops.num_formats = ARRAY_SIZE(mt9m001_colour_formats);
+		if (mt9m001->client->dev.platform_data)
+			mt9m001_ops.num_formats = ARRAY_SIZE(mt9m001_colour_formats);
+		else
+			mt9m001_ops.num_formats = 1;
 		break;
 	case 0x8431:
 		mt9m001->model = V4L2_IDENT_MT9M001C12STM;
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index 4683339..d677344 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -59,18 +59,25 @@ MODULE_PARM_DESC(sensor_type, "Sensor type: \"colour\" or \"monochrome\"\n");
 /* Progressive scan, master, defaults */
 #define MT9V022_CHIP_CONTROL_DEFAULT	0x188
 
-static const struct soc_camera_data_format mt9v022_formats[] = {
+static const struct soc_camera_data_format mt9v022_colour_formats[] = {
+	/* Order important: first natively supported,
+	 * second supported with a GPIO extender */
 	{
-		.name		= "RGB Bayer (sRGB)",
-		.depth		= 8,
-		.fourcc		= V4L2_PIX_FMT_SBGGR8,
-		.colorspace	= V4L2_COLORSPACE_SRGB,
-	}, {
-		.name		= "RGB Bayer (sRGB)",
+		.name		= "Bayer (sRGB) 10 bit",
 		.depth		= 10,
 		.fourcc		= V4L2_PIX_FMT_SBGGR16,
 		.colorspace	= V4L2_COLORSPACE_SRGB,
 	}, {
+		.name		= "Bayer (sRGB) 8 bit",
+		.depth		= 8,
+		.fourcc		= V4L2_PIX_FMT_SBGGR8,
+		.colorspace	= V4L2_COLORSPACE_SRGB,
+	}
+};
+
+static const struct soc_camera_data_format mt9v022_monochrome_formats[] = {
+	/* Order important - see above */
+	{
 		.name		= "Monochrome 10 bit",
 		.depth		= 10,
 		.fourcc		= V4L2_PIX_FMT_Y16,
@@ -486,8 +493,8 @@ static struct soc_camera_ops mt9v022_ops = {
 	.stop_capture		= mt9v022_stop_capture,
 	.set_capture_format	= mt9v022_set_capture_format,
 	.try_fmt_cap		= mt9v022_try_fmt_cap,
-	.formats		= mt9v022_formats,
-	.num_formats		= ARRAY_SIZE(mt9v022_formats),
+	.formats		= NULL, /* Filled in later depending on the */
+	.num_formats		= 0,	/* sensor type and data widths */
 	.get_datawidth		= mt9v022_get_datawidth,
 	.controls		= mt9v022_controls,
 	.num_controls		= ARRAY_SIZE(mt9v022_controls),
@@ -671,9 +678,19 @@ static int mt9v022_video_probe(struct soc_camera_device *icd)
 			    !strcmp("color", sensor_type))) {
 		ret = reg_write(icd, MT9V022_PIXEL_OPERATION_MODE, 4 | 0x11);
 		mt9v022->model = V4L2_IDENT_MT9V022IX7ATC;
+		mt9v022_ops.formats = mt9v022_colour_formats;
+		if (mt9v022->client->dev.platform_data)
+			mt9v022_ops.num_formats = ARRAY_SIZE(mt9v022_colour_formats);
+		else
+			mt9v022_ops.num_formats = 1;
 	} else {
 		ret = reg_write(icd, MT9V022_PIXEL_OPERATION_MODE, 0x11);
 		mt9v022->model = V4L2_IDENT_MT9V022IX7ATM;
+		mt9v022_ops.formats = mt9v022_monochrome_formats;
+		if (mt9v022->client->dev.platform_data)
+			mt9v022_ops.num_formats = ARRAY_SIZE(mt9v022_monochrome_formats);
+		else
+			mt9v022_ops.num_formats = 1;
 	}
 
 	if (ret >= 0)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
