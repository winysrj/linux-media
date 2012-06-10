Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4196 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451Ab2FJKzL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 06:55:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Steven Toth <stoth@kernellabs.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 03/11] cx88: each device node gets the right controls.
Date: Sun, 10 Jun 2012 12:54:49 +0200
Message-Id: <cd6c2854957a70be4cdba579acca68ba9ff7a53c.1339325224.git.hans.verkuil@cisco.com>
In-Reply-To: <1339325697-23280-1-git-send-email-hverkuil@xs4all.nl>
References: <1339325697-23280-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <541a39bdcc8a94d3de87a6a6d0b1b7c476983984.1339325224.git.hans.verkuil@cisco.com>
References: <541a39bdcc8a94d3de87a6a6d0b1b7c476983984.1339325224.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

radio only sees audio controls, video sees video and audio and vbi
sees none.

Also disable the chroma_agc control if secam is selected.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/cx88/cx88-cards.c |   15 +++-
 drivers/media/video/cx88/cx88-core.c  |    7 +-
 drivers/media/video/cx88/cx88-video.c |  139 +++++++++++++++++++++------------
 drivers/media/video/cx88/cx88.h       |    4 +-
 4 files changed, 108 insertions(+), 57 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-cards.c b/drivers/media/video/cx88/cx88-cards.c
index cd8c3bf6..4e9d4f7 100644
--- a/drivers/media/video/cx88/cx88-cards.c
+++ b/drivers/media/video/cx88/cx88-cards.c
@@ -3693,14 +3693,22 @@ struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
 		return NULL;
 	}
 
-	if (v4l2_ctrl_handler_init(&core->hdl, 13)) {
+	if (v4l2_ctrl_handler_init(&core->video_hdl, 13)) {
+		v4l2_device_unregister(&core->v4l2_dev);
+		kfree(core);
+		return NULL;
+	}
+
+	if (v4l2_ctrl_handler_init(&core->audio_hdl, 13)) {
+		v4l2_ctrl_handler_free(&core->video_hdl);
 		v4l2_device_unregister(&core->v4l2_dev);
 		kfree(core);
 		return NULL;
 	}
 
 	if (0 != cx88_get_resources(core, pci)) {
-		v4l2_ctrl_handler_free(&core->hdl);
+		v4l2_ctrl_handler_free(&core->video_hdl);
+		v4l2_ctrl_handler_free(&core->audio_hdl);
 		v4l2_device_unregister(&core->v4l2_dev);
 		kfree(core);
 		return NULL;
@@ -3715,7 +3723,8 @@ struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
 	if (core->lmmio == NULL) {
 		release_mem_region(pci_resource_start(pci, 0),
 			   pci_resource_len(pci, 0));
-		v4l2_ctrl_handler_free(&core->hdl);
+		v4l2_ctrl_handler_free(&core->video_hdl);
+		v4l2_ctrl_handler_free(&core->audio_hdl);
 		v4l2_device_unregister(&core->v4l2_dev);
 		kfree(core);
 		return NULL;
diff --git a/drivers/media/video/cx88/cx88-core.c b/drivers/media/video/cx88/cx88-core.c
index a6480aa..8bd925d 100644
--- a/drivers/media/video/cx88/cx88-core.c
+++ b/drivers/media/video/cx88/cx88-core.c
@@ -1012,6 +1012,9 @@ int cx88_set_tvnorm(struct cx88_core *core, v4l2_std_id norm)
 	// tell i2c chips
 	call_all(core, core, s_std, norm);
 
+	/* The chroma_agc control should be inaccessible if the video format is SECAM */
+	v4l2_ctrl_grab(core->chroma_agc, cxiformat == VideoFormatSECAM);
+
 	// done
 	return 0;
 }
@@ -1030,7 +1033,6 @@ struct video_device *cx88_vdev_init(struct cx88_core *core,
 		return NULL;
 	*vfd = *template_;
 	vfd->v4l2_dev = &core->v4l2_dev;
-	vfd->ctrl_handler = &core->hdl;
 	vfd->release = video_device_release;
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s (%s)",
 		 core->name, type, core->board.name);
@@ -1086,7 +1088,8 @@ void cx88_core_put(struct cx88_core *core, struct pci_dev *pci)
 	iounmap(core->lmmio);
 	cx88_devcount--;
 	mutex_unlock(&devlist);
-	v4l2_ctrl_handler_free(&core->hdl);
+	v4l2_ctrl_handler_free(&core->video_hdl);
+	v4l2_ctrl_handler_free(&core->audio_hdl);
 	v4l2_device_unregister(&core->v4l2_dev);
 	kfree(core);
 }
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 2f3d4df..104a85c 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -155,12 +155,6 @@ static const struct cx8800_fmt* format_by_fourcc(unsigned int fourcc)
 
 /* ------------------------------------------------------------------- */
 
-static const struct v4l2_queryctrl no_ctl = {
-	.name  = "42",
-	.flags = V4L2_CTRL_FLAG_DISABLED,
-};
-
-
 struct cx88_ctrl {
 	/* control information */
 	u32 id;
@@ -177,7 +171,7 @@ struct cx88_ctrl {
 	u32 shift;
 };
 
-static const struct cx88_ctrl cx8800_ctls[] = {
+static const struct cx88_ctrl cx8800_vid_ctls[] = {
 	/* --- video --- */
 	{
 		.id            = V4L2_CID_BRIGHTNESS,
@@ -260,7 +254,11 @@ static const struct cx88_ctrl cx8800_ctls[] = {
 		.reg           = MO_HTOTAL,
 		.mask          = 3 << 11,
 		.shift         = 11,
-	}, {
+	}
+};
+
+static const struct cx88_ctrl cx8800_aud_ctls[] = {
+	{
 		/* --- audio --- */
 		.id            = V4L2_CID_AUDIO_MUTE,
 		.minimum       = 0,
@@ -293,14 +291,10 @@ static const struct cx88_ctrl cx8800_ctls[] = {
 	}
 };
 
-enum { CX8800_CTLS = ARRAY_SIZE(cx8800_ctls) };
-
-
-int cx8800_ctrl_query(struct cx88_core *core, struct v4l2_queryctrl *qctrl)
-{
-	return 0;
-}
-EXPORT_SYMBOL(cx8800_ctrl_query);
+enum {
+	CX8800_VID_CTLS = ARRAY_SIZE(cx8800_vid_ctls),
+	CX8800_AUD_CTLS = ARRAY_SIZE(cx8800_aud_ctls),
+};
 
 /* ------------------------------------------------------------------- */
 /* resource management                                                 */
@@ -908,10 +902,56 @@ video_mmap(struct file *file, struct vm_area_struct * vma)
 /* ------------------------------------------------------------------ */
 /* VIDEO CTRL IOCTLS                                                  */
 
-static int cx8800_s_ctrl(struct v4l2_ctrl *ctrl)
+static int cx8800_s_vid_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct cx88_core *core =
+		container_of(ctrl->handler, struct cx88_core, video_hdl);
+	const struct cx88_ctrl *cc = ctrl->priv;
+	u32 value, mask;
+
+	mask = cc->mask;
+	switch (ctrl->id) {
+	case V4L2_CID_SATURATION:
+		/* special v_sat handling */
+
+		value = ((ctrl->val - cc->off) << cc->shift) & cc->mask;
+
+		if (core->tvnorm & V4L2_STD_SECAM) {
+			/* For SECAM, both U and V sat should be equal */
+			value = value << 8 | value;
+		} else {
+			/* Keeps U Saturation proportional to V Sat */
+			value = (value * 0x5a) / 0x7f << 8 | value;
+		}
+		mask = 0xffff;
+		break;
+	case V4L2_CID_SHARPNESS:
+		/* 0b000, 0b100, 0b101, 0b110, or 0b111 */
+		value = (ctrl->val < 1 ? 0 : ((ctrl->val + 3) << 7));
+		/* needs to be set for both fields */
+		cx_andor(MO_FILTER_EVEN, mask, value);
+		break;
+	case V4L2_CID_CHROMA_AGC:
+		value = ((ctrl->val - cc->off) << cc->shift) & cc->mask;
+		break;
+	default:
+		value = ((ctrl->val - cc->off) << cc->shift) & cc->mask;
+		break;
+	}
+	dprintk(1, "set_control id=0x%X(%s) ctrl=0x%02x, reg=0x%02x val=0x%02x (mask 0x%02x)%s\n",
+				ctrl->id, ctrl->name, ctrl->val, cc->reg, value,
+				mask, cc->sreg ? " [shadowed]" : "");
+	if (cc->sreg)
+		cx_sandor(cc->sreg, cc->reg, mask, value);
+	else
+		cx_andor(cc->reg, mask, value);
+	return 0;
+}
+
+static int cx8800_s_aud_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct cx88_core *core =
-		container_of(ctrl->handler, struct cx88_core, hdl);
+		container_of(ctrl->handler, struct cx88_core, audio_hdl);
 	const struct cx88_ctrl *cc = ctrl->priv;
 	u32 value,mask;
 
@@ -941,32 +981,6 @@ static int cx8800_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_AUDIO_VOLUME:
 		value = 0x3f - (ctrl->val & 0x3f);
 		break;
-	case V4L2_CID_SATURATION:
-		/* special v_sat handling */
-
-		value = ((ctrl->val - cc->off) << cc->shift) & cc->mask;
-
-		if (core->tvnorm & V4L2_STD_SECAM) {
-			/* For SECAM, both U and V sat should be equal */
-			value=value<<8|value;
-		} else {
-			/* Keeps U Saturation proportional to V Sat */
-			value=(value*0x5a)/0x7f<<8|value;
-		}
-		mask=0xffff;
-		break;
-	case V4L2_CID_SHARPNESS:
-		/* 0b000, 0b100, 0b101, 0b110, or 0b111 */
-		value = (ctrl->val < 1 ? 0 : ((ctrl->val + 3) << 7));
-		/* needs to be set for both fields */
-		cx_andor(MO_FILTER_EVEN, mask, value);
-		break;
-	case V4L2_CID_CHROMA_AGC:
-		/* Do not allow chroma AGC to be enabled for SECAM */
-		value = ((ctrl->val - cc->off) << cc->shift) & cc->mask;
-		if ((core->tvnorm & V4L2_STD_SECAM) && value)
-			return -EINVAL;
-		break;
 	default:
 		value = ((ctrl->val - cc->off) << cc->shift) & cc->mask;
 		break;
@@ -1599,8 +1613,12 @@ static const struct video_device cx8800_radio_template = {
 	.ioctl_ops 	      = &radio_ioctl_ops,
 };
 
-static const struct v4l2_ctrl_ops cx8800_ctrl_ops = {
-	.s_ctrl = cx8800_s_ctrl,
+static const struct v4l2_ctrl_ops cx8800_ctrl_vid_ops = {
+	.s_ctrl = cx8800_s_vid_ctrl,
+};
+
+static const struct v4l2_ctrl_ops cx8800_ctrl_aud_ops = {
+	.s_ctrl = cx8800_s_aud_ctrl,
 };
 
 /* ----------------------------------------------------------- */
@@ -1707,18 +1725,34 @@ static int __devinit cx8800_initdev(struct pci_dev *pci_dev,
 	}
 	cx_set(MO_PCI_INTMSK, core->pci_irqmask);
 
-	for (i = 0; i < CX8800_CTLS; i++) {
-		const struct cx88_ctrl *cc = &cx8800_ctls[i];
+	for (i = 0; i < CX8800_AUD_CTLS; i++) {
+		const struct cx88_ctrl *cc = &cx8800_aud_ctls[i];
+		struct v4l2_ctrl *vc;
+
+		vc = v4l2_ctrl_new_std(&core->audio_hdl, &cx8800_ctrl_aud_ops,
+			cc->id, cc->minimum, cc->maximum, cc->step, cc->default_value);
+		if (vc == NULL) {
+			err = core->audio_hdl.error;
+			goto fail_core;
+		}
+		vc->priv = (void *)cc;
+	}
+
+	for (i = 0; i < CX8800_VID_CTLS; i++) {
+		const struct cx88_ctrl *cc = &cx8800_vid_ctls[i];
 		struct v4l2_ctrl *vc;
 
-		vc = v4l2_ctrl_new_std(&core->hdl, &cx8800_ctrl_ops,
+		vc = v4l2_ctrl_new_std(&core->video_hdl, &cx8800_ctrl_vid_ops,
 			cc->id, cc->minimum, cc->maximum, cc->step, cc->default_value);
 		if (vc == NULL) {
-			err = core->hdl.error;
+			err = core->video_hdl.error;
 			goto fail_core;
 		}
 		vc->priv = (void *)cc;
+		if (vc->id == V4L2_CID_CHROMA_AGC)
+			core->chroma_agc = vc;
 	}
+	v4l2_ctrl_add_handler(&core->video_hdl, &core->audio_hdl);
 
 	/* load and configure helper modules */
 
@@ -1771,13 +1805,15 @@ static int __devinit cx8800_initdev(struct pci_dev *pci_dev,
 	/* initial device configuration */
 	mutex_lock(&core->lock);
 	cx88_set_tvnorm(core, core->tvnorm);
-	v4l2_ctrl_handler_setup(&core->hdl);
+	v4l2_ctrl_handler_setup(&core->video_hdl);
+	v4l2_ctrl_handler_setup(&core->audio_hdl);
 	cx88_video_mux(core, 0);
 
 	/* register v4l devices */
 	dev->video_dev = cx88_vdev_init(core,dev->pci,
 					&cx8800_video_template,"video");
 	video_set_drvdata(dev->video_dev, dev);
+	dev->video_dev->ctrl_handler = &core->video_hdl;
 	err = video_register_device(dev->video_dev,VFL_TYPE_GRABBER,
 				    video_nr[core->nr]);
 	if (err < 0) {
@@ -1804,6 +1840,7 @@ static int __devinit cx8800_initdev(struct pci_dev *pci_dev,
 		dev->radio_dev = cx88_vdev_init(core,dev->pci,
 						&cx8800_radio_template,"radio");
 		video_set_drvdata(dev->radio_dev, dev);
+		dev->radio_dev->ctrl_handler = &core->audio_hdl;
 		err = video_register_device(dev->radio_dev,VFL_TYPE_RADIO,
 					    radio_nr[core->nr]);
 		if (err < 0) {
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index f12a77b..280bf6a 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -350,7 +350,9 @@ struct cx88_core {
 
 	/* config info -- analog */
 	struct v4l2_device 	   v4l2_dev;
-	struct v4l2_ctrl_handler   hdl;
+	struct v4l2_ctrl_handler   video_hdl;
+	struct v4l2_ctrl	   *chroma_agc;
+	struct v4l2_ctrl_handler   audio_hdl;
 	struct v4l2_subdev	   *sd_wm8775;
 	struct i2c_client 	   *i2c_rtc;
 	unsigned int               boardnr;
-- 
1.7.10

