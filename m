Return-path: <mchehab@pedra>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2615 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab1AGMrx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 07:47:53 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFC PATCH 5/5] cafe_ccic: implement the control framework.
Date: Fri,  7 Jan 2011 13:47:35 +0100
Message-Id: <c724109013cf9c85df4b21da66bd323dc4627b7e.1294402580.git.hverkuil@xs4all.nl>
In-Reply-To: <1294404455-22050-1-git-send-email-hverkuil@xs4all.nl>
References: <1294404455-22050-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <cc5591b13e048b8fbc1482db6dffeb7d48f9134b.1294402580.git.hverkuil@xs4all.nl>
References: <cc5591b13e048b8fbc1482db6dffeb7d48f9134b.1294402580.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

And also swapped the out_free and out_unreg labels as they were in the
wrong order.

Tested with the OLPC laptop.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/cafe_ccic.c |   59 +++++++-------------------------------
 1 files changed, 11 insertions(+), 48 deletions(-)

diff --git a/drivers/media/video/cafe_ccic.c b/drivers/media/video/cafe_ccic.c
index 7488b47..44ec342 100644
--- a/drivers/media/video/cafe_ccic.c
+++ b/drivers/media/video/cafe_ccic.c
@@ -35,6 +35,7 @@
 #include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-chip-ident.h>
 #include <linux/device.h>
 #include <linux/wait.h>
@@ -145,6 +146,7 @@ struct cafe_sio_buffer {
 struct cafe_camera
 {
 	struct v4l2_device v4l2_dev;
+	struct v4l2_ctrl_handler ctrl_handler;
 	enum cafe_state state;
 	unsigned long flags;   		/* Buffer status, mainly (dev_lock) */
 	int users;			/* How many open FDs */
@@ -1466,48 +1468,6 @@ static unsigned int cafe_v4l_poll(struct file *filp,
 
 
 
-static int cafe_vidioc_queryctrl(struct file *filp, void *priv,
-		struct v4l2_queryctrl *qc)
-{
-	struct cafe_camera *cam = priv;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, core, queryctrl, qc);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-static int cafe_vidioc_g_ctrl(struct file *filp, void *priv,
-		struct v4l2_control *ctrl)
-{
-	struct cafe_camera *cam = priv;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, core, g_ctrl, ctrl);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-static int cafe_vidioc_s_ctrl(struct file *filp, void *priv,
-		struct v4l2_control *ctrl)
-{
-	struct cafe_camera *cam = priv;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, core, s_ctrl, ctrl);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-
-
-
 static int cafe_vidioc_querycap(struct file *file, void *priv,
 		struct v4l2_capability *cap)
 {
@@ -1792,9 +1752,6 @@ static const struct v4l2_ioctl_ops cafe_v4l_ioctl_ops = {
 	.vidioc_dqbuf		= cafe_vidioc_dqbuf,
 	.vidioc_streamon	= cafe_vidioc_streamon,
 	.vidioc_streamoff	= cafe_vidioc_streamoff,
-	.vidioc_queryctrl	= cafe_vidioc_queryctrl,
-	.vidioc_g_ctrl		= cafe_vidioc_g_ctrl,
-	.vidioc_s_ctrl		= cafe_vidioc_s_ctrl,
 	.vidioc_g_parm		= cafe_vidioc_g_parm,
 	.vidioc_s_parm		= cafe_vidioc_s_parm,
 	.vidioc_enum_framesizes = cafe_vidioc_enum_framesizes,
@@ -2031,6 +1988,10 @@ static int cafe_pci_probe(struct pci_dev *pdev,
 	INIT_LIST_HEAD(&cam->sb_avail);
 	INIT_LIST_HEAD(&cam->sb_full);
 	tasklet_init(&cam->s_tasklet, cafe_frame_tasklet, (unsigned long) cam);
+	ret = v4l2_ctrl_handler_init(&cam->ctrl_handler, 10);
+	if (ret)
+		goto out_unreg;
+	cam->v4l2_dev.ctrl_handler = &cam->ctrl_handler;
 	/*
 	 * Get set up on the PCI bus.
 	 */
@@ -2087,10 +2048,10 @@ static int cafe_pci_probe(struct pci_dev *pdev,
 	cam->vdev.debug = 0;
 /*	cam->vdev.debug = V4L2_DEBUG_IOCTL_ARG;*/
 	cam->vdev.v4l2_dev = &cam->v4l2_dev;
+	video_set_drvdata(&cam->vdev, cam);
 	ret = video_register_device(&cam->vdev, VFL_TYPE_GRABBER, -1);
 	if (ret)
 		goto out_unlock;
-	video_set_drvdata(&cam->vdev, cam);
 
 	/*
 	 * If so requested, try to get our DMA buffers now.
@@ -2113,9 +2074,10 @@ out_freeirq:
 	free_irq(pdev->irq, cam);
 out_iounmap:
 	pci_iounmap(pdev, cam->regs);
-out_free:
-	v4l2_device_unregister(&cam->v4l2_dev);
 out_unreg:
+	v4l2_ctrl_handler_free(&cam->ctrl_handler);
+	v4l2_device_unregister(&cam->v4l2_dev);
+out_free:
 	kfree(cam);
 out:
 	return ret;
@@ -2154,6 +2116,7 @@ static void cafe_pci_remove(struct pci_dev *pdev)
 	if (cam->users > 0)
 		cam_warn(cam, "Removing a device with users!\n");
 	cafe_shutdown(cam);
+	v4l2_ctrl_handler_free(&cam->ctrl_handler);
 	v4l2_device_unregister(&cam->v4l2_dev);
 	kfree(cam);
 /* No unlock - it no longer exists */
-- 
1.7.0.4

