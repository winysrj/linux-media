Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:57826 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728703AbeGYLPe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 07:15:34 -0400
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v6 4/8] media: platform: Add Cedrus VPU decoder driver
Date: Wed, 25 Jul 2018 12:02:52 +0200
Message-Id: <20180725100256.22833-5-paul.kocialkowski@bootlin.com>
In-Reply-To: <20180725100256.22833-1-paul.kocialkowski@bootlin.com>
References: <20180725100256.22833-1-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This introduces the Cedrus VPU driver that supports the VPU found in
Allwinner SoCs, also known as Video Engine. It is implemented through
a v4l2 m2m decoder device and a media device (used for media requests).
So far, it only supports MPEG2 decoding.

Since this VPU is stateless, synchronization with media requests is
required in order to ensure consistency between frame headers that
contain metadata about the frame to process and the raw slice data that
is used to generate the frame.

This driver was made possible thanks to the long-standing effort
carried out by the linux-sunxi community in the interest of reverse
engineering, documenting and implementing support for Allwinner VPU.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 MAINTAINERS                                   |   7 +
 drivers/staging/media/Kconfig                 |   2 +
 drivers/staging/media/Makefile                |   1 +
 drivers/staging/media/sunxi/Kconfig           |  15 +
 drivers/staging/media/sunxi/Makefile          |   1 +
 drivers/staging/media/sunxi/cedrus/Kconfig    |  14 +
 drivers/staging/media/sunxi/cedrus/Makefile   |   3 +
 drivers/staging/media/sunxi/cedrus/cedrus.c   | 419 +++++++++++++
 drivers/staging/media/sunxi/cedrus/cedrus.h   | 166 +++++
 .../staging/media/sunxi/cedrus/cedrus_dec.c   | 114 ++++
 .../staging/media/sunxi/cedrus/cedrus_dec.h   |  27 +
 .../staging/media/sunxi/cedrus/cedrus_hw.c    | 319 ++++++++++
 .../staging/media/sunxi/cedrus/cedrus_hw.h    |  29 +
 .../staging/media/sunxi/cedrus/cedrus_mpeg2.c | 240 ++++++++
 .../staging/media/sunxi/cedrus/cedrus_regs.h  | 235 ++++++++
 .../staging/media/sunxi/cedrus/cedrus_video.c | 566 ++++++++++++++++++
 .../staging/media/sunxi/cedrus/cedrus_video.h |  31 +
 17 files changed, 2189 insertions(+)
 create mode 100644 drivers/staging/media/sunxi/Kconfig
 create mode 100644 drivers/staging/media/sunxi/Makefile
 create mode 100644 drivers/staging/media/sunxi/cedrus/Kconfig
 create mode 100644 drivers/staging/media/sunxi/cedrus/Makefile
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus.c
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus.h
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_dec.c
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_dec.h
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_hw.c
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_hw.h
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_regs.h
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_video.c
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_video.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 89853313c697..342504506a89 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -656,6 +656,13 @@ L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	drivers/crypto/sunxi-ss/
 
+ALLWINNER VPU DRIVER
+M:	Maxime Ripard <maxime.ripard@bootlin.com>
+M:	Paul Kocialkowski <paul.kocialkowski@bootlin.com>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/staging/media/sunxi/cedrus/
+
 ALPHA PORT
 M:	Richard Henderson <rth@twiddle.net>
 M:	Ivan Kokshaysky <ink@jurassic.park.msu.ru>
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index db5cf67047ad..b3620a8f2d9f 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -31,6 +31,8 @@ source "drivers/staging/media/mt9t031/Kconfig"
 
 source "drivers/staging/media/omap4iss/Kconfig"
 
+source "drivers/staging/media/sunxi/Kconfig"
+
 source "drivers/staging/media/tegra-vde/Kconfig"
 
 source "drivers/staging/media/zoran/Kconfig"
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 503fbe47fa58..42948f805548 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -5,5 +5,6 @@ obj-$(CONFIG_SOC_CAMERA_IMX074)	+= imx074/
 obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= mt9t031/
 obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
+obj-$(CONFIG_VIDEO_SUNXI)	+= sunxi/
 obj-$(CONFIG_TEGRA_VDE)		+= tegra-vde/
 obj-$(CONFIG_VIDEO_ZORAN)	+= zoran/
diff --git a/drivers/staging/media/sunxi/Kconfig b/drivers/staging/media/sunxi/Kconfig
new file mode 100644
index 000000000000..c78d92240ceb
--- /dev/null
+++ b/drivers/staging/media/sunxi/Kconfig
@@ -0,0 +1,15 @@
+config VIDEO_SUNXI
+	bool "Allwinner sunXi family Video Devices"
+	depends on ARCH_SUNXI || COMPILE_TEST
+	help
+	  If you have an Allwinner SoC based on the sunXi family, say Y.
+
+	  Note that this option doesn't include new drivers in the
+	  kernel: saying N will just cause Kconfig to skip all the
+	  questions about Allwinner media devices.
+
+if VIDEO_SUNXI
+
+source "drivers/staging/media/sunxi/cedrus/Kconfig"
+
+endif
diff --git a/drivers/staging/media/sunxi/Makefile b/drivers/staging/media/sunxi/Makefile
new file mode 100644
index 000000000000..cee2846c3ecf
--- /dev/null
+++ b/drivers/staging/media/sunxi/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_VIDEO_SUNXI_CEDRUS)	+= cedrus/
diff --git a/drivers/staging/media/sunxi/cedrus/Kconfig b/drivers/staging/media/sunxi/cedrus/Kconfig
new file mode 100644
index 000000000000..3b38312b76d3
--- /dev/null
+++ b/drivers/staging/media/sunxi/cedrus/Kconfig
@@ -0,0 +1,14 @@
+config VIDEO_SUNXI_CEDRUS
+	tristate "Allwinner Cedrus VPU driver"
+	depends on VIDEO_DEV && VIDEO_V4L2 && MEDIA_CONTROLLER
+	depends on HAS_DMA
+	depends on OF
+	select VIDEOBUF2_DMA_CONTIG
+	select MEDIA_REQUEST_API
+	select V4L2_MEM2MEM_DEV
+	help
+	  Support for the VPU found in Allwinner SoCs, also known as the Cedar
+	  video engine.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called cedrus.
diff --git a/drivers/staging/media/sunxi/cedrus/Makefile b/drivers/staging/media/sunxi/cedrus/Makefile
new file mode 100644
index 000000000000..632a0be90ed7
--- /dev/null
+++ b/drivers/staging/media/sunxi/cedrus/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_VIDEO_SUNXI_CEDRUS) += cedrus.o
+
+cedrus-y = cedrus.o cedrus_video.o cedrus_hw.o cedrus_dec.o cedrus_mpeg2.o
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/staging/media/sunxi/cedrus/cedrus.c
new file mode 100644
index 000000000000..9cd7c06371cb
--- /dev/null
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
@@ -0,0 +1,419 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Sunxi-Cedrus VPU driver
+ *
+ * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com>
+ * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.com>
+ *
+ * Based on the vim2m driver, that is:
+ *
+ * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
+ * Pawel Osciak, <pawel@osciak.com>
+ * Marek Szyprowski, <m.szyprowski@samsung.com>
+ */
+
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/of.h>
+
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-mem2mem.h>
+
+#include "cedrus.h"
+#include "cedrus_video.h"
+#include "cedrus_dec.h"
+#include "cedrus_hw.h"
+
+static const struct cedrus_control cedrus_controls[] = {
+	{
+		.id		= V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS,
+		.elem_size	= sizeof(struct v4l2_ctrl_mpeg2_slice_params),
+		.codec		= CEDRUS_CODEC_MPEG2,
+		.required	= true,
+	},
+	{
+		.id		= V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION,
+		.elem_size	= sizeof(struct v4l2_ctrl_mpeg2_quantization),
+		.codec		= CEDRUS_CODEC_MPEG2,
+		.required	= false,
+	},
+};
+
+#define CEDRUS_CONTROLS_COUNT	ARRAY_SIZE(cedrus_controls)
+
+void *cedrus_find_control_data(struct cedrus_ctx *ctx, u32 id)
+{
+	unsigned int i;
+
+	for (i = 0; ctx->ctrls[i] != NULL; i++)
+		if (ctx->ctrls[i]->id == id)
+			return ctx->ctrls[i]->p_cur.p;
+
+	return NULL;
+}
+
+static int cedrus_init_ctrls(struct cedrus_dev *dev, struct cedrus_ctx *ctx)
+{
+	struct v4l2_ctrl_handler *hdl = &ctx->hdl;
+	struct v4l2_ctrl *ctrl;
+	unsigned int ctrl_size;
+	unsigned int i;
+
+	v4l2_ctrl_handler_init(hdl, CEDRUS_CONTROLS_COUNT);
+	if (hdl->error) {
+		v4l2_err(&dev->v4l2_dev,
+			 "Failed to initialize control handler\n");
+		return hdl->error;
+	}
+
+	ctrl_size = sizeof(ctrl) * CEDRUS_CONTROLS_COUNT + 1;
+
+	ctx->ctrls = kzalloc(ctrl_size, GFP_KERNEL);
+	memset(ctx->ctrls, 0, ctrl_size);
+
+	for (i = 0; i < CEDRUS_CONTROLS_COUNT; i++) {
+		struct v4l2_ctrl_config cfg = { 0 };
+
+		cfg.elem_size = cedrus_controls[i].elem_size;
+		cfg.id = cedrus_controls[i].id;
+
+		ctrl = v4l2_ctrl_new_custom(hdl, &cfg, NULL);
+		if (hdl->error) {
+			v4l2_err(&dev->v4l2_dev,
+				 "Failed to create new custom control\n");
+
+			v4l2_ctrl_handler_free(hdl);
+			kfree(ctx->ctrls);
+			return hdl->error;
+		}
+
+		ctx->ctrls[i] = ctrl;
+	}
+
+	ctx->fh.ctrl_handler = hdl;
+	v4l2_ctrl_handler_setup(hdl);
+
+	return 0;
+}
+
+static int cedrus_request_validate(struct media_request *req)
+{
+	struct media_request_object *obj, *obj_safe;
+	struct v4l2_ctrl_handler *parent_hdl, *hdl;
+	struct cedrus_ctx *ctx = NULL;
+	struct v4l2_ctrl *ctrl_test;
+	unsigned int i;
+
+	list_for_each_entry_safe(obj, obj_safe, &req->objects, list) {
+		struct vb2_buffer *vb;
+
+		if (vb2_request_object_is_buffer(obj)) {
+			vb = container_of(obj, struct vb2_buffer, req_obj);
+			ctx = vb2_get_drv_priv(vb->vb2_queue);
+
+			break;
+		}
+	}
+
+	if (!ctx)
+		return -EINVAL;
+
+	parent_hdl = &ctx->hdl;
+
+	hdl = v4l2_ctrl_request_hdl_find(req, parent_hdl);
+	if (!hdl) {
+		v4l2_err(&ctx->dev->v4l2_dev, "Missing codec control(s)\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < CEDRUS_CONTROLS_COUNT; i++) {
+		if (cedrus_controls[i].codec != ctx->current_codec ||
+		    !cedrus_controls[i].required)
+			continue;
+
+		ctrl_test = v4l2_ctrl_request_hdl_ctrl_find(hdl,
+			cedrus_controls[i].id);
+		if (!ctrl_test) {
+			v4l2_err(&ctx->dev->v4l2_dev,
+				 "Missing required codec control\n");
+			return -EINVAL;
+		}
+	}
+
+	v4l2_ctrl_request_hdl_put(hdl);
+
+	return vb2_request_validate(req);
+}
+
+static int cedrus_open(struct file *file)
+{
+	struct cedrus_dev *dev = video_drvdata(file);
+	struct cedrus_ctx *ctx = NULL;
+	int ret;
+
+	if (mutex_lock_interruptible(&dev->dev_mutex))
+		return -ERESTARTSYS;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx) {
+		mutex_unlock(&dev->dev_mutex);
+		return -ENOMEM;
+	}
+
+	v4l2_fh_init(&ctx->fh, video_devdata(file));
+	file->private_data = &ctx->fh;
+	ctx->dev = dev;
+
+	ret = cedrus_init_ctrls(dev, ctx);
+	if (ret)
+		goto err_free;
+
+	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx,
+					    &cedrus_queue_init);
+	if (IS_ERR(ctx->fh.m2m_ctx)) {
+		ret = PTR_ERR(ctx->fh.m2m_ctx);
+		goto err_ctrls;
+	}
+
+	v4l2_fh_add(&ctx->fh);
+
+	mutex_unlock(&dev->dev_mutex);
+
+	return 0;
+
+err_ctrls:
+	v4l2_ctrl_handler_free(&ctx->hdl);
+err_free:
+	kfree(ctx);
+	mutex_unlock(&dev->dev_mutex);
+
+	return ret;
+}
+
+static int cedrus_release(struct file *file)
+{
+	struct cedrus_dev *dev = video_drvdata(file);
+	struct cedrus_ctx *ctx = container_of(file->private_data,
+					      struct cedrus_ctx, fh);
+
+	mutex_lock(&dev->dev_mutex);
+
+	v4l2_fh_del(&ctx->fh);
+	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
+
+	v4l2_ctrl_handler_free(&ctx->hdl);
+	kfree(ctx->ctrls);
+
+	v4l2_fh_exit(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+
+	kfree(ctx);
+
+	mutex_unlock(&dev->dev_mutex);
+
+	return 0;
+}
+
+static const struct v4l2_file_operations cedrus_fops = {
+	.owner		= THIS_MODULE,
+	.open		= cedrus_open,
+	.release	= cedrus_release,
+	.poll		= v4l2_m2m_fop_poll,
+	.unlocked_ioctl	= video_ioctl2,
+	.mmap		= v4l2_m2m_fop_mmap,
+};
+
+static const struct video_device cedrus_video_device = {
+	.name		= CEDRUS_NAME,
+	.vfl_dir	= VFL_DIR_M2M,
+	.fops		= &cedrus_fops,
+	.ioctl_ops	= &cedrus_ioctl_ops,
+	.minor		= -1,
+	.release	= video_device_release_empty,
+};
+
+static const struct v4l2_m2m_ops cedrus_m2m_ops = {
+	.device_run	= cedrus_device_run,
+	.job_abort	= cedrus_job_abort,
+};
+
+static const struct media_device_ops cedrus_m2m_media_ops = {
+	.req_validate	= cedrus_request_validate,
+	.req_queue	= vb2_m2m_request_queue,
+};
+
+static int cedrus_probe(struct platform_device *pdev)
+{
+	struct cedrus_dev *dev;
+	struct video_device *vfd;
+	int ret;
+
+	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	dev->dev = &pdev->dev;
+	dev->pdev = pdev;
+
+	ret = cedrus_hw_probe(dev);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to probe hardware\n");
+		return ret;
+	}
+
+	dev->dec_ops[CEDRUS_CODEC_MPEG2] = &cedrus_dec_ops_mpeg2;
+
+	mutex_init(&dev->dev_mutex);
+	spin_lock_init(&dev->irq_lock);
+
+	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to register V4L2 device\n");
+		return ret;
+	}
+
+	dev->vfd = cedrus_video_device;
+	vfd = &dev->vfd;
+	vfd->lock = &dev->dev_mutex;
+	vfd->v4l2_dev = &dev->v4l2_dev;
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
+		goto err_v4l2;
+	}
+
+	snprintf(vfd->name, sizeof(vfd->name), "%s", cedrus_video_device.name);
+	video_set_drvdata(vfd, dev);
+
+	v4l2_info(&dev->v4l2_dev,
+		  "Device registered as /dev/video%d\n", vfd->num);
+
+	dev->m2m_dev = v4l2_m2m_init(&cedrus_m2m_ops);
+	if (IS_ERR(dev->m2m_dev)) {
+		v4l2_err(&dev->v4l2_dev,
+			 "Failed to initialize V4L2 M2M device\n");
+		ret = PTR_ERR(dev->m2m_dev);
+
+		goto err_video;
+	}
+
+	dev->mdev.dev = &pdev->dev;
+	strlcpy(dev->mdev.model, CEDRUS_NAME, sizeof(dev->mdev.model));
+
+	media_device_init(&dev->mdev);
+	dev->mdev.ops = &cedrus_m2m_media_ops;
+	dev->v4l2_dev.mdev = &dev->mdev;
+
+	ret = v4l2_m2m_register_media_controller(dev->m2m_dev,
+			vfd, MEDIA_ENT_F_PROC_VIDEO_DECODER);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev,
+			 "Failed to initialize V4L2 M2M media controller\n");
+		goto err_m2m;
+	}
+
+	ret = media_device_register(&dev->mdev);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to register media device\n");
+		goto err_m2m_mc;
+	}
+
+	platform_set_drvdata(pdev, dev);
+
+	return 0;
+
+err_m2m_mc:
+	v4l2_m2m_unregister_media_controller(dev->m2m_dev);
+err_m2m:
+	v4l2_m2m_release(dev->m2m_dev);
+err_video:
+	video_unregister_device(&dev->vfd);
+err_v4l2:
+	v4l2_device_unregister(&dev->v4l2_dev);
+
+	return ret;
+}
+
+static int cedrus_remove(struct platform_device *pdev)
+{
+	struct cedrus_dev *dev = platform_get_drvdata(pdev);
+
+	if (media_devnode_is_registered(dev->mdev.devnode)) {
+		media_device_unregister(&dev->mdev);
+		v4l2_m2m_unregister_media_controller(dev->m2m_dev);
+		media_device_cleanup(&dev->mdev);
+	}
+
+	v4l2_m2m_release(dev->m2m_dev);
+	video_unregister_device(&dev->vfd);
+	v4l2_device_unregister(&dev->v4l2_dev);
+
+	cedrus_hw_remove(dev);
+
+	return 0;
+}
+
+static const struct cedrus_variant sun4i_a10_cedrus_variant = {
+	/* No particular capability. */
+};
+
+static const struct cedrus_variant sun5i_a13_cedrus_variant = {
+	/* No particular capability. */
+};
+
+static const struct cedrus_variant sun7i_a20_cedrus_variant = {
+	/* No particular capability. */
+};
+
+static const struct cedrus_variant sun8i_a33_cedrus_variant = {
+	.capabilities	= CEDRUS_CAPABILITY_UNTILED,
+};
+
+static const struct cedrus_variant sun8i_h3_cedrus_variant = {
+	.capabilities	= CEDRUS_CAPABILITY_UNTILED,
+};
+
+static const struct of_device_id cedrus_dt_match[] = {
+	{
+		.compatible = "allwinner,sun4i-a10-video-engine",
+		.data = &sun4i_a10_cedrus_variant,
+	},
+	{
+		.compatible = "allwinner,sun5i-a13-video-engine",
+		.data = &sun5i_a13_cedrus_variant,
+	},
+	{
+		.compatible = "allwinner,sun7i-a20-video-engine",
+		.data = &sun7i_a20_cedrus_variant,
+	},
+	{
+		.compatible = "allwinner,sun8i-a33-video-engine",
+		.data = &sun8i_a33_cedrus_variant,
+	},
+	{
+		.compatible = "allwinner,sun8i-h3-video-engine",
+		.data = &sun8i_h3_cedrus_variant,
+	},
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, cedrus_dt_match);
+
+static struct platform_driver cedrus_driver = {
+	.probe		= cedrus_probe,
+	.remove		= cedrus_remove,
+	.driver		= {
+		.name		= CEDRUS_NAME,
+		.owner		= THIS_MODULE,
+		.of_match_table	= of_match_ptr(cedrus_dt_match),
+	},
+};
+module_platform_driver(cedrus_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Florent Revest <florent.revest@free-electrons.com>");
+MODULE_AUTHOR("Paul Kocialkowski <paul.kocialkowski@bootlin.com>");
+MODULE_AUTHOR("Maxime Ripard <maxime.ripard@bootlin.com>");
+MODULE_DESCRIPTION("Sunxi-Cedrus VPU driver");
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.h b/drivers/staging/media/sunxi/cedrus/cedrus.h
new file mode 100644
index 000000000000..e8167a37fb39
--- /dev/null
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.h
@@ -0,0 +1,166 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Sunxi-Cedrus VPU driver
+ *
+ * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com>
+ * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.com>
+ *
+ * Based on the vim2m driver, that is:
+ *
+ * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
+ * Pawel Osciak, <pawel@osciak.com>
+ * Marek Szyprowski, <m.szyprowski@samsung.com>
+ */
+
+#ifndef _CEDRUS_H_
+#define _CEDRUS_H_
+
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/videobuf2-v4l2.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include <linux/platform_device.h>
+
+#define CEDRUS_NAME			"cedrus"
+
+#define CEDRUS_CAPABILITY_UNTILED	BIT(0)
+
+enum cedrus_codec {
+	CEDRUS_CODEC_MPEG2,
+
+	CEDRUS_CODEC_LAST,
+};
+
+enum cedrus_irq_status {
+	CEDRUS_IRQ_NONE,
+	CEDRUS_IRQ_ERROR,
+	CEDRUS_IRQ_OK,
+};
+
+struct cedrus_control {
+	u32			id;
+	u32			elem_size;
+	enum cedrus_codec	codec;
+	bool			required;
+};
+
+struct cedrus_mpeg2_run {
+	const struct v4l2_ctrl_mpeg2_slice_params	*slice_params;
+	const struct v4l2_ctrl_mpeg2_quantization	*quantization;
+};
+
+struct cedrus_run {
+	struct vb2_v4l2_buffer	*src;
+	struct vb2_v4l2_buffer	*dst;
+
+	union {
+		struct cedrus_mpeg2_run	mpeg2;
+	};
+};
+
+struct cedrus_buffer {
+	struct v4l2_m2m_buffer          m2m_buf;
+};
+
+struct cedrus_ctx {
+	struct v4l2_fh			fh;
+	struct cedrus_dev		*dev;
+
+	struct v4l2_pix_format_mplane	src_fmt;
+	struct v4l2_pix_format_mplane	dst_fmt;
+	enum cedrus_codec		current_codec;
+
+	struct v4l2_ctrl_handler	hdl;
+	struct v4l2_ctrl		**ctrls;
+
+	struct vb2_buffer		*dst_bufs[VIDEO_MAX_FRAME];
+
+	int				job_abort;
+};
+
+struct cedrus_dec_ops {
+	void (*irq_clear)(struct cedrus_ctx *ctx);
+	void (*irq_disable)(struct cedrus_ctx *ctx);
+	enum cedrus_irq_status (*irq_status)(struct cedrus_ctx *ctx);
+	void (*setup)(struct cedrus_ctx *ctx, struct cedrus_run *run);
+	int (*start)(struct cedrus_ctx *ctx);
+	void (*stop)(struct cedrus_ctx *ctx);
+	void (*trigger)(struct cedrus_ctx *ctx);
+};
+
+struct cedrus_variant {
+	unsigned int	capabilities;
+};
+
+struct cedrus_dev {
+	struct v4l2_device	v4l2_dev;
+	struct video_device	vfd;
+	struct media_device	mdev;
+	struct media_pad	pad[2];
+	struct platform_device	*pdev;
+	struct device		*dev;
+	struct v4l2_m2m_dev	*m2m_dev;
+	struct cedrus_dec_ops	*dec_ops[CEDRUS_CODEC_LAST];
+
+	/* Device file mutex */
+	struct mutex		dev_mutex;
+	/* Interrupt spinlock */
+	spinlock_t		irq_lock;
+
+	void __iomem		*base;
+
+	struct clk		*mod_clk;
+	struct clk		*ahb_clk;
+	struct clk		*ram_clk;
+
+	struct reset_control	*rstc;
+
+	unsigned int		capabilities;
+};
+
+extern struct cedrus_dec_ops cedrus_dec_ops_mpeg2;
+
+static inline void cedrus_write(struct cedrus_dev *dev, u32 reg, u32 val)
+{
+	writel(val, dev->base + reg);
+}
+
+static inline u32 cedrus_read(struct cedrus_dev *dev, u32 reg)
+{
+	return readl(dev->base + reg);
+}
+
+static inline dma_addr_t cedrus_buf_addr(struct vb2_buffer *buf,
+					 struct v4l2_pix_format_mplane *fmt,
+					 unsigned int plane)
+{
+	dma_addr_t addr = vb2_dma_contig_plane_dma_addr(buf, 0);
+
+	return addr + (fmt ? (dma_addr_t)fmt->plane_fmt[0].bytesperline *
+	       fmt->height * plane : 0);
+}
+
+static inline dma_addr_t cedrus_dst_buf_addr(struct cedrus_ctx *ctx,
+					     unsigned int index,
+					     unsigned int plane)
+{
+	struct vb2_buffer *buf = ctx->dst_bufs[index];
+
+	return buf ? cedrus_buf_addr(buf, &ctx->dst_fmt, plane) : 0;
+}
+
+static inline struct cedrus_buffer *vb2_v4l2_to_cedrus_buffer(const struct vb2_v4l2_buffer *p)
+{
+	return container_of(p, struct cedrus_buffer, m2m_buf.vb);
+}
+
+static inline struct cedrus_buffer *vb2_to_cedrus_buffer(const struct vb2_buffer *p)
+{
+	return vb2_v4l2_to_cedrus_buffer(to_vb2_v4l2_buffer(p));
+}
+
+void *cedrus_find_control_data(struct cedrus_ctx *ctx, u32 id);
+
+#endif
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
new file mode 100644
index 000000000000..ca57d8a6e1ca
--- /dev/null
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Sunxi-Cedrus VPU driver
+ *
+ * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com>
+ * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.com>
+ *
+ * Based on the vim2m driver, that is:
+ *
+ * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
+ * Pawel Osciak, <pawel@osciak.com>
+ * Marek Szyprowski, <m.szyprowski@samsung.com>
+ */
+
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-mem2mem.h>
+
+#include "cedrus.h"
+#include "cedrus_dec.h"
+#include "cedrus_hw.h"
+
+void cedrus_device_run(void *priv)
+{
+	struct cedrus_ctx *ctx = priv;
+	struct cedrus_dev *dev = ctx->dev;
+	struct cedrus_run run = { 0 };
+	struct media_request *src_req;
+	unsigned long flags;
+
+	run.src = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+	run.dst = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
+
+	/* Apply request(s) controls if needed. */
+	src_req = run.src->vb2_buf.req_obj.req;
+
+	if (src_req)
+		v4l2_ctrl_request_setup(src_req, &ctx->hdl);
+
+	ctx->job_abort = 0;
+
+	spin_lock_irqsave(&ctx->dev->irq_lock, flags);
+
+	switch (ctx->src_fmt.pixelformat) {
+	case V4L2_PIX_FMT_MPEG2_SLICE:
+		run.mpeg2.slice_params = cedrus_find_control_data(ctx,
+			V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS);
+		run.mpeg2.quantization = cedrus_find_control_data(ctx,
+			V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION);
+		break;
+
+	default:
+		ctx->job_abort = 1;
+	}
+
+	if (!ctx->job_abort)
+		dev->dec_ops[ctx->current_codec]->setup(ctx, &run);
+
+	spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
+
+	/* Complete request(s) controls if needed. */
+
+	if (src_req)
+		v4l2_ctrl_request_complete(src_req, &ctx->hdl);
+
+	spin_lock_irqsave(&ctx->dev->irq_lock, flags);
+
+	if (!ctx->job_abort) {
+		dev->dec_ops[ctx->current_codec]->trigger(ctx);
+	} else {
+		v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+		v4l2_m2m_buf_done(run.src, VB2_BUF_STATE_ERROR);
+
+		v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+		v4l2_m2m_buf_done(run.dst, VB2_BUF_STATE_ERROR);
+	}
+
+	spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
+
+	if (ctx->job_abort)
+		v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->fh.m2m_ctx);
+}
+
+void cedrus_job_abort(void *priv)
+{
+	struct cedrus_ctx *ctx = priv;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
+	unsigned long flags;
+
+	ctx->job_abort = 1;
+
+	/*
+	 * V4L2 M2M and request API cleanup is done here while hardware state
+	 * cleanup is done in the interrupt context. Doing all the cleanup in
+	 * the interrupt context is a bit risky, since the job_abort call might
+	 * originate from the release hook, where interrupts have already been
+	 * disabled.
+	 */
+
+	spin_lock_irqsave(&ctx->dev->irq_lock, flags);
+
+	src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+	if (src_buf)
+		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
+
+	dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+	if (dst_buf)
+		v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
+
+	spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
+
+	v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->fh.m2m_ctx);
+}
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.h b/drivers/staging/media/sunxi/cedrus/cedrus_dec.h
new file mode 100644
index 000000000000..b38812136504
--- /dev/null
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Sunxi-Cedrus VPU driver
+ *
+ * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com>
+ * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.com>
+ *
+ * Based on the vim2m driver, that is:
+ *
+ * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
+ * Pawel Osciak, <pawel@osciak.com>
+ * Marek Szyprowski, <m.szyprowski@samsung.com>
+ */
+
+#ifndef _CEDRUS_DEC_H_
+#define _CEDRUS_DEC_H_
+
+extern const struct v4l2_ioctl_ops cedrus_ioctl_ops;
+
+void cedrus_device_work(struct work_struct *work);
+void cedrus_device_run(void *priv);
+void cedrus_job_abort(void *priv);
+
+int cedrus_queue_init(void *priv, struct vb2_queue *src_vq,
+		      struct vb2_queue *dst_vq);
+
+#endif
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_hw.c b/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
new file mode 100644
index 000000000000..7cb866403cd9
--- /dev/null
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
@@ -0,0 +1,319 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Sunxi-Cedrus VPU driver
+ *
+ * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com>
+ * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.com>
+ *
+ * Based on the vim2m driver, that is:
+ *
+ * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
+ * Pawel Osciak, <pawel@osciak.com>
+ * Marek Szyprowski, <m.szyprowski@samsung.com>
+ */
+
+#include <linux/platform_device.h>
+#include <linux/of_reserved_mem.h>
+#include <linux/of_device.h>
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/clk.h>
+#include <linux/regmap.h>
+#include <linux/reset.h>
+#include <linux/soc/sunxi/sunxi_sram.h>
+
+#include <media/videobuf2-core.h>
+#include <media/v4l2-mem2mem.h>
+
+#include "cedrus.h"
+#include "cedrus_hw.h"
+#include "cedrus_regs.h"
+
+int cedrus_engine_enable(struct cedrus_dev *dev, enum cedrus_codec codec)
+{
+	u32 reg = 0;
+
+	reg |= VE_MODE_REC_WR_MODE_2MB;
+	reg |= VE_MODE_DDR_MODE_BW_128;
+
+	switch (codec) {
+	case CEDRUS_CODEC_MPEG2:
+		reg |= VE_MODE_DEC_MPEG;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	cedrus_write(dev, VE_MODE, reg);
+
+	return 0;
+}
+
+void cedrus_engine_disable(struct cedrus_dev *dev)
+{
+	cedrus_write(dev, VE_MODE, VE_MODE_DISABLED);
+}
+
+void cedrus_dst_format_set(struct cedrus_dev *dev,
+			   struct v4l2_pix_format_mplane *fmt)
+{
+	unsigned int width = fmt->width;
+	unsigned int height = fmt->height;
+	u32 chroma_size;
+	u32 reg;
+
+	switch (fmt->pixelformat) {
+	case V4L2_PIX_FMT_NV12:
+		chroma_size = ALIGN(width, 32) * ALIGN(height / 2, 32);
+
+		reg = VE_PRIMARY_OUT_FMT_NV12 |
+		      VE_SECONDARY_SPECIAL_OUT_FMT_NV12;
+		cedrus_write(dev, VE_PRIMARY_OUT_FMT, reg);
+
+		reg = VE_CHROMA_BUF_LEN_SDRT(chroma_size / 2) |
+		      VE_SECONDARY_OUT_FMT_SPECIAL;
+		cedrus_write(dev, VE_CHROMA_BUF_LEN, reg);
+
+		reg = chroma_size / 2;
+		cedrus_write(dev, VE_PRIMARY_CHROMA_BUF_LEN, reg);
+
+		reg = VE_PRIMARY_FB_LINE_STRIDE_LUMA(ALIGN(width, 32)) |
+		      VE_PRIMARY_FB_LINE_STRIDE_CHROMA(ALIGN(width / 2, 16));
+		cedrus_write(dev, VE_PRIMARY_FB_LINE_STRIDE, reg);
+
+		break;
+	case V4L2_PIX_FMT_MB32_NV12:
+	default:
+		reg = VE_PRIMARY_OUT_FMT_MB32_NV12;
+		cedrus_write(dev, VE_PRIMARY_OUT_FMT, reg);
+
+		reg = VE_SECONDARY_OUT_FMT_MB32_NV12;
+		cedrus_write(dev, VE_CHROMA_BUF_LEN, reg);
+
+		break;
+	}
+}
+
+static irqreturn_t cedrus_bh(int irq, void *data)
+{
+	struct cedrus_dev *dev = data;
+	struct cedrus_ctx *ctx;
+
+	ctx = v4l2_m2m_get_curr_priv(dev->m2m_dev);
+	if (!ctx) {
+		v4l2_err(&dev->v4l2_dev,
+			 "Instance released before the end of transaction\n");
+		return IRQ_HANDLED;
+	}
+
+	v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->fh.m2m_ctx);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t cedrus_irq(int irq, void *data)
+{
+	struct cedrus_dev *dev = data;
+	struct cedrus_ctx *ctx;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
+	enum vb2_buffer_state state;
+	enum cedrus_irq_status status;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->irq_lock, flags);
+
+	ctx = v4l2_m2m_get_curr_priv(dev->m2m_dev);
+	if (!ctx) {
+		v4l2_err(&dev->v4l2_dev,
+			 "Instance released before the end of transaction\n");
+		spin_unlock_irqrestore(&dev->irq_lock, flags);
+
+		return IRQ_NONE;
+	}
+
+	status = dev->dec_ops[ctx->current_codec]->irq_status(ctx);
+	if (status == CEDRUS_IRQ_NONE) {
+		spin_unlock_irqrestore(&dev->irq_lock, flags);
+		return IRQ_NONE;
+	}
+
+	dev->dec_ops[ctx->current_codec]->irq_disable(ctx);
+	dev->dec_ops[ctx->current_codec]->irq_clear(ctx);
+
+	src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+	dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+
+	if (!src_buf || !dst_buf) {
+		v4l2_err(&dev->v4l2_dev,
+			 "Missing source and/or destination buffers\n");
+		spin_unlock_irqrestore(&dev->irq_lock, flags);
+
+		return IRQ_HANDLED;
+	}
+
+	if (ctx->job_abort || status == CEDRUS_IRQ_ERROR)
+		state = VB2_BUF_STATE_ERROR;
+	else
+		state = VB2_BUF_STATE_DONE;
+
+	v4l2_m2m_buf_done(src_buf, state);
+	v4l2_m2m_buf_done(dst_buf, state);
+
+	spin_unlock_irqrestore(&dev->irq_lock, flags);
+
+	return IRQ_WAKE_THREAD;
+}
+
+int cedrus_hw_probe(struct cedrus_dev *dev)
+{
+	const struct cedrus_variant *variant;
+	struct resource *res;
+	int irq_dec;
+	int ret;
+
+	variant = of_device_get_match_data(dev->dev);
+	if (!variant)
+		return -EINVAL;
+
+	dev->capabilities = variant->capabilities;
+
+	irq_dec = platform_get_irq(dev->pdev, 0);
+	if (irq_dec <= 0) {
+		v4l2_err(&dev->v4l2_dev, "Failed to get IRQ\n");
+
+		return irq_dec;
+	}
+	ret = devm_request_threaded_irq(dev->dev, irq_dec, cedrus_irq,
+					cedrus_bh, 0, dev_name(dev->dev),
+					dev);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to request IRQ\n");
+
+		return ret;
+	}
+
+	/*
+	 * The VPU is only able to handle bus addresses so we have to subtract
+	 * the RAM offset to the physcal addresses.
+	 */
+	dev->dev->dma_pfn_offset = PHYS_PFN_OFFSET;
+
+	ret = of_reserved_mem_device_init(dev->dev);
+	if (ret && ret != -ENODEV) {
+		v4l2_err(&dev->v4l2_dev, "Failed to reserve memory\n");
+
+		return ret;
+	}
+
+	ret = sunxi_sram_claim(dev->dev);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to claim SRAM\n");
+
+		goto err_mem;
+	}
+
+	dev->ahb_clk = devm_clk_get(dev->dev, "ahb");
+	if (IS_ERR(dev->ahb_clk)) {
+		v4l2_err(&dev->v4l2_dev, "Failed to get AHB clock\n");
+
+		ret = PTR_ERR(dev->ahb_clk);
+		goto err_sram;
+	}
+
+	dev->mod_clk = devm_clk_get(dev->dev, "mod");
+	if (IS_ERR(dev->mod_clk)) {
+		v4l2_err(&dev->v4l2_dev, "Failed to get MOD clock\n");
+
+		ret = PTR_ERR(dev->mod_clk);
+		goto err_sram;
+	}
+
+	dev->ram_clk = devm_clk_get(dev->dev, "ram");
+	if (IS_ERR(dev->ram_clk)) {
+		v4l2_err(&dev->v4l2_dev, "Failed to get RAM clock\n");
+
+		ret = PTR_ERR(dev->ram_clk);
+		goto err_sram;
+	}
+
+	dev->rstc = devm_reset_control_get(dev->dev, NULL);
+	if (IS_ERR(dev->rstc)) {
+		v4l2_err(&dev->v4l2_dev, "Failed to get reset control\n");
+
+		ret = PTR_ERR(dev->rstc);
+		goto err_sram;
+	}
+
+	res = platform_get_resource(dev->pdev, IORESOURCE_MEM, 0);
+	dev->base = devm_ioremap_resource(dev->dev, res);
+	if (!dev->base) {
+		v4l2_err(&dev->v4l2_dev, "Failed to map registers\n");
+
+		ret = -ENOMEM;
+		goto err_sram;
+	}
+
+	ret = clk_set_rate(dev->mod_clk, CEDRUS_CLOCK_RATE_DEFAULT);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to set clock rate\n");
+
+		goto err_sram;
+	}
+
+	ret = clk_prepare_enable(dev->ahb_clk);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to enable AHB clock\n");
+
+		goto err_sram;
+	}
+
+	ret = clk_prepare_enable(dev->mod_clk);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to enable MOD clock\n");
+
+		goto err_ahb_clk;
+	}
+
+	ret = clk_prepare_enable(dev->ram_clk);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to enable RAM clock\n");
+
+		goto err_mod_clk;
+	}
+
+	ret = reset_control_reset(dev->rstc);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to apply reset\n");
+
+		goto err_ram_clk;
+	}
+
+	return 0;
+
+err_ram_clk:
+	clk_disable_unprepare(dev->ram_clk);
+err_mod_clk:
+	clk_disable_unprepare(dev->mod_clk);
+err_ahb_clk:
+	clk_disable_unprepare(dev->ahb_clk);
+err_sram:
+	sunxi_sram_release(dev->dev);
+err_mem:
+	of_reserved_mem_device_release(dev->dev);
+
+	return ret;
+}
+
+void cedrus_hw_remove(struct cedrus_dev *dev)
+{
+	reset_control_assert(dev->rstc);
+
+	clk_disable_unprepare(dev->ram_clk);
+	clk_disable_unprepare(dev->mod_clk);
+	clk_disable_unprepare(dev->ahb_clk);
+
+	sunxi_sram_release(dev->dev);
+
+	of_reserved_mem_device_release(dev->dev);
+}
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_hw.h b/drivers/staging/media/sunxi/cedrus/cedrus_hw.h
new file mode 100644
index 000000000000..9704f1e0921c
--- /dev/null
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_hw.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Sunxi-Cedrus VPU driver
+ *
+ * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com>
+ * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.com>
+ *
+ * Based on the vim2m driver, that is:
+ *
+ * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
+ * Pawel Osciak, <pawel@osciak.com>
+ * Marek Szyprowski, <m.szyprowski@samsung.com>
+ */
+
+#ifndef _CEDRUS_HW_H_
+#define _CEDRUS_HW_H_
+
+#define CEDRUS_CLOCK_RATE_DEFAULT	320000000
+
+int cedrus_engine_enable(struct cedrus_dev *dev, enum cedrus_codec codec);
+void cedrus_engine_disable(struct cedrus_dev *dev);
+
+void cedrus_dst_format_set(struct cedrus_dev *dev,
+			   struct v4l2_pix_format_mplane *fmt);
+
+int cedrus_hw_probe(struct cedrus_dev *dev);
+void cedrus_hw_remove(struct cedrus_dev *dev);
+
+#endif
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
new file mode 100644
index 000000000000..ca329c0d4699
--- /dev/null
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
@@ -0,0 +1,240 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Sunxi-Cedrus VPU driver
+ *
+ * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com>
+ * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.com>
+ *
+ * Based on the vim2m driver, that is:
+ *
+ * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
+ * Pawel Osciak, <pawel@osciak.com>
+ * Marek Szyprowski, <m.szyprowski@samsung.com>
+ */
+
+#include <media/videobuf2-dma-contig.h>
+
+#include "cedrus.h"
+#include "cedrus_hw.h"
+#include "cedrus_regs.h"
+
+static const u8 intra_quantization_matrix_default[64] = {
+	8,  16, 16, 19, 16, 19, 22, 22,
+	22, 22, 22, 22, 26, 24, 26, 27,
+	27, 27, 26, 26, 26, 26, 27, 27,
+	27, 29, 29, 29, 34, 34, 34, 29,
+	29, 29, 27, 27, 29, 29, 32, 32,
+	34, 34, 37, 38, 37, 35, 35, 34,
+	35, 38, 38, 40, 40, 40, 48, 48,
+	46, 46, 56, 56, 58, 69, 69, 83
+};
+
+static const u8 non_intra_quantization_matrix_default[64] = {
+	16, 16, 16, 16, 16, 16, 16, 16,
+	16, 16, 16, 16, 16, 16, 16, 16,
+	16, 16, 16, 16, 16, 16, 16, 16,
+	16, 16, 16, 16, 16, 16, 16, 16,
+	16, 16, 16, 16, 16, 16, 16, 16,
+	16, 16, 16, 16, 16, 16, 16, 16,
+	16, 16, 16, 16, 16, 16, 16, 16,
+	16, 16, 16, 16, 16, 16, 16, 16
+};
+
+static enum cedrus_irq_status cedrus_mpeg2_irq_status(struct cedrus_ctx *ctx)
+{
+	struct cedrus_dev *dev = ctx->dev;
+	u32 reg;
+
+	reg = cedrus_read(dev, VE_DEC_MPEG_STATUS);
+	reg &= VE_DEC_MPEG_STATUS_CHECK_MASK;
+
+	if (!reg)
+		return CEDRUS_IRQ_NONE;
+
+	if (reg & VE_DEC_MPEG_STATUS_CHECK_ERROR ||
+	    !(reg & VE_DEC_MPEG_STATUS_SUCCESS))
+		return CEDRUS_IRQ_ERROR;
+
+	return CEDRUS_IRQ_OK;
+}
+
+static void cedrus_mpeg2_irq_clear(struct cedrus_ctx *ctx)
+{
+	struct cedrus_dev *dev = ctx->dev;
+
+	cedrus_write(dev, VE_DEC_MPEG_STATUS, VE_DEC_MPEG_STATUS_CHECK_MASK);
+}
+
+static void cedrus_mpeg2_irq_disable(struct cedrus_ctx *ctx)
+{
+	struct cedrus_dev *dev = ctx->dev;
+	u32 reg = cedrus_read(dev, VE_DEC_MPEG_CTRL);
+
+	reg &= ~VE_DEC_MPEG_CTRL_IRQ_MASK;
+
+	cedrus_write(dev, VE_DEC_MPEG_CTRL, reg);
+}
+
+static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
+{
+	const struct v4l2_ctrl_mpeg2_slice_params *slice_params;
+	const struct v4l2_ctrl_mpeg2_quantization *quantization;
+	dma_addr_t src_buf_addr, dst_luma_addr, dst_chroma_addr;
+	dma_addr_t fwd_luma_addr, fwd_chroma_addr;
+	dma_addr_t bwd_luma_addr, bwd_chroma_addr;
+	struct cedrus_dev *dev = ctx->dev;
+	u32 vld_end, vld_len;
+	const u8 *matrix;
+	unsigned int i;
+	u32 reg;
+
+	slice_params = run->mpeg2.slice_params;
+	quantization = run->mpeg2.quantization;
+
+	/* Activate MPEG engine. */
+	cedrus_engine_enable(dev, CEDRUS_CODEC_MPEG2);
+
+	/* Set intra quantization matrix. */
+
+	if (quantization && quantization->load_intra_quantiser_matrix)
+		matrix = quantization->intra_quantiser_matrix;
+	else
+		matrix = intra_quantization_matrix_default;
+
+	for (i = 0; i < 64; i++) {
+		reg = VE_DEC_MPEG_IQMINPUT_WEIGHT(i, matrix[i]);
+		reg |= VE_DEC_MPEG_IQMINPUT_FLAG_INTRA;
+
+		cedrus_write(dev, VE_DEC_MPEG_IQMINPUT, reg);
+	}
+
+	/* Set non-intra quantization matrix. */
+
+	if (quantization && quantization->load_non_intra_quantiser_matrix)
+		matrix = quantization->non_intra_quantiser_matrix;
+	else
+		matrix = non_intra_quantization_matrix_default;
+
+	for (i = 0; i < 64; i++) {
+		reg = VE_DEC_MPEG_IQMINPUT_WEIGHT(i, matrix[i]);
+		reg |= VE_DEC_MPEG_IQMINPUT_FLAG_NON_INTRA;
+
+		cedrus_write(dev, VE_DEC_MPEG_IQMINPUT, reg);
+	}
+
+	/* Set MPEG picture header. */
+
+	reg = VE_DEC_MPEG_MP12HDR_SLICE_TYPE(slice_params->slice_type);
+	reg |= VE_DEC_MPEG_MP12HDR_F_CODE(0, 0, slice_params->f_code[0][0]);
+	reg |= VE_DEC_MPEG_MP12HDR_F_CODE(0, 1, slice_params->f_code[0][1]);
+	reg |= VE_DEC_MPEG_MP12HDR_F_CODE(1, 0, slice_params->f_code[1][0]);
+	reg |= VE_DEC_MPEG_MP12HDR_F_CODE(1, 1, slice_params->f_code[1][1]);
+	reg |= VE_DEC_MPEG_MP12HDR_INTRA_DC_PRECISION(slice_params->intra_dc_precision);
+	reg |= VE_DEC_MPEG_MP12HDR_INTRA_PICTURE_STRUCTURE(slice_params->picture_structure);
+	reg |= VE_DEC_MPEG_MP12HDR_TOP_FIELD_FIRST(slice_params->top_field_first);
+	reg |= VE_DEC_MPEG_MP12HDR_FRAME_PRED_FRAME_DCT(slice_params->frame_pred_frame_dct);
+	reg |= VE_DEC_MPEG_MP12HDR_CONCEALMENT_MOTION_VECTORS(slice_params->concealment_motion_vectors);
+	reg |= VE_DEC_MPEG_MP12HDR_Q_SCALE_TYPE(slice_params->q_scale_type);
+	reg |= VE_DEC_MPEG_MP12HDR_INTRA_VLC_FORMAT(slice_params->intra_vlc_format);
+	reg |= VE_DEC_MPEG_MP12HDR_ALTERNATE_SCAN(slice_params->alternate_scan);
+	reg |= VE_DEC_MPEG_MP12HDR_FULL_PEL_FORWARD_VECTOR(0);
+	reg |= VE_DEC_MPEG_MP12HDR_FULL_PEL_BACKWARD_VECTOR(0);
+
+	cedrus_write(dev, VE_DEC_MPEG_MP12HDR, reg);
+
+	/* Set frame dimensions. */
+
+	reg = VE_DEC_MPEG_PICCODEDSIZE_WIDTH(slice_params->width);
+	reg |= VE_DEC_MPEG_PICCODEDSIZE_HEIGHT(slice_params->height);
+
+	cedrus_write(dev, VE_DEC_MPEG_PICCODEDSIZE, reg);
+
+	reg = VE_DEC_MPEG_PICBOUNDSIZE_WIDTH(slice_params->width);
+	reg |= VE_DEC_MPEG_PICBOUNDSIZE_HEIGHT(slice_params->height);
+
+	cedrus_write(dev, VE_DEC_MPEG_PICBOUNDSIZE, reg);
+
+	/* Forward and backward prediction reference buffers. */
+
+	fwd_luma_addr = cedrus_dst_buf_addr(ctx, slice_params->forward_ref_index, 0);
+	fwd_chroma_addr = cedrus_dst_buf_addr(ctx, slice_params->forward_ref_index, 1);
+
+	cedrus_write(dev, VE_DEC_MPEG_FWD_REF_LUMA_ADDR, fwd_luma_addr);
+	cedrus_write(dev, VE_DEC_MPEG_FWD_REF_CHROMA_ADDR, fwd_chroma_addr);
+
+	bwd_luma_addr = cedrus_dst_buf_addr(ctx, slice_params->backward_ref_index, 0);
+	bwd_chroma_addr = cedrus_dst_buf_addr(ctx, slice_params->backward_ref_index, 1);
+
+	cedrus_write(dev, VE_DEC_MPEG_BWD_REF_LUMA_ADDR, bwd_luma_addr);
+	cedrus_write(dev, VE_DEC_MPEG_BWD_REF_CHROMA_ADDR, bwd_chroma_addr);
+
+	/* Destination luma and chroma buffers. */
+
+	dst_luma_addr = cedrus_dst_buf_addr(ctx, run->dst->vb2_buf.index, 0);
+	dst_chroma_addr = cedrus_dst_buf_addr(ctx, run->dst->vb2_buf.index, 1);
+
+	cedrus_write(dev, VE_DEC_MPEG_REC_LUMA, dst_luma_addr);
+	cedrus_write(dev, VE_DEC_MPEG_REC_CHROMA, dst_chroma_addr);
+
+	cedrus_write(dev, VE_DEC_MPEG_ROT_LUMA, dst_luma_addr);
+	cedrus_write(dev, VE_DEC_MPEG_ROT_CHROMA, dst_chroma_addr);
+
+	/* Source offset and length in bits. */
+
+	cedrus_write(dev, VE_DEC_MPEG_VLD_OFFSET, slice_params->slice_pos);
+
+	vld_len = slice_params->slice_len - slice_params->slice_pos;
+	cedrus_write(dev, VE_DEC_MPEG_VLD_LEN, vld_len);
+
+	/* Source beginning and end addresses. */
+
+	src_buf_addr = vb2_dma_contig_plane_dma_addr(&run->src->vb2_buf, 0);
+
+	reg = VE_DEC_MPEG_VLD_ADDR_BASE(src_buf_addr);
+	reg |= VE_DEC_MPEG_VLD_ADDR_VALID_PIC_DATA;
+	reg |= VE_DEC_MPEG_VLD_ADDR_LAST_PIC_DATA;
+	reg |= VE_DEC_MPEG_VLD_ADDR_FIRST_PIC_DATA;
+
+	cedrus_write(dev, VE_DEC_MPEG_VLD_ADDR, reg);
+
+	vld_end = src_buf_addr + DIV_ROUND_UP(slice_params->slice_len, 8);
+	cedrus_write(dev, VE_DEC_MPEG_VLD_END, vld_end);
+
+	/* Macroblock address: start at the beginning. */
+	reg = VE_DEC_MPEG_MBADDR_Y(0) | VE_DEC_MPEG_MBADDR_X(0);
+	cedrus_write(dev, VE_DEC_MPEG_MBADDR, reg);
+
+	/* Clear previous errors. */
+	cedrus_write(dev, VE_DEC_MPEG_ERROR, 0);
+
+	/* Clear correct macroblocks register. */
+	cedrus_write(dev, VE_DEC_MPEG_CRTMBADDR, 0);
+
+	/* Enable appropriate interruptions and components. */
+
+	reg = VE_DEC_MPEG_CTRL_IRQ_MASK | VE_DEC_MPEG_CTRL_MC_NO_WRITEBACK |
+	      VE_DEC_MPEG_CTRL_ROTATE_SCALE_OUT_EN |
+	      VE_DEC_MPEG_CTRL_MC_CACHE_EN;
+
+	cedrus_write(dev, VE_DEC_MPEG_CTRL, reg);
+}
+
+static void cedrus_mpeg2_trigger(struct cedrus_ctx *ctx)
+{
+	struct cedrus_dev *dev = ctx->dev;
+	u32 reg;
+
+	/* Trigger MPEG engine. */
+	reg = VE_DEC_MPEG_TRIGGER_HW_MPEG_VLD | VE_DEC_MPEG_TRIGGER_MPEG2 |
+	      VE_DEC_MPEG_TRIGGER_MB_BOUNDARY;
+
+	cedrus_write(dev, VE_DEC_MPEG_TRIGGER, reg);
+}
+
+struct cedrus_dec_ops cedrus_dec_ops_mpeg2 = {
+	.irq_clear	= cedrus_mpeg2_irq_clear,
+	.irq_disable	= cedrus_mpeg2_irq_disable,
+	.irq_status	= cedrus_mpeg2_irq_status,
+	.setup		= cedrus_mpeg2_setup,
+	.trigger	= cedrus_mpeg2_trigger,
+};
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_regs.h b/drivers/staging/media/sunxi/cedrus/cedrus_regs.h
new file mode 100644
index 000000000000..b670cf2a51bc
--- /dev/null
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_regs.h
@@ -0,0 +1,235 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Sunxi-Cedrus VPU driver
+ *
+ * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com>
+ * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.com>
+ * Copyright (c) 2013-2016 Jens Kuske <jenskuske@gmail.com>
+ */
+
+#ifndef _CEDRUS_REGS_H_
+#define _CEDRUS_REGS_H_
+
+/*
+ * Common acronyms used in register descriptions:
+ * * VLD : Variable-Length Decoder
+ * * IQ: Inverse Quantization
+ * * IDCT: Inverse Discrete Cosine Transform
+ * * MC: Motion Compensation
+ * * STCD: Start Code Detect
+ * * SDRT: Scale Down and Rotate
+ */
+
+#define VE_ENGINE_DEC_MPEG			0x100
+#define VE_ENGINE_DEC_H264			0x200
+
+#define VE_MODE					0x00
+
+#define VE_MODE_REC_WR_MODE_2MB			(0x01 << 20)
+#define VE_MODE_REC_WR_MODE_1MB			(0x00 << 20)
+#define VE_MODE_DDR_MODE_BW_128			(0x03 << 16)
+#define VE_MODE_DDR_MODE_BW_256			(0x02 << 16)
+#define VE_MODE_DISABLED			(0x07 << 0)
+#define VE_MODE_DEC_H265			(0x04 << 0)
+#define VE_MODE_DEC_H264			(0x01 << 0)
+#define VE_MODE_DEC_MPEG			(0x00 << 0)
+
+#define VE_PRIMARY_CHROMA_BUF_LEN		0xc4
+#define VE_PRIMARY_FB_LINE_STRIDE		0xc8
+
+#define VE_PRIMARY_FB_LINE_STRIDE_CHROMA(s)	(((s) << 16) & GENMASK(31, 16))
+#define VE_PRIMARY_FB_LINE_STRIDE_LUMA(s)	(((s) << 0) & GENMASK(15, 0))
+
+#define VE_CHROMA_BUF_LEN			0xe8
+
+#define VE_SECONDARY_OUT_FMT_MB32_NV12		(0x00 << 30)
+#define VE_SECONDARY_OUT_FMT_SPECIAL		(0x01 << 30)
+#define VE_SECONDARY_OUT_FMT_YU12		(0x02 << 30)
+#define VE_SECONDARY_OUT_FMT_YV12		(0x03 << 30)
+#define VE_CHROMA_BUF_LEN_SDRT(l)		((l) & GENMASK(27, 0))
+
+#define VE_PRIMARY_OUT_FMT			0xec
+
+#define VE_PRIMARY_OUT_FMT_MB32_NV12		(0x00 << 4)
+#define VE_PRIMARY_OUT_FMT_MB128_NV12		(0x01 << 4)
+#define VE_PRIMARY_OUT_FMT_YU12			(0x02 << 4)
+#define VE_PRIMARY_OUT_FMT_YV12			(0x03 << 4)
+#define VE_PRIMARY_OUT_FMT_NV12			(0x04 << 4)
+#define VE_PRIMARY_OUT_FMT_NV21			(0x05 << 4)
+#define VE_SECONDARY_SPECIAL_OUT_FMT_MB32_NV12	(0x00 << 0)
+#define VE_SECONDARY_SPECIAL_OUT_FMT_MB128_NV12	(0x01 << 0)
+#define VE_SECONDARY_SPECIAL_OUT_FMT_YU12	(0x02 << 0)
+#define VE_SECONDARY_SPECIAL_OUT_FMT_YV12	(0x03 << 0)
+#define VE_SECONDARY_SPECIAL_OUT_FMT_NV12	(0x04 << 0)
+#define VE_SECONDARY_SPECIAL_OUT_FMT_NV21	(0x05 << 0)
+
+#define VE_VERSION				0xf0
+
+#define VE_VERSION_SHIFT			16
+
+#define VE_DEC_MPEG_MP12HDR			(VE_ENGINE_DEC_MPEG + 0x00)
+
+#define VE_DEC_MPEG_MP12HDR_SLICE_TYPE(t)	(((t) << 28) & GENMASK(30, 28))
+#define VE_DEC_MPEG_MP12HDR_F_CODE_SHIFT(x, y)	(24 - 4 * (y) - 8 * (x))
+#define VE_DEC_MPEG_MP12HDR_F_CODE_MASK(x, y) \
+	GENMASK(VE_DEC_MPEG_MP12HDR_F_CODE_SHIFT(x, y) + 3, \
+		VE_DEC_MPEG_MP12HDR_F_CODE_SHIFT(x, y))
+#define VE_DEC_MPEG_MP12HDR_F_CODE(x, y, v) \
+	(((v) << VE_DEC_MPEG_MP12HDR_F_CODE_SHIFT(x, y)) & \
+	 VE_DEC_MPEG_MP12HDR_F_CODE_MASK(x, y))
+#define VE_DEC_MPEG_MP12HDR_INTRA_DC_PRECISION(p) \
+	(((p) << 10) & GENMASK(11, 10))
+#define VE_DEC_MPEG_MP12HDR_INTRA_PICTURE_STRUCTURE(s) \
+	(((s) << 8) & GENMASK(9, 8))
+#define VE_DEC_MPEG_MP12HDR_TOP_FIELD_FIRST(v) \
+	((v) ? BIT(7) : 0)
+#define VE_DEC_MPEG_MP12HDR_FRAME_PRED_FRAME_DCT(v) \
+	((v) ? BIT(6) : 0)
+#define VE_DEC_MPEG_MP12HDR_CONCEALMENT_MOTION_VECTORS(v) \
+	((v) ? BIT(5) : 0)
+#define VE_DEC_MPEG_MP12HDR_Q_SCALE_TYPE(v) \
+	((v) ? BIT(4) : 0)
+#define VE_DEC_MPEG_MP12HDR_INTRA_VLC_FORMAT(v) \
+	((v) ? BIT(3) : 0)
+#define VE_DEC_MPEG_MP12HDR_ALTERNATE_SCAN(v) \
+	((v) ? BIT(2) : 0)
+#define VE_DEC_MPEG_MP12HDR_FULL_PEL_FORWARD_VECTOR(v) \
+	((v) ? BIT(1) : 0)
+#define VE_DEC_MPEG_MP12HDR_FULL_PEL_BACKWARD_VECTOR(v) \
+	((v) ? BIT(0) : 0)
+
+#define VE_DEC_MPEG_PICCODEDSIZE		(VE_ENGINE_DEC_MPEG + 0x08)
+
+#define VE_DEC_MPEG_PICCODEDSIZE_WIDTH(w) \
+	((DIV_ROUND_UP((w), 16) << 8) & GENMASK(15, 8))
+#define VE_DEC_MPEG_PICCODEDSIZE_HEIGHT(h) \
+	((DIV_ROUND_UP((h), 16) << 0) & GENMASK(7, 0))
+
+#define VE_DEC_MPEG_PICBOUNDSIZE		(VE_ENGINE_DEC_MPEG + 0x0c)
+
+#define VE_DEC_MPEG_PICBOUNDSIZE_WIDTH(w)	(((w) << 16) & GENMASK(27, 16))
+#define VE_DEC_MPEG_PICBOUNDSIZE_HEIGHT(h)	(((h) << 0) & GENMASK(11, 0))
+
+#define VE_DEC_MPEG_MBADDR			(VE_ENGINE_DEC_MPEG + 0x10)
+
+#define VE_DEC_MPEG_MBADDR_X(w)			(((w) << 8) & GENMASK(15, 8))
+#define VE_DEC_MPEG_MBADDR_Y(h)			(((h) << 0) & GENMASK(0, 7))
+
+#define VE_DEC_MPEG_CTRL			(VE_ENGINE_DEC_MPEG + 0x14)
+
+#define VE_DEC_MPEG_CTRL_MC_CACHE_EN		BIT(31)
+#define VE_DEC_MPEG_CTRL_SW_VLD			BIT(27)
+#define VE_DEC_MPEG_CTRL_SW_IQ_IS		BIT(17)
+#define VE_DEC_MPEG_CTRL_QP_AC_DC_OUT_EN	BIT(14)
+#define VE_DEC_MPEG_CTRL_ROTATE_SCALE_OUT_EN	BIT(8)
+#define VE_DEC_MPEG_CTRL_MC_NO_WRITEBACK	BIT(7)
+#define VE_DEC_MPEG_CTRL_ROTATE_IRQ_EN		BIT(6)
+#define VE_DEC_MPEG_CTRL_VLD_DATA_REQ_IRQ_EN	BIT(5)
+#define VE_DEC_MPEG_CTRL_ERROR_IRQ_EN		BIT(4)
+#define VE_DEC_MPEG_CTRL_FINISH_IRQ_EN		BIT(3)
+
+#define VE_DEC_MPEG_CTRL_IRQ_MASK \
+	(VE_DEC_MPEG_CTRL_FINISH_IRQ_EN | VE_DEC_MPEG_CTRL_ERROR_IRQ_EN | \
+	 VE_DEC_MPEG_CTRL_VLD_DATA_REQ_IRQ_EN)
+
+#define VE_DEC_MPEG_TRIGGER			(VE_ENGINE_DEC_MPEG + 0x18)
+
+#define VE_DEC_MPEG_TRIGGER_MB_BOUNDARY		BIT(31)
+
+#define VE_DEC_MPEG_TRIGGER_CHROMA_FMT_420	(0x00 << 27)
+#define VE_DEC_MPEG_TRIGGER_CHROMA_FMT_411	(0x01 << 27)
+#define VE_DEC_MPEG_TRIGGER_CHROMA_FMT_422	(0x02 << 27)
+#define VE_DEC_MPEG_TRIGGER_CHROMA_FMT_444	(0x03 << 27)
+#define VE_DEC_MPEG_TRIGGER_CHROMA_FMT_422T	(0x04 << 27)
+
+#define VE_DEC_MPEG_TRIGGER_MPEG1		(0x01 << 24)
+#define VE_DEC_MPEG_TRIGGER_MPEG2		(0x02 << 24)
+#define VE_DEC_MPEG_TRIGGER_JPEG		(0x03 << 24)
+#define VE_DEC_MPEG_TRIGGER_MPEG4		(0x04 << 24)
+#define VE_DEC_MPEG_TRIGGER_VP62		(0x05 << 24)
+
+#define VE_DEC_MPEG_TRIGGER_VP62_AC_GET_BITS	BIT(7)
+
+#define VE_DEC_MPEG_TRIGGER_STCD_VC1		(0x02 << 4)
+#define VE_DEC_MPEG_TRIGGER_STCD_MPEG2		(0x01 << 4)
+#define VE_DEC_MPEG_TRIGGER_STCD_AVC		(0x00 << 4)
+
+#define VE_DEC_MPEG_TRIGGER_HW_MPEG_VLD		(0x0f << 0)
+#define VE_DEC_MPEG_TRIGGER_HW_JPEG_VLD		(0x0e << 0)
+#define VE_DEC_MPEG_TRIGGER_HW_MB		(0x0d << 0)
+#define VE_DEC_MPEG_TRIGGER_HW_ROTATE		(0x0c << 0)
+#define VE_DEC_MPEG_TRIGGER_HW_VP6_VLD		(0x0b << 0)
+#define VE_DEC_MPEG_TRIGGER_HW_MAF		(0x0a << 0)
+#define VE_DEC_MPEG_TRIGGER_HW_STCD_END		(0x09 << 0)
+#define VE_DEC_MPEG_TRIGGER_HW_STCD_BEGIN	(0x08 << 0)
+#define VE_DEC_MPEG_TRIGGER_SW_MC		(0x07 << 0)
+#define VE_DEC_MPEG_TRIGGER_SW_IQ		(0x06 << 0)
+#define VE_DEC_MPEG_TRIGGER_SW_IDCT		(0x05 << 0)
+#define VE_DEC_MPEG_TRIGGER_SW_SCALE		(0x04 << 0)
+#define VE_DEC_MPEG_TRIGGER_SW_VP6		(0x03 << 0)
+#define VE_DEC_MPEG_TRIGGER_SW_VP62_AC_GET_BITS	(0x02 << 0)
+
+#define VE_DEC_MPEG_STATUS			(VE_ENGINE_DEC_MPEG + 0x1c)
+
+#define VE_DEC_MPEG_STATUS_START_DETECT_BUSY	BIT(27)
+#define VE_DEC_MPEG_STATUS_VP6_BIT		BIT(26)
+#define VE_DEC_MPEG_STATUS_VP6_BIT_BUSY		BIT(25)
+#define VE_DEC_MPEG_STATUS_MAF_BUSY		BIT(23)
+#define VE_DEC_MPEG_STATUS_VP6_MVP_BUSY		BIT(22)
+#define VE_DEC_MPEG_STATUS_JPEG_BIT_END		BIT(21)
+#define VE_DEC_MPEG_STATUS_JPEG_RESTART_ERROR	BIT(20)
+#define VE_DEC_MPEG_STATUS_JPEG_MARKER		BIT(19)
+#define VE_DEC_MPEG_STATUS_ROTATE_BUSY		BIT(18)
+#define VE_DEC_MPEG_STATUS_DEBLOCKING_BUSY	BIT(17)
+#define VE_DEC_MPEG_STATUS_SCALE_DOWN_BUSY	BIT(16)
+#define VE_DEC_MPEG_STATUS_IQIS_BUF_EMPTY	BIT(15)
+#define VE_DEC_MPEG_STATUS_IDCT_BUF_EMPTY	BIT(14)
+#define VE_DEC_MPEG_STATUS_VE_BUSY		BIT(13)
+#define VE_DEC_MPEG_STATUS_MC_BUSY		BIT(12)
+#define VE_DEC_MPEG_STATUS_IDCT_BUSY		BIT(11)
+#define VE_DEC_MPEG_STATUS_IQIS_BUSY		BIT(10)
+#define VE_DEC_MPEG_STATUS_DCAC_BUSY		BIT(9)
+#define VE_DEC_MPEG_STATUS_VLD_BUSY		BIT(8)
+#define VE_DEC_MPEG_STATUS_ROTATE_SUCCESS	BIT(3)
+#define VE_DEC_MPEG_STATUS_VLD_DATA_REQ		BIT(2)
+#define VE_DEC_MPEG_STATUS_ERROR		BIT(1)
+#define VE_DEC_MPEG_STATUS_SUCCESS		BIT(0)
+
+#define VE_DEC_MPEG_STATUS_CHECK_MASK \
+	(VE_DEC_MPEG_STATUS_SUCCESS | VE_DEC_MPEG_STATUS_ERROR | \
+	 VE_DEC_MPEG_STATUS_VLD_DATA_REQ)
+#define VE_DEC_MPEG_STATUS_CHECK_ERROR \
+	(VE_DEC_MPEG_STATUS_ERROR | VE_DEC_MPEG_STATUS_VLD_DATA_REQ)
+
+#define VE_DEC_MPEG_VLD_ADDR			(VE_ENGINE_DEC_MPEG + 0x28)
+
+#define VE_DEC_MPEG_VLD_ADDR_FIRST_PIC_DATA	BIT(30)
+#define VE_DEC_MPEG_VLD_ADDR_LAST_PIC_DATA	BIT(29)
+#define VE_DEC_MPEG_VLD_ADDR_VALID_PIC_DATA	BIT(28)
+#define VE_DEC_MPEG_VLD_ADDR_BASE(a) \
+	(((a) & GENMASK(27, 4)) | (((a) >> 28) & GENMASK(3, 0)))
+
+#define VE_DEC_MPEG_VLD_OFFSET			(VE_ENGINE_DEC_MPEG + 0x2c)
+#define VE_DEC_MPEG_VLD_LEN			(VE_ENGINE_DEC_MPEG + 0x30)
+#define VE_DEC_MPEG_VLD_END			(VE_ENGINE_DEC_MPEG + 0x34)
+
+#define VE_DEC_MPEG_REC_LUMA			(VE_ENGINE_DEC_MPEG + 0x48)
+#define VE_DEC_MPEG_REC_CHROMA			(VE_ENGINE_DEC_MPEG + 0x4c)
+#define VE_DEC_MPEG_FWD_REF_LUMA_ADDR		(VE_ENGINE_DEC_MPEG + 0x50)
+#define VE_DEC_MPEG_FWD_REF_CHROMA_ADDR		(VE_ENGINE_DEC_MPEG + 0x54)
+#define VE_DEC_MPEG_BWD_REF_LUMA_ADDR		(VE_ENGINE_DEC_MPEG + 0x58)
+#define VE_DEC_MPEG_BWD_REF_CHROMA_ADDR		(VE_ENGINE_DEC_MPEG + 0x5c)
+
+#define VE_DEC_MPEG_IQMINPUT			(VE_ENGINE_DEC_MPEG + 0x80)
+
+#define VE_DEC_MPEG_IQMINPUT_FLAG_INTRA		(0x01 << 14)
+#define VE_DEC_MPEG_IQMINPUT_FLAG_NON_INTRA	(0x00 << 14)
+#define VE_DEC_MPEG_IQMINPUT_WEIGHT(i, v) \
+	(((v) & GENMASK(7, 0)) | (((i) << 8) & GENMASK(13, 8)))
+
+#define VE_DEC_MPEG_ERROR			(VE_ENGINE_DEC_MPEG + 0xc4)
+#define VE_DEC_MPEG_CRTMBADDR			(VE_ENGINE_DEC_MPEG + 0xc8)
+#define VE_DEC_MPEG_ROT_LUMA			(VE_ENGINE_DEC_MPEG + 0xcc)
+#define VE_DEC_MPEG_ROT_CHROMA			(VE_ENGINE_DEC_MPEG + 0xd0)
+
+#endif
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
new file mode 100644
index 000000000000..1a6b6a90af8b
--- /dev/null
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
@@ -0,0 +1,566 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Sunxi-Cedrus VPU driver
+ *
+ * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com>
+ * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.com>
+ *
+ * Based on the vim2m driver, that is:
+ *
+ * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
+ * Pawel Osciak, <pawel@osciak.com>
+ * Marek Szyprowski, <m.szyprowski@samsung.com>
+ */
+
+#include <media/videobuf2-dma-contig.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-mem2mem.h>
+
+#include "cedrus.h"
+#include "cedrus_video.h"
+#include "cedrus_dec.h"
+#include "cedrus_hw.h"
+
+#define CEDRUS_DECODE_SRC	BIT(0)
+#define CEDRUS_DECODE_DST	BIT(1)
+
+#define CEDRUS_MIN_WIDTH	16U
+#define CEDRUS_MIN_HEIGHT	16U
+#define CEDRUS_MAX_WIDTH	3840U
+#define CEDRUS_MAX_HEIGHT	2160U
+
+static struct cedrus_format cedrus_formats[] = {
+	{
+		.pixelformat	= V4L2_PIX_FMT_MPEG2_SLICE,
+		.directions	= CEDRUS_DECODE_SRC,
+		.num_planes	= 1,
+		.num_buffers	= 1,
+	},
+	{
+		.pixelformat	= V4L2_PIX_FMT_MB32_NV12,
+		.directions	= CEDRUS_DECODE_DST,
+		.num_planes	= 2,
+		.num_buffers	= 1,
+	},
+	{
+		.pixelformat	= V4L2_PIX_FMT_NV12,
+		.directions	= CEDRUS_DECODE_DST,
+		.num_planes	= 2,
+		.num_buffers	= 1,
+		.capabilities	= CEDRUS_CAPABILITY_UNTILED,
+	},
+};
+
+#define CEDRUS_FORMATS_COUNT	ARRAY_SIZE(cedrus_formats)
+
+static inline struct cedrus_ctx *cedrus_file2ctx(struct file *file)
+{
+	return container_of(file->private_data, struct cedrus_ctx, fh);
+}
+
+static struct cedrus_format *cedrus_find_format(u32 pixelformat, u32 directions,
+						unsigned int capabilities)
+{
+	struct cedrus_format *fmt;
+	unsigned int i;
+
+	for (i = 0; i < CEDRUS_FORMATS_COUNT; i++) {
+		fmt = &cedrus_formats[i];
+
+		if (fmt->capabilities && (fmt->capabilities & capabilities) !=
+		    fmt->capabilities)
+			continue;
+
+		if (fmt->pixelformat == pixelformat &&
+		    (fmt->directions & directions) != 0)
+			break;
+	}
+
+	if (i == CEDRUS_FORMATS_COUNT)
+		return NULL;
+
+	return &cedrus_formats[i];
+}
+
+static void cedrus_prepare_plane_format(struct cedrus_format *fmt,
+					struct v4l2_format *f,
+					unsigned int i)
+{
+	struct v4l2_plane_pix_format *plane_fmt = &f->fmt.pix_mp.plane_fmt[i];
+	unsigned int width = f->fmt.pix_mp.width;
+	unsigned int height = f->fmt.pix_mp.height;
+	unsigned int sizeimage = plane_fmt->sizeimage;
+	unsigned int bytesperline = plane_fmt->bytesperline;
+
+	switch (fmt->pixelformat) {
+	case V4L2_PIX_FMT_MPEG2_SLICE:
+		/* Zero bytes per line. */
+		bytesperline = 0;
+		break;
+
+	case V4L2_PIX_FMT_MB32_NV12:
+		/* 32-aligned stride. */
+		bytesperline = ALIGN(width, 32);
+
+		/* 32-aligned (luma) height. */
+		height = ALIGN(height, 32);
+
+		if (i == 0)
+			/* 32-aligned luma size. */
+			sizeimage = bytesperline * height;
+		else if (i == 1)
+			/* 32-aligned chroma size with 2x2 sub-sampling. */
+			sizeimage = bytesperline * ALIGN(height / 2, 32);
+
+		break;
+
+	case V4L2_PIX_FMT_NV12:
+		/* 32-aligned stride. */
+		bytesperline = ALIGN(width, 32);
+
+		if (i == 0)
+			/* Regular luma size. */
+			sizeimage = bytesperline * height;
+		else if (i == 1)
+			/* Regular chroma size with 2x2 sub-sampling. */
+			sizeimage = bytesperline * height / 2;
+
+		break;
+	}
+
+	f->fmt.pix_mp.width = width;
+	f->fmt.pix_mp.height = height;
+
+	plane_fmt->bytesperline = bytesperline;
+	plane_fmt->sizeimage = sizeimage;
+}
+
+static void cedrus_prepare_format(struct cedrus_format *fmt,
+				  struct v4l2_format *f)
+{
+	unsigned int i;
+
+	f->fmt.pix_mp.field = V4L2_FIELD_NONE;
+	f->fmt.pix_mp.num_planes = fmt->num_planes;
+
+	for (i = 0; i < fmt->num_planes; i++)
+		cedrus_prepare_plane_format(fmt, f, i);
+}
+
+static int cedrus_querycap(struct file *file, void *priv,
+			   struct v4l2_capability *cap)
+{
+	strncpy(cap->driver, CEDRUS_NAME, sizeof(cap->driver) - 1);
+	strncpy(cap->card, CEDRUS_NAME, sizeof(cap->card) - 1);
+	snprintf(cap->bus_info, sizeof(cap->bus_info),
+		 "platform:%s", CEDRUS_NAME);
+
+	cap->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+
+	return 0;
+}
+
+static int cedrus_enum_fmt(struct file *file, struct v4l2_fmtdesc *f,
+			   u32 direction)
+{
+	struct cedrus_ctx *ctx = cedrus_file2ctx(file);
+	struct cedrus_dev *dev = ctx->dev;
+	unsigned int capabilities = dev->capabilities;
+	struct cedrus_format *fmt;
+	unsigned int i, index;
+
+	/* Index among formats that match the requested direction. */
+	index = 0;
+
+	for (i = 0; i < CEDRUS_FORMATS_COUNT; i++) {
+		fmt = &cedrus_formats[i];
+
+		if (fmt->capabilities && (fmt->capabilities & capabilities) !=
+		    fmt->capabilities)
+			continue;
+
+		if (!(cedrus_formats[i].directions & direction))
+			continue;
+
+		if (index == f->index)
+			break;
+
+		index++;
+	}
+
+	/* Matched format. */
+	if (i < CEDRUS_FORMATS_COUNT) {
+		f->pixelformat = cedrus_formats[i].pixelformat;
+
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static int cedrus_enum_fmt_vid_cap(struct file *file, void *priv,
+				   struct v4l2_fmtdesc *f)
+{
+	return cedrus_enum_fmt(file, f, CEDRUS_DECODE_DST);
+}
+
+static int cedrus_enum_fmt_vid_out(struct file *file, void *priv,
+				   struct v4l2_fmtdesc *f)
+{
+	return cedrus_enum_fmt(file, f, CEDRUS_DECODE_SRC);
+}
+
+static int cedrus_g_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct cedrus_ctx *ctx = cedrus_file2ctx(file);
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		return -EINVAL;
+
+	f->fmt.pix_mp = ctx->dst_fmt;
+
+	return 0;
+}
+
+static int cedrus_g_fmt_vid_out(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct cedrus_ctx *ctx = cedrus_file2ctx(file);
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		return -EINVAL;
+
+	f->fmt.pix_mp = ctx->src_fmt;
+
+	return 0;
+}
+
+static int cedrus_try_fmt_vid_cap(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	struct cedrus_ctx *ctx = cedrus_file2ctx(file);
+	struct cedrus_dev *dev = ctx->dev;
+	struct cedrus_format *fmt;
+
+	fmt = cedrus_find_format(f->fmt.pix_mp.pixelformat, CEDRUS_DECODE_DST,
+				 dev->capabilities);
+	if (!fmt)
+		return -EINVAL;
+
+	cedrus_prepare_format(fmt, f);
+
+	/* Limit to hardware min/max. */
+	f->fmt.pix_mp.width = clamp(f->fmt.pix_mp.width, CEDRUS_MIN_WIDTH,
+				    CEDRUS_MAX_WIDTH);
+	f->fmt.pix_mp.height = clamp(f->fmt.pix_mp.height, CEDRUS_MIN_HEIGHT,
+				     CEDRUS_MAX_HEIGHT);
+
+	return 0;
+}
+
+static int cedrus_try_fmt_vid_out(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	struct cedrus_ctx *ctx = cedrus_file2ctx(file);
+	struct cedrus_dev *dev = ctx->dev;
+	struct cedrus_format *fmt;
+	struct v4l2_plane_pix_format *plane_fmt;
+	unsigned int i;
+
+	fmt = cedrus_find_format(f->fmt.pix_mp.pixelformat, CEDRUS_DECODE_SRC,
+				 dev->capabilities);
+	if (!fmt)
+		return -EINVAL;
+
+	cedrus_prepare_format(fmt, f);
+
+	for (i = 0; i < f->fmt.pix_mp.num_planes; i++) {
+		plane_fmt = &f->fmt.pix_mp.plane_fmt[i];
+
+		/* Source image size has to be given by userspace. */
+		if (plane_fmt->sizeimage == 0)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int cedrus_s_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct cedrus_ctx *ctx = cedrus_file2ctx(file);
+	struct cedrus_dev *dev = ctx->dev;
+	int ret;
+
+	ret = cedrus_try_fmt_vid_cap(file, priv, f);
+	if (ret)
+		return ret;
+
+	ctx->dst_fmt = f->fmt.pix_mp;
+
+	cedrus_dst_format_set(dev, &ctx->dst_fmt);
+
+	return 0;
+}
+
+static int cedrus_s_fmt_vid_out(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct cedrus_ctx *ctx = cedrus_file2ctx(file);
+	int ret;
+
+	ret = cedrus_try_fmt_vid_out(file, priv, f);
+	if (ret)
+		return ret;
+
+	ctx->src_fmt = f->fmt.pix_mp;
+
+	return 0;
+}
+
+const struct v4l2_ioctl_ops cedrus_ioctl_ops = {
+	.vidioc_querycap		= cedrus_querycap,
+
+	.vidioc_enum_fmt_vid_cap_mplane	= cedrus_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap_mplane	= cedrus_g_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap_mplane	= cedrus_try_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap_mplane	= cedrus_s_fmt_vid_cap,
+
+	.vidioc_enum_fmt_vid_out_mplane = cedrus_enum_fmt_vid_out,
+	.vidioc_g_fmt_vid_out_mplane	= cedrus_g_fmt_vid_out,
+	.vidioc_try_fmt_vid_out_mplane	= cedrus_try_fmt_vid_out,
+	.vidioc_s_fmt_vid_out_mplane	= cedrus_s_fmt_vid_out,
+
+	.vidioc_reqbufs			= v4l2_m2m_ioctl_reqbufs,
+	.vidioc_querybuf		= v4l2_m2m_ioctl_querybuf,
+	.vidioc_qbuf			= v4l2_m2m_ioctl_qbuf,
+	.vidioc_dqbuf			= v4l2_m2m_ioctl_dqbuf,
+	.vidioc_prepare_buf		= v4l2_m2m_ioctl_prepare_buf,
+	.vidioc_create_bufs		= v4l2_m2m_ioctl_create_bufs,
+	.vidioc_expbuf			= v4l2_m2m_ioctl_expbuf,
+
+	.vidioc_streamon		= v4l2_m2m_ioctl_streamon,
+	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
+
+	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
+};
+
+static int cedrus_queue_setup(struct vb2_queue *vq, unsigned int *nbufs,
+			      unsigned int *nplanes, unsigned int sizes[],
+			      struct device *alloc_devs[])
+{
+	struct cedrus_ctx *ctx = vb2_get_drv_priv(vq);
+	struct cedrus_dev *dev = ctx->dev;
+	struct v4l2_pix_format_mplane *mplane_fmt;
+	struct cedrus_format *fmt;
+	unsigned int i;
+
+	switch (vq->type) {
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		mplane_fmt = &ctx->src_fmt;
+		fmt = cedrus_find_format(mplane_fmt->pixelformat,
+					 CEDRUS_DECODE_SRC,
+					 dev->capabilities);
+		break;
+
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		mplane_fmt = &ctx->dst_fmt;
+		fmt = cedrus_find_format(mplane_fmt->pixelformat,
+					 CEDRUS_DECODE_DST,
+					 dev->capabilities);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	if (!fmt)
+		return -EINVAL;
+
+	if (fmt->num_buffers == 1) {
+		sizes[0] = 0;
+
+		for (i = 0; i < fmt->num_planes; i++)
+			sizes[0] += mplane_fmt->plane_fmt[i].sizeimage;
+	} else if (fmt->num_buffers == fmt->num_planes) {
+		for (i = 0; i < fmt->num_planes; i++)
+			sizes[i] = mplane_fmt->plane_fmt[i].sizeimage;
+	} else {
+		return -EINVAL;
+	}
+
+	*nplanes = fmt->num_buffers;
+
+	return 0;
+}
+
+static int cedrus_buf_init(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct cedrus_ctx *ctx = vb2_get_drv_priv(vq);
+
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		ctx->dst_bufs[vb->index] = vb;
+
+	return 0;
+}
+
+static void cedrus_buf_cleanup(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct cedrus_ctx *ctx = vb2_get_drv_priv(vq);
+
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		ctx->dst_bufs[vb->index] = NULL;
+}
+
+static int cedrus_buf_prepare(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct cedrus_ctx *ctx = vb2_get_drv_priv(vq);
+	struct v4l2_pix_format_mplane *fmt;
+	unsigned int buffer_size = 0;
+	unsigned int format_size = 0;
+	unsigned int i;
+
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		fmt = &ctx->src_fmt;
+	else if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		fmt = &ctx->dst_fmt;
+	else
+		return -EINVAL;
+
+	for (i = 0; i < vb->num_planes; i++)
+		buffer_size += vb2_plane_size(vb, i);
+
+	for (i = 0; i < fmt->num_planes; i++)
+		format_size += fmt->plane_fmt[i].sizeimage;
+
+	if (buffer_size < format_size)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int cedrus_start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	struct cedrus_ctx *ctx = vb2_get_drv_priv(q);
+	struct cedrus_dev *dev = ctx->dev;
+	int ret = 0;
+
+	switch (ctx->src_fmt.pixelformat) {
+	case V4L2_PIX_FMT_MPEG2_SLICE:
+		ctx->current_codec = CEDRUS_CODEC_MPEG2;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (V4L2_TYPE_IS_OUTPUT(q->type) &&
+	    dev->dec_ops[ctx->current_codec]->start)
+		ret = dev->dec_ops[ctx->current_codec]->start(ctx);
+
+	return ret;
+}
+
+static void cedrus_stop_streaming(struct vb2_queue *q)
+{
+	struct cedrus_ctx *ctx = vb2_get_drv_priv(q);
+	struct cedrus_dev *dev = ctx->dev;
+	struct vb2_v4l2_buffer *vbuf;
+	unsigned long flags;
+
+	flush_scheduled_work();
+
+	if (V4L2_TYPE_IS_OUTPUT(q->type) &&
+	    dev->dec_ops[ctx->current_codec]->stop)
+		dev->dec_ops[ctx->current_codec]->stop(ctx);
+
+	for (;;) {
+		spin_lock_irqsave(&ctx->dev->irq_lock, flags);
+
+		if (V4L2_TYPE_IS_OUTPUT(q->type))
+			vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+		else
+			vbuf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+
+		spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
+
+		if (!vbuf)
+			return;
+
+		v4l2_ctrl_request_complete(vbuf->vb2_buf.req_obj.req,
+					   &ctx->hdl);
+		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
+	}
+}
+
+static void cedrus_buf_queue(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct cedrus_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+
+	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
+}
+
+static void cedrus_buf_request_complete(struct vb2_buffer *vb)
+{
+	struct cedrus_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+
+	v4l2_ctrl_request_complete(vb->req_obj.req, &ctx->hdl);
+}
+
+static struct vb2_ops cedrus_qops = {
+	.queue_setup		= cedrus_queue_setup,
+	.buf_prepare		= cedrus_buf_prepare,
+	.buf_init		= cedrus_buf_init,
+	.buf_cleanup		= cedrus_buf_cleanup,
+	.buf_queue		= cedrus_buf_queue,
+	.buf_request_complete	= cedrus_buf_request_complete,
+	.start_streaming	= cedrus_start_streaming,
+	.stop_streaming		= cedrus_stop_streaming,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
+};
+
+int cedrus_queue_init(void *priv, struct vb2_queue *src_vq,
+		      struct vb2_queue *dst_vq)
+{
+	struct cedrus_ctx *ctx = priv;
+	int ret;
+
+	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	src_vq->io_modes = VB2_MMAP | VB2_DMABUF;
+	src_vq->drv_priv = ctx;
+	src_vq->buf_struct_size = sizeof(struct cedrus_buffer);
+	src_vq->allow_zero_bytesused = 1;
+	src_vq->min_buffers_needed = 1;
+	src_vq->ops = &cedrus_qops;
+	src_vq->mem_ops = &vb2_dma_contig_memops;
+	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	src_vq->lock = &ctx->dev->dev_mutex;
+	src_vq->dev = ctx->dev->dev;
+
+	ret = vb2_queue_init(src_vq);
+	if (ret)
+		return ret;
+
+	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	dst_vq->io_modes = VB2_MMAP | VB2_DMABUF;
+	dst_vq->drv_priv = ctx;
+	dst_vq->buf_struct_size = sizeof(struct cedrus_buffer);
+	dst_vq->allow_zero_bytesused = 1;
+	dst_vq->min_buffers_needed = 1;
+	dst_vq->ops = &cedrus_qops;
+	dst_vq->mem_ops = &vb2_dma_contig_memops;
+	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	dst_vq->lock = &ctx->dev->dev_mutex;
+	dst_vq->dev = ctx->dev->dev;
+
+	return vb2_queue_init(dst_vq);
+}
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.h b/drivers/staging/media/sunxi/cedrus/cedrus_video.h
new file mode 100644
index 000000000000..56afcc8c02ba
--- /dev/null
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Sunxi-Cedrus VPU driver
+ *
+ * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com>
+ * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.com>
+ *
+ * Based on the vim2m driver, that is:
+ *
+ * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
+ * Pawel Osciak, <pawel@osciak.com>
+ * Marek Szyprowski, <m.szyprowski@samsung.com>
+ */
+
+#ifndef _CEDRUS_VIDEO_H_
+#define _CEDRUS_VIDEO_H_
+
+struct cedrus_format {
+	u32		pixelformat;
+	u32		directions;
+	unsigned int	num_planes;
+	unsigned int	num_buffers;
+	unsigned int	capabilities;
+};
+
+extern const struct v4l2_ioctl_ops cedrus_ioctl_ops;
+
+int cedrus_queue_init(void *priv, struct vb2_queue *src_vq,
+		      struct vb2_queue *dst_vq);
+
+#endif
-- 
2.18.0
