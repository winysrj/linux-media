Return-path: <mchehab@pedra>
Received: from gateway09.websitewelcome.com ([67.18.144.14]:44479 "HELO
	gateway09.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754865Ab1DDSXF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Apr 2011 14:23:05 -0400
Received: from [50.39.76.146] (port=17275 helo=[10.140.5.32])
	by gator886.hostgator.com with esmtp (Exim 4.69)
	(envelope-from <linux-dev@sensoray.com>)
	id 1Q6oQZ-0001md-NN
	for linux-media@vger.kernel.org; Mon, 04 Apr 2011 13:23:03 -0500
Message-ID: <4D9A0C87.40309@sensoray.com>
Date: Mon, 04 Apr 2011 11:23:03 -0700
From: Sensoray Linux Development <linux-dev@sensoray.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] [media] s2255drv: jpeg enable module parameter
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Adding jpeg enable module parameter.

Signed-off-by: Dean Anderson <linux-dev@sensoray.com>

---
 drivers/media/video/s2255drv.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index 38e5c4b..eb33e1e 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -389,12 +389,17 @@ static unsigned int vid_limit = 16;    /* Video memory limit, in Mb */
 /* start video number */
 static int video_nr = -1;    /* /dev/videoN, -1 for autodetect */
 
+/* Enable jpeg capture. */
+static int jpeg_enable = 1;
+
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Debug level(0-100) default 0");
 module_param(vid_limit, int, 0644);
 MODULE_PARM_DESC(vid_limit, "video memory limit(Mb)");
 module_param(video_nr, int, 0644);
 MODULE_PARM_DESC(video_nr, "start video minor(-1 default autodetect)");
+module_param(jpeg_enable, int, 0644);
+MODULE_PARM_DESC(jpeg_enable, "Jpeg enable(1-on 0-off) default 1");
 
 /* USB device table */
 #define USB_SENSORAY_VID    0x1943
@@ -408,6 +413,7 @@ MODULE_DEVICE_TABLE(usb, s2255_table);
 #define BUFFER_TIMEOUT msecs_to_jiffies(400)
 
 /* image formats.  */
+/* JPEG formats must be defined last to support jpeg_enable parameter */
 static const struct s2255_fmt formats[] = {
     {
         .name = "4:2:2, planar, YUV422P",
@@ -424,6 +430,10 @@ static const struct s2255_fmt formats[] = {
         .fourcc = V4L2_PIX_FMT_UYVY,
         .depth = 16
     }, {
+        .name = "8bpp GREY",
+        .fourcc = V4L2_PIX_FMT_GREY,
+        .depth = 8
+    }, {
         .name = "JPG",
         .fourcc = V4L2_PIX_FMT_JPEG,
         .depth = 24
@@ -431,10 +441,6 @@ static const struct s2255_fmt formats[] = {
         .name = "MJPG",
         .fourcc = V4L2_PIX_FMT_MJPEG,
         .depth = 24
-    }, {
-        .name = "8bpp GREY",
-        .fourcc = V4L2_PIX_FMT_GREY,
-        .depth = 8
     }
 };
 
@@ -609,6 +615,9 @@ static const struct s2255_fmt *format_by_fourcc(int fourcc)
     for (i = 0; i < ARRAY_SIZE(formats); i++) {
         if (-1 == formats[i].fourcc)
             continue;
+        if (!jpeg_enable && ((formats[i].fourcc == V4L2_PIX_FMT_JPEG) ||
+                     (formats[i].fourcc == V4L2_PIX_FMT_MJPEG)))
+            continue;
         if (formats[i].fourcc == fourcc)
             return formats + i;
     }
@@ -856,7 +865,9 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
 
     if (index >= ARRAY_SIZE(formats))
         return -EINVAL;
-
+    if (!jpeg_enable && ((formats[index].fourcc == V4L2_PIX_FMT_JPEG) ||
+                 (formats[index].fourcc == V4L2_PIX_FMT_MJPEG)))
+        return -EINVAL;
     dprintk(4, "name %s\n", formats[index].name);
     strlcpy(f->description, formats[index].name, sizeof(f->description));
     f->pixelformat = formats[index].fourcc;
-- 
1.7.0.4


