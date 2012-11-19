Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56304 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab2KSVfI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Nov 2012 16:35:08 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so1363711eek.19
        for <linux-media@vger.kernel.org>; Mon, 19 Nov 2012 13:35:07 -0800 (PST)
Message-ID: <50AAA609.2030007@gmail.com>
Date: Mon, 19 Nov 2012 22:35:05 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
CC: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	kgene.kim@samsung.com, shaik.samsung@gmail.com
Subject: Re: [PATCH] [media] exynos-gsc: Adding tiled multi-planar format
 to G-Scaler
References: <1352270227-8369-1-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1352270227-8369-1-git-send-email-shaik.ameer@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shaik,

On 11/07/2012 07:37 AM, Shaik Ameer Basha wrote:
> Adding V4L2_PIX_FMT_NV12MT_16X16 to G-Scaler supported formats.
> If the output or input format is V4L2_PIX_FMT_NV12MT_16X16, configure
> G-Scaler to use GSC_IN_TILE_MODE.
>
> Signed-off-by: Shaik Ameer Basha<shaik.ameer@samsung.com>
> ---
>   drivers/media/platform/exynos-gsc/gsc-core.c |    9 +++++++++
>   drivers/media/platform/exynos-gsc/gsc-core.h |    5 +++++
>   drivers/media/platform/exynos-gsc/gsc-regs.c |    6 ++++++
>   3 files changed, 20 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
> index cc7b218..00f1013 100644
> --- a/drivers/media/platform/exynos-gsc/gsc-core.c
> +++ b/drivers/media/platform/exynos-gsc/gsc-core.c
> @@ -185,6 +185,15 @@ static const struct gsc_fmt gsc_formats[] = {
>   		.corder		= GSC_CRCB,
>   		.num_planes	= 3,
>   		.num_comp	= 3,
> +	}, {
> +		.name		= "YUV 4:2:0 non-contig. 2p, Y/CbCr, tiled",

I have applied this patch to my tree for v3.8, and I've shortened this
description like this

		.name		= "YUV 4:2:0 n.c. 2p, Y/CbCr tiled",

so it fits in 32 char buffer.

There are some too long format descriptions in the driver already.
Please check output of VIDIOC_ENUM_FMT ioctl, for instance with
'v4l2-ctl --list-fmt'.

> +		.pixelformat	= V4L2_PIX_FMT_NV12MT_16X16,
> +		.depth		= { 8, 4 },
> +		.color		= GSC_YUV420,
> +		.yorder		= GSC_LSB_Y,
> +		.corder		= GSC_CBCR,
> +		.num_planes	= 2,
> +		.num_comp	= 2,
>   	}
>   };
>
> diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h b/drivers/media/platform/exynos-gsc/gsc-core.h
> index 5f157ef..cc19bba 100644
> --- a/drivers/media/platform/exynos-gsc/gsc-core.h
> +++ b/drivers/media/platform/exynos-gsc/gsc-core.h
> @@ -427,6 +427,11 @@ static inline void gsc_ctx_state_lock_clear(u32 state, struct gsc_ctx *ctx)
>   	spin_unlock_irqrestore(&ctx->gsc_dev->slock, flags);
>   }
>
> +static inline int is_tiled(const struct gsc_fmt *fmt)
> +{
> +	return fmt->pixelformat == V4L2_PIX_FMT_NV12MT_16X16;
> +}
> +
>   static inline void gsc_hw_enable_control(struct gsc_dev *dev, bool on)
>   {
>   	u32 cfg = readl(dev->regs + GSC_ENABLE);
> diff --git a/drivers/media/platform/exynos-gsc/gsc-regs.c b/drivers/media/platform/exynos-gsc/gsc-regs.c
> index 0146b35..6f5b5a4 100644
> --- a/drivers/media/platform/exynos-gsc/gsc-regs.c
> +++ b/drivers/media/platform/exynos-gsc/gsc-regs.c
> @@ -214,6 +214,9 @@ void gsc_hw_set_in_image_format(struct gsc_ctx *ctx)
>   		break;
>   	}
>
> +	if (is_tiled(frame->fmt))
> +		cfg |= GSC_IN_TILE_C_16x8 | GSC_IN_TILE_MODE;
> +
>   	writel(cfg, dev->regs + GSC_IN_CON);
>   }
>
> @@ -334,6 +337,9 @@ void gsc_hw_set_out_image_format(struct gsc_ctx *ctx)
>   		break;
>   	}
>
> +	if (is_tiled(frame->fmt))
> +		cfg |= GSC_OUT_TILE_C_16x8 | GSC_OUT_TILE_MODE;
> +
>   end_set:
>   	writel(cfg, dev->regs + GSC_OUT_CON);
>   }

Thanks,
Sylwester
