Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f197.google.com ([209.85.210.197]:62887 "EHLO
	mail-yx0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbZGTXyF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2009 19:54:05 -0400
Received: by yxe35 with SMTP id 35so309086yxe.33
        for <linux-media@vger.kernel.org>; Mon, 20 Jul 2009 16:54:05 -0700 (PDT)
From: Lamarque Vieira Souza <lamarque@gmail.com>
To: Antoine Jacquet <royale@zerezo.com>
Subject: [PATCH] Implement changing resolution on the fly for zr364xx driver
Date: Mon, 20 Jul 2009 20:46:42 -0300
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, video4linux-list@redhat.com
References: <200907152054.56581.lamarque@gmail.com>
In-Reply-To: <200907152054.56581.lamarque@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907202046.43194.lamarque@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

	This patch implements changing resolution in zr364xx_vidioc_s_fmt_vid_cap for 
zr364xx driver. This version is synced with v4l-dvb as of 20/Jul/2009. Tested 
with Creative PC-CAM 880.

OBS: I had to increase MAX_FRAME_SIZE to prevent a hard crash in my notebook 
(caps lock blinking) when testing with mplayer, which automatically sets 
resolution to the maximum (640x480). Maybe we should add code to auto-detect 
frame size to prevent this kind of crash in the future.

Signed-off-by: Lamarque V. Souza <lamarque@gmail.com>
---

diff -r 1cb6f19d2c9d linux/drivers/media/video/zr364xx.c
--- a/linux/drivers/media/video/zr364xx.c	Sun Jul 19 18:03:23 2009 -0300
+++ b/linux/drivers/media/video/zr364xx.c	Mon Jul 20 20:20:21 2009 -0300
@@ -43,14 +43,14 @@
 
 /* Version Information */
 #define DRIVER_VERSION "v0.73"
-#define ZR364_VERSION_CODE KERNEL_VERSION(0, 7, 3)
+#define ZR364XX_VERSION_CODE KERNEL_VERSION(0, 7, 3)
 #define DRIVER_AUTHOR "Antoine Jacquet, http://royale.zerezo.com/"
 #define DRIVER_DESC "Zoran 364xx"
 
 
 /* Camera */
 #define FRAMES 1
-#define MAX_FRAME_SIZE 100000
+#define MAX_FRAME_SIZE 200000
 #define BUFFER_SIZE 0x1000
 #define CTRL_TIMEOUT 500
 
@@ -734,7 +734,7 @@
 	strlcpy(cap->card, cam->udev->product, sizeof(cap->card));
 	strlcpy(cap->bus_info, dev_name(&cam->udev->dev),
 		sizeof(cap->bus_info));
-	cap->version = ZR364_VERSION_CODE;
+	cap->version = ZR364XX_VERSION_CODE;
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE |
 			    V4L2_CAP_READWRITE |
 			    V4L2_CAP_STREAMING;
@@ -874,9 +874,14 @@
 		return -EINVAL;
 	}
 
+	if (!(f->fmt.pix.width == 160 && f->fmt.pix.height == 120) &&
+	    !(f->fmt.pix.width == 640 && f->fmt.pix.height == 480)) {
+		f->fmt.pix.width = 320;
+		f->fmt.pix.height = 240;
+	}
+
 	f->fmt.pix.field = V4L2_FIELD_NONE;
-	f->fmt.pix.width = cam->width;
-	f->fmt.pix.height = cam->height;
+	f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	f->fmt.pix.bytesperline = f->fmt.pix.width * 2;
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 	f->fmt.pix.colorspace = 0;
@@ -907,7 +912,6 @@
 	return 0;
 }
 
-/* Lamarque TODO: implement changing resolution on the fly */
 static int zr364xx_vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 				    struct v4l2_format *f)
 {
@@ -915,6 +919,7 @@
 	struct videobuf_queue *q = &cam->vb_vidq;
 	char pixelformat_name[5];
 	int ret = zr364xx_vidioc_try_fmt_vid_cap(file, cam, f);
+	int i;
 
 	if (ret < 0)
 		return ret;
@@ -927,15 +932,55 @@
 		goto out;
 	}
 
-	f->fmt.pix.field = V4L2_FIELD_NONE;
-	f->fmt.pix.width = cam->width;
-	f->fmt.pix.height = cam->height;
+	if (res_check(cam)) {
+		DBG("%s can't change format after started\n", __func__);
+		ret = -EBUSY;
+		goto out;
+	}
+
+	cam->width = f->fmt.pix.width;
+	cam->height = f->fmt.pix.height;
+	dev_info(&cam->udev->dev, "%s: %dx%d mode selected\n", __func__,
+		 cam->width, cam->height);
 	f->fmt.pix.bytesperline = f->fmt.pix.width * 2;
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 	f->fmt.pix.colorspace = 0;
 	f->fmt.pix.priv = 0;
 	cam->vb_vidq.field = f->fmt.pix.field;
 	cam->mode.color = V4L2_PIX_FMT_JPEG;
+
+	if (f->fmt.pix.width == 160 && f->fmt.pix.height == 120)
+		mode = 1;
+	else if (f->fmt.pix.width == 640 && f->fmt.pix.height == 480)
+		mode = 2;
+	else
+		mode = 0;
+
+	m0d1[0] = mode;
+	m1[2].value = 0xf000 + mode;
+	m2[1].value = 0xf000 + mode;
+	header2[437] = cam->height / 256;
+	header2[438] = cam->height % 256;
+	header2[439] = cam->width / 256;
+	header2[440] = cam->width % 256;
+
+	for (i = 0; init[cam->method][i].size != -1; i++) {
+		ret =
+		    send_control_msg(cam->udev, 1, init[cam->method][i].value,
+				     0, init[cam->method][i].bytes,
+				     init[cam->method][i].size);
+		if (ret < 0) {
+			dev_err(&cam->udev->dev,
+			   "error during resolution change sequence: %d\n", i);
+			goto out;
+		}
+	}
+
+	/* Added some delay here, since opening/closing the camera quickly,
+	 * like Ekiga does during its startup, can crash the webcam
+	 */
+	mdelay(100);
+	cam->skip = 2;
 	ret = 0;
 
 out:
@@ -1123,6 +1168,7 @@
 		cam->buffer.frame[j].ulState = ZR364XX_READ_IDLE;
 		cam->buffer.frame[j].cur_size = 0;
 	}
+	cam->b_acquire = 1;
 	return 0;
 }
 
@@ -1165,7 +1211,6 @@
 	res = videobuf_streamon(&cam->vb_vidq);
 	if (res == 0) {
 		zr364xx_start_acquire(cam);
-		cam->b_acquire = 1;
 	} else {
 		res_free(cam);
 	}

