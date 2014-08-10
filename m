Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4969 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbaHJL6V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Aug 2014 07:58:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 06/19] cx23885: convert 417 to the control framework
Date: Sun, 10 Aug 2014 13:57:43 +0200
Message-Id: <1407671876-39386-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1407671876-39386-1-git-send-email-hverkuil@xs4all.nl>
References: <1407671876-39386-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Convert the -417 source to the control framework as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885-417.c   | 133 +++++-------------------------
 drivers/media/pci/cx23885/cx23885-video.c |   6 --
 drivers/media/pci/cx23885/cx23885.h       |   2 +-
 3 files changed, 20 insertions(+), 121 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index d44395c..4142c15 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -865,6 +865,11 @@ static int cx23885_api_cmd(struct cx23885_dev *dev,
 	return err;
 }
 
+static int cx23885_api_func(void *priv, u32 cmd, int in, int out, u32 data[CX2341X_MBOX_MAX_DATA])
+{
+	return cx23885_mbox_func(priv, cmd, in, out, data);
+}
+
 static int cx23885_find_mailbox(struct cx23885_dev *dev)
 {
 	u32 signature[4] = {
@@ -1033,12 +1038,12 @@ static void cx23885_codec_settings(struct cx23885_dev *dev)
 	cx23885_api_cmd(dev, CX2341X_ENC_SET_FRAME_SIZE, 2, 0,
 				dev->ts1.height, dev->ts1.width);
 
-	dev->mpeg_params.width = dev->ts1.width;
-	dev->mpeg_params.height = dev->ts1.height;
-	dev->mpeg_params.is_50hz =
+	dev->cxhdl.width = dev->ts1.width;
+	dev->cxhdl.height = dev->ts1.height;
+	dev->cxhdl.is_50hz =
 		(dev->encodernorm.id & V4L2_STD_625_50) != 0;
 
-	cx2341x_update(dev, cx23885_mbox_func, NULL, &dev->mpeg_params);
+	cx2341x_handler_setup(&dev->cxhdl);
 
 	cx23885_api_cmd(dev, CX2341X_ENC_MISC, 2, 0, 3, 1);
 	cx23885_api_cmd(dev, CX2341X_ENC_MISC, 2, 0, 4, 1);
@@ -1182,36 +1187,6 @@ static struct videobuf_queue_ops cx23885_qops = {
 
 /* ------------------------------------------------------------------ */
 
-static const u32 *ctrl_classes[] = {
-	cx2341x_mpeg_ctrls,
-	NULL
-};
-
-static int cx23885_queryctrl(struct cx23885_dev *dev,
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
-static int cx23885_querymenu(struct cx23885_dev *dev,
-	struct v4l2_querymenu *qmenu)
-{
-	struct v4l2_queryctrl qctrl;
-
-	qctrl.id = qmenu->id;
-	cx23885_queryctrl(dev, &qctrl);
-	return v4l2_ctrl_query_menu(qmenu, &qctrl,
-		cx2341x_ctrl_get_menu(&dev->mpeg_params, qmenu->id));
-}
-
 static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *id)
 {
 	struct cx23885_fh  *fh  = file->private_data;
@@ -1445,55 +1420,6 @@ static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 	return videobuf_streamoff(&fh->mpegq);
 }
 
-static int vidioc_g_ext_ctrls(struct file *file, void *priv,
-				struct v4l2_ext_controls *f)
-{
-	struct cx23885_fh  *fh  = priv;
-	struct cx23885_dev *dev = fh->dev;
-
-	if (f->ctrl_class != V4L2_CTRL_CLASS_MPEG)
-		return -EINVAL;
-	return cx2341x_ext_ctrls(&dev->mpeg_params, 0, f, VIDIOC_G_EXT_CTRLS);
-}
-
-static int vidioc_s_ext_ctrls(struct file *file, void *priv,
-				struct v4l2_ext_controls *f)
-{
-	struct cx23885_fh  *fh  = priv;
-	struct cx23885_dev *dev = fh->dev;
-	struct cx2341x_mpeg_params p;
-	int err;
-
-	if (f->ctrl_class != V4L2_CTRL_CLASS_MPEG)
-		return -EINVAL;
-
-	p = dev->mpeg_params;
-	err = cx2341x_ext_ctrls(&p, 0, f, VIDIOC_S_EXT_CTRLS);
-
-	if (err == 0) {
-		err = cx2341x_update(dev, cx23885_mbox_func,
-			&dev->mpeg_params, &p);
-		dev->mpeg_params = p;
-	}
-	return err;
-}
-
-static int vidioc_try_ext_ctrls(struct file *file, void *priv,
-				struct v4l2_ext_controls *f)
-{
-	struct cx23885_fh  *fh  = priv;
-	struct cx23885_dev *dev = fh->dev;
-	struct cx2341x_mpeg_params p;
-	int err;
-
-	if (f->ctrl_class != V4L2_CTRL_CLASS_MPEG)
-		return -EINVAL;
-
-	p = dev->mpeg_params;
-	err = cx2341x_ext_ctrls(&p, 0, f, VIDIOC_TRY_EXT_CTRLS);
-	return err;
-}
-
 static int vidioc_log_status(struct file *file, void *priv)
 {
 	struct cx23885_fh  *fh  = priv;
@@ -1501,35 +1427,11 @@ static int vidioc_log_status(struct file *file, void *priv)
 	char name[32 + 2];
 
 	snprintf(name, sizeof(name), "%s/2", dev->name);
-	printk(KERN_INFO
-		"%s/2: ============  START LOG STATUS  ============\n",
-	       dev->name);
 	call_all(dev, core, log_status);
-	cx2341x_log_status(&dev->mpeg_params, name);
-	printk(KERN_INFO
-		"%s/2: =============  END LOG STATUS  =============\n",
-	       dev->name);
+	v4l2_ctrl_handler_log_status(&dev->cxhdl.hdl, name);
 	return 0;
 }
 
-static int vidioc_querymenu(struct file *file, void *priv,
-				struct v4l2_querymenu *a)
-{
-	struct cx23885_fh  *fh  = priv;
-	struct cx23885_dev *dev = fh->dev;
-
-	return cx23885_querymenu(dev, a);
-}
-
-static int vidioc_queryctrl(struct file *file, void *priv,
-				struct v4l2_queryctrl *c)
-{
-	struct cx23885_fh  *fh  = priv;
-	struct cx23885_dev *dev = fh->dev;
-
-	return cx23885_queryctrl(dev, c);
-}
-
 static int mpeg_open(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
@@ -1667,9 +1569,6 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_dqbuf		 = vidioc_dqbuf,
 	.vidioc_streamon	 = vidioc_streamon,
 	.vidioc_streamoff	 = vidioc_streamoff,
-	.vidioc_g_ext_ctrls	 = vidioc_g_ext_ctrls,
-	.vidioc_s_ext_ctrls	 = vidioc_s_ext_ctrls,
-	.vidioc_try_ext_ctrls	 = vidioc_try_ext_ctrls,
 	.vidioc_log_status	 = vidioc_log_status,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_chip_info	 = cx23885_g_chip_info,
@@ -1694,6 +1593,7 @@ void cx23885_417_unregister(struct cx23885_dev *dev)
 			video_unregister_device(dev->v4l_device);
 		else
 			video_device_release(dev->v4l_device);
+		v4l2_ctrl_handler_free(&dev->cxhdl.hdl);
 		dev->v4l_device = NULL;
 	}
 }
@@ -1740,9 +1640,14 @@ int cx23885_417_register(struct cx23885_dev *dev)
 		tsport->height = 576;
 
 	tsport->width = 720;
-	cx2341x_fill_defaults(&dev->mpeg_params);
-
-	dev->mpeg_params.port = CX2341X_PORT_SERIAL;
+	dev->cxhdl.port = CX2341X_PORT_SERIAL;
+	err = cx2341x_handler_init(&dev->cxhdl, 50);
+	if (err)
+		return err;
+	dev->cxhdl.priv = dev;
+	dev->cxhdl.func = cx23885_api_func;
+	cx2341x_handler_set_50hz(&dev->cxhdl, tsport->height == 576);
+	v4l2_ctrl_add_handler(&dev->ctrl_handler, &dev->cxhdl.hdl, NULL);
 
 	/* Allocate and initialize V4L video device */
 	dev->v4l_device = cx23885_video_dev_alloc(tsport,
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 090d48b..116ce34 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -1219,13 +1219,7 @@ static int vidioc_log_status(struct file *file, void *priv)
 	struct cx23885_fh  *fh  = priv;
 	struct cx23885_dev *dev = fh->dev;
 
-	printk(KERN_INFO
-		"%s/0: ============  START LOG STATUS  ============\n",
-		dev->name);
 	call_all(dev, core, log_status);
-	printk(KERN_INFO
-		"%s/0: =============  END LOG STATUS  =============\n",
-		dev->name);
 	return 0;
 }
 
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index 516435c..2d57af7 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -439,7 +439,7 @@ struct cx23885_dev {
 
 	/* MPEG Encoder ONLY settings */
 	u32                        cx23417_mailbox;
-	struct cx2341x_mpeg_params mpeg_params;
+	struct cx2341x_handler     cxhdl;
 	struct video_device        *v4l_device;
 	atomic_t                   v4l_reader_count;
 	struct cx23885_tvnorm      encodernorm;
-- 
2.0.1

