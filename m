Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2825 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab3DNP1x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:27:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 14/30] cx25821: convert to the control framework.
Date: Sun, 14 Apr 2013 17:27:10 +0200
Message-Id: <1365953246-8972-15-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-core.c  |    5 +-
 drivers/media/pci/cx25821/cx25821-video.c |  210 +++++------------------------
 drivers/media/pci/cx25821/cx25821.h       |   10 +-
 3 files changed, 41 insertions(+), 184 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index f3a48a1..bf6c181 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -880,8 +880,11 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 
 	/* Apply a sensible clock frequency for the PCIe bridge */
 	dev->clk_freq = 28000000;
-	for (i = 0; i < MAX_VID_CHANNEL_NUM; i++)
+	for (i = 0; i < MAX_VID_CHANNEL_NUM; i++) {
+		dev->channels[i].dev = dev;
+		dev->channels[i].id = i;
 		dev->channels[i].sram_channels = &cx25821_sram_channels[i];
+	}
 
 	if (dev->nr > 1)
 		CX25821_INFO("dev->nr > 1!");
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 41e3475..0c11f31 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -1188,192 +1188,29 @@ int cx25821_vidioc_s_register(struct file *file, void *fh,
 
 #endif
 
-/*****************************************************************************/
-static const struct v4l2_queryctrl no_ctl = {
-	.name = "42",
-	.flags = V4L2_CTRL_FLAG_DISABLED,
-};
-
-static struct v4l2_queryctrl cx25821_ctls[] = {
-	/* --- video --- */
-	{
-		.id = V4L2_CID_BRIGHTNESS,
-		.name = "Brightness",
-		.minimum = 0,
-		.maximum = 10000,
-		.step = 1,
-		.default_value = 6200,
-		.type = V4L2_CTRL_TYPE_INTEGER,
-	}, {
-		.id = V4L2_CID_CONTRAST,
-		.name = "Contrast",
-		.minimum = 0,
-		.maximum = 10000,
-		.step = 1,
-		.default_value = 5000,
-		.type = V4L2_CTRL_TYPE_INTEGER,
-	}, {
-		.id = V4L2_CID_SATURATION,
-		.name = "Saturation",
-		.minimum = 0,
-		.maximum = 10000,
-		.step = 1,
-		.default_value = 5000,
-		.type = V4L2_CTRL_TYPE_INTEGER,
-	}, {
-		.id = V4L2_CID_HUE,
-		.name = "Hue",
-		.minimum = 0,
-		.maximum = 10000,
-		.step = 1,
-		.default_value = 5000,
-		.type = V4L2_CTRL_TYPE_INTEGER,
-	}
-};
-static const int CX25821_CTLS = ARRAY_SIZE(cx25821_ctls);
-
-static int cx25821_ctrl_query(struct v4l2_queryctrl *qctrl)
-{
-	int i;
-
-	if (qctrl->id < V4L2_CID_BASE || qctrl->id >= V4L2_CID_LASTP1)
-		return -EINVAL;
-	for (i = 0; i < CX25821_CTLS; i++)
-		if (cx25821_ctls[i].id == qctrl->id)
-			break;
-	if (i == CX25821_CTLS) {
-		*qctrl = no_ctl;
-		return 0;
-	}
-	*qctrl = cx25821_ctls[i];
-	return 0;
-}
-
-static int cx25821_vidioc_queryctrl(struct file *file, void *priv,
-		     struct v4l2_queryctrl *qctrl)
-{
-	return cx25821_ctrl_query(qctrl);
-}
-
-/* ------------------------------------------------------------------ */
-/* VIDEO CTRL IOCTLS                                                  */
-
-static const struct v4l2_queryctrl *ctrl_by_id(unsigned int id)
+static int cx25821_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	unsigned int i;
+	struct cx25821_channel *chan =
+		container_of(ctrl->handler, struct cx25821_channel, hdl);
+	struct cx25821_dev *dev = chan->dev;
 
-	for (i = 0; i < CX25821_CTLS; i++)
-		if (cx25821_ctls[i].id == id)
-			return cx25821_ctls + i;
-	return NULL;
-}
-
-static int cx25821_vidioc_g_ctrl(struct file *file, void *priv,
-			  struct v4l2_control *ctl)
-{
-	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-	struct cx25821_fh *fh = priv;
-
-	const struct v4l2_queryctrl *ctrl;
-
-	ctrl = ctrl_by_id(ctl->id);
-
-	if (NULL == ctrl)
-		return -EINVAL;
-	switch (ctl->id) {
+	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		ctl->value = dev->channels[fh->channel_id].ctl_bright;
+		medusa_set_brightness(dev, ctrl->val, chan->id);
 		break;
 	case V4L2_CID_HUE:
-		ctl->value = dev->channels[fh->channel_id].ctl_hue;
+		medusa_set_hue(dev, ctrl->val, chan->id);
 		break;
 	case V4L2_CID_CONTRAST:
-		ctl->value = dev->channels[fh->channel_id].ctl_contrast;
+		medusa_set_contrast(dev, ctrl->val, chan->id);
 		break;
 	case V4L2_CID_SATURATION:
-		ctl->value = dev->channels[fh->channel_id].ctl_saturation;
-		break;
-	}
-	return 0;
-}
-
-static int cx25821_set_control(struct cx25821_dev *dev,
-			struct v4l2_control *ctl, int chan_num)
-{
-	int err;
-	const struct v4l2_queryctrl *ctrl;
-
-	err = -EINVAL;
-
-	ctrl = ctrl_by_id(ctl->id);
-
-	if (NULL == ctrl)
-		return err;
-
-	switch (ctrl->type) {
-	case V4L2_CTRL_TYPE_BOOLEAN:
-	case V4L2_CTRL_TYPE_MENU:
-	case V4L2_CTRL_TYPE_INTEGER:
-		if (ctl->value < ctrl->minimum)
-			ctl->value = ctrl->minimum;
-		if (ctl->value > ctrl->maximum)
-			ctl->value = ctrl->maximum;
+		medusa_set_saturation(dev, ctrl->val, chan->id);
 		break;
 	default:
-		/* nothing */ ;
-	}
-
-	switch (ctl->id) {
-	case V4L2_CID_BRIGHTNESS:
-		dev->channels[chan_num].ctl_bright = ctl->value;
-		medusa_set_brightness(dev, ctl->value, chan_num);
-		break;
-	case V4L2_CID_HUE:
-		dev->channels[chan_num].ctl_hue = ctl->value;
-		medusa_set_hue(dev, ctl->value, chan_num);
-		break;
-	case V4L2_CID_CONTRAST:
-		dev->channels[chan_num].ctl_contrast = ctl->value;
-		medusa_set_contrast(dev, ctl->value, chan_num);
-		break;
-	case V4L2_CID_SATURATION:
-		dev->channels[chan_num].ctl_saturation = ctl->value;
-		medusa_set_saturation(dev, ctl->value, chan_num);
-		break;
-	}
-
-	err = 0;
-
-	return err;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-			struct v4l2_control *ctl)
-{
-	struct cx25821_fh *fh = priv;
-	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-	int err;
-
-	if (fh) {
-		err = v4l2_prio_check(&dev->channels[fh->channel_id].prio,
-				      fh->prio);
-		if (0 != err)
-			return err;
-	}
-
-	return cx25821_set_control(dev, ctl, fh->channel_id);
-}
-
-static void cx25821_init_controls(struct cx25821_dev *dev, int chan_num)
-{
-	struct v4l2_control ctrl;
-	int i;
-	for (i = 0; i < CX25821_CTLS; i++) {
-		ctrl.id = cx25821_ctls[i].id;
-		ctrl.value = cx25821_ctls[i].default_value;
-
-		cx25821_set_control(dev, &ctrl, chan_num);
+		return -EINVAL;
 	}
+	return 0;
 }
 
 static long video_ioctl_upstream9(struct file *file, unsigned int cmd,
@@ -1629,7 +1466,10 @@ static long cx25821_video_ioctl(struct file *file,
 	return video_ioctl2(file, cmd, arg);
 }
 
-/* exported stuff */
+static const struct v4l2_ctrl_ops cx25821_ctrl_ops = {
+	.s_ctrl = cx25821_s_ctrl,
+};
+
 static const struct v4l2_file_operations video_fops = {
 	.owner = THIS_MODULE,
 	.open = video_open,
@@ -1655,9 +1495,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_enum_input = cx25821_vidioc_enum_input,
 	.vidioc_g_input = cx25821_vidioc_g_input,
 	.vidioc_s_input = cx25821_vidioc_s_input,
-	.vidioc_g_ctrl = cx25821_vidioc_g_ctrl,
-	.vidioc_s_ctrl = vidioc_s_ctrl,
-	.vidioc_queryctrl = cx25821_vidioc_queryctrl,
 	.vidioc_streamon = vidioc_streamon,
 	.vidioc_streamoff = vidioc_streamoff,
 	.vidioc_log_status = vidioc_log_status,
@@ -1684,6 +1521,7 @@ void cx25821_video_unregister(struct cx25821_dev *dev, int chan_num)
 
 	if (video_is_registered(&dev->channels[chan_num].vdev)) {
 		video_unregister_device(&dev->channels[chan_num].vdev);
+		v4l2_ctrl_handler_free(&dev->channels[chan_num].hdl);
 
 		btcx_riscmem_free(dev->pci,
 				&dev->channels[chan_num].vidq.stopper);
@@ -1699,11 +1537,24 @@ int cx25821_video_register(struct cx25821_dev *dev)
 
 	for (i = 0; i < VID_CHANNEL_NUM; ++i) {
 		struct video_device *vdev = &dev->channels[i].vdev;
+		struct v4l2_ctrl_handler *hdl = &dev->channels[i].hdl;
 
 		if (i == SRAM_CH08) /* audio channel */
 			continue;
 
-		cx25821_init_controls(dev, i);
+		v4l2_ctrl_handler_init(hdl, 4);
+		v4l2_ctrl_new_std(hdl, &cx25821_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, 0, 10000, 1, 6200);
+		v4l2_ctrl_new_std(hdl, &cx25821_ctrl_ops,
+			V4L2_CID_CONTRAST, 0, 10000, 1, 5000);
+		v4l2_ctrl_new_std(hdl, &cx25821_ctrl_ops,
+			V4L2_CID_SATURATION, 0, 10000, 1, 5000);
+		v4l2_ctrl_new_std(hdl, &cx25821_ctrl_ops,
+			V4L2_CID_HUE, 0, 10000, 1, 5000);
+		if (hdl->error) {
+			err = hdl->error;
+			goto fail_unreg;
+		}
 
 		cx25821_risc_stopper(dev->pci, &dev->channels[i].vidq.stopper,
 			dev->channels[i].sram_channels->dma_ctl, 0x11, 0);
@@ -1727,6 +1578,7 @@ int cx25821_video_register(struct cx25821_dev *dev)
 		/* register v4l devices */
 		*vdev = cx25821_video_device;
 		vdev->v4l2_dev = &dev->v4l2_dev;
+		vdev->ctrl_handler = hdl;
 		snprintf(vdev->name, sizeof(vdev->name), "%s #%d", dev->name, i);
 		video_set_drvdata(vdev, dev);
 
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index df2ea22..c63f7f5 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -33,6 +33,7 @@
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
 #include <media/videobuf-dma-sg.h>
 
 #include "btcx-risc.h"
@@ -208,13 +209,14 @@ struct cx25821_data {
 	const struct sram_channel *channel;
 };
 
+struct cx25821_dev;
+
 struct cx25821_channel {
+	unsigned id;
+	struct cx25821_dev *dev;
 	struct v4l2_prio_state prio;
 
-	int ctl_bright;
-	int ctl_contrast;
-	int ctl_hue;
-	int ctl_saturation;
+	struct v4l2_ctrl_handler hdl;
 	struct cx25821_data timeout_data;
 
 	struct video_device vdev;
-- 
1.7.10.4

