Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:36903 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbZHKVBb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2009 17:01:31 -0400
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com, hverkuil@xs4all.nl,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 1/4 - v2] V4L: vpfe capture driver - adding support for camera capture
Date: Tue, 11 Aug 2009 17:01:24 -0400
Message-Id: <1250024484-5059-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

This patch incorporated comments received against v1 patch series.

Following are the major comments incorporated:-
	1) retained vpfe_g_std() since for vbi support g_std handling in v4l2 framework
	   is not sufficient.
	2) rename name field in vpfe_subdev_info to module_name and camera to is_camera.
	   also grouped bit field variables

Additional features added on top v1 patch:-
	2) vpfe_enable/disable_clock restructered to allow configuration of required
	   clocks in vpfe_capture configuration. This is required for upcoming DM365
	   support.

Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to V4L-DVB linux-next repository
 drivers/media/video/davinci/vpfe_capture.c |  545 +++++++++++++++++++++-------
 include/media/davinci/vpfe_capture.h       |   30 ++-
 2 files changed, 436 insertions(+), 139 deletions(-)

diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index 402ce43..ff43446 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -59,10 +59,8 @@
  *    TODO list
  *		- Support multiple REQBUF after open
  *		- Support for de-allocating buffers through REQBUF
- *		- Support for Raw Bayer RGB capture
  *		- Support for chaining Image Processor
  *		- Support for static allocation of buffers
- *		- Support for USERPTR IO
  *		- Support for STREAMON before QBUF
  *		- Support for control ioctls
  */
@@ -79,11 +77,24 @@
 static int debug;
 static u32 numbuffers = 3;
 static u32 bufsize = (720 * 576 * 2);
+static int interface;
 
+module_param(interface, bool, S_IRUGO);
 module_param(numbuffers, uint, S_IRUGO);
 module_param(bufsize, uint, S_IRUGO);
-module_param(debug, int, 0644);
-
+module_param(debug, bool, 0644);
+
+/**
+ * VPFE capture can be used for capturing video such as from TVP5146 or TVP7002
+ * and for capture raw bayer data from camera sensors such as MT9T031. At this
+ * point there is problem in co-existence of mt9t031 and tvp5146 due to i2c
+ * address collision. So set the variable below from bootargs to do either video
+ * capture or camera capture.
+ * interface = 0 - video capture (from TVP514x or such),
+ * interface = 1 - Camera capture (from MT9T031 or such)
+ * Re-visit this when we fix the co-existence issue
+ */
+MODULE_PARM_DESC(interface, "interface 0-1 (default:0)");
 MODULE_PARM_DESC(numbuffers, "buffer count (default:3)");
 MODULE_PARM_DESC(bufsize, "buffer size in bytes (default:720 x 576 x 2)");
 MODULE_PARM_DESC(debug, "Debug level 0-1");
@@ -143,6 +154,7 @@ static const struct vpfe_pixel_format vpfe_pix_fmts[] = {
 			.pixelformat = V4L2_PIX_FMT_SBGGR8,
 		},
 		.bpp = 1,
+		.subdev_pix_fmt = V4L2_PIX_FMT_SGRBG10,
 	},
 	{
 		.fmtdesc = {
@@ -152,6 +164,7 @@ static const struct vpfe_pixel_format vpfe_pix_fmts[] = {
 			.pixelformat = V4L2_PIX_FMT_SBGGR16,
 		},
 		.bpp = 2,
+		.subdev_pix_fmt = V4L2_PIX_FMT_SGRBG10,
 	},
 	{
 		.fmtdesc = {
@@ -161,6 +174,7 @@ static const struct vpfe_pixel_format vpfe_pix_fmts[] = {
 			.pixelformat = V4L2_PIX_FMT_SGRBG10DPCM8,
 		},
 		.bpp = 1,
+		.subdev_pix_fmt = V4L2_PIX_FMT_SGRBG10,
 	},
 	{
 		.fmtdesc = {
@@ -170,6 +184,7 @@ static const struct vpfe_pixel_format vpfe_pix_fmts[] = {
 			.pixelformat = V4L2_PIX_FMT_UYVY,
 		},
 		.bpp = 2,
+		.subdev_pix_fmt = V4L2_PIX_FMT_UYVY,
 	},
 	{
 		.fmtdesc = {
@@ -179,6 +194,7 @@ static const struct vpfe_pixel_format vpfe_pix_fmts[] = {
 			.pixelformat = V4L2_PIX_FMT_YUYV,
 		},
 		.bpp = 2,
+		.subdev_pix_fmt = V4L2_PIX_FMT_UYVY,
 	},
 	{
 		.fmtdesc = {
@@ -188,12 +204,15 @@ static const struct vpfe_pixel_format vpfe_pix_fmts[] = {
 			.pixelformat = V4L2_PIX_FMT_NV12,
 		},
 		.bpp = 1,
+		.subdev_pix_fmt = V4L2_PIX_FMT_UYVY,
 	},
 };
 
-/*
- * vpfe_lookup_pix_format()
- * lookup an entry in the vpfe pix format table based on pix_format
+/**
+ * vpfe_lookup_pix_format() - lookup an entry in the vpfe pix format table
+ * @pix_format: v4l pix format
+ * This function lookup an entry in the vpfe pix format table based on
+ * pix_format
  */
 static const struct vpfe_pixel_format *vpfe_lookup_pix_format(u32 pix_format)
 {
@@ -241,19 +260,19 @@ int vpfe_register_ccdc_device(struct ccdc_hw_device *dev)
 		 * walk through it during vpfe probe
 		 */
 		printk(KERN_ERR "vpfe capture not initialized\n");
-		ret = -1;
+		ret = -EFAULT;
 		goto unlock;
 	}
 
 	if (strcmp(dev->name, ccdc_cfg->name)) {
 		/* ignore this ccdc */
-		ret = -1;
+		ret = -EINVAL;
 		goto unlock;
 	}
 
 	if (ccdc_dev) {
 		printk(KERN_ERR "ccdc already registered\n");
-		ret = -1;
+		ret = -EINVAL;
 		goto unlock;
 	}
 
@@ -293,6 +312,45 @@ void vpfe_unregister_ccdc_device(struct ccdc_hw_device *dev)
 EXPORT_SYMBOL(vpfe_unregister_ccdc_device);
 
 /*
+ * vpfe_get_camera_frame_params()
+ * Get the image parameters such as max height and width, frame format
+ * etc and update the stdinfo accordingly. This is a work around to get
+ * the maximum width, height and frame format since camera driver doesn't
+ * support s_std.
+ */
+static int vpfe_get_camera_frame_params(struct vpfe_device *vpfe_dev)
+{
+	struct vpfe_subdev_info *sdinfo = vpfe_dev->current_subdev;
+	struct v4l2_format sd_fmt;
+	int ret;
+
+	/* TODO: Currently there is no support for setting timings
+	 * in sensor similar to S_STD. So get the limits of width and height
+	 * using try format. In future we should be able to set
+	 * timings for a specific resolution and fps. In that case
+	 * we know the limits for the specific timing and this code
+	 * would require change.
+	 */
+	memset(&sd_fmt, 0, sizeof(sd_fmt));
+	sd_fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	/* hard code it to match that of mt9t031 sensor */
+	sd_fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_SGRBG10;
+	/* use a value big enough */
+	sd_fmt.fmt.pix.width = 1 << 31;
+	sd_fmt.fmt.pix.height = 1 << 31;
+	ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev,
+			sdinfo->grp_id, video, try_fmt, &sd_fmt);
+
+	if (!ret) {
+		vpfe_dev->std_info.active_pixels = sd_fmt.fmt.pix.width;
+		vpfe_dev->std_info.active_lines = sd_fmt.fmt.pix.height;
+		/* hard code the frame format to be progressive always.  */
+		vpfe_dev->std_info.frame_format = 0;
+	}
+	return ret;
+}
+
+/*
  * vpfe_get_ccdc_image_format - Get image parameters based on CCDC settings
  */
 static int vpfe_get_ccdc_image_format(struct vpfe_device *vpfe_dev,
@@ -302,9 +360,13 @@ static int vpfe_get_ccdc_image_format(struct vpfe_device *vpfe_dev,
 	enum ccdc_buftype buf_type;
 	enum ccdc_frmfmt frm_fmt;
 
+	vpfe_dev->crop.top = 0;
+	vpfe_dev->crop.left = 0;
 	memset(f, 0, sizeof(*f));
 	f->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
 	ccdc_dev->hw_ops.get_image_window(&image_win);
+	vpfe_dev->crop.width = image_win.width;
+	vpfe_dev->crop.height = image_win.height;
 	f->fmt.pix.width = image_win.width;
 	f->fmt.pix.height = image_win.height;
 	f->fmt.pix.bytesperline = ccdc_dev->hw_ops.get_line_length();
@@ -386,8 +448,10 @@ static int vpfe_config_image_format(struct vpfe_device *vpfe_dev,
 				    const v4l2_std_id *std_id)
 {
 	struct vpfe_subdev_info *sdinfo = vpfe_dev->current_subdev;
+	struct v4l2_format sd_fmt;
 	int i, ret = 0;
 
+	/* configure the ccdc based on standard */
 	for (i = 0; i < ARRAY_SIZE(vpfe_standards); i++) {
 		if (vpfe_standards[i].std_id & *std_id) {
 			vpfe_dev->std_info.active_pixels =
@@ -424,16 +488,17 @@ static int vpfe_config_image_format(struct vpfe_device *vpfe_dev,
 		vpfe_dev->fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_SBGGR8;
 	}
 
+	sd_fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	/* if sub device supports g_fmt, override the defaults */
 	ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev,
-			sdinfo->grp_id, video, g_fmt, &vpfe_dev->fmt);
+			sdinfo->grp_id, video, g_fmt, &sd_fmt);
 
 	if (ret && ret != -ENOIOCTLCMD) {
 		v4l2_err(&vpfe_dev->v4l2_dev,
 			"error in getting g_fmt from sub device\n");
 		return ret;
 	}
-
+	vpfe_dev->fmt = sd_fmt;
 	/* Sets the values in CCDC */
 	ret = vpfe_config_ccdc_image_format(vpfe_dev);
 	if (ret)
@@ -456,13 +521,29 @@ static int vpfe_initialize_device(struct vpfe_device *vpfe_dev)
 
 	/* set first input of current subdevice as the current input */
 	vpfe_dev->current_input = 0;
+	/*
+	 * set default standard. For camera device, we cannot set standard.
+	 * So we set it to -1. Otherwise, first entry in the standard is the
+	 * is the default
+	 */
+	if (vpfe_dev->current_subdev->is_camera) {
+		vpfe_dev->std_index = -1;
+		/*
+		 * Configure the vpfe default format information based on ccdc
+		 * defaults
+		 */
+		ret = vpfe_get_ccdc_image_format(vpfe_dev, &vpfe_dev->fmt);
+		/* Get max width and height available for capture from camera */
+		if (!ret)
+			ret = vpfe_get_camera_frame_params(vpfe_dev);
 
-	/* set default standard */
-	vpfe_dev->std_index = 0;
-
-	/* Configure the default format information */
-	ret = vpfe_config_image_format(vpfe_dev,
+	} else {
+		vpfe_dev->std_index = 0;
+		/* Configure the default format information */
+		ret = vpfe_config_image_format(vpfe_dev,
 				&vpfe_standards[vpfe_dev->std_index].std_id);
+	}
+
 	if (ret)
 		return ret;
 
@@ -540,7 +621,22 @@ static void vpfe_schedule_next_buffer(struct vpfe_device *vpfe_dev)
 					struct videobuf_buffer, queue);
 	list_del(&vpfe_dev->next_frm->queue);
 	vpfe_dev->next_frm->state = VIDEOBUF_ACTIVE;
-	addr = videobuf_to_dma_contig(vpfe_dev->next_frm);
+	if (V4L2_MEMORY_USERPTR == vpfe_dev->memory)
+		addr = vpfe_dev->cur_frm->boff;
+	else
+		addr = videobuf_to_dma_contig(vpfe_dev->next_frm);
+	ccdc_dev->hw_ops.setfbaddr(addr);
+}
+
+static void vpfe_schedule_bottom_field(struct vpfe_device *vpfe_dev)
+{
+	unsigned long addr;
+
+	if (V4L2_MEMORY_USERPTR == vpfe_dev->memory)
+		addr = vpfe_dev->cur_frm->boff;
+	else
+		addr = videobuf_to_dma_contig(vpfe_dev->cur_frm);
+	addr += vpfe_dev->field_off;
 	ccdc_dev->hw_ops.setfbaddr(addr);
 }
 
@@ -561,7 +657,6 @@ static irqreturn_t vpfe_isr(int irq, void *dev_id)
 {
 	struct vpfe_device *vpfe_dev = dev_id;
 	enum v4l2_field field;
-	unsigned long addr;
 	int fid;
 
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "\nStarting vpfe_isr...\n");
@@ -605,12 +700,9 @@ static irqreturn_t vpfe_isr(int irq, void *dev_id)
 			 * interleavely or separately in memory, reconfigure
 			 * the CCDC memory address
 			 */
-			if (field == V4L2_FIELD_SEQ_TB) {
-				addr =
-				  videobuf_to_dma_contig(vpfe_dev->cur_frm);
-				addr += vpfe_dev->field_off;
-				ccdc_dev->hw_ops.setfbaddr(addr);
-			}
+			if (field == V4L2_FIELD_SEQ_TB)
+				vpfe_schedule_bottom_field(vpfe_dev);
+
 			return IRQ_HANDLED;
 		}
 		/*
@@ -709,7 +801,7 @@ static int vpfe_release(struct file *file)
 							 video, s_stream, 0);
 			if (ret && (ret != -ENOIOCTLCMD))
 				v4l2_err(&vpfe_dev->v4l2_dev,
-				"stream off failed in subdev\n");
+					 "stream off failed in subdev\n");
 			vpfe_stop_ccdc_capture(vpfe_dev);
 			vpfe_detach_irq(vpfe_dev);
 			videobuf_streamoff(&vpfe_dev->buffer_queue);
@@ -960,6 +1052,8 @@ static int vpfe_s_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct vpfe_device *vpfe_dev = video_drvdata(file);
 	const struct vpfe_pixel_format *pix_fmts;
+	struct vpfe_subdev_info *sdinfo;
+	struct v4l2_format sd_fmt;
 	int ret = 0;
 
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_s_fmt_vid_cap\n");
@@ -981,11 +1075,31 @@ static int vpfe_s_fmt_vid_cap(struct file *file, void *priv,
 	if (ret)
 		return ret;
 
-	/* First detach any IRQ if currently attached */
-	vpfe_detach_irq(vpfe_dev);
-	vpfe_dev->fmt = *fmt;
-	/* set image capture parameters in the ccdc */
-	ret = vpfe_config_ccdc_image_format(vpfe_dev);
+	sdinfo = vpfe_dev->current_subdev;
+	if (sdinfo->is_camera) {
+		/*
+		 * Current implementation of camera sub device calculates
+		 * sensor timing values based on S_FMT. So we need to
+		 * explicitely call S_FMT first and make sure it succeeds before
+		 * setting capture parameters in ccdc
+		 */
+		sd_fmt = *fmt;
+		sd_fmt.fmt.pix.pixelformat = pix_fmts->subdev_pix_fmt;
+		ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev,
+						 sdinfo->grp_id,
+						 video, s_fmt, &sd_fmt);
+
+		if (!ret) {
+			vpfe_dev->crop.width = fmt->fmt.pix.width;
+			vpfe_dev->crop.height = fmt->fmt.pix.height;
+		}
+	}
+
+	if (!ret) {
+		vpfe_dev->fmt = *fmt;
+		/* set image capture parameters in the ccdc */
+		ret = vpfe_config_ccdc_image_format(vpfe_dev);
+	}
 	mutex_unlock(&vpfe_dev->lock);
 	return ret;
 }
@@ -1043,9 +1157,10 @@ static int vpfe_get_app_input_index(struct vpfe_device *vpfe_dev,
 
 	for (i = 0; i < cfg->num_subdevs; i++) {
 		sdinfo = &cfg->sub_devs[i];
-		if (!strcmp(sdinfo->name, vpfe_dev->current_subdev->name)) {
+		if (!strcmp(sdinfo->module_name,
+		     vpfe_dev->current_subdev->module_name)) {
 			if (vpfe_dev->current_input >= sdinfo->num_inputs)
-				return -1;
+				return -EINVAL;
 			*app_input_index = j + vpfe_dev->current_input;
 			return 0;
 		}
@@ -1059,10 +1174,11 @@ static int vpfe_enum_input(struct file *file, void *priv,
 {
 	struct vpfe_device *vpfe_dev = video_drvdata(file);
 	struct vpfe_subdev_info *sdinfo;
-	int subdev, index ;
+	int subdev, index, temp_index;
 
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_enum_input\n");
 
+	temp_index = inp->index;
 	if (vpfe_get_subdev_input_index(vpfe_dev,
 					&subdev,
 					&index,
@@ -1073,6 +1189,7 @@ static int vpfe_enum_input(struct file *file, void *priv,
 	}
 	sdinfo = &vpfe_dev->cfg->sub_devs[subdev];
 	memcpy(inp, &sdinfo->inputs[index], sizeof(struct v4l2_input));
+	inp->index = temp_index;
 	return 0;
 }
 
@@ -1090,7 +1207,7 @@ static int vpfe_s_input(struct file *file, void *priv, unsigned int index)
 {
 	struct vpfe_device *vpfe_dev = video_drvdata(file);
 	struct vpfe_subdev_info *sdinfo;
-	int subdev_index, inp_index;
+	int subdev_index, subdev_inp_index;
 	struct vpfe_route *route;
 	u32 input = 0, output = 0;
 	int ret = -EINVAL;
@@ -1113,31 +1230,48 @@ static int vpfe_s_input(struct file *file, void *priv, unsigned int index)
 
 	if (vpfe_get_subdev_input_index(vpfe_dev,
 					&subdev_index,
-					&inp_index,
+					&subdev_inp_index,
 					index) < 0) {
 		v4l2_err(&vpfe_dev->v4l2_dev, "invalid input index\n");
 		goto unlock_out;
 	}
 
 	sdinfo = &vpfe_dev->cfg->sub_devs[subdev_index];
-	route = &sdinfo->routes[inp_index];
+
+	if (!sdinfo->registered) {
+		ret = -EINVAL;
+		goto unlock_out;
+	}
+
+	if (vpfe_dev->cfg->setup_input) {
+		if (vpfe_dev->cfg->setup_input(sdinfo->grp_id) < 0) {
+			ret = -EFAULT;
+			v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
+				 "couldn't setup input for %s\n",
+				 sdinfo->module_name);
+			goto unlock_out;
+		}
+	}
+
+	route = &sdinfo->routes[subdev_inp_index];
 	if (route && sdinfo->can_route) {
 		input = route->input;
 		output = route->output;
-	}
+		ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev,
+						 sdinfo->grp_id, video,
+						 s_routing, input, output, 0);
 
-	ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo->grp_id,
-					 video, s_routing, input, output, 0);
-
-	if (ret) {
-		v4l2_err(&vpfe_dev->v4l2_dev,
-			"vpfe_doioctl:error in setting input in decoder\n");
-		ret = -EINVAL;
-		goto unlock_out;
+		if (ret) {
+			v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
+				"vpfe_doioctl:error in setting input in"
+				" decoder \n");
+			ret = -EINVAL;
+			goto unlock_out;
+		}
 	}
+
 	vpfe_dev->current_subdev = sdinfo;
-	vpfe_dev->current_input = index;
-	vpfe_dev->std_index = 0;
+	vpfe_dev->current_input = subdev_inp_index;
 
 	/* set the bus/interface parameter for the sub device in ccdc */
 	ret = ccdc_dev->hw_ops.set_hw_if_params(&sdinfo->ccdc_if_params);
@@ -1145,8 +1279,22 @@ static int vpfe_s_input(struct file *file, void *priv, unsigned int index)
 		goto unlock_out;
 
 	/* set the default image parameters in the device */
-	ret = vpfe_config_image_format(vpfe_dev,
+	if (vpfe_dev->current_subdev->is_camera)
+		vpfe_dev->std_index = -1;
+		/* for camera, use ccdc default parameters */
+		ret = vpfe_get_ccdc_image_format(vpfe_dev, &vpfe_dev->fmt);
+		/* Get max width and height available for capture from camera */
+		if (!ret)
+			ret = vpfe_get_camera_frame_params(vpfe_dev);
+	else {
+		vpfe_dev->std_index = 0;
+		/*
+		 * For non-camera sub device, use standard to configure vpfe
+		 * default
+		 */
+		ret = vpfe_config_image_format(vpfe_dev,
 				&vpfe_standards[vpfe_dev->std_index].std_id);
+	}
 unlock_out:
 	mutex_unlock(&vpfe_dev->lock);
 	return ret;
@@ -1211,9 +1359,15 @@ static int vpfe_g_std(struct file *file, void *priv, v4l2_std_id *std_id)
 
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_g_std\n");
 
+	if (vpfe_dev->std_index < 0 ||
+	    vpfe_dev->std_index >= ARRAY_SIZE(vpfe_standards)) {
+		v4l2_err(&vpfe_dev->v4l2_dev, "Standard not supported\n");
+		return -EINVAL;
+	}
 	*std_id = vpfe_standards[vpfe_dev->std_index].std_id;
 	return 0;
 }
+
 /*
  *  Videobuf operations
  */
@@ -1225,15 +1379,65 @@ static int vpfe_videobuf_setup(struct videobuf_queue *vq,
 	struct vpfe_device *vpfe_dev = fh->vpfe_dev;
 
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_buffer_setup\n");
-	*size = config_params.device_bufsize;
+
+	/*
+	 * if we are using mmap, check the size of the allocated buffer is less
+	 * than or equal to the maximum specified in the driver. Assume here the
+	 * user has called S_FMT and sizeimage has been calculated.
+	 */
+	*size = vpfe_dev->fmt.fmt.pix.sizeimage;
+	if (vpfe_dev->memory == V4L2_MEMORY_MMAP &&
+	    vpfe_dev->fmt.fmt.pix.sizeimage > config_params.device_bufsize)
+		*size = config_params.device_bufsize;
 
 	if (*count < config_params.min_numbuffers)
 		*count = config_params.min_numbuffers;
+
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
 		"count=%d, size=%d\n", *count, *size);
 	return 0;
 }
 
+/*
+ * vpfe_uservirt_to_phys: This function is used to convert user
+ * space virtual address to physical address.
+ */
+static u32 vpfe_uservirt_to_phys(struct vpfe_device *vpfe_dev, u32 virtp)
+{
+	struct mm_struct *mm = current->mm;
+	unsigned long physp = 0;
+	struct vm_area_struct *vma;
+
+	vma = find_vma(mm, virtp);
+
+	/* For kernel direct-mapped memory, take the easy way */
+	if (virtp >= PAGE_OFFSET)
+		physp = virt_to_phys((void *)virtp);
+	else if (vma && (vma->vm_flags & VM_IO) && (vma->vm_pgoff))
+		/* this will catch, kernel-allocated, mmaped-to-usermode addr */
+		physp = (vma->vm_pgoff << PAGE_SHIFT) + (virtp - vma->vm_start);
+	else {
+		/* otherwise, use get_user_pages() for general userland pages */
+		int res, nr_pages = 1;
+		struct page *pages;
+		down_read(&current->mm->mmap_sem);
+
+		res = get_user_pages(current, current->mm,
+				     virtp, nr_pages, 1, 0, &pages, NULL);
+		up_read(&current->mm->mmap_sem);
+
+		if (res == nr_pages)
+			physp = __pa(page_address(&pages[0]) +
+				     (virtp & ~PAGE_MASK));
+		else {
+			v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
+				"get_user_pages failed\n");
+			return 0;
+		}
+	}
+	return physp;
+}
+
 static int vpfe_videobuf_prepare(struct videobuf_queue *vq,
 				struct videobuf_buffer *vb,
 				enum v4l2_field field)
@@ -1250,6 +1454,18 @@ static int vpfe_videobuf_prepare(struct videobuf_queue *vq,
 		vb->size = vpfe_dev->fmt.fmt.pix.sizeimage;
 		vb->field = field;
 	}
+
+	if (V4L2_MEMORY_USERPTR == vpfe_dev->memory) {
+		if (!vb->baddr) {
+			v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
+				"buffer address is 0\n");
+			return -EINVAL;
+		}
+		vb->boff = vpfe_uservirt_to_phys(vpfe_dev, vb->baddr);
+		/* Make sure user addresses are aligned to 32 bytes */
+		if (!ALIGN(vb->boff, 32))
+			return -EINVAL;
+	}
 	vb->state = VIDEOBUF_PREPARED;
 	return 0;
 }
@@ -1318,13 +1534,6 @@ static int vpfe_reqbufs(struct file *file, void *priv,
 		return -EINVAL;
 	}
 
-	if (V4L2_MEMORY_USERPTR == req_buf->memory) {
-		/* we don't support user ptr IO */
-		v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_reqbufs:"
-			 " USERPTR IO not supported\n");
-		return  -EINVAL;
-	}
-
 	ret = mutex_lock_interruptible(&vpfe_dev->lock);
 	if (ret)
 		return ret;
@@ -1497,7 +1706,10 @@ static int vpfe_streamon(struct file *file, void *priv,
 	vpfe_dev->cur_frm->state = VIDEOBUF_ACTIVE;
 	/* Initialize field_id and started member */
 	vpfe_dev->field_id = 0;
-	addr = videobuf_to_dma_contig(vpfe_dev->cur_frm);
+	if (V4L2_MEMORY_USERPTR == vpfe_dev->memory)
+		addr = vpfe_dev->cur_frm->boff;
+	else
+		addr = videobuf_to_dma_contig(vpfe_dev->cur_frm);
 
 	/* Calculate field offset */
 	vpfe_calculate_offsets(vpfe_dev);
@@ -1574,19 +1786,36 @@ static int vpfe_cropcap(struct file *file, void *priv,
 			      struct v4l2_cropcap *crop)
 {
 	struct vpfe_device *vpfe_dev = video_drvdata(file);
+	struct vpfe_subdev_info *sdinfo;
 
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_cropcap\n");
 
-	if (vpfe_dev->std_index > ARRAY_SIZE(vpfe_standards))
-		return -EINVAL;
-
 	memset(crop, 0, sizeof(struct v4l2_cropcap));
 	crop->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	crop->bounds.width = crop->defrect.width =
-		vpfe_standards[vpfe_dev->std_index].width;
-	crop->bounds.height = crop->defrect.height =
-		vpfe_standards[vpfe_dev->std_index].height;
-	crop->pixelaspect = vpfe_standards[vpfe_dev->std_index].pixelaspect;
+	sdinfo = vpfe_dev->current_subdev;
+
+	if (!sdinfo->is_camera) {
+
+		if (vpfe_dev->std_index < 0 ||
+		    vpfe_dev->std_index >= ARRAY_SIZE(vpfe_standards))
+			return -EINVAL;
+
+		crop->bounds.width = vpfe_standards[vpfe_dev->std_index].width;
+		crop->defrect.width = crop->bounds.width;
+		crop->bounds.height =
+			vpfe_standards[vpfe_dev->std_index].height;
+		crop->defrect.height = crop->bounds.height;
+		crop->pixelaspect =
+			vpfe_standards[vpfe_dev->std_index].pixelaspect;
+	} else {
+		/* camera interface */
+		crop->bounds.width = vpfe_dev->std_info.active_pixels;
+		crop->defrect.width = crop->bounds.width;
+		crop->bounds.height = vpfe_dev->std_info.active_lines;
+		crop->defrect.height = crop->bounds.height;
+		crop->pixelaspect.numerator = 1;
+		crop->pixelaspect.denominator = 1;
+	}
 	return 0;
 }
 
@@ -1752,62 +1981,83 @@ static struct vpfe_device *vpfe_initialize(void)
 static void vpfe_disable_clock(struct vpfe_device *vpfe_dev)
 {
 	struct vpfe_config *vpfe_cfg = vpfe_dev->cfg;
+	int i;
 
-	clk_disable(vpfe_cfg->vpssclk);
-	clk_put(vpfe_cfg->vpssclk);
-	clk_disable(vpfe_cfg->slaveclk);
-	clk_put(vpfe_cfg->slaveclk);
-	v4l2_info(vpfe_dev->pdev->driver,
-		 "vpfe vpss master & slave clocks disabled\n");
+	for (i = 0; i < vpfe_cfg->num_clocks; i++) {
+		clk_disable(vpfe_dev->clks[i]);
+		clk_put(vpfe_dev->clks[i]);
+	}
+	kfree(vpfe_dev->clks);
+	v4l2_info(vpfe_dev->pdev->driver, "vpfe capture clocks disabled\n");
 }
 
+/**
+ * vpfe_enable_clock() - Enable clocks for vpfe capture driver
+ * @vpfe_dev - ptr to vpfe capture device
+ *
+ * Enables clocks defined in vpfe configuration. The function
+ * assumes that at least one clock is to be defined which is
+ * true as of now. re-visit this if this assumption is not true
+ */
 static int vpfe_enable_clock(struct vpfe_device *vpfe_dev)
 {
 	struct vpfe_config *vpfe_cfg = vpfe_dev->cfg;
-	int ret = -ENOENT;
+	int ret = -EFAULT, i;
 
-	vpfe_cfg->vpssclk = clk_get(vpfe_dev->pdev, "vpss_master");
-	if (NULL == vpfe_cfg->vpssclk) {
-		v4l2_err(vpfe_dev->pdev->driver, "No clock defined for"
-			 "vpss_master\n");
-		return ret;
-	}
+	if (!vpfe_cfg->num_clocks)
+		return 0;
 
-	if (clk_enable(vpfe_cfg->vpssclk)) {
-		v4l2_err(vpfe_dev->pdev->driver,
-			"vpfe vpss master clock not enabled\n");
-		goto out;
-	}
-	v4l2_info(vpfe_dev->pdev->driver,
-		 "vpfe vpss master clock enabled\n");
+	vpfe_dev->clks = kzalloc(vpfe_cfg->num_clocks *
+				   sizeof(struct clock *), GFP_KERNEL);
 
-	vpfe_cfg->slaveclk = clk_get(vpfe_dev->pdev, "vpss_slave");
-	if (NULL == vpfe_cfg->slaveclk) {
-		v4l2_err(vpfe_dev->pdev->driver,
-			"No clock defined for vpss slave\n");
-		goto out;
+	if (NULL == vpfe_dev->clks) {
+		v4l2_err(vpfe_dev->pdev->driver, "Memory allocation failed\n");
+		return -ENOMEM;
 	}
 
-	if (clk_enable(vpfe_cfg->slaveclk)) {
-		v4l2_err(vpfe_dev->pdev->driver,
-			 "vpfe vpss slave clock not enabled\n");
-		goto out;
+	for (i = 0; i < vpfe_cfg->num_clocks; i++) {
+		if (NULL == vpfe_cfg->clocks[i]) {
+			v4l2_err(vpfe_dev->pdev->driver,
+				"clock %s is not defined in vpfe config\n",
+				vpfe_cfg->clocks[i]);
+			goto out;
+		}
+
+		vpfe_dev->clks[i] = clk_get(vpfe_dev->pdev,
+					      vpfe_cfg->clocks[i]);
+		if (NULL == vpfe_dev->clks[i]) {
+			v4l2_err(vpfe_dev->pdev->driver,
+				"Failed to get clock %s\n",
+				vpfe_cfg->clocks[i]);
+			goto out;
+		}
+
+		if (clk_enable(vpfe_dev->clks[i])) {
+			v4l2_err(vpfe_dev->pdev->driver,
+				"vpfe clock %s not enabled\n",
+				vpfe_cfg->clocks[i]);
+			goto out;
+		}
+
+		v4l2_info(vpfe_dev->pdev->driver, "vpss clock %s enabled",
+			  vpfe_cfg->clocks[i]);
 	}
-	v4l2_info(vpfe_dev->pdev->driver, "vpfe vpss slave clock enabled\n");
 	return 0;
 out:
-	if (vpfe_cfg->vpssclk)
-		clk_put(vpfe_cfg->vpssclk);
-	if (vpfe_cfg->slaveclk)
-		clk_put(vpfe_cfg->slaveclk);
-
-	return -1;
+	for (i = 0; i < vpfe_cfg->num_clocks; i++) {
+		if (vpfe_dev->clks[i])
+			clk_put(vpfe_dev->clks[i]);
+	}
+	kfree(vpfe_dev->clks);
+	return ret;
 }
 
-/*
- * vpfe_probe : This function creates device entries by register
- * itself to the V4L2 driver and initializes fields of each
- * device objects
+/**
+ * vpfe_probe : vpfe probe function
+ * @pdev: platform device pointer
+ *
+ * This function creates device entries by register itself to the V4L2 driver
+ * and initializes fields of each device objects
  */
 static __init int vpfe_probe(struct platform_device *pdev)
 {
@@ -1931,7 +2181,7 @@ static __init int vpfe_probe(struct platform_device *pdev)
 	vfd->ioctl_ops		= &vpfe_ioctl_ops;
 	vfd->minor		= -1;
 	vfd->tvnorms		= 0;
-	vfd->current_norm	= V4L2_STD_PAL;
+	vfd->current_norm	= V4L2_STD_NTSC;
 	vfd->v4l2_dev 		= &vpfe_dev->v4l2_dev;
 	snprintf(vfd->name, sizeof(vfd->name),
 		 "%s_V%d.%d.%d",
@@ -1994,34 +2244,65 @@ static __init int vpfe_probe(struct platform_device *pdev)
 		struct v4l2_input *inps;
 
 		sdinfo = &vpfe_cfg->sub_devs[i];
-
-		/* Load up the subdevice */
-		vpfe_dev->sd[i] =
-			v4l2_i2c_new_subdev_board(&vpfe_dev->v4l2_dev,
-						  i2c_adap,
-						  sdinfo->name,
-						  &sdinfo->board_info,
-						  NULL);
-		if (vpfe_dev->sd[i]) {
-			v4l2_info(&vpfe_dev->v4l2_dev,
-				  "v4l2 sub device %s registered\n",
-				  sdinfo->name);
-			vpfe_dev->sd[i]->grp_id = sdinfo->grp_id;
-			/* update tvnorms from the sub devices */
-			for (j = 0; j < sdinfo->num_inputs; j++) {
-				inps = &sdinfo->inputs[j];
-				vfd->tvnorms |= inps->std;
+		/**
+		 * register subdevices based on interface setting. Currently
+		 * tvp5146 and mt9t031 cannot co-exists due to i2c address
+		 * conflicts. So only one of them is registered. Re-visit this
+		 * once we have support for i2c switch handling in i2c driver
+		 * framework
+		 */
+		if (interface == sdinfo->is_camera) {
+			/* setup input path */
+			if (vpfe_cfg->setup_input) {
+				if (vpfe_cfg->setup_input(sdinfo->grp_id) < 0) {
+					ret = -EFAULT;
+					v4l2_info(&vpfe_dev->v4l2_dev, "could"
+						  " not setup input for %s\n",
+						  sdinfo->module_name);
+					goto probe_sd_out;
+				}
+			}
+			/* Load up the subdevice */
+			vpfe_dev->sd[i] =
+				v4l2_i2c_new_subdev_board(&vpfe_dev->v4l2_dev,
+							  i2c_adap,
+							  sdinfo->module_name,
+							  &sdinfo->board_info,
+							  NULL);
+			if (vpfe_dev->sd[i]) {
+				v4l2_info(&vpfe_dev->v4l2_dev,
+					  "v4l2 sub device %s registered\n",
+					  sdinfo->module_name);
+				vpfe_dev->sd[i]->grp_id = sdinfo->grp_id;
+				/* update tvnorms from the sub devices */
+				for (j = 0; j < sdinfo->num_inputs; j++) {
+					inps = &sdinfo->inputs[j];
+					vfd->tvnorms |= inps->std;
+				}
+				sdinfo->registered = 1;
+			} else {
+				v4l2_info(&vpfe_dev->v4l2_dev,
+					  "v4l2 sub device %s register fails\n",
+					  sdinfo->module_name);
 			}
-		} else {
-			v4l2_info(&vpfe_dev->v4l2_dev,
-				  "v4l2 sub device %s register fails\n",
-				  sdinfo->name);
-			goto probe_sd_out;
 		}
 	}
 
-	/* set first sub device as current one */
-	vpfe_dev->current_subdev = &vpfe_cfg->sub_devs[0];
+	/* We need at least one sub device to do capture */
+	for (i = 0; i < num_subdevs; i++) {
+		sdinfo = &vpfe_cfg->sub_devs[i];
+		if (sdinfo->registered) {
+			/* set this as the current sub device */
+			vpfe_dev->current_subdev = &vpfe_cfg->sub_devs[i];
+			break;
+		}
+	}
+
+	/* if we don't have any sub device registered, return error */
+	if (i == num_subdevs) {
+		printk(KERN_NOTICE "No sub devices registered\n");
+		goto probe_sd_out;
+	}
 
 	/* We have at least one sub device to work with */
 	mutex_unlock(&ccdc_lock);
@@ -2112,7 +2393,7 @@ static __init int vpfe_init(void)
 	return platform_driver_register(&vpfe_driver);
 }
 
-/*
+/**
  * vpfe_cleanup : This function un-registers device driver
  */
 static void vpfe_cleanup(void)
diff --git a/include/media/davinci/vpfe_capture.h b/include/media/davinci/vpfe_capture.h
index 71d8982..e8272d1 100644
--- a/include/media/davinci/vpfe_capture.h
+++ b/include/media/davinci/vpfe_capture.h
@@ -47,6 +47,8 @@ struct vpfe_pixel_format {
 	struct v4l2_fmtdesc fmtdesc;
 	/* bytes per pixel */
 	int bpp;
+	/* decoder format */
+	u32 subdev_pix_fmt;
 };
 
 struct vpfe_std_info {
@@ -61,9 +63,14 @@ struct vpfe_route {
 	u32 output;
 };
 
+enum vpfe_subdev_id {
+	VPFE_SUBDEV_TVP5146 = 1,
+	VPFE_SUBDEV_MT9T031 = 2
+};
+
 struct vpfe_subdev_info {
-	/* Sub device name */
-	char name[32];
+	/* Sub device module name */
+	char module_name[32];
 	/* Sub device group id */
 	int grp_id;
 	/* Number of inputs supported */
@@ -72,12 +79,16 @@ struct vpfe_subdev_info {
 	struct v4l2_input *inputs;
 	/* Sub dev routing information for each input */
 	struct vpfe_route *routes;
-	/* check if sub dev supports routing */
-	int can_route;
 	/* ccdc bus/interface configuration */
 	struct vpfe_hw_if_param ccdc_if_params;
 	/* i2c subdevice board info */
 	struct i2c_board_info board_info;
+	/* Is this a camera sub device ? */
+	unsigned is_camera:1;
+	/* check if sub dev supports routing */
+	unsigned can_route:1;
+	/* registered ? */
+	unsigned registered:1;
 };
 
 struct vpfe_config {
@@ -89,9 +100,12 @@ struct vpfe_config {
 	char *card_name;
 	/* ccdc name */
 	char *ccdc;
-	/* vpfe clock */
-	struct clk *vpssclk;
-	struct clk *slaveclk;
+	/* setup function for the input path */
+	int (*setup_input)(enum vpfe_subdev_id id);
+	/* number of clocks */
+	int num_clocks;
+	/* clocks used for vpfe capture */
+	char *clocks[];
 };
 
 struct vpfe_device {
@@ -102,6 +116,8 @@ struct vpfe_device {
 	struct v4l2_subdev **sd;
 	/* vpfe cfg */
 	struct vpfe_config *cfg;
+	/* clock ptrs for vpfe capture */
+	struct clk **clks;
 	/* V4l2 device */
 	struct v4l2_device v4l2_dev;
 	/* parent device */
-- 
1.6.0.4

