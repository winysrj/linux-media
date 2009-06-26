Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:41877 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbZFZWDu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 18:03:50 -0400
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id n5QM3m0S013924
	for <linux-media@vger.kernel.org>; Fri, 26 Jun 2009 17:03:53 -0500
From: m-karicheri2@ti.com
To: davinci-linux-open-source@linux.davincidsp.com,
	linux-media@vger.kernel.org
Cc: Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 1/3 - v0] V4L: vpfe capture driver -  adding support for camera capture
Date: Fri, 26 Jun 2009 18:03:46 -0400
Message-Id: <1246053826-8266-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

Following updates to vpfe capture driver :-
	1) Adding support for camera capture using mt9t031 driver
	   (A patch for mt9t031 is already sent for review)
	2) Use v4l2_i2c_new_subdev_board() for loading sub devices
	3) Fixed a bug in s_input and g_input handler
	4) removed g_std() since it is already taken care by
	   v4l2 framework based on current_norm
	5) return proper error code from ccdc register function

Mandatory Reviewers: Hans Verkuil <hverkuil@xs4all.nl>

NOTE: Requires support for v4l2_i2c_new_subdev_board() which was recently
added to v4l2 framework by Hans Verkuil.

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to v4l-dvb repository

 drivers/media/video/davinci/vpfe_capture.c |  356 ++++++++++++++++++++--------
 include/media/davinci/vpfe_capture.h       |   16 ++
 2 files changed, 271 insertions(+), 101 deletions(-)

diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index a4cbe2a..414a7b4 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -59,7 +59,6 @@
  *    TODO list
  *		- Support multiple REQBUF after open
  *		- Support for de-allocating buffers through REQBUF
- *		- Support for Raw Bayer RGB capture
  *		- Support for chaining Image Processor
  *		- Support for static allocation of buffers
  *		- Support for USERPTR IO
@@ -74,18 +73,29 @@
 #include <media/v4l2-common.h>
 #include <linux/io.h>
 #include <media/davinci/vpfe_capture.h>
-#include <media/tvp514x.h>
-#include <linux/i2c.h>
 #include "ccdc_hw_device.h"
 
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
@@ -145,6 +155,7 @@ static const struct vpfe_pixel_format vpfe_pix_fmts[] = {
 			.pixelformat = V4L2_PIX_FMT_SBGGR8,
 		},
 		.bpp = 1,
+		.subdev_pix_fmt = V4L2_PIX_FMT_SGRBG10,
 	},
 	{
 		.fmtdesc = {
@@ -154,6 +165,7 @@ static const struct vpfe_pixel_format vpfe_pix_fmts[] = {
 			.pixelformat = V4L2_PIX_FMT_SBGGR16,
 		},
 		.bpp = 2,
+		.subdev_pix_fmt = V4L2_PIX_FMT_SGRBG10,
 	},
 	{
 		.fmtdesc = {
@@ -163,6 +175,7 @@ static const struct vpfe_pixel_format vpfe_pix_fmts[] = {
 			.pixelformat = V4L2_PIX_FMT_SGRBG10DPCM8,
 		},
 		.bpp = 1,
+		.subdev_pix_fmt = V4L2_PIX_FMT_SGRBG10,
 	},
 	{
 		.fmtdesc = {
@@ -172,6 +185,7 @@ static const struct vpfe_pixel_format vpfe_pix_fmts[] = {
 			.pixelformat = V4L2_PIX_FMT_UYVY,
 		},
 		.bpp = 2,
+		.subdev_pix_fmt = V4L2_PIX_FMT_UYVY,
 	},
 	{
 		.fmtdesc = {
@@ -181,6 +195,7 @@ static const struct vpfe_pixel_format vpfe_pix_fmts[] = {
 			.pixelformat = V4L2_PIX_FMT_YUYV,
 		},
 		.bpp = 2,
+		.subdev_pix_fmt = V4L2_PIX_FMT_UYVY,
 	},
 	{
 		.fmtdesc = {
@@ -190,12 +205,15 @@ static const struct vpfe_pixel_format vpfe_pix_fmts[] = {
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
@@ -243,19 +261,19 @@ int vpfe_register_ccdc_device(struct ccdc_hw_device *dev)
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
 
@@ -295,6 +313,41 @@ void vpfe_unregister_ccdc_device(struct ccdc_hw_device *dev)
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
+	/*
+	 * Get the limits of width and height using try format
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
@@ -304,9 +357,13 @@ static int vpfe_get_ccdc_image_format(struct vpfe_device *vpfe_dev,
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
@@ -388,8 +445,10 @@ static int vpfe_config_image_format(struct vpfe_device *vpfe_dev,
 				    const v4l2_std_id *std_id)
 {
 	struct vpfe_subdev_info *sdinfo = vpfe_dev->current_subdev;
+	struct v4l2_format sd_fmt;
 	int i, ret = 0;
 
+	/* configure the ccdc based on standard */
 	for (i = 0; i < ARRAY_SIZE(vpfe_standards); i++) {
 		if (vpfe_standards[i].std_id & *std_id) {
 			vpfe_dev->std_info.active_pixels =
@@ -426,16 +485,17 @@ static int vpfe_config_image_format(struct vpfe_device *vpfe_dev,
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
@@ -458,13 +518,29 @@ static int vpfe_initialize_device(struct vpfe_device *vpfe_dev)
 
 	/* set first input of current subdevice as the current input */
 	vpfe_dev->current_input = 0;
+	/*
+	 * set default standard. For camera device, we cannot set standard.
+	 * So we set it to -1. Otherwise, first entry in the standard is the
+	 * is the default
+	 */
+	if (vpfe_dev->current_subdev->camera) {
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
 
@@ -962,6 +1038,8 @@ static int vpfe_s_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct vpfe_device *vpfe_dev = video_drvdata(file);
 	const struct vpfe_pixel_format *pix_fmts;
+	struct vpfe_subdev_info *sdinfo;
+	struct v4l2_format sd_fmt;
 	int ret = 0;
 
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_s_fmt_vid_cap\n");
@@ -983,11 +1061,30 @@ static int vpfe_s_fmt_vid_cap(struct file *file, void *priv,
 	if (ret)
 		return ret;
 
-	/* First detach any IRQ if currently attached */
-	vpfe_detach_irq(vpfe_dev);
-	vpfe_dev->fmt = *fmt;
-	/* set image capture parameters in the ccdc */
-	ret = vpfe_config_ccdc_image_format(vpfe_dev);
+	sdinfo = vpfe_dev->current_subdev;
+	if (sdinfo->camera) {
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
+		vpfe_dev->crop.width = fmt->fmt.pix.width;
+		vpfe_dev->crop.height = fmt->fmt.pix.height;
+	}
+
+	if (!ret) {
+		/* First detach any IRQ if currently attached */
+		vpfe_dev->fmt = *fmt;
+		/* set image capture parameters in the ccdc */
+		ret = vpfe_config_ccdc_image_format(vpfe_dev);
+	}
 	mutex_unlock(&vpfe_dev->lock);
 	return ret;
 }
@@ -1047,7 +1144,7 @@ static int vpfe_get_app_input_index(struct vpfe_device *vpfe_dev,
 		sdinfo = &cfg->sub_devs[i];
 		if (!strcmp(sdinfo->name, vpfe_dev->current_subdev->name)) {
 			if (vpfe_dev->current_input >= sdinfo->num_inputs)
-				return -1;
+				return -EINVAL;
 			*app_input_index = j + vpfe_dev->current_input;
 			return 0;
 		}
@@ -1061,10 +1158,11 @@ static int vpfe_enum_input(struct file *file, void *priv,
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
@@ -1075,6 +1173,7 @@ static int vpfe_enum_input(struct file *file, void *priv,
 	}
 	sdinfo = &vpfe_dev->cfg->sub_devs[subdev];
 	memcpy(inp, &sdinfo->inputs[index], sizeof(struct v4l2_input));
+	inp->index = temp_index;
 	return 0;
 }
 
@@ -1092,7 +1191,7 @@ static int vpfe_s_input(struct file *file, void *priv, unsigned int index)
 {
 	struct vpfe_device *vpfe_dev = video_drvdata(file);
 	struct vpfe_subdev_info *sdinfo;
-	int subdev_index, inp_index;
+	int subdev_index, subdev_inp_index;
 	struct vpfe_route *route;
 	u32 input = 0, output = 0;
 	int ret = -EINVAL;
@@ -1115,31 +1214,47 @@ static int vpfe_s_input(struct file *file, void *priv, unsigned int index)
 
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
+			v4l2_info(&vpfe_dev->v4l2_dev, "couldn't setup input"
+				  " for %s\n", sdinfo->name);
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
-			"vpfe_doioctl:error in setting input in decoder \n");
-		ret = -EINVAL;
-		goto unlock_out;
+		if (ret) {
+			v4l2_err(&vpfe_dev->v4l2_dev,
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
@@ -1147,8 +1262,22 @@ static int vpfe_s_input(struct file *file, void *priv, unsigned int index)
 		goto unlock_out;
 
 	/* set the default image parameters in the device */
-	ret = vpfe_config_image_format(vpfe_dev,
+	if (vpfe_dev->current_subdev->camera)
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
@@ -1207,15 +1336,6 @@ unlock_out:
 	return ret;
 }
 
-static int vpfe_g_std(struct file *file, void *priv, v4l2_std_id *std_id)
-{
-	struct vpfe_device *vpfe_dev = video_drvdata(file);
-
-	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_g_std\n");
-
-	*std_id = vpfe_standards[vpfe_dev->std_index].std_id;
-	return 0;
-}
 /*
  *  Videobuf operations
  */
@@ -1576,6 +1696,7 @@ static int vpfe_cropcap(struct file *file, void *priv,
 			      struct v4l2_cropcap *crop)
 {
 	struct vpfe_device *vpfe_dev = video_drvdata(file);
+	struct vpfe_subdev_info *sdinfo;
 
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_cropcap\n");
 
@@ -1584,11 +1705,25 @@ static int vpfe_cropcap(struct file *file, void *priv,
 
 	memset(crop, 0, sizeof(struct v4l2_cropcap));
 	crop->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	crop->bounds.width = crop->defrect.width =
-		vpfe_standards[vpfe_dev->std_index].width;
-	crop->bounds.height = crop->defrect.height =
-		vpfe_standards[vpfe_dev->std_index].height;
-	crop->pixelaspect = vpfe_standards[vpfe_dev->std_index].pixelaspect;
+	sdinfo = vpfe_dev->current_subdev;
+
+	if (!sdinfo->camera) {
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
 
@@ -1710,7 +1845,6 @@ static const struct v4l2_ioctl_ops vpfe_ioctl_ops = {
 	.vidioc_s_input		 = vpfe_s_input,
 	.vidioc_querystd	 = vpfe_querystd,
 	.vidioc_s_std		 = vpfe_s_std,
-	.vidioc_g_std		 = vpfe_g_std,
 	.vidioc_reqbufs		 = vpfe_reqbufs,
 	.vidioc_querybuf	 = vpfe_querybuf,
 	.vidioc_qbuf		 = vpfe_qbuf,
@@ -1806,18 +1940,20 @@ out:
 	return -1;
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
+	struct vpfe_subdev_info *sdinfo;
 	struct vpfe_config *vpfe_cfg;
 	struct resource *res1;
 	struct vpfe_device *vpfe_dev;
 	struct i2c_adapter *i2c_adap;
-	struct i2c_client *client;
 	struct video_device *vfd;
 	int ret = -ENOMEM, i, j;
 	int num_subdevs = 0;
@@ -1919,7 +2055,7 @@ static __init int vpfe_probe(struct platform_device *pdev)
 	/* Allocate memory for video device */
 	vfd = video_device_alloc();
 	if (NULL == vfd) {
-		ret = ENOMEM;
+		ret = -ENOMEM;
 		v4l2_err(pdev->dev.driver,
 			"Unable to alloc video device\n");
 		goto probe_out_release_irq;
@@ -1927,12 +2063,11 @@ static __init int vpfe_probe(struct platform_device *pdev)
 
 	/* Initialize field of video device */
 	vfd->release		= video_device_release;
-	vfd->current_norm	= V4L2_STD_UNKNOWN;
 	vfd->fops		= &vpfe_fops;
 	vfd->ioctl_ops		= &vpfe_ioctl_ops;
 	vfd->minor		= -1;
 	vfd->tvnorms		= 0;
-	vfd->current_norm	= V4L2_STD_PAL;
+	vfd->current_norm	= V4L2_STD_NTSC;
 	vfd->v4l2_dev 		= &vpfe_dev->v4l2_dev;
 	snprintf(vfd->name, sizeof(vfd->name),
 		 "%s_V%d.%d.%d",
@@ -1992,62 +2127,81 @@ static __init int vpfe_probe(struct platform_device *pdev)
 	}
 
 	for (i = 0; i < num_subdevs; i++) {
-		struct vpfe_subdev_info *sdinfo = &vpfe_cfg->sub_devs[i];
 		struct v4l2_input *inps;
 
-		list_for_each_entry(client, &i2c_adap->clients, list) {
-			if (!strcmp(client->name, sdinfo->name))
-				break;
-		}
+		sdinfo = &vpfe_cfg->sub_devs[i];
+		/**
+		 * register subdevices based on interface setting. Currently
+		 * tvp5146 and mt9t031 cannot co-exists due to i2c address
+		 * conflicts. So only one of them is registered. Re-visit this
+		 * once we have support for i2c switch handling in i2c driver
+		 * framework
+		 */
+		if (interface == sdinfo->camera) {
+			/* setup input path */
+			if (vpfe_cfg->setup_input) {
+				if (vpfe_cfg->setup_input(sdinfo->grp_id) < 0) {
+					ret = -EFAULT;
+					v4l2_info(&vpfe_dev->v4l2_dev, "could"
+						  " not setup input for %s\n",
+						  sdinfo->name);
+					goto probe_sd_out;
+				}
+			}
+			/* Load up the subdevice */
+			vpfe_dev->sd[i] =
+				v4l2_i2c_new_subdev_board(&vpfe_dev->v4l2_dev,
+							  i2c_adap,
+							  sdinfo->name,
+							  &sdinfo->board_info,
+							  0);
+			if (vpfe_dev->sd[i])
+				v4l2_info(&vpfe_dev->v4l2_dev,
+					  "v4l2 sub device %s registered\n",
+					  sdinfo->name);
+			else {
+				v4l2_info(&vpfe_dev->v4l2_dev,
+					  "v4l2 sub device %s register fails\n",
+					  sdinfo->name);
+			}
+			vpfe_dev->sd[i]->grp_id = sdinfo->grp_id;
 
-		if (NULL == client) {
-			v4l2_err(&vpfe_dev->v4l2_dev, "No Subdevice found\n");
-			ret =  -ENODEV;
-			goto probe_sd_out;
+			/* update tvnorms from the sub devices */
+			for (j = 0; j < sdinfo->num_inputs; j++) {
+				inps = &sdinfo->inputs[j];
+				vfd->tvnorms |= inps->std;
+			}
+			sdinfo->registered = 1;
 		}
+	}
 
-		/* Get subdevice data from the client */
-		vpfe_dev->sd[i] = i2c_get_clientdata(client);
-		if (NULL == vpfe_dev->sd[i]) {
-			v4l2_err(&vpfe_dev->v4l2_dev,
-				"No Subdevice data\n");
-			ret =  -ENODEV;
-			goto probe_sd_out;
+	/* We need atleast one sub device to do capture */
+	for (i = 0; i < num_subdevs; i++) {
+		sdinfo = &vpfe_cfg->sub_devs[i];
+		if (sdinfo->registered) {
+			/* set this as the current sub device */
+			vpfe_dev->current_subdev = &vpfe_cfg->sub_devs[i];
+			break;
 		}
+	}
 
-		vpfe_dev->sd[i]->grp_id = sdinfo->grp_id;
-		ret = v4l2_device_register_subdev(&vpfe_dev->v4l2_dev,
-						  vpfe_dev->sd[i]);
-		if (ret) {
-			ret =  -ENODEV;
-			v4l2_err(&vpfe_dev->v4l2_dev,
-				"Error registering v4l2 sub-device\n");
-			goto probe_sd_out;
-		}
-		v4l2_info(&vpfe_dev->v4l2_dev, "v4l2 sub device %s"
-			  " registered\n", client->name);
+	/* if we don't have any sub device registered, return error */
+	if (i == num_subdevs)
+		goto probe_sd_out;
 
-		/* update tvnorms from the sub devices */
-		for (j = 0; j < sdinfo->num_inputs; j++) {
-			inps = &sdinfo->inputs[j];
-			vfd->tvnorms |= inps->std;
-		}
-	}
 	/* We have at least one sub device to work with */
-	vpfe_dev->current_subdev = &vpfe_cfg->sub_devs[0];
 	mutex_unlock(&ccdc_lock);
 	return 0;
 
 probe_sd_out:
-	for (j = i; j >= 0; j--)
-		v4l2_device_unregister_subdev(vpfe_dev->sd[j]);
 	kfree(vpfe_dev->sd);
 probe_out_video_unregister:
 	video_unregister_device(vpfe_dev->video_dev);
 probe_out_v4l2_unregister:
 	v4l2_device_unregister(&vpfe_dev->v4l2_dev);
 probe_out_video_release:
-	video_device_release(vpfe_dev->video_dev);
+	if (vpfe_dev->video_dev->minor == -1)
+		video_device_release(vpfe_dev->video_dev);
 probe_out_release_irq:
 	free_irq(vpfe_dev->ccdc_irq0, vpfe_dev);
 probe_out_unmap1:
@@ -2124,7 +2278,7 @@ static __init int vpfe_init(void)
 	return platform_driver_register(&vpfe_driver);
 }
 
-/*
+/**
  * vpfe_cleanup : This function un-registers device driver
  */
 static void vpfe_cleanup(void)
diff --git a/include/media/davinci/vpfe_capture.h b/include/media/davinci/vpfe_capture.h
index 8259257..2aad7d7 100644
--- a/include/media/davinci/vpfe_capture.h
+++ b/include/media/davinci/vpfe_capture.h
@@ -25,6 +25,7 @@
 #include <media/v4l2-dev.h>
 #include <linux/videodev2.h>
 #include <linux/clk.h>
+#include <linux/i2c.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 #include <media/videobuf-dma-contig.h>
@@ -46,6 +47,8 @@ struct vpfe_pixel_format {
 	struct v4l2_fmtdesc fmtdesc;
 	/* bytes per pixel */
 	int bpp;
+	/* decoder format */
+	u32 subdev_pix_fmt;
 };
 
 struct vpfe_std_info {
@@ -60,9 +63,16 @@ struct vpfe_route {
 	u32 output;
 };
 
+enum vpfe_subdev_id {
+	VPFE_SUBDEV_TVP5146 = 1,
+	VPFE_SUBDEV_MT9T031 = 2
+};
+
 struct vpfe_subdev_info {
 	/* Sub device name */
 	char name[32];
+	/* Is this a camera sub device ? */
+	int camera;
 	/* Sub device group id */
 	int grp_id;
 	/* Number of inputs supported */
@@ -75,6 +85,10 @@ struct vpfe_subdev_info {
 	int can_route;
 	/* ccdc bus/interface configuration */
 	struct vpfe_hw_if_param ccdc_if_params;
+	/* i2c subdevice board info */
+	struct i2c_board_info board_info;
+	/* registered ? */
+	int registered;
 };
 
 struct vpfe_config {
@@ -89,6 +103,8 @@ struct vpfe_config {
 	/* vpfe clock */
 	struct clk *vpssclk;
 	struct clk *slaveclk;
+	/* setup function for the input path */
+	int (*setup_input)(enum vpfe_subdev_id id);
 };
 
 struct vpfe_device {
-- 
1.6.0.4

