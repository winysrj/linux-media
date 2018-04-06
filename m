Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36203 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751417AbeDFXzh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Apr 2018 19:55:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v7 7/8] media: vsp1: Adapt entities to configure into a body
Date: Sat, 07 Apr 2018 02:55:35 +0300
Message-ID: <2913291.xUNrKpSUYI@avalon>
In-Reply-To: <c192724a85e17f984e5fa7e5af871eb33bc19384.1520466993.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.636c1ee27fc6973cc312e0f25131a435872a0a35.1520466993.git-series.kieran.bingham+renesas@ideasonboard.com> <c192724a85e17f984e5fa7e5af871eb33bc19384.1520466993.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Thursday, 8 March 2018 02:05:30 EEST Kieran Bingham wrote:
> Currently the entities store their configurations into a display list.
> Adapt this such that the code can be configured into a body directly,
> allowing greater flexibility and control of the content.
> 
> All users of vsp1_dl_list_write() are removed in this process, thus it
> too is removed.
> 
> A helper, vsp1_dl_list_get_body0() is provided to access the internal body0
> from the display list.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> ---
> v7
>  - Rebase
>  - s/prepare/configure_stream/
>  - s/configure/configure_frame/
> 
>  drivers/media/platform/vsp1/vsp1_bru.c    | 22 ++++++-------
>  drivers/media/platform/vsp1/vsp1_clu.c    | 22 ++++++-------
>  drivers/media/platform/vsp1/vsp1_dl.c     | 12 ++-----
>  drivers/media/platform/vsp1/vsp1_dl.h     |  2 +-
>  drivers/media/platform/vsp1/vsp1_drm.c    | 20 +++++++----
>  drivers/media/platform/vsp1/vsp1_entity.c | 15 ++++-----
>  drivers/media/platform/vsp1/vsp1_entity.h | 11 +++---
>  drivers/media/platform/vsp1/vsp1_hgo.c    | 16 ++++-----
>  drivers/media/platform/vsp1/vsp1_hgt.c    | 18 +++++-----
>  drivers/media/platform/vsp1/vsp1_hsit.c   | 10 +++---
>  drivers/media/platform/vsp1/vsp1_lif.c    | 15 ++++-----
>  drivers/media/platform/vsp1/vsp1_lut.c    | 21 ++++++------
>  drivers/media/platform/vsp1/vsp1_pipe.c   |  4 +-
>  drivers/media/platform/vsp1/vsp1_pipe.h   |  3 +-
>  drivers/media/platform/vsp1/vsp1_rpf.c    | 39 +++++++++++-----------
>  drivers/media/platform/vsp1/vsp1_sru.c    | 14 ++++----
>  drivers/media/platform/vsp1/vsp1_uds.c    | 24 +++++++-------
>  drivers/media/platform/vsp1/vsp1_uds.h    |  2 +-
>  drivers/media/platform/vsp1/vsp1_video.c  | 11 ++++--
>  drivers/media/platform/vsp1/vsp1_wpf.c    | 42 ++++++++++++------------
>  20 files changed, 172 insertions(+), 151 deletions(-)

[snip]

> diff --git a/drivers/media/platform/vsp1/vsp1_uds.c
> b/drivers/media/platform/vsp1/vsp1_uds.c index ce1731c2b3a9..6ddfce4bd095
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_uds.c
> +++ b/drivers/media/platform/vsp1/vsp1_uds.c
> @@ -31,22 +31,23 @@
>   * Device Access
>   */
> 
> -static inline void vsp1_uds_write(struct vsp1_uds *uds, struct vsp1_dl_list
> *dl,
> -				  u32 reg, u32 data)
> +static inline void vsp1_uds_write(struct vsp1_uds *uds,
> +				  struct vsp1_dl_body *dlb, u32 reg, u32 data)
>  {
> -	vsp1_dl_list_write(dl, reg + uds->entity.index * VI6_UDS_OFFSET, data);
> +	vsp1_dl_body_write(dlb, reg + uds->entity.index * VI6_UDS_OFFSET,
> +			       data);

This can hold on a single line.

>  }

[snip]

> diff --git a/drivers/media/platform/vsp1/vsp1_video.c
> b/drivers/media/platform/vsp1/vsp1_video.c index 1b5a31734834..b47708660e53
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c

[snip]

> @@ -802,6 +804,9 @@ static int vsp1_video_setup_pipeline(struct
> vsp1_pipeline *pipe) if (!pipe->dl)
>  		return -ENOMEM;
> 
> +	/* Retrieve the default DLB from the list */

s/list/list./

> +	dlb = vsp1_dl_list_get_body0(pipe->dl);
> +
>  	if (pipe->uds) {
>  		struct vsp1_uds *uds = to_uds(&pipe->uds->subdev);
> 
> @@ -824,8 +829,8 @@ static int vsp1_video_setup_pipeline(struct
> vsp1_pipeline *pipe) }
> 
>  	list_for_each_entry(entity, &pipe->entities, list_pipe) {
> -		vsp1_entity_route_setup(entity, pipe, pipe->dl);
> -		vsp1_entity_configure_stream(entity, pipe, pipe->dl);
> +		vsp1_entity_route_setup(entity, pipe, dlb);
> +		vsp1_entity_configure_stream(entity, pipe, dlb);
>  	}
> 
>  	return 0;
> diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c
> b/drivers/media/platform/vsp1/vsp1_wpf.c index 6a6cdf0fb5f1..68218625549e
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_wpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_wpf.c
> @@ -31,9 +31,10 @@
>   */
> 
>  static inline void vsp1_wpf_write(struct vsp1_rwpf *wpf,
> -				  struct vsp1_dl_list *dl, u32 reg, u32 data)
> +				  struct vsp1_dl_body *dlb, u32 reg, u32 data)
>  {
> -	vsp1_dl_list_write(dl, reg + wpf->entity.index * VI6_WPF_OFFSET, data);
> +	vsp1_dl_body_write(dlb, reg + wpf->entity.index * VI6_WPF_OFFSET,
> +			       data);

This can hold on a single line.

>  }

[snip]

> @@ -292,10 +293,10 @@ static void wpf_configure_stream(struct vsp1_entity
> *entity,
> 
>  	wpf->outfmt = outfmt;
> 
> -	vsp1_dl_list_write(dl, VI6_DPR_WPF_FPORCH(wpf->entity.index),
> -			   VI6_DPR_WPF_FPORCH_FP_WPFN);
> +	vsp1_dl_body_write(dlb, VI6_DPR_WPF_FPORCH(wpf->entity.index),
> +			       VI6_DPR_WPF_FPORCH_FP_WPFN);

Strange indentation.

> 
> -	vsp1_dl_list_write(dl, VI6_WPF_WRBCK_CTRL, 0);
> +	vsp1_dl_body_write(dlb, VI6_WPF_WRBCK_CTRL, 0);
> 
>  	/*
>  	 * Sources. If the pipeline has a single input and BRU is not used,
> @@ -319,17 +320,18 @@ static void wpf_configure_stream(struct vsp1_entity
> *entity, ? VI6_WPF_SRCRPF_VIRACT_MST
> 
>  			: VI6_WPF_SRCRPF_VIRACT2_MST;
> 
> -	vsp1_wpf_write(wpf, dl, VI6_WPF_SRCRPF, srcrpf);
> +	vsp1_wpf_write(wpf, dlb, VI6_WPF_SRCRPF, srcrpf);
> 
>  	/* Enable interrupts */
> -	vsp1_dl_list_write(dl, VI6_WPF_IRQ_STA(wpf->entity.index), 0);
> -	vsp1_dl_list_write(dl, VI6_WPF_IRQ_ENB(wpf->entity.index),
> -			   VI6_WFP_IRQ_ENB_DFEE);
> +	vsp1_dl_body_write(dlb, VI6_WPF_IRQ_STA(wpf->entity.index), 0);
> +	vsp1_dl_body_write(dlb, VI6_WPF_IRQ_ENB(wpf->entity.index),
> +			       VI6_WFP_IRQ_ENB_DFEE);

Here too.

>  }

[snip]

With those small issues fixed,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart
