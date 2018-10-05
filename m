Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59295 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727036AbeJEQq6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 12:46:58 -0400
Message-ID: <1538732937.3545.8.camel@pengutronix.de>
Subject: Re: [PATCH v4 03/11] gpu: ipu-v3: Add planar support to interlaced
 scan
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "open list:DRM DRIVERS FOR FREESCALE IMX"
        <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>
Date: Fri, 05 Oct 2018 11:48:57 +0200
In-Reply-To: <20181004185401.15751-4-slongerbeam@gmail.com>
References: <20181004185401.15751-1-slongerbeam@gmail.com>
         <20181004185401.15751-4-slongerbeam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2018-10-04 at 11:53 -0700, Steve Longerbeam wrote:
> To support interlaced scan with planar formats, cpmem SLUV must
> be programmed with the correct chroma line stride. For full and
> partial planar 4:2:2 (YUV422P, NV16), chroma line stride must
> be doubled. For full and partial planar 4:2:0 (YUV420, YVU420, NV12),
> chroma line stride must _not_ be doubled, since a single chroma line
> is shared by two luma lines.
> 
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> ---
>  drivers/gpu/ipu-v3/ipu-cpmem.c              | 26 +++++++++++++++++++--
>  drivers/staging/media/imx/imx-ic-prpencvf.c |  3 ++-
>  drivers/staging/media/imx/imx-media-csi.c   |  3 ++-
>  include/video/imx-ipu-v3.h                  |  3 ++-
>  4 files changed, 30 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpu/ipu-v3/ipu-cpmem.c b/drivers/gpu/ipu-v3/ipu-cpmem.c
> index a9d2501500a1..d41df8034c5b 100644
> --- a/drivers/gpu/ipu-v3/ipu-cpmem.c
> +++ b/drivers/gpu/ipu-v3/ipu-cpmem.c
> @@ -273,9 +273,10 @@ void ipu_cpmem_set_uv_offset(struct ipuv3_channel *ch, u32 u_off, u32 v_off)
>  }
>  EXPORT_SYMBOL_GPL(ipu_cpmem_set_uv_offset);
>  
> -void ipu_cpmem_interlaced_scan(struct ipuv3_channel *ch, int stride)
> +void ipu_cpmem_interlaced_scan(struct ipuv3_channel *ch, int stride,
> +			       u32 pixelformat)
>  {
> -	u32 ilo, sly;
> +	u32 ilo, sly, sluv;
>  
>  	if (stride < 0) {
>  		stride = -stride;
> @@ -286,9 +287,30 @@ void ipu_cpmem_interlaced_scan(struct ipuv3_channel *ch, int stride)
>  
>  	sly = (stride * 2) - 1;
>  
> +	switch (pixelformat) {
> +	case V4L2_PIX_FMT_YUV420:
> +	case V4L2_PIX_FMT_YVU420:
> +		sluv = stride / 2 - 1;
> +		break;
> +	case V4L2_PIX_FMT_NV12:
> +		sluv = stride - 1;
> +		break;
> +	case V4L2_PIX_FMT_YUV422P:
> +		sluv = stride - 1;
> +		break;
> +	case V4L2_PIX_FMT_NV16:
> +		sluv = stride * 2 - 1;
> +		break;
> +	default:
> +		sluv = 0;
> +		break;
> +	}
> +
>  	ipu_ch_param_write_field(ch, IPU_FIELD_SO, 1);
>  	ipu_ch_param_write_field(ch, IPU_FIELD_ILO, ilo);
>  	ipu_ch_param_write_field(ch, IPU_FIELD_SLY, sly);
> +	if (sluv)
> +		ipu_ch_param_write_field(ch, IPU_FIELD_SLUV, sluv);
>  };
>  EXPORT_SYMBOL_GPL(ipu_cpmem_interlaced_scan);
[...]

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

and

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

to be merged with the rest of the series via the media tree. I'll take
care not to introduce nontrivial conflicts in imx-drm.

regards
Philipp
