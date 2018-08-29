Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:54238 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725723AbeH2FCe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Aug 2018 01:02:34 -0400
Message-ID: <f15e355ece0b250a252347ec22f1433dd786bb5b.camel@collabora.com>
Subject: Re: [PATCH v8 4/8] media: platform: Add Cedrus VPU decoder driver
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-sunxi@googlegroups.com
Date: Tue, 28 Aug 2018 22:08:00 -0300
In-Reply-To: <20180828073424.30247-5-paul.kocialkowski@bootlin.com>
References: <20180828073424.30247-1-paul.kocialkowski@bootlin.com>
         <20180828073424.30247-5-paul.kocialkowski@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2018-08-28 at 09:34 +0200, Paul Kocialkowski wrote:
> This introduces the Cedrus VPU driver that supports the VPU found in
> Allwinner SoCs, also known as Video Engine. It is implemented through
> a v4l2 m2m decoder device and a media device (used for media requests).
> So far, it only supports MPEG2 decoding.
> 
> Since this VPU is stateless, synchronization with media requests is
> required in order to ensure consistency between frame headers that
> contain metadata about the frame to process and the raw slice data that
> is used to generate the frame.
> 
> This driver was made possible thanks to the long-standing effort
> carried out by the linux-sunxi community in the interest of reverse
> engineering, documenting and implementing support for Allwinner VPU.
> 
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> ---
>  MAINTAINERS                                   |   7 +
>  drivers/staging/media/Kconfig                 |   2 +
>  drivers/staging/media/Makefile                |   1 +
>  drivers/staging/media/sunxi/Kconfig           |  15 +
>  drivers/staging/media/sunxi/Makefile          |   1 +
>  drivers/staging/media/sunxi/cedrus/Kconfig    |  14 +
>  drivers/staging/media/sunxi/cedrus/Makefile   |   3 +
>  drivers/staging/media/sunxi/cedrus/cedrus.c   | 420 +++++++++++++
>  drivers/staging/media/sunxi/cedrus/cedrus.h   | 167 +++++
>  .../staging/media/sunxi/cedrus/cedrus_dec.c   | 116 ++++
>  .../staging/media/sunxi/cedrus/cedrus_dec.h   |  28 +
>  .../staging/media/sunxi/cedrus/cedrus_hw.c    | 322 ++++++++++
>  .../staging/media/sunxi/cedrus/cedrus_hw.h    |  30 +
>  .../staging/media/sunxi/cedrus/cedrus_mpeg2.c | 235 +++++++
>  .../staging/media/sunxi/cedrus/cedrus_regs.h  | 233 +++++++
>  .../staging/media/sunxi/cedrus/cedrus_video.c | 574 ++++++++++++++++++
>  .../staging/media/sunxi/cedrus/cedrus_video.h |  32 +
>  17 files changed, 2200 insertions(+)
>  create mode 100644 drivers/staging/media/sunxi/Kconfig
>  create mode 100644 drivers/staging/media/sunxi/Makefile
>  create mode 100644 drivers/staging/media/sunxi/cedrus/Kconfig
>  create mode 100644 drivers/staging/media/sunxi/cedrus/Makefile
>  create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus.c
>  create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus.h
>  create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_dec.c
>  create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_dec.h
>  create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_hw.c
>  create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_hw.h
>  create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
>  create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_regs.h
>  create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_video.c
>  create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_video.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 435e6c08c694..08065d53c69d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -656,6 +656,13 @@ L:	linux-crypto@vger.kernel.org
>  S:	Maintained
>  F:	drivers/crypto/sunxi-ss/
>  
> +ALLWINNER VPU DRIVER
> +M:	Maxime Ripard <maxime.ripard@bootlin.com>
> +M:	Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> +L:	linux-media@vger.kernel.org
> +S:	Maintained
> +F:	drivers/staging/media/sunxi/cedrus/
> +
>  ALPHA PORT
>  M:	Richard Henderson <rth@twiddle.net>
>  M:	Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
> index db5cf67047ad..b3620a8f2d9f 100644
> --- a/drivers/staging/media/Kconfig
> +++ b/drivers/staging/media/Kconfig
> @@ -31,6 +31,8 @@ source "drivers/staging/media/mt9t031/Kconfig"
>  
>  source "drivers/staging/media/omap4iss/Kconfig"
>  
> +source "drivers/staging/media/sunxi/Kconfig"
> +
>  source "drivers/staging/media/tegra-vde/Kconfig"
>  
>  source "drivers/staging/media/zoran/Kconfig"
> diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
> index 503fbe47fa58..42948f805548 100644
> --- a/drivers/staging/media/Makefile
> +++ b/drivers/staging/media/Makefile
> @@ -5,5 +5,6 @@ obj-$(CONFIG_SOC_CAMERA_IMX074)	+= imx074/
>  obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= mt9t031/
>  obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
>  obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
> +obj-$(CONFIG_VIDEO_SUNXI)	+= sunxi/
>  obj-$(CONFIG_TEGRA_VDE)		+= tegra-vde/
>  obj-$(CONFIG_VIDEO_ZORAN)	+= zoran/
> diff --git a/drivers/staging/media/sunxi/Kconfig b/drivers/staging/media/sunxi/Kconfig
> new file mode 100644
> index 000000000000..c78d92240ceb
> --- /dev/null
> +++ b/drivers/staging/media/sunxi/Kconfig
> @@ -0,0 +1,15 @@
> +config VIDEO_SUNXI
> +	bool "Allwinner sunXi family Video Devices"
> +	depends on ARCH_SUNXI || COMPILE_TEST
> +	help
> +	  If you have an Allwinner SoC based on the sunXi family, say Y.
> +
> +	  Note that this option doesn't include new drivers in the
> +	  kernel: saying N will just cause Kconfig to skip all the
> +	  questions about Allwinner media devices.
> +
> +if VIDEO_SUNXI
> +
> +source "drivers/staging/media/sunxi/cedrus/Kconfig"
> +
> +endif
> diff --git a/drivers/staging/media/sunxi/Makefile b/drivers/staging/media/sunxi/Makefile
> new file mode 100644
> index 000000000000..cee2846c3ecf
> --- /dev/null
> +++ b/drivers/staging/media/sunxi/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_VIDEO_SUNXI_CEDRUS)	+= cedrus/
> diff --git a/drivers/staging/media/sunxi/cedrus/Kconfig b/drivers/staging/media/sunxi/cedrus/Kconfig
> new file mode 100644
> index 000000000000..afd7d7ee0388
> --- /dev/null
> +++ b/drivers/staging/media/sunxi/cedrus/Kconfig
> @@ -0,0 +1,14 @@
> +config VIDEO_SUNXI_CEDRUS
> +	tristate "Allwinner Cedrus VPU driver"
> +	depends on VIDEO_DEV && VIDEO_V4L2 && MEDIA_CONTROLLER
> +	depends on HAS_DMA
> +	depends on OF
> +	select VIDEOBUF2_DMA_CONTIG
> +	select MEDIA_REQUEST_API
> +	select V4L2_MEM2MEM_DEV
> +	help
> +	  Support for the VPU found in Allwinner SoCs, also known as the Cedar
> +	  video engine.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called sunxi-cedrus.
> diff --git a/drivers/staging/media/sunxi/cedrus/Makefile b/drivers/staging/media/sunxi/cedrus/Makefile
> new file mode 100644
> index 000000000000..e9dc68b7bcb6
> --- /dev/null
> +++ b/drivers/staging/media/sunxi/cedrus/Makefile
> @@ -0,0 +1,3 @@
> +obj-$(CONFIG_VIDEO_SUNXI_CEDRUS) += sunxi-cedrus.o
> +
> +sunxi-cedrus-y = cedrus.o cedrus_video.o cedrus_hw.o cedrus_dec.o cedrus_mpeg2.o
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/staging/media/sunxi/cedrus/cedrus.c
> new file mode 100644
> index 000000000000..7c0f90253135
> --- /dev/null
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
> @@ -0,0 +1,420 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Cedrus VPU driver
> + *
> + * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.com>
> + * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> + * Copyright (C) 2018 Bootlin
> + *
> + * Based on the vim2m driver, that is:
> + *
> + * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
> + * Pawel Osciak, <pawel@osciak.com>
> + * Marek Szyprowski, <m.szyprowski@samsung.com>
> + */
> +
> +#include <linux/platform_device.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-mem2mem.h>
> +
> +#include "cedrus.h"
> +#include "cedrus_video.h"
> +#include "cedrus_dec.h"
> +#include "cedrus_hw.h"
> +
> +static const struct cedrus_control cedrus_controls[] = {
> +	{
> +		.id		= V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS,
> +		.elem_size	= sizeof(struct v4l2_ctrl_mpeg2_slice_params),
> +		.codec		= CEDRUS_CODEC_MPEG2,
> +		.required	= true,
> +	},
> +	{
> +		.id		= V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION,
> +		.elem_size	= sizeof(struct v4l2_ctrl_mpeg2_quantization),
> +		.codec		= CEDRUS_CODEC_MPEG2,
> +		.required	= false,
> +	},
> +};
> +
> +#define CEDRUS_CONTROLS_COUNT	ARRAY_SIZE(cedrus_controls)
> +
> +void *cedrus_find_control_data(struct cedrus_ctx *ctx, u32 id)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; ctx->ctrls[i] != NULL; i++)
> +		if (ctx->ctrls[i]->id == id)
> +			return ctx->ctrls[i]->p_cur.p;
> +
> +	return NULL;
> +}
> +
> +static int cedrus_init_ctrls(struct cedrus_dev *dev, struct cedrus_ctx *ctx)
> +{
> +	struct v4l2_ctrl_handler *hdl = &ctx->hdl;
> +	struct v4l2_ctrl *ctrl;
> +	unsigned int ctrl_size;
> +	unsigned int i;
> +
> +	v4l2_ctrl_handler_init(hdl, CEDRUS_CONTROLS_COUNT);
> +	if (hdl->error) {
> +		v4l2_err(&dev->v4l2_dev,
> +			 "Failed to initialize control handler\n");
> +		return hdl->error;
> +	}
> +
> +	ctrl_size = sizeof(ctrl) * CEDRUS_CONTROLS_COUNT + 1;
> +
> +	ctx->ctrls = kzalloc(ctrl_size, GFP_KERNEL);
> +	memset(ctx->ctrls, 0, ctrl_size);
> +
> +	for (i = 0; i < CEDRUS_CONTROLS_COUNT; i++) {
> +		struct v4l2_ctrl_config cfg = { 0 };
> +
> +		cfg.elem_size = cedrus_controls[i].elem_size;
> +		cfg.id = cedrus_controls[i].id;
> +
> +		ctrl = v4l2_ctrl_new_custom(hdl, &cfg, NULL);
> +		if (hdl->error) {
> +			v4l2_err(&dev->v4l2_dev,
> +				 "Failed to create new custom control\n");
> +
> +			v4l2_ctrl_handler_free(hdl);
> +			kfree(ctx->ctrls);
> +			return hdl->error;
> +		}
> +
> +		ctx->ctrls[i] = ctrl;
> +	}
> +
> +	ctx->fh.ctrl_handler = hdl;
> +	v4l2_ctrl_handler_setup(hdl);
> +
> +	return 0;
> +}
> +
> +static int cedrus_request_validate(struct media_request *req)
> +{
> +	struct media_request_object *obj, *obj_safe;
> +	struct v4l2_ctrl_handler *parent_hdl, *hdl;
> +	struct cedrus_ctx *ctx = NULL;
> +	struct v4l2_ctrl *ctrl_test;
> +	unsigned int i;
> +
> +	list_for_each_entry_safe(obj, obj_safe, &req->objects, list) {
> +		struct vb2_buffer *vb;
> +
> +		if (vb2_request_object_is_buffer(obj)) {
> +			vb = container_of(obj, struct vb2_buffer, req_obj);
> +			ctx = vb2_get_drv_priv(vb->vb2_queue);
> +
> +			break;
> +		}
> +	}
> +
> +	if (!ctx)
> +		return -ENOENT;
> +
> +	parent_hdl = &ctx->hdl;
> +
> +	hdl = v4l2_ctrl_request_hdl_find(req, parent_hdl);
> +	if (!hdl) {
> +		v4l2_err(&ctx->dev->v4l2_dev, "Missing codec control(s)\n");
> +		return -ENOENT;
> +	}
> +
> +	for (i = 0; i < CEDRUS_CONTROLS_COUNT; i++) {
> +		if (cedrus_controls[i].codec != ctx->current_codec ||
> +		    !cedrus_controls[i].required)
> +			continue;
> +
> +		ctrl_test = v4l2_ctrl_request_hdl_ctrl_find(hdl,
> +			cedrus_controls[i].id);
> +		if (!ctrl_test) {
> +			v4l2_err(&ctx->dev->v4l2_dev,
> +				 "Missing required codec control\n");
> +			return -ENOENT;
> +		}
> +	}
> +
> +	v4l2_ctrl_request_hdl_put(hdl);
> +
> +	return vb2_request_validate(req);
> +}
> +
> +static int cedrus_open(struct file *file)
> +{
> +	struct cedrus_dev *dev = video_drvdata(file);
> +	struct cedrus_ctx *ctx = NULL;
> +	int ret;
> +
> +	if (mutex_lock_interruptible(&dev->dev_mutex))
> +		return -ERESTARTSYS;
> +
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx) {
> +		mutex_unlock(&dev->dev_mutex);
> +		return -ENOMEM;
> +	}
> +
> +	v4l2_fh_init(&ctx->fh, video_devdata(file));
> +	file->private_data = &ctx->fh;
> +	ctx->dev = dev;
> +
> +	ret = cedrus_init_ctrls(dev, ctx);
> +	if (ret)
> +		goto err_free;
> +
> +	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx,
> +					    &cedrus_queue_init);
> +	if (IS_ERR(ctx->fh.m2m_ctx)) {
> +		ret = PTR_ERR(ctx->fh.m2m_ctx);
> +		goto err_ctrls;
> +	}
> +
> +	v4l2_fh_add(&ctx->fh);
> +
> +	mutex_unlock(&dev->dev_mutex);
> +
> +	return 0;
> +
> +err_ctrls:
> +	v4l2_ctrl_handler_free(&ctx->hdl);
> +err_free:
> +	kfree(ctx);
> +	mutex_unlock(&dev->dev_mutex);
> +
> +	return ret;
> +}
> +
> +static int cedrus_release(struct file *file)
> +{
> +	struct cedrus_dev *dev = video_drvdata(file);
> +	struct cedrus_ctx *ctx = container_of(file->private_data,
> +					      struct cedrus_ctx, fh);
> +
> +	mutex_lock(&dev->dev_mutex);
> +
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
> +
> +	v4l2_ctrl_handler_free(&ctx->hdl);
> +	kfree(ctx->ctrls);
> +
> +	v4l2_fh_exit(&ctx->fh);
> +
> +	kfree(ctx);
> +
> +	mutex_unlock(&dev->dev_mutex);
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_file_operations cedrus_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= cedrus_open,
> +	.release	= cedrus_release,
> +	.poll		= v4l2_m2m_fop_poll,
> +	.unlocked_ioctl	= video_ioctl2,
> +	.mmap		= v4l2_m2m_fop_mmap,
> +};
> +
> +static const struct video_device cedrus_video_device = {
> +	.name		= CEDRUS_NAME,
> +	.vfl_dir	= VFL_DIR_M2M,
> +	.fops		= &cedrus_fops,
> +	.ioctl_ops	= &cedrus_ioctl_ops,
> +	.minor		= -1,
> +	.release	= video_device_release_empty,
> +	.device_caps	= V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING,
> +};
> +
> +static const struct v4l2_m2m_ops cedrus_m2m_ops = {
> +	.device_run	= cedrus_device_run,
> +	.job_abort	= cedrus_job_abort,
> +};
> +

I think you can get rid of this .job_abort. It should
simplify your .device_run quite a bit.

.job_abort is optional now since 5525b8314389a0c558d15464e86f438974b94e32.

Regards,
Ezequiel
