Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:54277 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726121AbeGRKfe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jul 2018 06:35:34 -0400
Subject: Re: [PATCH 3/3] media: add Rockchip VPU driver
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>
References: <20180705172819.5588-1-ezequiel@collabora.com>
 <20180705172819.5588-4-ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3ea4cbc3-d7df-5860-46ec-9302b19bd713@xs4all.nl>
Date: Wed, 18 Jul 2018 11:58:22 +0200
MIME-Version: 1.0
In-Reply-To: <20180705172819.5588-4-ezequiel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/07/18 19:28, Ezequiel Garcia wrote:
> Add a mem2mem driver for the VPU available on Rockchip SoCs.
> Currently only JPEG encoding is supported, for RK3399 and RK3288
> platforms.
> 
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  drivers/media/platform/Kconfig                |  12 +
>  drivers/media/platform/Makefile               |   1 +
>  drivers/media/platform/rockchip/vpu/Makefile  |   8 +
>  .../platform/rockchip/vpu/rk3288_vpu_hw.c     | 127 +++
>  .../rockchip/vpu/rk3288_vpu_hw_jpege.c        | 156 ++++
>  .../platform/rockchip/vpu/rk3288_vpu_regs.h   | 442 ++++++++++
>  .../platform/rockchip/vpu/rk3399_vpu_hw.c     | 127 +++
>  .../rockchip/vpu/rk3399_vpu_hw_jpege.c        | 165 ++++
>  .../platform/rockchip/vpu/rk3399_vpu_regs.h   | 601 ++++++++++++++
>  .../platform/rockchip/vpu/rockchip_vpu.h      | 270 +++++++
>  .../platform/rockchip/vpu/rockchip_vpu_drv.c  | 416 ++++++++++
>  .../platform/rockchip/vpu/rockchip_vpu_enc.c  | 763 ++++++++++++++++++
>  .../platform/rockchip/vpu/rockchip_vpu_enc.h  |  25 +
>  .../platform/rockchip/vpu/rockchip_vpu_hw.h   |  67 ++
>  14 files changed, 3180 insertions(+)
>  create mode 100644 drivers/media/platform/rockchip/vpu/Makefile
>  create mode 100644 drivers/media/platform/rockchip/vpu/rk3288_vpu_hw.c
>  create mode 100644 drivers/media/platform/rockchip/vpu/rk3288_vpu_hw_jpege.c
>  create mode 100644 drivers/media/platform/rockchip/vpu/rk3288_vpu_regs.h
>  create mode 100644 drivers/media/platform/rockchip/vpu/rk3399_vpu_hw.c
>  create mode 100644 drivers/media/platform/rockchip/vpu/rk3399_vpu_hw_jpege.c
>  create mode 100644 drivers/media/platform/rockchip/vpu/rk3399_vpu_regs.h
>  create mode 100644 drivers/media/platform/rockchip/vpu/rockchip_vpu.h
>  create mode 100644 drivers/media/platform/rockchip/vpu/rockchip_vpu_drv.c
>  create mode 100644 drivers/media/platform/rockchip/vpu/rockchip_vpu_enc.c
>  create mode 100644 drivers/media/platform/rockchip/vpu/rockchip_vpu_enc.h
>  create mode 100644 drivers/media/platform/rockchip/vpu/rockchip_vpu_hw.h
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 2728376b04b5..7244a2360732 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -448,6 +448,18 @@ config VIDEO_ROCKCHIP_RGA
>  
>  	  To compile this driver as a module choose m here.
>  
> +config VIDEO_ROCKCHIP_VPU
> +	tristate "Rockchip VPU driver"
> +	depends on VIDEO_DEV && VIDEO_V4L2
> +	depends on ARCH_ROCKCHIP || COMPILE_TEST
> +	select VIDEOBUF2_DMA_CONTIG
> +	select V4L2_MEM2MEM_DEV
> +	default n
> +	---help---
> +	  Support for the VPU video codec found on Rockchip SoC.
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called rockchip-vpu.
> +
>  config VIDEO_TI_VPE
>  	tristate "TI VPE (Video Processing Engine) driver"
>  	depends on VIDEO_DEV && VIDEO_V4L2
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index 04bc1502a30e..83378180d8ac 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -66,6 +66,7 @@ obj-$(CONFIG_VIDEO_RENESAS_JPU)		+= rcar_jpu.o
>  obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1/
>  
>  obj-$(CONFIG_VIDEO_ROCKCHIP_RGA)	+= rockchip/rga/
> +obj-$(CONFIG_VIDEO_ROCKCHIP_VPU)        += rockchip/vpu/
>  
>  obj-y	+= omap/
>  
> diff --git a/drivers/media/platform/rockchip/vpu/Makefile b/drivers/media/platform/rockchip/vpu/Makefile
> new file mode 100644
> index 000000000000..cab0123c49d4
> --- /dev/null
> +++ b/drivers/media/platform/rockchip/vpu/Makefile
> @@ -0,0 +1,8 @@
> +obj-$(CONFIG_VIDEO_ROCKCHIP_VPU) += rockchip-vpu.o
> +
> +rockchip-vpu-y += rockchip_vpu_drv.o \
> +		rockchip_vpu_enc.o \
> +		rk3288_vpu_hw.o \
> +		rk3288_vpu_hw_jpege.o \
> +		rk3399_vpu_hw.o \
> +		rk3399_vpu_hw_jpege.o
> diff --git a/drivers/media/platform/rockchip/vpu/rk3288_vpu_hw.c b/drivers/media/platform/rockchip/vpu/rk3288_vpu_hw.c
> new file mode 100644
> index 000000000000..0caff8ecf343
> --- /dev/null
> +++ b/drivers/media/platform/rockchip/vpu/rk3288_vpu_hw.c
> @@ -0,0 +1,127 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Rockchip VPU codec driver
> + *
> + * Copyright (C) 2018 Rockchip Electronics Co., Ltd.
> + *	Jeffy Chen <jeffy.chen@rock-chips.com>
> + */
> +
> +#include <linux/clk.h>
> +
> +#include "rockchip_vpu.h"
> +#include "rk3288_vpu_regs.h"
> +
> +#define RK3288_ACLK_MAX_FREQ (400 * 1000 * 1000)
> +
> +/*
> + * Supported formats.
> + */
> +
> +static const struct rockchip_vpu_fmt rk3288_vpu_enc_fmts[] = {
> +	/* Source formats. */
> +	{
> +		.name = "4:2:0 3 planes Y/Cb/Cr",

Drop the name field, it's not needed.

> +		.fourcc = V4L2_PIX_FMT_YUV420M,
> +		.codec_mode = RK_VPU_CODEC_NONE,
> +		.num_planes = 3,
> +		.depth = { 8, 4, 4 },
> +		.enc_fmt = RK3288_VPU_ENC_FMT_YUV420P,
> +	},
> +	{
> +		.name = "4:2:0 2 plane Y/CbCr",
> +		.fourcc = V4L2_PIX_FMT_NV12M,
> +		.codec_mode = RK_VPU_CODEC_NONE,
> +		.num_planes = 2,
> +		.depth = { 8, 8 },
> +		.enc_fmt = RK3288_VPU_ENC_FMT_YUV420SP,
> +	},
> +	{
> +		.name = "4:2:2 1 plane YUYV",
> +		.fourcc = V4L2_PIX_FMT_YUYV,
> +		.codec_mode = RK_VPU_CODEC_NONE,
> +		.num_planes = 1,
> +		.depth = { 16 },
> +		.enc_fmt = RK3288_VPU_ENC_FMT_YUYV422,
> +	},
> +	{
> +		.name = "4:2:2 1 plane UYVY",
> +		.fourcc = V4L2_PIX_FMT_UYVY,
> +		.codec_mode = RK_VPU_CODEC_NONE,
> +		.num_planes = 1,
> +		.depth = { 16 },
> +		.enc_fmt = RK3288_VPU_ENC_FMT_UYVY422,
> +	},
> +	/* Destination formats. */
> +	{
> +		.name = "JPEG Encoded Stream",
> +		.fourcc = V4L2_PIX_FMT_JPEG_RAW,
> +		.codec_mode = RK_VPU_CODEC_JPEGE,
> +		.num_planes = 1,
> +		.frmsize = {
> +			.min_width = 96,
> +			.max_width = 8192,
> +			.step_width = MB_DIM,
> +			.min_height = 32,
> +			.max_height = 8192,
> +			.step_height = MB_DIM,
> +		},
> +	},
> +};

<snip>

> diff --git a/drivers/media/platform/rockchip/vpu/rockchip_vpu_drv.c b/drivers/media/platform/rockchip/vpu/rockchip_vpu_drv.c
> new file mode 100644
> index 000000000000..aea16850682c
> --- /dev/null
> +++ b/drivers/media/platform/rockchip/vpu/rockchip_vpu_drv.c
> @@ -0,0 +1,416 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Rockchip VPU codec driver
> + *
> + * Copyright (C) 2018 Collabora, Ltd.
> + * Copyright (C) 2014 Google, Inc.
> + *	Tomasz Figa <tfiga@chromium.org>
> + *
> + * Based on s5p-mfc driver by Samsung Electronics Co., Ltd.
> + * Copyright (C) 2011 Samsung Electronics Co., Ltd.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/slab.h>
> +#include <linux/videodev2.h>
> +#include <linux/workqueue.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-mem2mem.h>
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "rockchip_vpu.h"
> +#include "rockchip_vpu_enc.h"
> +#include "rockchip_vpu_hw.h"
> +
> +#define DRIVER_NAME "rockchip-vpu"
> +
> +int rockchip_vpu_debug;
> +module_param_named(debug, rockchip_vpu_debug, int, 0644);
> +MODULE_PARM_DESC(debug,
> +		 "Debug level - higher value produces more verbose messages");
> +
> +static inline struct rockchip_vpu_ctx *
> +rockchip_vpu_set_ctx(struct rockchip_vpu_dev *vpu,
> +		     struct rockchip_vpu_ctx *new_ctx)
> +{
> +	struct rockchip_vpu_ctx *ctx;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&vpu->irqlock, flags);
> +	ctx = vpu->running_ctx;
> +	vpu->running_ctx = new_ctx;
> +	spin_unlock_irqrestore(&vpu->irqlock, flags);
> +
> +	return ctx;
> +}
> +
> +void rockchip_vpu_irq_done(struct rockchip_vpu_dev *vpu)
> +{
> +	struct rockchip_vpu_ctx *ctx = rockchip_vpu_set_ctx(vpu, NULL);
> +
> +	/* Atomic watchdog cancel. The worker may still be
> +	 * running after calling this.
> +	 */
> +	cancel_delayed_work(&vpu->watchdog_work);
> +	if (ctx)
> +		ctx->codec_ops->done(ctx, VB2_BUF_STATE_DONE);
> +}
> +
> +void rockchip_vpu_watchdog(struct work_struct *work)
> +{
> +	struct rockchip_vpu_dev *vpu = container_of(to_delayed_work(work),
> +		struct rockchip_vpu_dev, watchdog_work);
> +	struct rockchip_vpu_ctx *ctx = rockchip_vpu_set_ctx(vpu, NULL);
> +
> +	if (ctx) {
> +		vpu_err("frame processing timed out!\n");
> +		ctx->codec_ops->reset(ctx);
> +		ctx->codec_ops->done(ctx, VB2_BUF_STATE_ERROR);
> +	}
> +}
> +
> +static void device_run(void *priv)
> +{
> +	struct rockchip_vpu_ctx *ctx = priv;
> +	struct rockchip_vpu_dev *vpu = ctx->dev;
> +
> +	rockchip_vpu_set_ctx(vpu, ctx);
> +	ctx->codec_ops->run(ctx);
> +}
> +
> +static struct v4l2_m2m_ops vpu_m2m_ops = {
> +	.device_run = device_run,
> +};
> +
> +static int
> +queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
> +{
> +	struct rockchip_vpu_ctx *ctx = priv;
> +	int ret;
> +
> +	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> +	src_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;

Any reason for setting USERPTR?

> +	src_vq->drv_priv = ctx;
> +	src_vq->ops = &rockchip_vpu_enc_queue_ops;
> +	src_vq->mem_ops = &vb2_dma_contig_memops;

It isn't really useful in combination with dma_contig.

> +	src_vq->dma_attrs = DMA_ATTR_ALLOC_SINGLE_PAGES |
> +			    DMA_ATTR_NO_KERNEL_MAPPING;
> +	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	src_vq->lock = &ctx->dev->vpu_mutex;
> +	src_vq->dev = ctx->dev->v4l2_dev.dev;
> +
> +	ret = vb2_queue_init(src_vq);
> +	if (ret)
> +		return ret;
> +
> +	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> +	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;

Ditto.

> +	dst_vq->drv_priv = ctx;
> +	dst_vq->ops = &rockchip_vpu_enc_queue_ops;
> +	dst_vq->mem_ops = &vb2_dma_contig_memops;
> +	dst_vq->dma_attrs = DMA_ATTR_ALLOC_SINGLE_PAGES;
> +	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	dst_vq->lock = &ctx->dev->vpu_mutex;
> +	dst_vq->dev = ctx->dev->v4l2_dev.dev;
> +
> +	return vb2_queue_init(dst_vq);
> +}
> +
> +/*
> + * V4L2 file operations.
> + */
> +
> +static int rockchip_vpu_open(struct file *filp)
> +{
> +	struct rockchip_vpu_dev *vpu = video_drvdata(filp);
> +	struct rockchip_vpu_ctx *ctx;
> +	int ret;
> +
> +	/*
> +	 * We do not need any extra locking here, because we operate only
> +	 * on local data here, except reading few fields from dev, which
> +	 * do not change through device's lifetime (which is guaranteed by
> +	 * reference on module from open()) and V4L2 internal objects (such
> +	 * as vdev and ctx->fh), which have proper locking done in respective
> +	 * helper functions used here.
> +	 */
> +
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx)
> +		return -ENOMEM;
> +
> +	ctx->dev = vpu;
> +	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(vpu->m2m_dev, ctx, &queue_init);
> +	if (IS_ERR(ctx->fh.m2m_ctx)) {
> +		ret = PTR_ERR(ctx->fh.m2m_ctx);
> +		kfree(ctx);
> +		return ret;
> +	}
> +	v4l2_fh_init(&ctx->fh, video_devdata(filp));
> +	filp->private_data = &ctx->fh;
> +	v4l2_fh_add(&ctx->fh);
> +
> +	ctx->colorspace = V4L2_COLORSPACE_JPEG,
> +	ctx->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
> +	ctx->quantization = V4L2_QUANTIZATION_DEFAULT;
> +	ctx->xfer_func = V4L2_XFER_FUNC_DEFAULT;
> +
> +	ret = rockchip_vpu_enc_init(ctx);
> +	if (ret) {
> +		vpu_err("Failed to initialize encoder context\n");
> +		goto err_fh_free;
> +	}
> +	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
> +	return 0;
> +
> +err_fh_free:
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +	kfree(ctx);
> +	return ret;
> +}
> +
> +static int rockchip_vpu_release(struct file *filp)
> +{
> +	struct rockchip_vpu_ctx *ctx = fh_to_ctx(filp->private_data);
> +
> +	/*
> +	 * No need for extra locking because this was the last reference
> +	 * to this file.
> +	 */
> +	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +	rockchip_vpu_enc_exit(ctx);
> +	kfree(ctx);
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_file_operations rockchip_vpu_fops = {
> +	.owner = THIS_MODULE,
> +	.open = rockchip_vpu_open,
> +	.release = rockchip_vpu_release,
> +	.poll = v4l2_m2m_fop_poll,
> +	.unlocked_ioctl = video_ioctl2,
> +	.mmap = v4l2_m2m_fop_mmap,
> +};
> +
> +static const struct of_device_id of_rockchip_vpu_match[] = {
> +	{ .compatible = "rockchip,rk3399-vpu", .data = &rk3399_vpu_variant, },
> +	{ .compatible = "rockchip,rk3288-vpu", .data = &rk3288_vpu_variant, },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, of_rockchip_vpu_match);
> +
> +static int rockchip_vpu_video_device_register(struct rockchip_vpu_dev *vpu)
> +{
> +	struct video_device *vfd;
> +	int ret;
> +
> +	vfd = video_device_alloc();
> +	if (!vfd) {
> +		v4l2_err(&vpu->v4l2_dev, "Failed to allocate video device\n");
> +		return -ENOMEM;
> +	}
> +
> +	vpu->vfd = vfd;
> +	vfd->fops = &rockchip_vpu_fops;
> +	vfd->release = video_device_release;
> +	vfd->lock = &vpu->vpu_mutex;
> +	vfd->v4l2_dev = &vpu->v4l2_dev;
> +	vfd->vfl_dir = VFL_DIR_M2M;
> +	vfd->ioctl_ops = &rockchip_vpu_enc_ioctl_ops;
> +	snprintf(vfd->name, sizeof(vfd->name), "%s-enc", DRIVER_NAME);
> +
> +	video_set_drvdata(vfd, vpu);
> +
> +	vpu->m2m_dev = v4l2_m2m_init(&vpu_m2m_ops);
> +	if (IS_ERR(vpu->m2m_dev)) {
> +		v4l2_err(&vpu->v4l2_dev, "Failed to init mem2mem device\n");
> +		ret = PTR_ERR(vpu->m2m_dev);
> +		goto err_dev_reg;
> +	}
> +
> +	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
> +	if (ret) {
> +		v4l2_err(&vpu->v4l2_dev, "Failed to register video device\n");
> +		goto err_m2m_rel;
> +	}
> +	return 0;
> +
> +err_m2m_rel:
> +	v4l2_m2m_release(vpu->m2m_dev);
> +err_dev_reg:
> +	video_device_release(vfd);
> +	return ret;
> +}
> +
> +static int rockchip_vpu_probe(struct platform_device *pdev)
> +{
> +	const struct of_device_id *match;
> +	struct rockchip_vpu_dev *vpu;
> +	struct resource *res;
> +	int irq, i, ret;
> +
> +	vpu = devm_kzalloc(&pdev->dev, sizeof(*vpu), GFP_KERNEL);
> +	if (!vpu)
> +		return -ENOMEM;
> +
> +	vpu->dev = &pdev->dev;
> +	vpu->pdev = pdev;
> +	mutex_init(&vpu->vpu_mutex);
> +	spin_lock_init(&vpu->irqlock);
> +
> +	match = of_match_node(of_rockchip_vpu_match, pdev->dev.of_node);
> +	vpu->variant = match->data;
> +
> +	INIT_DELAYED_WORK(&vpu->watchdog_work, rockchip_vpu_watchdog);
> +
> +	for (i = 0; i < vpu->variant->num_clocks; i++) {
> +		vpu->clocks[i] = devm_clk_get(&pdev->dev,
> +					      vpu->variant->clk_names[i]);
> +		if (IS_ERR(vpu->clocks[i])) {
> +			dev_err(&pdev->dev, "failed to get clock: %s\n",
> +				vpu->variant->clk_names[i]);
> +			return PTR_ERR(vpu->clocks[i]);
> +		}
> +	}
> +
> +	res = platform_get_resource(vpu->pdev, IORESOURCE_MEM, 0);
> +	vpu->base = devm_ioremap_resource(vpu->dev, res);
> +	if (IS_ERR(vpu->base))
> +		return PTR_ERR(vpu->base);
> +	vpu->enc_base = vpu->base + vpu->variant->enc_offset;
> +
> +	ret = dma_set_coherent_mask(vpu->dev, DMA_BIT_MASK(32));
> +	if (ret) {
> +		dev_err(vpu->dev, "Could not set DMA coherent mask.\n");
> +		return ret;
> +	}
> +
> +	irq = platform_get_irq_byname(vpu->pdev, "vepu");
> +	if (irq <= 0) {
> +		dev_err(vpu->dev, "Could not get vepu IRQ.\n");
> +		return -ENXIO;
> +	}
> +
> +	ret = devm_request_irq(vpu->dev, irq, vpu->variant->vepu_irq,
> +			       0, dev_name(vpu->dev), vpu);
> +	if (ret) {
> +		dev_err(vpu->dev, "Could not request vepu IRQ.\n");
> +		return ret;
> +	}
> +
> +	ret = vpu->variant->init(vpu);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to init VPU hardware\n");
> +		return ret;
> +	}
> +
> +	ret = v4l2_device_register(&pdev->dev, &vpu->v4l2_dev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to register v4l2 device\n");
> +		return ret;
> +	}
> +
> +	platform_set_drvdata(pdev, vpu);
> +
> +	pm_runtime_set_autosuspend_delay(vpu->dev, 100);
> +	pm_runtime_use_autosuspend(vpu->dev);
> +	pm_runtime_enable(vpu->dev);
> +	pm_runtime_get_sync(vpu->dev);
> +
> +	ret = rockchip_vpu_video_device_register(vpu);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to register encoder\n");
> +		goto err_v4l2_dev_unreg;
> +	}
> +
> +	return 0;
> +
> +err_v4l2_dev_unreg:
> +	v4l2_device_unregister(&vpu->v4l2_dev);
> +	pm_runtime_mark_last_busy(vpu->dev);
> +	pm_runtime_put_autosuspend(vpu->dev);
> +	pm_runtime_disable(vpu->dev);
> +	return ret;
> +}
> +
> +static int rockchip_vpu_remove(struct platform_device *pdev)
> +{
> +	struct rockchip_vpu_dev *vpu = platform_get_drvdata(pdev);
> +
> +	v4l2_info(&vpu->v4l2_dev, "Removing %s\n", pdev->name);
> +
> +	video_unregister_device(vpu->vfd);
> +	video_device_release(vpu->vfd);
> +	v4l2_device_unregister(&vpu->v4l2_dev);
> +	pm_runtime_mark_last_busy(vpu->dev);
> +	pm_runtime_put_autosuspend(vpu->dev);
> +	pm_runtime_disable(vpu->dev);
> +
> +	return 0;
> +}
> +
> +static int __maybe_unused rockchip_vpu_runtime_suspend(struct device *dev)
> +{
> +	struct rockchip_vpu_dev *vpu = dev_get_drvdata(dev);
> +	int i;
> +
> +	for (i = vpu->variant->num_clocks - 1; i >= 0; i--)
> +		clk_disable_unprepare(vpu->clocks[i]);
> +	return 0;
> +}
> +
> +static int __maybe_unused rockchip_vpu_runtime_resume(struct device *dev)
> +{
> +	struct rockchip_vpu_dev *vpu = dev_get_drvdata(dev);
> +	int i;
> +
> +	for (i = 0; i < vpu->variant->num_clocks; i++) {
> +		int ret;
> +
> +		ret = clk_prepare_enable(vpu->clocks[i]);
> +		if (ret) {
> +			while (--i >= 0)
> +				clk_disable_unprepare(vpu->clocks[i]);
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops rockchip_vpu_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
> +				pm_runtime_force_resume)
> +	SET_RUNTIME_PM_OPS(rockchip_vpu_runtime_suspend,
> +			   rockchip_vpu_runtime_resume, NULL)
> +};
> +
> +static struct platform_driver rockchip_vpu_driver = {
> +	.probe = rockchip_vpu_probe,
> +	.remove = rockchip_vpu_remove,
> +	.driver = {
> +		   .name = DRIVER_NAME,
> +		   .of_match_table = of_match_ptr(of_rockchip_vpu_match),
> +		   .pm = &rockchip_vpu_pm_ops,
> +	},
> +};
> +module_platform_driver(rockchip_vpu_driver);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Alpha Lin <Alpha.Lin@Rock-Chips.com>");
> +MODULE_AUTHOR("Tomasz Figa <tfiga@chromium.org>");
> +MODULE_AUTHOR("Ezequiel Garcia <ezequiel@collabora.com>");
> +MODULE_DESCRIPTION("Rockchip VPU codec driver");
> diff --git a/drivers/media/platform/rockchip/vpu/rockchip_vpu_enc.c b/drivers/media/platform/rockchip/vpu/rockchip_vpu_enc.c
> new file mode 100644
> index 000000000000..6a5e45f7d69f
> --- /dev/null
> +++ b/drivers/media/platform/rockchip/vpu/rockchip_vpu_enc.c
> @@ -0,0 +1,763 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Rockchip VPU codec driver
> + *
> + * Copyright (C) 2018 Collabora, Ltd.
> + * Copyright (C) 2018 Rockchip Electronics Co., Ltd.
> + *	Alpha Lin <Alpha.Lin@rock-chips.com>
> + *	Jeffy Chen <jeffy.chen@rock-chips.com>
> + *
> + * Copyright (C) 2018 Google, Inc.
> + *	Tomasz Figa <tfiga@chromium.org>
> + *
> + * Based on s5p-mfc driver by Samsung Electronics Co., Ltd.
> + * Copyright (C) 2010-2011 Samsung Electronics Co., Ltd.
> + */
> +
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/videodev2.h>
> +#include <linux/workqueue.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-mem2mem.h>
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-dma-sg.h>
> +
> +#include "rockchip_vpu.h"
> +#include "rockchip_vpu_enc.h"
> +#include "rockchip_vpu_hw.h"
> +
> +#define JPEG_MAX_BYTES_PER_PIXEL 2
> +
> +static const struct rockchip_vpu_fmt *
> +rockchip_vpu_find_format(struct rockchip_vpu_dev *dev, u32 fourcc)
> +{
> +	const struct rockchip_vpu_fmt *formats = dev->variant->enc_fmts;
> +	unsigned int i;
> +
> +	for (i = 0; i < dev->variant->num_enc_fmts; i++) {
> +		if (formats[i].fourcc == fourcc)
> +			return &formats[i];
> +	}
> +
> +	return NULL;
> +}
> +
> +static const struct rockchip_vpu_fmt *
> +rockchip_vpu_get_default_fmt(struct rockchip_vpu_dev *dev, bool bitstream)
> +{
> +	const struct rockchip_vpu_fmt *formats = dev->variant->enc_fmts;
> +	unsigned int i;
> +
> +	for (i = 0; i < dev->variant->num_enc_fmts; i++) {
> +		if (bitstream == (formats[i].codec_mode != RK_VPU_CODEC_NONE))
> +			return &formats[i];
> +	}
> +
> +	/* There must be at least one raw and one coded format in the array. */
> +	BUG_ON(i >= dev->variant->num_enc_fmts);
> +	return NULL;
> +}
> +
> +static const struct v4l2_ctrl_config controls[] = {
> +	[ROCKCHIP_VPU_ENC_CTRL_Y_QUANT_TBL] = {
> +		.id = V4L2_CID_JPEG_LUMA_QUANTIZATION,
> +		.type = V4L2_CTRL_TYPE_U8,
> +		.step = 1,
> +		.def = 0x00,
> +		.min = 0x00,
> +		.max = 0xff,
> +		.dims = { 8, 8 }
> +	},
> +	[ROCKCHIP_VPU_ENC_CTRL_C_QUANT_TBL] = {
> +		.id = V4L2_CID_JPEG_CHROMA_QUANTIZATION,
> +		.type = V4L2_CTRL_TYPE_U8,
> +		.step = 1,
> +		.def = 0x00,
> +		.min = 0x00,
> +		.max = 0xff,
> +		.dims = { 8, 8 }
> +	},
> +};
> +
> +static int vidioc_querycap(struct file *file, void *priv,
> +			   struct v4l2_capability *cap)
> +{
> +	struct rockchip_vpu_dev *vpu = video_drvdata(file);
> +
> +	strlcpy(cap->driver, vpu->dev->driver->name, sizeof(cap->driver));
> +	strlcpy(cap->card, vpu->vfd->name, sizeof(cap->card));
> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform: %s",
> +		 vpu->dev->driver->name);
> +
> +	/*
> +	 * This is only a mem-to-mem video device.
> +	 */
> +	cap->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +
> +	return 0;
> +}
> +
> +static int vidioc_enum_framesizes(struct file *file, void *prov,
> +				  struct v4l2_frmsizeenum *fsize)
> +{
> +	struct rockchip_vpu_dev *dev = video_drvdata(file);
> +	const struct rockchip_vpu_fmt *fmt;
> +
> +	if (fsize->index != 0) {
> +		vpu_debug(0, "invalid frame size index (expected 0, got %d)\n",
> +				fsize->index);
> +		return -EINVAL;
> +	}
> +
> +	fmt = rockchip_vpu_find_format(dev, fsize->pixel_format);
> +	if (!fmt) {
> +		vpu_debug(0, "unsupported bitstream format (%08x)\n",
> +				fsize->pixel_format);
> +		return -EINVAL;
> +	}
> +
> +	/* This only makes sense for codec formats */
> +	if (fmt->codec_mode == RK_VPU_CODEC_NONE)
> +		return -ENOTTY;
> +
> +	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
> +	fsize->stepwise = fmt->frmsize;
> +
> +	return 0;
> +}
> +
> +static int vidioc_enum_fmt_vid_cap_mplane(struct file *file, void *priv,
> +					  struct v4l2_fmtdesc *f)
> +{
> +	struct rockchip_vpu_dev *dev = video_drvdata(file);
> +	const struct rockchip_vpu_fmt *fmt;
> +	const struct rockchip_vpu_fmt *formats = dev->variant->enc_fmts;
> +	int i, j = 0;
> +
> +	for (i = 0; i < dev->variant->num_enc_fmts; i++) {
> +		/* Skip uncompressed formats */
> +		if (formats[i].codec_mode == RK_VPU_CODEC_NONE)
> +			continue;
> +		if (j == f->index) {
> +			fmt = &formats[i];
> +			strlcpy(f->description,
> +				fmt->name, sizeof(f->description));

Don't fill in the description. The v4l2 core will take care of that.

> +			f->pixelformat = fmt->fourcc;
> +			f->flags = 0;
> +			f->flags |= V4L2_FMT_FLAG_COMPRESSED;

Same for this.

> +			return 0;
> +		}
> +		++j;
> +	}
> +	return -EINVAL;
> +}
> +
> +static int vidioc_enum_fmt_vid_out_mplane(struct file *file, void *priv,
> +					  struct v4l2_fmtdesc *f)
> +{
> +	struct rockchip_vpu_dev *dev = video_drvdata(file);
> +	const struct rockchip_vpu_fmt *fmt;
> +	const struct rockchip_vpu_fmt *formats = dev->variant->enc_fmts;
> +	int i, j = 0;
> +
> +	for (i = 0; i < dev->variant->num_enc_fmts; i++) {
> +		if (formats[i].codec_mode != RK_VPU_CODEC_NONE)
> +			continue;
> +		if (j == f->index) {
> +			fmt = &formats[i];
> +			strlcpy(f->description,
> +				fmt->name, sizeof(f->description));

Ditto.

> +			f->pixelformat = fmt->fourcc;
> +			f->flags = 0;

Ditto.

> +			return 0;
> +		}
> +		++j;
> +	}
> +	return -EINVAL;
> +}
> +
> +static int vidioc_g_fmt_out(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
> +	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> +
> +	vpu_debug(4, "f->type = %d\n", f->type);
> +
> +	*pix_mp = ctx->src_fmt;
> +	pix_mp->colorspace = ctx->colorspace;
> +	pix_mp->ycbcr_enc = ctx->ycbcr_enc;
> +	pix_mp->xfer_func = ctx->xfer_func;
> +	pix_mp->quantization = ctx->quantization;
> +
> +	return 0;
> +}
> +
> +static int vidioc_g_fmt_cap(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
> +	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> +
> +	vpu_debug(4, "f->type = %d\n", f->type);
> +
> +	*pix_mp = ctx->dst_fmt;
> +	pix_mp->colorspace = ctx->colorspace;
> +	pix_mp->ycbcr_enc = ctx->ycbcr_enc;
> +	pix_mp->xfer_func = ctx->xfer_func;
> +	pix_mp->quantization = ctx->quantization;
> +
> +	return 0;
> +}
> +
> +static void calculate_plane_sizes(const struct rockchip_vpu_fmt *fmt,
> +				  struct v4l2_pix_format_mplane *pix_mp)
> +{
> +	unsigned int w = pix_mp->width;
> +	unsigned int h = pix_mp->height;
> +	int i;
> +
> +	for (i = 0; i < fmt->num_planes; ++i) {
> +		memset(pix_mp->plane_fmt[i].reserved, 0,
> +		       sizeof(pix_mp->plane_fmt[i].reserved));
> +		pix_mp->plane_fmt[i].bytesperline = w * fmt->depth[i] / 8;
> +		pix_mp->plane_fmt[i].sizeimage = h *
> +					pix_mp->plane_fmt[i].bytesperline;
> +		/*
> +		 * All of multiplanar formats we support have chroma
> +		 * planes subsampled by 2 vertically.
> +		 */
> +		if (i != 0)
> +			pix_mp->plane_fmt[i].sizeimage /= 2;
> +	}
> +}
> +
> +static int vidioc_try_fmt_cap(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct rockchip_vpu_dev *dev = video_drvdata(file);
> +	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> +	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
> +	const struct rockchip_vpu_fmt *fmt;
> +	char str[5];
> +
> +	vpu_debug(4, "%s\n", fmt2str(pix_mp->pixelformat, str));
> +
> +	fmt = rockchip_vpu_find_format(dev, pix_mp->pixelformat);
> +	if (!fmt) {
> +		fmt = rockchip_vpu_get_default_fmt(dev, true);
> +		f->fmt.pix.pixelformat = fmt->fourcc;
> +	}
> +
> +	/* Limit to hardware min/max. */
> +	pix_mp->width = clamp(pix_mp->width,
> +			ctx->vpu_dst_fmt->frmsize.min_width,
> +			ctx->vpu_dst_fmt->frmsize.max_width);
> +	pix_mp->height = clamp(pix_mp->height,
> +			ctx->vpu_dst_fmt->frmsize.min_height,
> +			ctx->vpu_dst_fmt->frmsize.max_height);
> +	pix_mp->num_planes = fmt->num_planes;
> +
> +	pix_mp->plane_fmt[0].sizeimage =
> +		pix_mp->width * pix_mp->height * JPEG_MAX_BYTES_PER_PIXEL;
> +	memset(pix_mp->plane_fmt[0].reserved, 0,
> +	       sizeof(pix_mp->plane_fmt[0].reserved));
> +	pix_mp->field = V4L2_FIELD_NONE;
> +
> +	return 0;
> +}
> +
> +static int vidioc_try_fmt_out(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct rockchip_vpu_dev *dev = video_drvdata(file);
> +	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> +	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
> +	const struct rockchip_vpu_fmt *fmt;
> +	char str[5];
> +	unsigned long dma_align;
> +	bool need_alignment;
> +	int i;
> +
> +	vpu_debug(4, "%s\n", fmt2str(pix_mp->pixelformat, str));
> +
> +	fmt = rockchip_vpu_find_format(dev, pix_mp->pixelformat);
> +	if (!fmt) {
> +		fmt = rockchip_vpu_get_default_fmt(dev, false);
> +		f->fmt.pix.pixelformat = fmt->fourcc;
> +	}
> +
> +	/* Limit to hardware min/max. */
> +	pix_mp->width = clamp(pix_mp->width,
> +			ctx->vpu_dst_fmt->frmsize.min_width,
> +			ctx->vpu_dst_fmt->frmsize.max_width);
> +	pix_mp->height = clamp(pix_mp->height,
> +			ctx->vpu_dst_fmt->frmsize.min_height,
> +			ctx->vpu_dst_fmt->frmsize.max_height);
> +	/* Round up to macroblocks. */
> +	pix_mp->width = round_up(pix_mp->width, MB_DIM);
> +	pix_mp->height = round_up(pix_mp->height, MB_DIM);
> +	pix_mp->num_planes = fmt->num_planes;
> +	pix_mp->field = V4L2_FIELD_NONE;
> +
> +	vpu_debug(0, "OUTPUT codec mode: %d\n", fmt->codec_mode);
> +	vpu_debug(0, "fmt - w: %d, h: %d, mb - w: %d, h: %d\n",
> +		  pix_mp->width, pix_mp->height,
> +		  MB_WIDTH(pix_mp->width),
> +		  MB_HEIGHT(pix_mp->height));
> +
> +	/* Fill remaining fields */
> +	calculate_plane_sizes(fmt, pix_mp);
> +
> +	dma_align = dma_get_cache_alignment();
> +	need_alignment = false;
> +	for (i = 0; i < fmt->num_planes; i++) {
> +		if (!IS_ALIGNED(pix_mp->plane_fmt[i].sizeimage,
> +				dma_align)) {
> +			need_alignment = true;
> +			break;
> +		}
> +	}
> +	if (!need_alignment)
> +		return 0;
> +
> +	pix_mp->height = round_up(pix_mp->height, dma_align * 4 / MB_DIM);
> +	if (pix_mp->height > ctx->vpu_dst_fmt->frmsize.max_height) {
> +		vpu_err("Aligned height higher than maximum.\n");
> +		return -EINVAL;
> +	}
> +	/* Fill in remaining fields, again */
> +	calculate_plane_sizes(fmt, pix_mp);
> +	return 0;
> +}
> +
> +static void rockchip_vpu_reset_dst_fmt(struct rockchip_vpu_dev *vpu,
> +					struct rockchip_vpu_ctx *ctx)
> +{
> +	struct v4l2_pix_format_mplane *fmt = &ctx->dst_fmt;
> +
> +	ctx->vpu_dst_fmt = rockchip_vpu_get_default_fmt(vpu, true);
> +
> +	memset(fmt, 0, sizeof(*fmt));
> +
> +	fmt->width = ctx->vpu_dst_fmt->frmsize.min_width;
> +	fmt->height = ctx->vpu_dst_fmt->frmsize.min_height;
> +	fmt->pixelformat = ctx->vpu_dst_fmt->fourcc;
> +	fmt->num_planes = ctx->vpu_dst_fmt->num_planes;
> +	fmt->plane_fmt[0].sizeimage =
> +		fmt->width * fmt->height * JPEG_MAX_BYTES_PER_PIXEL;
> +
> +	fmt->field = V4L2_FIELD_NONE;
> +
> +	fmt->colorspace = ctx->colorspace;
> +	fmt->ycbcr_enc = ctx->ycbcr_enc;
> +	fmt->xfer_func = ctx->xfer_func;
> +	fmt->quantization = ctx->quantization;
> +}
> +
> +static void rockchip_vpu_reset_src_fmt(struct rockchip_vpu_dev *vpu,
> +					struct rockchip_vpu_ctx *ctx)
> +{
> +	struct v4l2_pix_format_mplane *fmt = &ctx->src_fmt;
> +
> +	ctx->vpu_src_fmt = rockchip_vpu_get_default_fmt(vpu, false);
> +
> +	memset(fmt, 0, sizeof(*fmt));
> +
> +	fmt->width = ctx->vpu_dst_fmt->frmsize.min_width;
> +	fmt->height = ctx->vpu_dst_fmt->frmsize.min_height;
> +	fmt->pixelformat = ctx->vpu_src_fmt->fourcc;
> +	fmt->num_planes = ctx->vpu_src_fmt->num_planes;
> +
> +	fmt->field = V4L2_FIELD_NONE;
> +
> +	fmt->colorspace = ctx->colorspace;
> +	fmt->ycbcr_enc = ctx->ycbcr_enc;
> +	fmt->xfer_func = ctx->xfer_func;
> +	fmt->quantization = ctx->quantization;
> +
> +	calculate_plane_sizes(ctx->vpu_src_fmt, fmt);
> +}
> +
> +static int vidioc_s_fmt_out(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
> +	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> +	struct rockchip_vpu_dev *vpu = ctx->dev;
> +	struct vb2_queue *vq, *peer_vq;
> +	int ret;
> +
> +	/* Change not allowed if queue is streaming. */
> +	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> +	if (vb2_is_streaming(vq))
> +		return -EBUSY;
> +
> +	ctx->colorspace = pix_mp->colorspace;
> +	ctx->ycbcr_enc = pix_mp->ycbcr_enc;
> +	ctx->xfer_func = pix_mp->xfer_func;
> +	ctx->quantization = pix_mp->quantization;
> +
> +	/*
> +	 * Pixel format change is not allowed when the other queue has
> +	 * buffers allocated.
> +	 */
> +	peer_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
> +		V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
> +	if (vb2_is_busy(peer_vq) &&
> +	    pix_mp->pixelformat != ctx->src_fmt.pixelformat)
> +		return -EBUSY;
> +
> +	ret = vidioc_try_fmt_out(file, priv, f);
> +	if (ret)
> +		return ret;
> +
> +	ctx->vpu_src_fmt = rockchip_vpu_find_format(vpu,
> +		pix_mp->pixelformat);
> +
> +	/* Reset crop rectangle. */
> +	ctx->src_crop.width = pix_mp->width;
> +	ctx->src_crop.height = pix_mp->height;
> +	ctx->src_fmt = *pix_mp;
> +
> +	return 0;
> +}
> +
> +static int vidioc_s_fmt_cap(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
> +	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> +	struct rockchip_vpu_dev *vpu = ctx->dev;
> +	struct vb2_queue *vq, *peer_vq;
> +	int ret;
> +
> +	/* Change not allowed if queue is streaming. */
> +	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> +	if (vb2_is_streaming(vq))
> +		return -EBUSY;
> +
> +	ctx->colorspace = pix_mp->colorspace;
> +	ctx->ycbcr_enc = pix_mp->ycbcr_enc;
> +	ctx->xfer_func = pix_mp->xfer_func;
> +	ctx->quantization = pix_mp->quantization;
> +
> +	/*
> +	 * Pixel format change is not allowed when the other queue has
> +	 * buffers allocated.
> +	 */
> +	peer_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
> +			V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
> +	if (vb2_is_busy(peer_vq) &&
> +	    pix_mp->pixelformat != ctx->dst_fmt.pixelformat)
> +		return -EBUSY;
> +
> +	ret = vidioc_try_fmt_cap(file, priv, f);
> +	if (ret)
> +		return ret;
> +
> +	ctx->vpu_dst_fmt = rockchip_vpu_find_format(vpu, pix_mp->pixelformat);
> +	ctx->dst_fmt = *pix_mp;
> +
> +	/*
> +	 * Current raw format might have become invalid with newly
> +	 * selected codec, so reset it to default just to be safe and
> +	 * keep internal driver state sane. User is mandated to set
> +	 * the raw format again after we return, so we don't need
> +	 * anything smarter.
> +	 */
> +	rockchip_vpu_reset_src_fmt(vpu, ctx);
> +
> +	return 0;
> +}
> +
> +static int vidioc_cropcap(struct file *file, void *priv,
> +			  struct v4l2_cropcap *cap)
> +{
> +	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> +	struct v4l2_pix_format_mplane *fmt = &ctx->src_fmt;
> +
> +	/* Crop only supported on source. */
> +	if (cap->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		return -EINVAL;
> +
> +	cap->bounds.left = 0;
> +	cap->bounds.top = 0;
> +	cap->bounds.width = fmt->width;
> +	cap->bounds.height = fmt->height;
> +	cap->defrect = cap->bounds;
> +	cap->pixelaspect.numerator = 1;
> +	cap->pixelaspect.denominator = 1;
> +
> +	return 0;
> +}
> +
> +static int vidioc_g_crop(struct file *file, void *priv, struct v4l2_crop *crop)
> +{
> +	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> +	int ret = 0;
> +
> +	/* Crop only supported on source. */
> +	if (crop->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		return -EINVAL;
> +
> +	crop->c = ctx->src_crop;
> +
> +	return ret;
> +}
> +
> +static int vidioc_s_crop(struct file *file, void *priv,
> +			 const struct v4l2_crop *crop)
> +{
> +	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> +	struct v4l2_pix_format_mplane *fmt = &ctx->src_fmt;
> +	const struct v4l2_rect *rect = &crop->c;
> +	struct vb2_queue *vq;
> +
> +	/* Crop only supported on source. */
> +	if (crop->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		return -EINVAL;
> +
> +	/* Change not allowed if the queue is streaming. */
> +	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, crop->type);
> +	if (vb2_is_streaming(vq))
> +		return -EBUSY;
> +
> +	/* We do not support offsets. */
> +	if (rect->left != 0 || rect->top != 0)
> +		goto fallback;
> +
> +	/* We can crop only inside right- or bottom-most macroblocks. */
> +	if (round_up(rect->width, MB_DIM) != fmt->width
> +	    || round_up(rect->height, MB_DIM) != fmt->height)
> +		goto fallback;
> +
> +	/* We support widths aligned to 4 pixels and arbitrary heights. */
> +	ctx->src_crop.width = round_up(rect->width, 4);
> +	ctx->src_crop.height = rect->height;
> +
> +	return 0;
> +
> +fallback:
> +	/* Default to full frame for incorrect settings. */
> +	ctx->src_crop.width = fmt->width;
> +	ctx->src_crop.height = fmt->height;
> +	return 0;
> +}

Replace crop by the selection API. The old crop API is no longer allowed
in new drivers.

> +
> +const struct v4l2_ioctl_ops rockchip_vpu_enc_ioctl_ops = {
> +	.vidioc_querycap = vidioc_querycap,
> +	.vidioc_enum_framesizes = vidioc_enum_framesizes,
> +
> +	.vidioc_try_fmt_vid_cap_mplane = vidioc_try_fmt_cap,
> +	.vidioc_try_fmt_vid_out_mplane = vidioc_try_fmt_out,
> +	.vidioc_s_fmt_vid_out_mplane = vidioc_s_fmt_out,
> +	.vidioc_s_fmt_vid_cap_mplane = vidioc_s_fmt_cap,
> +	.vidioc_g_fmt_vid_out_mplane = vidioc_g_fmt_out,
> +	.vidioc_g_fmt_vid_cap_mplane = vidioc_g_fmt_cap,
> +	.vidioc_enum_fmt_vid_out_mplane = vidioc_enum_fmt_vid_out_mplane,
> +	.vidioc_enum_fmt_vid_cap_mplane = vidioc_enum_fmt_vid_cap_mplane,
> +
> +	.vidioc_reqbufs = v4l2_m2m_ioctl_reqbufs,
> +	.vidioc_querybuf = v4l2_m2m_ioctl_querybuf,
> +	.vidioc_qbuf = v4l2_m2m_ioctl_qbuf,
> +	.vidioc_dqbuf = v4l2_m2m_ioctl_dqbuf,
> +	.vidioc_prepare_buf = v4l2_m2m_ioctl_prepare_buf,
> +	.vidioc_create_bufs = v4l2_m2m_ioctl_create_bufs,
> +	.vidioc_expbuf = v4l2_m2m_ioctl_expbuf,
> +
> +	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
> +	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
> +
> +	.vidioc_streamon = v4l2_m2m_ioctl_streamon,
> +	.vidioc_streamoff = v4l2_m2m_ioctl_streamoff,
> +
> +	.vidioc_cropcap = vidioc_cropcap,
> +	.vidioc_g_crop = vidioc_g_crop,
> +	.vidioc_s_crop = vidioc_s_crop,
> +};
> +
> +static int rockchip_vpu_queue_setup(struct vb2_queue *vq,
> +				  unsigned int *num_buffers,
> +				  unsigned int *num_planes,
> +				  unsigned int sizes[],
> +				  struct device *alloc_devs[])
> +{
> +	struct rockchip_vpu_ctx *ctx = vb2_get_drv_priv(vq);
> +	int ret = 0;
> +	int i;
> +
> +	*num_buffers = clamp_t(unsigned int,
> +			*num_buffers, 1, VIDEO_MAX_FRAME);
> +
> +	switch (vq->type) {
> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +		*num_planes = ctx->vpu_dst_fmt->num_planes;
> +
> +		sizes[0] = ctx->dst_fmt.plane_fmt[0].sizeimage;
> +		vpu_debug(0, "capture sizes[%d]: %d\n", 0, sizes[0]);
> +		break;
> +
> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +		*num_planes = ctx->vpu_src_fmt->num_planes;
> +
> +		for (i = 0; i < ctx->vpu_src_fmt->num_planes; ++i) {
> +			sizes[i] = ctx->src_fmt.plane_fmt[i].sizeimage;
> +			vpu_debug(0, "output sizes[%d]: %d\n", i, sizes[i]);
> +		}
> +		break;
> +
> +	default:
> +		vpu_err("invalid queue type: %d\n", vq->type);
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +static int rockchip_vpu_buf_prepare(struct vb2_buffer *vb)
> +{
> +	struct vb2_queue *vq = vb->vb2_queue;
> +	struct rockchip_vpu_ctx *ctx = vb2_get_drv_priv(vq);
> +	unsigned int sz;
> +	int ret = 0;
> +	int i;
> +
> +	switch (vq->type) {
> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +		sz = ctx->dst_fmt.plane_fmt[0].sizeimage;
> +
> +		vpu_debug(4, "plane size: %ld, dst size: %d\n",
> +			vb2_plane_size(vb, 0), sz);
> +		if (vb2_plane_size(vb, 0) < sz) {
> +			vpu_err("plane size is too small for capture\n");
> +			ret = -EINVAL;
> +		}
> +		break;
> +
> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +		for (i = 0; i < ctx->vpu_src_fmt->num_planes; ++i) {
> +			sz = ctx->src_fmt.plane_fmt[i].sizeimage;
> +
> +			vpu_debug(4, "plane %d size: %ld, sizeimage: %u\n", i,
> +				vb2_plane_size(vb, i), sz);
> +			if (vb2_plane_size(vb, i) < sz) {
> +				vpu_err("size of plane %d is too small for output\n",
> +					i);
> +				break;
> +			}
> +		}
> +
> +		if (i != ctx->vpu_src_fmt->num_planes)
> +			ret = -EINVAL;
> +		break;
> +
> +	default:
> +		vpu_err("invalid queue type: %d\n", vq->type);
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +static void rockchip_vpu_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct rockchip_vpu_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +
> +	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
> +}
> +
> +static int rockchip_vpu_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	struct rockchip_vpu_ctx *ctx = vb2_get_drv_priv(q);
> +	enum rockchip_vpu_codec_mode codec_mode;
> +
> +	/* Set codec_ops for the chosen destination format */
> +	codec_mode = ctx->vpu_dst_fmt->codec_mode;
> +	ctx->codec_ops = &ctx->dev->variant->codec_ops[codec_mode];
> +
> +	return 0;
> +}
> +
> +static void rockchip_vpu_stop_streaming(struct vb2_queue *q)
> +{
> +	struct rockchip_vpu_ctx *ctx = vb2_get_drv_priv(q);
> +
> +	/* The mem2mem framework calls v4l2_m2m_cancel_job before
> +	 * .stop_streaming, so there isn't any job running and
> +	 * it is safe to return all the buffers.
> +	 */
> +	for (;;) {
> +		struct vb2_v4l2_buffer *vbuf;
> +
> +		if (V4L2_TYPE_IS_OUTPUT(q->type))
> +			vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> +		else
> +			vbuf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
> +		if (!vbuf)
> +			break;
> +		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
> +	}
> +}
> +
> +const struct vb2_ops rockchip_vpu_enc_queue_ops = {
> +	.queue_setup = rockchip_vpu_queue_setup,
> +	.buf_prepare = rockchip_vpu_buf_prepare,
> +	.buf_queue = rockchip_vpu_buf_queue,
> +	.start_streaming = rockchip_vpu_start_streaming,
> +	.stop_streaming = rockchip_vpu_stop_streaming,
> +};
> +
> +int rockchip_vpu_enc_ctrls_setup(struct rockchip_vpu_ctx *ctx)
> +{
> +	int i, num_ctrls = ARRAY_SIZE(controls);
> +
> +	if (num_ctrls > ARRAY_SIZE(ctx->ctrls)) {
> +		vpu_err("context control array not large enough\n");
> +		return -EINVAL;
> +	}
> +
> +	v4l2_ctrl_handler_init(&ctx->ctrl_handler, num_ctrls);
> +	if (ctx->ctrl_handler.error) {
> +		vpu_err("v4l2_ctrl_handler_init failed\n");
> +		return ctx->ctrl_handler.error;
> +	}
> +
> +	for (i = 0; i < num_ctrls; i++) {
> +		ctx->ctrls[i] = v4l2_ctrl_new_custom(&ctx->ctrl_handler,
> +						     &controls[i], NULL);
> +		if (ctx->ctrl_handler.error) {
> +			vpu_err("Adding control (%d) failed %d\n", i,
> +				ctx->ctrl_handler.error);
> +			v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> +			return ctx->ctrl_handler.error;
> +		}
> +	}
> +
> +	v4l2_ctrl_handler_setup(&ctx->ctrl_handler);
> +	ctx->num_ctrls = num_ctrls;
> +	return 0;
> +}
> +
> +int rockchip_vpu_enc_init(struct rockchip_vpu_ctx *ctx)
> +{
> +	struct rockchip_vpu_dev *vpu = ctx->dev;
> +	int ret;
> +
> +	rockchip_vpu_reset_dst_fmt(vpu, ctx);
> +	rockchip_vpu_reset_src_fmt(vpu, ctx);
> +
> +	ret = rockchip_vpu_enc_ctrls_setup(ctx);
> +	if (ret) {
> +		vpu_err("Failed to set up controls.\n");
> +		return ret;
> +	}
> +	return 0;
> +}
> +
> +void rockchip_vpu_enc_exit(struct rockchip_vpu_ctx *ctx)
> +{
> +	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> +}
> diff --git a/drivers/media/platform/rockchip/vpu/rockchip_vpu_enc.h b/drivers/media/platform/rockchip/vpu/rockchip_vpu_enc.h
> new file mode 100644
> index 000000000000..4742cbd9295c
> --- /dev/null
> +++ b/drivers/media/platform/rockchip/vpu/rockchip_vpu_enc.h
> @@ -0,0 +1,25 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Rockchip VPU codec driver
> + *
> + * Copyright (C) 2018 Rockchip Electronics Co., Ltd.
> + *	Alpha Lin <Alpha.Lin@rock-chips.com>
> + *	Jeffy Chen <jeffy.chen@rock-chips.com>
> + *
> + * Copyright (C) 2018 Google, Inc.
> + *	Tomasz Figa <tfiga@chromium.org>
> + *
> + * Based on s5p-mfc driver by Samsung Electronics Co., Ltd.
> + * Copyright (C) 2011 Samsung Electronics Co., Ltd.
> + */
> +
> +#ifndef ROCKCHIP_VPU_ENC_H_
> +#define ROCKCHIP_VPU_ENC_H_
> +
> +extern const struct v4l2_ioctl_ops rockchip_vpu_enc_ioctl_ops;
> +extern const struct vb2_ops rockchip_vpu_enc_queue_ops;
> +
> +int rockchip_vpu_enc_init(struct rockchip_vpu_ctx *ctx);
> +void rockchip_vpu_enc_exit(struct rockchip_vpu_ctx *ctx);
> +
> +#endif /* ROCKCHIP_VPU_ENC_H_  */
> diff --git a/drivers/media/platform/rockchip/vpu/rockchip_vpu_hw.h b/drivers/media/platform/rockchip/vpu/rockchip_vpu_hw.h
> new file mode 100644
> index 000000000000..3298e21aa68c
> --- /dev/null
> +++ b/drivers/media/platform/rockchip/vpu/rockchip_vpu_hw.h
> @@ -0,0 +1,67 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Rockchip VPU codec driver
> + *
> + * Copyright (C) 2018 Google, Inc.
> + *	Tomasz Figa <tfiga@chromium.org>
> + */
> +
> +#ifndef ROCKCHIP_VPU_HW_H_
> +#define ROCKCHIP_VPU_HW_H_
> +
> +#include <linux/interrupt.h>
> +#include <linux/v4l2-controls.h>
> +#include <media/videobuf2-core.h>
> +
> +#define ROCKCHIP_HEADER_SIZE		1280
> +#define ROCKCHIP_HW_PARAMS_SIZE		5487
> +#define ROCKCHIP_RET_PARAMS_SIZE	488
> +#define ROCKCHIP_JPEG_QUANT_ELE_SIZE	64
> +
> +#define ROCKCHIP_VPU_CABAC_TABLE_SIZE	(52 * 2 * 464)
> +
> +struct rockchip_vpu_dev;
> +struct rockchip_vpu_ctx;
> +struct rockchip_vpu_buf;
> +struct rockchip_vpu_variant;
> +
> +/**
> + * struct rockchip_vpu_codec_ops - codec mode specific operations
> + *
> + * @run:	Start single {en,de)coding job. Called from atomic context
> + *		to indicate that a pair of buffers is ready and the hardware
> + *		should be programmed and started.
> + * @done:	Read back processing results and additional data from hardware.
> + * @reset:	Reset the hardware in case of a timeout.
> + */
> +struct rockchip_vpu_codec_ops {
> +	void (*run)(struct rockchip_vpu_ctx *ctx);
> +	void (*done)(struct rockchip_vpu_ctx *ctx, enum vb2_buffer_state);
> +	void (*reset)(struct rockchip_vpu_ctx *ctx);
> +};
> +
> +/**
> + * enum rockchip_vpu_enc_fmt - source format ID for hardware registers.
> + */
> +enum rockchip_vpu_enc_fmt {
> +	RK3288_VPU_ENC_FMT_YUV420P = 0,
> +	RK3288_VPU_ENC_FMT_YUV420SP = 1,
> +	RK3288_VPU_ENC_FMT_YUYV422 = 2,
> +	RK3288_VPU_ENC_FMT_UYVY422 = 3,
> +};
> +
> +extern const struct rockchip_vpu_variant rk3399_vpu_variant;
> +extern const struct rockchip_vpu_variant rk3288_vpu_variant;
> +
> +void rockchip_vpu_watchdog(struct work_struct *work);
> +void rockchip_vpu_run(struct rockchip_vpu_ctx *ctx);
> +void rockchip_vpu_irq_done(struct rockchip_vpu_dev *vpu);
> +
> +void rk3288_vpu_jpege_run(struct rockchip_vpu_ctx *ctx);
> +void rk3288_vpu_jpege_done(struct rockchip_vpu_ctx *ctx,
> +			   enum vb2_buffer_state result);
> +void rk3399_vpu_jpege_run(struct rockchip_vpu_ctx *ctx);
> +void rk3399_vpu_jpege_done(struct rockchip_vpu_ctx *ctx,
> +			   enum vb2_buffer_state result);
> +
> +#endif /* ROCKCHIP_VPU_HW_H_ */
> 

I skipped the review of the colorspace handling. I'll see if I can come back
to that later today. I'm not sure if it is correct, but to be honest I doubt
that there is any JPEG encoder that does this right anyway.

BTW, please show the 'v4l2-compliance -s' output in the cover letter for the
next version.

Regards,

	Hans
