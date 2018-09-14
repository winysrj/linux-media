Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34314 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726868AbeINPji (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 11:39:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] media: vsp1: Correct the pitch on multiplanar formats
Date: Fri, 14 Sep 2018 13:25:59 +0300
Message-ID: <4407219.HP1UPh24hA@avalon>
In-Reply-To: <20180831144044.31713-3-kieran.bingham+renesas@ideasonboard.com>
References: <20180831144044.31713-1-kieran.bingham+renesas@ideasonboard.com> <20180831144044.31713-3-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Friday, 31 August 2018 17:40:40 EEST Kieran Bingham wrote:
> DRM pipelines now support tri-planar as well as packed formats with
> YCbCr, however the pitch calculation was not updated to support this.
> 
> Correct this by adjusting the bytesperline accordingly when 3 planes are
> used.
> 
> Fixes: 7863ac504bc5 ("drm: rcar-du: Add tri-planar memory formats support")
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

I already have a similar patch from Matsuoka-san in my tree, please see 
https://patchwork.kernel.org/patch/10425565/. I'll update it with the fixes 
tag.

> ---
>  drivers/media/platform/vsp1/vsp1_drm.c | 10 ++++++++++
>  include/media/vsp1.h                   |  2 +-
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c
> b/drivers/media/platform/vsp1/vsp1_drm.c index b9c0f695d002..b9afd98f6867
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -814,6 +814,16 @@ int vsp1_du_atomic_update(struct device *dev, unsigned
> int pipe_index, rpf->format.num_planes = fmtinfo->planes;
>  	rpf->format.plane_fmt[0].bytesperline = cfg->pitch;
>  	rpf->format.plane_fmt[1].bytesperline = cfg->pitch;
> +
> +	/*
> +	 * Packed YUV formats are subsampled, but the packing of two components
> +	 * into a single plane compensates for this leaving the bytesperline
> +	 * to be the correct value. For multiplanar formats we must adjust the
> +	 * pitch accordingly.
> +	 */
> +	if (fmtinfo->planes == 3)
> +		rpf->format.plane_fmt[1].bytesperline /= fmtinfo->hsub;
> +
>  	rpf->alpha = cfg->alpha;
> 
>  	rpf->mem.addr[0] = cfg->mem[0];
> diff --git a/include/media/vsp1.h b/include/media/vsp1.h
> index 3093b9cb9067..0ce19b595cc7 100644
> --- a/include/media/vsp1.h
> +++ b/include/media/vsp1.h
> @@ -46,7 +46,7 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int
> pipe_index, /**
>   * struct vsp1_du_atomic_config - VSP atomic configuration parameters
>   * @pixelformat: plane pixel format (V4L2 4CC)
> - * @pitch: line pitch in bytes, for all planes
> + * @pitch: line pitch in bytes

Should I update the above-mentioned patch with this as well ? How about 
phrasing it as "line pitch in bytes for the first plane" ?

>   * @mem: DMA memory address for each plane of the frame buffer
>   * @src: source rectangle in the frame buffer (integer coordinates)
>   * @dst: destination rectangle on the display (integer coordinates)

-- 
Regards,

Laurent Pinchart
