Return-path: <linux-media-owner@vger.kernel.org>
Received: from anholt.net ([50.246.234.109]:52160 "EHLO anholt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752123AbdA0V7F (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jan 2017 16:59:05 -0500
From: Eric Anholt <eric@anholt.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Anholt <eric@anholt.net>
Subject: [PATCH 5/6] staging: bcm2835-v4l2: Apply many whitespace fixes from checkpatch.
Date: Fri, 27 Jan 2017 13:55:02 -0800
Message-Id: <20170127215503.13208-6-eric@anholt.net>
In-Reply-To: <20170127215503.13208-1-eric@anholt.net>
References: <20170127215503.13208-1-eric@anholt.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Generated with checkpatch.pl --fix-inplace, some manual fixes for
cases where checkpatch fixed one out of multiple lines of mis-indented
function parameters, and then git add -p out of the results.

I skipped some fixes that should probably instead be replaced with the
BIT() macro.

Signed-off-by: Eric Anholt <eric@anholt.net>
---
 .../media/platform/bcm2835/bcm2835-camera.c        |  90 ++++----
 drivers/staging/media/platform/bcm2835/controls.c  | 236 ++++++++++-----------
 .../staging/media/platform/bcm2835/mmal-vchiq.c    |  13 +-
 3 files changed, 167 insertions(+), 172 deletions(-)

diff --git a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
index 4f03949aecf3..4541a363905c 100644
--- a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
+++ b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
@@ -38,7 +38,7 @@
 #define BM2835_MMAL_MODULE_NAME "bcm2835-v4l2"
 #define MIN_WIDTH 32
 #define MIN_HEIGHT 32
-#define MIN_BUFFER_SIZE (80*1024)
+#define MIN_BUFFER_SIZE (80 * 1024)
 
 #define MAX_VIDEO_MODE_WIDTH 1280
 #define MAX_VIDEO_MODE_HEIGHT 720
@@ -420,6 +420,7 @@ static void buffer_cb(struct vchiq_mmal_instance *instance,
 static int enable_camera(struct bm2835_mmal_dev *dev)
 {
 	int ret;
+
 	if (!dev->camera_use_count) {
 		ret = vchiq_mmal_port_parameter_set(
 			dev->instance,
@@ -451,6 +452,7 @@ static int enable_camera(struct bm2835_mmal_dev *dev)
 static int disable_camera(struct bm2835_mmal_dev *dev)
 {
 	int ret;
+
 	if (!dev->camera_use_count) {
 		v4l2_err(&dev->v4l2_dev,
 			 "Disabled the camera when already disabled\n");
@@ -459,6 +461,7 @@ static int disable_camera(struct bm2835_mmal_dev *dev)
 	dev->camera_use_count--;
 	if (!dev->camera_use_count) {
 		unsigned int i = 0xFFFFFFFF;
+
 		v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
 			 "Disabling camera\n");
 		ret =
@@ -643,12 +646,14 @@ static void stop_streaming(struct vb2_queue *vq)
 static void bm2835_mmal_lock(struct vb2_queue *vq)
 {
 	struct bm2835_mmal_dev *dev = vb2_get_drv_priv(vq);
+
 	mutex_lock(&dev->mutex);
 }
 
 static void bm2835_mmal_unlock(struct vb2_queue *vq)
 {
 	struct bm2835_mmal_dev *dev = vb2_get_drv_priv(vq);
+
 	mutex_unlock(&dev->mutex);
 }
 
@@ -737,7 +742,7 @@ static int vidioc_try_fmt_vid_overlay(struct file *file, void *priv,
 			      1, 0);
 
 	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
-		"Overlay: Now w/h %dx%d l/t %dx%d\n",
+		 "Overlay: Now w/h %dx%d l/t %dx%d\n",
 		f->fmt.win.w.width, f->fmt.win.w.height,
 		f->fmt.win.w.left, f->fmt.win.w.top);
 
@@ -759,7 +764,7 @@ static int vidioc_s_fmt_vid_overlay(struct file *file, void *priv,
 	dev->overlay = f->fmt.win;
 	if (dev->component[MMAL_COMPONENT_PREVIEW]->enabled) {
 		set_overlay_params(dev,
-			&dev->component[MMAL_COMPONENT_PREVIEW]->input[0]);
+				   &dev->component[MMAL_COMPONENT_PREVIEW]->input[0]);
 	}
 
 	return 0;
@@ -771,6 +776,7 @@ static int vidioc_overlay(struct file *file, void *f, unsigned int on)
 	struct bm2835_mmal_dev *dev = video_drvdata(file);
 	struct vchiq_mmal_port *src;
 	struct vchiq_mmal_port *dst;
+
 	if ((on && dev->component[MMAL_COMPONENT_PREVIEW]->enabled) ||
 	    (!on && !dev->component[MMAL_COMPONENT_PREVIEW]->enabled))
 		return 0;	/* already in requested state */
@@ -842,7 +848,7 @@ static int vidioc_g_fbuf(struct file *file, void *fh,
 	a->fmt.pixelformat = V4L2_PIX_FMT_YUV420;
 	a->fmt.bytesperline = preview_port->es.video.width;
 	a->fmt.sizeimage = (preview_port->es.video.width *
-			       preview_port->es.video.height * 3)>>1;
+			       preview_port->es.video.height * 3) >> 1;
 	a->fmt.colorspace = V4L2_COLORSPACE_SMPTE170M;
 
 	return 0;
@@ -958,8 +964,8 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.field = V4L2_FIELD_NONE;
 
 	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
-		"Clipping/aligning %dx%d format %08X\n",
-		f->fmt.pix.width, f->fmt.pix.height, f->fmt.pix.pixelformat);
+		 "Clipping/aligning %dx%d format %08X\n",
+		 f->fmt.pix.width, f->fmt.pix.height, f->fmt.pix.pixelformat);
 
 	v4l_bound_align_image(&f->fmt.pix.width, MIN_WIDTH, dev->max_width, 1,
 			      &f->fmt.pix.height, MIN_HEIGHT, dev->max_height,
@@ -969,8 +975,8 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	/* Image buffer has to be padded to allow for alignment, even though
 	 * we then remove that padding before delivering the buffer.
 	 */
-	f->fmt.pix.sizeimage = ((f->fmt.pix.height+15)&~15) *
-			(((f->fmt.pix.width+31)&~31) * mfmt->depth) >> 3;
+	f->fmt.pix.sizeimage = ((f->fmt.pix.height + 15) & ~15) *
+			(((f->fmt.pix.width + 31) & ~31) * mfmt->depth) >> 3;
 
 	if ((mfmt->flags & V4L2_FMT_FLAG_COMPRESSED) &&
 	    f->fmt.pix.sizeimage < MIN_BUFFER_SIZE)
@@ -985,7 +991,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.priv = 0;
 
 	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
-		"Now %dx%d format %08X\n",
+		 "Now %dx%d format %08X\n",
 		f->fmt.pix.width, f->fmt.pix.height, f->fmt.pix.pixelformat);
 
 	v4l2_dump_pix_format(1, bcm2835_v4l2_debug, &dev->v4l2_dev, &f->fmt.pix,
@@ -1203,9 +1209,9 @@ static int mmal_setup_components(struct bm2835_mmal_dev *dev,
 						encode_component);
 				if (ret) {
 					v4l2_dbg(1, bcm2835_v4l2_debug,
-					   &dev->v4l2_dev,
-					   "%s Failed to enable encode components\n",
-					   __func__);
+						 &dev->v4l2_dev,
+						 "%s Failed to enable encode components\n",
+						 __func__);
 				}
 			}
 			if (!ret) {
@@ -1216,10 +1222,10 @@ static int mmal_setup_components(struct bm2835_mmal_dev *dev,
 				if (port->format.encoding ==
 				    MMAL_ENCODING_JPEG) {
 					v4l2_dbg(1, bcm2835_v4l2_debug,
-					    &dev->v4l2_dev,
-					    "JPG - buf size now %d was %d\n",
-					    f->fmt.pix.sizeimage,
-					    port->current_buffer.size);
+						 &dev->v4l2_dev,
+						 "JPG - buf size now %d was %d\n",
+						 f->fmt.pix.sizeimage,
+						 port->current_buffer.size);
 					port->current_buffer.size =
 					    (f->fmt.pix.sizeimage <
 					     (100 << 10))
@@ -1332,7 +1338,7 @@ int vidioc_enum_framesizes(struct file *file, void *fh,
 
 /* timeperframe is arbitrary and continous */
 static int vidioc_enum_frameintervals(struct file *file, void *priv,
-					     struct v4l2_frmivalenum *fival)
+				      struct v4l2_frmivalenum *fival)
 {
 	struct bm2835_mmal_dev *dev = video_drvdata(file);
 	int i;
@@ -1362,7 +1368,7 @@ static int vidioc_enum_frameintervals(struct file *file, void *priv,
 }
 
 static int vidioc_g_parm(struct file *file, void *priv,
-			  struct v4l2_streamparm *parm)
+			 struct v4l2_streamparm *parm)
 {
 	struct bm2835_mmal_dev *dev = video_drvdata(file);
 
@@ -1380,7 +1386,7 @@ static int vidioc_g_parm(struct file *file, void *priv,
 	 (u64)(b).numerator * (a).denominator)
 
 static int vidioc_s_parm(struct file *file, void *priv,
-			  struct v4l2_streamparm *parm)
+			 struct v4l2_streamparm *parm)
 {
 	struct bm2835_mmal_dev *dev = video_drvdata(file);
 	struct v4l2_fract tpf;
@@ -1516,7 +1522,7 @@ static struct video_device vdev_template = {
  * by those cameras.
  */
 static int get_num_cameras(struct vchiq_mmal_instance *instance,
-	unsigned int resolutions[][2], int num_resolutions)
+			   unsigned int resolutions[][2], int num_resolutions)
 {
 	int ret;
 	struct vchiq_mmal_component  *cam_info_component;
@@ -1621,14 +1627,14 @@ static int __init mmal_init(struct bm2835_mmal_dev *dev)
 	dev->rgb_bgr_swapped = true;
 	param_size = sizeof(supported_encodings);
 	ret = vchiq_mmal_port_parameter_get(dev->instance,
-		&camera->output[MMAL_CAMERA_PORT_CAPTURE],
-		MMAL_PARAMETER_SUPPORTED_ENCODINGS,
-		&supported_encodings,
-		&param_size);
+					    &camera->output[MMAL_CAMERA_PORT_CAPTURE],
+					    MMAL_PARAMETER_SUPPORTED_ENCODINGS,
+					    &supported_encodings,
+					    &param_size);
 	if (ret == 0) {
 		int i;
 
-		for (i = 0; i < param_size/sizeof(u32); i++) {
+		for (i = 0; i < param_size / sizeof(u32); i++) {
 			if (supported_encodings[i] == MMAL_ENCODING_BGR24) {
 				/* Found BGR24 first - old firmware. */
 				break;
@@ -1671,9 +1677,9 @@ static int __init mmal_init(struct bm2835_mmal_dev *dev)
 	format->es->video.frame_rate.den = 1;
 
 	vchiq_mmal_port_parameter_set(dev->instance,
-		&camera->output[MMAL_CAMERA_PORT_VIDEO],
-		MMAL_PARAMETER_NO_IMAGE_PADDING,
-		&bool_true, sizeof(bool_true));
+				      &camera->output[MMAL_CAMERA_PORT_VIDEO],
+				      MMAL_PARAMETER_NO_IMAGE_PADDING,
+				      &bool_true, sizeof(bool_true));
 
 	format = &camera->output[MMAL_CAMERA_PORT_CAPTURE].format;
 
@@ -1697,9 +1703,9 @@ static int __init mmal_init(struct bm2835_mmal_dev *dev)
 	dev->capture.enc_level = V4L2_MPEG_VIDEO_H264_LEVEL_4_0;
 
 	vchiq_mmal_port_parameter_set(dev->instance,
-		&camera->output[MMAL_CAMERA_PORT_CAPTURE],
-		MMAL_PARAMETER_NO_IMAGE_PADDING,
-		&bool_true, sizeof(bool_true));
+				      &camera->output[MMAL_CAMERA_PORT_CAPTURE],
+				      MMAL_PARAMETER_NO_IMAGE_PADDING,
+				      &bool_true, sizeof(bool_true));
 
 	/* get the preview component ready */
 	ret = vchiq_mmal_component_init(
@@ -1750,11 +1756,12 @@ static int __init mmal_init(struct bm2835_mmal_dev *dev)
 			&dev->component[MMAL_COMPONENT_VIDEO_ENCODE]->output[0];
 		encoder_port->format.encoding = MMAL_ENCODING_H264;
 		ret = vchiq_mmal_port_set_format(dev->instance,
-			encoder_port);
+						 encoder_port);
 	}
 
 	{
 		unsigned int enable = 1;
+
 		vchiq_mmal_port_parameter_set(
 			dev->instance,
 			&dev->component[MMAL_COMPONENT_VIDEO_ENCODE]->control,
@@ -1762,10 +1769,10 @@ static int __init mmal_init(struct bm2835_mmal_dev *dev)
 			&enable, sizeof(enable));
 
 		vchiq_mmal_port_parameter_set(dev->instance,
-			&dev->component[MMAL_COMPONENT_VIDEO_ENCODE]->control,
-			MMAL_PARAMETER_MINIMISE_FRAGMENTATION,
-			&enable,
-			sizeof(enable));
+					      &dev->component[MMAL_COMPONENT_VIDEO_ENCODE]->control,
+					      MMAL_PARAMETER_MINIMISE_FRAGMENTATION,
+					      &enable,
+					      sizeof(enable));
 	}
 	ret = bm2835_mmal_set_all_camera_controls(dev);
 	if (ret < 0)
@@ -1808,7 +1815,7 @@ static int __init bm2835_mmal_init_device(struct bm2835_mmal_dev *dev,
 	*vfd = vdev_template;
 	if (gst_v4l2src_is_broken) {
 		v4l2_info(&dev->v4l2_dev,
-		  "Work-around for gstreamer issue is active.\n");
+			  "Work-around for gstreamer issue is active.\n");
 		vfd->ioctl_ops = &camera0_ioctl_ops_gstreamer;
 	}
 
@@ -1828,8 +1835,9 @@ static int __init bm2835_mmal_init_device(struct bm2835_mmal_dev *dev,
 		return ret;
 
 	v4l2_info(vfd->v4l2_dev,
-		"V4L2 device registered as %s - stills mode > %dx%d\n",
-		video_device_node_name(vfd), max_video_width, max_video_height);
+		  "V4L2 device registered as %s - stills mode > %dx%d\n",
+		  video_device_node_name(vfd),
+		  max_video_width, max_video_height);
 
 	return 0;
 }
@@ -1881,7 +1889,7 @@ static struct v4l2_format default_v4l2_format = {
 	.fmt.pix.width = 1024,
 	.fmt.pix.bytesperline = 0,
 	.fmt.pix.height = 768,
-	.fmt.pix.sizeimage = 1024*768,
+	.fmt.pix.sizeimage = 1024 * 768,
 };
 
 static int __init bm2835_mmal_init(void)
@@ -1995,7 +2003,7 @@ static int __init bm2835_mmal_init(void)
 		gdev[camera] = NULL;
 	}
 	pr_info("%s: error %d while loading driver\n",
-		 BM2835_MMAL_MODULE_NAME, ret);
+		BM2835_MMAL_MODULE_NAME, ret);
 
 	return ret;
 }
diff --git a/drivers/staging/media/platform/bcm2835/controls.c b/drivers/staging/media/platform/bcm2835/controls.c
index fe61330ba2a6..a40987b2e75d 100644
--- a/drivers/staging/media/platform/bcm2835/controls.c
+++ b/drivers/staging/media/platform/bcm2835/controls.c
@@ -171,8 +171,8 @@ static const struct v4l2_mmal_scene_config scene_configs[] = {
 /* control handlers*/
 
 static int ctrl_set_rational(struct bm2835_mmal_dev *dev,
-		      struct v4l2_ctrl *ctrl,
-		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+			     struct v4l2_ctrl *ctrl,
+			     const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
 {
 	struct mmal_parameter_rational rational_value;
 	struct vchiq_mmal_port *control;
@@ -189,8 +189,8 @@ static int ctrl_set_rational(struct bm2835_mmal_dev *dev,
 }
 
 static int ctrl_set_value(struct bm2835_mmal_dev *dev,
-		      struct v4l2_ctrl *ctrl,
-		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+			  struct v4l2_ctrl *ctrl,
+			  const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
 {
 	u32 u32_value;
 	struct vchiq_mmal_port *control;
@@ -205,8 +205,8 @@ static int ctrl_set_value(struct bm2835_mmal_dev *dev,
 }
 
 static int ctrl_set_iso(struct bm2835_mmal_dev *dev,
-		      struct v4l2_ctrl *ctrl,
-		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+			struct v4l2_ctrl *ctrl,
+			const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
 {
 	u32 u32_value;
 	struct vchiq_mmal_port *control;
@@ -235,15 +235,15 @@ static int ctrl_set_iso(struct bm2835_mmal_dev *dev,
 }
 
 static int ctrl_set_value_ev(struct bm2835_mmal_dev *dev,
-		      struct v4l2_ctrl *ctrl,
-		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+			     struct v4l2_ctrl *ctrl,
+			     const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
 {
 	s32 s32_value;
 	struct vchiq_mmal_port *control;
 
 	control = &dev->component[MMAL_COMPONENT_CAMERA]->control;
 
-	s32_value = (ctrl->val-12)*2;	/* Convert from index to 1/6ths */
+	s32_value = (ctrl->val - 12) * 2;	/* Convert from index to 1/6ths */
 
 	return vchiq_mmal_port_parameter_set(dev->instance, control,
 					     mmal_ctrl->mmal_id,
@@ -251,8 +251,8 @@ static int ctrl_set_value_ev(struct bm2835_mmal_dev *dev,
 }
 
 static int ctrl_set_rotate(struct bm2835_mmal_dev *dev,
-		      struct v4l2_ctrl *ctrl,
-		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+			   struct v4l2_ctrl *ctrl,
+			   const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
 {
 	int ret;
 	u32 u32_value;
@@ -282,8 +282,8 @@ static int ctrl_set_rotate(struct bm2835_mmal_dev *dev,
 }
 
 static int ctrl_set_flip(struct bm2835_mmal_dev *dev,
-		      struct v4l2_ctrl *ctrl,
-		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+			 struct v4l2_ctrl *ctrl,
+			 const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
 {
 	int ret;
 	u32 u32_value;
@@ -322,12 +322,11 @@ static int ctrl_set_flip(struct bm2835_mmal_dev *dev,
 					    &u32_value, sizeof(u32_value));
 
 	return ret;
-
 }
 
 static int ctrl_set_exposure(struct bm2835_mmal_dev *dev,
-		      struct v4l2_ctrl *ctrl,
-		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+			     struct v4l2_ctrl *ctrl,
+			     const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
 {
 	enum mmal_parameter_exposuremode exp_mode = dev->exposure_mode_user;
 	u32 shutter_speed = 0;
@@ -362,15 +361,15 @@ static int ctrl_set_exposure(struct bm2835_mmal_dev *dev,
 			shutter_speed = dev->manual_shutter_speed;
 
 		ret = vchiq_mmal_port_parameter_set(dev->instance,
-					control,
-					MMAL_PARAMETER_SHUTTER_SPEED,
-					&shutter_speed,
-					sizeof(shutter_speed));
+						    control,
+						    MMAL_PARAMETER_SHUTTER_SPEED,
+						    &shutter_speed,
+						    sizeof(shutter_speed));
 		ret += vchiq_mmal_port_parameter_set(dev->instance,
-					control,
-					MMAL_PARAMETER_EXPOSURE_MODE,
-					&exp_mode,
-					sizeof(u32));
+						     control,
+						     MMAL_PARAMETER_EXPOSURE_MODE,
+						     &exp_mode,
+						     sizeof(u32));
 		dev->exposure_mode_active = exp_mode;
 	}
 	/* exposure_dynamic_framerate (V4L2_CID_EXPOSURE_AUTO_PRIORITY) should
@@ -382,8 +381,8 @@ static int ctrl_set_exposure(struct bm2835_mmal_dev *dev,
 }
 
 static int ctrl_set_metering_mode(struct bm2835_mmal_dev *dev,
-			   struct v4l2_ctrl *ctrl,
-			   const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+				  struct v4l2_ctrl *ctrl,
+				  const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
 {
 	switch (ctrl->val) {
 	case V4L2_EXPOSURE_METERING_AVERAGE:
@@ -403,7 +402,6 @@ static int ctrl_set_metering_mode(struct bm2835_mmal_dev *dev,
 		dev->metering_mode = MMAL_PARAM_EXPOSUREMETERINGMODE_MATRIX;
 		break;
 	*/
-
 	}
 
 	if (dev->scene_mode == V4L2_SCENE_MODE_NONE) {
@@ -420,8 +418,8 @@ static int ctrl_set_metering_mode(struct bm2835_mmal_dev *dev,
 }
 
 static int ctrl_set_flicker_avoidance(struct bm2835_mmal_dev *dev,
-			   struct v4l2_ctrl *ctrl,
-			   const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+				      struct v4l2_ctrl *ctrl,
+				      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
 {
 	u32 u32_value;
 	struct vchiq_mmal_port *control;
@@ -449,8 +447,8 @@ static int ctrl_set_flicker_avoidance(struct bm2835_mmal_dev *dev,
 }
 
 static int ctrl_set_awb_mode(struct bm2835_mmal_dev *dev,
-		      struct v4l2_ctrl *ctrl,
-		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+			     struct v4l2_ctrl *ctrl,
+			     const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
 {
 	u32 u32_value;
 	struct vchiq_mmal_port *control;
@@ -497,7 +495,6 @@ static int ctrl_set_awb_mode(struct bm2835_mmal_dev *dev,
 	case V4L2_WHITE_BALANCE_SHADE:
 		u32_value = MMAL_PARAM_AWBMODE_SHADE;
 		break;
-
 	}
 
 	return vchiq_mmal_port_parameter_set(dev->instance, control,
@@ -506,8 +503,8 @@ static int ctrl_set_awb_mode(struct bm2835_mmal_dev *dev,
 }
 
 static int ctrl_set_awb_gains(struct bm2835_mmal_dev *dev,
-		      struct v4l2_ctrl *ctrl,
-		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+			      struct v4l2_ctrl *ctrl,
+			      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
 {
 	struct vchiq_mmal_port *control;
 	struct mmal_parameter_awbgains gains;
@@ -529,8 +526,8 @@ static int ctrl_set_awb_gains(struct bm2835_mmal_dev *dev,
 }
 
 static int ctrl_set_image_effect(struct bm2835_mmal_dev *dev,
-		   struct v4l2_ctrl *ctrl,
-		   const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+				 struct v4l2_ctrl *ctrl,
+				 const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
 {
 	int ret = -EINVAL;
 	int i, j;
@@ -539,7 +536,6 @@ static int ctrl_set_image_effect(struct bm2835_mmal_dev *dev,
 
 	for (i = 0; i < ARRAY_SIZE(v4l2_to_mmal_effects_values); i++) {
 		if (ctrl->val == v4l2_to_mmal_effects_values[i].v4l2_effect) {
-
 			imagefx.effect =
 				v4l2_to_mmal_effects_values[i].mmal_effect;
 			imagefx.num_effect_params =
@@ -588,8 +584,8 @@ static int ctrl_set_image_effect(struct bm2835_mmal_dev *dev,
 }
 
 static int ctrl_set_colfx(struct bm2835_mmal_dev *dev,
-		   struct v4l2_ctrl *ctrl,
-		   const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+			  struct v4l2_ctrl *ctrl,
+			  const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
 {
 	int ret = -EINVAL;
 	struct vchiq_mmal_port *control;
@@ -600,8 +596,9 @@ static int ctrl_set_colfx(struct bm2835_mmal_dev *dev,
 	dev->colourfx.enable = ctrl->val & 0xff;
 
 	ret = vchiq_mmal_port_parameter_set(dev->instance, control,
-					MMAL_PARAMETER_COLOUR_EFFECT,
-					&dev->colourfx, sizeof(dev->colourfx));
+					    MMAL_PARAMETER_COLOUR_EFFECT,
+					    &dev->colourfx,
+					    sizeof(dev->colourfx));
 
 	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
 		 "%s: After: mmal_ctrl:%p ctrl id:0x%x ctrl val:%d ret %d(%d)\n",
@@ -611,8 +608,8 @@ static int ctrl_set_colfx(struct bm2835_mmal_dev *dev,
 }
 
 static int ctrl_set_bitrate(struct bm2835_mmal_dev *dev,
-		   struct v4l2_ctrl *ctrl,
-		   const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+			    struct v4l2_ctrl *ctrl,
+			    const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
 {
 	int ret;
 	struct vchiq_mmal_port *encoder_out;
@@ -629,8 +626,8 @@ static int ctrl_set_bitrate(struct bm2835_mmal_dev *dev,
 }
 
 static int ctrl_set_bitrate_mode(struct bm2835_mmal_dev *dev,
-		   struct v4l2_ctrl *ctrl,
-		   const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+				 struct v4l2_ctrl *ctrl,
+				 const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
 {
 	u32 bitrate_mode;
 	struct vchiq_mmal_port *encoder_out;
@@ -649,15 +646,15 @@ static int ctrl_set_bitrate_mode(struct bm2835_mmal_dev *dev,
 	}
 
 	vchiq_mmal_port_parameter_set(dev->instance, encoder_out,
-					     mmal_ctrl->mmal_id,
+				      mmal_ctrl->mmal_id,
 					     &bitrate_mode,
 					     sizeof(bitrate_mode));
 	return 0;
 }
 
 static int ctrl_set_image_encode_output(struct bm2835_mmal_dev *dev,
-		      struct v4l2_ctrl *ctrl,
-		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+					struct v4l2_ctrl *ctrl,
+					const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
 {
 	u32 u32_value;
 	struct vchiq_mmal_port *jpeg_out;
@@ -672,8 +669,8 @@ static int ctrl_set_image_encode_output(struct bm2835_mmal_dev *dev,
 }
 
 static int ctrl_set_video_encode_param_output(struct bm2835_mmal_dev *dev,
-		      struct v4l2_ctrl *ctrl,
-		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+					      struct v4l2_ctrl *ctrl,
+					      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
 {
 	u32 u32_value;
 	struct vchiq_mmal_port *vid_enc_ctl;
@@ -688,8 +685,8 @@ static int ctrl_set_video_encode_param_output(struct bm2835_mmal_dev *dev,
 }
 
 static int ctrl_set_video_encode_profile_level(struct bm2835_mmal_dev *dev,
-		      struct v4l2_ctrl *ctrl,
-		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+					       struct v4l2_ctrl *ctrl,
+					       const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
 {
 	struct mmal_parameter_video_profile param;
 	int ret = 0;
@@ -791,7 +788,7 @@ static int ctrl_set_video_encode_profile_level(struct bm2835_mmal_dev *dev,
 		}
 
 		ret = vchiq_mmal_port_parameter_set(dev->instance,
-			&dev->component[MMAL_COMPONENT_VIDEO_ENCODE]->output[0],
+						    &dev->component[MMAL_COMPONENT_VIDEO_ENCODE]->output[0],
 			mmal_ctrl->mmal_id,
 			&param, sizeof(param));
 	}
@@ -799,16 +796,16 @@ static int ctrl_set_video_encode_profile_level(struct bm2835_mmal_dev *dev,
 }
 
 static int ctrl_set_scene_mode(struct bm2835_mmal_dev *dev,
-		      struct v4l2_ctrl *ctrl,
-		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+			       struct v4l2_ctrl *ctrl,
+			       const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
 {
 	int ret = 0;
 	int shutter_speed;
 	struct vchiq_mmal_port *control;
 
 	v4l2_dbg(0, bcm2835_v4l2_debug, &dev->v4l2_dev,
-		"scene mode selected %d, was %d\n", ctrl->val,
-		dev->scene_mode);
+		 "scene mode selected %d, was %d\n", ctrl->val,
+		 dev->scene_mode);
 	control = &dev->component[MMAL_COMPONENT_CAMERA]->control;
 
 	if (ctrl->val == dev->scene_mode)
@@ -824,25 +821,25 @@ static int ctrl_set_scene_mode(struct bm2835_mmal_dev *dev,
 			shutter_speed = 0;
 
 		v4l2_dbg(0, bcm2835_v4l2_debug, &dev->v4l2_dev,
-			"%s: scene mode none: shut_speed %d, exp_mode %d, metering %d\n",
-			__func__, shutter_speed, dev->exposure_mode_user,
-			dev->metering_mode);
+			 "%s: scene mode none: shut_speed %d, exp_mode %d, metering %d\n",
+			 __func__, shutter_speed, dev->exposure_mode_user,
+			 dev->metering_mode);
 		ret = vchiq_mmal_port_parameter_set(dev->instance,
-					control,
-					MMAL_PARAMETER_SHUTTER_SPEED,
-					&shutter_speed,
-					sizeof(shutter_speed));
+						    control,
+						    MMAL_PARAMETER_SHUTTER_SPEED,
+						    &shutter_speed,
+						    sizeof(shutter_speed));
 		ret += vchiq_mmal_port_parameter_set(dev->instance,
-					control,
-					MMAL_PARAMETER_EXPOSURE_MODE,
-					&dev->exposure_mode_user,
-					sizeof(u32));
+						     control,
+						     MMAL_PARAMETER_EXPOSURE_MODE,
+						     &dev->exposure_mode_user,
+						     sizeof(u32));
 		dev->exposure_mode_active = dev->exposure_mode_user;
 		ret += vchiq_mmal_port_parameter_set(dev->instance,
-					control,
-					MMAL_PARAMETER_EXP_METERING_MODE,
-					&dev->metering_mode,
-					sizeof(u32));
+						     control,
+						     MMAL_PARAMETER_EXP_METERING_MODE,
+						     &dev->metering_mode,
+						     sizeof(u32));
 		ret += set_framerate_params(dev);
 	} else {
 		/* Set up scene mode */
@@ -875,33 +872,32 @@ static int ctrl_set_scene_mode(struct bm2835_mmal_dev *dev,
 		metering_mode = scene->metering_mode;
 
 		v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
-			"%s: scene mode none: shut_speed %d, exp_mode %d, metering %d\n",
-			__func__, shutter_speed, exposure_mode, metering_mode);
+			 "%s: scene mode none: shut_speed %d, exp_mode %d, metering %d\n",
+			 __func__, shutter_speed, exposure_mode, metering_mode);
 
 		ret = vchiq_mmal_port_parameter_set(dev->instance, control,
-					MMAL_PARAMETER_SHUTTER_SPEED,
-					&shutter_speed,
-					sizeof(shutter_speed));
-		ret += vchiq_mmal_port_parameter_set(dev->instance,
-					control,
-					MMAL_PARAMETER_EXPOSURE_MODE,
-					&exposure_mode,
-					sizeof(u32));
+						    MMAL_PARAMETER_SHUTTER_SPEED,
+						    &shutter_speed,
+						    sizeof(shutter_speed));
+		ret += vchiq_mmal_port_parameter_set(dev->instance, control,
+						     MMAL_PARAMETER_EXPOSURE_MODE,
+						     &exposure_mode,
+						     sizeof(u32));
 		dev->exposure_mode_active = exposure_mode;
 		ret += vchiq_mmal_port_parameter_set(dev->instance, control,
-					MMAL_PARAMETER_EXPOSURE_MODE,
-					&exposure_mode,
-					sizeof(u32));
+						     MMAL_PARAMETER_EXPOSURE_MODE,
+						     &exposure_mode,
+						     sizeof(u32));
 		ret += vchiq_mmal_port_parameter_set(dev->instance, control,
-					MMAL_PARAMETER_EXP_METERING_MODE,
-					&metering_mode,
-					sizeof(u32));
+						     MMAL_PARAMETER_EXP_METERING_MODE,
+						     &metering_mode,
+						     sizeof(u32));
 		ret += set_framerate_params(dev);
 	}
 	if (ret) {
 		v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
-			"%s: Setting scene to %d, ret=%d\n",
-			__func__, ctrl->val, ret);
+			 "%s: Setting scene to %d, ret=%d\n",
+			 __func__, ctrl->val, ret);
 		ret = -EINVAL;
 	}
 	return 0;
@@ -925,7 +921,7 @@ static int bm2835_mmal_s_ctrl(struct v4l2_ctrl *ctrl)
 	ret = mmal_ctrl->setter(dev, ctrl, mmal_ctrl);
 	if (ret)
 		pr_warn("ctrl id:%d/MMAL param %08X- returned ret %d\n",
-				ctrl->id, mmal_ctrl->mmal_id, ret);
+			ctrl->id, mmal_ctrl->mmal_id, ret);
 	if (mmal_ctrl->ignore_errors)
 		ret = 0;
 	return ret;
@@ -935,8 +931,6 @@ static const struct v4l2_ctrl_ops bm2835_mmal_ctrl_ops = {
 	.s_ctrl = bm2835_mmal_s_ctrl,
 };
 
-
-
 static const struct bm2835_mmal_v4l2_ctrl v4l2_ctrls[V4L2_CTRL_COUNT] = {
 	{
 		V4L2_CID_SATURATION, MMAL_CONTROL_TYPE_STD,
@@ -1005,7 +999,7 @@ static const struct bm2835_mmal_v4l2_ctrl v4l2_ctrls[V4L2_CTRL_COUNT] = {
 	{
 		V4L2_CID_EXPOSURE_ABSOLUTE, MMAL_CONTROL_TYPE_STD,
 		/* Units of 100usecs */
-		1, 1*1000*10, 100*10, 1, NULL,
+		1, 1 * 1000 * 10, 100 * 10, 1, NULL,
 		MMAL_PARAMETER_SHUTTER_SPEED,
 		&ctrl_set_exposure,
 		false
@@ -1013,7 +1007,7 @@ static const struct bm2835_mmal_v4l2_ctrl v4l2_ctrls[V4L2_CTRL_COUNT] = {
 	{
 		V4L2_CID_AUTO_EXPOSURE_BIAS, MMAL_CONTROL_TYPE_INT_MENU,
 		0, ARRAY_SIZE(ev_bias_qmenu) - 1,
-		(ARRAY_SIZE(ev_bias_qmenu)+1)/2 - 1, 0, ev_bias_qmenu,
+		(ARRAY_SIZE(ev_bias_qmenu) + 1) / 2 - 1, 0, ev_bias_qmenu,
 		MMAL_PARAMETER_EXPOSURE_COMP,
 		&ctrl_set_value_ev,
 		false
@@ -1101,7 +1095,7 @@ static const struct bm2835_mmal_v4l2_ctrl v4l2_ctrls[V4L2_CTRL_COUNT] = {
 	},
 	{
 		V4L2_CID_MPEG_VIDEO_BITRATE, MMAL_CONTROL_TYPE_STD,
-		25*1000, 25*1000*1000, 10*1000*1000, 25*1000, NULL,
+		25 * 1000, 25 * 1000 * 1000, 10 * 1000 * 1000, 25 * 1000, NULL,
 		MMAL_PARAMETER_VIDEO_BIT_RATE,
 		&ctrl_set_bitrate,
 		false
@@ -1192,8 +1186,8 @@ int bm2835_mmal_set_all_camera_controls(struct bm2835_mmal_dev *dev)
 						   &v4l2_ctrls[c]);
 			if (!v4l2_ctrls[c].ignore_errors && ret) {
 				v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
-					"Failed when setting default values for ctrl %d\n",
-					c);
+					 "Failed when setting default values for ctrl %d\n",
+					 c);
 				break;
 			}
 		}
@@ -1207,7 +1201,7 @@ int set_framerate_params(struct bm2835_mmal_dev *dev)
 	int ret;
 
 	if ((dev->exposure_mode_active != MMAL_PARAM_EXPOSUREMODE_OFF) &&
-	     (dev->exp_auto_priority)) {
+	    (dev->exp_auto_priority)) {
 		/* Variable FPS. Define min FPS as 1fps.
 		 * Max as max defined FPS.
 		 */
@@ -1224,35 +1218,32 @@ int set_framerate_params(struct bm2835_mmal_dev *dev)
 	}
 
 	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
-			 "Set fps range to %d/%d to %d/%d\n",
-			 fps_range.fps_low.num,
-			 fps_range.fps_low.den,
-			 fps_range.fps_high.num,
-			 fps_range.fps_high.den
-		 );
+		 "Set fps range to %d/%d to %d/%d\n",
+		 fps_range.fps_low.num,
+		 fps_range.fps_low.den,
+		 fps_range.fps_high.num,
+		 fps_range.fps_high.den);
 
 	ret = vchiq_mmal_port_parameter_set(dev->instance,
-				      &dev->component[MMAL_COMPONENT_CAMERA]->
-					output[MMAL_CAMERA_PORT_PREVIEW],
-				      MMAL_PARAMETER_FPS_RANGE,
-				      &fps_range, sizeof(fps_range));
+					    &dev->component[MMAL_COMPONENT_CAMERA]->
+					    output[MMAL_CAMERA_PORT_PREVIEW],
+					    MMAL_PARAMETER_FPS_RANGE,
+					    &fps_range, sizeof(fps_range));
 	ret += vchiq_mmal_port_parameter_set(dev->instance,
-				      &dev->component[MMAL_COMPONENT_CAMERA]->
-					output[MMAL_CAMERA_PORT_VIDEO],
-				      MMAL_PARAMETER_FPS_RANGE,
-				      &fps_range, sizeof(fps_range));
+					     &dev->component[MMAL_COMPONENT_CAMERA]->
+					     output[MMAL_CAMERA_PORT_VIDEO],
+					     MMAL_PARAMETER_FPS_RANGE,
+					     &fps_range, sizeof(fps_range));
 	ret += vchiq_mmal_port_parameter_set(dev->instance,
-				      &dev->component[MMAL_COMPONENT_CAMERA]->
-					output[MMAL_CAMERA_PORT_CAPTURE],
-				      MMAL_PARAMETER_FPS_RANGE,
-				      &fps_range, sizeof(fps_range));
+					     &dev->component[MMAL_COMPONENT_CAMERA]->
+					     output[MMAL_CAMERA_PORT_CAPTURE],
+					     MMAL_PARAMETER_FPS_RANGE,
+					     &fps_range, sizeof(fps_range));
 	if (ret)
 		v4l2_dbg(0, bcm2835_v4l2_debug, &dev->v4l2_dev,
-		 "Failed to set fps ret %d\n",
-		 ret);
+			 "Failed to set fps ret %d\n", ret);
 
 	return ret;
-
 }
 
 int bm2835_mmal_init_controls(struct bm2835_mmal_dev *dev,
@@ -1318,7 +1309,7 @@ int bm2835_mmal_init_controls(struct bm2835_mmal_dev *dev,
 
 	if (hdl->error) {
 		pr_err("error adding control %d/%d id 0x%x\n", c,
-			 V4L2_CTRL_COUNT, ctrl->id);
+		       V4L2_CTRL_COUNT, ctrl->id);
 		return hdl->error;
 	}
 
@@ -1328,7 +1319,7 @@ int bm2835_mmal_init_controls(struct bm2835_mmal_dev *dev,
 		switch (ctrl->type) {
 		case MMAL_CONTROL_TYPE_CLUSTER:
 			v4l2_ctrl_auto_cluster(ctrl->min,
-					       &dev->ctrls[c+1],
+					       &dev->ctrls[c + 1],
 					       ctrl->max,
 					       ctrl->def);
 			break;
@@ -1338,7 +1329,6 @@ int bm2835_mmal_init_controls(struct bm2835_mmal_dev *dev,
 		case MMAL_CONTROL_TYPE_INT_MENU:
 			break;
 		}
-
 	}
 
 	return 0;
diff --git a/drivers/staging/media/platform/bcm2835/mmal-vchiq.c b/drivers/staging/media/platform/bcm2835/mmal-vchiq.c
index 24bd2948136c..cc968442adc4 100644
--- a/drivers/staging/media/platform/bcm2835/mmal-vchiq.c
+++ b/drivers/staging/media/platform/bcm2835/mmal-vchiq.c
@@ -637,7 +637,6 @@ static void service_callback(void *param,
 
 		/* handling is different for buffer messages */
 		switch (msg->h.type) {
-
 		case MMAL_MSG_TYPE_BUFFER_FROM_HOST:
 			vchi_held_msg_release(&msg_handle);
 			break;
@@ -722,7 +721,7 @@ static int send_synchronous_mmal_msg(struct vchiq_mmal_instance *instance,
 	if (payload_len >
 	    (MMAL_MSG_MAX_SIZE - sizeof(struct mmal_msg_header))) {
 		pr_err("payload length %d exceeds max:%d\n", payload_len,
-			 (MMAL_MSG_MAX_SIZE - sizeof(struct mmal_msg_header)));
+		       (MMAL_MSG_MAX_SIZE - sizeof(struct mmal_msg_header)));
 		return -EINVAL;
 	}
 
@@ -749,7 +748,7 @@ static int send_synchronous_mmal_msg(struct vchiq_mmal_instance *instance,
 		return ret;
 	}
 
-	ret = wait_for_completion_timeout(&msg_context.u.sync.cmplt, 3*HZ);
+	ret = wait_for_completion_timeout(&msg_context.u.sync.cmplt, 3 * HZ);
 	if (ret <= 0) {
 		pr_err("error %d waiting for sync completion\n", ret);
 		if (ret == 0)
@@ -807,7 +806,6 @@ static void dump_port_info(struct vchiq_mmal_port *port)
 
 static void port_to_mmal_msg(struct vchiq_mmal_port *port, struct mmal_port *p)
 {
-
 	/* todo do readonly fields need setting at all? */
 	p->type = port->type;
 	p->index = port->index;
@@ -883,7 +881,6 @@ static int port_info_set(struct vchiq_mmal_instance *instance,
 	vchi_held_msg_release(&rmsg_handle);
 
 	return ret;
-
 }
 
 /* use port info get message to retrive port information */
@@ -1334,7 +1331,7 @@ static int port_parameter_get(struct vchiq_mmal_instance *instance,
 		       rmsg->u.port_parameter_get_reply.size);
 
 	pr_debug("%s:result:%d component:0x%x port:%d parameter:%d\n", __func__,
-	        ret, port->component->handle, port->handle, parameter_id);
+		 ret, port->component->handle, port->handle, parameter_id);
 
 release_msg:
 	vchi_held_msg_release(&rmsg_handle);
@@ -1358,12 +1355,12 @@ static int port_disable(struct vchiq_mmal_instance *instance,
 	ret = port_action_port(instance, port,
 			       MMAL_MSG_PORT_ACTION_TYPE_DISABLE);
 	if (ret == 0) {
-
 		/* drain all queued buffers on port */
 		spin_lock_irqsave(&port->slock, flags);
 
 		list_for_each_safe(buf_head, q, &port->buffers) {
 			struct mmal_buffer *mmalbuf;
+
 			mmalbuf = list_entry(buf_head, struct mmal_buffer,
 					     list);
 			list_del(buf_head);
@@ -1415,6 +1412,7 @@ static int port_enable(struct vchiq_mmal_instance *instance,
 		hdr_count = 1;
 		list_for_each(buf_head, &port->buffers) {
 			struct mmal_buffer *mmalbuf;
+
 			mmalbuf = list_entry(buf_head, struct mmal_buffer,
 					     list);
 			ret = buffer_from_host(instance, port, mmalbuf);
@@ -1456,7 +1454,6 @@ int vchiq_mmal_port_set_format(struct vchiq_mmal_instance *instance,
 	mutex_unlock(&instance->vchiq_mutex);
 
 	return ret;
-
 }
 
 int vchiq_mmal_port_parameter_set(struct vchiq_mmal_instance *instance,
-- 
2.11.0

