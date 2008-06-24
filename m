Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5OKhV6F012001
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 16:43:31 -0400
Received: from yx-out-2324.google.com (yx-out-2324.google.com [74.125.44.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5OKhHvw020124
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 16:43:17 -0400
Received: by yx-out-2324.google.com with SMTP id 3so511520yxj.81
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 13:43:17 -0700 (PDT)
From: Daniel Drake <dsd@laptop.org>
To: video4linux-list@redhat.com
Content-Type: multipart/mixed; boundary="=-agFdycFWlZF2Hr/NQR85"
Date: Tue, 24 Jun 2008 16:43:06 -0400
Message-Id: <1214340186.12907.10.camel@olpc-desktop01.laptop.org>
Mime-Version: 1.0
Subject: v4l2 TRY_FMT/S_FMT field semantics
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


--=-agFdycFWlZF2Hr/NQR85
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

[I posted some mails which are held up in the moderation queue, feel
free to discard them now that I'm subscribed and reposting here]

There seems to be variance in driver behaviour for the situation when an
unsupported video field is requested through S_FMT/TRY_FMT. Some drivers
(e.g. zr364xx, ov7670) return -EINVAL from the ioctl implementation,
whereas others (e.g. stk-webcam) just ignore the user input and return a
supported field.

I believe the latter is correct (ignore user input, don't return error)
based on the documentation:
http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec-single/v4l2.html#VIDIOC-G-FMT
"Drivers should not return an error code unless the input is ambiguous"
"Very simple, inflexible devices may even ignore all input and always
return the default parameters."
"When the requested buffer type is not supported drivers return an
EINVAL error code."
i.e. returning errors for unsupported fields is bad, and it's ok to
unconditionally overwrite user-requested settings

I'm attaching a quick patch to fix up a few drivers, if this is
acknowledged/accepted I will produce another patch based on a more
exhaustive search.

Background: here at OLPC have to patch gstreamer-plugins-good for the XO
laptop (which uses the ov7670 v4l2 driver): gstreamer always requests
interlaced video, but ov7670 returns -EINVAL if this is requested.
﻿http://dev.laptop.org/attachment/ticket/7294/v4l2-nointerlace.patch

We would like to fix gstreamer properly so that we can drop our fork,
but further investigation leads me to believe that this is a kernel bug:
ov7670 should fix up the requested field, and gstreamer should check the
returned settings (if it does not do so already).

Daniel


--=-agFdycFWlZF2Hr/NQR85
Content-Disposition: attachment; filename=v4l-ioctl-semantics.txt
Content-Type: message/rfc822; name=v4l-ioctl-semantics.txt

From: Daniel Drake <dsd@laptop.org>
To: mchehab@infradead.org
Cc: video4linux-list@redhat.com
Subject: [PATCH] try_fmt/s_fmt semantics fixups
Date: Tue, 24 Jun 2008 16:42:46 -0400
Message-Id: <1214340166.12907.9.camel@olpc-desktop01.laptop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

Here are a bunch of changes to make drivers more conformant with the
documented user-level ioctl API: drivers should not return an error code for
S_FMT/TRY_FMT  unless the input is ambiguous, and it is legal for drivers to
ignore input and return their supported settings only.

If this is corrected or acknowledged I'll write a more exhaustive patch
(I'm sure I missed a few drivers).

Signed-off-by: Daniel Drake <dsd@laptop.org>

diff --git a/drivers/media/video/meye.c b/drivers/media/video/meye.c
index e7ccbc8..6379b1b 100644
--- a/drivers/media/video/meye.c
+++ b/drivers/media/video/meye.c
@@ -1291,11 +1291,7 @@ static int vidioc_try_fmt_cap(struct file *file, void *fh,
 
 	if (f->fmt.pix.pixelformat != V4L2_PIX_FMT_YUYV &&
 	    f->fmt.pix.pixelformat != V4L2_PIX_FMT_MJPEG)
-		return -EINVAL;
-
-	if (f->fmt.pix.field != V4L2_FIELD_ANY &&
-	    f->fmt.pix.field != V4L2_FIELD_NONE)
-		return -EINVAL;
+		f->fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
 
 	f->fmt.pix.field = V4L2_FIELD_NONE;
 
@@ -1353,11 +1349,7 @@ static int vidioc_s_fmt_cap(struct file *file, void *fh, struct v4l2_format *f)
 
 	if (f->fmt.pix.pixelformat != V4L2_PIX_FMT_YUYV &&
 	    f->fmt.pix.pixelformat != V4L2_PIX_FMT_MJPEG)
-		return -EINVAL;
-
-	if (f->fmt.pix.field != V4L2_FIELD_ANY &&
-	    f->fmt.pix.field != V4L2_FIELD_NONE)
-		return -EINVAL;
+		f->fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
 
 	f->fmt.pix.field = V4L2_FIELD_NONE;
 	mutex_lock(&meye.lock);
diff --git a/drivers/media/video/ov7670.c b/drivers/media/video/ov7670.c
index 2bc6bdc..f201af2 100644
--- a/drivers/media/video/ov7670.c
+++ b/drivers/media/video/ov7670.c
@@ -680,17 +680,17 @@ static int ov7670_try_fmt(struct i2c_client *c, struct v4l2_format *fmt,
 	for (index = 0; index < N_OV7670_FMTS; index++)
 		if (ov7670_formats[index].pixelformat == pix->pixelformat)
 			break;
-	if (index >= N_OV7670_FMTS)
-		return -EINVAL;
+	if (index >= N_OV7670_FMTS) {
+		/* default to first format */
+		index = 0;
+		pix->pixelformat = ov7670_formats[0].pixelformat;
+	}
 	if (ret_fmt != NULL)
 		*ret_fmt = ov7670_formats + index;
 	/*
 	 * Fields: the OV devices claim to be progressive.
 	 */
-	if (pix->field == V4L2_FIELD_ANY)
-		pix->field = V4L2_FIELD_NONE;
-	else if (pix->field != V4L2_FIELD_NONE)
-		return -EINVAL;
+	pix->field = V4L2_FIELD_NONE;
 	/*
 	 * Round requested image size down to the nearest
 	 * we support, but not below the smallest.
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index a1b9244..6f4c116 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -51,29 +51,28 @@ static int soc_camera_try_fmt_cap(struct file *file, void *priv,
 	struct soc_camera_device *icd = icf->icd;
 	struct soc_camera_host *ici =
 		to_soc_camera_host(icd->dev.parent);
-	enum v4l2_field field;
 	const struct soc_camera_data_format *fmt;
 	int ret;
 
 	WARN_ON(priv != file->private_data);
 
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		dev_warn(&icd->dev, "Attention! Wrong buf-type %d\n",
+			 f->type);
+		return -EINVAL;
+	}
+
 	fmt = format_by_fourcc(icd, f->fmt.pix.pixelformat);
 	if (!fmt) {
 		dev_dbg(&icd->dev, "invalid format 0x%08x\n",
 			f->fmt.pix.pixelformat);
-		return -EINVAL;
+		fmt = &icd->formats[0];
+		f->fmt.pix.pixelformat = fmt->fourcc;
 	}
 
 	dev_dbg(&icd->dev, "fmt: 0x%08x\n", fmt->fourcc);
 
-	field = f->fmt.pix.field;
-
-	if (field == V4L2_FIELD_ANY) {
-		field = V4L2_FIELD_NONE;
-	} else if (V4L2_FIELD_NONE != field) {
-		dev_err(&icd->dev, "Field type invalid.\n");
-		return -EINVAL;
-	}
+	f->fmt.pix.field = V4L2_FIELD_ANY;
 
 	/* test physical bus parameters */
 	ret = ici->ops->try_bus_param(icd, f->fmt.pix.pixelformat);
@@ -84,7 +83,6 @@ static int soc_camera_try_fmt_cap(struct file *file, void *priv,
 	ret = ici->ops->try_fmt_cap(icd, f);
 
 	/* calculate missing fields */
-	f->fmt.pix.field = field;
 	f->fmt.pix.bytesperline =
 		(f->fmt.pix.width * fmt->depth) >> 3;
 	f->fmt.pix.sizeimage =
@@ -356,8 +354,10 @@ static int soc_camera_s_fmt_cap(struct file *file, void *priv,
 	WARN_ON(priv != file->private_data);
 
 	data_fmt = format_by_fourcc(icd, f->fmt.pix.pixelformat);
-	if (!data_fmt)
-		return -EINVAL;
+	if (!data_fmt) {
+		data_fmt = &icd->formats[0];
+		f->fmt.pix.pixelformat = data_fmt->fourcc;
+	}
 
 	/* buswidth may be further adjusted by the ici */
 	icd->buswidth = data_fmt->depth;
@@ -378,9 +378,6 @@ static int soc_camera_s_fmt_cap(struct file *file, void *priv,
 	icd->width		= rect.width;
 	icd->height		= rect.height;
 	icf->vb_vidq.field	= f->fmt.pix.field;
-	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != f->type)
-		dev_warn(&icd->dev, "Attention! Wrong buf-type %d\n",
-			 f->type);
 
 	dev_dbg(&icd->dev, "set width: %d height: %d\n",
 		icd->width, icd->height);
diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index b12c60c..da1fb9e 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -1066,7 +1066,7 @@ static int stk_vidioc_try_fmt_cap(struct file *filp,
 	case V4L2_PIX_FMT_SBGGR8:
 		break;
 	default:
-		return -EINVAL;
+		fmtd->fmt.pix.pixelformat = V4L2_PIX_FMT_RGB565;
 	}
 	for (i = 1; i < ARRAY_SIZE(stk_sizes); i++) {
 		if (fmtd->fmt.pix.width > stk_sizes[i].w)
diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 845be18..3a47d30 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -670,18 +670,12 @@ static int vidioc_try_fmt_cap(struct file *file, void *priv,
 		dprintk(dev, 1, "Fourcc format (0x%08x) invalid. "
 			"Driver accepts only 0x%08x\n",
 			f->fmt.pix.pixelformat, format.fourcc);
-		return -EINVAL;
+		f->fmt.pix.pixelformat = format.fourcc;
 	}
 	fmt = &format;
 
 	field = f->fmt.pix.field;
-
-	if (field == V4L2_FIELD_ANY) {
-		field = V4L2_FIELD_INTERLACED;
-	} else if (V4L2_FIELD_INTERLACED != field) {
-		dprintk(dev, 1, "Field type invalid.\n");
-		return -EINVAL;
-	}
+	field = V4L2_FIELD_INTERLACED;
 
 	maxw  = norm_maxw();
 	maxh  = norm_maxh();
diff --git a/drivers/media/video/zoran_driver.c b/drivers/media/video/zoran_driver.c
index 5394d7a..ac2380f 100644
--- a/drivers/media/video/zoran_driver.c
+++ b/drivers/media/video/zoran_driver.c
@@ -2837,22 +2837,19 @@ zoran_do_ioctl (struct inode *inode,
 				dprintk(5,
 					KERN_ERR "%s: bpl not supported\n",
 					ZR_DEVNAME(zr));
-				return -EINVAL;
+				fmt->fmt.pix.bytesperline = 0;
 			}
 
 			/* we can be requested to do JPEG/raw playback/capture */
-			if (!
-			    (fmt->type == V4L2_BUF_TYPE_VIDEO_CAPTURE ||
-			     (fmt->type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
-			      fmt->fmt.pix.pixelformat ==
-			      V4L2_PIX_FMT_MJPEG))) {
+			if (fmt->type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
+			    fmt->fmt.pix.pixelformat != V4L2_PIX_FMT_MJPEG) {
 				dprintk(1,
 					KERN_ERR
 					"%s: VIDIOC_S_FMT - unknown type %d/0x%x(%4.4s) combination\n",
 					ZR_DEVNAME(zr), fmt->type,
 					fmt->fmt.pix.pixelformat,
 					(char *) &printformat);
-				return -EINVAL;
+				fmt->fmt.pix.pixelformat = V4L2_PIX_FMT_MJPEG;
 			}
 
 			if (fmt->fmt.pix.pixelformat == V4L2_PIX_FMT_MJPEG) {
@@ -2947,7 +2944,8 @@ zoran_do_ioctl (struct inode *inode,
 						ZR_DEVNAME(zr),
 						fmt->fmt.pix.pixelformat,
 						(char *) &printformat);
-					return -EINVAL;
+					fmt->fmt.pix.pixelformat =
+						zoran_formats[0].fourcc;
 				}
 				mutex_lock(&zr->resource_lock);
 				if (fh->jpg_buffers.allocated ||
@@ -4088,8 +4086,7 @@ zoran_do_ioctl (struct inode *inode,
 
 		case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 		case V4L2_BUF_TYPE_VIDEO_OUTPUT:
-			if (fmt->fmt.pix.bytesperline > 0)
-				return -EINVAL;
+			fmt->fmt.pix.bytesperline = 0;
 
 			mutex_lock(&zr->resource_lock);
 
@@ -4154,10 +4151,9 @@ zoran_do_ioctl (struct inode *inode,
 					if (zoran_formats[i].fourcc ==
 					    fmt->fmt.pix.pixelformat)
 						break;
-				if (i == NUM_FORMATS) {
-					res = -EINVAL;
-					goto tryfmt_unlock_and_return;
-				}
+				if (i == NUM_FORMATS)
+					fmt->fmt.pix.pixelformat =
+						zoran_formats[0].fourcc;
 
 				if (fmt->fmt.pix.width > BUZ_MAX_WIDTH)
 					fmt->fmt.pix.width = BUZ_MAX_WIDTH;
diff --git a/drivers/media/video/zr364xx.c b/drivers/media/video/zr364xx.c
index a0e49dc..83fa17a 100644
--- a/drivers/media/video/zr364xx.c
+++ b/drivers/media/video/zr364xx.c
@@ -549,11 +549,7 @@ static int zr364xx_vidioc_try_fmt_cap(struct file *file, void *priv,
 
 	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
-	if (f->fmt.pix.pixelformat != V4L2_PIX_FMT_JPEG)
-		return -EINVAL;
-	if (f->fmt.pix.field != V4L2_FIELD_ANY &&
-	    f->fmt.pix.field != V4L2_FIELD_NONE)
-		return -EINVAL;
+	f->fmt.pix.pixelformat = V4L2_PIX_FMT_JPEG;
 	f->fmt.pix.field = V4L2_FIELD_NONE;
 	f->fmt.pix.width = cam->width;
 	f->fmt.pix.height = cam->height;
@@ -601,11 +597,7 @@ static int zr364xx_vidioc_s_fmt_cap(struct file *file, void *priv,
 
 	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
-	if (f->fmt.pix.pixelformat != V4L2_PIX_FMT_JPEG)
-		return -EINVAL;
-	if (f->fmt.pix.field != V4L2_FIELD_ANY &&
-	    f->fmt.pix.field != V4L2_FIELD_NONE)
-		return -EINVAL;
+	f->fmt.pix.pixelformat = V4L2_PIX_FMT_JPEG;
 	f->fmt.pix.field = V4L2_FIELD_NONE;
 	f->fmt.pix.width = cam->width;
 	f->fmt.pix.height = cam->height;

--=-agFdycFWlZF2Hr/NQR85
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=-agFdycFWlZF2Hr/NQR85--
