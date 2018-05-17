Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:46914 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750924AbeEQJlK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 05:41:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v9 6/8] media: vsp1: Refactor display list configure operations
Date: Thu, 17 May 2018 12:41:14 +0300
Message-ID: <1699268.4rpuBZgWBW@avalon>
In-Reply-To: <3c526da2424dda10560a0d40dc258263b54e122f.1525354160.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.76b8251c2457cea047ecba892cf0d7a351644051.1525354160.git-series.kieran.bingham+renesas@ideasonboard.com> <3c526da2424dda10560a0d40dc258263b54e122f.1525354160.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Thursday, 3 May 2018 16:35:45 EEST Kieran Bingham wrote:
> The entities provide a single .configure operation which configures the
> object into the target display list, based on the vsp1_entity_params
> selection.
> 
> Split the configure function into three parts, '.configure_stream()',
> '.configure_frame()', and '.configure_partition()' to facilitate
> splitting the configuration of each parameter class into separate
> display list bodies.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> ---
> The checkpatch warning:
> 
> WARNING: function definition argument 'struct vsp1_dl_list *' should
> also have an identifier name
> 
> has been ignored to match the existing code style.
> 
> v8:
>  - Add support for the UIF
>  - Remove unrelated whitespace change
>  - Fix comment location for clu_configure_stream()
>  - Update configure documentations
>  - Implement configure_partition separation.
> 
> v7
>  - Fix formatting and white space
>  - s/prepare/configure_stream/
>  - s/configure/configure_frame/
> ---
>  drivers/media/platform/vsp1/vsp1_brx.c    |  12 +-
>  drivers/media/platform/vsp1/vsp1_clu.c    |  77 ++----
>  drivers/media/platform/vsp1/vsp1_drm.c    |  12 +-
>  drivers/media/platform/vsp1/vsp1_entity.c |  24 ++-
>  drivers/media/platform/vsp1/vsp1_entity.h |  39 +--
>  drivers/media/platform/vsp1/vsp1_hgo.c    |  12 +-
>  drivers/media/platform/vsp1/vsp1_hgt.c    |  12 +-
>  drivers/media/platform/vsp1/vsp1_hsit.c   |  12 +-
>  drivers/media/platform/vsp1/vsp1_lif.c    |  12 +-
>  drivers/media/platform/vsp1/vsp1_lut.c    |  47 +---
>  drivers/media/platform/vsp1/vsp1_rpf.c    | 168 ++++++-------
>  drivers/media/platform/vsp1/vsp1_sru.c    |  12 +-
>  drivers/media/platform/vsp1/vsp1_uds.c    |  56 ++--
>  drivers/media/platform/vsp1/vsp1_uif.c    |  16 +-
>  drivers/media/platform/vsp1/vsp1_video.c  |  28 +--
>  drivers/media/platform/vsp1/vsp1_wpf.c    | 303 ++++++++++++-----------
>  16 files changed, 422 insertions(+), 420 deletions(-)

[snip]

> diff --git a/drivers/media/platform/vsp1/vsp1_clu.c
> b/drivers/media/platform/vsp1/vsp1_clu.c index ea83f1b7d125..0a978980d447
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_clu.c
> +++ b/drivers/media/platform/vsp1/vsp1_clu.c
> @@ -168,58 +168,50 @@ static const struct v4l2_subdev_ops clu_ops = {
>  /* ------------------------------------------------------------------------
>   * VSP1 Entity Operations
>   */
> +static void clu_configure_stream(struct vsp1_entity *entity,
> +				 struct vsp1_pipeline *pipe,
> +				 struct vsp1_dl_list *dl)
> +{
> +	struct vsp1_clu *clu = to_clu(&entity->subdev);
> +	struct v4l2_mbus_framefmt *format;
> 

I would have kept this blank line before the function.

> -static void clu_configure(struct vsp1_entity *entity,
> -			  struct vsp1_pipeline *pipe,
> -			  struct vsp1_dl_list *dl,
> -			  enum vsp1_entity_params params)
> +	/*
> +	 * The yuv_mode can't be changed during streaming. Cache it internally
> +	 * for future runtime configuration calls.
> +	 */
> +	format = vsp1_entity_get_pad_format(&clu->entity,
> +					    clu->entity.config,
> +					    CLU_PAD_SINK);
> +	clu->yuv_mode = format->code == MEDIA_BUS_FMT_AYUV8_1X32;
> +}

[snip]

> diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c
> b/drivers/media/platform/vsp1/vsp1_wpf.c index 65ed2f849551..da287c27b324
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_wpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_wpf.c

[snip]

> +static void wpf_configure_frame(struct vsp1_entity *entity,
> +				struct vsp1_pipeline *pipe,
> +				struct vsp1_dl_list *dl)
> +{
> +	struct vsp1_rwpf *wpf = to_rwpf(&entity->subdev);
> +	unsigned long flags;
> +	u32 outfmt = 0;

No need to initialize outfmt to 0.

> +

This blank line isn't needed.

> +	const unsigned int mask = BIT(WPF_CTRL_VFLIP)
> +				| BIT(WPF_CTRL_HFLIP);
> +
> +	spin_lock_irqsave(&wpf->flip.lock, flags);
> +	wpf->flip.active = (wpf->flip.active & ~mask)
> +			 | (wpf->flip.pending & mask);
> +	spin_unlock_irqrestore(&wpf->flip.lock, flags);
> +
> +	outfmt = (wpf->alpha << VI6_WPF_OUTFMT_PDV_SHIFT) | wpf->outfmt;
> +
> +	if (wpf->flip.active & BIT(WPF_CTRL_VFLIP))
> +		outfmt |= VI6_WPF_OUTFMT_FLP;
> +	if (wpf->flip.active & BIT(WPF_CTRL_HFLIP))
> +		outfmt |= VI6_WPF_OUTFMT_HFLP;
> +
> +	vsp1_wpf_write(wpf, dl, VI6_WPF_OUTFMT, outfmt);
> +}

[snip]

Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

If you agree with those small changes there's no need to resubmit, I'll fix 
when applying.

-- 
Regards,

Laurent Pinchart
