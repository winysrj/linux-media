Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45300 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbeKUGve (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Nov 2018 01:51:34 -0500
Message-ID: <e328cf634373468cf13f38cc0f857503dfbcd979.camel@collabora.com>
Subject: Re: [PATCH v8 3/3] media: add Rockchip VPU JPEG encoder driver
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-rockchip@lists.infradead.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Miouyouyou <myy@miouyouyou.fr>
Date: Tue, 20 Nov 2018 17:20:26 -0300
In-Reply-To: <76eaab16-6334-ffcb-43b3-394cc5b3ad27@xs4all.nl>
References: <20181119152902.31429-1-ezequiel@collabora.com>
         <20181119152902.31429-4-ezequiel@collabora.com>
         <76eaab16-6334-ffcb-43b3-394cc5b3ad27@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2018-11-20 at 14:52 +0100, Hans Verkuil wrote:
> On 11/19/2018 04:29 PM, Ezequiel Garcia wrote:
> > Add a mem2mem driver for the VPU available on Rockchip SoCs.
> > Currently only JPEG encoding is supported, for RK3399 and RK3288
> > platforms.
> > 
> > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> > ---
> >  MAINTAINERS                                   |   7 +
> >  drivers/staging/media/Kconfig                 |   2 +
> >  drivers/staging/media/Makefile                |   1 +
> >  drivers/staging/media/rockchip/vpu/Kconfig    |  14 +
> >  drivers/staging/media/rockchip/vpu/Makefile   |  10 +
> >  drivers/staging/media/rockchip/vpu/TODO       |   9 +
> >  .../media/rockchip/vpu/rk3288_vpu_hw.c        | 118 +++
> >  .../rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c     | 133 ++++
> >  .../media/rockchip/vpu/rk3288_vpu_regs.h      | 442 +++++++++++
> >  .../media/rockchip/vpu/rk3399_vpu_hw.c        | 118 +++
> >  .../rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c     | 160 ++++
> >  .../media/rockchip/vpu/rk3399_vpu_regs.h      | 600 +++++++++++++++
> >  .../staging/media/rockchip/vpu/rockchip_vpu.h | 237 ++++++
> >  .../media/rockchip/vpu/rockchip_vpu_common.h  |  29 +
> >  .../media/rockchip/vpu/rockchip_vpu_drv.c     | 535 +++++++++++++
> >  .../media/rockchip/vpu/rockchip_vpu_enc.c     | 701 ++++++++++++++++++
> >  .../media/rockchip/vpu/rockchip_vpu_hw.h      |  58 ++
> >  .../media/rockchip/vpu/rockchip_vpu_jpeg.c    | 289 ++++++++
> >  .../media/rockchip/vpu/rockchip_vpu_jpeg.h    |  12 +
> >  19 files changed, 3475 insertions(+)
> >  create mode 100644 drivers/staging/media/rockchip/vpu/Kconfig
> >  create mode 100644 drivers/staging/media/rockchip/vpu/Makefile
> >  create mode 100644 drivers/staging/media/rockchip/vpu/TODO
> >  create mode 100644 drivers/staging/media/rockchip/vpu/rk3288_vpu_hw.c
> >  create mode 100644 drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c
> >  create mode 100644 drivers/staging/media/rockchip/vpu/rk3288_vpu_regs.h
> >  create mode 100644 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw.c
> >  create mode 100644 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c
> >  create mode 100644 drivers/staging/media/rockchip/vpu/rk3399_vpu_regs.h
> >  create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu.h
> >  create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_common.h
> >  create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
> >  create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
> >  create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_hw.h
> >  create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.c
> >  create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.h
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index a8588dedc683..e5a294453393 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -12742,6 +12742,13 @@ S:	Maintained
> >  F:	drivers/media/platform/rockchip/rga/
> >  F:	Documentation/devicetree/bindings/media/rockchip-rga.txt
> >  
> > +ROCKCHIP VPU CODEC DRIVER
> > +M:	Ezequiel Garcia <ezequiel@collabora.com>
> > +L:	linux-media@vger.kernel.org
> > +S:	Maintained
> > +F:	drivers/staging/media/platform/rockchip/vpu/
> > +F:	Documentation/devicetree/bindings/media/rockchip-vpu.txt
> > +
> >  ROCKER DRIVER
> >  M:	Jiri Pirko <jiri@resnulli.us>
> >  L:	netdev@vger.kernel.org
> > diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
> > index b3620a8f2d9f..c6f3404dea43 100644
> > --- a/drivers/staging/media/Kconfig
> > +++ b/drivers/staging/media/Kconfig
> > @@ -31,6 +31,8 @@ source "drivers/staging/media/mt9t031/Kconfig"
> >  
> >  source "drivers/staging/media/omap4iss/Kconfig"
> >  
> > +source "drivers/staging/media/rockchip/vpu/Kconfig"
> > +
> >  source "drivers/staging/media/sunxi/Kconfig"
> >  
> >  source "drivers/staging/media/tegra-vde/Kconfig"
> > diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
> > index 42948f805548..43c7bee1fc8c 100644
> > --- a/drivers/staging/media/Makefile
> > +++ b/drivers/staging/media/Makefile
> > @@ -8,3 +8,4 @@ obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
> >  obj-$(CONFIG_VIDEO_SUNXI)	+= sunxi/
> >  obj-$(CONFIG_TEGRA_VDE)		+= tegra-vde/
> >  obj-$(CONFIG_VIDEO_ZORAN)	+= zoran/
> > +obj-$(CONFIG_VIDEO_ROCKCHIP_VPU) += rockchip/vpu/
> > diff --git a/drivers/staging/media/rockchip/vpu/Kconfig b/drivers/staging/media/rockchip/vpu/Kconfig
> > new file mode 100644
> > index 000000000000..fa65c03d65bf
> > --- /dev/null
> > +++ b/drivers/staging/media/rockchip/vpu/Kconfig
> > @@ -0,0 +1,14 @@
> > +config VIDEO_ROCKCHIP_VPU
> > +	tristate "Rockchip VPU driver"
> > +	depends on ARCH_ROCKCHIP || COMPILE_TEST
> > +	depends on VIDEO_DEV && VIDEO_V4L2 && MEDIA_CONTROLLER
> > +	select VIDEOBUF2_DMA_CONTIG
> > +	select VIDEOBUF2_VMALLOC
> > +	select V4L2_MEM2MEM_DEV
> > +	default n
> > +	help
> > +	  Support for the Video Processing Unit present on Rockchip SoC,
> > +	  which accelerates video and image encoding and decoding.
> > +	  To compile this driver as a module, choose M here: the module
> > +	  will be called rockchip-vpu.
> > +
> > diff --git a/drivers/staging/media/rockchip/vpu/Makefile b/drivers/staging/media/rockchip/vpu/Makefile
> > new file mode 100644
> > index 000000000000..e9d733bb7632
> > --- /dev/null
> > +++ b/drivers/staging/media/rockchip/vpu/Makefile
> > @@ -0,0 +1,10 @@
> > +obj-$(CONFIG_VIDEO_ROCKCHIP_VPU) += rockchip-vpu.o
> > +
> > +rockchip-vpu-y += \
> > +		rockchip_vpu_drv.o \
> > +		rockchip_vpu_enc.o \
> > +		rk3288_vpu_hw.o \
> > +		rk3288_vpu_hw_jpeg_enc.o \
> > +		rk3399_vpu_hw.o \
> > +		rk3399_vpu_hw_jpeg_enc.o \
> > +		rockchip_vpu_jpeg.o
> > diff --git a/drivers/staging/media/rockchip/vpu/TODO b/drivers/staging/media/rockchip/vpu/TODO
> > new file mode 100644
> > index 000000000000..2b11ab5545e2
> > --- /dev/null
> > +++ b/drivers/staging/media/rockchip/vpu/TODO
> > @@ -0,0 +1,9 @@
> > +This driver is in staging until the V4L controls stabilize.
> > +
> > +Given the V4L controls are part of the uABI, it's better
> > +to have the driver in staging, so users are aware of this
> > +driver having an unstable interface.
> > +
> > +Having proper userspace support for drivers like this that
> > +use JPEG_RAW and similar formats is also a requirement
> > +for moving out of staging.
> 
> This TODO is now out of date: there are no new controls and no new JPEG_RAW
> format.
> 

Oh, forgot about this TODO file.

> There is in principle no reason for this driver to be in staging anymore. But
> it is my understanding that it is the intention to add the Rockchip stateless
> codecs to this driver as well, and those need to be in staging (at least for
> now). So I gather that's the real reason why this is in staging, and that
> should be documented in the TODO file.
> 

Indeed, I'd like to keep this in staging for that reason.

> > diff --git a/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw.c b/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw.c
> > new file mode 100644
> > index 000000000000..75b7abbd3aca
> > --- /dev/null
> > +++ b/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw.c
> > @@ -0,0 +1,118 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Rockchip VPU codec driver
> > + *
> > + * Copyright (C) 2018 Rockchip Electronics Co., Ltd.
> > + *	Jeffy Chen <jeffy.chen@rock-chips.com>
> > + */
> > +
> > +#include <linux/clk.h>
> > +
> > +#include "rockchip_vpu.h"
> > +#include "rockchip_vpu_jpeg.h"
> > +#include "rk3288_vpu_regs.h"
> > +
> > +#define RK3288_ACLK_MAX_FREQ (400 * 1000 * 1000)
> > +
> > +/*
> > + * Supported formats.
> > + */
> > +
> > +static const struct rockchip_vpu_fmt rk3288_vpu_enc_fmts[] = {
> > +	{
> > +		.fourcc = V4L2_PIX_FMT_YUV420M,
> > +		.codec_mode = RK_VPU_MODE_NONE,
> > +		.enc_fmt = RK3288_VPU_ENC_FMT_YUV420P,
> > +	},
> > +	{
> > +		.fourcc = V4L2_PIX_FMT_NV12M,
> > +		.codec_mode = RK_VPU_MODE_NONE,
> > +		.enc_fmt = RK3288_VPU_ENC_FMT_YUV420SP,
> > +	},
> > +	{
> > +		.fourcc = V4L2_PIX_FMT_YUYV,
> > +		.codec_mode = RK_VPU_MODE_NONE,
> > +		.enc_fmt = RK3288_VPU_ENC_FMT_YUYV422,
> > +	},
> > +	{
> > +		.fourcc = V4L2_PIX_FMT_UYVY,
> > +		.codec_mode = RK_VPU_MODE_NONE,
> > +		.enc_fmt = RK3288_VPU_ENC_FMT_UYVY422,
> > +	},
> > +	{
> > +		.fourcc = V4L2_PIX_FMT_JPEG,
> > +		.codec_mode = RK_VPU_MODE_JPEG_ENC,
> > +		.max_depth = 2,
> > +		.header_size = JPEG_HEADER_SIZE,
> > +		.frmsize = {
> > +			.min_width = 96,
> > +			.max_width = 8192,
> > +			.step_width = MB_DIM,
> > +			.min_height = 32,
> > +			.max_height = 8192,
> > +			.step_height = MB_DIM,
> 
> The hardware has no support for padding the image up to the next MB_DIM
> alignment? Just curious. If that's the case, then I suggest adding a
> comment here. If not, then perhaps adding support for this should be
> added to do TODO file?
> 

I don't know :-) Tomasz, can you shed a light here?

> > +		},
> > +	},
> > +};
> > +
> > +static irqreturn_t rk3288_vepu_irq(int irq, void *dev_id)
> > +{
> > +	struct rockchip_vpu_dev *vpu = dev_id;
> > +	enum vb2_buffer_state state;
> > +	u32 status, bytesused;
> > +
> > +	status = vepu_read(vpu, VEPU_REG_INTERRUPT);
> > +	bytesused = vepu_read(vpu, VEPU_REG_STR_BUF_LIMIT) / 8;
> > +	state = (status & VEPU_REG_INTERRUPT_FRAME_RDY) ?
> > +		VB2_BUF_STATE_DONE : VB2_BUF_STATE_ERROR;
> > +
> > +	vepu_write(vpu, 0, VEPU_REG_INTERRUPT);
> > +	vepu_write(vpu, 0, VEPU_REG_AXI_CTRL);
> > +
> > +	rockchip_vpu_irq_done(vpu, bytesused, state);
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +static int rk3288_vpu_hw_init(struct rockchip_vpu_dev *vpu)
> > +{
> > +	/* Bump ACLK to max. possible freq. to improve performance. */
> > +	clk_set_rate(vpu->clocks[0].clk, RK3288_ACLK_MAX_FREQ);
> > +	return 0;
> > +}
> > +
> > +static void rk3288_vpu_enc_reset(struct rockchip_vpu_ctx *ctx)
> > +{
> > +	struct rockchip_vpu_dev *vpu = ctx->dev;
> > +
> > +	vepu_write(vpu, VEPU_REG_INTERRUPT_DIS_BIT, VEPU_REG_INTERRUPT);
> > +	vepu_write(vpu, 0, VEPU_REG_ENC_CTRL);
> > +	vepu_write(vpu, 0, VEPU_REG_AXI_CTRL);
> > +}
> > +
> > +/*
> > + * Supported codec ops.
> > + */
> > +
> > +static const struct rockchip_vpu_codec_ops rk3288_vpu_codec_ops[] = {
> > +	[RK_VPU_MODE_JPEG_ENC] = {
> > +		.run = rk3288_vpu_jpeg_enc_run,
> > +		.reset = rk3288_vpu_enc_reset,
> > +	},
> > +};
> > +
> > +/*
> > + * VPU variant.
> > + */
> > +
> > +const struct rockchip_vpu_variant rk3288_vpu_variant = {
> > +	.enc_offset = 0x0,
> > +	.enc_fmts = rk3288_vpu_enc_fmts,
> > +	.num_enc_fmts = ARRAY_SIZE(rk3288_vpu_enc_fmts),
> > +	.codec_ops = rk3288_vpu_codec_ops,
> > +	.codec = RK_VPU_CODEC_JPEG,
> > +	.vepu_irq = rk3288_vepu_irq,
> > +	.init = rk3288_vpu_hw_init,
> > +	.clk_names = {"aclk", "hclk"},
> > +	.num_clocks = 2
> > +};
> 
> <snip>
> 
> > diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c b/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
> > new file mode 100644
> > index 000000000000..a355ccb678e8
> > --- /dev/null
> > +++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
> > @@ -0,0 +1,535 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Rockchip VPU codec driver
> > + *
> > + * Copyright (C) 2018 Collabora, Ltd.
> > + * Copyright (C) 2014 Google, Inc.
> > + *	Tomasz Figa <tfiga@chromium.org>
> > + *
> > + * Based on s5p-mfc driver by Samsung Electronics Co., Ltd.
> > + * Copyright (C) 2011 Samsung Electronics Co., Ltd.
> > + */
> > +
> > +#include <linux/clk.h>
> > +#include <linux/module.h>
> > +#include <linux/of.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/pm.h>
> > +#include <linux/pm_runtime.h>
> > +#include <linux/slab.h>
> > +#include <linux/videodev2.h>
> > +#include <linux/workqueue.h>
> > +#include <media/v4l2-event.h>
> > +#include <media/v4l2-mem2mem.h>
> > +#include <media/videobuf2-core.h>
> > +#include <media/videobuf2-core.h>
> > +#include <media/videobuf2-vmalloc.h>
> > +
> > +#include "rockchip_vpu_common.h"
> > +#include "rockchip_vpu.h"
> > +#include "rockchip_vpu_hw.h"
> > +
> > +#define DRIVER_NAME "rockchip-vpu"
> > +
> > +int rockchip_vpu_debug;
> > +module_param_named(debug, rockchip_vpu_debug, int, 0644);
> > +MODULE_PARM_DESC(debug,
> > +		 "Debug level - higher value produces more verbose messages");
> > +
> > +static void rockchip_vpu_job_finish(struct rockchip_vpu_dev *vpu,
> > +				    struct rockchip_vpu_ctx *ctx,
> > +				    unsigned int bytesused,
> > +				    enum vb2_buffer_state result)
> > +{
> > +	struct vb2_v4l2_buffer *src, *dst;
> > +
> > +	pm_runtime_mark_last_busy(vpu->dev);
> > +	pm_runtime_put_autosuspend(vpu->dev);
> > +
> > +	src = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> > +	dst = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
> > +
> > +	if (WARN_ON(!src))
> > +		return;
> > +	if (WARN_ON(!dst))
> > +		return;
> > +
> > +	src->sequence = ctx->sequence_out++;
> > +	dst->sequence = ctx->sequence_cap++;
> > +
> > +	dst->field = src->field;
> > +	dst->timecode = src->timecode;
> > +	dst->vb2_buf.timestamp = src->vb2_buf.timestamp;
> > +	dst->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> > +	dst->flags |= src->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> > +
> > +	if (bytesused) {
> > +		if (ctx->bounce_buf) {
> > +			memcpy(vb2_plane_vaddr(&dst->vb2_buf, 0) +
> > +			       ctx->vpu_dst_fmt->header_size,
> > +			       ctx->bounce_buf, bytesused);
> > +		}
> > +		dst->vb2_buf.planes[0].bytesused =
> > +			ctx->vpu_dst_fmt->header_size + bytesused;
> > +	}
> > +
> > +	v4l2_m2m_buf_done(src, result);
> > +	v4l2_m2m_buf_done(dst, result);
> > +
> > +	v4l2_m2m_job_finish(vpu->m2m_dev, ctx->fh.m2m_ctx);
> > +}
> > +
> > +void rockchip_vpu_irq_done(struct rockchip_vpu_dev *vpu,
> > +			   unsigned int bytesused,
> > +			   enum vb2_buffer_state result)
> > +{
> > +	struct rockchip_vpu_ctx *ctx =
> > +		(struct rockchip_vpu_ctx *)v4l2_m2m_get_curr_priv(vpu->m2m_dev);
> > +
> > +	/* Atomic watchdog cancel. The worker may still be
> > +	 * running after calling this.
> > +	 */
> > +	cancel_delayed_work(&vpu->watchdog_work);
> > +	if (ctx)
> > +		rockchip_vpu_job_finish(vpu, ctx, bytesused, result);
> > +}
> > +
> > +void rockchip_vpu_watchdog(struct work_struct *work)
> > +{
> > +	struct rockchip_vpu_dev *vpu;
> > +	struct rockchip_vpu_ctx *ctx;
> > +
> > +	vpu = container_of(to_delayed_work(work),
> > +			   struct rockchip_vpu_dev, watchdog_work);
> > +	ctx = (struct rockchip_vpu_ctx *)v4l2_m2m_get_curr_priv(vpu->m2m_dev);
> > +	if (ctx) {
> > +		vpu_err("frame processing timed out!\n");
> > +		ctx->codec_ops->reset(ctx);
> > +		rockchip_vpu_job_finish(vpu, ctx, 0, VB2_BUF_STATE_ERROR);
> > +	}
> > +}
> > +
> > +static void device_run(void *priv)
> > +{
> > +	struct rockchip_vpu_ctx *ctx = priv;
> > +
> > +	pm_runtime_get_sync(ctx->dev->dev);
> > +
> > +	ctx->codec_ops->run(ctx);
> > +}
> > +
> > +static struct v4l2_m2m_ops vpu_m2m_ops = {
> > +	.device_run = device_run,
> > +};
> > +
> > +static int
> > +enc_queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
> > +{
> > +	struct rockchip_vpu_ctx *ctx = priv;
> > +	int ret;
> > +
> > +	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> > +	src_vq->io_modes = VB2_MMAP | VB2_DMABUF;
> > +	src_vq->drv_priv = ctx;
> > +	src_vq->ops = &rockchip_vpu_enc_queue_ops;
> > +	src_vq->mem_ops = &vb2_dma_contig_memops;
> > +	src_vq->dma_attrs = DMA_ATTR_ALLOC_SINGLE_PAGES |
> > +			    DMA_ATTR_NO_KERNEL_MAPPING;
> > +	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> > +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> > +	src_vq->lock = &ctx->dev->vpu_mutex;
> > +	src_vq->dev = ctx->dev->v4l2_dev.dev;
> > +
> > +	ret = vb2_queue_init(src_vq);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* The CAPTURE queue doesn't need dma memory,
> > +	 * as the CPU needs to create the JPEG frames,
> > +	 * from the hardware-produced JPEG payload.
> > +	 *
> > +	 * For the DMA destination buffer, we use
> > +	 * a bounce buffer.
> > +	 */
> > +	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> > +	dst_vq->io_modes = VB2_MMAP | VB2_DMABUF;
> > +	dst_vq->drv_priv = ctx;
> > +	dst_vq->ops = &rockchip_vpu_enc_queue_ops;
> > +	dst_vq->mem_ops = &vb2_vmalloc_memops;
> > +	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> > +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> > +	dst_vq->lock = &ctx->dev->vpu_mutex;
> > +	dst_vq->dev = ctx->dev->v4l2_dev.dev;
> > +
> > +	return vb2_queue_init(dst_vq);
> > +}
> > +
> > +static int rockchip_vpu_s_ctrl(struct v4l2_ctrl *ctrl)
> > +{
> > +	struct rockchip_vpu_ctx *ctx;
> > +
> > +	ctx = container_of(ctrl->handler,
> > +			   struct rockchip_vpu_ctx, ctrl_handler);
> > +
> > +	vpu_debug(1, "s_ctrl: id = %d, val = %d\n", ctrl->id, ctrl->val);
> > +
> > +	switch (ctrl->id) {
> > +	case V4L2_CID_JPEG_COMPRESSION_QUALITY:
> > +		ctx->jpeg_quality = ctrl->val;
> > +		break;
> > +	default:
> > +		vpu_err("Invalid control id = %d, val = %d\n",
> > +			ctrl->id, ctrl->val);
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct v4l2_ctrl_ops rockchip_vpu_ctrl_ops = {
> > +	.s_ctrl = rockchip_vpu_s_ctrl,
> > +};
> > +
> > +static int rockchip_vpu_ctrls_setup(struct rockchip_vpu_dev *vpu,
> > +				    struct rockchip_vpu_ctx *ctx)
> > +{
> > +	v4l2_ctrl_handler_init(&ctx->ctrl_handler, 1);
> > +	if (ctx->ctrl_handler.error) {
> > +		vpu_err("v4l2_ctrl_handler_init failed (%d)\n",
> > +			ctx->ctrl_handler.error);
> > +		return ctx->ctrl_handler.error;
> > +	}
> > +
> > +	if (vpu->variant->codec & RK_VPU_CODEC_JPEG) {
> > +		v4l2_ctrl_new_std(&ctx->ctrl_handler, &rockchip_vpu_ctrl_ops,
> > +				  V4L2_CID_JPEG_COMPRESSION_QUALITY,
> > +				  5, 100, 1, 50);
> > +		if (ctx->ctrl_handler.error) {
> > +			vpu_err("Adding JPEG control failed %d\n",
> > +				ctx->ctrl_handler.error);
> > +			v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> > +			return ctx->ctrl_handler.error;
> > +		}
> > +	}
> > +
> > +	return v4l2_ctrl_handler_setup(&ctx->ctrl_handler);
> > +}
> > +
> > +/*
> > + * V4L2 file operations.
> > + */
> > +
> > +static int rockchip_vpu_open(struct file *filp)
> > +{
> > +	struct rockchip_vpu_dev *vpu = video_drvdata(filp);
> > +	struct video_device *vdev = video_devdata(filp);
> > +	struct rockchip_vpu_ctx *ctx;
> > +	int ret;
> > +
> > +	/*
> > +	 * We do not need any extra locking here, because we operate only
> > +	 * on local data here, except reading few fields from dev, which
> > +	 * do not change through device's lifetime (which is guaranteed by
> > +	 * reference on module from open()) and V4L2 internal objects (such
> > +	 * as vdev and ctx->fh), which have proper locking done in respective
> > +	 * helper functions used here.
> > +	 */
> > +
> > +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> > +	if (!ctx)
> > +		return -ENOMEM;
> > +
> > +	ctx->dev = vpu;
> > +	if (vdev == vpu->vfd_enc)
> > +		ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(vpu->m2m_dev, ctx,
> > +						    &enc_queue_init);
> > +	else
> > +		ctx->fh.m2m_ctx = ERR_PTR(-ENODEV);
> > +	if (IS_ERR(ctx->fh.m2m_ctx)) {
> > +		ret = PTR_ERR(ctx->fh.m2m_ctx);
> > +		kfree(ctx);
> > +		return ret;
> > +	}
> > +
> > +	v4l2_fh_init(&ctx->fh, vdev);
> > +	filp->private_data = &ctx->fh;
> > +	v4l2_fh_add(&ctx->fh);
> > +
> > +	if (vdev == vpu->vfd_enc) {
> > +		rockchip_vpu_enc_reset_dst_fmt(vpu, ctx);
> > +		rockchip_vpu_enc_reset_src_fmt(vpu, ctx);
> > +	}
> > +
> > +	ret = rockchip_vpu_ctrls_setup(vpu, ctx);
> > +	if (ret) {
> > +		vpu_err("Failed to set up controls\n");
> > +		goto err_fh_free;
> > +	}
> > +	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
> > +
> > +	return 0;
> > +
> > +err_fh_free:
> > +	v4l2_fh_del(&ctx->fh);
> > +	v4l2_fh_exit(&ctx->fh);
> > +	kfree(ctx);
> > +	return ret;
> > +}
> > +
> > +static int rockchip_vpu_release(struct file *filp)
> > +{
> > +	struct rockchip_vpu_ctx *ctx =
> > +		container_of(filp->private_data, struct rockchip_vpu_ctx, fh);
> > +
> > +	/*
> > +	 * No need for extra locking because this was the last reference
> > +	 * to this file.
> > +	 */
> > +	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
> > +	v4l2_fh_del(&ctx->fh);
> > +	v4l2_fh_exit(&ctx->fh);
> > +	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> > +	kfree(ctx);
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct v4l2_file_operations rockchip_vpu_fops = {
> > +	.owner = THIS_MODULE,
> 
> If I am not mistaken, then setting owner is no longer necessary.
> 

For v4l2_file_operations, seems the .owner is expected, see:

static inline int __must_check video_register_device(struct video_device *vdev,
                                                     enum vfl_devnode_type type,
                                                     int nr)
{
        return __video_register_device(vdev, type, nr, 1, vdev->fops->owner);
}

> > +	.open = rockchip_vpu_open,
> > +	.release = rockchip_vpu_release,
> > +	.poll = v4l2_m2m_fop_poll,
> > +	.unlocked_ioctl = video_ioctl2,
> > +	.mmap = v4l2_m2m_fop_mmap,
> > +};
> > +
> > +static const struct of_device_id of_rockchip_vpu_match[] = {
> > +	{ .compatible = "rockchip,rk3399-vpu", .data = &rk3399_vpu_variant, },
> > +	{ .compatible = "rockchip,rk3288-vpu", .data = &rk3288_vpu_variant, },
> > +	{ /* sentinel */ }
> > +};
> > +MODULE_DEVICE_TABLE(of, of_rockchip_vpu_match);
> > +
> > +static int rockchip_vpu_video_device_register(struct rockchip_vpu_dev *vpu)
> > +{
> > +	const struct of_device_id *match;
> > +	struct video_device *vfd;
> > +	int function, ret;
> > +
> > +	match = of_match_node(of_rockchip_vpu_match, vpu->dev->of_node);
> > +	vfd = video_device_alloc();
> > +	if (!vfd) {
> > +		v4l2_err(&vpu->v4l2_dev, "Failed to allocate video device\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	vfd->fops = &rockchip_vpu_fops;
> > +	vfd->release = video_device_release;
> > +	vfd->lock = &vpu->vpu_mutex;
> > +	vfd->v4l2_dev = &vpu->v4l2_dev;
> > +	vfd->vfl_dir = VFL_DIR_M2M;
> > +	vfd->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE;
> > +	vfd->ioctl_ops = &rockchip_vpu_enc_ioctl_ops;
> > +	snprintf(vfd->name, sizeof(vfd->name), "%s-enc", match->compatible);
> > +	vpu->vfd_enc = vfd;
> > +	video_set_drvdata(vfd, vpu);
> > +
> > +	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
> > +	if (ret) {
> > +		v4l2_err(&vpu->v4l2_dev, "Failed to register video device\n");
> > +		goto err_free_dev;
> > +	}
> > +	v4l2_info(&vpu->v4l2_dev, "registered as /dev/video%d\n", vfd->num);
> > +
> > +	function = MEDIA_ENT_F_PROC_VIDEO_ENCODER;
> > +	ret = v4l2_m2m_register_media_controller(vpu->m2m_dev, vfd, function);
> > +	if (ret) {
> > +		v4l2_err(&vpu->v4l2_dev, "Failed to init mem2mem media controller\n");
> > +		goto err_unreg_video;
> > +	}
> > +	return 0;
> > +
> > +err_unreg_video:
> > +	video_unregister_device(vfd);
> > +err_free_dev:
> > +	video_device_release(vfd);
> > +	return ret;
> > +}
> > +
> > +static int rockchip_vpu_probe(struct platform_device *pdev)
> > +{
> > +	const struct of_device_id *match;
> > +	struct rockchip_vpu_dev *vpu;
> > +	struct resource *res;
> > +	int i, ret;
> > +
> > +	vpu = devm_kzalloc(&pdev->dev, sizeof(*vpu), GFP_KERNEL);
> > +	if (!vpu)
> > +		return -ENOMEM;
> > +
> > +	vpu->dev = &pdev->dev;
> > +	vpu->pdev = pdev;
> > +	mutex_init(&vpu->vpu_mutex);
> > +	spin_lock_init(&vpu->irqlock);
> > +
> > +	match = of_match_node(of_rockchip_vpu_match, pdev->dev.of_node);
> > +	vpu->variant = match->data;
> > +
> > +	INIT_DELAYED_WORK(&vpu->watchdog_work, rockchip_vpu_watchdog);
> > +
> > +	for (i = 0; i < vpu->variant->num_clocks; i++)
> > +		vpu->clocks[i].id = vpu->variant->clk_names[i];
> > +	ret = devm_clk_bulk_get(&pdev->dev, vpu->variant->num_clocks,
> > +				vpu->clocks);
> > +	if (ret)
> > +		return ret;
> > +
> > +	res = platform_get_resource(vpu->pdev, IORESOURCE_MEM, 0);
> > +	vpu->base = devm_ioremap_resource(vpu->dev, res);
> > +	if (IS_ERR(vpu->base))
> > +		return PTR_ERR(vpu->base);
> > +	vpu->enc_base = vpu->base + vpu->variant->enc_offset;
> > +
> > +	ret = dma_set_coherent_mask(vpu->dev, DMA_BIT_MASK(32));
> > +	if (ret) {
> > +		dev_err(vpu->dev, "Could not set DMA coherent mask.\n");
> > +		return ret;
> > +	}
> > +
> > +	if (vpu->variant->vepu_irq) {
> > +		int irq;
> > +
> > +		irq = platform_get_irq_byname(vpu->pdev, "vepu");
> > +		if (irq <= 0) {
> > +			dev_err(vpu->dev, "Could not get vepu IRQ.\n");
> > +			return -ENXIO;
> > +		}
> > +
> > +		ret = devm_request_irq(vpu->dev, irq, vpu->variant->vepu_irq,
> > +				       0, dev_name(vpu->dev), vpu);
> > +		if (ret) {
> > +			dev_err(vpu->dev, "Could not request vepu IRQ.\n");
> > +			return ret;
> > +		}
> > +	}
> > +
> > +	ret = vpu->variant->init(vpu);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Failed to init VPU hardware\n");
> > +		return ret;
> > +	}
> > +
> > +	pm_runtime_set_autosuspend_delay(vpu->dev, 100);
> > +	pm_runtime_use_autosuspend(vpu->dev);
> > +	pm_runtime_enable(vpu->dev);
> > +
> > +	ret = clk_bulk_prepare(vpu->variant->num_clocks, vpu->clocks);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Failed to prepare clocks\n");
> > +		return ret;
> > +	}
> > +
> > +	ret = v4l2_device_register(&pdev->dev, &vpu->v4l2_dev);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Failed to register v4l2 device\n");
> > +		goto err_clk_unprepare;
> > +	}
> > +	platform_set_drvdata(pdev, vpu);
> > +
> > +	vpu->m2m_dev = v4l2_m2m_init(&vpu_m2m_ops);
> > +	if (IS_ERR(vpu->m2m_dev)) {
> > +		v4l2_err(&vpu->v4l2_dev, "Failed to init mem2mem device\n");
> > +		ret = PTR_ERR(vpu->m2m_dev);
> > +		goto err_v4l2_unreg;
> > +	}
> > +
> > +	vpu->mdev.dev = vpu->dev;
> > +	strlcpy(vpu->mdev.model, DRIVER_NAME, sizeof(vpu->mdev.model));
> > +	media_device_init(&vpu->mdev);
> > +	vpu->v4l2_dev.mdev = &vpu->mdev;
> > +
> > +	ret = rockchip_vpu_video_device_register(vpu);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Failed to register encoder\n");
> > +		goto err_m2m_rel;
> > +	}
> > +
> > +	ret = media_device_register(&vpu->mdev);
> > +	if (ret) {
> > +		v4l2_err(&vpu->v4l2_dev, "Failed to register mem2mem media device\n");
> > +		goto err_video_dev_unreg;
> > +	}
> > +	return 0;
> > +err_video_dev_unreg:
> > +	if (vpu->vfd_enc) {
> > +		video_unregister_device(vpu->vfd_enc);
> > +		video_device_release(vpu->vfd_enc);
> > +	}
> > +err_m2m_rel:
> > +	v4l2_m2m_release(vpu->m2m_dev);
> > +err_v4l2_unreg:
> > +	v4l2_device_unregister(&vpu->v4l2_dev);
> > +err_clk_unprepare:
> > +	clk_bulk_unprepare(vpu->variant->num_clocks, vpu->clocks);
> > +	pm_runtime_disable(vpu->dev);
> > +	return ret;
> > +}
> > +
> > +static int rockchip_vpu_remove(struct platform_device *pdev)
> > +{
> > +	struct rockchip_vpu_dev *vpu = platform_get_drvdata(pdev);
> > +
> > +	v4l2_info(&vpu->v4l2_dev, "Removing %s\n", pdev->name);
> > +
> > +	media_device_unregister(&vpu->mdev);
> > +	v4l2_m2m_unregister_media_controller(vpu->m2m_dev);
> > +	v4l2_m2m_release(vpu->m2m_dev);
> > +	media_device_cleanup(&vpu->mdev);
> > +	if (vpu->vfd_enc) {
> > +		video_unregister_device(vpu->vfd_enc);
> > +		video_device_release(vpu->vfd_enc);
> > +	}
> > +	v4l2_device_unregister(&vpu->v4l2_dev);
> > +	clk_bulk_unprepare(vpu->variant->num_clocks, vpu->clocks);
> > +	pm_runtime_disable(vpu->dev);
> > +	return 0;
> > +}
> > +
> > +static int __maybe_unused rockchip_vpu_runtime_suspend(struct device *dev)
> > +{
> > +	struct rockchip_vpu_dev *vpu = dev_get_drvdata(dev);
> > +
> > +	clk_bulk_disable(vpu->variant->num_clocks, vpu->clocks);
> > +	return 0;
> > +}
> > +
> > +static int __maybe_unused rockchip_vpu_runtime_resume(struct device *dev)
> > +{
> > +	struct rockchip_vpu_dev *vpu = dev_get_drvdata(dev);
> > +
> > +	return clk_bulk_enable(vpu->variant->num_clocks, vpu->clocks);
> > +}
> > +
> > +static const struct dev_pm_ops rockchip_vpu_pm_ops = {
> > +	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
> > +				pm_runtime_force_resume)
> > +	SET_RUNTIME_PM_OPS(rockchip_vpu_runtime_suspend,
> > +			   rockchip_vpu_runtime_resume, NULL)
> > +};
> > +
> > +static struct platform_driver rockchip_vpu_driver = {
> > +	.probe = rockchip_vpu_probe,
> > +	.remove = rockchip_vpu_remove,
> > +	.driver = {
> > +		   .name = DRIVER_NAME,
> > +		   .of_match_table = of_match_ptr(of_rockchip_vpu_match),
> > +		   .pm = &rockchip_vpu_pm_ops,
> > +	},
> > +};
> > +module_platform_driver(rockchip_vpu_driver);
> > +
> > +MODULE_LICENSE("GPL v2");
> > +MODULE_AUTHOR("Alpha Lin <Alpha.Lin@Rock-Chips.com>");
> > +MODULE_AUTHOR("Tomasz Figa <tfiga@chromium.org>");
> > +MODULE_AUTHOR("Ezequiel Garcia <ezequiel@collabora.com>");
> > +MODULE_DESCRIPTION("Rockchip VPU codec driver");
> > diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c b/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
> > new file mode 100644
> > index 000000000000..a041e8622ce5
> > --- /dev/null
> > +++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
> > @@ -0,0 +1,701 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Rockchip VPU codec driver
> > + *
> > + * Copyright (C) 2018 Collabora, Ltd.
> > + * Copyright (C) 2018 Rockchip Electronics Co., Ltd.
> > + *	Alpha Lin <Alpha.Lin@rock-chips.com>
> > + *	Jeffy Chen <jeffy.chen@rock-chips.com>
> > + *
> > + * Copyright (C) 2018 Google, Inc.
> > + *	Tomasz Figa <tfiga@chromium.org>
> > + *
> > + * Based on s5p-mfc driver by Samsung Electronics Co., Ltd.
> > + * Copyright (C) 2010-2011 Samsung Electronics Co., Ltd.
> > + */
> > +
> > +#include <linux/interrupt.h>
> > +#include <linux/io.h>
> > +#include <linux/module.h>
> > +#include <linux/pm_runtime.h>
> > +#include <linux/videodev2.h>
> > +#include <linux/workqueue.h>
> > +#include <media/v4l2-ctrls.h>
> > +#include <media/v4l2-event.h>
> > +#include <media/v4l2-mem2mem.h>
> > +#include <media/videobuf2-core.h>
> > +#include <media/videobuf2-dma-sg.h>
> > +
> > +#include "rockchip_vpu.h"
> > +#include "rockchip_vpu_hw.h"
> > +#include "rockchip_vpu_common.h"
> > +
> > +/**
> > + * struct v4l2_format_info - information about a V4L2 format
> > + * @format: 4CC format identifier (V4L2_PIX_FMT_*)
> > + * @header_size: Size of header, optional and used by compressed formats
> > + * @num_planes: Number of planes (1 to 3)
> > + * @cpp: Number of bytes per pixel (per plane)
> > + * @hsub: Horizontal chroma subsampling factor
> > + * @vsub: Vertical chroma subsampling factor
> > + * @is_compressed: Is it a compressed format?
> 
> 'multiplanar' is not documented.
> 

Oops :]

> Is it needed? Doesn't num_planes > 1 do the same?
> 

The multiplanar flag is used to distinguish e.g.
V4L2_PIX_FMT_NV12M from V4L2_PIX_FMT_NV12.

> > + */
> > +struct v4l2_format_info {
> > +	u32 format;
> > +	u32 header_size;
> > +	u8 num_planes;
> > +	u8 cpp[3];
> > +	u8 hsub;
> > +	u8 vsub;
> > +	bool is_compressed;
> > +	bool multiplanar;
> > +};
> > +
> > +static const struct v4l2_format_info *
> > +v4l2_format_info(u32 format)
> > +{
> > +	static const struct v4l2_format_info formats[] = {
> > +		{ .format = V4L2_PIX_FMT_YUV420M,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 2, .vsub = 2, .multiplanar = 1 },
> > +		{ .format = V4L2_PIX_FMT_NV12M,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 2, .multiplanar = 1 },
> > +		{ .format = V4L2_PIX_FMT_YUYV,		.num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
> > +		{ .format = V4L2_PIX_FMT_UYVY,		.num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
> > +	};
> > +	unsigned int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
> > +		if (formats[i].format == format)
> > +			return &formats[i];
> > +	}
> > +
> > +	vpu_err("Unsupported V4L 4CC format (%08x)\n", format);
> > +	return NULL;
> > +}
> > +
> > +static void
> > +fill_pixfmt_mp(struct v4l2_pix_format_mplane *pixfmt,
> > +	       int pixelformat, int width, int height)
> > +{
> > +	const struct v4l2_format_info *info;
> > +	struct v4l2_plane_pix_format *plane;
> > +	int i;
> > +
> > +	info = v4l2_format_info(pixelformat);
> > +	if (!info)
> > +		return;
> > +
> > +	pixfmt->width = width;
> > +	pixfmt->height = height;
> > +	pixfmt->pixelformat = pixelformat;
> > +
> > +	if (!info->multiplanar) {
> > +		pixfmt->num_planes = 1;
> > +		plane = &pixfmt->plane_fmt[0];
> > +		plane->bytesperline = info->is_compressed ?
> > +					0 : width * info->cpp[0];
> > +		plane->sizeimage = info->header_size;
> > +		for (i = 0; i < info->num_planes; i++) {
> > +			unsigned int hsub = (i == 0) ? 1 : info->hsub;
> > +			unsigned int vsub = (i == 0) ? 1 : info->vsub;
> > +
> > +			plane->sizeimage +=
> > +				width * height * info->cpp[i] / (hsub * vsub);
> > +		}
> > +	} else {
> > +		pixfmt->num_planes = info->num_planes;
> > +		for (i = 0; i < info->num_planes; i++) {
> > +			unsigned int hsub = (i == 0) ? 1 : info->hsub;
> > +			unsigned int vsub = (i == 0) ? 1 : info->vsub;
> > +
> > +			plane = &pixfmt->plane_fmt[i];
> > +			plane->bytesperline = width * info->cpp[i] / hsub;
> > +			plane->sizeimage =
> > +				width * height * info->cpp[i] / (hsub * vsub);
> > +		}
> > +	}
> > +}
> > +
> > +static const struct rockchip_vpu_fmt *
> > +rockchip_vpu_find_format(struct rockchip_vpu_ctx *ctx, u32 fourcc)
> > +{
> > +	struct rockchip_vpu_dev *dev = ctx->dev;
> > +	const struct rockchip_vpu_fmt *formats;
> > +	unsigned int num_fmts, i;
> > +
> > +	formats = dev->variant->enc_fmts;
> > +	num_fmts = dev->variant->num_enc_fmts;
> > +	for (i = 0; i < num_fmts; i++)
> > +		if (formats[i].fourcc == fourcc)
> > +			return &formats[i];
> > +	return NULL;
> > +}
> > +
> > +static const struct rockchip_vpu_fmt *
> > +rockchip_vpu_get_default_fmt(struct rockchip_vpu_ctx *ctx, bool bitstream)
> > +{
> > +	struct rockchip_vpu_dev *dev = ctx->dev;
> > +	const struct rockchip_vpu_fmt *formats;
> > +	unsigned int num_fmts, i;
> > +
> > +	formats = dev->variant->enc_fmts;
> > +	num_fmts = dev->variant->num_enc_fmts;
> > +	for (i = 0; i < num_fmts; i++) {
> > +		if (bitstream == (formats[i].codec_mode != RK_VPU_MODE_NONE))
> > +			return &formats[i];
> > +	}
> > +	return NULL;
> > +}
> > +
> > +static int vidioc_querycap(struct file *file, void *priv,
> > +			   struct v4l2_capability *cap)
> > +{
> > +	struct rockchip_vpu_dev *vpu = video_drvdata(file);
> > +
> > +	strlcpy(cap->driver, vpu->dev->driver->name, sizeof(cap->driver));
> > +	strlcpy(cap->card, vpu->vfd_enc->name, sizeof(cap->card));
> 
> Use strscpy instead of strcpy, strlcpy or strncpy.
> 
> Please check the driver code for this.
> 

Sure.

> > +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform: %s",
> > +		 vpu->dev->driver->name);
> > +	return 0;
> > +}
> > +
> > +static int vidioc_enum_framesizes(struct file *file, void *priv,
> > +				  struct v4l2_frmsizeenum *fsize)
> > +{
> > +	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> > +	const struct rockchip_vpu_fmt *fmt;
> > +
> > +	if (fsize->index != 0) {
> > +		vpu_debug(0, "invalid frame size index (expected 0, got %d)\n",
> > +			  fsize->index);
> > +		return -EINVAL;
> > +	}
> > +
> > +	fmt = rockchip_vpu_find_format(ctx, fsize->pixel_format);
> > +	if (!fmt) {
> > +		vpu_debug(0, "unsupported bitstream format (%08x)\n",
> > +			  fsize->pixel_format);
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* This only makes sense for codec formats */
> > +	if (fmt->codec_mode == RK_VPU_MODE_NONE)
> > +		return -EINVAL;
> > +
> > +	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
> > +	fsize->stepwise = fmt->frmsize;
> > +
> > +	return 0;
> > +}
> > +
> > +static int vidioc_enum_fmt_vid_cap_mplane(struct file *file, void *priv,
> > +					  struct v4l2_fmtdesc *f)
> > +{
> > +	struct rockchip_vpu_dev *dev = video_drvdata(file);
> > +	const struct rockchip_vpu_fmt *fmt;
> > +	const struct rockchip_vpu_fmt *formats;
> > +	int num_fmts, i, j = 0;
> > +
> > +	formats = dev->variant->enc_fmts;
> > +	num_fmts = dev->variant->num_enc_fmts;
> > +	for (i = 0; i < num_fmts; i++) {
> > +		/* Skip uncompressed formats */
> > +		if (formats[i].codec_mode == RK_VPU_MODE_NONE)
> > +			continue;
> > +		if (j == f->index) {
> > +			fmt = &formats[i];
> > +			f->pixelformat = fmt->fourcc;
> > +			return 0;
> > +		}
> > +		++j;
> > +	}
> > +	return -EINVAL;
> > +}
> > +
> > +static int vidioc_enum_fmt_vid_out_mplane(struct file *file, void *priv,
> > +					  struct v4l2_fmtdesc *f)
> > +{
> > +	struct rockchip_vpu_dev *dev = video_drvdata(file);
> > +	const struct rockchip_vpu_fmt *formats;
> > +	const struct rockchip_vpu_fmt *fmt;
> > +	int num_fmts, i, j = 0;
> > +
> > +	formats = dev->variant->enc_fmts;
> > +	num_fmts = dev->variant->num_enc_fmts;
> > +	for (i = 0; i < num_fmts; i++) {
> > +		if (formats[i].codec_mode != RK_VPU_MODE_NONE)
> > +			continue;
> > +		if (j == f->index) {
> > +			fmt = &formats[i];
> > +			f->pixelformat = fmt->fourcc;
> > +			return 0;
> > +		}
> > +		++j;
> > +	}
> > +	return -EINVAL;
> > +}
> > +
> > +static int vidioc_g_fmt_out(struct file *file, void *priv,
> 
> Please add the _mplane suffix to all these vidioc_*_fmt functions.
> It's confusing otherwise.
> 

Will do.

> > +			    struct v4l2_format *f)
> > +{
> > +	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
> > +	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> > +
> > +	vpu_debug(4, "f->type = %d\n", f->type);
> > +
> > +	*pix_mp = ctx->src_fmt;
> > +	pix_mp->colorspace = ctx->colorspace;
> > +	pix_mp->ycbcr_enc = ctx->ycbcr_enc;
> > +	pix_mp->xfer_func = ctx->xfer_func;
> > +	pix_mp->quantization = ctx->quantization;
> > +
> > +	return 0;
> > +}
> > +
> > +static int vidioc_g_fmt_cap(struct file *file, void *priv,
> > +			    struct v4l2_format *f)
> > +{
> > +	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
> > +	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> > +
> > +	vpu_debug(4, "f->type = %d\n", f->type);
> > +
> > +	*pix_mp = ctx->dst_fmt;
> > +	pix_mp->colorspace = ctx->colorspace;
> > +	pix_mp->ycbcr_enc = ctx->ycbcr_enc;
> > +	pix_mp->xfer_func = ctx->xfer_func;
> > +	pix_mp->quantization = ctx->quantization;
> > +
> > +	return 0;
> > +}
> > +
> > +static int
> > +vidioc_try_fmt_cap(struct file *file, void *priv, struct v4l2_format *f)
> > +{
> > +	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> > +	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
> > +	const struct rockchip_vpu_fmt *fmt;
> > +
> > +	vpu_debug(4, "%c%c%c%c\n",
> > +		  (pix_mp->pixelformat & 0x7f),
> > +		  (pix_mp->pixelformat >> 8) & 0x7f,
> > +		  (pix_mp->pixelformat >> 16) & 0x7f,
> > +		  (pix_mp->pixelformat >> 24) & 0x7f);
> > +
> > +	fmt = rockchip_vpu_find_format(ctx, pix_mp->pixelformat);
> > +	if (!fmt) {
> > +		fmt = rockchip_vpu_get_default_fmt(ctx, true);
> > +		f->fmt.pix.pixelformat = fmt->fourcc;
> > +	}
> > +
> > +	pix_mp->num_planes = 1;
> > +	pix_mp->field = V4L2_FIELD_NONE;
> > +	pix_mp->width = clamp(pix_mp->width,
> > +			      fmt->frmsize.min_width,
> > +			      fmt->frmsize.max_width);
> > +	pix_mp->height = clamp(pix_mp->height,
> > +			       fmt->frmsize.min_height,
> > +			       fmt->frmsize.max_height);
> > +	pix_mp->plane_fmt[0].sizeimage = fmt->header_size +
> > +		pix_mp->width * pix_mp->height * fmt->max_depth;
> > +	memset(pix_mp->plane_fmt[0].reserved, 0,
> > +	       sizeof(pix_mp->plane_fmt[0].reserved));
> > +	return 0;
> > +}
> > +
> > +static int
> > +vidioc_try_fmt_out(struct file *file, void *priv, struct v4l2_format *f)
> > +{
> > +	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> > +	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
> > +	const struct rockchip_vpu_fmt *fmt;
> > +	unsigned int width, height;
> > +	unsigned long dma_align;
> > +	bool need_alignment;
> > +	int i;
> > +
> > +	vpu_debug(4, "%c%c%c%c\n",
> > +		  (pix_mp->pixelformat & 0x7f),
> > +		  (pix_mp->pixelformat >> 8) & 0x7f,
> > +		  (pix_mp->pixelformat >> 16) & 0x7f,
> > +		  (pix_mp->pixelformat >> 24) & 0x7f);
> > +
> > +	fmt = rockchip_vpu_find_format(ctx, pix_mp->pixelformat);
> > +	if (!fmt) {
> > +		fmt = rockchip_vpu_get_default_fmt(ctx, false);
> > +		f->fmt.pix.pixelformat = fmt->fourcc;
> > +	}
> > +
> > +	pix_mp->field = V4L2_FIELD_NONE;
> > +	width = clamp(pix_mp->width,
> > +		      ctx->vpu_dst_fmt->frmsize.min_width,
> > +		      ctx->vpu_dst_fmt->frmsize.max_width);
> > +	height = clamp(pix_mp->height,
> > +		       ctx->vpu_dst_fmt->frmsize.min_height,
> > +		       ctx->vpu_dst_fmt->frmsize.max_height);
> > +	/* Round up to macroblocks. */
> > +	width = round_up(width, MB_DIM);
> > +	height = round_up(height, MB_DIM);
> > +
> > +	/* Fill remaining fields */
> > +	fill_pixfmt_mp(pix_mp, fmt->fourcc, width, height);
> > +
> > +	for (i = 0; i < pix_mp->num_planes; i++) {
> > +		memset(pix_mp->plane_fmt[i].reserved, 0,
> > +		       sizeof(pix_mp->plane_fmt[i].reserved));
> > +	}
> > +
> > +	dma_align = dma_get_cache_alignment();
> > +	need_alignment = false;
> > +	for (i = 0; i < pix_mp->num_planes; i++) {
> > +		if (!IS_ALIGNED(pix_mp->plane_fmt[i].sizeimage,
> > +				dma_align)) {
> > +			need_alignment = true;
> > +			break;
> > +		}
> > +	}
> > +	if (!need_alignment)
> > +		return 0;
> > +
> > +	pix_mp->height = round_up(pix_mp->height, dma_align * 4 / MB_DIM);
> > +	if (pix_mp->height > ctx->vpu_dst_fmt->frmsize.max_height) {
> > +		vpu_err("Aligned height higher than maximum.\n");
> > +		return -EINVAL;
> > +	}
> > +	/* Fill in remaining fields, again */
> > +	fill_pixfmt_mp(pix_mp, fmt->fourcc, pix_mp->width, pix_mp->height);
> > +	return 0;
> > +}
> > +
> > +void rockchip_vpu_enc_reset_dst_fmt(struct rockchip_vpu_dev *vpu,
> > +				    struct rockchip_vpu_ctx *ctx)
> > +{
> > +	struct v4l2_pix_format_mplane *fmt = &ctx->dst_fmt;
> > +
> > +	ctx->vpu_dst_fmt = rockchip_vpu_get_default_fmt(ctx, true);
> > +
> > +	memset(fmt, 0, sizeof(*fmt));
> > +
> > +	fmt->num_planes = 1;
> > +	fmt->width = clamp(fmt->width, ctx->vpu_dst_fmt->frmsize.min_width,
> > +			   ctx->vpu_dst_fmt->frmsize.max_width);
> > +	fmt->height = clamp(fmt->height, ctx->vpu_dst_fmt->frmsize.min_height,
> > +			    ctx->vpu_dst_fmt->frmsize.max_height);
> > +	fmt->pixelformat = ctx->vpu_dst_fmt->fourcc;
> > +	fmt->field = V4L2_FIELD_NONE;
> > +	fmt->colorspace = ctx->colorspace;
> > +	fmt->ycbcr_enc = ctx->ycbcr_enc;
> > +	fmt->xfer_func = ctx->xfer_func;
> > +	fmt->quantization = ctx->quantization;
> > +
> > +	fmt->plane_fmt[0].sizeimage = ctx->vpu_dst_fmt->header_size +
> > +		fmt->width * fmt->height * ctx->vpu_dst_fmt->max_depth;
> > +}
> > +
> > +void rockchip_vpu_enc_reset_src_fmt(struct rockchip_vpu_dev *vpu,
> > +				    struct rockchip_vpu_ctx *ctx)
> > +{
> > +	struct v4l2_pix_format_mplane *fmt = &ctx->src_fmt;
> > +	unsigned int width, height;
> > +
> > +	ctx->vpu_src_fmt = rockchip_vpu_get_default_fmt(ctx, false);
> > +
> > +	memset(fmt, 0, sizeof(*fmt));
> > +
> > +	width = clamp(fmt->width, ctx->vpu_dst_fmt->frmsize.min_width,
> > +		      ctx->vpu_dst_fmt->frmsize.max_width);
> > +	height = clamp(fmt->height, ctx->vpu_dst_fmt->frmsize.min_height,
> > +		       ctx->vpu_dst_fmt->frmsize.max_height);
> > +	fmt->field = V4L2_FIELD_NONE;
> > +	fmt->colorspace = ctx->colorspace;
> > +	fmt->ycbcr_enc = ctx->ycbcr_enc;
> > +	fmt->xfer_func = ctx->xfer_func;
> > +	fmt->quantization = ctx->quantization;
> > +
> > +	fill_pixfmt_mp(fmt, ctx->vpu_src_fmt->fourcc, width, height);
> > +}
> > +
> > +static int
> > +vidioc_s_fmt_out(struct file *file, void *priv, struct v4l2_format *f)
> > +{
> > +	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
> > +	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> > +	struct vb2_queue *vq, *peer_vq;
> > +	int ret;
> > +
> > +	/* Change not allowed if queue is streaming. */
> > +	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> > +	if (vb2_is_streaming(vq))
> > +		return -EBUSY;
> > +
> > +	ctx->colorspace = pix_mp->colorspace;
> > +	ctx->ycbcr_enc = pix_mp->ycbcr_enc;
> > +	ctx->xfer_func = pix_mp->xfer_func;
> > +	ctx->quantization = pix_mp->quantization;
> > +
> > +	/*
> > +	 * Pixel format change is not allowed when the other queue has
> > +	 * buffers allocated.
> > +	 */
> > +	peer_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
> > +				  V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
> > +	if (vb2_is_busy(peer_vq) &&
> > +	    pix_mp->pixelformat != ctx->src_fmt.pixelformat)
> > +		return -EBUSY;
> > +
> > +	ret = vidioc_try_fmt_out(file, priv, f);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ctx->vpu_src_fmt = rockchip_vpu_find_format(ctx, pix_mp->pixelformat);
> > +	ctx->src_fmt = *pix_mp;
> > +
> > +	vpu_debug(0, "OUTPUT codec mode: %d\n", ctx->vpu_src_fmt->codec_mode);
> > +	vpu_debug(0, "fmt - w: %d, h: %d, mb - w: %d, h: %d\n",
> > +		  pix_mp->width, pix_mp->height,
> > +		  MB_WIDTH(pix_mp->width),
> > +		  MB_HEIGHT(pix_mp->height));
> > +	return 0;
> > +}
> > +
> > +static int
> > +vidioc_s_fmt_cap(struct file *file, void *priv, struct v4l2_format *f)
> > +{
> > +	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
> > +	struct rockchip_vpu_ctx *ctx = fh_to_ctx(priv);
> > +	struct rockchip_vpu_dev *vpu = ctx->dev;
> > +	struct vb2_queue *vq, *peer_vq;
> > +	int ret;
> > +
> > +	/* Change not allowed if queue is streaming. */
> > +	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> > +	if (vb2_is_streaming(vq))
> > +		return -EBUSY;
> > +
> > +	ctx->colorspace = pix_mp->colorspace;
> > +	ctx->ycbcr_enc = pix_mp->ycbcr_enc;
> > +	ctx->xfer_func = pix_mp->xfer_func;
> > +	ctx->quantization = pix_mp->quantization;
> > +
> > +	/*
> > +	 * Pixel format change is not allowed when the other queue has
> > +	 * buffers allocated.
> > +	 */
> > +	peer_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
> > +				  V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
> > +	if (vb2_is_busy(peer_vq) &&
> > +	    pix_mp->pixelformat != ctx->dst_fmt.pixelformat)
> > +		return -EBUSY;
> > +
> > +	ret = vidioc_try_fmt_cap(file, priv, f);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ctx->vpu_dst_fmt = rockchip_vpu_find_format(ctx, pix_mp->pixelformat);
> > +	ctx->dst_fmt = *pix_mp;
> > +
> > +	vpu_debug(0, "CAPTURE codec mode: %d\n", ctx->vpu_dst_fmt->codec_mode);
> > +	vpu_debug(0, "fmt - w: %d, h: %d, mb - w: %d, h: %d\n",
> > +		  pix_mp->width, pix_mp->height,
> > +		  MB_WIDTH(pix_mp->width),
> > +		  MB_HEIGHT(pix_mp->height));
> > +
> > +	/*
> > +	 * Current raw format might have become invalid with newly
> > +	 * selected codec, so reset it to default just to be safe and
> > +	 * keep internal driver state sane. User is mandated to set
> > +	 * the raw format again after we return, so we don't need
> > +	 * anything smarter.
> > +	 */
> > +	rockchip_vpu_enc_reset_src_fmt(vpu, ctx);
> > +	return 0;
> > +}
> > +
> > +const struct v4l2_ioctl_ops rockchip_vpu_enc_ioctl_ops = {
> > +	.vidioc_querycap = vidioc_querycap,
> > +	.vidioc_enum_framesizes = vidioc_enum_framesizes,
> > +
> > +	.vidioc_try_fmt_vid_cap_mplane = vidioc_try_fmt_cap,
> > +	.vidioc_try_fmt_vid_out_mplane = vidioc_try_fmt_out,
> > +	.vidioc_s_fmt_vid_out_mplane = vidioc_s_fmt_out,
> > +	.vidioc_s_fmt_vid_cap_mplane = vidioc_s_fmt_cap,
> > +	.vidioc_g_fmt_vid_out_mplane = vidioc_g_fmt_out,
> > +	.vidioc_g_fmt_vid_cap_mplane = vidioc_g_fmt_cap,
> > +	.vidioc_enum_fmt_vid_out_mplane = vidioc_enum_fmt_vid_out_mplane,
> > +	.vidioc_enum_fmt_vid_cap_mplane = vidioc_enum_fmt_vid_cap_mplane,
> > +
> > +	.vidioc_reqbufs = v4l2_m2m_ioctl_reqbufs,
> > +	.vidioc_querybuf = v4l2_m2m_ioctl_querybuf,
> > +	.vidioc_qbuf = v4l2_m2m_ioctl_qbuf,
> > +	.vidioc_dqbuf = v4l2_m2m_ioctl_dqbuf,
> > +	.vidioc_prepare_buf = v4l2_m2m_ioctl_prepare_buf,
> > +	.vidioc_create_bufs = v4l2_m2m_ioctl_create_bufs,
> > +	.vidioc_expbuf = v4l2_m2m_ioctl_expbuf,
> > +
> > +	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
> > +	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
> > +
> > +	.vidioc_streamon = v4l2_m2m_ioctl_streamon,
> > +	.vidioc_streamoff = v4l2_m2m_ioctl_streamoff,
> > +};
> > +
> > +static int
> > +rockchip_vpu_queue_setup(struct vb2_queue *vq,
> > +			 unsigned int *num_buffers,
> > +			 unsigned int *num_planes,
> > +			 unsigned int sizes[],
> > +			 struct device *alloc_devs[])
> > +{
> > +	struct rockchip_vpu_ctx *ctx = vb2_get_drv_priv(vq);
> > +	const struct rockchip_vpu_fmt *vpu_fmt;
> > +	struct v4l2_pix_format_mplane *pixfmt;
> > +	int i;
> > +
> > +	switch (vq->type) {
> > +	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> > +		vpu_fmt = ctx->vpu_dst_fmt;
> > +		pixfmt = &ctx->dst_fmt;
> > +		break;
> > +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> > +		vpu_fmt = ctx->vpu_src_fmt;
> > +		pixfmt = &ctx->src_fmt;
> > +		break;
> > +	default:
> > +		vpu_err("invalid queue type: %d\n", vq->type);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (*num_planes) {
> > +		if (*num_planes !=  pixfmt->num_planes)
> > +			return -EINVAL;
> > +		for (i = 0; i < pixfmt->num_planes; ++i)
> > +			if (sizes[i] < pixfmt->plane_fmt[i].sizeimage)
> > +				return -EINVAL;
> > +		return 0;
> > +	}
> > +
> > +	*num_planes = pixfmt->num_planes;
> > +	for (i = 0; i < pixfmt->num_planes; ++i)
> > +		sizes[i] = pixfmt->plane_fmt[i].sizeimage;
> > +	return 0;
> > +}
> > +
> > +static int rockchip_vpu_buf_prepare(struct vb2_buffer *vb)
> > +{
> > +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> > +	struct vb2_queue *vq = vb->vb2_queue;
> > +	struct rockchip_vpu_ctx *ctx = vb2_get_drv_priv(vq);
> > +	const struct rockchip_vpu_fmt *vpu_fmt;
> > +	struct v4l2_pix_format_mplane *pixfmt;
> > +	unsigned int sz;
> > +	int ret = 0;
> > +	int i;
> > +
> > +	switch (vq->type) {
> > +	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> > +		vpu_fmt = ctx->vpu_dst_fmt;
> > +		pixfmt = &ctx->dst_fmt;
> > +		break;
> > +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> > +		vpu_fmt = ctx->vpu_src_fmt;
> > +		pixfmt = &ctx->src_fmt;
> > +
> > +		if (vbuf->field == V4L2_FIELD_ANY)
> > +			vbuf->field = V4L2_FIELD_NONE;
> > +		if (vbuf->field != V4L2_FIELD_NONE) {
> > +			vpu_debug(4, "field %d not supported\n",
> > +				  vbuf->field);
> > +			return -EINVAL;
> > +		}
> > +		break;
> > +	default:
> > +		vpu_err("invalid queue type: %d\n", vq->type);
> > +		return -EINVAL;
> > +	}
> > +
> > +	for (i = 0; i < pixfmt->num_planes; ++i) {
> > +		sz = pixfmt->plane_fmt[i].sizeimage;
> > +		vpu_debug(4, "plane %d size: %ld, sizeimage: %u\n",
> > +			  i, vb2_plane_size(vb, i), sz);
> > +		if (vb2_plane_size(vb, i) < sz) {
> > +			vpu_err("plane %d is too small\n", i);
> > +			ret = -EINVAL;
> > +			break;
> > +		}
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static void rockchip_vpu_buf_queue(struct vb2_buffer *vb)
> > +{
> > +	struct rockchip_vpu_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> > +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> > +
> > +	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
> > +}
> > +
> > +static int rockchip_vpu_start_streaming(struct vb2_queue *q, unsigned int count)
> > +{
> > +	struct rockchip_vpu_ctx *ctx = vb2_get_drv_priv(q);
> > +	enum rockchip_vpu_codec_mode codec_mode;
> > +
> > +	if (V4L2_TYPE_IS_OUTPUT(q->type))
> > +		ctx->sequence_out = 0;
> > +	else
> > +		ctx->sequence_cap = 0;
> > +
> > +	/* Set codec_ops for the chosen destination format */
> > +	codec_mode = ctx->vpu_dst_fmt->codec_mode;
> > +
> > +	vpu_debug(4, "Codec mode = %d\n", codec_mode);
> > +	ctx->codec_ops = &ctx->dev->variant->codec_ops[codec_mode];
> > +
> > +	/* A bounce buffer is needed for the JPEG payload */
> 
> Why exactly is it needed? I assume it is because the DMA engine expects
> that the JPEG data starts at a specific alignment? And that alignment
> doesn't work with the header in front?
> 

You assume correctly. Without some padding, the JPEG start of scan
would violate the alignment for DMA. 

> If that's the case, then there are ways around it: you would have to
> add a APPn block to align to the right boundary, and you would need to
> copy the header in the buf_prepare op (i.e. before the buffer is
> synced for DMA).
> 
> Not saying you should do that now, but if this is the reason for the
> bounce buffer, then this may be a future optimization.
> 

Right. I will post follow-up patches, as it will be interesting
to reduce the memory usage.

> > +	if (!V4L2_TYPE_IS_OUTPUT(q->type)) {
> > +		ctx->bounce_size = ctx->dst_fmt.plane_fmt[0].sizeimage -
> > +				  ctx->vpu_dst_fmt->header_size;
> > +		ctx->bounce_buf = dma_alloc_attrs(ctx->dev->dev,
> > +						  ctx->bounce_size,
> > +						  &ctx->bounce_dma_addr,
> > +						  GFP_KERNEL,
> > +						  DMA_ATTR_ALLOC_SINGLE_PAGES);
> > +	}
> > +	return 0;
> > +}
> > +
> > +static void rockchip_vpu_stop_streaming(struct vb2_queue *q)
> > +{
> > +	struct rockchip_vpu_ctx *ctx = vb2_get_drv_priv(q);
> > +
> > +	if (!V4L2_TYPE_IS_OUTPUT(q->type))
> > +		dma_free_attrs(ctx->dev->dev,
> > +			       ctx->bounce_size,
> > +			       ctx->bounce_buf,
> > +			       ctx->bounce_dma_addr,
> > +			       DMA_ATTR_ALLOC_SINGLE_PAGES);
> > +
> > +	/* The mem2mem framework calls v4l2_m2m_cancel_job before
> > +	 * .stop_streaming, so there isn't any job running and
> > +	 * it is safe to return all the buffers.
> > +	 */
> > +	for (;;) {
> > +		struct vb2_v4l2_buffer *vbuf;
> > +
> > +		if (V4L2_TYPE_IS_OUTPUT(q->type))
> > +			vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> > +		else
> > +			vbuf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
> > +		if (!vbuf)
> > +			break;
> > +		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
> > +	}
> > +}
> > +
> > +const struct vb2_ops rockchip_vpu_enc_queue_ops = {
> > +	.queue_setup = rockchip_vpu_queue_setup,
> > +	.buf_prepare = rockchip_vpu_buf_prepare,
> > +	.buf_queue = rockchip_vpu_buf_queue,
> > +	.start_streaming = rockchip_vpu_start_streaming,
> > +	.stop_streaming = rockchip_vpu_stop_streaming,
> > +	.wait_prepare = vb2_ops_wait_prepare,
> > +	.wait_finish = vb2_ops_wait_finish,
> > +};
> > diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_hw.h b/drivers/staging/media/rockchip/vpu/rockchip_vpu_hw.h
> > new file mode 100644
> > index 000000000000..305362fd9584
> > --- /dev/null
> > +++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_hw.h
> > @@ -0,0 +1,58 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Rockchip VPU codec driver
> > + *
> > + * Copyright (C) 2018 Google, Inc.
> > + *	Tomasz Figa <tfiga@chromium.org>
> > + */
> > +
> > +#ifndef ROCKCHIP_VPU_HW_H_
> > +#define ROCKCHIP_VPU_HW_H_
> > +
> > +#include <linux/interrupt.h>
> > +#include <linux/v4l2-controls.h>
> > +#include <media/videobuf2-core.h>
> > +
> > +struct rockchip_vpu_dev;
> > +struct rockchip_vpu_ctx;
> > +struct rockchip_vpu_buf;
> > +struct rockchip_vpu_variant;
> > +
> > +/**
> > + * struct rockchip_vpu_codec_ops - codec mode specific operations
> > + *
> > + * @run:	Start single {en,de)coding job. Called from atomic context
> > + *		to indicate that a pair of buffers is ready and the hardware
> > + *		should be programmed and started.
> > + * @done:	Read back processing results and additional data from hardware.
> > + * @reset:	Reset the hardware in case of a timeout.
> > + */
> > +struct rockchip_vpu_codec_ops {
> > +	void (*run)(struct rockchip_vpu_ctx *ctx);
> > +	void (*done)(struct rockchip_vpu_ctx *ctx, enum vb2_buffer_state);
> > +	void (*reset)(struct rockchip_vpu_ctx *ctx);
> > +};
> > +
> > +/**
> > + * enum rockchip_vpu_enc_fmt - source format ID for hardware registers.
> > + */
> > +enum rockchip_vpu_enc_fmt {
> > +	RK3288_VPU_ENC_FMT_YUV420P = 0,
> > +	RK3288_VPU_ENC_FMT_YUV420SP = 1,
> > +	RK3288_VPU_ENC_FMT_YUYV422 = 2,
> > +	RK3288_VPU_ENC_FMT_UYVY422 = 3,
> > +};
> > +
> > +extern const struct rockchip_vpu_variant rk3399_vpu_variant;
> > +extern const struct rockchip_vpu_variant rk3288_vpu_variant;
> > +
> > +void rockchip_vpu_watchdog(struct work_struct *work);
> > +void rockchip_vpu_run(struct rockchip_vpu_ctx *ctx);
> > +void rockchip_vpu_irq_done(struct rockchip_vpu_dev *vpu,
> > +			   unsigned int bytesused,
> > +			   enum vb2_buffer_state result);
> > +
> > +void rk3288_vpu_jpeg_enc_run(struct rockchip_vpu_ctx *ctx);
> > +void rk3399_vpu_jpeg_enc_run(struct rockchip_vpu_ctx *ctx);
> > +
> > +#endif /* ROCKCHIP_VPU_HW_H_ */
> > diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.c b/drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.c
> > new file mode 100644
> > index 000000000000..678d53f3c2c2
> > --- /dev/null
> > +++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.c
> > @@ -0,0 +1,289 @@
> > +/*
> > + * Copyright (C) Collabora, Ltd.
> > + *
> > + * Based on GSPCA and CODA drivers:
> > + * Copyright (C) Jean-Francois Moine (http://moinejf.free.fr)
> > + * Copyright (C) 2014 Philipp Zabel, Pengutronix
> > + */
> > +#include <linux/kernel.h>
> > +#include <linux/string.h>
> > +#include "rockchip_vpu_jpeg.h"
> > +
> > +#define LUMA_QUANT_OFF		7
> > +#define CHROMA_QUANT_OFF	72
> > +#define HEIGHT_OFF		141
> > +#define WIDTH_OFF		143
> > +
> > +#define HUFF_LUMA_DC_OFF	160
> > +#define HUFF_LUMA_AC_OFF	193
> > +#define HUFF_CHROMA_DC_OFF	376
> > +#define HUFF_CHROMA_AC_OFF	409
> > +
> > +/* Default tables from JPEG ITU-T.81
> > + * (ISO/IEC 10918-1) Annex K.3, I
> > + */
> > +static const unsigned char luma_q_table[] = {
> > +	0x10, 0x0b, 0x0a, 0x10, 0x7c, 0x8c, 0x97, 0xa1,
> > +	0x0c, 0x0c, 0x0e, 0x13, 0x7e, 0x9e, 0xa0, 0x9b,
> > +	0x0e, 0x0d, 0x10, 0x18, 0x8c, 0x9d, 0xa9, 0x9c,
> > +	0x0e, 0x11, 0x16, 0x1d, 0x97, 0xbb, 0xb4, 0xa2,
> > +	0x12, 0x16, 0x25, 0x38, 0xa8, 0x6d, 0x67, 0xb1,
> > +	0x18, 0x23, 0x37, 0x40, 0xb5, 0x68, 0x71, 0xc0,
> > +	0x31, 0x40, 0x4e, 0x57, 0x67, 0x79, 0x78, 0x65,
> > +	0x48, 0x5c, 0x5f, 0x62, 0x70, 0x64, 0x67, 0xc7,
> > +};
> > +
> > +static const unsigned char chroma_q_table[] = {
> > +	0x11, 0x12, 0x18, 0x2f, 0x63, 0x63, 0x63, 0x63,
> > +	0x12, 0x15, 0x1a, 0x42, 0x63, 0x63, 0x63, 0x63,
> > +	0x18, 0x1a, 0x38, 0x63, 0x63, 0x63, 0x63, 0x63,
> > +	0x2f, 0x42, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63,
> > +	0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63,
> > +	0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63,
> > +	0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63,
> > +	0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63
> > +};
> > +
> > +/* Huffman tables are shared with CODA */
> > +static const unsigned char luma_dc_table[] = {
> > +	0x00, 0x01, 0x05, 0x01, 0x01, 0x01, 0x01, 0x01,
> > +	0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
> > +	0x08, 0x09, 0x0a, 0x0b,
> > +};
> > +
> > +static const unsigned char chroma_dc_table[] = {
> > +	0x00, 0x03, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
> > +	0x01, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
> > +	0x08, 0x09, 0x0a, 0x0b,
> > +};
> > +
> > +static const unsigned char luma_ac_table[] = {
> > +	0x00, 0x02, 0x01, 0x03, 0x03, 0x02, 0x04, 0x03,
> > +	0x05, 0x05, 0x04, 0x04, 0x00, 0x00, 0x01, 0x7d,
> > +	0x01, 0x02, 0x03, 0x00, 0x04, 0x11, 0x05, 0x12,
> > +	0x21, 0x31, 0x41, 0x06, 0x13, 0x51, 0x61, 0x07,
> > +	0x22, 0x71, 0x14, 0x32, 0x81, 0x91, 0xa1, 0x08,
> > +	0x23, 0x42, 0xb1, 0xc1, 0x15, 0x52, 0xd1, 0xf0,
> > +	0x24, 0x33, 0x62, 0x72, 0x82, 0x09, 0x0a, 0x16,
> > +	0x17, 0x18, 0x19, 0x1a, 0x25, 0x26, 0x27, 0x28,
> > +	0x29, 0x2a, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39,
> > +	0x3a, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49,
> > +	0x4a, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59,
> > +	0x5a, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69,
> > +	0x6a, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79,
> > +	0x7a, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89,
> > +	0x8a, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98,
> > +	0x99, 0x9a, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7,
> > +	0xa8, 0xa9, 0xaa, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6,
> > +	0xb7, 0xb8, 0xb9, 0xba, 0xc2, 0xc3, 0xc4, 0xc5,
> > +	0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xd2, 0xd3, 0xd4,
> > +	0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0xda, 0xe1, 0xe2,
> > +	0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9, 0xea,
> > +	0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8,
> > +	0xf9, 0xfa,
> > +};
> > +
> > +static const unsigned char chroma_ac_table[] = {
> > +	0x00, 0x02, 0x01, 0x02, 0x04, 0x04, 0x03, 0x04,
> > +	0x07, 0x05, 0x04, 0x04, 0x00, 0x01, 0x02, 0x77,
> > +	0x00, 0x01, 0x02, 0x03, 0x11, 0x04, 0x05, 0x21,
> > +	0x31, 0x06, 0x12, 0x41, 0x51, 0x07, 0x61, 0x71,
> > +	0x13, 0x22, 0x32, 0x81, 0x08, 0x14, 0x42, 0x91,
> > +	0xa1, 0xb1, 0xc1, 0x09, 0x23, 0x33, 0x52, 0xf0,
> > +	0x15, 0x62, 0x72, 0xd1, 0x0a, 0x16, 0x24, 0x34,
> > +	0xe1, 0x25, 0xf1, 0x17, 0x18, 0x19, 0x1a, 0x26,
> > +	0x27, 0x28, 0x29, 0x2a, 0x35, 0x36, 0x37, 0x38,
> > +	0x39, 0x3a, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48,
> > +	0x49, 0x4a, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58,
> > +	0x59, 0x5a, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68,
> > +	0x69, 0x6a, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78,
> > +	0x79, 0x7a, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> > +	0x88, 0x89, 0x8a, 0x92, 0x93, 0x94, 0x95, 0x96,
> > +	0x97, 0x98, 0x99, 0x9a, 0xa2, 0xa3, 0xa4, 0xa5,
> > +	0xa6, 0xa7, 0xa8, 0xa9, 0xaa, 0xb2, 0xb3, 0xb4,
> > +	0xb5, 0xb6, 0xb7, 0xb8, 0xb9, 0xba, 0xc2, 0xc3,
> > +	0xc4, 0xc5, 0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xd2,
> > +	0xd3, 0xd4, 0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0xda,
> > +	0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9,
> > +	0xea, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8,
> > +	0xf9, 0xfa,
> > +};
> > +
> > +/* For simplicity, we keep a pre-formatted JPEG header,
> > + * and we'll use fixed offsets to change the width, height
> > + * quantization tables, etc.
> > + */
> > +static const unsigned char rockchip_vpu_jpeg_header[JPEG_HEADER_SIZE] = {
> > +	/* SOI */
> > +	0xff, 0xd8,
> > +
> > +	/* DQT */
> > +	0xff, 0xdb, 0x00, 0x84,
> > +
> > +	0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +
> > +	0x01,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +
> > +	/* SOF */
> > +	0xff, 0xc0, 0x00, 0x11, 0x08, 0x00, 0xf0, 0x01,
> > +	0x40, 0x03, 0x01, 0x22, 0x00, 0x02, 0x11, 0x01,
> > +	0x03, 0x11, 0x01,
> > +
> > +	/* DHT */
> > +	0xff, 0xc4, 0x00, 0x1f, 0x00,
> > +
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00,
> > +
> > +	/* DHT */
> > +	0xff, 0xc4, 0x00, 0xb5, 0x10,
> > +
> > +	0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +
> > +	/* DHT */
> > +	0xff, 0xc4, 0x00, 0x1f, 0x01,
> > +
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00,
> > +
> > +	/* DHT */
> > +	0xff, 0xc4, 0x00, 0xb5, 0x11,
> > +
> > +	0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +
> > +	/* SOS */
> > +	0xff, 0xda, 0x00, 0x0c, 0x03, 0x01, 0x00, 0x02,
> > +	0x11, 0x03, 0x11, 0x00, 0x3f, 0x00,
> > +};
> > +
> > +static void
> > +jpeg_scale_quant_table(unsigned char *q_tab,
> > +		       const unsigned char *tab, int scale)
> > +{
> > +	unsigned int temp;
> > +	int i;
> > +
> > +	for (i = 0; i < 64; i++) {
> > +		temp = DIV_ROUND_CLOSEST((unsigned int)tab[i] * scale, 100);
> > +		if (temp <= 0)
> > +			temp = 1;
> > +		if (temp > 255)
> > +			temp = 255;
> > +		q_tab[i] = (unsigned char)temp;
> > +	}
> > +}
> > +
> > +static void jpeg_set_quality(unsigned char *buffer, int quality)
> > +{
> > +	int scale;
> > +
> > +	/*
> > +	 * Non-linear scaling factor:
> > +	 * [5,50] -> [1000..100], [51,100] -> [98..0]
> > +	 */
> > +	if (quality < 50)
> > +		scale = 5000 / quality;
> > +	else
> > +		scale = 200 - 2 * quality;
> > +
> > +	jpeg_scale_quant_table(buffer + LUMA_QUANT_OFF,
> > +			       luma_q_table, scale);
> > +	jpeg_scale_quant_table(buffer + CHROMA_QUANT_OFF,
> > +			       chroma_q_table, scale);
> > +}
> > +
> > +unsigned char *
> > +rockchip_vpu_jpeg_get_qtable(struct rockchip_vpu_jpeg_ctx *ctx, int index)
> > +{
> > +	if (index == 0)
> > +		return ctx->buffer + LUMA_QUANT_OFF;
> > +	return ctx->buffer + CHROMA_QUANT_OFF;
> > +}
> > +
> > +void rockchip_vpu_jpeg_render(struct rockchip_vpu_jpeg_ctx *ctx)
> > +{
> > +	char *buf = ctx->buffer;
> > +
> > +	memcpy(buf, rockchip_vpu_jpeg_header,
> > +	       sizeof(rockchip_vpu_jpeg_header));
> > +
> > +	buf[HEIGHT_OFF + 0] = ctx->height >> 8;
> > +	buf[HEIGHT_OFF + 1] = ctx->height;
> > +	buf[WIDTH_OFF + 0] = ctx->width >> 8;
> > +	buf[WIDTH_OFF + 1] = ctx->width;
> > +
> > +	memcpy(buf + HUFF_LUMA_DC_OFF, luma_dc_table, sizeof(luma_dc_table));
> > +	memcpy(buf + HUFF_LUMA_AC_OFF, luma_ac_table, sizeof(luma_ac_table));
> > +	memcpy(buf + HUFF_CHROMA_DC_OFF, chroma_dc_table,
> > +	       sizeof(chroma_dc_table));
> > +	memcpy(buf + HUFF_CHROMA_AC_OFF, chroma_ac_table,
> > +	       sizeof(chroma_ac_table));
> > +
> > +	jpeg_set_quality(buf, ctx->quality);
> > +}
> > diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.h b/drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.h
> > new file mode 100644
> > index 000000000000..a616d85359e8
> > --- /dev/null
> > +++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.h
> > @@ -0,0 +1,12 @@
> > +#define JPEG_HEADER_SIZE	601
> > +
> > +struct rockchip_vpu_jpeg_ctx {
> > +	int width;
> > +	int height;
> > +	int quality;
> > +	unsigned char *buffer;
> > +};
> > +
> > +unsigned char *
> > +rockchip_vpu_jpeg_get_qtable(struct rockchip_vpu_jpeg_ctx *ctx, int index);
> > +void rockchip_vpu_jpeg_render(struct rockchip_vpu_jpeg_ctx *ctx);
> > 
> 
> Regards,
> 
> 	Hans

Thanks for the quick review!
