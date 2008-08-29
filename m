Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7TIXXM4028203
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 14:33:33 -0400
Received: from mail11a.verio-web.com (mail11a.verio-web.com [204.202.242.23])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m7TIXM2c021845
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 14:33:23 -0400
Received: from mx107.stngva01.us.mxservers.net (198.173.112.44)
	by mail11a.verio-web.com (RS ver 1.0.95vs) with SMTP id 1-0328714801
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 14:33:22 -0400 (EDT)
Date: Fri, 29 Aug 2008 11:33:19 -0700 (PDT)
From: "Dean A." <dean@sensoray.com>
To: mchehab@infradead.org, video4linux-list@redhat.com,
	v4l-dvb-maintainer@linuxtv.org
Message-ID: <tkrat.fe10464e74816cea@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Cc: greg@kroah.com, dean@sensoray.com
Subject: [PATCH] s2255drv:  adds JPEG compression quality control
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

From: Dean Anderson <dean@sensoray.com>

adds VIDIOC_S_JPEGCOMP and VIDIOC_G_JPEGCOMP ioctls for
controlling JPEG compression quality.

Signed-off-by: Dean Anderson <dean@sensoray.com>
---


--- /usr/src/v4l-dvb-3cca4cda1e3f/linux/drivers/media/video/s2255drv.c.orig	2008-08-29 11:19:08.000000000 -0700
+++ /usr/src/v4l-dvb-3cca4cda1e3f/linux/drivers/media/video/s2255drv.c	2008-08-29 11:28:10.000000000 -0700
@@ -59,6 +59,8 @@
 
 
 
+/* default JPEG quality */
+#define S2255_DEF_JPEG_QUAL     50
 /* vendor request in */
 #define S2255_VR_IN		0
 /* vendor request out */
@@ -243,6 +245,8 @@ struct s2255_dev {
 	struct s2255_pipeinfo	pipes[MAX_PIPE_BUFFERS];
 	struct s2255_bufferi		buffer[MAX_CHANNELS];
 	struct s2255_mode	mode[MAX_CHANNELS];
+	/* jpeg compression */
+	struct v4l2_jpegcompression jc[MAX_CHANNELS];
 	const struct s2255_fmt	*cur_fmt[MAX_CHANNELS];
 	int			cur_frame[MAX_CHANNELS];
 	int			last_frame[MAX_CHANNELS];
@@ -1036,7 +1040,8 @@ static int vidioc_s_fmt_vid_cap(struct f
 		fh->mode.color = COLOR_Y8;
 		break;
 	case V4L2_PIX_FMT_JPEG:
-		fh->mode.color = COLOR_JPG | (50 << 8);
+		fh->mode.color = COLOR_JPG |
+			(fh->dev->jc[fh->channel].quality << 8);
 		break;
 	case V4L2_PIX_FMT_YUV422P:
 		fh->mode.color = COLOR_YUVPL;
@@ -1209,6 +1214,10 @@ static int s2255_set_mode(struct s2255_d
 		dev->mode[chn].scale);
 	dprintk(2, "mode contrast %x\n", mode->contrast);
 
+	/* if JPEG, set the quality */
+	if ((mode->color & MASK_COLOR) == COLOR_JPG)
+		mode->color = (dev->jc[chn].quality << 8) | COLOR_JPG;
+
 	/* save the mode */
 	dev->mode[chn] = *mode;
 	dev->req_image_size[chn] = get_transfer_size(mode);
@@ -1472,6 +1481,27 @@ static int vidioc_s_ctrl(struct file *fi
 	return -EINVAL;
 }
 
+static int vidioc_g_jpegcomp(struct file *file, void *priv,
+			 struct v4l2_jpegcompression *jc)
+{
+	struct s2255_fh *fh = priv;
+	struct s2255_dev *dev = fh->dev;
+	*jc = dev->jc[fh->channel];
+	dprintk(2, "getting jpegcompression, quality %d\n", jc->quality);
+	return 0;
+}
+
+static int vidioc_s_jpegcomp(struct file *file, void *priv,
+			 struct v4l2_jpegcompression *jc)
+{
+	struct s2255_fh *fh = priv;
+	struct s2255_dev *dev = fh->dev;
+	if (jc->quality < 0 || jc->quality > 100)
+		return -EINVAL;
+	dev->jc[fh->channel].quality = jc->quality;
+	dprintk(2, "setting jpeg quality %d\n", jc->quality);
+	return 0;
+}
 static int s2255_open(struct inode *inode, struct file *file)
 {
 	int minor = iminor(inode);
@@ -1762,6 +1792,8 @@ static const struct v4l2_ioctl_ops s2255
 #ifdef CONFIG_VIDEO_V4L1_COMPAT
 	.vidiocgmbuf = vidioc_cgmbuf,
 #endif
+	.vidioc_s_jpegcomp = vidioc_s_jpegcomp,
+	.vidioc_g_jpegcomp = vidioc_g_jpegcomp,
 };
 
 static struct video_device template = {
@@ -2148,6 +2180,7 @@ static int s2255_board_init(struct s2255
 	for (j = 0; j < MAX_CHANNELS; j++) {
 		dev->b_acquire[j] = 0;
 		dev->mode[j] = mode_def;
+		dev->jc[j].quality = S2255_DEF_JPEG_QUAL;
 		dev->cur_fmt[j] = &formats[0];
 		dev->mode[j].restart = 1;
 		dev->req_image_size[j] = get_transfer_size(&mode_def);

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
