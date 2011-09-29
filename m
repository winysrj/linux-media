Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:56962 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201Ab1I2QTF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Sep 2011 12:19:05 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>
Subject: [PATCH 7/9] V4L: soc-camera: add a Media Controller wrapper
Date: Thu, 29 Sep 2011 18:18:55 +0200
Message-Id: <1317313137-4403-8-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1317313137-4403-1-git-send-email-g.liakhovetski@gmx.de>
References: <1317313137-4403-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This wrapper adds a Media Controller implementation to soc-camera drivers.
To really benefit from it individual host drivers should implement support
for values of enum soc_camera_target other than SOCAM_TARGET_PIPELINE in
their .set_fmt() and .try_fmt() methods.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/Makefile       |    6 +-
 drivers/media/video/soc_camera.c   |   46 ++++--
 drivers/media/video/soc_entity.c   |  284 ++++++++++++++++++++++++++++++++++++
 drivers/media/video/soc_mediabus.c |   16 --
 include/media/soc_camera.h         |    1 +
 include/media/soc_entity.h         |   12 ++
 6 files changed, 334 insertions(+), 31 deletions(-)
 create mode 100644 drivers/media/video/soc_entity.c

diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 11fff97..f4e3d52 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -162,7 +162,11 @@ obj-$(CONFIG_VIDEO_CX23885) += cx23885/
 obj-$(CONFIG_VIDEO_AK881X)		+= ak881x.o
 
 obj-$(CONFIG_VIDEO_OMAP2)		+= omap2cam.o
-obj-$(CONFIG_SOC_CAMERA)		+= soc_camera.o soc_mediabus.o
+obj-$(CONFIG_SOC_CAMERA)		+= soc_camera_core.o
+soc_camera_core-objs			:= soc_camera.o soc_mediabus.o
+ifeq ($(CONFIG_MEDIA_CONTROLLER),y)
+soc_camera_core-objs			+= soc_entity.o
+endif
 obj-$(CONFIG_SOC_CAMERA_PLATFORM)	+= soc_camera_platform.o
 # soc-camera host drivers have to be linked after camera drivers
 obj-$(CONFIG_VIDEO_MX1)			+= mx1_camera.o
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 790c14c..9b4c3c0 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -515,17 +515,17 @@ int soc_camera_set_fmt(struct soc_camera_device *icd, struct v4l2_format *f,
 	case SOCAM_TARGET_HOST_OUT:
 		icd->user_width		= pix->width;
 		icd->user_height	= pix->height;
+		icd->bytesperline	= pix->bytesperline;
+		icd->sizeimage		= pix->sizeimage;
+		icd->colorspace		= pix->colorspace;
+		icd->field		= pix->field;
+		if (ici->ops->init_videobuf)
+			icd->vb_vidq.field = pix->field;
 		break;
 	case SOCAM_TARGET_HOST_IN:
 		icd->host_input_width	= pix->width;
 		icd->host_input_height	= pix->height;
 	}
-	icd->bytesperline	= pix->bytesperline;
-	icd->sizeimage		= pix->sizeimage;
-	icd->colorspace		= pix->colorspace;
-	icd->field		= pix->field;
-	if (ici->ops->init_videobuf)
-		icd->vb_vidq.field = pix->field;
 
 	dev_dbg(icd->pdev, "set width: %d height: %d\n",
 		icd->user_width, icd->user_height);
@@ -835,10 +835,14 @@ static int soc_camera_streamon(struct file *file, void *priv,
 	if (icd->streamer != file)
 		return -EBUSY;
 
+	ret = soc_camera_mc_streamon(icd);
+	if (ret < 0)
+		return ret;
+
 	/* set physical bus parameters */
 	ret = ici->ops->set_bus_param(icd);
 	if (ret < 0)
-		return ret;
+		goto ebusp;
 
 	/* This calls buf_queue from host driver's videobuf_queue_ops */
 	if (ici->ops->init_videobuf)
@@ -846,9 +850,23 @@ static int soc_camera_streamon(struct file *file, void *priv,
 	else
 		ret = vb2_streamon(&icd->vb2_vidq, i);
 
-	if (!ret)
-		v4l2_subdev_call(sd, video, s_stream, 1);
+	if (ret < 0)
+		goto estreamon;
+
+	ret = v4l2_subdev_call(sd, video, s_stream, 1);
+	if (ret < 0 && ret != -ENOIOCTLCMD)
+		goto esdstream;
+
+	return ret;
 
+esdstream:
+	if (ici->ops->init_videobuf)
+		videobuf_streamoff(&icd->vb_vidq);
+	else
+		vb2_streamoff(&icd->vb2_vidq, i);
+estreamon:
+ebusp:
+	soc_camera_mc_streamoff(icd);
 	return ret;
 }
 
@@ -877,6 +895,7 @@ static int soc_camera_streamoff(struct file *file, void *priv,
 		vb2_streamoff(&icd->vb2_vidq, i);
 
 	v4l2_subdev_call(sd, video, s_stream, 0);
+	soc_camera_mc_streamoff(icd);
 
 	return 0;
 }
@@ -1250,12 +1269,11 @@ static int soc_camera_remove(struct soc_camera_device *icd)
 	BUG_ON(!icd->parent);
 
 	v4l2_ctrl_handler_free(&icd->ctrl_handler);
-	if (vdev) {
+	soc_camera_mc_free(icd);
+	if (vdev)
 		video_unregister_device(vdev);
-		icd->vdev = NULL;
-	}
 
-	soc_camera_mc_free(icd);
+	icd->vdev = NULL;
 
 	if (icl->board_info) {
 		soc_camera_free_i2c(icd);
@@ -1484,7 +1502,7 @@ static int video_dev_create(struct soc_camera_device *icd)
 	if (!vdev)
 		return -ENOMEM;
 
-	strlcpy(vdev->name, ici->drv_name, sizeof(vdev->name));
+	snprintf(vdev->name, sizeof(vdev->name), "%s output", ici->drv_name);
 
 	vdev->current_norm	= V4L2_STD_UNKNOWN;
 	vdev->fops		= &soc_camera_fops;
diff --git a/drivers/media/video/soc_entity.c b/drivers/media/video/soc_entity.c
new file mode 100644
index 0000000..3a04700
--- /dev/null
+++ b/drivers/media/video/soc_entity.c
@@ -0,0 +1,284 @@
+/*
+ * soc-camera Media Controller wrapper
+ *
+ * Copyright (C) 2011, Guennadi Liakhovetski <kernel@pengutronix.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/media.h>
+#include <linux/string.h>
+#include <linux/v4l2-mediabus.h>
+
+#include <media/soc_camera.h>
+#include <media/soc_mediabus.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-subdev.h>
+
+#define soc_entity_native_mc(x) false
+
+enum {
+	SOC_HOST_BUS_PAD_SINK,
+	SOC_HOST_BUS_PAD_SOURCE,
+};
+
+enum {
+	SOC_HOST_VDEV_PAD_SINK,
+};
+
+static void se_v4l2_to_mbus(struct soc_camera_device *icd,
+			    struct v4l2_format *vf,
+			    struct v4l2_mbus_framefmt *mf)
+{
+	struct v4l2_pix_format *pfmt = &vf->fmt.pix;
+
+	mf->width	= pfmt->width;
+	mf->height	= pfmt->height;
+	mf->colorspace	= pfmt->colorspace;
+	mf->field	= pfmt->field;
+	mf->code	= soc_camera_xlate_by_fourcc(icd,
+						pfmt->pixelformat)->code;
+}
+
+static void se_mbus_to_v4l2(struct soc_camera_device *icd,
+			    struct v4l2_mbus_framefmt *mf,
+			    struct v4l2_format *vf)
+{
+	struct v4l2_pix_format *pfmt = &vf->fmt.pix;
+	u32 fourcc = icd->current_fmt->host_fmt->fourcc;
+
+	pfmt->width		= mf->width;
+	pfmt->height		= mf->height;
+	pfmt->colorspace	= mf->colorspace;
+	pfmt->field		= mf->field;
+	pfmt->pixelformat	= soc_camera_xlate_by_mcode(icd,
+					mf->code, fourcc)->host_fmt->fourcc;
+}
+
+static int bus_sd_pad_g_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			    struct v4l2_subdev_format *sd_fmt)
+{
+	struct soc_camera_device *icd = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *f = &sd_fmt->format;
+
+	if (sd_fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		sd_fmt->format = *v4l2_subdev_get_try_format(fh, sd_fmt->pad);
+		return 0;
+	}
+
+	if (sd_fmt->pad == SOC_HOST_BUS_PAD_SINK) {
+		f->width	= icd->host_input_width;
+		f->height	= icd->host_input_height;
+	} else {
+		f->width	= icd->user_width;
+		f->height	= icd->user_height;
+	}
+	f->field	= icd->field;
+	f->code		= icd->current_fmt->code;
+	f->colorspace	= icd->colorspace;
+
+	return 0;
+}
+
+static int bus_sd_pad_s_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			    struct v4l2_subdev_format *sd_fmt)
+{
+	struct soc_camera_device *icd = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *mf = &sd_fmt->format;
+	struct v4l2_format vf = {
+		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
+	};
+	enum soc_camera_target tgt = sd_fmt->pad == SOC_HOST_BUS_PAD_SINK ?
+		SOCAM_TARGET_HOST_IN : SOCAM_TARGET_HOST_OUT;
+	int ret;
+
+	se_mbus_to_v4l2(icd, mf, &vf);
+
+	if (sd_fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		struct v4l2_mbus_framefmt *try_fmt =
+			v4l2_subdev_get_try_format(fh, sd_fmt->pad);
+		ret = soc_camera_try_fmt(icd, &vf, tgt);
+		if (!ret) {
+			se_v4l2_to_mbus(icd, &vf, try_fmt);
+			sd_fmt->format = *try_fmt;
+		}
+		return ret;
+	}
+
+	ret = soc_camera_set_fmt(icd, &vf, tgt);
+	if (!ret)
+		se_v4l2_to_mbus(icd, &vf, &sd_fmt->format);
+
+	return ret;
+}
+
+static int bus_sd_pad_enum_mbus_code(struct v4l2_subdev *sd,
+				     struct v4l2_subdev_fh *fh,
+				     struct v4l2_subdev_mbus_code_enum *ce)
+{
+	struct soc_camera_device *icd = v4l2_get_subdevdata(sd);
+
+	if (ce->index >= icd->num_user_formats)
+		return -EINVAL;
+
+	ce->code = icd->user_formats[ce->index].code;
+	return 0;
+}
+
+static const struct v4l2_subdev_pad_ops se_bus_sd_pad_ops = {
+	.get_fmt	= bus_sd_pad_g_fmt,
+	.set_fmt	= bus_sd_pad_s_fmt,
+	.enum_mbus_code	= bus_sd_pad_enum_mbus_code,
+};
+
+static const struct v4l2_subdev_ops se_bus_sd_ops = {
+	.pad		= &se_bus_sd_pad_ops,
+};
+
+static const struct media_entity_operations se_bus_me_ops = {
+};
+
+static const struct media_entity_operations se_vdev_me_ops = {
+};
+
+int soc_camera_mc_streamon(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct v4l2_subdev *bus_sd = &ici->bus_sd;
+	struct media_entity *bus_me = &bus_sd->entity;
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct v4l2_mbus_framefmt mf;
+	int ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
+	if (WARN_ON(ret < 0))
+		return ret;
+	if (icd->host_input_width != mf.width ||
+	    icd->host_input_height != mf.height ||
+	    icd->current_fmt->code != mf.code)
+		return -EINVAL;
+
+	media_entity_pipeline_start(bus_me, &ici->pipe);
+	return 0;
+}
+
+void soc_camera_mc_streamoff(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct v4l2_subdev *bus_sd = &ici->bus_sd;
+	struct media_entity *bus_me = &bus_sd->entity;
+	media_entity_pipeline_stop(bus_me);
+}
+
+int soc_camera_mc_install(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct v4l2_subdev *bus_sd = &ici->bus_sd;
+	struct media_entity *bus_me = &bus_sd->entity;
+	struct media_pad *bus_pads = ici->bus_pads;
+	struct media_pad *vdev_pads = ici->vdev_pads;
+	struct video_device *vdev = icd->vdev;
+	struct media_entity *vdev_me = &vdev->entity;
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	int ret;
+
+	if (!ici->v4l2_dev.mdev || soc_entity_native_mc(icd))
+		return 0;
+
+	/* Configure the video bus subdevice, entity, and pads */
+	v4l2_subdev_init(bus_sd, &se_bus_sd_ops);
+	v4l2_set_subdevdata(bus_sd, icd);
+	bus_sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	snprintf(bus_sd->name, sizeof(bus_sd->name), "%s input", ici->drv_name);
+
+	bus_pads[SOC_HOST_BUS_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	bus_pads[SOC_HOST_BUS_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
+	bus_me->ops = &se_bus_me_ops;
+
+	ret = media_entity_init(bus_me, 2, bus_pads, 0);
+	if (ret < 0)
+		return ret;
+
+	/* Configure the video-device entity */
+	vdev_pads[SOC_HOST_VDEV_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	vdev_me->ops = &se_vdev_me_ops;
+
+	ret = media_entity_init(vdev_me, 1, vdev_pads, 0);
+	if (ret < 0)
+		goto evmei;
+
+	/* Link the two entities */
+	ret = media_entity_create_link(bus_me, SOC_HOST_BUS_PAD_SOURCE,
+				vdev_me, SOC_HOST_VDEV_PAD_SINK,
+				MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED);
+	if (ret < 0)
+		goto elink;
+
+	ret = v4l2_device_register_subdev(&ici->v4l2_dev, bus_sd);
+	if (ret < 0)
+		goto eregsd;
+
+	ret = v4l2_device_register_subdev_nodes(&ici->v4l2_dev);
+	if (ret < 0)
+		goto eregsdn;
+
+	/*
+	 * Link the client: make it immutable too for now, since there is no
+	 * meaningful mapping for the .link_setup() method to the soc-camera
+	 * API
+	 */
+	ret = media_entity_create_link(&sd->entity, 0,
+				bus_me, SOC_HOST_BUS_PAD_SINK,
+				MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED);
+	if (ret < 0)
+		goto eclink;
+
+	return 0;
+
+eclink:
+eregsdn:
+	v4l2_device_unregister_subdev(bus_sd);
+eregsd:
+elink:
+	media_entity_cleanup(vdev_me);
+evmei:
+	media_entity_cleanup(bus_me);
+
+	return ret;
+}
+
+void soc_camera_mc_free(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct v4l2_subdev *bus_sd = &ici->bus_sd;
+	struct media_entity *bus_me = &bus_sd->entity;
+	struct video_device *vdev = icd->vdev;
+	struct media_entity *vdev_me = &vdev->entity;
+
+	if (!ici->v4l2_dev.mdev || !soc_camera_to_subdev(icd)->ops->pad ||
+	    soc_entity_native_mc(icd))
+		return;
+
+	v4l2_device_unregister_subdev(bus_sd);
+
+	media_entity_cleanup(vdev_me);
+	media_entity_cleanup(bus_me);
+}
+
+void soc_camera_mc_register(struct soc_camera_host *ici)
+{
+	int ret;
+
+	/* The Big Moment: register the media device */
+	ici->mdev.dev = ici->v4l2_dev.dev;
+	ici->v4l2_dev.mdev = &ici->mdev;
+	strlcpy(ici->mdev.model, ici->drv_name, sizeof(ici->mdev.model));
+	ret = media_device_register(&ici->mdev);
+	if (ret < 0)
+		ici->v4l2_dev.mdev = NULL;
+}
+
+void soc_camera_mc_unregister(struct soc_camera_host *ici)
+{
+	if (ici->v4l2_dev.mdev)
+		media_device_unregister(&ici->mdev);
+}
diff --git a/drivers/media/video/soc_mediabus.c b/drivers/media/video/soc_mediabus.c
index cf7f219..9f84c5c 100644
--- a/drivers/media/video/soc_mediabus.c
+++ b/drivers/media/video/soc_mediabus.c
@@ -415,19 +415,3 @@ unsigned int soc_mbus_config_compatible(const struct v4l2_mbus_config *cfg,
 	return 0;
 }
 EXPORT_SYMBOL(soc_mbus_config_compatible);
-
-static int __init soc_mbus_init(void)
-{
-	return 0;
-}
-
-static void __exit soc_mbus_exit(void)
-{
-}
-
-module_init(soc_mbus_init);
-module_exit(soc_mbus_exit);
-
-MODULE_DESCRIPTION("soc-camera media bus interface");
-MODULE_AUTHOR("Guennadi Liakhovetski <g.liakhovetski@gmx.de>");
-MODULE_LICENSE("GPL v2");
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 0a21ff1..8b2b4ee 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -70,6 +70,7 @@ struct soc_camera_host {
 	struct v4l2_subdev bus_sd;
 	struct media_pad bus_pads[2];
 	struct media_pad vdev_pads[1];
+	struct media_pipeline pipe;
 #endif
 };
 
diff --git a/include/media/soc_entity.h b/include/media/soc_entity.h
index e461f5e..e4c692a 100644
--- a/include/media/soc_entity.h
+++ b/include/media/soc_entity.h
@@ -11,9 +11,21 @@
 #ifndef SOC_ENTITY_H
 #define SOC_ENTITY_H
 
+#if defined(CONFIG_MEDIA_CONTROLLER)
+struct soc_camera_device;
+int soc_camera_mc_install(struct soc_camera_device *icd);
+void soc_camera_mc_free(struct soc_camera_device *icd);
+void soc_camera_mc_register(struct soc_camera_host *ici);
+void soc_camera_mc_unregister(struct soc_camera_host *ici);
+int soc_camera_mc_streamon(struct soc_camera_device *icd);
+int soc_camera_mc_streamoff(struct soc_camera_device *icd);
+#else
 #define soc_camera_mc_install(x) 0
 #define soc_camera_mc_free(x) do {} while (0)
 #define soc_camera_mc_register(x) do {} while (0)
 #define soc_camera_mc_unregister(x) do {} while (0)
+#define soc_camera_mc_streamon(x) 0
+#define soc_camera_mc_streamoff(x) do {} while (0)
+#endif
 
 #endif
-- 
1.7.2.5

