Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail11b.verio-web.com ([204.202.242.87]:47745 "HELO
	mail11b.verio-web.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755035AbZEORcH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2009 13:32:07 -0400
Received: from mx89.stngva01.us.mxservers.net (198.173.112.6)
	by mail11b.verio-web.com (RS ver 1.0.95vs) with SMTP id 1-0970708726
	for <linux-media@vger.kernel.org>; Fri, 15 May 2009 13:32:06 -0400 (EDT)
Date: Fri, 15 May 2009 10:32:04 -0700 (PDT)
From: "Dean A." <dean@sensoray.com>
Subject: patch: s2255drv: adding V4L2_MODE_HIGHQUALITY
To: linux-media@vger.kernel.org, mchehab@infradead.org,
	video4linux-list@redhat.com
Message-ID: <tkrat.20eecea659be4c29@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dean Anderson <dean@sensoray.com>

Adding V4L2_MODE_HIGHQUALITY feature.

Signed-off-by: Dean Anderson <dean@sensoray.com>

--- v4l-dvb-0018ed9bbca3/linux/drivers/media/video/s2255drv.c.orig	2009-05-15 10:15:36.000000000 -0700
+++ v4l-dvb-0018ed9bbca3/linux/drivers/media/video/s2255drv.c	2009-05-15 10:20:43.000000000 -0700
@@ -110,6 +110,8 @@
 #define SCALE_4CIFS	1	/* 640x480(NTSC) or 704x576(PAL) */
 #define SCALE_2CIFS	2	/* 640x240(NTSC) or 704x288(PAL) */
 #define SCALE_1CIFS	3	/* 320x240(NTSC) or 352x288(PAL) */
+/* SCALE_4CIFSI is the 2 fields interpolated into one */
+#define SCALE_4CIFSI	4	/* 640x480(NTSC) or 704x576(PAL) high quality */
 
 #define COLOR_YUVPL	1	/* YUV planar */
 #define COLOR_YUVPK	2	/* YUV packed */
@@ -239,6 +241,8 @@
 	struct s2255_mode	mode[MAX_CHANNELS];
 	/* jpeg compression */
 	struct v4l2_jpegcompression jc[MAX_CHANNELS];
+	/* capture parameters (for high quality mode full size) */
+	struct v4l2_captureparm cap_parm[MAX_CHANNELS];
 	const struct s2255_fmt	*cur_fmt[MAX_CHANNELS];
 	int			cur_frame[MAX_CHANNELS];
 	int			last_frame[MAX_CHANNELS];
@@ -1021,9 +1025,16 @@
 	fh->type = f->type;
 	norm = norm_minw(fh->dev->vdev[fh->channel]);
 	if (fh->width > norm_minw(fh->dev->vdev[fh->channel])) {
-		if (fh->height > norm_minh(fh->dev->vdev[fh->channel]))
-			fh->mode.scale = SCALE_4CIFS;
-		else
+		if (fh->height > norm_minh(fh->dev->vdev[fh->channel])) {
+			if (fh->dev->cap_parm[fh->channel].capturemode &
+			    V4L2_MODE_HIGHQUALITY) {
+				fh->mode.scale = SCALE_4CIFSI;
+				dprintk(2, "scale 4CIFSI\n");
+			} else {
+				fh->mode.scale = SCALE_4CIFS;
+				dprintk(2, "scale 4CIFS\n");
+			}
+		} else
 			fh->mode.scale = SCALE_2CIFS;
 
 	} else {
@@ -1124,6 +1135,7 @@
 	if (mode->format == FORMAT_NTSC) {
 		switch (mode->scale) {
 		case SCALE_4CIFS:
+		case SCALE_4CIFSI:
 			linesPerFrame = NUM_LINES_4CIFS_NTSC * 2;
 			pixelsPerLine = LINE_SZ_4CIFS_NTSC;
 			break;
@@ -1141,6 +1153,7 @@
 	} else if (mode->format == FORMAT_PAL) {
 		switch (mode->scale) {
 		case SCALE_4CIFS:
+		case SCALE_4CIFSI:
 			linesPerFrame = NUM_LINES_4CIFS_PAL * 2;
 			pixelsPerLine = LINE_SZ_4CIFS_PAL;
 			break;
@@ -1496,6 +1509,33 @@
 	dprintk(2, "setting jpeg quality %d\n", jc->quality);
 	return 0;
 }
+
+static int vidioc_g_parm(struct file *file, void *priv,
+			 struct v4l2_streamparm *sp)
+{
+	struct s2255_fh *fh = priv;
+	struct s2255_dev *dev = fh->dev;
+	if (sp->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+	sp->parm.capture.capturemode = dev->cap_parm[fh->channel].capturemode;
+	dprintk(2, "getting parm %d\n", sp->parm.capture.capturemode);
+	return 0;
+}
+
+static int vidioc_s_parm(struct file *file, void *priv,
+			 struct v4l2_streamparm *sp)
+{
+	struct s2255_fh *fh = priv;
+	struct s2255_dev *dev = fh->dev;
+
+	if (sp->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	dev->cap_parm[fh->channel].capturemode = sp->parm.capture.capturemode;
+	dprintk(2, "setting param capture mode %d\n",
+		sp->parm.capture.capturemode);
+	return 0;
+}
 static int s2255_open(struct file *file)
 {
 	int minor = video_devdata(file)->minor;
@@ -1787,6 +1827,8 @@
 #endif
 	.vidioc_s_jpegcomp = vidioc_s_jpegcomp,
 	.vidioc_g_jpegcomp = vidioc_g_jpegcomp,
+	.vidioc_s_parm = vidioc_s_parm,
+	.vidioc_g_parm = vidioc_g_parm,
 };
 
 static struct video_device template = {

