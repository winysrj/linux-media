Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:63914 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab2GZEVQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 00:21:16 -0400
Received: by vcbfk26 with SMTP id fk26so1293809vcb.19
        for <linux-media@vger.kernel.org>; Wed, 25 Jul 2012 21:21:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <501062F6.3070408@gmail.com>
References: <1343219191-3969-1-git-send-email-shaik.ameer@samsung.com>
	<1343219191-3969-3-git-send-email-shaik.ameer@samsung.com>
	<501062F6.3070408@gmail.com>
Date: Thu, 26 Jul 2012 09:51:15 +0530
Message-ID: <CAOD6ATpra8uL3HQ7xyYZQp=0zhAymWyaZ+xOQtpXRmDi+m0sCg@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] media: gscaler: Add new driver for generic scaler
From: Shaik Ameer Basha <shaik.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	linux-media@vger.kernel.org, sungchun.kang@samsung.com,
	khw0178.kim@samsung.com, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com, sy0816.kang@samsung.com,
	s.nawrocki@samsung.com, posciak@google.com, alim.akhtar@gmail.com,
	prashanth.g@samsung.com, joshi@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for your super fast review :)

On Thu, Jul 26, 2012 at 2:49 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> On 07/25/2012 02:26 PM, Shaik Ameer Basha wrote:
>>
>> From: Sungchun Kang<sungchun.kang@samsung.com>
>>
>> This patch adds support for G-Scaler (Generic Scaler) device which is a
>> new device for scaling and color space conversion on EXYNOS5 SoCs. This
>> patch adds the code for register definitions and register operations.
>>
>> This device supports the followings as key feature.
>>   1) Input image format
>>     - RGB888/565, YUV422 1P/2P, YUV420 2P/3P, TILE
>>   2) Output image format
>>     - RGB888/565, YUV422 1P/2P, YUV420 2P/3P, YUV444
>>   3) Input rotation
>>     - 0/90/180/270 degree, X/Y Flip
>>   4) Scale ratio
>>     - 1/16 scale down to 8 scale up
>>   5) CSC
>>     - RGB to YUV / YUV to RGB
>>   6) Size
>>     - 2048 x 2048 for tile or rotation
>>     - 4800 x 3344 other case
>>
>> Signed-off-by: Hynwoong Kim<khw0178.kim@samsung.com>
>> Signed-off-by: Sungchun Kang<sungchun.kang@samsung.com>
>> Signed-off-by: Shaik Ameer Basha<shaik.ameer@samsung.com>
>> ---
>>   drivers/media/video/exynos-gsc/gsc-regs.c |  450
>> +++++++++++++++++++++++++++++
>>   drivers/media/video/exynos-gsc/gsc-regs.h |  172 +++++++++++
>>   2 files changed, 622 insertions(+), 0 deletions(-)
>>   create mode 100644 drivers/media/video/exynos-gsc/gsc-regs.c
>>   create mode 100644 drivers/media/video/exynos-gsc/gsc-regs.h
>>
>> diff --git a/drivers/media/video/exynos-gsc/gsc-regs.c
>> b/drivers/media/video/exynos-gsc/gsc-regs.c
>> new file mode 100644
>> index 0000000..0adb5ea
>> --- /dev/null
>> +++ b/drivers/media/video/exynos-gsc/gsc-regs.c
>> @@ -0,0 +1,450 @@
>> +/*
>> + * Copyright (c) 2011 - 2012 Samsung Electronics Co., Ltd.
>> + *             http://www.samsung.com
>> + *
>> + * Samsung EXYNOS5 SoC series G-Scaler driver
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published
>> + * by the Free Software Foundation, either version 2 of the License,
>> + * or (at your option) any later version.
>> + */
>> +
>> +#include<linux/io.h>
>> +#include<linux/delay.h>
>> +#include<mach/map.h>
>> +
>> +#include "gsc-core.h"
>> +
>> +void gsc_hw_set_sw_reset(struct gsc_dev *dev)
>> +{
>> +       u32 cfg = 0;
>> +
>> +       cfg |= GSC_SW_RESET_SRESET;
>> +       writel(cfg, dev->regs + GSC_SW_RESET);
>
>
> Just do:
>
>         writel(GSC_SW_RESET_SRESET, dev->regs + GSC_SW_RESET);
>

Ok. I will do that.

>
>> +}
>> +
>> +int gsc_wait_reset(struct gsc_dev *dev)
>> +{
>> +       unsigned long timeo = jiffies + 10; /* timeout of 50ms */
>
>
> I commented on this already. Please fix this misleading comment.
>

Sorry. Somehow I missed to address these comments.
Next time i will cross check before posting.

Ok. I will also fix the other review comments pointed out in this mail...

>
>> +       u32 cfg;
>> +
>> +       while (time_before(jiffies, timeo)) {
>> +               cfg = readl(dev->regs + GSC_SW_RESET);
>> +               if (!cfg)
>> +                       return 0;
>> +               usleep_range(10, 20);
>> +       }
>> +
>> +       return -EBUSY;
>> +}
>> +
>> +int gsc_wait_operating(struct gsc_dev *dev)
>> +{
>> +       unsigned long timeo = jiffies + 10; /* timeout of 50ms */
>
>
> Ditto.
>
>> +       u32 cfg;
>> +
>> +       while (time_before(jiffies, timeo)) {
>> +               cfg = readl(dev->regs + GSC_ENABLE);
>> +               if ((cfg&  GSC_ENABLE_OP_STATUS) == GSC_ENABLE_OP_STATUS)
>>
>> +                       return 0;
>> +               usleep_range(10, 20);
>> +       }
>> +       pr_debug("wait time : %d ms", jiffies_to_msecs(jiffies - timeo +
>> 20));
>
>
> It's also misleading.
>
>> +
>> +       return -EBUSY;
>> +}
>> +
>> +void gsc_hw_set_frm_done_irq_mask(struct gsc_dev *dev, bool mask)
>> +{
>> +       u32 cfg;
>> +
>> +       cfg = readl(dev->regs + GSC_IRQ);
>> +       if (mask)
>> +               cfg |= GSC_IRQ_FRMDONE_MASK;
>> +       else
>> +               cfg&= ~GSC_IRQ_FRMDONE_MASK;
>>
>> +       writel(cfg, dev->regs + GSC_IRQ);
>> +}
>> +
>> +void gsc_hw_set_gsc_irq_enable(struct gsc_dev *dev, bool mask)
>> +{
>> +       u32 cfg;
>> +
>> +       cfg = readl(dev->regs + GSC_IRQ);
>> +       if (mask)
>> +               cfg |= GSC_IRQ_ENABLE;
>> +       else
>> +               cfg&= ~GSC_IRQ_ENABLE;
>>
>> +       writel(cfg, dev->regs + GSC_IRQ);
>> +}
>> +
>> +void gsc_hw_set_input_buf_masking(struct gsc_dev *dev, u32 shift,
>> +                               bool enable)
>> +{
>> +       u32 cfg = readl(dev->regs + GSC_IN_BASE_ADDR_Y_MASK);
>> +       u32 mask = 1<<  shift;
>> +
>> +       cfg&= (~mask);
>
>
> Superfluous braces. It also has been pointed out...
>
>
>> +       cfg |= enable<<  shift;
>> +
>> +       writel(cfg, dev->regs + GSC_IN_BASE_ADDR_Y_MASK);
>> +       writel(cfg, dev->regs + GSC_IN_BASE_ADDR_CB_MASK);
>> +       writel(cfg, dev->regs + GSC_IN_BASE_ADDR_CR_MASK);
>> +}
>> +
>> +void gsc_hw_set_output_buf_masking(struct gsc_dev *dev, u32 shift,
>> +                               bool enable)
>> +{
>> +       u32 cfg = readl(dev->regs + GSC_OUT_BASE_ADDR_Y_MASK);
>> +       u32 mask = 1<<  shift;
>> +
>> +       cfg&= (~mask);
>
>
> ditto
>
>> +       cfg |= enable<<  shift;
>> +
>> +       writel(cfg, dev->regs + GSC_OUT_BASE_ADDR_Y_MASK);
>> +       writel(cfg, dev->regs + GSC_OUT_BASE_ADDR_CB_MASK);
>> +       writel(cfg, dev->regs + GSC_OUT_BASE_ADDR_CR_MASK);
>> +}
>> +
>> +void gsc_hw_set_input_addr(struct gsc_dev *dev, struct gsc_addr *addr,
>> +                               int index)
>> +{
>> +       pr_debug("src_buf[%d]: 0x%X, cb: 0x%X, cr: 0x%X", index,
>> +                       addr->y, addr->cb, addr->cr);
>> +       writel(addr->y, dev->regs + GSC_IN_BASE_ADDR_Y(index));
>> +       writel(addr->cb, dev->regs + GSC_IN_BASE_ADDR_CB(index));
>> +       writel(addr->cr, dev->regs + GSC_IN_BASE_ADDR_CR(index));
>> +
>> +}
>> +
>> +void gsc_hw_set_output_addr(struct gsc_dev *dev,
>> +                            struct gsc_addr *addr, int index)
>> +{
>> +       pr_debug("dst_buf[%d]: 0x%X, cb: 0x%X, cr: 0x%X",
>> +                       index, addr->y, addr->cb, addr->cr);
>> +       writel(addr->y, dev->regs + GSC_OUT_BASE_ADDR_Y(index));
>> +       writel(addr->cb, dev->regs + GSC_OUT_BASE_ADDR_CB(index));
>> +       writel(addr->cr, dev->regs + GSC_OUT_BASE_ADDR_CR(index));
>> +}
>> +
>> +void gsc_hw_set_input_path(struct gsc_ctx *ctx)
>> +{
>> +       struct gsc_dev *dev = ctx->gsc_dev;
>> +
>> +       u32 cfg = readl(dev->regs + GSC_IN_CON);
>> +       cfg&= ~(GSC_IN_PATH_MASK | GSC_IN_LOCAL_SEL_MASK);
>>
>> +
>> +       if (ctx->in_path == GSC_DMA)
>> +               cfg |= GSC_IN_PATH_MEMORY;
>> +
>> +       writel(cfg, dev->regs + GSC_IN_CON);
>> +}
>> +
>> +void gsc_hw_set_in_size(struct gsc_ctx *ctx)
>> +{
>> +       struct gsc_dev *dev = ctx->gsc_dev;
>> +       struct gsc_frame *frame =&ctx->s_frame;
>>
>> +       u32 cfg;
>> +
>> +       /* Set input pixel offset */
>> +       cfg = GSC_SRCIMG_OFFSET_X(frame->crop.left);
>> +       cfg |= GSC_SRCIMG_OFFSET_Y(frame->crop.top);
>> +       writel(cfg, dev->regs + GSC_SRCIMG_OFFSET);
>> +
>> +       /* Set input original size */
>> +       cfg = GSC_SRCIMG_WIDTH(frame->f_width);
>> +       cfg |= GSC_SRCIMG_HEIGHT(frame->f_height);
>> +       writel(cfg, dev->regs + GSC_SRCIMG_SIZE);
>> +
>> +       /* Set input cropped size */
>> +       cfg = GSC_CROPPED_WIDTH(frame->crop.width);
>> +       cfg |= GSC_CROPPED_HEIGHT(frame->crop.height);
>> +       writel(cfg, dev->regs + GSC_CROPPED_SIZE);
>> +}
>> +
>> +void gsc_hw_set_in_image_rgb(struct gsc_ctx *ctx)
>> +{
>> +       struct gsc_dev *dev = ctx->gsc_dev;
>> +       struct gsc_frame *frame =&ctx->s_frame;
>>
>> +       u32 cfg;
>> +
>> +       cfg = readl(dev->regs + GSC_IN_CON);
>> +       if (frame->colorspace == V4L2_COLORSPACE_REC709)
>> +               cfg |= GSC_IN_RGB_HD_WIDE;
>> +       else
>> +               cfg |= GSC_IN_RGB_SD_WIDE;
>> +
>> +       if (frame->fmt->pixelformat == V4L2_PIX_FMT_RGB565X)
>> +               cfg |= GSC_IN_RGB565;
>> +       else if (frame->fmt->pixelformat == V4L2_PIX_FMT_RGB32)
>> +               cfg |= GSC_IN_XRGB8888;
>> +
>> +       writel(cfg, dev->regs + GSC_IN_CON);
>> +}
>> +
>> +void gsc_hw_set_in_image_format(struct gsc_ctx *ctx)
>> +{
>> +       struct gsc_dev *dev = ctx->gsc_dev;
>> +       struct gsc_frame *frame =&ctx->s_frame;
>>
>> +       u32 i, depth = 0;
>> +       u32 cfg;
>> +
>> +       cfg = readl(dev->regs + GSC_IN_CON);
>> +       cfg&= ~(GSC_IN_RGB_TYPE_MASK | GSC_IN_YUV422_1P_ORDER_MASK |
>>
>> +                GSC_IN_CHROMA_ORDER_MASK | GSC_IN_FORMAT_MASK |
>> +                GSC_IN_TILE_TYPE_MASK | GSC_IN_TILE_MODE);
>> +       writel(cfg, dev->regs + GSC_IN_CON);
>> +
>> +       if (is_rgb(frame->fmt->color)) {
>> +               gsc_hw_set_in_image_rgb(ctx);
>> +               return;
>> +       }
>> +       for (i = 0; i<  frame->fmt->num_planes; i++)
>> +               depth += frame->fmt->depth[i];
>> +
>> +       switch (frame->fmt->num_comp) {
>> +       case 1:
>> +               cfg |= GSC_IN_YUV422_1P;
>> +               if (frame->fmt->yorder == GSC_LSB_Y)
>> +                       cfg |= GSC_IN_YUV422_1P_ORDER_LSB_Y;
>> +               else
>> +                       cfg |= GSC_IN_YUV422_1P_OEDER_LSB_C;
>> +               if (frame->fmt->corder == GSC_CBCR)
>> +                       cfg |= GSC_IN_CHROMA_ORDER_CBCR;
>> +               else
>> +                       cfg |= GSC_IN_CHROMA_ORDER_CRCB;
>> +               break;
>> +       case 2:
>> +               if (depth == 12)
>> +                       cfg |= GSC_IN_YUV420_2P;
>> +               else
>> +                       cfg |= GSC_IN_YUV422_2P;
>> +               if (frame->fmt->corder == GSC_CBCR)
>> +                       cfg |= GSC_IN_CHROMA_ORDER_CBCR;
>> +               else
>> +                       cfg |= GSC_IN_CHROMA_ORDER_CRCB;
>> +               break;
>> +       case 3:
>> +               if (depth == 12)
>> +                       cfg |= GSC_IN_YUV420_3P;
>> +               else
>> +                       cfg |= GSC_IN_YUV422_3P;
>> +               break;
>> +       };
>> +
>> +       if (is_tiled(frame->fmt))
>> +               cfg |= GSC_IN_TILE_C_16x8 | GSC_IN_TILE_MODE;
>> +
>> +       writel(cfg, dev->regs + GSC_IN_CON);
>> +}
>> +
>> +void gsc_hw_set_output_path(struct gsc_ctx *ctx)
>> +{
>> +       struct gsc_dev *dev = ctx->gsc_dev;
>> +
>> +       u32 cfg = readl(dev->regs + GSC_OUT_CON);
>> +       cfg&= ~GSC_OUT_PATH_MASK;
>>
>> +
>> +       if (ctx->out_path == GSC_DMA)
>> +               cfg |= GSC_OUT_PATH_MEMORY;
>> +       else
>> +               cfg |= GSC_OUT_PATH_LOCAL;
>> +
>> +       writel(cfg, dev->regs + GSC_OUT_CON);
>> +}
>> +
>> +void gsc_hw_set_out_size(struct gsc_ctx *ctx)
>> +{
>> +       struct gsc_dev *dev = ctx->gsc_dev;
>> +       struct gsc_frame *frame =&ctx->d_frame;
>>
>> +       u32 cfg;
>> +
>> +       /* Set output original size */
>> +       if (ctx->out_path == GSC_DMA) {
>> +               cfg = GSC_DSTIMG_OFFSET_X(frame->crop.left);
>> +               cfg |= GSC_DSTIMG_OFFSET_Y(frame->crop.top);
>> +               writel(cfg, dev->regs + GSC_DSTIMG_OFFSET);
>> +
>> +               cfg = GSC_DSTIMG_WIDTH(frame->f_width);
>> +               cfg |= GSC_DSTIMG_HEIGHT(frame->f_height);
>> +               writel(cfg, dev->regs + GSC_DSTIMG_SIZE);
>> +       }
>> +
>> +       /* Set output scaled size */
>> +       if (ctx->gsc_ctrls.rotate->val == 90 ||
>> +           ctx->gsc_ctrls.rotate->val == 270) {
>> +               cfg = GSC_SCALED_WIDTH(frame->crop.height);
>> +               cfg |= GSC_SCALED_HEIGHT(frame->crop.width);
>> +       } else {
>> +               cfg = GSC_SCALED_WIDTH(frame->crop.width);
>> +               cfg |= GSC_SCALED_HEIGHT(frame->crop.height);
>> +       }
>> +       writel(cfg, dev->regs + GSC_SCALED_SIZE);
>> +}
>> +
>> +void gsc_hw_set_out_image_rgb(struct gsc_ctx *ctx)
>> +{
>> +       struct gsc_dev *dev = ctx->gsc_dev;
>> +       struct gsc_frame *frame =&ctx->d_frame;
>>
>> +       u32 cfg;
>> +
>> +       cfg = readl(dev->regs + GSC_OUT_CON);
>> +       if (frame->colorspace == V4L2_COLORSPACE_REC709)
>> +               cfg |= GSC_OUT_RGB_HD_WIDE;
>> +       else
>> +               cfg |= GSC_OUT_RGB_SD_WIDE;
>> +
>> +       if (frame->fmt->pixelformat == V4L2_PIX_FMT_RGB565X)
>> +               cfg |= GSC_OUT_RGB565;
>> +       else if (frame->fmt->pixelformat == V4L2_PIX_FMT_RGB32)
>> +               cfg |= GSC_OUT_XRGB8888;
>> +
>> +       writel(cfg, dev->regs + GSC_OUT_CON);
>> +}
>> +
>> +void gsc_hw_set_out_image_format(struct gsc_ctx *ctx)
>> +{
>> +       struct gsc_dev *dev = ctx->gsc_dev;
>> +       struct gsc_frame *frame =&ctx->d_frame;
>>
>> +       u32 i, depth = 0;
>> +       u32 cfg;
>> +
>> +       cfg = readl(dev->regs + GSC_OUT_CON);
>> +       cfg&= ~(GSC_OUT_RGB_TYPE_MASK | GSC_OUT_YUV422_1P_ORDER_MASK |
>>
>> +                GSC_OUT_CHROMA_ORDER_MASK | GSC_OUT_FORMAT_MASK |
>> +                GSC_OUT_TILE_TYPE_MASK | GSC_OUT_TILE_MODE);
>> +       writel(cfg, dev->regs + GSC_OUT_CON);
>> +
>> +       if (is_rgb(frame->fmt->color)) {
>> +               gsc_hw_set_out_image_rgb(ctx);
>> +               return;
>> +       }
>> +
>> +       if (ctx->out_path != GSC_DMA) {
>> +               cfg |= GSC_OUT_YUV444;
>> +               goto end_set;
>> +       }
>> +
>> +       for (i = 0; i<  frame->fmt->num_planes; i++)
>> +               depth += frame->fmt->depth[i];
>> +
>> +       switch (frame->fmt->num_comp) {
>> +       case 1:
>> +               cfg |= GSC_OUT_YUV422_1P;
>> +               if (frame->fmt->yorder == GSC_LSB_Y)
>> +                       cfg |= GSC_OUT_YUV422_1P_ORDER_LSB_Y;
>> +               else
>> +                       cfg |= GSC_OUT_YUV422_1P_OEDER_LSB_C;
>> +               if (frame->fmt->corder == GSC_CBCR)
>> +                       cfg |= GSC_OUT_CHROMA_ORDER_CBCR;
>> +               else
>> +                       cfg |= GSC_OUT_CHROMA_ORDER_CRCB;
>> +               break;
>> +       case 2:
>> +               if (depth == 12)
>> +                       cfg |= GSC_OUT_YUV420_2P;
>> +               else
>> +                       cfg |= GSC_OUT_YUV422_2P;
>> +               if (frame->fmt->corder == GSC_CBCR)
>> +                       cfg |= GSC_OUT_CHROMA_ORDER_CBCR;
>> +               else
>> +                       cfg |= GSC_OUT_CHROMA_ORDER_CRCB;
>> +               break;
>> +       case 3:
>> +               cfg |= GSC_OUT_YUV420_3P;
>> +               break;
>> +       };
>> +
>> +       if (is_tiled(frame->fmt))
>> +               cfg |= GSC_OUT_TILE_C_16x8 | GSC_OUT_TILE_MODE;
>> +
>> +end_set:
>> +       writel(cfg, dev->regs + GSC_OUT_CON);
>> +}
>> +
>> +void gsc_hw_set_prescaler(struct gsc_ctx *ctx)
>> +{
>> +       struct gsc_dev *dev = ctx->gsc_dev;
>> +       struct gsc_scaler *sc =&ctx->scaler;
>>
>> +       u32 cfg;
>> +
>> +       cfg = GSC_PRESC_SHFACTOR(sc->pre_shfactor);
>> +       cfg |= GSC_PRESC_H_RATIO(sc->pre_hratio);
>> +       cfg |= GSC_PRESC_V_RATIO(sc->pre_vratio);
>> +       writel(cfg, dev->regs + GSC_PRE_SCALE_RATIO);
>> +}
>> +
>> +void gsc_hw_set_mainscaler(struct gsc_ctx *ctx)
>> +{
>> +       struct gsc_dev *dev = ctx->gsc_dev;
>> +       struct gsc_scaler *sc =&ctx->scaler;
>>
>> +       u32 cfg;
>> +
>> +       cfg = GSC_MAIN_H_RATIO_VALUE(sc->main_hratio);
>> +       writel(cfg, dev->regs + GSC_MAIN_H_RATIO);
>> +
>> +       cfg = GSC_MAIN_V_RATIO_VALUE(sc->main_vratio);
>> +       writel(cfg, dev->regs + GSC_MAIN_V_RATIO);
>> +}
>> +
>> +void gsc_hw_set_rotation(struct gsc_ctx *ctx)
>> +{
>> +       struct gsc_dev *dev = ctx->gsc_dev;
>> +       u32 cfg;
>> +
>> +       cfg = readl(dev->regs + GSC_IN_CON);
>> +       cfg&= ~GSC_IN_ROT_MASK;
>>
>> +
>> +       switch (ctx->gsc_ctrls.rotate->val) {
>> +       case 270:
>> +               cfg |= GSC_IN_ROT_270;
>> +               break;
>> +       case 180:
>> +               cfg |= GSC_IN_ROT_180;
>> +               break;
>> +       case 90:
>> +               if (ctx->gsc_ctrls.hflip->val)
>> +                       cfg |= GSC_IN_ROT_90_XFLIP;
>> +               else if (ctx->gsc_ctrls.vflip->val)
>> +                       cfg |= GSC_IN_ROT_90_YFLIP;
>> +               else
>> +                       cfg |= GSC_IN_ROT_90;
>> +               break;
>> +       case 0:
>> +               if (ctx->gsc_ctrls.hflip->val)
>> +                       cfg |= GSC_IN_ROT_XFLIP;
>> +               else if (ctx->gsc_ctrls.vflip->val)
>> +                       cfg |= GSC_IN_ROT_YFLIP;
>> +       }
>> +
>> +       writel(cfg, dev->regs + GSC_IN_CON);
>> +}
>> +
>> +void gsc_hw_set_global_alpha(struct gsc_ctx *ctx)
>> +{
>> +       struct gsc_dev *dev = ctx->gsc_dev;
>> +       struct gsc_frame *frame =&ctx->d_frame;
>>
>> +       u32 cfg;
>> +
>> +       if (!is_rgb(frame->fmt->color)) {
>> +               pr_debug("Not a RGB format");
>> +               return;
>> +       }
>> +
>> +       cfg = readl(dev->regs + GSC_OUT_CON);
>> +       cfg&= ~GSC_OUT_GLOBAL_ALPHA_MASK;
>>
>> +
>> +       cfg |= GSC_OUT_GLOBAL_ALPHA(ctx->gsc_ctrls.global_alpha->val);
>> +       writel(cfg, dev->regs + GSC_OUT_CON);
>> +}
>> +
>> +void gsc_hw_set_sfr_update(struct gsc_ctx *ctx)
>> +{
>> +       struct gsc_dev *dev = ctx->gsc_dev;
>> +       u32 cfg;
>> +
>> +       cfg = readl(dev->regs + GSC_ENABLE);
>> +       cfg |= GSC_ENABLE_SFR_UPDATE;
>> +       writel(cfg, dev->regs + GSC_ENABLE);
>> +}
>> diff --git a/drivers/media/video/exynos-gsc/gsc-regs.h
>> b/drivers/media/video/exynos-gsc/gsc-regs.h
>> new file mode 100644
>> index 0000000..533e994
>> --- /dev/null
>> +++ b/drivers/media/video/exynos-gsc/gsc-regs.h
>> @@ -0,0 +1,172 @@
>> +/*
>> + * Copyright (c) 2011 - 2012 Samsung Electronics Co., Ltd.
>> + *             http://www.samsung.com
>> + *
>> + * Register definition file for Samsung G-Scaler driver
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#ifndef REGS_GSC_H_
>> +#define REGS_GSC_H_
>> +
>> +/* G-Scaler enable */
>> +#define GSC_ENABLE                     0x00
>> +#define GSC_ENABLE_OP_STATUS           (1<<  2)
>> +#define GSC_ENABLE_SFR_UPDATE          (1<<  1)
>> +#define GSC_ENABLE_ON                  (1<<  0)
>> +
>> +/* G-Scaler S/W reset */
>> +#define GSC_SW_RESET                   0x04
>> +#define GSC_SW_RESET_SRESET            (1<<  0)
>> +
>> +/* G-Scaler IRQ */
>> +#define GSC_IRQ                                0x08
>> +#define GSC_IRQ_STATUS_OR_IRQ          (1<<  17)
>> +#define GSC_IRQ_STATUS_FRM_DONE_IRQ    (1<<  16)
>> +#define GSC_IRQ_FRMDONE_MASK           (1<<  1)
>> +#define GSC_IRQ_ENABLE                 (1<<  0)
>> +
>> +/* G-Scaler input control */
>> +#define GSC_IN_CON                     0x10
>> +#define GSC_IN_ROT_MASK                        (7<<  16)
>> +#define GSC_IN_ROT_270                 (7<<  16)
>> +#define GSC_IN_ROT_90_YFLIP            (6<<  16)
>> +#define GSC_IN_ROT_90_XFLIP            (5<<  16)
>> +#define GSC_IN_ROT_90                  (4<<  16)
>> +#define GSC_IN_ROT_180                 (3<<  16)
>> +#define GSC_IN_ROT_YFLIP               (2<<  16)
>> +#define GSC_IN_ROT_XFLIP               (1<<  16)
>> +#define GSC_IN_RGB_TYPE_MASK           (3<<  14)
>> +#define GSC_IN_RGB_HD_WIDE             (3<<  14)
>> +#define GSC_IN_RGB_HD_NARROW           (2<<  14)
>> +#define GSC_IN_RGB_SD_WIDE             (1<<  14)
>> +#define GSC_IN_RGB_SD_NARROW           (0<<  14)
>> +#define GSC_IN_YUV422_1P_ORDER_MASK    (1<<  13)
>> +#define GSC_IN_YUV422_1P_ORDER_LSB_Y   (0<<  13)
>> +#define GSC_IN_YUV422_1P_OEDER_LSB_C   (1<<  13)
>> +#define GSC_IN_CHROMA_ORDER_MASK       (1<<  12)
>> +#define GSC_IN_CHROMA_ORDER_CBCR       (0<<  12)
>> +#define GSC_IN_CHROMA_ORDER_CRCB       (1<<  12)
>> +#define GSC_IN_FORMAT_MASK             (7<<  8)
>> +#define GSC_IN_XRGB8888                        (0<<  8)
>> +#define GSC_IN_RGB565                  (1<<  8)
>> +#define GSC_IN_YUV420_2P               (2<<  8)
>> +#define GSC_IN_YUV420_3P               (3<<  8)
>> +#define GSC_IN_YUV422_1P               (4<<  8)
>> +#define GSC_IN_YUV422_2P               (5<<  8)
>> +#define GSC_IN_YUV422_3P               (6<<  8)
>> +#define GSC_IN_TILE_TYPE_MASK          (1<<  4)
>> +#define GSC_IN_TILE_C_16x8             (0<<  4)
>> +#define GSC_IN_TILE_MODE               (1<<  3)
>> +#define GSC_IN_LOCAL_SEL_MASK          (3<<  1)
>> +#define GSC_IN_PATH_MASK               (1<<  0)
>> +#define GSC_IN_PATH_MEMORY             (0<<  0)
>> +
>> +/* G-Scaler source image size */
>> +#define GSC_SRCIMG_SIZE                        0x14
>> +#define GSC_SRCIMG_HEIGHT(x)           ((x)<<  16)
>> +#define GSC_SRCIMG_WIDTH(x)            ((x)<<  0)
>> +
>> +/* G-Scaler source image offset */
>> +#define GSC_SRCIMG_OFFSET              0x18
>> +#define GSC_SRCIMG_OFFSET_Y(x)         ((x)<<  16)
>> +#define GSC_SRCIMG_OFFSET_X(x)         ((x)<<  0)
>> +
>> +/* G-Scaler cropped source image size */
>> +#define GSC_CROPPED_SIZE               0x1c
>> +#define GSC_CROPPED_HEIGHT(x)          ((x)<<  16)
>> +#define GSC_CROPPED_WIDTH(x)           ((x)<<  0)
>> +
>> +/* G-Scaler output control */
>> +#define GSC_OUT_CON                    0x20
>> +#define GSC_OUT_GLOBAL_ALPHA_MASK      (0xff<<  24)
>> +#define GSC_OUT_GLOBAL_ALPHA(x)                ((x)<<  24)
>> +#define GSC_OUT_RGB_TYPE_MASK          (3<<  10)
>> +#define GSC_OUT_RGB_HD_NARROW          (3<<  10)
>> +#define GSC_OUT_RGB_HD_WIDE            (2<<  10)
>> +#define GSC_OUT_RGB_SD_NARROW          (1<<  10)
>> +#define GSC_OUT_RGB_SD_WIDE            (0<<  10)
>> +#define GSC_OUT_YUV422_1P_ORDER_MASK   (1<<  9)
>> +#define GSC_OUT_YUV422_1P_ORDER_LSB_Y  (0<<  9)
>> +#define GSC_OUT_YUV422_1P_OEDER_LSB_C  (1<<  9)
>> +#define GSC_OUT_CHROMA_ORDER_MASK      (1<<  8)
>> +#define GSC_OUT_CHROMA_ORDER_CBCR      (0<<  8)
>> +#define GSC_OUT_CHROMA_ORDER_CRCB      (1<<  8)
>> +#define GSC_OUT_FORMAT_MASK            (7<<  4)
>> +#define GSC_OUT_XRGB8888               (0<<  4)
>> +#define GSC_OUT_RGB565                 (1<<  4)
>> +#define GSC_OUT_YUV420_2P              (2<<  4)
>> +#define GSC_OUT_YUV420_3P              (3<<  4)
>> +#define GSC_OUT_YUV422_1P              (4<<  4)
>> +#define GSC_OUT_YUV422_2P              (5<<  4)
>> +#define GSC_OUT_YUV444                 (7<<  4)
>> +#define GSC_OUT_TILE_TYPE_MASK         (1<<  2)
>> +#define GSC_OUT_TILE_C_16x8            (0<<  2)
>> +#define GSC_OUT_TILE_MODE              (1<<  1)
>> +#define GSC_OUT_PATH_MASK              (1<<  0)
>> +#define GSC_OUT_PATH_LOCAL             (1<<  0)
>> +#define GSC_OUT_PATH_MEMORY            (0<<  0)
>> +
>> +/* G-Scaler scaled destination image size */
>> +#define GSC_SCALED_SIZE                        0x24
>> +#define GSC_SCALED_HEIGHT(x)           ((x)<<  16)
>> +#define GSC_SCALED_WIDTH(x)            ((x)<<  0)
>> +
>> +/* G-Scaler pre scale ratio */
>> +#define GSC_PRE_SCALE_RATIO            0x28
>> +#define GSC_PRESC_SHFACTOR(x)          ((x)<<  28)
>> +#define GSC_PRESC_V_RATIO(x)           ((x)<<  16)
>> +#define GSC_PRESC_H_RATIO(x)           ((x)<<  0)
>> +
>> +/* G-Scaler main scale horizontal ratio */
>> +#define GSC_MAIN_H_RATIO               0x2c
>> +#define GSC_MAIN_H_RATIO_VALUE(x)      ((x)<<  0)
>> +
>> +/* G-Scaler main scale vertical ratio */
>> +#define GSC_MAIN_V_RATIO               0x30
>> +#define GSC_MAIN_V_RATIO_VALUE(x)      ((x)<<  0)
>> +
>> +/* G-Scaler destination image size */
>> +#define GSC_DSTIMG_SIZE                        0x40
>> +#define GSC_DSTIMG_HEIGHT(x)           ((x)<<  16)
>> +#define GSC_DSTIMG_WIDTH(x)            ((x)<<  0)
>> +
>> +/* G-Scaler destination image offset */
>> +#define GSC_DSTIMG_OFFSET              0x44
>> +#define GSC_DSTIMG_OFFSET_Y(x)         ((x)<<  16)
>> +#define GSC_DSTIMG_OFFSET_X(x)         ((x)<<  0)
>> +
>> +/* G-Scaler input y address mask */
>> +#define GSC_IN_BASE_ADDR_Y_MASK                0x4c
>> +/* G-Scaler input y base address */
>> +#define GSC_IN_BASE_ADDR_Y(n)          (0x50 + (n) * 0x4)
>> +
>> +/* G-Scaler input cb address mask */
>> +#define GSC_IN_BASE_ADDR_CB_MASK       0x7c
>> +/* G-Scaler input cb base address */
>> +#define GSC_IN_BASE_ADDR_CB(n)         (0x80 + (n) * 0x4)
>> +
>> +/* G-Scaler input cr address mask */
>> +#define GSC_IN_BASE_ADDR_CR_MASK       0xac
>> +/* G-Scaler input cr base address */
>> +#define GSC_IN_BASE_ADDR_CR(n)         (0xb0 + (n) * 0x4)
>> +
>> +/* G-Scaler output y address mask */
>> +#define GSC_OUT_BASE_ADDR_Y_MASK       0x10c
>> +/* G-Scaler output y base address */
>> +#define GSC_OUT_BASE_ADDR_Y(n)         (0x110 + (n) * 0x4)
>> +
>> +/* G-Scaler output cb address mask */
>> +#define GSC_OUT_BASE_ADDR_CB_MASK      0x15c
>> +/* G-Scaler output cb base address */
>> +#define GSC_OUT_BASE_ADDR_CB(n)                (0x160 + (n) * 0x4)
>> +
>> +/* G-Scaler output cr address mask */
>> +#define GSC_OUT_BASE_ADDR_CR_MASK      0x1ac
>> +/* G-Scaler output cr base address */
>> +#define GSC_OUT_BASE_ADDR_CR(n)                (0x1b0 + (n) * 0x4)
>> +
>> +#endif /* REGS_GSC_H_ */
>
>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>
> --
>
> Thanks,
> Sylwester


Regards,
Shaik Ameer Basha
