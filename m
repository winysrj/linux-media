Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1364 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202Ab2FJKzS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 06:55:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Steven Toth <stoth@kernellabs.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 09/11] cx88: fix a number of v4l2-compliance violations.
Date: Sun, 10 Jun 2012 12:54:55 +0200
Message-Id: <55f95df4f27de4a3a66b7293523259a4263c64cc.1339325224.git.hans.verkuil@cisco.com>
In-Reply-To: <1339325697-23280-1-git-send-email-hverkuil@xs4all.nl>
References: <1339325697-23280-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <541a39bdcc8a94d3de87a6a6d0b1b7c476983984.1339325224.git.hans.verkuil@cisco.com>
References: <541a39bdcc8a94d3de87a6a6d0b1b7c476983984.1339325224.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- missing COMPRESSED flag for MPEG formats
- set colorspace
- set sizeimage
- add tuner index checks
- setup the frequency ranges correctly
- add missing g_chip_ident ioctl
- fix audmode handling
- don't handle vbi formats on a video node and vice versa.

cx88 now passes the v4l2-compliance tests.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/cx88/cx88-blackbird.c |   24 ++++++----
 drivers/media/video/cx88/cx88-video.c     |   71 +++++++++++++++++++++++------
 2 files changed, 72 insertions(+), 23 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
index 1a5facb..397ac42 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -709,6 +709,7 @@ static int vidioc_enum_fmt_vid_cap (struct file *file, void  *priv,
 
 	strlcpy(f->description, "MPEG", sizeof(f->description));
 	f->pixelformat = V4L2_PIX_FMT_MPEG;
+	f->flags = V4L2_FMT_FLAG_COMPRESSED;
 	return 0;
 }
 
@@ -720,8 +721,8 @@ static int vidioc_g_fmt_vid_cap (struct file *file, void *priv,
 
 	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.bytesperline = 0;
-	f->fmt.pix.sizeimage    = dev->ts_packet_size * dev->ts_packet_count; /* 188 * 4 * 1024; */
-	f->fmt.pix.colorspace   = 0;
+	f->fmt.pix.sizeimage    = 188 * 4 * mpegbufs; /* 188 * 4 * 1024; */;
+	f->fmt.pix.colorspace   = V4L2_COLORSPACE_SMPTE170M;
 	f->fmt.pix.width        = dev->width;
 	f->fmt.pix.height       = dev->height;
 	f->fmt.pix.field        = fh->mpegq.field;
@@ -738,8 +739,8 @@ static int vidioc_try_fmt_vid_cap (struct file *file, void *priv,
 
 	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.bytesperline = 0;
-	f->fmt.pix.sizeimage    = dev->ts_packet_size * dev->ts_packet_count; /* 188 * 4 * 1024; */;
-	f->fmt.pix.colorspace   = 0;
+	f->fmt.pix.sizeimage    = 188 * 4 * mpegbufs; /* 188 * 4 * 1024; */;
+	f->fmt.pix.colorspace   = V4L2_COLORSPACE_SMPTE170M;
 	dprintk(1, "VIDIOC_TRY_FMT: w: %d, h: %d, f: %d\n",
 		dev->width, dev->height, fh->mpegq.field );
 	return 0;
@@ -754,8 +755,8 @@ static int vidioc_s_fmt_vid_cap (struct file *file, void *priv,
 
 	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.bytesperline = 0;
-	f->fmt.pix.sizeimage    = dev->ts_packet_size * dev->ts_packet_count; /* 188 * 4 * 1024; */;
-	f->fmt.pix.colorspace   = 0;
+	f->fmt.pix.sizeimage    = 188 * 4 * mpegbufs; /* 188 * 4 * 1024; */;
+	f->fmt.pix.colorspace   = V4L2_COLORSPACE_SMPTE170M;
 	dev->width              = f->fmt.pix.width;
 	dev->height             = f->fmt.pix.height;
 	fh->mpegq.field         = f->fmt.pix.field;
@@ -819,6 +820,10 @@ static int vidioc_s_frequency (struct file *file, void *priv,
 	struct cx8802_dev *dev  = fh->dev;
 	struct cx88_core  *core = dev->core;
 
+	if (unlikely(UNSET == core->board.tuner_type))
+		return -EINVAL;
+	if (unlikely(f->tuner != 0))
+		return -EINVAL;
 	if (dev->mpeg_active)
 		blackbird_stop_codec(dev);
 
@@ -856,8 +861,9 @@ static int vidioc_g_frequency (struct file *file, void *priv,
 
 	if (unlikely(UNSET == core->board.tuner_type))
 		return -EINVAL;
+	if (unlikely(f->tuner != 0))
+		return -EINVAL;
 
-	f->type = V4L2_TUNER_ANALOG_TV;
 	f->frequency = core->freq;
 	call_all(core, tuner, g_frequency, f);
 
@@ -878,6 +884,8 @@ static int vidioc_s_input (struct file *file, void *priv, unsigned int i)
 
 	if (i >= 4)
 		return -EINVAL;
+	if (0 == INPUT(i).type)
+		return -EINVAL;
 
 	mutex_lock(&core->lock);
 	cx88_newstation(core);
@@ -898,9 +906,9 @@ static int vidioc_g_tuner (struct file *file, void *priv,
 		return -EINVAL;
 
 	strcpy(t->name, "Television");
-	t->type       = V4L2_TUNER_ANALOG_TV;
 	t->capability = V4L2_TUNER_CAP_NORM;
 	t->rangehigh  = 0xffffffffUL;
+	call_all(core, tuner, g_tuner, t);
 
 	cx88_get_stereo(core ,t);
 	reg = cx_read(MO_DEVICE_STATUS);
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 930d43b..3dee421 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -831,7 +831,6 @@ video_poll(struct file *file, struct poll_table_struct *wait)
 			return rc | POLLERR;
 		return rc | videobuf_poll_stream(file, &fh->vbiq, wait);
 	}
-
 	mutex_lock(&fh->vidq.vb_lock);
 	if (res_check(fh,RESOURCE_VIDEO)) {
 		/* streaming capture */
@@ -1222,8 +1221,8 @@ int cx88_enum_input (struct cx88_core  *core,struct v4l2_input *i)
 	if ((CX88_VMUX_TELEVISION == INPUT(n).type) ||
 	    (CX88_VMUX_CABLE      == INPUT(n).type)) {
 		i->type = V4L2_INPUT_TYPE_TUNER;
-		i->std = CX88_NORMS;
 	}
+	i->std = CX88_NORMS;
 	return 0;
 }
 EXPORT_SYMBOL(cx88_enum_input);
@@ -1249,6 +1248,8 @@ static int vidioc_s_input (struct file *file, void *priv, unsigned int i)
 
 	if (i >= 4)
 		return -EINVAL;
+	if (0 == INPUT(i).type)
+		return -EINVAL;
 
 	mutex_lock(&core->lock);
 	cx88_newstation(core);
@@ -1269,9 +1270,9 @@ static int vidioc_g_tuner (struct file *file, void *priv,
 		return -EINVAL;
 
 	strcpy(t->name, "Television");
-	t->type       = V4L2_TUNER_ANALOG_TV;
 	t->capability = V4L2_TUNER_CAP_NORM;
 	t->rangehigh  = 0xffffffffUL;
+	call_all(core, tuner, g_tuner, t);
 
 	cx88_get_stereo(core ,t);
 	reg = cx_read(MO_DEVICE_STATUS);
@@ -1301,6 +1302,8 @@ static int vidioc_g_frequency (struct file *file, void *priv,
 
 	if (unlikely(UNSET == core->board.tuner_type))
 		return -EINVAL;
+	if (f->tuner)
+		return -EINVAL;
 
 	f->frequency = core->freq;
 
@@ -1318,9 +1321,10 @@ int cx88_set_freq (struct cx88_core  *core,
 		return -EINVAL;
 
 	mutex_lock(&core->lock);
-	core->freq = f->frequency;
 	cx88_newstation(core);
 	call_all(core, tuner, s_frequency, f);
+	call_all(core, tuner, g_frequency, f);
+	core->freq = f->frequency;
 
 	/* When changing channels it is required to reset TVAUDIO */
 	msleep (10);
@@ -1341,6 +1345,16 @@ static int vidioc_s_frequency (struct file *file, void *priv,
 	return cx88_set_freq(core, f);
 }
 
+static int vidioc_g_chip_ident(struct file *file, void *priv,
+				struct v4l2_dbg_chip_ident *chip)
+{
+	if (!v4l2_chip_match_host(&chip->match))
+		return -EINVAL;
+	chip->revision = 0;
+	chip->ident = V4L2_IDENT_UNKNOWN;
+	return 0;
+}
+
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int vidioc_g_register (struct file *file, void *fh,
 				struct v4l2_dbg_register *reg)
@@ -1380,7 +1394,6 @@ static int radio_g_tuner (struct file *file, void *priv,
 		return -EINVAL;
 
 	strcpy(t->name, "Radio");
-	t->type = V4L2_TUNER_RADIO;
 
 	call_all(core, tuner, g_tuner, t);
 	return 0;
@@ -1395,6 +1408,8 @@ static int radio_s_tuner (struct file *file, void *priv,
 
 	if (0 != t->index)
 		return -EINVAL;
+	if (t->audmode > V4L2_TUNER_MODE_STEREO)
+		t->audmode = V4L2_TUNER_MODE_STEREO;
 
 	call_all(core, tuner, s_tuner, t);
 
@@ -1543,9 +1558,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_g_fmt_vid_cap     = vidioc_g_fmt_vid_cap,
 	.vidioc_try_fmt_vid_cap   = vidioc_try_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap     = vidioc_s_fmt_vid_cap,
-	.vidioc_g_fmt_vbi_cap     = cx8800_vbi_fmt,
-	.vidioc_try_fmt_vbi_cap   = cx8800_vbi_fmt,
-	.vidioc_s_fmt_vbi_cap     = cx8800_vbi_fmt,
 	.vidioc_reqbufs       = vidioc_reqbufs,
 	.vidioc_querybuf      = vidioc_querybuf,
 	.vidioc_qbuf          = vidioc_qbuf,
@@ -1562,14 +1574,13 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_s_frequency   = vidioc_s_frequency,
 	.vidioc_subscribe_event      = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event    = v4l2_event_unsubscribe,
+	.vidioc_g_chip_ident  = vidioc_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register    = vidioc_g_register,
 	.vidioc_s_register    = vidioc_s_register,
 #endif
 };
 
-static struct video_device cx8800_vbi_template;
-
 static const struct video_device cx8800_video_template = {
 	.name                 = "cx8800-video",
 	.fops                 = &video_fops,
@@ -1578,6 +1589,40 @@ static const struct video_device cx8800_video_template = {
 	.current_norm         = V4L2_STD_NTSC_M,
 };
 
+static const struct v4l2_ioctl_ops vbi_ioctl_ops = {
+	.vidioc_querycap      = vidioc_querycap,
+	.vidioc_g_fmt_vbi_cap     = cx8800_vbi_fmt,
+	.vidioc_try_fmt_vbi_cap   = cx8800_vbi_fmt,
+	.vidioc_s_fmt_vbi_cap     = cx8800_vbi_fmt,
+	.vidioc_reqbufs       = vidioc_reqbufs,
+	.vidioc_querybuf      = vidioc_querybuf,
+	.vidioc_qbuf          = vidioc_qbuf,
+	.vidioc_dqbuf         = vidioc_dqbuf,
+	.vidioc_s_std         = vidioc_s_std,
+	.vidioc_enum_input    = vidioc_enum_input,
+	.vidioc_g_input       = vidioc_g_input,
+	.vidioc_s_input       = vidioc_s_input,
+	.vidioc_streamon      = vidioc_streamon,
+	.vidioc_streamoff     = vidioc_streamoff,
+	.vidioc_g_tuner       = vidioc_g_tuner,
+	.vidioc_s_tuner       = vidioc_s_tuner,
+	.vidioc_g_frequency   = vidioc_g_frequency,
+	.vidioc_s_frequency   = vidioc_s_frequency,
+	.vidioc_g_chip_ident  = vidioc_g_chip_ident,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.vidioc_g_register    = vidioc_g_register,
+	.vidioc_s_register    = vidioc_s_register,
+#endif
+};
+
+static const struct video_device cx8800_vbi_template = {
+	.name                 = "cx8800-vbi",
+	.fops                 = &video_fops,
+	.ioctl_ops	      = &vbi_ioctl_ops,
+	.tvnorms              = CX88_NORMS,
+	.current_norm         = V4L2_STD_NTSC_M,
+};
+
 static const struct v4l2_file_operations radio_fops =
 {
 	.owner         = THIS_MODULE,
@@ -1595,6 +1640,7 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_s_frequency   = vidioc_s_frequency,
 	.vidioc_subscribe_event      = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event    = v4l2_event_unsubscribe,
+	.vidioc_g_chip_ident  = vidioc_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register    = vidioc_g_register,
 	.vidioc_s_register    = vidioc_s_register,
@@ -1682,11 +1728,6 @@ static int __devinit cx8800_initdev(struct pci_dev *pci_dev,
 		goto fail_core;
 	}
 
-	/* Initialize VBI template */
-	memcpy( &cx8800_vbi_template, &cx8800_video_template,
-		sizeof(cx8800_vbi_template) );
-	strcpy(cx8800_vbi_template.name,"cx8800-vbi");
-
 	/* initialize driver struct */
 	spin_lock_init(&dev->slock);
 	core->tvnorm = cx8800_video_template.current_norm;
-- 
1.7.10

