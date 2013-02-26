Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2734 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab3BZRf7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Feb 2013 12:35:59 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 05/11] s2255: fixes in the way standards are handled.
Date: Tue, 26 Feb 2013 18:35:40 +0100
Message-Id: <e5cd962ba6b106d0c583886dce0b64d0688731b4.1361900043.git.hans.verkuil@cisco.com>
In-Reply-To: <1361900146-32759-1-git-send-email-hverkuil@xs4all.nl>
References: <1361900146-32759-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <f11ed501c392d8891c3eefeb4959a117e5ddf94e.1361900043.git.hans.verkuil@cisco.com>
References: <f11ed501c392d8891c3eefeb4959a117e5ddf94e.1361900043.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Instead of comparing against STD_NTSC and STD_PAL compare against 60 and
50 Hz formats. That's what you really want.

When the standard is changed, make sure the width and height of the format
are also updated to reflect the current standard.

Also replace the deprecated current_norm by the g_std ioctl.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/s2255/s2255drv.c |   61 +++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 22 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 9cb8325..88f728d 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -225,6 +225,7 @@ struct s2255_channel {
 	struct s2255_dmaqueue	vidq;
 	struct s2255_bufferi	buffer;
 	struct s2255_mode	mode;
+	v4l2_std_id		std;
 	/* jpeg compression */
 	unsigned		jpegqual;
 	/* capture parameters (for high quality mode full size) */
@@ -312,7 +313,7 @@ struct s2255_fh {
 /* Need DSP version 5+ for video status feature */
 #define S2255_MIN_DSP_STATUS      5
 #define S2255_MIN_DSP_COLORFILTER 8
-#define S2255_NORMS		(V4L2_STD_PAL | V4L2_STD_NTSC)
+#define S2255_NORMS		(V4L2_STD_ALL)
 
 /* private V4L2 controls */
 
@@ -443,27 +444,27 @@ static const struct s2255_fmt formats[] = {
 	}
 };
 
-static int norm_maxw(struct video_device *vdev)
+static int norm_maxw(struct s2255_channel *channel)
 {
-	return (vdev->current_norm & V4L2_STD_NTSC) ?
+	return (channel->std & V4L2_STD_525_60) ?
 	    LINE_SZ_4CIFS_NTSC : LINE_SZ_4CIFS_PAL;
 }
 
-static int norm_maxh(struct video_device *vdev)
+static int norm_maxh(struct s2255_channel *channel)
 {
-	return (vdev->current_norm & V4L2_STD_NTSC) ?
+	return (channel->std & V4L2_STD_525_60) ?
 	    (NUM_LINES_1CIFS_NTSC * 2) : (NUM_LINES_1CIFS_PAL * 2);
 }
 
-static int norm_minw(struct video_device *vdev)
+static int norm_minw(struct s2255_channel *channel)
 {
-	return (vdev->current_norm & V4L2_STD_NTSC) ?
+	return (channel->std & V4L2_STD_525_60) ?
 	    LINE_SZ_1CIFS_NTSC : LINE_SZ_1CIFS_PAL;
 }
 
-static int norm_minh(struct video_device *vdev)
+static int norm_minh(struct s2255_channel *channel)
 {
-	return (vdev->current_norm & V4L2_STD_NTSC) ?
+	return (channel->std & V4L2_STD_525_60) ?
 	    (NUM_LINES_1CIFS_NTSC) : (NUM_LINES_1CIFS_PAL);
 }
 
@@ -725,10 +726,10 @@ static int buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 	if (channel->fmt == NULL)
 		return -EINVAL;
 
-	if ((w < norm_minw(&channel->vdev)) ||
-	    (w > norm_maxw(&channel->vdev)) ||
-	    (h < norm_minh(&channel->vdev)) ||
-	    (h > norm_maxh(&channel->vdev))) {
+	if ((w < norm_minw(channel)) ||
+	    (w > norm_maxw(channel)) ||
+	    (h < norm_minh(channel)) ||
+	    (h > norm_maxh(channel))) {
 		dprintk(4, "invalid buffer prepare\n");
 		return -EINVAL;
 	}
@@ -870,8 +871,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	struct s2255_fh *fh = priv;
 	struct s2255_channel *channel = fh->channel;
 	int is_ntsc;
-	is_ntsc =
-		(channel->vdev.current_norm & V4L2_STD_NTSC) ? 1 : 0;
+	is_ntsc = (channel->std & V4L2_STD_525_60) ? 1 : 0;
 
 	fmt = format_by_fourcc(f->fmt.pix.pixelformat);
 
@@ -998,8 +998,8 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	channel->height = f->fmt.pix.height;
 	fh->vb_vidq.field = f->fmt.pix.field;
 	fh->type = f->type;
-	if (channel->width > norm_minw(&channel->vdev)) {
-		if (channel->height > norm_minh(&channel->vdev)) {
+	if (channel->width > norm_minw(channel)) {
+		if (channel->height > norm_minh(channel)) {
 			if (channel->cap_parm.capturemode &
 			    V4L2_MODE_HIGHQUALITY)
 				mode.scale = SCALE_4CIFSI;
@@ -1323,7 +1323,9 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *i)
 	struct s2255_fh *fh = priv;
 	struct s2255_mode mode;
 	struct videobuf_queue *q = &fh->vb_vidq;
+	struct s2255_channel *channel = fh->channel;
 	int ret = 0;
+
 	mutex_lock(&q->vb_lock);
 	if (videobuf_queue_is_busy(q)) {
 		dprintk(1, "queue busy\n");
@@ -1336,24 +1338,30 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *i)
 		goto out_s_std;
 	}
 	mode = fh->channel->mode;
-	if (*i & V4L2_STD_NTSC) {
-		dprintk(4, "%s NTSC\n", __func__);
+	if (*i & V4L2_STD_525_60) {
+		dprintk(4, "%s 60 Hz\n", __func__);
 		/* if changing format, reset frame decimation/intervals */
 		if (mode.format != FORMAT_NTSC) {
 			mode.restart = 1;
 			mode.format = FORMAT_NTSC;
 			mode.fdec = FDEC_1;
+			channel->width = LINE_SZ_4CIFS_NTSC;
+			channel->height = NUM_LINES_4CIFS_NTSC * 2;
 		}
-	} else if (*i & V4L2_STD_PAL) {
-		dprintk(4, "%s PAL\n", __func__);
+	} else if (*i & V4L2_STD_625_50) {
+		dprintk(4, "%s 50 Hz\n", __func__);
 		if (mode.format != FORMAT_PAL) {
 			mode.restart = 1;
 			mode.format = FORMAT_PAL;
 			mode.fdec = FDEC_1;
+			channel->width = LINE_SZ_4CIFS_PAL;
+			channel->height = NUM_LINES_4CIFS_PAL * 2;
 		}
 	} else {
 		ret = -EINVAL;
+		goto out_s_std;
 	}
+	fh->channel->std = *i;
 	if (mode.restart)
 		s2255_set_mode(fh->channel, &mode);
 out_s_std:
@@ -1361,6 +1369,14 @@ out_s_std:
 	return ret;
 }
 
+static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *i)
+{
+	struct s2255_fh *fh = priv;
+
+	*i = fh->channel->std;
+	return 0;
+}
+
 /* Sensoray 2255 is a multiple channel capture device.
    It does not have a "crossbar" of inputs.
    We use one V4L device per channel. The user must
@@ -1815,6 +1831,7 @@ static const struct v4l2_ioctl_ops s2255_ioctl_ops = {
 	.vidioc_qbuf = vidioc_qbuf,
 	.vidioc_dqbuf = vidioc_dqbuf,
 	.vidioc_s_std = vidioc_s_std,
+	.vidioc_g_std = vidioc_g_std,
 	.vidioc_enum_input = vidioc_enum_input,
 	.vidioc_g_input = vidioc_g_input,
 	.vidioc_s_input = vidioc_s_input,
@@ -1851,7 +1868,6 @@ static struct video_device template = {
 	.ioctl_ops = &s2255_ioctl_ops,
 	.release = s2255_video_device_release,
 	.tvnorms = S2255_NORMS,
-	.current_norm = V4L2_STD_NTSC_M,
 };
 
 static const struct v4l2_ctrl_ops s2255_ctrl_ops = {
@@ -2265,6 +2281,7 @@ static int s2255_board_init(struct s2255_dev *dev)
 		channel->jpegqual = S2255_DEF_JPEG_QUAL;
 		channel->width = LINE_SZ_4CIFS_NTSC;
 		channel->height = NUM_LINES_4CIFS_NTSC * 2;
+		channel->std = V4L2_STD_NTSC_M;
 		channel->fmt = &formats[0];
 		channel->mode.restart = 1;
 		channel->req_image_size = get_transfer_size(&mode_def);
-- 
1.7.10.4

