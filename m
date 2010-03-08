Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway09.websitewelcome.com ([69.93.179.27]:36916 "HELO
	gateway09.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756223Ab0CIAvc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Mar 2010 19:51:32 -0500
Received: from [66.15.212.169] (port=24034 helo=[10.140.5.13])
	by gator886.hostgator.com with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <dean@sensoray.com>)
	id 1Nom0I-0002W7-84
	for linux-media@vger.kernel.org; Mon, 08 Mar 2010 17:04:50 -0600
Date: Mon, 8 Mar 2010 15:04:48 -0800 (PST)
From: "Dean A." <dean@sensoray.com>
Subject: [PATCH] s2255drv: support for frame skipping
To: linux-media@vger.kernel.org
Message-ID: <tkrat.bdcfbe49c59f68a6@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Dean Anderson <dean@sensoray.com>
# Date 1268089334 28800
# Node ID 3ac8a7637cf3db984665e5aa43e03c22ee0c16f2
# Parent  08932f075cb147c47e2acc4b1f464c736080bc96
s2255drv: frame decimation support

From: Dean Anderson <dean@sensoray.com>

adds hardware frame skipping using VIDIOC_S_PARM ioctl.
adds support for VIDIOC_ENUM_FRAMEINTERVALS.

Priority: normal

Signed-off-by: Dean Anderson <dean@sensoray.com>

diff -r 08932f075cb1 -r 3ac8a7637cf3 linux/drivers/media/video/s2255drv.c
--- a/linux/drivers/media/video/s2255drv.c	Fri Mar 05 14:55:23 2010 -0800
+++ b/linux/drivers/media/video/s2255drv.c	Mon Mar 08 15:02:14 2010 -0800
@@ -1427,11 +1427,19 @@
 	}
 	mode = &fh->mode;
 	if (*i & V4L2_STD_NTSC) {
-		dprintk(4, "vidioc_s_std NTSC\n");
-		mode->format = FORMAT_NTSC;
+		dprintk(4, "%s NTSC\n", __func__);
+		/* if changing format, reset frame decimation/intervals */
+		if (mode->format != FORMAT_NTSC) {
+			mode->format = FORMAT_NTSC;
+			mode->fdec = FDEC_1;
+		}
 	} else if (*i & V4L2_STD_PAL) {
-		dprintk(4, "vidioc_s_std PAL\n");
+		dprintk(4, "%s PAL\n", __func__);
 		mode->format = FORMAT_PAL;
+		if (mode->format != FORMAT_PAL) {
+			mode->format = FORMAT_PAL;
+			mode->fdec = FDEC_1;
+		}
 	} else {
 		ret = -EINVAL;
 	}
@@ -1633,10 +1641,34 @@
 {
 	struct s2255_fh *fh = priv;
 	struct s2255_dev *dev = fh->dev;
+	__u32 def_num, def_dem;
 	if (sp->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
+	memset(sp, 0, sizeof(struct v4l2_streamparm));
+	sp->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
 	sp->parm.capture.capturemode = dev->cap_parm[fh->channel].capturemode;
-	dprintk(2, "getting parm %d\n", sp->parm.capture.capturemode);
+	def_num = (fh->mode.format == FORMAT_NTSC) ? 1001 : 1000;
+	def_dem = (fh->mode.format == FORMAT_NTSC) ? 30000 : 25000;
+	sp->parm.capture.timeperframe.denominator = def_dem;
+	switch (fh->mode.fdec) {
+	default:
+	case FDEC_1:
+		sp->parm.capture.timeperframe.numerator = def_num;
+		break;
+	case FDEC_2:
+		sp->parm.capture.timeperframe.numerator = def_num * 2;
+		break;
+	case FDEC_3:
+		sp->parm.capture.timeperframe.numerator = def_num * 3;
+		break;
+	case FDEC_5:
+		sp->parm.capture.timeperframe.numerator = def_num * 5;
+		break;
+	}
+	dprintk(4, "%s capture mode, %d timeperframe %d/%d\n", __func__,
+		sp->parm.capture.capturemode,
+		sp->parm.capture.timeperframe.numerator,
+		sp->parm.capture.timeperframe.denominator);
 	return 0;
 }
 
@@ -1645,15 +1677,79 @@
 {
 	struct s2255_fh *fh = priv;
 	struct s2255_dev *dev = fh->dev;
-
+	int fdec = FDEC_1;
+	__u32 def_num, def_dem;
 	if (sp->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
-
-	dev->cap_parm[fh->channel].capturemode = sp->parm.capture.capturemode;
-	dprintk(2, "setting param capture mode %d\n",
-		sp->parm.capture.capturemode);
+	/* high quality capture mode requires a stream restart */
+	if (dev->cap_parm[fh->channel].capturemode
+	    != sp->parm.capture.capturemode && res_locked(fh->dev, fh))
+		return -EBUSY;
+	def_num = (fh->mode.format == FORMAT_NTSC) ? 1001 : 1000;
+	def_dem = (fh->mode.format == FORMAT_NTSC) ? 30000 : 25000;
+	if (def_dem != sp->parm.capture.timeperframe.denominator)
+		sp->parm.capture.timeperframe.numerator = def_num;
+	else if (sp->parm.capture.timeperframe.numerator <= def_num)
+		sp->parm.capture.timeperframe.numerator = def_num;
+	else if (sp->parm.capture.timeperframe.numerator <= (def_num * 2)) {
+		sp->parm.capture.timeperframe.numerator = def_num * 2;
+		fdec = FDEC_2;
+	} else if (sp->parm.capture.timeperframe.numerator <= (def_num * 3)) {
+		sp->parm.capture.timeperframe.numerator = def_num * 3;
+		fdec = FDEC_3;
+	} else {
+		sp->parm.capture.timeperframe.numerator = def_num * 5;
+		fdec = FDEC_5;
+	}
+	fh->mode.fdec = fdec;
+	sp->parm.capture.timeperframe.denominator = def_dem;
+	s2255_set_mode(dev, fh->channel, &fh->mode);
+	dprintk(4, "%s capture mode, %d timeperframe %d/%d, fdec %d\n",
+		__func__,
+		sp->parm.capture.capturemode,
+		sp->parm.capture.timeperframe.numerator,
+		sp->parm.capture.timeperframe.denominator, fdec);
 	return 0;
 }
+
+static int vidioc_enum_frameintervals(struct file *file, void *priv,
+			    struct v4l2_frmivalenum *fe)
+{
+	int is_ntsc = 0;
+#define NUM_FRAME_ENUMS 4
+	int frm_dec[NUM_FRAME_ENUMS] = {1, 2, 3, 5};
+	if (fe->index < 0 || fe->index >= NUM_FRAME_ENUMS)
+		return -EINVAL;
+	switch (fe->width) {
+	case 640:
+		if (fe->height != 240 && fe->height != 480)
+			return -EINVAL;
+		is_ntsc = 1;
+		break;
+	case 320:
+		if (fe->height != 240)
+			return -EINVAL;
+		is_ntsc = 1;
+		break;
+	case 704:
+		if (fe->height != 288 && fe->height != 576)
+			return -EINVAL;
+		break;
+	case 352:
+		if (fe->height != 288)
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+	fe->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	fe->discrete.denominator = is_ntsc ? 30000 : 25000;
+	fe->discrete.numerator = (is_ntsc ? 1001 : 1000) * frm_dec[fe->index];
+	dprintk(4, "%s discrete %d/%d\n", __func__, fe->discrete.numerator,
+		fe->discrete.denominator);
+	return 0;
+}
+
 static int s2255_open(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
@@ -1932,6 +2028,7 @@
 	.vidioc_g_jpegcomp = vidioc_g_jpegcomp,
 	.vidioc_s_parm = vidioc_s_parm,
 	.vidioc_g_parm = vidioc_g_parm,
+	.vidioc_enum_frameintervals = vidioc_enum_frameintervals,
 };
 
 static struct video_device template = {

