Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:45141 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751542AbeBWIZ7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Feb 2018 03:25:59 -0500
Received: by mail-lf0-f68.google.com with SMTP id x196so11195263lfd.12
        for <linux-media@vger.kernel.org>; Fri, 23 Feb 2018 00:25:59 -0800 (PST)
Date: Fri, 23 Feb 2018 09:25:56 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v2] v4l: vsp1: Print the correct blending unit name in
 debug messages
Message-ID: <20180223082556.GE6373@bigcity.dyn.berto.se>
References: <20180222205226.3099-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180222205226.3099-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your patch.

On 2018-02-22 22:52:26 +0200, Laurent Pinchart wrote:
> The DRM pipelines can use either the BRU or the BRS for blending. Make
> sure the right name is used in debugging messages to avoid confusion.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Reviewed-by: Niklas S�derlund <niklas.soderlund+renesas@ragnatech.se>

> ---
> Changes since v1:
> 
> - Create a macro to get the right entity name instead of duplicating the
>   same code all over the driver
> ---
>  drivers/media/platform/vsp1/vsp1_drm.c | 21 ++++++++-------------
>  1 file changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index ac85942162c1..b8fee1834253 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -27,6 +27,7 @@
>  #include "vsp1_pipe.h"
>  #include "vsp1_rwpf.h"
>  
> +#define BRU_NAME(e)	(e)->type == VSP1_ENTITY_BRU ? "BRU" : "BRS"
>  
>  /* -----------------------------------------------------------------------------
>   * Interrupt Handling
> @@ -88,7 +89,6 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
>  	struct vsp1_entity *next;
>  	struct vsp1_dl_list *dl;
>  	struct v4l2_subdev_format format;
> -	const char *bru_name;
>  	unsigned long flags;
>  	unsigned int i;
>  	int ret;
> @@ -99,7 +99,6 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
>  	drm_pipe = &vsp1->drm->pipe[pipe_index];
>  	pipe = &drm_pipe->pipe;
>  	bru = to_bru(&pipe->bru->subdev);
> -	bru_name = pipe->bru->type == VSP1_ENTITY_BRU ? "BRU" : "BRS";
>  
>  	if (!cfg) {
>  		/*
> @@ -165,7 +164,7 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
>  
>  		dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on %s pad %u\n",
>  			__func__, format.format.width, format.format.height,
> -			format.format.code, bru_name, i);
> +			format.format.code, BRU_NAME(pipe->bru), i);
>  	}
>  
>  	format.pad = pipe->bru->source_pad;
> @@ -181,7 +180,7 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
>  
>  	dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on %s pad %u\n",
>  		__func__, format.format.width, format.format.height,
> -		format.format.code, bru_name, i);
> +		format.format.code, BRU_NAME(pipe->bru), i);
>  
>  	format.pad = RWPF_PAD_SINK;
>  	ret = v4l2_subdev_call(&pipe->output->entity.subdev, pad, set_fmt, NULL,
> @@ -473,9 +472,9 @@ static int vsp1_du_setup_rpf_pipe(struct vsp1_device *vsp1,
>  	if (ret < 0)
>  		return ret;
>  
> -	dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on BRU pad %u\n",
> +	dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on %s pad %u\n",
>  		__func__, format.format.width, format.format.height,
> -		format.format.code, format.pad);
> +		format.format.code, BRU_NAME(pipe->bru), format.pad);
>  
>  	sel.pad = bru_input;
>  	sel.target = V4L2_SEL_TGT_COMPOSE;
> @@ -486,10 +485,9 @@ static int vsp1_du_setup_rpf_pipe(struct vsp1_device *vsp1,
>  	if (ret < 0)
>  		return ret;
>  
> -	dev_dbg(vsp1->dev,
> -		"%s: set selection (%u,%u)/%ux%u on BRU pad %u\n",
> +	dev_dbg(vsp1->dev, "%s: set selection (%u,%u)/%ux%u on %s pad %u\n",
>  		__func__, sel.r.left, sel.r.top, sel.r.width, sel.r.height,
> -		sel.pad);
> +		BRU_NAME(pipe->bru), sel.pad);
>  
>  	return 0;
>  }
> @@ -514,12 +512,9 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)
>  	struct vsp1_entity *entity;
>  	struct vsp1_entity *next;
>  	struct vsp1_dl_list *dl;
> -	const char *bru_name;
>  	unsigned int i;
>  	int ret;
>  
> -	bru_name = pipe->bru->type == VSP1_ENTITY_BRU ? "BRU" : "BRS";
> -
>  	/* Prepare the display list. */
>  	dl = vsp1_dl_list_get(pipe->output->dlm);
>  
> @@ -570,7 +565,7 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)
>  		rpf->entity.sink_pad = i;
>  
>  		dev_dbg(vsp1->dev, "%s: connecting RPF.%u to %s:%u\n",
> -			__func__, rpf->entity.index, bru_name, i);
> +			__func__, rpf->entity.index, BRU_NAME(pipe->bru), i);
>  
>  		ret = vsp1_du_setup_rpf_pipe(vsp1, pipe, rpf, i);
>  		if (ret < 0)
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Regards,
Niklas S�derlund
