Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43424 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab2GZE3m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 00:29:42 -0400
Received: by vbbff1 with SMTP id ff1so1286267vbb.19
        for <linux-media@vger.kernel.org>; Wed, 25 Jul 2012 21:29:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5010615D.8080000@gmail.com>
References: <1343219191-3969-1-git-send-email-shaik.ameer@samsung.com>
	<1343219191-3969-4-git-send-email-shaik.ameer@samsung.com>
	<5010615D.8080000@gmail.com>
Date: Thu, 26 Jul 2012 09:59:41 +0530
Message-ID: <CAOD6ATqrQ5m1Qzxy3=nX0bsT-EWF66rr-TF5awjkGbh_Nxntyg@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] media: gscaler: Add core functionality for the
 G-Scaler driver
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

On Thu, Jul 26, 2012 at 2:43 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> On 07/25/2012 02:26 PM, Shaik Ameer Basha wrote:
>>
>> From: Sungchun Kang<sungchun.kang@samsung.com>
>>
>> This patch adds the core functionality for the G-Scaler driver.
>>
>> Signed-off-by: Hynwoong Kim<khw0178.kim@samsung.com>
>> Signed-off-by: Sungchun Kang<sungchun.kang@samsung.com>
>> Signed-off-by: Shaik Ameer Basha<shaik.ameer@samsung.com>
>> ---
>>   drivers/media/video/exynos-gsc/gsc-core.c | 1261
>> +++++++++++++++++++++++++++++
>>   drivers/media/video/exynos-gsc/gsc-core.h |  537 ++++++++++++
>>   2 files changed, 1798 insertions(+), 0 deletions(-)
>>   create mode 100644 drivers/media/video/exynos-gsc/gsc-core.c
>>   create mode 100644 drivers/media/video/exynos-gsc/gsc-core.h
>>
>> diff --git a/drivers/media/video/exynos-gsc/gsc-core.c
>> b/drivers/media/video/exynos-gsc/gsc-core.c
>> new file mode 100644
>> index 0000000..8d1a1db
>> --- /dev/null
>> +++ b/drivers/media/video/exynos-gsc/gsc-core.c
>> @@ -0,0 +1,1261 @@
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
>> +#include<linux/module.h>
>> +#include<linux/kernel.h>
>> +#include<linux/version.h>
>> +#include<linux/types.h>
>> +#include<linux/errno.h>
>> +#include<linux/bug.h>
>> +#include<linux/interrupt.h>
>> +#include<linux/workqueue.h>
>> +#include<linux/device.h>
>> +#include<linux/platform_device.h>
>> +#include<linux/list.h>
>> +#include<linux/io.h>
>> +#include<linux/slab.h>
>> +#include<linux/clk.h>
>> +#include<linux/of.h>
>> +#include<media/v4l2-ioctl.h>
>> +
>> +#include "gsc-core.h"
>> +
>> +#define GSC_CLOCK_GATE_NAME    "gscl"
>> +
>> +static const struct gsc_fmt gsc_formats[] = {
>> +       {
>> +               .name           = "RGB565",
>> +               .pixelformat    = V4L2_PIX_FMT_RGB565X,
>> +               .depth          = { 16 },
>> +               .color          = GSC_RGB,
>> +               .num_planes     = 1,
>> +               .num_comp       = 1,
>> +       }, {
>> +               .name           = "XRGB-8-8-8-8, 32 bpp",
>> +               .pixelformat    = V4L2_PIX_FMT_RGB32,
>> +               .depth          = { 32 },
>> +               .color          = GSC_RGB,
>> +               .num_planes     = 1,
>> +               .num_comp       = 1,
>> +       }, {
>> +               .name           = "YUV 4:2:2 packed, YCbYCr",
>> +               .pixelformat    = V4L2_PIX_FMT_YUYV,
>> +               .depth          = { 16 },
>> +               .color          = GSC_YUV422,
>> +               .yorder         = GSC_LSB_Y,
>> +               .corder         = GSC_CBCR,
>> +               .num_planes     = 1,
>> +               .num_comp       = 1,
>> +               .mbus_code      = V4L2_MBUS_FMT_YUYV8_2X8,
>> +       }, {
>> +               .name           = "YUV 4:2:2 packed, CbYCrY",
>> +               .pixelformat    = V4L2_PIX_FMT_UYVY,
>> +               .depth          = { 16 },
>> +               .color          = GSC_YUV422,
>> +               .yorder         = GSC_LSB_C,
>> +               .corder         = GSC_CBCR,
>> +               .num_planes     = 1,
>> +               .num_comp       = 1,
>> +               .mbus_code      = V4L2_MBUS_FMT_UYVY8_2X8,
>> +       }, {
>> +               .name           = "YUV 4:2:2 packed, CrYCbY",
>> +               .pixelformat    = V4L2_PIX_FMT_VYUY,
>> +               .depth          = { 16 },
>> +               .color          = GSC_YUV422,
>> +               .yorder         = GSC_LSB_C,
>> +               .corder         = GSC_CRCB,
>> +               .num_planes     = 1,
>> +               .num_comp       = 1,
>> +               .mbus_code      = V4L2_MBUS_FMT_VYUY8_2X8,
>> +       }, {
>> +               .name           = "YUV 4:2:2 packed, YCrYCb",
>> +               .pixelformat    = V4L2_PIX_FMT_YVYU,
>> +               .depth          = { 16 },
>> +               .color          = GSC_YUV422,
>> +               .yorder         = GSC_LSB_Y,
>> +               .corder         = GSC_CRCB,
>> +               .num_planes     = 1,
>> +               .num_comp       = 1,
>> +               .mbus_code      = V4L2_MBUS_FMT_YVYU8_2X8,
>> +       }, {
>> +               .name           = "YUV 4:4:4 planar, YCbYCr",
>> +               .pixelformat    = V4L2_PIX_FMT_YUV32,
>> +               .depth          = { 32 },
>> +               .color          = GSC_YUV444,
>> +               .yorder         = GSC_LSB_Y,
>> +               .corder         = GSC_CBCR,
>> +               .num_planes     = 1,
>> +               .num_comp       = 1,
>> +       }, {
>> +               .name           = "YUV 4:2:2 planar, Y/Cb/Cr",
>> +               .pixelformat    = V4L2_PIX_FMT_YUV422P,
>> +               .depth          = { 16 },
>> +               .color          = GSC_YUV422,
>> +               .yorder         = GSC_LSB_Y,
>> +               .corder         = GSC_CBCR,
>> +               .num_planes     = 1,
>> +               .num_comp       = 3,
>> +       }, {
>> +               .name           = "YUV 4:2:2 planar, Y/CbCr",
>> +               .pixelformat    = V4L2_PIX_FMT_NV16,
>> +               .depth          = { 16 },
>> +               .color          = GSC_YUV422,
>> +               .yorder         = GSC_LSB_Y,
>> +               .corder         = GSC_CBCR,
>> +               .num_planes     = 1,
>> +               .num_comp       = 2,
>> +       }, {
>> +               .name           = "YUV 4:2:2 planar, Y/CrCb",
>> +               .pixelformat    = V4L2_PIX_FMT_NV61,
>> +               .depth          = { 16 },
>> +               .color          = GSC_YUV422,
>> +               .yorder         = GSC_LSB_Y,
>> +               .corder         = GSC_CRCB,
>> +               .num_planes     = 1,
>> +               .num_comp       = 2,
>> +       }, {
>> +               .name           = "YUV 4:2:0 planar, YCbCr",
>> +               .pixelformat    = V4L2_PIX_FMT_YUV420,
>> +               .depth          = { 12 },
>> +               .color          = GSC_YUV420,
>> +               .yorder         = GSC_LSB_Y,
>> +               .corder         = GSC_CBCR,
>> +               .num_planes     = 1,
>> +               .num_comp       = 3,
>> +       }, {
>> +               .name           = "YUV 4:2:0 planar, YCrCb",
>> +               .pixelformat    = V4L2_PIX_FMT_YVU420,
>> +               .depth          = { 12 },
>> +               .color          = GSC_YUV420,
>> +               .yorder         = GSC_LSB_Y,
>> +               .corder         = GSC_CRCB,
>> +               .num_planes     = 1,
>> +               .num_comp       = 3,
>> +
>> +       }, {
>> +               .name           = "YUV 4:2:0 planar, Y/CbCr",
>> +               .pixelformat    = V4L2_PIX_FMT_NV12,
>> +               .depth          = { 12 },
>> +               .color          = GSC_YUV420,
>> +               .yorder         = GSC_LSB_Y,
>> +               .corder         = GSC_CBCR,
>> +               .num_planes     = 1,
>> +               .num_comp       = 2,
>> +       }, {
>> +               .name           = "YUV 4:2:0 planar, Y/CrCb",
>> +               .pixelformat    = V4L2_PIX_FMT_NV21,
>> +               .depth          = { 12 },
>> +               .color          = GSC_YUV420,
>> +               .yorder         = GSC_LSB_Y,
>> +               .corder         = GSC_CRCB,
>> +               .num_planes     = 1,
>> +               .num_comp       = 2,
>> +       }, {
>> +               .name           = "YUV 4:2:0 non-contig. 2p, Y/CbCr",
>> +               .pixelformat    = V4L2_PIX_FMT_NV12M,
>> +               .depth          = { 8, 4 },
>> +               .color          = GSC_YUV420,
>> +               .yorder         = GSC_LSB_Y,
>> +               .corder         = GSC_CBCR,
>> +               .num_planes     = 2,
>> +               .num_comp       = 2,
>> +       }, {
>> +               .name           = "YUV 4:2:0 non-contig. 3p, Y/Cb/Cr",
>> +               .pixelformat    = V4L2_PIX_FMT_YUV420M,
>> +               .depth          = { 8, 2, 2 },
>> +               .color          = GSC_YUV420,
>> +               .yorder         = GSC_LSB_Y,
>> +               .corder         = GSC_CBCR,
>> +               .num_planes     = 3,
>> +               .num_comp       = 3,
>> +       }, {
>> +               .name           = "YUV 4:2:0 non-contig. 3p, Y/Cr/Cb",
>> +               .pixelformat    = V4L2_PIX_FMT_YVU420M,
>> +               .depth          = { 8, 2, 2 },
>> +               .color          = GSC_YUV420,
>> +               .yorder         = GSC_LSB_Y,
>> +               .corder         = GSC_CRCB,
>> +               .num_planes     = 3,
>> +               .num_comp       = 3,
>> +       }, {
>> +               .name           = "YUV 4:2:0 non-contig. 2p, tiled",
>> +               .pixelformat    = V4L2_PIX_FMT_NV12MT_16X16,
>> +               .depth          = { 8, 4 },
>> +               .color          = GSC_YUV420,
>> +               .yorder         = GSC_LSB_Y,
>> +               .corder         = GSC_CBCR,
>> +               .num_planes     = 2,
>> +               .num_comp       = 2,
>> +       },
>> +};
>> +
>> +struct gsc_fmt *get_format(int index)
>> +{
>> +       if (index>= ARRAY_SIZE(gsc_formats))
>> +               return NULL;
>> +
>> +       return (struct gsc_fmt *)&gsc_formats[index];
>
>
> Rather than casting here it would be better to update all users
> of this functions and corresponding data structures, as in the
> attached patch.
>

Ok. I will do that.
Thanks for the attached patch. I can see some more small fixes in your patch. :)

>> +}
>> +
>> +struct gsc_fmt *find_fmt(u32 *pixelformat, u32 *mbus_code, u32 index)
>> +{
>> +       struct gsc_fmt *fmt, *def_fmt = NULL;
>> +       unsigned int i;
>> +
>> +       if (index>= ARRAY_SIZE(gsc_formats))
>> +               return NULL;
>> +
>> +       for (i = 0; i<  ARRAY_SIZE(gsc_formats); ++i) {
>> +               fmt = get_format(i);
>> +               if (pixelformat&&  fmt->pixelformat == *pixelformat)
>> +                       return fmt;
>> +               if (mbus_code&&  fmt->mbus_code == *mbus_code)
>> +                       return fmt;
>> +               if (index == i)
>> +                       def_fmt = fmt;
>> +       }
>> +       return def_fmt;
>> +
>> +}
>> +

<snip>

>> +
>> +int gsc_try_crop(struct gsc_ctx *ctx, struct v4l2_crop *cr)
>> +{
>> +       struct gsc_frame *f;
>> +       struct gsc_dev *gsc = ctx->gsc_dev;
>> +       struct gsc_variant *variant = gsc->variant;
>> +       u32 mod_x = 0, mod_y = 0, tmp_w, tmp_h;
>> +       u32 min_w, min_h, max_w, max_h;
>> +
>> +       if (cr->c.top<  0 || cr->c.left<  0) {
>> +               pr_err("doesn't support negative values for top&
>> left\n");
>> +               return -EINVAL;
>> +       }
>> +       pr_debug("user put w: %d, h: %d", cr->c.width, cr->c.height);
>> +
>> +       if (cr->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
>> +               f =&ctx->d_frame;
>> +       else if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>> +               f =&ctx->s_frame;
>> +       else
>> +               return -EINVAL;
>> +
>> +       max_w = f->f_width;
>> +       max_h = f->f_height;
>> +       tmp_w = cr->c.width;
>> +       tmp_h = cr->c.height;
>> +
>> +       if (V4L2_TYPE_IS_OUTPUT(cr->type)) {
>> +               if ((is_yuv422(f->fmt->color)&&  f->fmt->num_comp == 1) ||
>> +                   is_rgb(f->fmt->color))
>> +                       min_w = 32;
>> +               else
>> +                       min_w = 64;
>> +               if ((is_yuv422(f->fmt->color)&&  f->fmt->num_comp == 3) ||
>> +                   is_yuv420(f->fmt->color))
>> +                       min_h = 32;
>> +               else
>> +                       min_h = 16;
>> +       } else {
>> +               if (is_yuv420(f->fmt->color) || is_yuv422(f->fmt->color))
>> +                       mod_x = ffs(variant->pix_align->target_w) - 1;
>> +               if (is_yuv420(f->fmt->color))
>> +                       mod_y = ffs(variant->pix_align->target_h) - 1;
>> +               if (ctx->gsc_ctrls.rotate->val == 90 ||
>> +                   ctx->gsc_ctrls.rotate->val == 270) {
>> +                       max_w = f->f_height;
>> +                       max_h = f->f_width;
>> +                       min_w = variant->pix_min->target_rot_en_w;
>> +                       min_h = variant->pix_min->target_rot_en_h;
>> +                       tmp_w = cr->c.height;
>> +                       tmp_h = cr->c.width;
>> +               } else {
>> +                       min_w = variant->pix_min->target_rot_dis_w;
>> +                       min_h = variant->pix_min->target_rot_dis_h;
>> +               }
>> +       }
>> +       pr_debug("mod_x: %d, mod_y: %d, min_w: %d, min_h = %d",
>> +                                       mod_x, mod_y, min_w, min_h);
>> +       pr_debug("tmp_w : %d, tmp_h : %d", tmp_w, tmp_h);
>> +
>> +       v4l_bound_align_image(&tmp_w, min_w, max_w, mod_x,
>> +                       &tmp_h, min_h, max_h, mod_y, 0);
>> +
>> +       if (!V4L2_TYPE_IS_OUTPUT(cr->type)&&
>> +               (ctx->gsc_ctrls.rotate->val == 90 ||
>> +               ctx->gsc_ctrls.rotate->val == 270))
>> +               gsc_check_crop_change(tmp_h, tmp_w,
>> +                                       &cr->c.width,&cr->c.height);
>> +       else
>> +               gsc_check_crop_change(tmp_w, tmp_h,
>> +                                       &cr->c.width,&cr->c.height);
>> +
>> +
>> +       /* adjust left/top if cropping rectangle is out of bounds */
>> +       /* Need to add code to algin left value with 2's multiple */
>> +       if (cr->c.left + tmp_w>  max_w)
>> +               cr->c.left = max_w - tmp_w;
>> +       if (cr->c.top + tmp_h>  max_h)
>> +               cr->c.top = max_h - tmp_h;
>> +
>> +       if (is_yuv420(f->fmt->color) || is_yuv422(f->fmt->color))
>> +               if (cr->c.left % 2)
>> +                       cr->c.left -= 1;
>
>
>         if ((is_yuv420(f->fmt->color) || is_yuv422(f->fmt->color)) &&
>                 cr->c.left & 1)
>                         cr->c.left -= 1;
>

Ok. Will change that.

>> +
>> +       pr_debug("Aligned l:%d, t:%d, w:%d, h:%d, f_w: %d, f_h: %d",
>> +           cr->c.left, cr->c.top, cr->c.width, cr->c.height, max_w,
>> max_h);
>> +
>> +       return 0;
>> +}
>> +
>> +int gsc_check_scaler_ratio(struct gsc_variant *var, int sw, int sh, int
>> dw,
>> +                          int dh, int rot, int out_path)
>> +{
>> +       int tmp_w, tmp_h, sc_down_max;
>> +       sc_down_max =
>> +               (out_path == GSC_DMA) ? var->sc_down_max :
>> var->local_sc_down;
>> +
>
>         if (out_path == GSC_DMA)
>                 sc_down_max = var->sc_down_max;
>         else
>                 sc_down_max = var->local_sc_down
>
>> +       if (rot == 90 || rot == 270) {
>> +               tmp_w = dh;
>> +               tmp_h = dw;
>> +       } else {
>> +               tmp_w = dw;
>> +               tmp_h = dh;
>> +       }
>> +
>> +       if ((sw / tmp_w)>  sc_down_max ||
>> +           (sh / tmp_h)>  sc_down_max ||
>> +           (tmp_w / sw)>  var->sc_up_max ||
>> +           (tmp_h / sh)>  var->sc_up_max)
>> +               return -EINVAL;
>> +
>> +       return 0;
>> +}
>> +
>> +int gsc_set_scaler_info(struct gsc_ctx *ctx)
>> +{
>> +       struct gsc_scaler *sc =&ctx->scaler;
>> +       struct gsc_frame *s_frame =&ctx->s_frame;
>> +       struct gsc_frame *d_frame =&ctx->d_frame;
>> +       struct gsc_variant *variant = ctx->gsc_dev->variant;
>> +       struct device *dev =&ctx->gsc_dev->pdev->dev;
>> +       int tx, ty;
>> +       int ret;
>> +
>> +       ret = gsc_check_scaler_ratio(variant, s_frame->crop.width,
>> +               s_frame->crop.height, d_frame->crop.width,
>> d_frame->crop.height,
>> +               ctx->gsc_ctrls.rotate->val, ctx->out_path);
>> +       if (ret) {
>> +               pr_err("out of scaler range");
>> +               return ret;
>> +       }
>> +
>> +       if (ctx->gsc_ctrls.rotate->val == 90 ||
>> +           ctx->gsc_ctrls.rotate->val == 270) {
>> +               ty = d_frame->crop.width;
>> +               tx = d_frame->crop.height;
>> +       } else {
>> +               tx = d_frame->crop.width;
>> +               ty = d_frame->crop.height;
>> +       }
>> +
>> +       if (tx<= 0 || ty<= 0) {
>> +               dev_err(dev, "Invalid target size: %dx%d", tx, ty);
>> +               return -EINVAL;
>> +       }
>> +
>> +       ret = gsc_cal_prescaler_ratio(variant, s_frame->crop.width,
>> +                                     tx,&sc->pre_hratio);
>> +       if (ret) {
>> +               pr_err("Horizontal scale ratio is out of range");
>> +               return ret;
>> +       }
>> +
>> +       ret = gsc_cal_prescaler_ratio(variant, s_frame->crop.height,
>> +                                     ty,&sc->pre_vratio);
>> +       if (ret) {
>> +               pr_err("Vertical scale ratio is out of range");
>> +               return ret;
>> +       }
>> +
>> +       gsc_check_src_scale_info(variant, s_frame,&sc->pre_hratio,
>> +                                tx, ty,&sc->pre_vratio);
>> +
>> +       gsc_get_prescaler_shfactor(sc->pre_hratio, sc->pre_vratio,
>> +                               &sc->pre_shfactor);
>> +
>> +       sc->main_hratio = (s_frame->crop.width<<  16) / tx;
>> +       sc->main_vratio = (s_frame->crop.height<<  16) / ty;
>> +
>> +       pr_debug("scaler input/output size : sx = %d, sy = %d, tx = %d, ty
>> = %d",
>> +                       s_frame->crop.width, s_frame->crop.height, tx,
>> ty);
>> +       pr_debug("scaler ratio info : pre_shfactor : %d, pre_h : %d",
>> +                       sc->pre_shfactor, sc->pre_hratio);
>> +       pr_debug("pre_v :%d, main_h : %d, main_v : %d",
>> +                       sc->pre_vratio, sc->main_hratio, sc->main_vratio);
>> +
>> +       return 0;
>> +}
>> +
>
>
> Unnecessary empty line.
>

Will remove that.

>> +
>> +static int __gsc_s_ctrl(struct gsc_ctx *ctx, struct v4l2_ctrl *ctrl)
>> +{
>> +       struct gsc_dev *gsc = ctx->gsc_dev;
>> +       struct gsc_variant *variant = gsc->variant;
>> +       unsigned int flags = GSC_DST_FMT | GSC_SRC_FMT;
>> +       int ret = 0;
>> +
>> +       if (ctrl->flags&  V4L2_CTRL_FLAG_INACTIVE)
>> +               return 0;
>> +
>> +       switch (ctrl->id) {
>> +       case V4L2_CID_HFLIP:
>> +               ctx->hflip = ctrl->val;
>> +               break;
>> +
>> +       case V4L2_CID_VFLIP:
>> +               ctx->vflip = ctrl->val;
>> +               break;
>> +
>> +       case V4L2_CID_ROTATE:
>> +               if ((ctx->state&  flags) == flags) {
>> +                       ret = gsc_check_scaler_ratio(variant,
>> +                                       ctx->s_frame.crop.width,
>> +                                       ctx->s_frame.crop.height,
>> +                                       ctx->d_frame.crop.width,
>> +                                       ctx->d_frame.crop.height,
>> +                                       ctx->gsc_ctrls.rotate->val,
>> +                                       ctx->out_path);
>> +
>> +                       if (ret)
>> +                               return -EINVAL;
>> +               }
>> +
>> +               ctx->rotation = ctrl->val;
>> +               break;
>> +
>> +       case V4L2_CID_ALPHA_COMPONENT:
>> +               ctx->d_frame.alpha = ctrl->val;
>> +               break;
>> +       }
>> +
>> +       ctx->state |= GSC_PARAMS;
>> +       return 0;
>> +}
>> +

<snip>

>> +static inline struct gsc_frame *ctx_get_frame(struct gsc_ctx *ctx,
>> +                                             enum v4l2_buf_type type)
>> +{
>> +       struct gsc_frame *frame;
>> +
>> +       if (V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE == type) {
>> +               frame =&ctx->s_frame;
>> +       } else if (V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE == type) {
>> +               frame =&ctx->d_frame;
>> +       } else {
>> +               pr_err("Wrong buffer/video queue type (%d)", type);
>> +               return ERR_PTR(-EINVAL);
>> +       }
>> +
>> +       return frame;
>> +}
>> +
>> +static inline void user_to_drv(struct v4l2_ctrl *ctrl, s32 value)
>
>
> It's unused now.
>

Uff... you are right. will delete this.

>> +{
>> +       ctrl->cur.val = ctrl->val = value;
>> +}
>> +
>> +void gsc_hw_set_sw_reset(struct gsc_dev *dev);
>> +int gsc_wait_reset(struct gsc_dev *dev);
>> +
>> +void gsc_hw_set_frm_done_irq_mask(struct gsc_dev *dev, bool mask);
>> +void gsc_hw_set_gsc_irq_enable(struct gsc_dev *dev, bool mask);
>> +void gsc_hw_set_input_buf_masking(struct gsc_dev *dev, u32 shift, bool
>> enable);
>> +void gsc_hw_set_output_buf_masking(struct gsc_dev *dev, u32 shift, bool
>> enable);
>> +void gsc_hw_set_input_addr(struct gsc_dev *dev, struct gsc_addr *addr,
>> +                                                       int index);
>> +void gsc_hw_set_output_addr(struct gsc_dev *dev, struct gsc_addr *addr,
>> +                                                       int index);
>> +void gsc_hw_set_input_path(struct gsc_ctx *ctx);
>> +void gsc_hw_set_in_size(struct gsc_ctx *ctx);
>> +void gsc_hw_set_in_image_rgb(struct gsc_ctx *ctx);
>> +void gsc_hw_set_in_image_format(struct gsc_ctx *ctx);
>> +void gsc_hw_set_output_path(struct gsc_ctx *ctx);
>> +void gsc_hw_set_out_size(struct gsc_ctx *ctx);
>> +void gsc_hw_set_out_image_rgb(struct gsc_ctx *ctx);
>> +void gsc_hw_set_out_image_format(struct gsc_ctx *ctx);
>> +void gsc_hw_set_prescaler(struct gsc_ctx *ctx);
>> +void gsc_hw_set_mainscaler(struct gsc_ctx *ctx);
>> +void gsc_hw_set_rotation(struct gsc_ctx *ctx);
>> +void gsc_hw_set_global_alpha(struct gsc_ctx *ctx);
>> +void gsc_hw_set_sfr_update(struct gsc_ctx *ctx);
>> +
>> +int gsc_wait_operating(struct gsc_dev *dev);
>> +
>> +#endif /* GSC_CORE_H_ */
>
>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>
> --
>
> Regards,
> Sylwester

Regards,
Shaik Ameer Basha
