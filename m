Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:52988 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751151AbeGJICO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 04:02:14 -0400
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Marco Franchi <marco.franchi@nxp.com>,
        Icenowy Zheng <icenowy@aosc.io>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Tom Saeger <tom.saeger@oracle.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Benoit Parrot <bparrot@ti.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pawel Osciak <posciak@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>
Subject: [PATCH v5 18/22] media: platform: Add Sunxi-Cedrus VPU decoder driver
Date: Tue, 10 Jul 2018 10:01:10 +0200
Message-Id: <20180710080114.31469-19-paul.kocialkowski@bootlin.com>
In-Reply-To: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
References: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This introduces the Sunxi-Cedrus VPU driver that supports the VPU found
in Allwinner SoCs, also known as Video Engine. It is implemented through
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
 drivers/media/platform/Kconfig                |   2 +
 drivers/media/platform/Makefile               |   1 +
 drivers/media/platform/sunxi/Kconfig          |  15 +
 drivers/media/platform/sunxi/Makefile         |   1 +
 drivers/media/platform/sunxi/cedrus/Kconfig   |  13 +
 drivers/media/platform/sunxi/cedrus/Makefile  |   3 +
 drivers/media/platform/sunxi/cedrus/cedrus.c  | 374 ++++++++++++
 drivers/media/platform/sunxi/cedrus/cedrus.h  | 161 +++++
 .../media/platform/sunxi/cedrus/cedrus_dec.c  | 129 ++++
 .../media/platform/sunxi/cedrus/cedrus_dec.h  |  27 +
 .../media/platform/sunxi/cedrus/cedrus_hw.c   | 325 ++++++++++
 .../media/platform/sunxi/cedrus/cedrus_hw.h   |  29 +
 .../platform/sunxi/cedrus/cedrus_mpeg2.c      | 178 ++++++
 .../media/platform/sunxi/cedrus/cedrus_regs.h | 195 ++++++
 .../platform/sunxi/cedrus/cedrus_video.c      | 556 ++++++++++++++++++
 .../platform/sunxi/cedrus/cedrus_video.h      |  31 +
 17 files changed, 2047 insertions(+)
 create mode 100644 drivers/media/platform/sunxi/Kconfig
 create mode 100644 drivers/media/platform/sunxi/Makefile
 create mode 100644 drivers/media/platform/sunxi/cedrus/Kconfig
 create mode 100644 drivers/media/platform/sunxi/cedrus/Makefile
 create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus.c
 create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus.h
 create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_dec.c
 create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_dec.h
 create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_hw.c
 create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_hw.h
 create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_mpeg2.c
 create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_regs.h
 create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_video.c
 create mode 100644 drivers/media/platform/sunxi/cedrus/cedrus_video.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 89853313c697..e9f190109d58 100644
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
+F:	drivers/media/platform/sunxi/cedrus/
+
 ALPHA PORT
 M:	Richard Henderson <rth@twiddle.net>
 M:	Ivan Kokshaysky <ink@jurassic.park.msu.ru>
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 210b44a457eb..6ee971b7258a 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -32,6 +32,8 @@ source "drivers/media/platform/davinci/Kconfig"
 
 source "drivers/media/platform/omap/Kconfig"
 
+source "drivers/media/platform/sunxi/Kconfig"
+
 config VIDEO_SH_VOU
 	tristate "SuperH VOU video output driver"
 	depends on MEDIA_CAMERA_SUPPORT
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 04bc1502a30e..3e2665cec205 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -70,6 +70,7 @@ obj-$(CONFIG_VIDEO_ROCKCHIP_RGA)	+= rockchip/rga/
 obj-y	+= omap/
 
 obj-$(CONFIG_VIDEO_AM437X_VPFE)		+= am437x/
+obj-$(CONFIG_VIDEO_SUNXI)		+= sunxi/
 
 obj-$(CONFIG_VIDEO_XILINX)		+= xilinx/
 
diff --git a/drivers/media/platform/sunxi/Kconfig b/drivers/media/platform/sunxi/Kconfig
new file mode 100644
index 000000000000..a639b0949826
--- /dev/null
+++ b/drivers/media/platform/sunxi/Kconfig
@@ -0,0 +1,15 @@
+config VIDEO_SUNXI
+	bool "Allwinner sunXi family Video Devices"
+	depends on ARCH_SUNXI
+	help
+	  If you have an Allwinner SoC based on the sunXi family, say Y.
+
+	  Note that this option doesn't include new drivers in the
+	  kernel: saying N will just cause Kconfig to skip all the
+	  questions about Allwinner media devices.
+
+if VIDEO_SUNXI
+
+source "drivers/media/platform/sunxi/cedrus/Kconfig"
+
+endif
diff --git a/drivers/media/platform/sunxi/Makefile b/drivers/media/platform/sunxi/Makefile
new file mode 100644
index 000000000000..cee2846c3ecf
--- /dev/null
+++ b/drivers/media/platform/sunxi/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_VIDEO_SUNXI_CEDRUS)	+= cedrus/
diff --git a/drivers/media/platform/sunxi/cedrus/Kconfig b/drivers/media/platform/sunxi/cedrus/Kconfig
new file mode 100644
index 000000000000..870a4b64a45c
--- /dev/null
+++ b/drivers/media/platform/sunxi/cedrus/Kconfig
@@ -0,0 +1,13 @@
+config VIDEO_SUNXI_CEDRUS
+	tristate "Allwinner Cedrus VPU driver"
+	depends on VIDEO_DEV && VIDEO_V4L2 && MEDIA_CONTROLLER
+	depends on HAS_DMA
+	select VIDEOBUF2_DMA_CONTIG
+	select MEDIA_REQUEST_API
+	select V4L2_MEM2MEM_DEV
+	help
+	  Support for the VPU found in Allwinner SoCs, also known as the Cedar
+	  video engine.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called cedrus.
diff --git a/drivers/media/platform/sunxi/cedrus/Makefile b/drivers/media/platform/sunxi/cedrus/Makefile
new file mode 100644
index 000000000000..632a0be90ed7
--- /dev/null
+++ b/drivers/media/platform/sunxi/cedrus/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_VIDEO_SUNXI_CEDRUS) += cedrus.o
+
+cedrus-y = cedrus.o cedrus_video.o cedrus_hw.o cedrus_dec.o cedrus_mpeg2.o
diff --git a/drivers/media/platform/sunxi/cedrus/cedrus.c b/drivers/media/platform/sunxi/cedrus/cedrus.c
new file mode 100644
index 000000000000..087ccf044313
--- /dev/null
+++ b/drivers/media/platform/sunxi/cedrus/cedrus.c
@@ -0,0 +1,374 @@
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
+	if (ctx == NULL)
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
+		if (cedrus_controls[i].codec == ctx->current_codec &&
+		    cedrus_controls[i].required) {
+			ctrl_test = v4l2_ctrl_request_hdl_ctrl_find(hdl,
+				cedrus_controls[i].id);
+			if (!ctrl_test) {
+				v4l2_err(&ctx->dev->v4l2_dev,
+					 "Missing required codec control\n");
+				return -EINVAL;
+			}
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
+	mutex_init(&dev->dev_mutex);
+	spin_lock_init(&dev->irq_lock);
+
+	dev->vfd = cedrus_video_device;
+	vfd = &dev->vfd;
+	vfd->lock = &dev->dev_mutex;
+	vfd->v4l2_dev = &dev->v4l2_dev;
+
+	dev->mdev.dev = &pdev->dev;
+	strlcpy(dev->mdev.model, CEDRUS_NAME, sizeof(dev->mdev.model));
+
+	media_device_init(&dev->mdev);
+	dev->mdev.ops = &cedrus_m2m_media_ops;
+	dev->v4l2_dev.mdev = &dev->mdev;
+	dev->pad[0].flags = MEDIA_PAD_FL_SINK;
+	dev->pad[1].flags = MEDIA_PAD_FL_SOURCE;
+
+	ret = media_entity_pads_init(&vfd->entity, 2, dev->pad);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to initialize media entity pads\n");
+		return ret;
+	}
+
+	dev->dec_ops[CEDRUS_CODEC_MPEG2] = &cedrus_dec_ops_mpeg2;
+
+	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to register V4L2 device\n");
+		return ret;
+	}
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
+		goto err_v4l2;
+	}
+
+	video_set_drvdata(vfd, dev);
+	snprintf(vfd->name, sizeof(vfd->name), "%s", cedrus_video_device.name);
+
+	v4l2_info(&dev->v4l2_dev,
+		  "Device registered as /dev/video%d\n", vfd->num);
+
+	platform_set_drvdata(pdev, dev);
+
+	dev->m2m_dev = v4l2_m2m_init(&cedrus_m2m_ops);
+	if (IS_ERR(dev->m2m_dev)) {
+		v4l2_err(&dev->v4l2_dev,
+			 "Failed to initialize V4L2 M2M device\n");
+		ret = PTR_ERR(dev->m2m_dev);
+		goto err_video;
+	}
+
+	ret = media_device_register(&dev->mdev);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to register media device\n");
+		goto err_m2m;
+	}
+
+	return 0;
+
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
+	v4l2_info(&dev->v4l2_dev, "Removing " CEDRUS_NAME);
+
+	if (media_devnode_is_registered(dev->mdev.devnode)) {
+		media_device_unregister(&dev->mdev);
+		media_device_cleanup(&dev->mdev);
+	}
+
+	v4l2_m2m_release(dev->m2m_dev);
+	video_unregister_device(&dev->vfd);
+	v4l2_device_unregister(&dev->v4l2_dev);
+	cedrus_hw_remove(dev);
+
+	return 0;
+}
+
+static const struct of_device_id cedrus_dt_match[] = {
+	{ .compatible = "allwinner,sun4i-a10-video-engine" },
+	{ .compatible = "allwinner,sun5i-a13-video-engine" },
+	{ .compatible = "allwinner,sun7i-a20-video-engine" },
+	{ .compatible = "allwinner,sun8i-a33-video-engine" },
+	{ .compatible = "allwinner,sun8i-h3-video-engine" },
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
diff --git a/drivers/media/platform/sunxi/cedrus/cedrus.h b/drivers/media/platform/sunxi/cedrus/cedrus.h
new file mode 100644
index 000000000000..98ca13abd678
--- /dev/null
+++ b/drivers/media/platform/sunxi/cedrus/cedrus.h
@@ -0,0 +1,161 @@
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
+#define CEDRUS_NAME	"cedrus"
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
+	return addr + (fmt ? (dma_addr_t) fmt->plane_fmt[0].bytesperline *
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
diff --git a/drivers/media/platform/sunxi/cedrus/cedrus_dec.c b/drivers/media/platform/sunxi/cedrus/cedrus_dec.c
new file mode 100644
index 000000000000..d3e952e2fa47
--- /dev/null
+++ b/drivers/media/platform/sunxi/cedrus/cedrus_dec.c
@@ -0,0 +1,129 @@
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
+	if (!run.src) {
+		v4l2_err(&dev->v4l2_dev, "No source buffer to prepare\n");
+		return;
+	}
+
+	run.dst = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
+	if (!run.dst) {
+		v4l2_err(&dev->v4l2_dev, "No destination buffer to prepare\n");
+		return;
+	}
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
+
+		if (!run.mpeg2.slice_params) {
+			v4l2_err(&dev->v4l2_dev,
+				 "Missing MPEG2 frame params control\n");
+			ctx->job_abort = 1;
+			goto unlock_complete;
+		}
+		break;
+
+	default:
+		ctx->job_abort = 1;
+	}
+
+	if (!ctx->job_abort)
+		dev->dec_ops[ctx->current_codec]->setup(ctx, &run);
+
+unlock_complete:
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
diff --git a/drivers/media/platform/sunxi/cedrus/cedrus_dec.h b/drivers/media/platform/sunxi/cedrus/cedrus_dec.h
new file mode 100644
index 000000000000..b38812136504
--- /dev/null
+++ b/drivers/media/platform/sunxi/cedrus/cedrus_dec.h
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
diff --git a/drivers/media/platform/sunxi/cedrus/cedrus_hw.c b/drivers/media/platform/sunxi/cedrus/cedrus_hw.c
new file mode 100644
index 000000000000..ec013f89f960
--- /dev/null
+++ b/drivers/media/platform/sunxi/cedrus/cedrus_hw.c
@@ -0,0 +1,325 @@
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
+	/*
+	 * FIXME: This is only valid on 32-bits DDR's, we should test
+	 * it on the A13/A33.
+	 */
+	reg |= VE_CTRL_REC_WR_MODE_2MB;
+
+	reg |= VE_CTRL_CACHE_BUS_BW_128;
+
+	switch (codec) {
+	case CEDRUS_CODEC_MPEG2:
+		reg |= VE_CTRL_DEC_MODE_MPEG;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	cedrus_write(dev, VE_CTRL, reg);
+
+	return 0;
+}
+
+void cedrus_engine_disable(struct cedrus_dev *dev)
+{
+	cedrus_write(dev, VE_CTRL, VE_CTRL_DEC_MODE_DISABLED);
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
+		reg = VE_PRIMARY_OUT_FMT_NV12 | VE_SECONDARY_SPECIAL_OUT_FMT_NV12;
+		cedrus_write(dev, VE_PRIMARY_OUT_FMT, reg);
+
+		reg = VE_SECONDARY_OUT_FMT_SPECIAL | (chroma_size / 2);
+		cedrus_write(dev, VE_CHROMA_BUF_LEN, reg);
+
+		reg = chroma_size / 2;
+		cedrus_write(dev, VE_PRIMARY_CHROMA_BUF_LEN, reg);
+
+		reg = (ALIGN(width / 2, 16) << VE_CHROMA_LINE_STRIDE_SHIFT) |
+		      (ALIGN(width, 32) << VE_LUMA_LINE_STRIDE_SHIFT);
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
+static void cedrus_hw_set_capabilities(struct cedrus_dev *dev)
+{
+	unsigned int engine_version;
+
+	engine_version = cedrus_read(dev, VE_VERSION) >> VE_VERSION_SHIFT;
+
+	if (engine_version >= 0x1667)
+		dev->capabilities |= CEDRUS_CAPABILITY_UNTILED;
+}
+
+int cedrus_hw_probe(struct cedrus_dev *dev)
+{
+	struct resource *res;
+	int irq_dec;
+	int ret;
+
+	irq_dec = platform_get_irq(dev->pdev, 0);
+	if (irq_dec <= 0) {
+		v4l2_err(&dev->v4l2_dev, "Failed to get IRQ\n");
+		return -ENXIO;
+	}
+	ret = devm_request_threaded_irq(dev->dev, irq_dec, cedrus_irq,
+					cedrus_bh, 0, dev_name(dev->dev),
+					dev);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to request IRQ\n");
+		return -ENXIO;
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
+		v4l2_err(&dev->v4l2_dev, "Failed to reserved memory\n");
+		return -ENODEV;
+	}
+
+	ret = sunxi_sram_claim(dev->dev);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to claim SRAM\n");
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
+		ret = -EFAULT;
+		goto err_sram;
+	}
+
+	ret = clk_set_rate(dev->mod_clk, CEDRUS_CLOCK_RATE_DEFAULT);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to set clock rate\n");
+		goto err_sram;
+	}
+
+	ret = clk_prepare_enable(dev->ahb_clk);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to enable AHB clock\n");
+
+		ret = -EFAULT;
+		goto err_sram;
+	}
+
+	ret = clk_prepare_enable(dev->mod_clk);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to enable MOD clock\n");
+
+		ret = -EFAULT;
+		goto err_ahb_clk;
+	}
+
+	ret = clk_prepare_enable(dev->ram_clk);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to enable RAM clock\n");
+
+		ret = -EFAULT;
+		goto err_mod_clk;
+	}
+
+	ret = reset_control_reset(dev->rstc);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to apply reset\n");
+
+		ret = -EFAULT;
+		goto err_ram_clk;
+	}
+
+	cedrus_hw_set_capabilities(dev);
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
diff --git a/drivers/media/platform/sunxi/cedrus/cedrus_hw.h b/drivers/media/platform/sunxi/cedrus/cedrus_hw.h
new file mode 100644
index 000000000000..9704f1e0921c
--- /dev/null
+++ b/drivers/media/platform/sunxi/cedrus/cedrus_hw.h
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
diff --git a/drivers/media/platform/sunxi/cedrus/cedrus_mpeg2.c b/drivers/media/platform/sunxi/cedrus/cedrus_mpeg2.c
new file mode 100644
index 000000000000..6d12725377b2
--- /dev/null
+++ b/drivers/media/platform/sunxi/cedrus/cedrus_mpeg2.c
@@ -0,0 +1,178 @@
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
+static const u8 mpeg_default_intra_quant[64] = {
+	8, 16, 16, 19, 16, 19, 22, 22,
+	22, 22, 22, 22, 26, 24, 26, 27,
+	27, 27, 26, 26, 26, 26, 27, 27,
+	27, 29, 29, 29, 34, 34, 34, 29,
+	29, 29, 27, 27, 29, 29, 32, 32,
+	34, 34, 37, 38, 37, 35, 35, 34,
+	35, 38, 38, 40, 40, 40, 48, 48,
+	46, 46, 56, 56, 58, 69, 69, 83
+};
+
+#define m_iq(i) (((64 + i) << 8) | mpeg_default_intra_quant[i])
+
+static const u8 mpeg_default_non_intra_quant[64] = {
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
+#define m_niq(i) ((i << 8) | mpeg_default_non_intra_quant[i])
+
+static enum cedrus_irq_status cedrus_mpeg2_irq_status(struct cedrus_ctx *ctx)
+{
+	struct cedrus_dev *dev = ctx->dev;
+	u32 reg = cedrus_read(dev, VE_MPEG_STATUS) & 0x7;
+
+	if (!reg)
+		return CEDRUS_IRQ_NONE;
+
+	if (reg & (BIT(1) | BIT(2)))
+		return CEDRUS_IRQ_ERROR;
+
+	return CEDRUS_IRQ_OK;
+}
+
+static void cedrus_mpeg2_irq_clear(struct cedrus_ctx *ctx)
+{
+	struct cedrus_dev *dev = ctx->dev;
+
+	cedrus_write(dev, VE_MPEG_STATUS, GENMASK(2, 0));
+}
+
+static void cedrus_mpeg2_irq_disable(struct cedrus_ctx *ctx)
+{
+	struct cedrus_dev *dev = ctx->dev;
+	u32 reg = cedrus_read(dev, VE_MPEG_CTRL) & ~BIT(3);
+
+	cedrus_write(dev, VE_MPEG_CTRL, reg);
+}
+
+static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
+{
+	struct cedrus_dev *dev = ctx->dev;
+	const struct v4l2_ctrl_mpeg2_slice_params *slice_params =
+		run->mpeg2.slice_params;
+
+	u16 width = DIV_ROUND_UP(slice_params->width, 16);
+	u16 height = DIV_ROUND_UP(slice_params->height, 16);
+
+	u32 pic_header = 0;
+	u32 vld_len = slice_params->slice_len - slice_params->slice_pos;
+	int i;
+
+	dma_addr_t src_buf_addr, dst_luma_addr, dst_chroma_addr;
+	dma_addr_t fwd_luma = 0, fwd_chroma = 0, bwd_luma = 0, bwd_chroma = 0;
+
+	fwd_luma = cedrus_dst_buf_addr(ctx, slice_params->forward_ref_index, 0);
+	fwd_chroma = cedrus_dst_buf_addr(ctx, slice_params->forward_ref_index, 1);
+
+	bwd_luma = cedrus_dst_buf_addr(ctx, slice_params->backward_ref_index, 0);
+	bwd_chroma = cedrus_dst_buf_addr(ctx, slice_params->backward_ref_index, 1);
+
+	/* Activate MPEG engine. */
+	cedrus_engine_enable(dev, CEDRUS_CODEC_MPEG2);
+
+	/* Set quantization matrices. */
+	for (i = 0; i < 64; i++) {
+		cedrus_write(dev, VE_MPEG_IQ_MIN_INPUT, m_iq(i));
+		cedrus_write(dev, VE_MPEG_IQ_MIN_INPUT, m_niq(i));
+	}
+
+	/* Set frame dimensions. */
+	cedrus_write(dev, VE_MPEG_SIZE, width << 8 | height);
+	cedrus_write(dev, VE_MPEG_FRAME_SIZE, width << 20 | height << 4);
+
+	/* Set MPEG picture header. */
+	pic_header |= (slice_params->slice_type & 0xf) << 28;
+	pic_header |= (slice_params->f_code[0][0] & 0xf) << 24;
+	pic_header |= (slice_params->f_code[0][1] & 0xf) << 20;
+	pic_header |= (slice_params->f_code[1][0] & 0xf) << 16;
+	pic_header |= (slice_params->f_code[1][1] & 0xf) << 12;
+	pic_header |= (slice_params->intra_dc_precision & 0x3) << 10;
+	pic_header |= (slice_params->picture_structure & 0x3) << 8;
+	pic_header |= (slice_params->top_field_first & 0x1) << 7;
+	pic_header |= (slice_params->frame_pred_frame_dct & 0x1) << 6;
+	pic_header |= (slice_params->concealment_motion_vectors & 0x1) << 5;
+	pic_header |= (slice_params->q_scale_type & 0x1) << 4;
+	pic_header |= (slice_params->intra_vlc_format & 0x1) << 3;
+	pic_header |= (slice_params->alternate_scan & 0x1) << 2;
+	cedrus_write(dev, VE_MPEG_PIC_HDR, pic_header);
+
+	/* Enable interrupt and an unknown control flag. */
+	cedrus_write(dev, VE_MPEG_CTRL, VE_MPEG_CTRL_MPEG2);
+
+	/* Macroblock address. */
+	cedrus_write(dev, VE_MPEG_MBA, 0);
+
+	/* Clear previous errors. */
+	cedrus_write(dev, VE_MPEG_ERROR, 0);
+
+	/* Clear correct macroblocks register. */
+	cedrus_write(dev, VE_MPEG_CTR_MB, 0);
+
+	/* Forward and backward prediction reference buffers. */
+	cedrus_write(dev, VE_MPEG_FWD_LUMA, fwd_luma);
+	cedrus_write(dev, VE_MPEG_FWD_CHROMA, fwd_chroma);
+	cedrus_write(dev, VE_MPEG_BACK_LUMA, bwd_luma);
+	cedrus_write(dev, VE_MPEG_BACK_CHROMA, bwd_chroma);
+
+	/* Destination luma and chroma buffers. */
+	dst_luma_addr = cedrus_dst_buf_addr(ctx, run->dst->vb2_buf.index, 0);
+	dst_chroma_addr = cedrus_dst_buf_addr(ctx, run->dst->vb2_buf.index, 1);
+
+	cedrus_write(dev, VE_MPEG_REC_LUMA, dst_luma_addr);
+	cedrus_write(dev, VE_MPEG_REC_CHROMA, dst_chroma_addr);
+	cedrus_write(dev, VE_MPEG_ROT_LUMA, dst_luma_addr);
+	cedrus_write(dev, VE_MPEG_ROT_CHROMA, dst_chroma_addr);
+
+	/* Source offset and length in bits. */
+	cedrus_write(dev, VE_MPEG_VLD_OFFSET, slice_params->slice_pos);
+	cedrus_write(dev, VE_MPEG_VLD_LEN, vld_len);
+
+	/* Source beginning and end addresses. */
+	src_buf_addr = vb2_dma_contig_plane_dma_addr(&run->src->vb2_buf, 0);
+	cedrus_write(dev, VE_MPEG_VLD_ADDR, VE_MPEG_VLD_ADDR_VAL(src_buf_addr));
+	cedrus_write(dev, VE_MPEG_VLD_END, src_buf_addr + VBV_SIZE - 1);
+}
+
+static void cedrus_mpeg2_trigger(struct cedrus_ctx *ctx)
+{
+	struct cedrus_dev *dev = ctx->dev;
+
+	/* Trigger MPEG engine. */
+	cedrus_write(dev, VE_MPEG_TRIGGER, VE_TRIG_MPEG2);
+}
+
+struct cedrus_dec_ops cedrus_dec_ops_mpeg2 = {
+	.irq_clear	= cedrus_mpeg2_irq_clear,
+	.irq_disable	= cedrus_mpeg2_irq_disable,
+	.irq_status	= cedrus_mpeg2_irq_status,
+	.setup		= cedrus_mpeg2_setup,
+	.trigger	= cedrus_mpeg2_trigger,
+};
diff --git a/drivers/media/platform/sunxi/cedrus/cedrus_regs.h b/drivers/media/platform/sunxi/cedrus/cedrus_regs.h
new file mode 100644
index 000000000000..15edc5b13d65
--- /dev/null
+++ b/drivers/media/platform/sunxi/cedrus/cedrus_regs.h
@@ -0,0 +1,195 @@
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
+#ifndef _CEDRUS_REGS_H_
+#define _CEDRUS_REGS_H_
+
+/*
+ * For more information, consult http://linux-sunxi.org/VE_Register_guide
+ */
+
+/* VE_MPEG_CTRL:
+ * The bit 3 (0x8) is used to enable IRQs
+ * The other bits are unknown but needed
+ */
+#define VE_MPEG_CTRL_MPEG2	0x800001b8
+#define VE_MPEG_CTRL_MPEG4	(0x80084118 | BIT(7))
+#define VE_MPEG_CTRL_MPEG4_P	(VE_MPEG_CTRL_MPEG4 | BIT(12))
+
+/* VE_MPEG_VLD_ADDR:
+ * The bits 27 to 4 are used for the address
+ * The bits 31 to 28 (0x7) are used to select the MPEG or JPEG engine
+ */
+#define VE_MPEG_VLD_ADDR_VAL(x)	((x & 0x0ffffff0) | (x >> 28) | (0x7 << 28))
+
+/* VE_MPEG_TRIGGER:
+ * The first three bits are used to trigger the engine
+ * The bits 24 to 26 are used to select the input format (1 for MPEG1, 2 for
+ *                           MPEG2, 4 for MPEG4)
+ * The bit 21 (0x8) is used to disable bitstream error handling
+ *
+ * In MPEG4 the w*h value is somehow used for an offset, unknown but needed
+ */
+#define VE_TRIG_MPEG1		0x8100000f
+#define VE_TRIG_MPEG2		0x8200000f
+#define VE_TRIG_MPEG4(w, h)	(0x8400000d | ((w * h) << 8))
+
+/* VE_MPEG_SDROT_CTRL:
+ * The bit 8 at zero is used to disable x downscaling
+ * The bit 10 at 0 is used to disable y downscaling
+ * The other bits are unknown but needed
+ */
+#define VE_NO_SDROT_CTRL	0x40620000
+
+/* Decent size fo video buffering verifier */
+#define VBV_SIZE		(1024 * 1024)
+
+/* Registers addresses */
+#define VE_CTRL				0x000
+/*
+ * The datasheet states that this should be set to 2MB on a 32bits
+ * DDR-3.
+ */
+#define VE_CTRL_REC_WR_MODE_2MB			(1 << 20)
+#define VE_CTRL_REC_WR_MODE_1MB			(0 << 20)
+
+#define VE_CTRL_CACHE_BUS_BW_128		(3 << 16)
+#define VE_CTRL_CACHE_BUS_BW_256		(2 << 16)
+
+#define VE_CTRL_DEC_MODE_DISABLED		(7 << 0)
+#define VE_CTRL_DEC_MODE_H265			(4 << 0)
+#define VE_CTRL_DEC_MODE_H264			(1 << 0)
+#define VE_CTRL_DEC_MODE_MPEG			(0 << 0)
+
+#define VE_PRIMARY_OUT_FMT_MB32_NV12		(0 << 4)
+#define VE_PRIMARY_OUT_FMT_MB128_NV12		(1 << 4)
+#define VE_PRIMARY_OUT_FMT_YU12			(2 << 4)
+#define VE_PRIMARY_OUT_FMT_YV12			(3 << 4)
+#define VE_PRIMARY_OUT_FMT_NV12			(4 << 4)
+#define VE_PRIMARY_OUT_FMT_NV21			(5 << 4)
+
+#define VE_SECONDARY_SPECIAL_OUT_FMT_MB32_NV12	(0 << 0)
+#define VE_SECONDARY_SPECIAL_OUT_FMT_MB128_NV12	(1 << 0)
+#define VE_SECONDARY_SPECIAL_OUT_FMT_YU12	(2 << 0)
+#define VE_SECONDARY_SPECIAL_OUT_FMT_YV12	(3 << 0)
+#define VE_SECONDARY_SPECIAL_OUT_FMT_NV12	(4 << 0)
+#define VE_SECONDARY_SPECIAL_OUT_FMT_NV21	(5 << 0)
+
+#define VE_SECONDARY_OUT_FMT_MB32_NV12		(0 << 30)
+#define VE_SECONDARY_OUT_FMT_SPECIAL		(1 << 30)
+#define VE_SECONDARY_OUT_FMT_YU12		(2 << 30)
+#define VE_SECONDARY_OUT_FMT_YV12		(3 << 30)
+
+#define VE_LUMA_LINE_STRIDE_SHIFT		0
+#define VE_CHROMA_LINE_STRIDE_SHIFT		16
+
+#define VE_VERSION_SHIFT			16
+
+#define VE_PRIMARY_CHROMA_BUF_LEN	0x0c4
+#define VE_PRIMARY_FB_LINE_STRIDE	0x0c8
+#define VE_CHROMA_BUF_LEN		0x0e8
+#define VE_PRIMARY_OUT_FMT		0x0ec
+#define VE_VERSION			0x0f0
+
+#define VE_MPEG_PIC_HDR			0x100
+#define VE_MPEG_VOP_HDR			0x104
+#define VE_MPEG_SIZE			0x108
+#define VE_MPEG_FRAME_SIZE		0x10c
+#define VE_MPEG_MBA			0x110
+#define VE_MPEG_CTRL			0x114
+#define VE_MPEG_TRIGGER			0x118
+#define VE_MPEG_STATUS			0x11c
+#define VE_MPEG_TRBTRD_FIELD		0x120
+#define VE_MPEG_TRBTRD_FRAME		0x124
+#define VE_MPEG_VLD_ADDR		0x128
+#define VE_MPEG_VLD_OFFSET		0x12c
+#define VE_MPEG_VLD_LEN			0x130
+#define VE_MPEG_VLD_END			0x134
+#define VE_MPEG_MBH_ADDR		0x138
+#define VE_MPEG_DCAC_ADDR		0x13c
+#define VE_MPEG_NCF_ADDR		0x144
+#define VE_MPEG_REC_LUMA		0x148
+#define VE_MPEG_REC_CHROMA		0x14c
+#define VE_MPEG_FWD_LUMA		0x150
+#define VE_MPEG_FWD_CHROMA		0x154
+#define VE_MPEG_BACK_LUMA		0x158
+#define VE_MPEG_BACK_CHROMA		0x15c
+#define VE_MPEG_IQ_MIN_INPUT		0x180
+#define VE_MPEG_QP_INPUT		0x184
+#define VE_MPEG_JPEG_SIZE		0x1b8
+#define VE_MPEG_JPEG_RES_INT		0x1c0
+#define VE_MPEG_ERROR			0x1c4
+#define VE_MPEG_CTR_MB			0x1c8
+#define VE_MPEG_ROT_LUMA		0x1cc
+#define VE_MPEG_ROT_CHROMA		0x1d0
+#define VE_MPEG_SDROT_CTRL		0x1d4
+#define VE_MPEG_RAM_WRITE_PTR		0x1e0
+#define VE_MPEG_RAM_WRITE_DATA		0x1e4
+
+#define VE_H264_FRAME_SIZE		0x200
+#define VE_H264_PIC_HDR			0x204
+#define VE_H264_SLICE_HDR		0x208
+#define VE_H264_SLICE_HDR2		0x20c
+#define VE_H264_PRED_WEIGHT		0x210
+#define VE_H264_QP_PARAM		0x21c
+#define VE_H264_CTRL			0x220
+#define VE_H264_TRIGGER			0x224
+#define VE_H264_STATUS			0x228
+#define VE_H264_CUR_MB_NUM		0x22c
+#define VE_H264_VLD_ADDR		0x230
+#define VE_H264_VLD_OFFSET		0x234
+#define VE_H264_VLD_LEN			0x238
+#define VE_H264_VLD_END			0x23c
+#define VE_H264_SDROT_CTRL		0x240
+#define VE_H264_OUTPUT_FRAME_IDX	0x24c
+#define VE_H264_EXTRA_BUFFER1		0x250
+#define VE_H264_EXTRA_BUFFER2		0x254
+#define VE_H264_BASIC_BITS		0x2dc
+#define VE_H264_RAM_WRITE_PTR		0x2e0
+#define VE_H264_RAM_WRITE_DATA		0x2e4
+
+#define VE_SRAM_H264_PRED_WEIGHT_TABLE	0x000
+#define VE_SRAM_H264_FRAMEBUFFER_LIST	0x400
+#define VE_SRAM_H264_REF_LIST0		0x640
+#define VE_SRAM_H264_REF_LIST1		0x664
+#define VE_SRAM_H264_SCALING_LISTS	0x800
+
+#define VE_ISP_INPUT_SIZE		0xa00
+#define VE_ISP_INPUT_STRIDE		0xa04
+#define VE_ISP_CTRL			0xa08
+#define VE_ISP_INPUT_LUMA		0xa78
+#define VE_ISP_INPUT_CHROMA		0xa7c
+
+#define VE_AVC_PARAM			0xb04
+#define VE_AVC_QP			0xb08
+#define VE_AVC_MOTION_EST		0xb10
+#define VE_AVC_CTRL			0xb14
+#define VE_AVC_TRIGGER			0xb18
+#define VE_AVC_STATUS			0xb1c
+#define VE_AVC_BASIC_BITS		0xb20
+#define VE_AVC_UNK_BUF			0xb60
+#define VE_AVC_VLE_ADDR			0xb80
+#define VE_AVC_VLE_END			0xb84
+#define VE_AVC_VLE_OFFSET		0xb88
+#define VE_AVC_VLE_MAX			0xb8c
+#define VE_AVC_VLE_LENGTH		0xb90
+#define VE_AVC_REF_LUMA			0xba0
+#define VE_AVC_REF_CHROMA		0xba4
+#define VE_AVC_REC_LUMA			0xbb0
+#define VE_AVC_REC_CHROMA		0xbb4
+#define VE_AVC_REF_SLUMA		0xbb8
+#define VE_AVC_REC_SLUMA		0xbbc
+#define VE_AVC_MB_INFO			0xbc0
+
+#endif
diff --git a/drivers/media/platform/sunxi/cedrus/cedrus_video.c b/drivers/media/platform/sunxi/cedrus/cedrus_video.c
new file mode 100644
index 000000000000..0a9420b1c827
--- /dev/null
+++ b/drivers/media/platform/sunxi/cedrus/cedrus_video.c
@@ -0,0 +1,556 @@
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
+static int cedrus_enum_fmt(struct v4l2_fmtdesc *f, u32 direction)
+{
+	struct cedrus_format *fmt;
+	unsigned int i, index;
+
+	/* Index among formats that match the requested direction. */
+	index = 0;
+
+	for (i = 0; i < CEDRUS_FORMATS_COUNT; i++) {
+		if (cedrus_formats[i].directions & direction) {
+			if (index == f->index)
+				break;
+
+			index++;
+		}
+	}
+
+	/* Matched format. */
+	if (i < CEDRUS_FORMATS_COUNT) {
+		fmt = &cedrus_formats[i];
+		f->pixelformat = fmt->pixelformat;
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
+	return cedrus_enum_fmt(f, CEDRUS_DECODE_DST);
+}
+
+static int cedrus_enum_fmt_vid_out(struct file *file, void *priv,
+				   struct v4l2_fmtdesc *f)
+{
+	return cedrus_enum_fmt(f, CEDRUS_DECODE_SRC);
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
+				    CEDRUS_MAX_HEIGHT);
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
+	.vidioc_enum_fmt_vid_cap	= cedrus_enum_fmt_vid_cap,
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
diff --git a/drivers/media/platform/sunxi/cedrus/cedrus_video.h b/drivers/media/platform/sunxi/cedrus/cedrus_video.h
new file mode 100644
index 000000000000..56afcc8c02ba
--- /dev/null
+++ b/drivers/media/platform/sunxi/cedrus/cedrus_video.h
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
2.17.1
