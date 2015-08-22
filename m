Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40428 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbbHVR2h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:37 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 15/39] [media] v4l2-subdev: add remaining argument descriptions
Date: Sat, 22 Aug 2015 14:28:00 -0300
Message-Id: <48c6d9031a11bbe8d338c06e34482744cbe23f64.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Warning(.//include/media/v4l2-subdev.h:203): No description found for parameter 'ioctl'
Warning(.//include/media/v4l2-subdev.h:203): No description found for parameter 'compat_ioctl32'
Warning(.//include/media/v4l2-subdev.h:203): No description found for parameter 'subscribe_event'
Warning(.//include/media/v4l2-subdev.h:203): No description found for parameter 'unsubscribe_event'
Warning(.//include/media/v4l2-subdev.h:273): No description found for parameter 's_stream'
Warning(.//include/media/v4l2-subdev.h:407): No description found for parameter 's_stream'
Warning(.//include/media/v4l2-subdev.h:623): No description found for parameter 'link_validate'
Warning(.//include/media/v4l2-subdev.h:623): No description found for parameter 'set_frame_desc'

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index c6205c038b06..b273cf9ac047 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -157,6 +157,12 @@ struct v4l2_subdev_io_pin_config {
  *
  * @querymenu: callback for VIDIOC_QUERYMENU ioctl handler code.
  *
+ * @ioctl: called at the end of ioctl() syscall handler at the V4L2 core.
+ *	   used to provide support for private ioctls used on the driver.
+ *
+ * @compat_ioctl32: called when a 32 bits application uses a 64 bits Kernel,
+ *		    in order to fix data passed from/to userspace.
+ *
  * @g_register: callback for VIDIOC_G_REGISTER ioctl handler code.
  *
  * @s_register: callback for VIDIOC_G_REGISTER ioctl handler code.
@@ -168,6 +174,11 @@ struct v4l2_subdev_io_pin_config {
  *	handler, when an interrupt status has be raised due to this subdev,
  *	so that this subdev can handle the details.  It may schedule work to be
  *	performed later.  It must not sleep.  *Called from an IRQ context*.
+ *
+ * @subscribe_event: used by the drivers to request the control framework that
+ *		     for it to be warned when the value of a control changes.
+ *
+ * @unsubscribe_event: remove event subscription from the control framework.
  */
 struct v4l2_subdev_core_ops {
 	int (*log_status)(struct v4l2_subdev *sd);
@@ -264,6 +275,9 @@ struct v4l2_subdev_tuner_ops {
  *	board or platform it might be connected to something else entirely.
  *	The calling driver is responsible for mapping a user-level input to
  *	the right pins on the i2c device.
+ *
+ * @s_stream: used to notify the audio code that stream will start or has
+ *	stopped.
  */
 struct v4l2_subdev_audio_ops {
 	int (*s_clock_freq)(struct v4l2_subdev *sd, u32 freq);
@@ -339,6 +353,9 @@ struct v4l2_mbus_frame_desc {
  * @g_input_status: get input status. Same as the status field in the v4l2_input
  *	struct.
  *
+ * @s_stream: used to notify the driver that a video stream will start or has
+ *	stopped.
+ *
  * @cropcap: callback for VIDIOC_CROPCAP ioctl handler code.
  *
  * @g_crop: callback for VIDIOC_G_CROP ioctl handler code.
@@ -578,9 +595,12 @@ struct v4l2_subdev_pad_config {
  * @enum_dv_timings: callback for VIDIOC_SUBDEV_ENUM_DV_TIMINGS ioctl handler
  *		     code.
  *
+ * @link_validate: used by the media controller code to check if the links
+ *		   that belongs to a pipeline can be used for stream.
+ *
  * @get_frame_desc: get the current low level media bus frame parameters.
  *
- * @get_frame_desc: set the low level media bus frame parameters, @fd array
+ * @set_frame_desc: set the low level media bus frame parameters, @fd array
  *                  may be adjusted by the subdev driver to device capabilities.
  */
 struct v4l2_subdev_pad_ops {
-- 
2.4.3

