Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2936 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab3BPKSr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 05:18:47 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Anatolij Gustschin <agust@denx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 1/5] fsl-viu: convert to the control framework.
Date: Sat, 16 Feb 2013 11:18:23 +0100
Message-Id: <77816a8ba6f0fe685a83a012371cf07b1ab505da.1361009701.git.hans.verkuil@cisco.com>
In-Reply-To: <1361009907-30990-1-git-send-email-hverkuil@xs4all.nl>
References: <1361009907-30990-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Interestingly enough, the existing control handling code basically did
nothing. At least the new code will inherit the controls from the
saa7115 driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/fsl-viu.c |  110 +++++---------------------------------
 1 file changed, 14 insertions(+), 96 deletions(-)

diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index 5f7db3f..4a46819 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -26,6 +26,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
 #include <media/videobuf-dma-contig.h>
 
 #define DRV_NAME		"fsl_viu"
@@ -38,49 +39,6 @@
 /* I2C address of video decoder chip is 0x4A */
 #define VIU_VIDEO_DECODER_ADDR	0x25
 
-/* supported controls */
-static struct v4l2_queryctrl viu_qctrl[] = {
-	{
-		.id            = V4L2_CID_BRIGHTNESS,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-		.name          = "Brightness",
-		.minimum       = 0,
-		.maximum       = 255,
-		.step          = 1,
-		.default_value = 127,
-		.flags         = 0,
-	}, {
-		.id            = V4L2_CID_CONTRAST,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-		.name          = "Contrast",
-		.minimum       = 0,
-		.maximum       = 255,
-		.step          = 0x1,
-		.default_value = 0x10,
-		.flags         = 0,
-	}, {
-		.id            = V4L2_CID_SATURATION,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-		.name          = "Saturation",
-		.minimum       = 0,
-		.maximum       = 255,
-		.step          = 0x1,
-		.default_value = 127,
-		.flags         = 0,
-	}, {
-		.id            = V4L2_CID_HUE,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-		.name          = "Hue",
-		.minimum       = -128,
-		.maximum       = 127,
-		.step          = 0x1,
-		.default_value = 0,
-		.flags         = 0,
-	}
-};
-
-static int qctl_regs[ARRAY_SIZE(viu_qctrl)];
-
 static int info_level;
 
 #define dprintk(level, fmt, arg...)					\
@@ -154,6 +112,7 @@ struct viu_reg {
 
 struct viu_dev {
 	struct v4l2_device	v4l2_dev;
+	struct v4l2_ctrl_handler hdl;
 	struct mutex		lock;
 	spinlock_t		slock;
 	int			users;
@@ -1006,51 +965,6 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 	return 0;
 }
 
-/* Controls */
-static int vidioc_queryctrl(struct file *file, void *priv,
-				struct v4l2_queryctrl *qc)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(viu_qctrl); i++) {
-		if (qc->id && qc->id == viu_qctrl[i].id) {
-			memcpy(qc, &(viu_qctrl[i]), sizeof(*qc));
-			return 0;
-		}
-	}
-	return -EINVAL;
-}
-
-static int vidioc_g_ctrl(struct file *file, void *priv,
-				struct v4l2_control *ctrl)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(viu_qctrl); i++) {
-		if (ctrl->id == viu_qctrl[i].id) {
-			ctrl->value = qctl_regs[i];
-			return 0;
-		}
-	}
-	return -EINVAL;
-}
-static int vidioc_s_ctrl(struct file *file, void *priv,
-				struct v4l2_control *ctrl)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(viu_qctrl); i++) {
-		if (ctrl->id == viu_qctrl[i].id) {
-			if (ctrl->value < viu_qctrl[i].minimum
-				|| ctrl->value > viu_qctrl[i].maximum)
-					return -ERANGE;
-			qctl_regs[i] = ctrl->value;
-			return 0;
-		}
-	}
-	return -EINVAL;
-}
-
 inline void viu_activate_next_buf(struct viu_dev *dev,
 				struct viu_dmaqueue *viuq)
 {
@@ -1262,7 +1176,6 @@ static int viu_open(struct file *file)
 	struct viu_reg *vr;
 	int minor = vdev->minor;
 	u32 status_cfg;
-	int i;
 
 	dprintk(1, "viu: open (minor=%d)\n", minor);
 
@@ -1300,10 +1213,6 @@ static int viu_open(struct file *file)
 	dev->crop_current.width  = fh->width;
 	dev->crop_current.height = fh->height;
 
-	/* Put all controls at a sane state */
-	for (i = 0; i < ARRAY_SIZE(viu_qctrl); i++)
-		qctl_regs[i] = viu_qctrl[i].default_value;
-
 	dprintk(1, "Open: fh=0x%08lx, dev=0x%08lx, dev->vidq=0x%08lx\n",
 		(unsigned long)fh, (unsigned long)dev,
 		(unsigned long)&dev->vidq);
@@ -1460,9 +1369,6 @@ static const struct v4l2_ioctl_ops viu_ioctl_ops = {
 	.vidioc_enum_input    = vidioc_enum_input,
 	.vidioc_g_input       = vidioc_g_input,
 	.vidioc_s_input       = vidioc_s_input,
-	.vidioc_queryctrl     = vidioc_queryctrl,
-	.vidioc_g_ctrl        = vidioc_g_ctrl,
-	.vidioc_s_ctrl        = vidioc_s_ctrl,
 	.vidioc_streamon      = vidioc_streamon,
 	.vidioc_streamoff     = vidioc_streamoff,
 };
@@ -1540,6 +1446,16 @@ static int viu_of_probe(struct platform_device *op)
 	}
 
 	ad = i2c_get_adapter(0);
+
+	v4l2_ctrl_handler_init(&viu_dev->hdl, 5);
+	if (viu_dev->hdl.error) {
+		ret = viu_dev->hdl.error;
+		dev_err(&op->dev, "couldn't register control\n");
+		goto err_vdev;
+	}
+	/* This control handler will inherit the control(s) from the
+	   sub-device(s). */
+	viu_dev->v4l2_dev.ctrl_handler = &viu_dev->hdl;
 	viu_dev->decoder = v4l2_i2c_new_subdev(&viu_dev->v4l2_dev, ad,
 			"saa7113", VIU_VIDEO_DECODER_ADDR, NULL);
 
@@ -1607,6 +1523,7 @@ err_irq:
 err_clk:
 	video_unregister_device(viu_dev->vdev);
 err_vdev:
+	v4l2_ctrl_handler_free(&viu_dev->hdl);
 	mutex_unlock(&viu_dev->lock);
 	i2c_put_adapter(ad);
 	v4l2_device_unregister(&viu_dev->v4l2_dev);
@@ -1629,6 +1546,7 @@ static int viu_of_remove(struct platform_device *op)
 	clk_disable(dev->clk);
 	clk_put(dev->clk);
 
+	v4l2_ctrl_handler_free(&dev->hdl);
 	video_unregister_device(dev->vdev);
 	i2c_put_adapter(client->adapter);
 	v4l2_device_unregister(&dev->v4l2_dev);
-- 
1.7.10.4

