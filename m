Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:40553 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3JTMdX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Oct 2013 08:33:23 -0400
MIME-Version: 1.0
In-Reply-To: <5260F7F3.20802@samsung.com>
References: <1380889594-10448-1-git-send-email-shaik.ameer@samsung.com>
	<1380889594-10448-2-git-send-email-shaik.ameer@samsung.com>
	<5260F7F3.20802@samsung.com>
Date: Sun, 20 Oct 2013 21:33:21 +0900
Message-ID: <CAOD6ATqPrt8FsTFA-YR8-AJDrwFmQ=vYCGYO_bVi3rt-Ra7Ocg@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] [media] exynos-scaler: Add new driver for Exynos5 SCALER
From: Shaik Ameer Basha <shaik.samsung@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc@vger.kernel.org,
	Arun Kumar K <arun.kk@samsung.com>,
	Pawel Osciak <posciak@google.com>,
	Inki Dae <inki.dae@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Fri, Oct 18, 2013 at 5:57 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> Hi,
>
> I have couple minor comments. These could be addressed in follow up
> patches, it you won't manage to do it today. Sorry for being late with
> this.

Sorry for the late reply.

Currently I am on travel and I don't have the environment to rebase
and test this driver.
I will address your comments in follow up patches.

Can you please queue this driver to your branch and send a pull
request for 3.13 ?

Regards,
Shaik Ameer Basha

>
> On 04/10/13 14:26, Shaik Ameer Basha wrote:
>> This patch adds support for SCALER device which is a new device
>> for scaling, blending, color fill  and color space conversion
>> on EXYNOS5410 and EXYNOS5420 SoCs.
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
>>     Size - Exynos5420
>>         - Input : 16x16 to 8192x8192
>>         - Output:   4x4 to 8192x8192
>>     Size - Exynos5410
>>         - Input/Output: 4x4 to 4096x4096
>>     alpha blending, color fill
>>
>> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>
>> +void scaler_hw_set_in_size(struct scaler_ctx *ctx)
>> +{
>> +     struct scaler_dev *dev = ctx->scaler_dev;
>> +     struct scaler_frame *frame = &ctx->s_frame;
>> +     u32 cfg;
>> +
>> +     /* set input pixel offset */
>> +     cfg = (frame->selection.left & SCALER_SRC_YH_POS_MASK) <<
>> +                               SCALER_SRC_YH_POS_SHIFT;
>> +     cfg |= ((frame->selection.top & SCALER_SRC_YV_POS_MASK) <<
>> +                                SCALER_SRC_YV_POS_SHIFT);
>> +     scaler_write(dev, SCALER_SRC_Y_POS, cfg);
>> +
>> +     /* TODO: calculate 'C' plane h/v offset using 'Y' plane h/v offset */
>> +
>> +     /* Set input span */
>> +     cfg = (frame->f_width & SCALER_SRC_Y_SPAN_MASK) <<
>> +                             SCALER_SRC_Y_SPAN_SHIFT;
>> +     if (is_yuv420_2p(frame->fmt))
>> +             cfg |= ((frame->f_width & SCALER_SRC_C_SPAN_MASK) <<
>> +                                       SCALER_SRC_C_SPAN_SHIFT);
>> +     else /* TODO: Verify */
>> +             cfg |= ((frame->f_width & SCALER_SRC_C_SPAN_MASK) <<
>> +                                       SCALER_SRC_C_SPAN_SHIFT);
>> +
>> +     scaler_write(dev, SCALER_SRC_SPAN, cfg);
>> +
>> +     /* Set input cropped size */
>> +     cfg = (frame->selection.width & SCALER_SRC_WIDTH_MASK) <<
>> +                                SCALER_SRC_WIDTH_SHIFT;
>> +     cfg |= ((frame->selection.height & SCALER_SRC_HEIGHT_MASK) <<
>> +                                   SCALER_SRC_HEIGHT_SHIFT);
>> +     scaler_write(dev, SCALER_SRC_WH, cfg);
>> +
>> +     scaler_dbg(dev, "src: posx: %d, posY: %d, spanY: %d, spanC: %d, cropX: %d, cropY: %d\n",
>
> This could be broken into two lines, it's just a debug print.
>
>> +             frame->selection.left, frame->selection.top,
>> +             frame->f_width, frame->f_width, frame->selection.width,
>> +             frame->selection.height);
>> +}
>> +
>> +void scaler_hw_set_in_image_format(struct scaler_ctx *ctx)
>> +{
>> +     struct scaler_dev *dev = ctx->scaler_dev;
>> +     struct scaler_frame *frame = &ctx->s_frame;
>> +     u32 cfg;
>> +
>> +     cfg = scaler_read(dev, SCALER_SRC_CFG);
>> +     cfg &= ~(SCALER_SRC_COLOR_FORMAT_MASK << SCALER_SRC_COLOR_FORMAT_SHIFT);
>> +     cfg |= ((frame->fmt->scaler_color & SCALER_SRC_COLOR_FORMAT_MASK) <<
>> +                                        SCALER_SRC_COLOR_FORMAT_SHIFT);
>> +
>> +     /* Setting tiled/linear format */
>> +     if (is_tiled_fmt(frame->fmt))
>> +             cfg |= SCALER_SRC_TILE_EN;
>> +     else
>> +             cfg &= ~SCALER_SRC_TILE_EN;
>> +
>> +     scaler_write(dev, SCALER_SRC_CFG, cfg);
>> +}
>> +
>> +void scaler_hw_set_out_size(struct scaler_ctx *ctx)
>> +{
>> +     struct scaler_dev *dev = ctx->scaler_dev;
>> +     struct scaler_frame *frame = &ctx->d_frame;
>> +     u32 cfg;
>> +
>> +     /* Set output pixel offset */
>> +     cfg = (frame->selection.left & SCALER_DST_H_POS_MASK) <<
>> +                               SCALER_DST_H_POS_SHIFT;
>> +     cfg |= (frame->selection.top & SCALER_DST_V_POS_MASK) <<
>> +                               SCALER_DST_V_POS_SHIFT;
>> +     scaler_write(dev, SCALER_DST_POS, cfg);
>> +
>> +     /* Set output span */
>> +     cfg = (frame->f_width & SCALER_DST_Y_SPAN_MASK) <<
>> +                             SCALER_DST_Y_SPAN_SHIFT;
>> +     if (is_yuv420_2p(frame->fmt))
>> +             cfg |= (((frame->f_width / 2) & SCALER_DST_C_SPAN_MASK) <<
>> +                                          SCALER_DST_C_SPAN_SHIFT);
>> +     else
>> +             cfg |= (((frame->f_width) & SCALER_DST_C_SPAN_MASK) <<
>> +                                          SCALER_DST_C_SPAN_SHIFT);
>> +     scaler_write(dev, SCALER_DST_SPAN, cfg);
>> +
>> +     /* Set output scaled size */
>> +     cfg = (frame->selection.width & SCALER_DST_WIDTH_MASK) <<
>> +                                SCALER_DST_WIDTH_SHIFT;
>> +     cfg |= (frame->selection.height & SCALER_DST_HEIGHT_MASK) <<
>> +                                  SCALER_DST_HEIGHT_SHIFT;
>> +     scaler_write(dev, SCALER_DST_WH, cfg);
>> +
>> +     scaler_dbg(dev, "dst: pos X: %d, pos Y: %d, span Y: %d, span C: %d, crop X: %d, crop Y: %d\n",
>
> Ditto.
>
>> +             frame->selection.left, frame->selection.top,
>> +             frame->f_width, frame->f_width, frame->selection.width,
>> +             frame->selection.height);
>> +}
> [...]
>> +struct scaler_error {
>> +     u32 irq_num;
>> +     const char * const name;
>> +};
>> +
>> +static const struct scaler_error scaler_errors[] = {
>> +     {SCALER_INT_TIMEOUT,                    "Timeout"},
>
> Please add spaces after { and before } for all these entries.
>
>> +     {SCALER_INT_ILLEGAL_BLEND,              "Illegal Blend setting"},
>> +     {SCALER_INT_ILLEGAL_RATIO,              "Illegal Scale ratio setting"},
>> +     {SCALER_INT_ILLEGAL_DST_HEIGHT,         "Illegal Dst Height"},
>> +     {SCALER_INT_ILLEGAL_DST_WIDTH,          "Illegal Dst Width"},
>> +     {SCALER_INT_ILLEGAL_DST_V_POS,          "Illegal Dst V-Pos"},
>> +     {SCALER_INT_ILLEGAL_DST_H_POS,          "Illegal Dst H-Pos"},
>> +     {SCALER_INT_ILLEGAL_DST_C_SPAN,         "Illegal Dst C-Span"},
>> +     {SCALER_INT_ILLEGAL_DST_Y_SPAN,         "Illegal Dst Y-span"},
>> +     {SCALER_INT_ILLEGAL_DST_CR_BASE,        "Illegal Dst Cr-base"},
>> +     {SCALER_INT_ILLEGAL_DST_CB_BASE,        "Illegal Dst Cb-base"},
>> +     {SCALER_INT_ILLEGAL_DST_Y_BASE,         "Illegal Dst Y-base"},
>> +     {SCALER_INT_ILLEGAL_DST_COLOR,          "Illegal Dst Color"},
>> +     {SCALER_INT_ILLEGAL_SRC_HEIGHT,         "Illegal Src Height"},
>> +     {SCALER_INT_ILLEGAL_SRC_WIDTH,          "Illegal Src Width"},
>> +     {SCALER_INT_ILLEGAL_SRC_CV_POS,         "Illegal Src Chroma V-pos"},
>> +     {SCALER_INT_ILLEGAL_SRC_CH_POS,         "Illegal Src Chroma H-pos"},
>> +     {SCALER_INT_ILLEGAL_SRC_YV_POS,         "Illegal Src Luma V-pos"},
>> +     {SCALER_INT_ILLEGAL_SRC_YH_POS,         "Illegal Src Luma H-pos"},
>> +     {SCALER_INT_ILLEGAL_SRC_C_SPAN,         "Illegal Src C-span"},
>> +     {SCALER_INT_ILLEGAL_SRC_Y_SPAN,         "Illegal Src Y-span"},
>> +     {SCALER_INT_ILLEGAL_SRC_CR_BASE,        "Illegal Src Cr-base"},
>> +     {SCALER_INT_ILLEGAL_SRC_CB_BASE,        "Illegal Src Cb-base"},
>> +     {SCALER_INT_ILLEGAL_SRC_Y_BASE,         "Illegal Src Y-base"},
>> +     {SCALER_INT_ILLEGAL_SRC_COLOR,          "Illegal Src Color setting"},
>
> You could remove remove word "Illegal" and add it when printing
> the error string for all entries except the first one. This will
> slightly decrease code section size of this module.
>
> Thanks,
> Sylwester
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
