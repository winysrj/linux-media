Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4836 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab1AISFi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Jan 2011 13:05:38 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFCv2 PATCH 0/5] Use control framework in cafe_ccic and s_config removal
Date: Sun, 9 Jan 2011 19:05:26 +0100
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Daniel Drake <dsd@laptop.org>
References: <1294484508-14820-1-git-send-email-hverkuil@xs4all.nl> <20110109095540.21fcd9e4@bike.lwn.net>
In-Reply-To: <20110109095540.21fcd9e4@bike.lwn.net>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201101091905.26715.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday, January 09, 2011 17:55:40 Jonathan Corbet wrote:
> On Sat,  8 Jan 2011 12:01:43 +0100
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
> > This patch series converts the OLPC cafe_ccic driver to the new control
> > framework. It turned out that this depended on the removal of the legacy
> > s_config subdev operation. I originally created the ov7670 controls in
> > s_config, but it turned out that s_config is called after v4l2_device_register_subdev,
> > so v4l2_device_register_subdev is unable to 'inherit' the ov7670 controls
> > in cafe_ccic since there aren't any yet.
> > 
> > Another reason why s_config is a bad idea.
> > 
> > So the first patch removes s_config and v4l2_i2c_new_subdev_cfg and converts
> > any users (cafe_ccic/ov7670 among them) to v4l2_i2c_new_subdev_board, which is
> > what God (i.e. Jean Delvare) intended. :-)
> 
> I've been "vacationing" with the in-laws in Europe for the last couple of
> weeks; just got back home last night.  Body clock is still in transit
> somewhere.
> 
> Anyway, I've looked the patches over quickly and can't find anything to
> really complain about, but I can't claim to have done an in-depth review.
> Before it's merged, it would be nice to let the OLPC folks take a look
> (adding Daniel to Cc).  It also would be really nice to know that the
> reworked ov7670 driver still plays nice with the via-camera driver.  I can
> try to find time to check that out, but my time between now and LCA/FOSDEM
> is going to be tight indeed.

The via_camera driver should work just fine with the converted ov7670.

However, if someone can test the via_camera driver, then it's best to convert
the via_camera driver to the control framework as well and test that at the
same time. I've whipped up a patch for that and I've included it at the end.
Note that I saw that the via_camera struct was never freed in via_camera.c.
I've fixed that.

> > This has been extensively tested on my humble OLPC laptop (and it took me 4-5
> > hours just to get the damn thing up and running with these drivers).
> 
> My experience with the XO is always the same; it's a real pain to get
> things going after I've been away from it for a while.
> 
> > The way this works is that setting the gain on its own will turn off autogain
> > (this conforms to the current behavior of ov7670), setting autogain and gain
> > atomically will only set the gain if autogain is set to manual.
> > 
> > Ditto for exposure/autoexposure.
> > 
> > The only question is: is the current behavior of implicitly turning off autogain
> > when setting a new gain value correct? I think setting the gain in that case
> > should do nothing.
> 
> I did it that way years ago because it seemed to me that, if the
> application is setting the gain, it should actually set the gain.  I still
> think that is the behavior that makes sense.  I don't know that anybody is
> tied to that behavior, though, so it probably makes more sense to do what
> all the other drivers do, whatever that is.

Good question: 'whatever that is' :-)

I will leave it as is for now.

Regards,

	Hans

>From 39c39c9d0e5009e140822d9223fc7ac02ae04ac9 Mon Sep 17 00:00:00 2001
Message-Id: <39c39c9d0e5009e140822d9223fc7ac02ae04ac9.1294596207.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 9 Jan 2011 18:55:02 +0100
Subject: [PATCH] via-camera: implement the control framework.

And added a missing kfree to clean up the via_camera struct.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/via-camera.c |   60 +++++++++-----------------------------
 1 files changed, 14 insertions(+), 46 deletions(-)

diff --git a/drivers/media/video/via-camera.c b/drivers/media/video/via-camera.c
index e25aca5..57538a3 100644
--- a/drivers/media/video/via-camera.c
+++ b/drivers/media/video/via-camera.c
@@ -19,6 +19,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-ctrls.h>
 #include <media/videobuf-dma-sg.h>
 #include <linux/device.h>
 #include <linux/delay.h>
@@ -64,6 +65,7 @@ enum viacam_opstate { S_IDLE = 0, S_RUNNING = 1 };
 
 struct via_camera {
 	struct v4l2_device v4l2_dev;
+	struct v4l2_ctrl_handler ctrl_handler;
 	struct video_device vdev;
 	struct v4l2_subdev *sensor;
 	struct platform_device *platdev;
@@ -823,47 +825,6 @@ static int viacam_g_chip_ident(struct file *file, void *priv,
 }
 
 /*
- * Control ops are passed through to the sensor.
- */
-static int viacam_queryctrl(struct file *filp, void *priv,
-		struct v4l2_queryctrl *qc)
-{
-	struct via_camera *cam = priv;
-	int ret;
-
-	mutex_lock(&cam->lock);
-	ret = sensor_call(cam, core, queryctrl, qc);
-	mutex_unlock(&cam->lock);
-	return ret;
-}
-
-
-static int viacam_g_ctrl(struct file *filp, void *priv,
-		struct v4l2_control *ctrl)
-{
-	struct via_camera *cam = priv;
-	int ret;
-
-	mutex_lock(&cam->lock);
-	ret = sensor_call(cam, core, g_ctrl, ctrl);
-	mutex_unlock(&cam->lock);
-	return ret;
-}
-
-
-static int viacam_s_ctrl(struct file *filp, void *priv,
-		struct v4l2_control *ctrl)
-{
-	struct via_camera *cam = priv;
-	int ret;
-
-	mutex_lock(&cam->lock);
-	ret = sensor_call(cam, core, s_ctrl, ctrl);
-	mutex_unlock(&cam->lock);
-	return ret;
-}
-
-/*
  * Only one input.
  */
 static int viacam_enum_input(struct file *filp, void *priv,
@@ -1219,9 +1180,6 @@ static int viacam_enum_frameintervals(struct file *filp, void *priv,
 
 static const struct v4l2_ioctl_ops viacam_ioctl_ops = {
 	.vidioc_g_chip_ident	= viacam_g_chip_ident,
-	.vidioc_queryctrl	= viacam_queryctrl,
-	.vidioc_g_ctrl		= viacam_g_ctrl,
-	.vidioc_s_ctrl		= viacam_s_ctrl,
 	.vidioc_enum_input	= viacam_enum_input,
 	.vidioc_g_input		= viacam_g_input,
 	.vidioc_s_input		= viacam_s_input,
@@ -1320,8 +1278,12 @@ static __devinit int viacam_probe(struct platform_device *pdev)
 	ret = v4l2_device_register(&pdev->dev, &cam->v4l2_dev);
 	if (ret) {
 		dev_err(&pdev->dev, "Unable to register v4l2 device\n");
-		return ret;
+		goto out_free;
 	}
+	ret = v4l2_ctrl_handler_init(&cam->ctrl_handler, 10);
+	if (ret)
+		goto out_unregister;
+	cam->v4l2_dev.ctrl_handler = &cam->ctrl_handler;
 	/*
 	 * Convince the system that we can do DMA.
 	 */
@@ -1338,7 +1300,7 @@ static __devinit int viacam_probe(struct platform_device *pdev)
 	 */
 	ret = via_sensor_power_setup(cam);
 	if (ret)
-		goto out_unregister;
+		goto out_ctrl_hdl_free;
 	via_sensor_power_up(cam);
 
 	/*
@@ -1379,8 +1341,12 @@ out_irq:
 	free_irq(viadev->pdev->irq, cam);
 out_power_down:
 	via_sensor_power_release(cam);
+out_ctrl_hdl_free:
+	v4l2_ctrl_handler_free(&cam->ctrl_handler);
 out_unregister:
 	v4l2_device_unregister(&cam->v4l2_dev);
+out_free:
+	kfree(cam);
 	return ret;
 }
 
@@ -1393,6 +1359,8 @@ static __devexit int viacam_remove(struct platform_device *pdev)
 	v4l2_device_unregister(&cam->v4l2_dev);
 	free_irq(viadev->pdev->irq, cam);
 	via_sensor_power_release(cam);
+	v4l2_ctrl_handler_free(&cam->ctrl_handler);
+	kfree(cam);
 	via_cam_info = NULL;
 	return 0;
 }
-- 
1.7.0.4


-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
