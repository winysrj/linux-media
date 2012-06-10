Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3610 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab2FJKzL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 06:55:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Steven Toth <stoth@kernellabs.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 04/11] cx88: convert cx88-blackbird to the control framework.
Date: Sun, 10 Jun 2012 12:54:50 +0200
Message-Id: <a41e025b5dd33040b2236c11937c4ed157ec934d.1339325224.git.hans.verkuil@cisco.com>
In-Reply-To: <1339325697-23280-1-git-send-email-hverkuil@xs4all.nl>
References: <1339325697-23280-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <541a39bdcc8a94d3de87a6a6d0b1b7c476983984.1339325224.git.hans.verkuil@cisco.com>
References: <541a39bdcc8a94d3de87a6a6d0b1b7c476983984.1339325224.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/cx88/cx88-blackbird.c |  108 +++++++++++------------------
 drivers/media/video/cx88/cx88.h           |    2 +-
 2 files changed, 40 insertions(+), 70 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
index c9bbe9f..18ed14b 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -523,11 +523,10 @@ static void blackbird_codec_settings(struct cx8802_dev *dev)
 	blackbird_api_cmd(dev, CX2341X_ENC_SET_FRAME_SIZE, 2, 0,
 				dev->height, dev->width);
 
-	dev->params.width = dev->width;
-	dev->params.height = dev->height;
-	dev->params.is_50hz = (dev->core->tvnorm & V4L2_STD_625_50) != 0;
-
-	cx2341x_update(dev, blackbird_mbox_func, NULL, &dev->params);
+	dev->cxhdl.width = dev->width;
+	dev->cxhdl.height = dev->height;
+	cx2341x_handler_set_50hz(&dev->cxhdl, dev->core->tvnorm & V4L2_STD_625_50);
+	cx2341x_handler_setup(&dev->cxhdl);
 }
 
 static int blackbird_initialize_codec(struct cx8802_dev *dev)
@@ -618,6 +617,8 @@ static int blackbird_start_codec(struct file *file, void *priv)
 	/* initialize the video input */
 	blackbird_api_cmd(dev, CX2341X_ENC_INITIALIZE_INPUT, 0, 0);
 
+	cx2341x_handler_set_busy(&dev->cxhdl, 1);
+
 	/* start capturing to the host interface */
 	blackbird_api_cmd(dev, CX2341X_ENC_START_CAPTURE, 2, 0,
 			BLACKBIRD_MPEG_CAPTURE,
@@ -636,6 +637,8 @@ static int blackbird_stop_codec(struct cx8802_dev *dev)
 			BLACKBIRD_RAW_BITS_NONE
 		);
 
+	cx2341x_handler_set_busy(&dev->cxhdl, 0);
+
 	dev->mpeg_active = 0;
 	return 0;
 }
@@ -721,7 +724,7 @@ static int vidioc_g_fmt_vid_cap (struct file *file, void *priv,
 	f->fmt.pix.width        = dev->width;
 	f->fmt.pix.height       = dev->height;
 	f->fmt.pix.field        = fh->mpegq.field;
-	dprintk(0,"VIDIOC_G_FMT: w: %d, h: %d, f: %d\n",
+	dprintk(1, "VIDIOC_G_FMT: w: %d, h: %d, f: %d\n",
 		dev->width, dev->height, fh->mpegq.field );
 	return 0;
 }
@@ -736,7 +739,7 @@ static int vidioc_try_fmt_vid_cap (struct file *file, void *priv,
 	f->fmt.pix.bytesperline = 0;
 	f->fmt.pix.sizeimage    = dev->ts_packet_size * dev->ts_packet_count; /* 188 * 4 * 1024; */;
 	f->fmt.pix.colorspace   = 0;
-	dprintk(0,"VIDIOC_TRY_FMT: w: %d, h: %d, f: %d\n",
+	dprintk(1, "VIDIOC_TRY_FMT: w: %d, h: %d, f: %d\n",
 		dev->width, dev->height, fh->mpegq.field );
 	return 0;
 }
@@ -758,7 +761,7 @@ static int vidioc_s_fmt_vid_cap (struct file *file, void *priv,
 	cx88_set_scale(core, f->fmt.pix.width, f->fmt.pix.height, f->fmt.pix.field);
 	blackbird_api_cmd(dev, CX2341X_ENC_SET_FRAME_SIZE, 2, 0,
 				f->fmt.pix.height, f->fmt.pix.width);
-	dprintk(0,"VIDIOC_S_FMT: w: %d, h: %d, f: %d\n",
+	dprintk(1, "VIDIOC_S_FMT: w: %d, h: %d, f: %d\n",
 		f->fmt.pix.width, f->fmt.pix.height, f->fmt.pix.field );
 	return 0;
 }
@@ -791,60 +794,21 @@ static int vidioc_dqbuf (struct file *file, void *priv, struct v4l2_buffer *p)
 static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 {
 	struct cx8802_fh  *fh   = priv;
+	struct cx8802_dev *dev  = fh->dev;
+
+	if (!dev->mpeg_active)
+		blackbird_start_codec(file, fh);
 	return videobuf_streamon(&fh->mpegq);
 }
 
 static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 {
 	struct cx8802_fh  *fh   = priv;
-	return videobuf_streamoff(&fh->mpegq);
-}
-
-static int vidioc_g_ext_ctrls (struct file *file, void *priv,
-			       struct v4l2_ext_controls *f)
-{
-	struct cx8802_dev *dev  = ((struct cx8802_fh *)priv)->dev;
-
-	if (f->ctrl_class != V4L2_CTRL_CLASS_MPEG)
-		return -EINVAL;
-	return cx2341x_ext_ctrls(&dev->params, 0, f, VIDIOC_G_EXT_CTRLS);
-}
-
-static int vidioc_s_ext_ctrls (struct file *file, void *priv,
-			       struct v4l2_ext_controls *f)
-{
-	struct cx8802_dev *dev  = ((struct cx8802_fh *)priv)->dev;
-	struct cx2341x_mpeg_params p;
-	int err;
-
-	if (f->ctrl_class != V4L2_CTRL_CLASS_MPEG)
-		return -EINVAL;
+	struct cx8802_dev *dev  = fh->dev;
 
 	if (dev->mpeg_active)
 		blackbird_stop_codec(dev);
-
-	p = dev->params;
-	err = cx2341x_ext_ctrls(&p, 0, f, VIDIOC_S_EXT_CTRLS);
-	if (!err) {
-		err = cx2341x_update(dev, blackbird_mbox_func, &dev->params, &p);
-		dev->params = p;
-	}
-	return err;
-}
-
-static int vidioc_try_ext_ctrls (struct file *file, void *priv,
-			       struct v4l2_ext_controls *f)
-{
-	struct cx8802_dev *dev  = ((struct cx8802_fh *)priv)->dev;
-	struct cx2341x_mpeg_params p;
-	int err;
-
-	if (f->ctrl_class != V4L2_CTRL_CLASS_MPEG)
-		return -EINVAL;
-	p = dev->params;
-	err = cx2341x_ext_ctrls(&p, 0, f, VIDIOC_TRY_EXT_CTRLS);
-
-	return err;
+	return videobuf_streamoff(&fh->mpegq);
 }
 
 static int vidioc_s_frequency (struct file *file, void *priv,
@@ -870,13 +834,9 @@ static int vidioc_log_status (struct file *file, void *priv)
 	struct cx88_core  *core = dev->core;
 	char name[32 + 2];
 
-	snprintf(name, sizeof(name), "%s/2", core->name);
-	printk("%s/2: ============  START LOG STATUS  ============\n",
-		core->name);
+ 	snprintf(name, sizeof(name), "%s/2", core->name);
 	call_all(core, core, log_status);
-	cx2341x_log_status(&dev->params, name);
-	printk("%s/2: =============  END LOG STATUS  =============\n",
-		core->name);
+	v4l2_ctrl_handler_log_status(&dev->cxhdl.hdl, name);
 	return 0;
 }
 
@@ -1082,10 +1042,11 @@ mpeg_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
 static unsigned int
 mpeg_poll(struct file *file, struct poll_table_struct *wait)
 {
+	unsigned long req_events = poll_requested_events(wait);
 	struct cx8802_fh *fh = file->private_data;
 	struct cx8802_dev *dev = fh->dev;
 
-	if (!dev->mpeg_active)
+	if (!dev->mpeg_active && (req_events & (POLLIN | POLLRDNORM)))
 		blackbird_start_codec(file, fh);
 
 	return videobuf_poll_stream(file, &fh->mpegq, wait);
@@ -1122,9 +1083,6 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_dqbuf         = vidioc_dqbuf,
 	.vidioc_streamon      = vidioc_streamon,
 	.vidioc_streamoff     = vidioc_streamoff,
-	.vidioc_g_ext_ctrls   = vidioc_g_ext_ctrls,
-	.vidioc_s_ext_ctrls   = vidioc_s_ext_ctrls,
-	.vidioc_try_ext_ctrls = vidioc_try_ext_ctrls,
 	.vidioc_s_frequency   = vidioc_s_frequency,
 	.vidioc_log_status    = vidioc_log_status,
 	.vidioc_enum_input    = vidioc_enum_input,
@@ -1209,6 +1167,7 @@ static int blackbird_register_video(struct cx8802_dev *dev)
 
 	dev->mpeg_dev = cx88_vdev_init(dev->core,dev->pci,
 				       &cx8802_mpeg_template,"mpeg");
+	dev->mpeg_dev->ctrl_handler = &dev->cxhdl.hdl;
 	video_set_drvdata(dev->mpeg_dev, dev);
 	err = video_register_device(dev->mpeg_dev,VFL_TYPE_GRABBER, -1);
 	if (err < 0) {
@@ -1240,18 +1199,23 @@ static int cx8802_blackbird_probe(struct cx8802_driver *drv)
 	if (!(core->board.mpeg & CX88_MPEG_BLACKBIRD))
 		goto fail_core;
 
-	dev->width = 720;
-	dev->height = 576;
-	cx2341x_fill_defaults(&dev->params);
-	dev->params.port = CX2341X_PORT_STREAMING;
-
 	cx8802_mpeg_template.current_norm = core->tvnorm;
 
+	dev->width = 720;
 	if (core->tvnorm & V4L2_STD_525_60) {
 		dev->height = 480;
 	} else {
 		dev->height = 576;
 	}
+	dev->cxhdl.port = CX2341X_PORT_STREAMING;
+	dev->cxhdl.width = dev->width;
+	dev->cxhdl.height = dev->height;
+	dev->cxhdl.func = blackbird_mbox_func;
+	dev->cxhdl.priv = dev;
+	err = cx2341x_handler_init(&dev->cxhdl, 36);
+	if (err)
+		goto fail_core;
+	v4l2_ctrl_add_handler(&dev->cxhdl.hdl, &core->video_hdl);
 
 	/* blackbird stuff */
 	printk("%s/2: cx23416 based mpeg encoder (blackbird reference design)\n",
@@ -1259,12 +1223,14 @@ static int cx8802_blackbird_probe(struct cx8802_driver *drv)
 	host_setup(dev->core);
 
 	blackbird_initialize_codec(dev);
-	blackbird_register_video(dev);
 
 	/* initial device configuration: needed ? */
 //	init_controls(core);
 	cx88_set_tvnorm(core,core->tvnorm);
 	cx88_video_mux(core,0);
+	cx2341x_handler_set_50hz(&dev->cxhdl, dev->height == 576);
+	cx2341x_handler_setup(&dev->cxhdl);
+	blackbird_register_video(dev);
 
 	return 0;
 
@@ -1274,8 +1240,12 @@ static int cx8802_blackbird_probe(struct cx8802_driver *drv)
 
 static int cx8802_blackbird_remove(struct cx8802_driver *drv)
 {
+	struct cx88_core *core = drv->core;
+	struct cx8802_dev *dev = core->dvbdev;
+
 	/* blackbird */
 	blackbird_unregister_video(drv->core->dvbdev);
+	v4l2_ctrl_handler_free(&dev->cxhdl.hdl);
 
 	return 0;
 }
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index 280bf6a..e79cb87 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -575,7 +575,7 @@ struct cx8802_dev {
 	unsigned char              mpeg_active; /* nonzero if mpeg encoder is active */
 
 	/* mpeg params */
-	struct cx2341x_mpeg_params params;
+	struct cx2341x_handler     cxhdl;
 #endif
 
 #if defined(CONFIG_VIDEO_CX88_DVB) || defined(CONFIG_VIDEO_CX88_DVB_MODULE)
-- 
1.7.10

