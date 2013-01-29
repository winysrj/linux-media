Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2132 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab3A2Qdo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 11:33:44 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 20/20] cx231xx-417: convert to the control framework.
Date: Tue, 29 Jan 2013 17:33:13 +0100
Message-Id: <701f7328438388816ab5c93e7de83ccb5c110660.1359476777.git.hans.verkuil@cisco.com>
In-Reply-To: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl>
References: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <8a9d877c6be8a336a44c69a21b3fca449294139d.1359476776.git.hans.verkuil@cisco.com>
References: <8a9d877c6be8a336a44c69a21b3fca449294139d.1359476776.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-417.c |  213 ++++++++++++-------------------
 drivers/media/usb/cx231xx/cx231xx.h     |    2 +-
 2 files changed, 86 insertions(+), 129 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index 567d7ab..49c842a 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -34,6 +34,7 @@
 #include <linux/vmalloc.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-event.h>
 #include <media/cx2341x.h>
 #include <media/tuner.h>
 #include <linux/usb.h>
@@ -744,7 +745,7 @@ static int cx231xx_mbox_func(void *priv, u32 command, int in, int out,
 	if (value != 0x12345678) {
 		dprintk(3, "Firmware and/or mailbox pointer not initialized or corrupted, signature = 0x%x, cmd = %s\n",
 			value, cmd_to_str(command));
-		return -1;
+		return -EIO;
 	}
 
 	/* This read looks at 32 bits, but flag is only 8 bits.
@@ -754,7 +755,7 @@ static int cx231xx_mbox_func(void *priv, u32 command, int in, int out,
 	if (flag) {
 		dprintk(3, "ERROR: Mailbox appears to be in use (%x), cmd = %s\n",
 				flag, cmd_to_str(command));
-		return -1;
+		return -EBUSY;
 	}
 
 	flag |= 1; /* tell 'em we're working on it */
@@ -783,7 +784,7 @@ static int cx231xx_mbox_func(void *priv, u32 command, int in, int out,
 			break;
 		if (time_after(jiffies, timeout)) {
 			dprintk(3, "ERROR: API Mailbox timeout\n");
-			return -1;
+			return -EIO;
 		}
 		udelay(10);
 	}
@@ -800,7 +801,7 @@ static int cx231xx_mbox_func(void *priv, u32 command, int in, int out,
 	flag = 0;
 	mc417_memory_write(dev, dev->cx23417_mailbox, flag);
 
-	return retval;
+	return 0;
 }
 
 /* We don't need to call the API often, so using just one
@@ -829,6 +830,7 @@ static int cx231xx_api_cmd(struct cx231xx *dev, u32 command,
 	return err;
 }
 
+
 static int cx231xx_find_mailbox(struct cx231xx *dev)
 {
 	u32 signature[4] = {
@@ -1092,10 +1094,10 @@ static void cx231xx_codec_settings(struct cx231xx *dev)
 	cx231xx_api_cmd(dev, CX2341X_ENC_SET_FRAME_SIZE, 2, 0,
 				dev->ts1.height, dev->ts1.width);
 
-	dev->mpeg_params.width = dev->ts1.width;
-	dev->mpeg_params.height = dev->ts1.height;
+	dev->mpeg_ctrl_handler.width = dev->ts1.width;
+	dev->mpeg_ctrl_handler.height = dev->ts1.height;
 
-	cx2341x_update(dev, cx231xx_mbox_func, NULL, &dev->mpeg_params);
+	cx2341x_handler_setup(&dev->mpeg_ctrl_handler);
 
 	cx231xx_api_cmd(dev, CX2341X_ENC_MISC, 2, 0, 3, 1);
 	cx231xx_api_cmd(dev, CX2341X_ENC_MISC, 2, 0, 4, 1);
@@ -1481,36 +1483,6 @@ static struct videobuf_queue_ops cx231xx_qops = {
 
 /* ------------------------------------------------------------------ */
 
-static const u32 *ctrl_classes[] = {
-	cx2341x_mpeg_ctrls,
-	NULL
-};
-
-static int cx231xx_queryctrl(struct cx231xx *dev,
-	struct v4l2_queryctrl *qctrl)
-{
-	qctrl->id = v4l2_ctrl_next(ctrl_classes, qctrl->id);
-	if (qctrl->id == 0)
-		return -EINVAL;
-
-	/* MPEG V4L2 controls */
-	if (cx2341x_ctrl_query(&dev->mpeg_params, qctrl))
-		qctrl->flags |= V4L2_CTRL_FLAG_DISABLED;
-
-	return 0;
-}
-
-static int cx231xx_querymenu(struct cx231xx *dev,
-	struct v4l2_querymenu *qmenu)
-{
-	struct v4l2_queryctrl qctrl;
-
-	qctrl.id = qmenu->id;
-	cx231xx_queryctrl(dev, &qctrl);
-	return v4l2_ctrl_query_menu(qmenu, &qctrl,
-		cx2341x_ctrl_get_menu(&dev->mpeg_params, qmenu->id));
-}
-
 static int vidioc_g_std(struct file *file, void *fh0, v4l2_std_id *norm)
 {
 	struct cx231xx_fh  *fh  = file->private_data;
@@ -1537,12 +1509,12 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *id)
 		dprintk(3, "encodernorm set to NTSC\n");
 		dev->norm = V4L2_STD_NTSC;
 		dev->ts1.height = 480;
-		dev->mpeg_params.is_50hz = 0;
+		cx2341x_handler_set_50hz(&dev->mpeg_ctrl_handler, false);
 	} else {
 		dprintk(3, "encodernorm set to PAL\n");
 		dev->norm = V4L2_STD_PAL_B;
 		dev->ts1.height = 576;
-		dev->mpeg_params.is_50hz = 1;
+		cx2341x_handler_set_50hz(&dev->mpeg_ctrl_handler, true);
 	}
 	call_all(dev, core, s_std, dev->norm);
 	/* do mode control overrides */
@@ -1680,92 +1652,13 @@ static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 	return videobuf_streamoff(&fh->vidq);
 }
 
-static int vidioc_g_ext_ctrls(struct file *file, void *priv,
-				struct v4l2_ext_controls *f)
-{
-	struct cx231xx_fh  *fh  = priv;
-	struct cx231xx *dev = fh->dev;
-
-	dprintk(3, "enter vidioc_g_ext_ctrls()\n");
-	if (f->ctrl_class != V4L2_CTRL_CLASS_MPEG)
-		return -EINVAL;
-	dprintk(3, "exit vidioc_g_ext_ctrls()\n");
-	return cx2341x_ext_ctrls(&dev->mpeg_params, 0, f, VIDIOC_G_EXT_CTRLS);
-}
-
-static int vidioc_s_ext_ctrls(struct file *file, void *priv,
-				struct v4l2_ext_controls *f)
-{
-	struct cx231xx_fh  *fh  = priv;
-	struct cx231xx *dev = fh->dev;
-	struct cx2341x_mpeg_params p;
-	int err;
-
-	dprintk(3, "enter vidioc_s_ext_ctrls()\n");
-	if (f->ctrl_class != V4L2_CTRL_CLASS_MPEG)
-		return -EINVAL;
-
-	p = dev->mpeg_params;
-	err = cx2341x_ext_ctrls(&p, 0, f, VIDIOC_TRY_EXT_CTRLS);
-	if (err == 0) {
-		err = cx2341x_update(dev, cx231xx_mbox_func,
-			&dev->mpeg_params, &p);
-		dev->mpeg_params = p;
-	}
-
-	return err;
-}
-
-static int vidioc_try_ext_ctrls(struct file *file, void *priv,
-				struct v4l2_ext_controls *f)
-{
-	struct cx231xx_fh  *fh  = priv;
-	struct cx231xx *dev = fh->dev;
-	struct cx2341x_mpeg_params p;
-	int err;
-
-	dprintk(3, "enter vidioc_try_ext_ctrls()\n");
-	if (f->ctrl_class != V4L2_CTRL_CLASS_MPEG)
-		return -EINVAL;
-
-	p = dev->mpeg_params;
-	err = cx2341x_ext_ctrls(&p, 0, f, VIDIOC_TRY_EXT_CTRLS);
-	dprintk(3, "exit vidioc_try_ext_ctrls() err=%d\n", err);
-	return err;
-}
-
 static int vidioc_log_status(struct file *file, void *priv)
 {
 	struct cx231xx_fh  *fh  = priv;
 	struct cx231xx *dev = fh->dev;
-	char name[32 + 2];
 
-	snprintf(name, sizeof(name), "%s/2", dev->name);
 	call_all(dev, core, log_status);
-	cx2341x_log_status(&dev->mpeg_params, name);
-	return 0;
-}
-
-static int vidioc_querymenu(struct file *file, void *priv,
-				struct v4l2_querymenu *a)
-{
-	struct cx231xx_fh  *fh  = priv;
-	struct cx231xx *dev = fh->dev;
-
-	dprintk(3, "enter vidioc_querymenu()\n");
-	dprintk(3, "exit vidioc_querymenu()\n");
-	return cx231xx_querymenu(dev, a);
-}
-
-static int vidioc_queryctrl(struct file *file, void *priv,
-				struct v4l2_queryctrl *c)
-{
-	struct cx231xx_fh  *fh  = priv;
-	struct cx231xx *dev = fh->dev;
-
-	dprintk(3, "enter vidioc_queryctrl()\n");
-	dprintk(3, "exit vidioc_queryctrl()\n");
-	return cx231xx_queryctrl(dev, c);
+	return v4l2_ctrl_log_status(file, priv);
 }
 
 static int mpeg_open(struct file *file)
@@ -1885,9 +1778,23 @@ static ssize_t mpeg_read(struct file *file, char __user *data,
 static unsigned int mpeg_poll(struct file *file,
 	struct poll_table_struct *wait)
 {
+	unsigned long req_events = poll_requested_events(wait);
 	struct cx231xx_fh *fh = file->private_data;
+	struct cx231xx *dev = fh->dev;
+	unsigned int res = 0;
 
-	return videobuf_poll_stream(file, &fh->vidq, wait);
+	if (v4l2_event_pending(&fh->fh))
+		res |= POLLPRI;
+	else
+		poll_wait(file, &fh->fh.wait, wait);
+
+	if (!(req_events & (POLLIN | POLLRDNORM)))
+		return res;
+
+	mutex_lock(&dev->lock);
+	res |= videobuf_poll_stream(file, &fh->vidq, wait);
+	mutex_unlock(&dev->lock);
+	return res;
 }
 
 static int mpeg_mmap(struct file *file, struct vm_area_struct *vma)
@@ -1932,17 +1839,14 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_dqbuf		 = vidioc_dqbuf,
 	.vidioc_streamon	 = vidioc_streamon,
 	.vidioc_streamoff	 = vidioc_streamoff,
-	.vidioc_g_ext_ctrls	 = vidioc_g_ext_ctrls,
-	.vidioc_s_ext_ctrls	 = vidioc_s_ext_ctrls,
-	.vidioc_try_ext_ctrls	 = vidioc_try_ext_ctrls,
 	.vidioc_log_status	 = vidioc_log_status,
-	.vidioc_querymenu	 = vidioc_querymenu,
-	.vidioc_queryctrl	 = vidioc_queryctrl,
 	.vidioc_g_chip_ident	 = cx231xx_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register	 = cx231xx_g_register,
 	.vidioc_s_register	 = cx231xx_s_register,
 #endif
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 static struct video_device cx231xx_mpeg_template = {
@@ -1950,7 +1854,7 @@ static struct video_device cx231xx_mpeg_template = {
 	.fops          = &mpeg_fops,
 	.ioctl_ops     = &mpeg_ioctl_ops,
 	.minor         = -1,
-	.tvnorms       = CX231xx_NORMS,
+	.tvnorms       = V4L2_STD_ALL,
 };
 
 void cx231xx_417_unregister(struct cx231xx *dev)
@@ -1963,10 +1867,44 @@ void cx231xx_417_unregister(struct cx231xx *dev)
 			video_unregister_device(dev->v4l_device);
 		else
 			video_device_release(dev->v4l_device);
+		v4l2_ctrl_handler_free(&dev->mpeg_ctrl_handler.hdl);
 		dev->v4l_device = NULL;
 	}
 }
 
+static int cx231xx_s_video_encoding(struct cx2341x_handler *cxhdl, u32 val)
+{
+	struct cx231xx *dev = container_of(cxhdl, struct cx231xx, mpeg_ctrl_handler);
+	int is_mpeg1 = val == V4L2_MPEG_VIDEO_ENCODING_MPEG_1;
+	struct v4l2_mbus_framefmt fmt;
+
+	/* fix videodecoder resolution */
+	fmt.width = cxhdl->width / (is_mpeg1 ? 2 : 1);
+	fmt.height = cxhdl->height;
+	fmt.code = V4L2_MBUS_FMT_FIXED;
+	v4l2_subdev_call(dev->sd_cx25840, video, s_mbus_fmt, &fmt);
+	return 0;
+}
+
+static int cx231xx_s_audio_sampling_freq(struct cx2341x_handler *cxhdl, u32 idx)
+{
+	static const u32 freqs[3] = { 44100, 48000, 32000 };
+	struct cx231xx *dev = container_of(cxhdl, struct cx231xx, mpeg_ctrl_handler);
+
+	/* The audio clock of the digitizer must match the codec sample
+	   rate otherwise you get some very strange effects. */
+	if (idx < ARRAY_SIZE(freqs))
+		call_all(dev, audio, s_clock_freq, freqs[idx]);
+	return 0;
+}
+
+static struct cx2341x_handler_ops cx231xx_ops = {
+	/* needed for the video clock freq */
+	.s_audio_sampling_freq = cx231xx_s_audio_sampling_freq,
+	/* needed for setting up the video resolution */
+	.s_video_encoding = cx231xx_s_video_encoding,
+};
+
 static struct video_device *cx231xx_video_dev_alloc(
 	struct cx231xx *dev,
 	struct usb_device *usbdev,
@@ -1987,6 +1925,7 @@ static struct video_device *cx231xx_video_dev_alloc(
 	vfd->lock = &dev->lock;
 	vfd->release = video_device_release;
 	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
+	vfd->ctrl_handler = &dev->mpeg_ctrl_handler.hdl;
 	video_set_drvdata(vfd, dev);
 	if (dev->tuner_type == TUNER_ABSENT) {
 		v4l2_disable_ioctl(vfd, VIDIOC_G_FREQUENCY);
@@ -2016,10 +1955,27 @@ int cx231xx_417_register(struct cx231xx *dev)
 		tsport->height = 576;
 
 	tsport->width = 720;
-	cx2341x_fill_defaults(&dev->mpeg_params);
+	err = cx2341x_handler_init(&dev->mpeg_ctrl_handler, 50);
+	if (err) {
+		dprintk(3, "%s: can't init cx2341x controls\n", dev->name);
+		return err;
+	}
+	dev->mpeg_ctrl_handler.func = cx231xx_mbox_func;
+	dev->mpeg_ctrl_handler.priv = dev;
+	dev->mpeg_ctrl_handler.ops = &cx231xx_ops;
+	if (dev->sd_cx25840)
+		v4l2_ctrl_add_handler(&dev->mpeg_ctrl_handler.hdl,
+				dev->sd_cx25840->ctrl_handler, NULL);
+	if (dev->mpeg_ctrl_handler.hdl.error) {
+		err = dev->mpeg_ctrl_handler.hdl.error;
+		dprintk(3, "%s: can't add cx25840 controls\n", dev->name);
+		v4l2_ctrl_handler_free(&dev->mpeg_ctrl_handler.hdl);
+		return err;
+	}
 	dev->norm = V4L2_STD_NTSC;
 
-	dev->mpeg_params.port = CX2341X_PORT_SERIAL;
+	dev->mpeg_ctrl_handler.port = CX2341X_PORT_SERIAL;
+	cx2341x_handler_set_50hz(&dev->mpeg_ctrl_handler, false);
 
 	/* Allocate and initialize V4L video device */
 	dev->v4l_device = cx231xx_video_dev_alloc(dev,
@@ -2028,6 +1984,7 @@ int cx231xx_417_register(struct cx231xx *dev)
 		VFL_TYPE_GRABBER, -1);
 	if (err < 0) {
 		dprintk(3, "%s: can't register mpeg device\n", dev->name);
+		v4l2_ctrl_handler_free(&dev->mpeg_ctrl_handler.hdl);
 		return err;
 	}
 
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index 6130e4f..0f92fd1 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -612,6 +612,7 @@ struct cx231xx {
 	struct v4l2_subdev *sd_tuner;
 	struct v4l2_ctrl_handler ctrl_handler;
 	struct v4l2_ctrl_handler radio_ctrl_handler;
+	struct cx2341x_handler mpeg_ctrl_handler;
 
 	struct work_struct wq_trigger;		/* Trigger to start/stop audio for alsa module */
 	atomic_t	   stream_started;	/* stream should be running if true */
@@ -715,7 +716,6 @@ struct cx231xx {
 	u8 USE_ISO;
 	struct cx231xx_tvnorm      encodernorm;
 	struct cx231xx_tsport      ts1, ts2;
-	struct cx2341x_mpeg_params mpeg_params;
 	struct video_device        *v4l_device;
 	atomic_t                   v4l_reader_count;
 	u32                        freq;
-- 
1.7.10.4

