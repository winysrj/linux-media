Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f172.google.com ([209.85.216.172]:33655 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab3HTIHV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Aug 2013 04:07:21 -0400
MIME-Version: 1.0
In-Reply-To: <032701ce9cda$5c0e55d0$142b0170$%dae@samsung.com>
References: <1376909932-23644-1-git-send-email-shaik.ameer@samsung.com>
	<1376909932-23644-2-git-send-email-shaik.ameer@samsung.com>
	<032701ce9cda$5c0e55d0$142b0170$%dae@samsung.com>
Date: Tue, 20 Aug 2013 13:37:20 +0530
Message-ID: <CAOD6ATqdW4zqaKNrWtJ9x+fR_TW2hHYMt27wAHB3py4=8G2Rww@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] [media] exynos-mscl: Add new driver for M-Scaler
From: Shaik Ameer Basha <shaik.samsung@gmail.com>
To: Inki Dae <inki.dae@samsung.com>
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc@vger.kernel.org, cpgs@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	posciak@google.com, Arun Kumar K <arun.kk@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Inki Dae,

Thanks for the review.


On Mon, Aug 19, 2013 at 6:18 PM, Inki Dae <inki.dae@samsung.com> wrote:
> Just quick review.
>
>> -----Original Message-----
>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>> owner@vger.kernel.org] On Behalf Of Shaik Ameer Basha
>> Sent: Monday, August 19, 2013 7:59 PM
>> To: linux-media@vger.kernel.org; linux-samsung-soc@vger.kernel.org
>> Cc: s.nawrocki@samsung.com; posciak@google.com; arun.kk@samsung.com;
>> shaik.ameer@samsung.com
>> Subject: [PATCH v2 1/5] [media] exynos-mscl: Add new driver for M-Scaler
>>
>> This patch adds support for M-Scaler (M2M Scaler) device which is a
>> new device for scaling, blending, color fill  and color space
>> conversion on EXYNOS5 SoCs.
>>
>> This device supports the followings as key feature.
>>     input image format
>>         - YCbCr420 2P(UV/VU), 3P
>>         - YCbCr422 1P(YUYV/UYVY/YVYU), 2P(UV,VU), 3P
>>         - YCbCr444 2P(UV,VU), 3P
>>         - RGB565, ARGB1555, ARGB4444, ARGB8888, RGBA8888
>>         - Pre-multiplexed ARGB8888, L8A8 and L8
>>     output image format
>>         - YCbCr420 2P(UV/VU), 3P
>>         - YCbCr422 1P(YUYV/UYVY/YVYU), 2P(UV,VU), 3P
>>         - YCbCr444 2P(UV,VU), 3P
>>         - RGB565, ARGB1555, ARGB4444, ARGB8888, RGBA8888
>>         - Pre-multiplexed ARGB8888
>>     input rotation
>>         - 0/90/180/270 degree, X/Y/XY Flip
>>     scale ratio
>>         - 1/4 scale down to 16 scale up
>>     color space conversion
>>         - RGB to YUV / YUV to RGB
>>     Size
>>         - Input : 16x16 to 8192x8192
>>         - Output:   4x4 to 8192x8192
>>     alpha blending, color fill
>>
>> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
>> ---
>>  drivers/media/platform/exynos-mscl/mscl-regs.c |  318
>> ++++++++++++++++++++++++
>>  drivers/media/platform/exynos-mscl/mscl-regs.h |  282
>> +++++++++++++++++++++
>>  2 files changed, 600 insertions(+)
>>  create mode 100644 drivers/media/platform/exynos-mscl/mscl-regs.c
>>  create mode 100644 drivers/media/platform/exynos-mscl/mscl-regs.h
>>
>> diff --git a/drivers/media/platform/exynos-mscl/mscl-regs.c
>> b/drivers/media/platform/exynos-mscl/mscl-regs.c
>> new file mode 100644
>> index 0000000..9354afc
>> --- /dev/null
>> +++ b/drivers/media/platform/exynos-mscl/mscl-regs.c
>> @@ -0,0 +1,318 @@
>> +/*
>> + * Copyright (c) 2013 - 2014 Samsung Electronics Co., Ltd.
>> + *           http://www.samsung.com
>> + *
>> + * Samsung EXYNOS5 SoC series M-Scaler driver
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published
>> + * by the Free Software Foundation, either version 2 of the License,
>> + * or (at your option) any later version.
>> + */
>> +
>> +#include <linux/delay.h>
>> +#include <linux/platform_device.h>
>> +
>> +#include "mscl-core.h"
>> +
>> +void mscl_hw_set_sw_reset(struct mscl_dev *dev)
>> +{
>> +     u32 cfg;
>> +
>> +     cfg = readl(dev->regs + MSCL_CFG);
>> +     cfg |= MSCL_CFG_SOFT_RESET;
>> +
>> +     writel(cfg, dev->regs + MSCL_CFG);
>> +}
>> +
>> +int mscl_wait_reset(struct mscl_dev *dev)
>> +{
>> +     unsigned long end = jiffies + msecs_to_jiffies(50);
>
> What does 50 mean?
>
>> +     u32 cfg, reset_done = 0;
>> +
>
> Please describe why the below codes are needed.


As per the Documentation,

" SOFT RESET: Writing "1" to this bit generates software reset. To
check the completion of the reset, wait until this
field becomes zero, then wrie an arbitrary value to any of RW
registers and read it. If the read data matches the written data,
 it means SW reset succeeded. Otherwise, repeat write & read until matched."


Thie below code tries to do the same (as per user manual). and in the
above msec_to_jiffies(50), 50 is the 50msec wait. before
checking the SOFT RESET is really done.

Is it good to ignore this checks?



>
>> +     while (time_before(jiffies, end)) {
>> +             cfg = readl(dev->regs + MSCL_CFG);
>> +             if (!(cfg & MSCL_CFG_SOFT_RESET)) {
>> +                     reset_done = 1;
>> +                     break;
>> +             }
>> +             usleep_range(10, 20);
>> +     }
>> +
>> +     /* write any value to r/w reg and read it back */
>> +     while (reset_done) {
>> +
>> +             /* [TBD] need to define number of tries before returning
>> +              * -EBUSY to the caller
>> +              */
>> +
>> +             writel(MSCL_CFG_SOFT_RESET_CHECK_VAL,
>> +                             dev->regs + MSCL_CFG_SOFT_RESET_CHECK_REG);
>> +             if (MSCL_CFG_SOFT_RESET_CHECK_VAL ==
>> +                     readl(dev->regs + MSCL_CFG_SOFT_RESET_CHECK_REG))
>> +                     return 0;
>> +     }
>> +
>> +     return -EBUSY;
>> +}
>> +
>> +void mscl_hw_set_irq_mask(struct mscl_dev *dev, int interrupt, bool mask)
>> +{
>> +     u32 cfg;
>> +
>> +     switch (interrupt) {
>> +     case MSCL_INT_TIMEOUT:
>> +     case MSCL_INT_ILLEGAL_BLEND:
>> +     case MSCL_INT_ILLEGAL_RATIO:
>> +     case MSCL_INT_ILLEGAL_DST_HEIGHT:
>> +     case MSCL_INT_ILLEGAL_DST_WIDTH:
>> +     case MSCL_INT_ILLEGAL_DST_V_POS:
>> +     case MSCL_INT_ILLEGAL_DST_H_POS:
>> +     case MSCL_INT_ILLEGAL_DST_C_SPAN:
>> +     case MSCL_INT_ILLEGAL_DST_Y_SPAN:
>> +     case MSCL_INT_ILLEGAL_DST_CR_BASE:
>> +     case MSCL_INT_ILLEGAL_DST_CB_BASE:
>> +     case MSCL_INT_ILLEGAL_DST_Y_BASE:
>> +     case MSCL_INT_ILLEGAL_DST_COLOR:
>> +     case MSCL_INT_ILLEGAL_SRC_HEIGHT:
>> +     case MSCL_INT_ILLEGAL_SRC_WIDTH:
>> +     case MSCL_INT_ILLEGAL_SRC_CV_POS:
>> +     case MSCL_INT_ILLEGAL_SRC_CH_POS:
>> +     case MSCL_INT_ILLEGAL_SRC_YV_POS:
>> +     case MSCL_INT_ILLEGAL_SRC_YH_POS:
>> +     case MSCL_INT_ILLEGAL_SRC_C_SPAN:
>> +     case MSCL_INT_ILLEGAL_SRC_Y_SPAN:
>> +     case MSCL_INT_ILLEGAL_SRC_CR_BASE:
>> +     case MSCL_INT_ILLEGAL_SRC_CB_BASE:
>> +     case MSCL_INT_ILLEGAL_SRC_Y_BASE:
>> +     case MSCL_INT_ILLEGAL_SRC_COLOR:
>> +     case MSCL_INT_FRAME_END:
>> +             break;
>> +     default:
>> +             return;
>> +     }
>
> It seems that the above codes could be more simple,


ok. will change this.


>
>
>> +     cfg = readl(dev->regs + MSCL_INT_EN);
>> +     if (mask)
>> +             cfg |= interrupt;
>> +     else
>> +             cfg &= ~interrupt;
>> +     writel(cfg, dev->regs + MSCL_INT_EN);
>> +}
>> +
>> +void mscl_hw_set_input_addr(struct mscl_dev *dev, struct mscl_addr *addr)
>> +{
>> +     dev_dbg(&dev->pdev->dev, "src_buf: 0x%X, cb: 0x%X, cr: 0x%X",
>> +                             addr->y, addr->cb, addr->cr);
>> +     writel(addr->y, dev->regs + MSCL_SRC_Y_BASE);
>> +     writel(addr->cb, dev->regs + MSCL_SRC_CB_BASE);
>> +     writel(addr->cr, dev->regs + MSCL_SRC_CR_BASE);
>> +}
>> +
>> +void mscl_hw_set_output_addr(struct mscl_dev *dev,
>> +                          struct mscl_addr *addr)
>> +{
>> +     dev_dbg(&dev->pdev->dev, "dst_buf: 0x%X, cb: 0x%X, cr: 0x%X",
>> +                             addr->y, addr->cb, addr->cr);
>> +     writel(addr->y, dev->regs + MSCL_DST_Y_BASE);
>> +     writel(addr->cb, dev->regs + MSCL_DST_CB_BASE);
>> +     writel(addr->cr, dev->regs + MSCL_DST_CR_BASE);
>> +}
>> +
>> +void mscl_hw_set_in_size(struct mscl_ctx *ctx)
>> +{
>> +     struct mscl_dev *dev = ctx->mscl_dev;
>> +     struct mscl_frame *frame = &ctx->s_frame;
>> +     u32 cfg;
>> +
>> +     /* set input pixel offset */
>> +     cfg = MSCL_SRC_YH_POS(frame->crop.left);
>> +     cfg |= MSCL_SRC_YV_POS(frame->crop.top);
>
> Where are the limitations to left and top checked?.



mscl_try_crop() does this checking.



>
>> +     writel(cfg, dev->regs + MSCL_SRC_Y_POS);
>> +
>> +     /* [TBD] calculate 'C' plane h/v offset using 'Y' plane h/v offset
>> */
>> +
>> +     /* set input span */
>> +     cfg = MSCL_SRC_Y_SPAN(frame->f_width);
>> +     if (is_yuv420_2p(frame->fmt))
>> +             cfg |= MSCL_SRC_C_SPAN(frame->f_width);
>> +     else
>> +             cfg |= MSCL_SRC_C_SPAN(frame->f_width); /* [TBD] Verify */
>> +
>> +     writel(cfg, dev->regs + MSCL_SRC_SPAN);
>> +
>> +     /* Set input cropped size */
>> +     cfg = MSCL_SRC_WIDTH(frame->crop.width);
>> +     cfg |= MSCL_SRC_HEIGHT(frame->crop.height);
>> +     writel(cfg, dev->regs + MSCL_SRC_WH);
>> +
>> +     dev_dbg(&dev->pdev->dev,
>> +             "src: posx: %d, posY: %d, spanY: %d, spanC: %d, "
>> +             "cropX: %d, cropY: %d\n",
>> +             frame->crop.left, frame->crop.top, frame->f_width,
>> +             frame->f_width, frame->crop.width, frame->crop.height);
>> +}
>> +
>> +void mscl_hw_set_in_image_format(struct mscl_ctx *ctx)
>> +{
>> +     struct mscl_dev *dev = ctx->mscl_dev;
>> +     struct mscl_frame *frame = &ctx->s_frame;
>> +     u32 cfg;
>> +
>> +     cfg = readl(dev->regs + MSCL_SRC_CFG);
>> +     cfg &= ~MSCL_SRC_COLOR_FORMAT_MASK;
>> +     cfg |= MSCL_SRC_COLOR_FORMAT(frame->fmt->mscl_color);
>> +
>> +     /* setting tile/linear format */
>> +     if (frame->fmt->is_tiled)
>> +             cfg |= MSCL_SRC_TILE_EN;
>> +     else
>> +             cfg &= ~MSCL_SRC_TILE_EN;
>> +
>> +     writel(cfg, dev->regs + MSCL_SRC_CFG);
>> +}
>> +
>> +void mscl_hw_set_out_size(struct mscl_ctx *ctx)
>> +{
>> +     struct mscl_dev *dev = ctx->mscl_dev;
>> +     struct mscl_frame *frame = &ctx->d_frame;
>> +     u32 cfg;
>> +
>> +     /* set output pixel offset */
>> +     cfg = MSCL_DST_H_POS(frame->crop.left);
>> +     cfg |= MSCL_DST_V_POS(frame->crop.top);
>
> Ditto.
>
>> +     writel(cfg, dev->regs + MSCL_DST_POS);
>> +
>> +     /* set output span */
>> +     cfg = MSCL_DST_Y_SPAN(frame->f_width);
>> +     if (is_yuv420_2p(frame->fmt))
>> +             cfg |= MSCL_DST_C_SPAN(frame->f_width/2);
>> +     else
>> +             cfg |= MSCL_DST_C_SPAN(frame->f_width);
>> +     writel(cfg, dev->regs + MSCL_DST_SPAN);
>> +
>> +     /* set output scaled size */
>> +     cfg = MSCL_DST_WIDTH(frame->crop.width);
>> +     cfg |= MSCL_DST_HEIGHT(frame->crop.height);
>> +     writel(cfg, dev->regs + MSCL_DST_WH);
>> +
>> +     dev_dbg(&dev->pdev->dev,
>> +             "dst: posx: %d, posY: %d, spanY: %d, spanC: %d, "
>> +             "cropX: %d, cropY: %d\n",
>> +             frame->crop.left, frame->crop.top, frame->f_width,
>> +             frame->f_width, frame->crop.width, frame->crop.height);
>> +}
>> +
>> +void mscl_hw_set_out_image_format(struct mscl_ctx *ctx)
>> +{
>> +     struct mscl_dev *dev = ctx->mscl_dev;
>> +     struct mscl_frame *frame = &ctx->d_frame;
>> +     u32 cfg;
>> +
>> +     cfg = readl(dev->regs + MSCL_DST_CFG);
>> +     cfg &= ~MSCL_DST_COLOR_FORMAT_MASK;
>> +     cfg |= MSCL_DST_COLOR_FORMAT(frame->fmt->mscl_color);
>> +
>> +     writel(cfg, dev->regs + MSCL_DST_CFG);
>> +}
>> +
>> +void mscl_hw_set_scaler_ratio(struct mscl_ctx *ctx)
>> +{
>> +     struct mscl_dev *dev = ctx->mscl_dev;
>> +     struct mscl_scaler *sc = &ctx->scaler;
>> +     u32 cfg;
>> +
>> +     cfg = MSCL_H_RATIO_VALUE(sc->hratio);
>> +     writel(cfg, dev->regs + MSCL_H_RATIO);
>> +
>> +     cfg = MSCL_V_RATIO_VALUE(sc->vratio);
>> +     writel(cfg, dev->regs + MSCL_V_RATIO);
>> +}
>> +
>> +void mscl_hw_set_rotation(struct mscl_ctx *ctx)
>> +{
>> +     struct mscl_dev *dev = ctx->mscl_dev;
>> +     u32 cfg = 0;
>> +
>> +     cfg = MSCL_ROTMODE(ctx->ctrls_mscl.rotate->val/90);
>> +
>> +     if (ctx->ctrls_mscl.hflip->val)
>> +             cfg |= MSCL_FLIP_X_EN;
>> +
>> +     if (ctx->ctrls_mscl.vflip->val)
>> +             cfg |= MSCL_FLIP_Y_EN;
>> +
>> +     writel(cfg, dev->regs + MSCL_ROT_CFG);
>> +}
>> +
>> +void mscl_hw_address_queue_reset(struct mscl_ctx *ctx)
>> +{
>> +     struct mscl_dev *dev = ctx->mscl_dev;
>> +
>> +     writel(MSCL_ADDR_QUEUE_RST, dev->regs + MSCL_ADDR_QUEUE_CONFIG);
>> +}
>> +
>> +void mscl_hw_set_csc_coeff(struct mscl_ctx *ctx)
>> +{
>> +     struct mscl_dev *dev = ctx->mscl_dev;
>> +     enum mscl_csc_coeff type;
>> +     u32 cfg = 0;
>> +     int i, j;
>> +     static const u32 csc_coeff[MSCL_CSC_COEFF_MAX][3][3] = {
>> +             { /* YCbCr to RGB */
>> +                     {0x200, 0x000, 0x2be},
>> +                     {0x200, 0xeac, 0x165},
>> +                     {0x200, 0x377, 0x000}
>> +             },
>> +             { /* YCbCr to RGB with -16 offset */
>> +                     {0x254, 0x000, 0x331},
>> +                     {0x254, 0xec8, 0xFA0},
>> +                     {0x254, 0x409, 0x000}
>> +             },
>> +             { /* RGB to YCbCr */
>> +                     {0x099, 0x12d, 0x03a},
>> +                     {0xe58, 0xeae, 0x106},
>> +                     {0x106, 0xedb, 0xe2a}
>> +             },
>> +             { /* RGB to YCbCr with -16 offset */
>> +                     {0x084, 0x102, 0x032},
>> +                     {0xe4c, 0xe95, 0x0e1},
>> +                     {0x0e1, 0xebc, 0xe24}
>> +             } };
>> +
>> +     if (is_rgb(ctx->s_frame.fmt) == is_rgb(ctx->d_frame.fmt))
>> +             type = MSCL_CSC_COEFF_NONE;
>> +     else if (is_rgb(ctx->d_frame.fmt))
>> +             type = MSCL_CSC_COEFF_YCBCR_TO_RGB_OFF16;
>> +     else
>> +             type = MSCL_CSC_COEFF_RGB_TO_YCBCR_OFF16;
>> +
>> +     if ((type == ctx->mscl_dev->coeff_type) || (type >=
>> MSCL_CSC_COEFF_MAX))
>> +             return;
>> +
>> +     for (i = 0; i < 3; i++) {
>> +             for (j = 0; j < 3; j++) {
>> +                     cfg = csc_coeff[type][i][j];
>> +                     writel(cfg, dev->regs + MSCL_CSC_COEF(i, j));
>> +             }
>> +     }
>> +
>> +     switch (type) {
>> +     case MSCL_CSC_COEFF_YCBCR_TO_RGB:
>
> Is there this case?
>
>> +             mscl_hw_src_y_offset_en(ctx->mscl_dev, false);
>
> And this switch-case could be removed if you move the above line to the
> above if-sentence.
>
>
>> +             break;
>> +     case MSCL_CSC_COEFF_YCBCR_TO_RGB_OFF16:
>> +             mscl_hw_src_y_offset_en(ctx->mscl_dev, true);
>
> Ditto.
>
>> +             break;
>> +     case MSCL_CSC_COEFF_RGB_TO_YCBCR:
>
> Seems no case.
>
>> +             mscl_hw_src_y_offset_en(ctx->mscl_dev, false);
>
> Could be moved to the above if-sentence.



I think MSCL_CSC_COEFF_YCBCR_TO_RGB_OFF16, MSCL_CSC_COEFF_YCBCR_TO_RGB
belongs to different color spaces.
Anyways, will remove the unused cases and will reorganize the code as
per your comments.

Regards,
Shaik Ameer Basha



>
>> +             break;
>> +     case MSCL_CSC_COEFF_RGB_TO_YCBCR_OFF16:
>> +             mscl_hw_src_y_offset_en(ctx->mscl_dev, true);
>
> Ditto.
>
>> +             break;
>> +     default:
>> +             return;
>> +     }
>> +
>> +     ctx->mscl_dev->coeff_type = type;
>> +     return;
>> +}

[snip]
