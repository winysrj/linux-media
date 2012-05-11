Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4332 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab2EKHzj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 03:55:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Michael Hunold <hunold@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 04/16] saa7146: saa7146: first round of cleanups.
Date: Fri, 11 May 2012 09:54:58 +0200
Message-Id: <e345ce36ab3d14a650b2fd118595c1d0ce086d87.1336722502.git.hans.verkuil@cisco.com>
In-Reply-To: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
References: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
References: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Convert to the control framework, fix the easy v4l2-compliance failures.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/saa7146_fops.c  |   27 +++++
 drivers/media/common/saa7146_video.c |  210 ++++++----------------------------
 include/media/saa7146.h              |    2 +
 include/media/saa7146_vv.h           |    1 +
 4 files changed, 68 insertions(+), 172 deletions(-)

diff --git a/drivers/media/common/saa7146_fops.c b/drivers/media/common/saa7146_fops.c
index 71f8e01..734ea6c 100644
--- a/drivers/media/common/saa7146_fops.c
+++ b/drivers/media/common/saa7146_fops.c
@@ -429,8 +429,13 @@ static void vv_callback(struct saa7146_dev *dev, unsigned long status)
 	}
 }
 
+static const struct v4l2_ctrl_ops saa7146_ctrl_ops = {
+	.s_ctrl = saa7146_s_ctrl,
+};
+
 int saa7146_vv_init(struct saa7146_dev* dev, struct saa7146_ext_vv *ext_vv)
 {
+	struct v4l2_ctrl_handler *hdl = &dev->ctrl_handler;
 	struct saa7146_vv *vv;
 	int err;
 
@@ -438,9 +443,28 @@ int saa7146_vv_init(struct saa7146_dev* dev, struct saa7146_ext_vv *ext_vv)
 	if (err)
 		return err;
 
+	v4l2_ctrl_handler_init(hdl, 6);
+	v4l2_ctrl_new_std(hdl, &saa7146_ctrl_ops,
+		V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(hdl, &saa7146_ctrl_ops,
+		V4L2_CID_CONTRAST, 0, 127, 1, 64);
+	v4l2_ctrl_new_std(hdl, &saa7146_ctrl_ops,
+		V4L2_CID_SATURATION, 0, 127, 1, 64);
+	v4l2_ctrl_new_std(hdl, &saa7146_ctrl_ops,
+		V4L2_CID_VFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(hdl, &saa7146_ctrl_ops,
+		V4L2_CID_HFLIP, 0, 1, 1, 0);
+	if (hdl->error) {
+		err = hdl->error;
+		v4l2_ctrl_handler_free(hdl);
+		return err;
+	}
+	dev->v4l2_dev.ctrl_handler = hdl;
+
 	vv = kzalloc(sizeof(struct saa7146_vv), GFP_KERNEL);
 	if (vv == NULL) {
 		ERR("out of memory. aborting.\n");
+		v4l2_ctrl_handler_free(hdl);
 		return -ENOMEM;
 	}
 	ext_vv->ops = saa7146_video_ioctl_ops;
@@ -463,6 +487,7 @@ int saa7146_vv_init(struct saa7146_dev* dev, struct saa7146_ext_vv *ext_vv)
 	if( NULL == vv->d_clipping.cpu_addr ) {
 		ERR("out of memory. aborting.\n");
 		kfree(vv);
+		v4l2_ctrl_handler_free(hdl);
 		return -1;
 	}
 	memset(vv->d_clipping.cpu_addr, 0x0, SAA7146_CLIPPING_MEM);
@@ -486,6 +511,7 @@ int saa7146_vv_release(struct saa7146_dev* dev)
 
 	v4l2_device_unregister(&dev->v4l2_dev);
 	pci_free_consistent(dev->pci, SAA7146_CLIPPING_MEM, vv->d_clipping.cpu_addr, vv->d_clipping.dma_handle);
+	v4l2_ctrl_handler_free(&dev->ctrl_handler);
 	kfree(vv);
 	dev->vv_data = NULL;
 	dev->vv_callback = NULL;
@@ -512,6 +538,7 @@ int saa7146_register_device(struct video_device **vid, struct saa7146_dev* dev,
 	vfd->ioctl_ops = &dev->ext_vv_data->ops;
 	vfd->release = video_device_release;
 	vfd->lock = &dev->v4l2_lock;
+	vfd->v4l2_dev = &dev->v4l2_dev;
 	vfd->tvnorms = 0;
 	for (i = 0; i < dev->ext_vv_data->num_stds; i++)
 		vfd->tvnorms |= dev->ext_vv_data->stds[i].id;
diff --git a/drivers/media/common/saa7146_video.c b/drivers/media/common/saa7146_video.c
index ce30533..8818e66 100644
--- a/drivers/media/common/saa7146_video.c
+++ b/drivers/media/common/saa7146_video.c
@@ -202,65 +202,6 @@ int saa7146_stop_preview(struct saa7146_fh *fh)
 EXPORT_SYMBOL_GPL(saa7146_stop_preview);
 
 /********************************************************************************/
-/* device controls */
-
-static struct v4l2_queryctrl controls[] = {
-	{
-		.id		= V4L2_CID_BRIGHTNESS,
-		.name		= "Brightness",
-		.minimum	= 0,
-		.maximum	= 255,
-		.step		= 1,
-		.default_value	= 128,
-		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.flags 		= V4L2_CTRL_FLAG_SLIDER,
-	},{
-		.id		= V4L2_CID_CONTRAST,
-		.name		= "Contrast",
-		.minimum	= 0,
-		.maximum	= 127,
-		.step		= 1,
-		.default_value	= 64,
-		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.flags 		= V4L2_CTRL_FLAG_SLIDER,
-	},{
-		.id		= V4L2_CID_SATURATION,
-		.name		= "Saturation",
-		.minimum	= 0,
-		.maximum	= 127,
-		.step		= 1,
-		.default_value	= 64,
-		.type		= V4L2_CTRL_TYPE_INTEGER,
-		.flags 		= V4L2_CTRL_FLAG_SLIDER,
-	},{
-		.id		= V4L2_CID_VFLIP,
-		.name		= "Vertical Flip",
-		.minimum	= 0,
-		.maximum	= 1,
-		.type		= V4L2_CTRL_TYPE_BOOLEAN,
-	},{
-		.id		= V4L2_CID_HFLIP,
-		.name		= "Horizontal Flip",
-		.minimum	= 0,
-		.maximum	= 1,
-		.type		= V4L2_CTRL_TYPE_BOOLEAN,
-	},
-};
-static int NUM_CONTROLS = sizeof(controls)/sizeof(struct v4l2_queryctrl);
-
-#define V4L2_CID_PRIVATE_LASTP1      (V4L2_CID_PRIVATE_BASE + 0)
-
-static struct v4l2_queryctrl* ctrl_by_id(int id)
-{
-	int i;
-
-	for (i = 0; i < NUM_CONTROLS; i++)
-		if (controls[i].id == id)
-			return controls+i;
-	return NULL;
-}
-
-/********************************************************************************/
 /* common pagetable functions */
 
 static int saa7146_pgtable_build(struct saa7146_dev *dev, struct saa7146_buf *buf)
@@ -510,12 +451,13 @@ static int vidioc_querycap(struct file *file, void *fh, struct v4l2_capability *
 	strlcpy((char *)cap->card, dev->ext->name, sizeof(cap->card));
 	sprintf((char *)cap->bus_info, "PCI:%s", pci_name(dev->pci));
 	cap->version = SAA7146_VERSION_CODE;
-	cap->capabilities =
+	cap->device_caps =
 		V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_VIDEO_OVERLAY |
 		V4L2_CAP_READWRITE |
 		V4L2_CAP_STREAMING;
-	cap->capabilities |= dev->ext_vv_data->capabilities;
+	cap->device_caps |= dev->ext_vv_data->capabilities;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
@@ -579,135 +521,58 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void *fh, struct v4l2_fmtd
 	return 0;
 }
 
-static int vidioc_queryctrl(struct file *file, void *fh, struct v4l2_queryctrl *c)
-{
-	const struct v4l2_queryctrl *ctrl;
-
-	if ((c->id <  V4L2_CID_BASE ||
-	     c->id >= V4L2_CID_LASTP1) &&
-	    (c->id <  V4L2_CID_PRIVATE_BASE ||
-	     c->id >= V4L2_CID_PRIVATE_LASTP1))
-		return -EINVAL;
-
-	ctrl = ctrl_by_id(c->id);
-	if (ctrl == NULL)
-		return -EINVAL;
-
-	DEB_EE("VIDIOC_QUERYCTRL: id:%d\n", c->id);
-	*c = *ctrl;
-	return 0;
-}
-
-static int vidioc_g_ctrl(struct file *file, void *fh, struct v4l2_control *c)
+int saa7146_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
+	struct saa7146_dev *dev = container_of(ctrl->handler,
+				struct saa7146_dev, ctrl_handler);
 	struct saa7146_vv *vv = dev->vv_data;
-	const struct v4l2_queryctrl *ctrl;
-	u32 value = 0;
+	u32 val;
 
-	ctrl = ctrl_by_id(c->id);
-	if (NULL == ctrl)
-		return -EINVAL;
-	switch (c->id) {
+	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		value = saa7146_read(dev, BCS_CTRL);
-		c->value = 0xff & (value >> 24);
-		DEB_D("V4L2_CID_BRIGHTNESS: %d\n", c->value);
-		break;
-	case V4L2_CID_CONTRAST:
-		value = saa7146_read(dev, BCS_CTRL);
-		c->value = 0x7f & (value >> 16);
-		DEB_D("V4L2_CID_CONTRAST: %d\n", c->value);
-		break;
-	case V4L2_CID_SATURATION:
-		value = saa7146_read(dev, BCS_CTRL);
-		c->value = 0x7f & (value >> 0);
-		DEB_D("V4L2_CID_SATURATION: %d\n", c->value);
-		break;
-	case V4L2_CID_VFLIP:
-		c->value = vv->vflip;
-		DEB_D("V4L2_CID_VFLIP: %d\n", c->value);
-		break;
-	case V4L2_CID_HFLIP:
-		c->value = vv->hflip;
-		DEB_D("V4L2_CID_HFLIP: %d\n", c->value);
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *c)
-{
-	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
-	struct saa7146_vv *vv = dev->vv_data;
-	const struct v4l2_queryctrl *ctrl;
-
-	ctrl = ctrl_by_id(c->id);
-	if (NULL == ctrl) {
-		DEB_D("unknown control %d\n", c->id);
-		return -EINVAL;
-	}
-
-	switch (ctrl->type) {
-	case V4L2_CTRL_TYPE_BOOLEAN:
-	case V4L2_CTRL_TYPE_MENU:
-	case V4L2_CTRL_TYPE_INTEGER:
-		if (c->value < ctrl->minimum)
-			c->value = ctrl->minimum;
-		if (c->value > ctrl->maximum)
-			c->value = ctrl->maximum;
-		break;
-	default:
-		/* nothing */;
-	}
-
-	switch (c->id) {
-	case V4L2_CID_BRIGHTNESS: {
-		u32 value = saa7146_read(dev, BCS_CTRL);
-		value &= 0x00ffffff;
-		value |= (c->value << 24);
-		saa7146_write(dev, BCS_CTRL, value);
+		val = saa7146_read(dev, BCS_CTRL);
+		val &= 0x00ffffff;
+		val |= (ctrl->val << 24);
+		saa7146_write(dev, BCS_CTRL, val);
 		saa7146_write(dev, MC2, MASK_22 | MASK_06);
 		break;
-	}
-	case V4L2_CID_CONTRAST: {
-		u32 value = saa7146_read(dev, BCS_CTRL);
-		value &= 0xff00ffff;
-		value |= (c->value << 16);
-		saa7146_write(dev, BCS_CTRL, value);
+
+	case V4L2_CID_CONTRAST:
+		val = saa7146_read(dev, BCS_CTRL);
+		val &= 0xff00ffff;
+		val |= (ctrl->val << 16);
+		saa7146_write(dev, BCS_CTRL, val);
 		saa7146_write(dev, MC2, MASK_22 | MASK_06);
 		break;
-	}
-	case V4L2_CID_SATURATION: {
-		u32 value = saa7146_read(dev, BCS_CTRL);
-		value &= 0xffffff00;
-		value |= (c->value << 0);
-		saa7146_write(dev, BCS_CTRL, value);
+
+	case V4L2_CID_SATURATION:
+		val = saa7146_read(dev, BCS_CTRL);
+		val &= 0xffffff00;
+		val |= (ctrl->val << 0);
+		saa7146_write(dev, BCS_CTRL, val);
 		saa7146_write(dev, MC2, MASK_22 | MASK_06);
 		break;
-	}
+
 	case V4L2_CID_HFLIP:
 		/* fixme: we can support changing VFLIP and HFLIP here... */
-		if (IS_CAPTURE_ACTIVE(fh) != 0) {
-			DEB_D("V4L2_CID_HFLIP while active capture\n");
+		if ((vv->video_status & STATUS_CAPTURE))
 			return -EBUSY;
-		}
-		vv->hflip = c->value;
+		vv->hflip = ctrl->val;
 		break;
+
 	case V4L2_CID_VFLIP:
-		if (IS_CAPTURE_ACTIVE(fh) != 0) {
-			DEB_D("V4L2_CID_VFLIP while active capture\n");
+		if ((vv->video_status & STATUS_CAPTURE))
 			return -EBUSY;
-		}
-		vv->vflip = c->value;
+		vv->vflip = ctrl->val;
 		break;
+
 	default:
 		return -EINVAL;
 	}
 
-	if (IS_OVERLAY_ACTIVE(fh) != 0) {
+	if ((vv->video_status & STATUS_OVERLAY) != 0) { /* CHECK: && (vv->video_fh == fh)) */
+		struct saa7146_fh *fh = vv->video_fh;
+
 		saa7146_stop_preview(fh);
 		saa7146_start_preview(fh);
 	}
@@ -720,6 +585,8 @@ static int vidioc_g_parm(struct file *file, void *fh,
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 	struct saa7146_vv *vv = dev->vv_data;
 
+	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
 	parm->parm.capture.readbuffers = 1;
 	v4l2_video_std_frame_period(vv->standard->id,
 				    &parm->parm.capture.timeperframe);
@@ -787,6 +654,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *fh, struct v4l2_forma
 	}
 
 	f->fmt.pix.field = field;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 	if (f->fmt.pix.width > maxw)
 		f->fmt.pix.width = maxw;
 	if (f->fmt.pix.height > maxh)
@@ -1141,9 +1009,6 @@ const struct v4l2_ioctl_ops saa7146_video_ioctl_ops = {
 	.vidioc_dqbuf                = vidioc_dqbuf,
 	.vidioc_g_std                = vidioc_g_std,
 	.vidioc_s_std                = vidioc_s_std,
-	.vidioc_queryctrl            = vidioc_queryctrl,
-	.vidioc_g_ctrl               = vidioc_g_ctrl,
-	.vidioc_s_ctrl               = vidioc_s_ctrl,
 	.vidioc_streamon             = vidioc_streamon,
 	.vidioc_streamoff            = vidioc_streamoff,
 	.vidioc_g_parm 		     = vidioc_g_parm,
@@ -1338,6 +1203,7 @@ static int video_open(struct saa7146_dev *dev, struct file *file)
 	fh->video_fmt.pixelformat = V4L2_PIX_FMT_BGR24;
 	fh->video_fmt.bytesperline = 0;
 	fh->video_fmt.field = V4L2_FIELD_ANY;
+	fh->video_fmt.colorspace = V4L2_COLORSPACE_SMPTE170M;
 	sfmt = saa7146_format_by_fourcc(dev,fh->video_fmt.pixelformat);
 	fh->video_fmt.sizeimage = (fh->video_fmt.width * fh->video_fmt.height * sfmt->depth)/8;
 
diff --git a/include/media/saa7146.h b/include/media/saa7146.h
index 0f037e8..c791940 100644
--- a/include/media/saa7146.h
+++ b/include/media/saa7146.h
@@ -13,6 +13,7 @@
 #include <linux/mutex.h>
 #include <linux/scatterlist.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
 
 #include <linux/vmalloc.h>	/* for vmalloc() */
 #include <linux/mm.h>		/* for vmalloc_to_page() */
@@ -121,6 +122,7 @@ struct saa7146_dev
 	struct list_head		item;
 
 	struct v4l2_device 		v4l2_dev;
+	struct v4l2_ctrl_handler	ctrl_handler;
 
 	/* different device locks */
 	spinlock_t			slock;
diff --git a/include/media/saa7146_vv.h b/include/media/saa7146_vv.h
index 4aeff96..b4761ed 100644
--- a/include/media/saa7146_vv.h
+++ b/include/media/saa7146_vv.h
@@ -206,6 +206,7 @@ extern struct saa7146_use_ops saa7146_video_uops;
 int saa7146_start_preview(struct saa7146_fh *fh);
 int saa7146_stop_preview(struct saa7146_fh *fh);
 long saa7146_video_do_ioctl(struct file *file, unsigned int cmd, void *arg);
+int saa7146_s_ctrl(struct v4l2_ctrl *ctrl);
 
 /* from saa7146_vbi.c */
 extern struct saa7146_use_ops saa7146_vbi_uops;
-- 
1.7.10

