Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4223 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbaHNJyW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Aug 2014 05:54:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 05/20] cx23885: convert to the control framework
Date: Thu, 14 Aug 2014 11:53:50 +0200
Message-Id: <1408010045-24016-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
References: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is part 1, converting the uncompressed video/vbi nodes to use
the control framework.

The next patch converts the compressed video node as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885-417.c   |  20 ---
 drivers/media/pci/cx23885/cx23885-core.c  |  17 ++-
 drivers/media/pci/cx23885/cx23885-video.c | 246 +++++-------------------------
 drivers/media/pci/cx23885/cx23885.h       |  12 +-
 4 files changed, 51 insertions(+), 244 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index 395f7a9..d44395c 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1313,22 +1313,6 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	return cx23885_set_frequency(file, priv, f);
 }
 
-static int vidioc_g_ctrl(struct file *file, void *priv,
-	struct v4l2_control *ctl)
-{
-	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
-
-	return cx23885_get_control(dev, ctl);
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-	struct v4l2_control *ctl)
-{
-	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
-
-	return cx23885_set_control(dev, ctl);
-}
-
 static int vidioc_querycap(struct file *file, void  *priv,
 				struct v4l2_capability *cap)
 {
@@ -1672,8 +1656,6 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_s_tuner		 = vidioc_s_tuner,
 	.vidioc_g_frequency	 = vidioc_g_frequency,
 	.vidioc_s_frequency	 = vidioc_s_frequency,
-	.vidioc_s_ctrl		 = vidioc_s_ctrl,
-	.vidioc_g_ctrl		 = vidioc_g_ctrl,
 	.vidioc_querycap	 = vidioc_querycap,
 	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
 	.vidioc_g_fmt_vid_cap	 = vidioc_g_fmt_vid_cap,
@@ -1689,8 +1671,6 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_s_ext_ctrls	 = vidioc_s_ext_ctrls,
 	.vidioc_try_ext_ctrls	 = vidioc_try_ext_ctrls,
 	.vidioc_log_status	 = vidioc_log_status,
-	.vidioc_querymenu	 = vidioc_querymenu,
-	.vidioc_queryctrl	 = vidioc_queryctrl,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_chip_info	 = cx23885_g_chip_info,
 	.vidioc_g_register	 = cx23885_g_register,
diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index edcd79d..075b28e 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -2087,6 +2087,7 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
 			   const struct pci_device_id *pci_id)
 {
 	struct cx23885_dev *dev;
+	struct v4l2_ctrl_handler *hdl;
 	int err;
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
@@ -2097,6 +2098,14 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
 	if (err < 0)
 		goto fail_free;
 
+	hdl = &dev->ctrl_handler;
+	v4l2_ctrl_handler_init(hdl, 6);
+	if (hdl->error) {
+		err = hdl->error;
+		goto fail_ctrl;
+	}
+	dev->v4l2_dev.ctrl_handler = hdl;
+
 	/* Prepare to handle notifications from subdevices */
 	cx23885_v4l2_dev_notify_init(dev);
 
@@ -2104,12 +2113,12 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
 	dev->pci = pci_dev;
 	if (pci_enable_device(pci_dev)) {
 		err = -EIO;
-		goto fail_unreg;
+		goto fail_ctrl;
 	}
 
 	if (cx23885_dev_setup(dev) < 0) {
 		err = -EINVAL;
-		goto fail_unreg;
+		goto fail_ctrl;
 	}
 
 	/* print pci info */
@@ -2157,7 +2166,8 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
 
 fail_irq:
 	cx23885_dev_unregister(dev);
-fail_unreg:
+fail_ctrl:
+	v4l2_ctrl_handler_free(hdl);
 	v4l2_device_unregister(&dev->v4l2_dev);
 fail_free:
 	kfree(dev);
@@ -2180,6 +2190,7 @@ static void cx23885_finidev(struct pci_dev *pci_dev)
 	free_irq(pci_dev->irq, dev);
 
 	cx23885_dev_unregister(dev);
+	v4l2_ctrl_handler_free(&dev->ctrl_handler);
 	v4l2_device_unregister(v4l2_dev);
 	kfree(dev);
 }
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index ba93e29..090d48b 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -35,6 +35,7 @@
 #include "cx23885-video.h"
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-event.h>
 #include "cx23885-ioctl.h"
 #include "tuner-xc2028.h"
 
@@ -170,119 +171,6 @@ static struct cx23885_fmt *format_by_fourcc(unsigned int fourcc)
 
 /* ------------------------------------------------------------------- */
 
-static const struct v4l2_queryctrl no_ctl = {
-	.name  = "42",
-	.flags = V4L2_CTRL_FLAG_DISABLED,
-};
-
-static struct cx23885_ctrl cx23885_ctls[] = {
-	/* --- video --- */
-	{
-		.v = {
-			.id            = V4L2_CID_BRIGHTNESS,
-			.name          = "Brightness",
-			.minimum       = 0x00,
-			.maximum       = 0xff,
-			.step          = 1,
-			.default_value = 0x7f,
-			.type          = V4L2_CTRL_TYPE_INTEGER,
-		},
-		.off                   = 128,
-		.reg                   = LUMA_CTRL,
-		.mask                  = 0x00ff,
-		.shift                 = 0,
-	}, {
-		.v = {
-			.id            = V4L2_CID_CONTRAST,
-			.name          = "Contrast",
-			.minimum       = 0,
-			.maximum       = 0x7f,
-			.step          = 1,
-			.default_value = 0x3f,
-			.type          = V4L2_CTRL_TYPE_INTEGER,
-		},
-		.off                   = 0,
-		.reg                   = LUMA_CTRL,
-		.mask                  = 0xff00,
-		.shift                 = 8,
-	}, {
-		.v = {
-			.id            = V4L2_CID_HUE,
-			.name          = "Hue",
-			.minimum       = -127,
-			.maximum       = 128,
-			.step          = 1,
-			.default_value = 0x0,
-			.type          = V4L2_CTRL_TYPE_INTEGER,
-		},
-		.off                   = 128,
-		.reg                   = CHROMA_CTRL,
-		.mask                  = 0xff0000,
-		.shift                 = 16,
-	}, {
-		/* strictly, this only describes only U saturation.
-		 * V saturation is handled specially through code.
-		 */
-		.v = {
-			.id            = V4L2_CID_SATURATION,
-			.name          = "Saturation",
-			.minimum       = 0,
-			.maximum       = 0x7f,
-			.step          = 1,
-			.default_value = 0x3f,
-			.type          = V4L2_CTRL_TYPE_INTEGER,
-		},
-		.off                   = 0,
-		.reg                   = CHROMA_CTRL,
-		.mask                  = 0x00ff,
-		.shift                 = 0,
-	}, {
-	/* --- audio --- */
-		.v = {
-			.id            = V4L2_CID_AUDIO_MUTE,
-			.name          = "Mute",
-			.minimum       = 0,
-			.maximum       = 1,
-			.default_value = 1,
-			.type          = V4L2_CTRL_TYPE_BOOLEAN,
-		},
-		.reg                   = PATH1_CTL1,
-		.mask                  = (0x1f << 24),
-		.shift                 = 24,
-	}, {
-		.v = {
-			.id            = V4L2_CID_AUDIO_VOLUME,
-			.name          = "Volume",
-			.minimum       = 0,
-			.maximum       = 65535,
-			.step          = 65535 / 100,
-			.default_value = 65535,
-			.type          = V4L2_CTRL_TYPE_INTEGER,
-		},
-		.reg                   = PATH1_VOL_CTL,
-		.mask                  = 0xff,
-		.shift                 = 0,
-	}
-};
-static const int CX23885_CTLS = ARRAY_SIZE(cx23885_ctls);
-
-/* Must be sorted from low to high control ID! */
-static const u32 cx23885_user_ctrls[] = {
-	V4L2_CID_USER_CLASS,
-	V4L2_CID_BRIGHTNESS,
-	V4L2_CID_CONTRAST,
-	V4L2_CID_SATURATION,
-	V4L2_CID_HUE,
-	V4L2_CID_AUDIO_VOLUME,
-	V4L2_CID_AUDIO_MUTE,
-	0
-};
-
-static const u32 *ctrl_classes[] = {
-	cx23885_user_ctrls,
-	NULL
-};
-
 void cx23885_video_wakeup(struct cx23885_dev *dev,
 	struct cx23885_dmaqueue *q, u32 count)
 {
@@ -352,24 +240,6 @@ static struct video_device *cx23885_vdev_init(struct cx23885_dev *dev,
 	return vfd;
 }
 
-static int cx23885_ctrl_query(struct v4l2_queryctrl *qctrl)
-{
-	int i;
-
-	if (qctrl->id < V4L2_CID_BASE ||
-	    qctrl->id >= V4L2_CID_LASTP1)
-		return -EINVAL;
-	for (i = 0; i < CX23885_CTLS; i++)
-		if (cx23885_ctls[i].v.id == qctrl->id)
-			break;
-	if (i == CX23885_CTLS) {
-		*qctrl = no_ctl;
-		return 0;
-	}
-	*qctrl = cx23885_ctls[i].v;
-	return 0;
-}
-
 /* ------------------------------------------------------------------- */
 /* resource management                                                 */
 
@@ -936,12 +806,20 @@ static unsigned int video_poll(struct file *file,
 {
 	struct cx23885_fh *fh = file->private_data;
 	struct cx23885_buffer *buf;
-	unsigned int rc = POLLERR;
+	unsigned long req_events = poll_requested_events(wait);
+	unsigned int rc = 0;
+
+	if (v4l2_event_pending(&fh->fh))
+		rc = POLLPRI;
+	else
+		poll_wait(file, &fh->fh.wait, wait);
+	if (!(req_events & (POLLIN | POLLRDNORM)))
+		return rc;
 
 	if (V4L2_BUF_TYPE_VBI_CAPTURE == fh->type) {
 		if (!res_get(fh->dev, fh, RESOURCE_VBI))
-			return POLLERR;
-		return videobuf_poll_stream(file, &fh->vbiq, wait);
+			return rc | POLLERR;
+		return rc | videobuf_poll_stream(file, &fh->vbiq, wait);
 	}
 
 	mutex_lock(&fh->vidq.vb_lock);
@@ -960,9 +838,7 @@ static unsigned int video_poll(struct file *file,
 	poll_wait(file, &buf->vb.done, wait);
 	if (buf->vb.state == VIDEOBUF_DONE ||
 	    buf->vb.state == VIDEOBUF_ERROR)
-		rc =  POLLIN|POLLRDNORM;
-	else
-		rc = 0;
+		rc |= POLLIN | POLLRDNORM;
 done:
 	mutex_unlock(&fh->vidq.vb_lock);
 	return rc;
@@ -1022,39 +898,6 @@ static int video_mmap(struct file *file, struct vm_area_struct *vma)
 }
 
 /* ------------------------------------------------------------------ */
-/* VIDEO CTRL IOCTLS                                                  */
-
-int cx23885_get_control(struct cx23885_dev *dev,
-	struct v4l2_control *ctl)
-{
-	dprintk(1, "%s() calling cx25840(VIDIOC_G_CTRL)\n", __func__);
-	call_all(dev, core, g_ctrl, ctl);
-	return 0;
-}
-
-int cx23885_set_control(struct cx23885_dev *dev,
-	struct v4l2_control *ctl)
-{
-	dprintk(1, "%s() calling cx25840(VIDIOC_S_CTRL)\n", __func__);
-	call_all(dev, core, s_ctrl, ctl);
-
-	return 0;
-}
-
-static void init_controls(struct cx23885_dev *dev)
-{
-	struct v4l2_control ctrl;
-	int i;
-
-	for (i = 0; i < CX23885_CTLS; i++) {
-		ctrl.id = cx23885_ctls[i].v.id;
-		ctrl.value = cx23885_ctls[i].v.default_value;
-
-		cx23885_set_control(dev, &ctrl);
-	}
-}
-
-/* ------------------------------------------------------------------ */
 /* VIDEO IOCTLS                                                       */
 
 static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
@@ -1453,31 +1296,6 @@ static int vidioc_s_audinput(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_queryctrl(struct file *file, void *priv,
-				struct v4l2_queryctrl *qctrl)
-{
-	qctrl->id = v4l2_ctrl_next(ctrl_classes, qctrl->id);
-	if (unlikely(qctrl->id == 0))
-		return -EINVAL;
-	return cx23885_ctrl_query(qctrl);
-}
-
-static int vidioc_g_ctrl(struct file *file, void *priv,
-				struct v4l2_control *ctl)
-{
-	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
-
-	return cx23885_get_control(dev, ctl);
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-				struct v4l2_control *ctl)
-{
-	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
-
-	return cx23885_set_control(dev, ctl);
-}
-
 static int vidioc_g_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *t)
 {
@@ -1529,7 +1347,8 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 
 static int cx23885_set_freq(struct cx23885_dev *dev, const struct v4l2_frequency *f)
 {
-	struct v4l2_control ctrl;
+	struct v4l2_ctrl *mute;
+	int old_mute_val = 1;
 
 	if (dev->tuner_type == TUNER_ABSENT)
 		return -EINVAL;
@@ -1539,9 +1358,12 @@ static int cx23885_set_freq(struct cx23885_dev *dev, const struct v4l2_frequency
 	dev->freq = f->frequency;
 
 	/* I need to mute audio here */
-	ctrl.id = V4L2_CID_AUDIO_MUTE;
-	ctrl.value = 1;
-	cx23885_set_control(dev, &ctrl);
+	mute = v4l2_ctrl_find(&dev->ctrl_handler, V4L2_CID_AUDIO_MUTE);
+	if (mute) {
+		old_mute_val = v4l2_ctrl_g_ctrl(mute);
+		if (!old_mute_val)
+			v4l2_ctrl_s_ctrl(mute, 1);
+	}
 
 	call_all(dev, tuner, s_frequency, f);
 
@@ -1549,8 +1371,8 @@ static int cx23885_set_freq(struct cx23885_dev *dev, const struct v4l2_frequency
 	msleep(100);
 
 	/* I need to unmute audio here */
-	ctrl.value = 0;
-	cx23885_set_control(dev, &ctrl);
+	if (old_mute_val == 0)
+		v4l2_ctrl_s_ctrl(mute, old_mute_val);
 
 	return 0;
 }
@@ -1558,7 +1380,8 @@ static int cx23885_set_freq(struct cx23885_dev *dev, const struct v4l2_frequency
 static int cx23885_set_freq_via_ops(struct cx23885_dev *dev,
 	const struct v4l2_frequency *f)
 {
-	struct v4l2_control ctrl;
+	struct v4l2_ctrl *mute;
+	int old_mute_val = 1;
 	struct videobuf_dvb_frontend *vfe;
 	struct dvb_frontend *fe;
 
@@ -1572,9 +1395,12 @@ static int cx23885_set_freq_via_ops(struct cx23885_dev *dev,
 	dev->freq = f->frequency;
 
 	/* I need to mute audio here */
-	ctrl.id = V4L2_CID_AUDIO_MUTE;
-	ctrl.value = 1;
-	cx23885_set_control(dev, &ctrl);
+	mute = v4l2_ctrl_find(&dev->ctrl_handler, V4L2_CID_AUDIO_MUTE);
+	if (mute) {
+		old_mute_val = v4l2_ctrl_g_ctrl(mute);
+		if (!old_mute_val)
+			v4l2_ctrl_s_ctrl(mute, 1);
+	}
 
 	/* If HVR1850 */
 	dprintk(1, "%s() frequency=%d tuner=%d std=0x%llx\n", __func__,
@@ -1603,8 +1429,8 @@ static int cx23885_set_freq_via_ops(struct cx23885_dev *dev,
 	msleep(100);
 
 	/* I need to unmute audio here */
-	ctrl.value = 0;
-	cx23885_set_control(dev, &ctrl);
+	if (old_mute_val == 0)
+		v4l2_ctrl_s_ctrl(mute, old_mute_val);
 
 	return 0;
 }
@@ -1749,9 +1575,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_g_input       = vidioc_g_input,
 	.vidioc_s_input       = vidioc_s_input,
 	.vidioc_log_status    = vidioc_log_status,
-	.vidioc_queryctrl     = vidioc_queryctrl,
-	.vidioc_g_ctrl        = vidioc_g_ctrl,
-	.vidioc_s_ctrl        = vidioc_s_ctrl,
 	.vidioc_streamon      = vidioc_streamon,
 	.vidioc_streamoff     = vidioc_streamoff,
 	.vidioc_g_tuner       = vidioc_g_tuner,
@@ -1766,6 +1589,8 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_enumaudio     = vidioc_enum_audinput,
 	.vidioc_g_audio       = vidioc_g_audinput,
 	.vidioc_s_audio       = vidioc_s_audinput,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 static struct video_device cx23885_vbi_template;
@@ -1889,7 +1714,6 @@ int cx23885_video_register(struct cx23885_dev *dev)
 	/* initial device configuration */
 	mutex_lock(&dev->lock);
 	cx23885_set_tvnorm(dev, dev->tvnorm);
-	init_controls(dev);
 	cx23885_video_mux(dev, 0);
 	cx23885_audio_mux(dev, 0);
 	mutex_unlock(&dev->lock);
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index de164c9..516435c 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -26,6 +26,7 @@
 
 #include <media/v4l2-device.h>
 #include <media/v4l2-fh.h>
+#include <media/v4l2-ctrls.h>
 #include <media/tuner.h>
 #include <media/tveeprom.h>
 #include <media/videobuf-dma-sg.h>
@@ -132,14 +133,6 @@ struct cx23885_fmt {
 	u32   cxformat;
 };
 
-struct cx23885_ctrl {
-	struct v4l2_queryctrl v;
-	u32                   off;
-	u32                   reg;
-	u32                   mask;
-	u32                   shift;
-};
-
 struct cx23885_tvnorm {
 	char		*name;
 	v4l2_std_id	id;
@@ -370,6 +363,7 @@ struct cx23885_audio_dev {
 struct cx23885_dev {
 	atomic_t                   refcount;
 	struct v4l2_device 	   v4l2_dev;
+	struct v4l2_ctrl_handler   ctrl_handler;
 
 	/* pci stuff */
 	struct pci_dev             *pci;
@@ -597,8 +591,6 @@ int cx23885_enum_input(struct cx23885_dev *dev, struct v4l2_input *i);
 int cx23885_set_input(struct file *file, void *priv, unsigned int i);
 int cx23885_get_input(struct file *file, void *priv, unsigned int *i);
 int cx23885_set_frequency(struct file *file, void *priv, const struct v4l2_frequency *f);
-int cx23885_set_control(struct cx23885_dev *dev, struct v4l2_control *ctl);
-int cx23885_get_control(struct cx23885_dev *dev, struct v4l2_control *ctl);
 int cx23885_set_tvnorm(struct cx23885_dev *dev, v4l2_std_id norm);
 
 /* ----------------------------------------------------------- */
-- 
2.1.0.rc1

