Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48262 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750827AbeBWMPI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Feb 2018 07:15:08 -0500
Subject: Re: [PATCH v2] v4l: vsp1: Print the correct blending unit name in
 debug messages
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
References: <20180222205226.3099-1-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <da94f2fc-f95a-592d-a968-3f979c973b94@ideasonboard.com>
Date: Fri, 23 Feb 2018 12:15:03 +0000
MIME-Version: 1.0
In-Reply-To: <20180222205226.3099-1-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thankyou for the patch (update).

On 22/02/18 20:52, Laurent Pinchart wrote:
> The DRM pipelines can use either the BRU or the BRS for blending. Make
> sure the right name is used in debugging messages to avoid confusion.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

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
> 
