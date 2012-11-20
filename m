Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:50787 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab2KTLmU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Nov 2012 06:42:20 -0500
Received: by mail-vc0-f174.google.com with SMTP id m18so2245456vcm.19
        for <linux-media@vger.kernel.org>; Tue, 20 Nov 2012 03:42:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50AAA609.2030007@gmail.com>
References: <1352270227-8369-1-git-send-email-shaik.ameer@samsung.com>
	<50AAA609.2030007@gmail.com>
Date: Tue, 20 Nov 2012 17:12:19 +0530
Message-ID: <CAOD6ATq2rDP8EGg4AAgiGukO_312Fz4DUx1sqpGO4mck7LEarQ@mail.gmail.com>
Subject: Re: [PATCH] [media] exynos-gsc: Adding tiled multi-planar format to G-Scaler
From: Shaik Ameer Basha <shaik.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	kgene.kim@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Tue, Nov 20, 2012 at 3:05 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi Shaik,
>
>
> On 11/07/2012 07:37 AM, Shaik Ameer Basha wrote:
>>
>> Adding V4L2_PIX_FMT_NV12MT_16X16 to G-Scaler supported formats.
>> If the output or input format is V4L2_PIX_FMT_NV12MT_16X16, configure
>> G-Scaler to use GSC_IN_TILE_MODE.
>>
>> Signed-off-by: Shaik Ameer Basha<shaik.ameer@samsung.com>
>> ---
>>   drivers/media/platform/exynos-gsc/gsc-core.c |    9 +++++++++
>>   drivers/media/platform/exynos-gsc/gsc-core.h |    5 +++++
>>   drivers/media/platform/exynos-gsc/gsc-regs.c |    6 ++++++
>>   3 files changed, 20 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c
>> b/drivers/media/platform/exynos-gsc/gsc-core.c
>> index cc7b218..00f1013 100644
>> --- a/drivers/media/platform/exynos-gsc/gsc-core.c
>> +++ b/drivers/media/platform/exynos-gsc/gsc-core.c
>> @@ -185,6 +185,15 @@ static const struct gsc_fmt gsc_formats[] = {
>>                 .corder         = GSC_CRCB,
>>                 .num_planes     = 3,
>>                 .num_comp       = 3,
>> +       }, {
>> +               .name           = "YUV 4:2:0 non-contig. 2p, Y/CbCr,
>> tiled",
>
>
> I have applied this patch to my tree for v3.8, and I've shortened this
> description like this
>
>                 .name           = "YUV 4:2:0 n.c. 2p, Y/CbCr tiled",
>
> so it fits in 32 char buffer.

Thanks and that should be fine.

>
> There are some too long format descriptions in the driver already.
> Please check output of VIDIOC_ENUM_FMT ioctl, for instance with
> 'v4l2-ctl --list-fmt'.
>
>
>> +               .pixelformat    = V4L2_PIX_FMT_NV12MT_16X16,
>> +               .depth          = { 8, 4 },
>> +               .color          = GSC_YUV420,
>> +               .yorder         = GSC_LSB_Y,
>> +               .corder         = GSC_CBCR,
>> +               .num_planes     = 2,
>> +               .num_comp       = 2,
>>         }
>>   };
>>
>> diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h
>> b/drivers/media/platform/exynos-gsc/gsc-core.h
>> index 5f157ef..cc19bba 100644
>> --- a/drivers/media/platform/exynos-gsc/gsc-core.h
>> +++ b/drivers/media/platform/exynos-gsc/gsc-core.h
>> @@ -427,6 +427,11 @@ static inline void gsc_ctx_state_lock_clear(u32
>> state, struct gsc_ctx *ctx)
>>         spin_unlock_irqrestore(&ctx->gsc_dev->slock, flags);
>>   }
>>
>> +static inline int is_tiled(const struct gsc_fmt *fmt)
>> +{
>> +       return fmt->pixelformat == V4L2_PIX_FMT_NV12MT_16X16;
>> +}
>> +
>>   static inline void gsc_hw_enable_control(struct gsc_dev *dev, bool on)
>>   {
>>         u32 cfg = readl(dev->regs + GSC_ENABLE);
>> diff --git a/drivers/media/platform/exynos-gsc/gsc-regs.c
>> b/drivers/media/platform/exynos-gsc/gsc-regs.c
>> index 0146b35..6f5b5a4 100644
>> --- a/drivers/media/platform/exynos-gsc/gsc-regs.c
>> +++ b/drivers/media/platform/exynos-gsc/gsc-regs.c
>> @@ -214,6 +214,9 @@ void gsc_hw_set_in_image_format(struct gsc_ctx *ctx)
>>                 break;
>>         }
>>
>> +       if (is_tiled(frame->fmt))
>> +               cfg |= GSC_IN_TILE_C_16x8 | GSC_IN_TILE_MODE;
>> +
>>         writel(cfg, dev->regs + GSC_IN_CON);
>>   }
>>
>> @@ -334,6 +337,9 @@ void gsc_hw_set_out_image_format(struct gsc_ctx *ctx)
>>                 break;
>>         }
>>
>> +       if (is_tiled(frame->fmt))
>> +               cfg |= GSC_OUT_TILE_C_16x8 | GSC_OUT_TILE_MODE;
>> +
>>   end_set:
>>         writel(cfg, dev->regs + GSC_OUT_CON);
>>   }
>
>
> Thanks,
> Sylwester
