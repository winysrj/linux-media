Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58633 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752876AbeC1PBY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 11:01:24 -0400
Subject: Re: [PATCH 09/15] v4l: vsp1: Replace manual DRM pipeline input setup
 in vsp1_du_setup_lif
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org
References: <20180226214516.11559-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180226214516.11559-10-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <52699ae7-c093-1f2a-5ae1-b6b847952294@ideasonboard.com>
Date: Wed, 28 Mar 2018 16:01:20 +0100
MIME-Version: 1.0
In-Reply-To: <20180226214516.11559-10-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 26/02/18 21:45, Laurent Pinchart wrote:
> The vsp1_du_setup_lif() function setups the DRM pipeline input manually.

s/ setups the / sets up the /

> This duplicates the code from the vsp1_du_pipeline_setup_input()
> function. Replace the manual implementation by a call to the function.
> 
> As the pipeline has no enabled input in vsp1_du_setup_lif(), the
> vsp1_du_pipeline_setup_input() function will not setup any RPF, and will
> thus not setup formats on the BRU sink pads. This isn't a problem as all
> inputs are disabled, and the BRU sink pads will be reconfigured from the
> atomic commit handler when inputs will be enabled.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Aside from the above,

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/vsp1/vsp1_drm.c | 40 +++++-----------------------------
>  1 file changed, 6 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index 6ad8aa6c8138..00ce99bd1605 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -412,47 +412,19 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
>  	dev_dbg(vsp1->dev, "%s: configuring LIF%u with format %ux%u\n",
>  		__func__, pipe_index, cfg->width, cfg->height);
>  
> -	/*
> -	 * Configure the format at the BRU sinks and propagate it through the
> -	 * pipeline.
> -	 */
> +	/* Setup formats through the pipeline. */
> +	ret = vsp1_du_pipeline_setup_input(vsp1, pipe);
> +	if (ret < 0)
> +		return ret;
> +
>  	memset(&format, 0, sizeof(format));
>  	format.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> -
> -	for (i = 0; i < pipe->bru->source_pad; ++i) {
> -		format.pad = i;
> -
> -		format.format.width = cfg->width;
> -		format.format.height = cfg->height;
> -		format.format.code = MEDIA_BUS_FMT_ARGB8888_1X32;
> -		format.format.field = V4L2_FIELD_NONE;
> -
> -		ret = v4l2_subdev_call(&pipe->bru->subdev, pad,
> -				       set_fmt, NULL, &format);
> -		if (ret < 0)
> -			return ret;
> -
> -		dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on %s pad %u\n",
> -			__func__, format.format.width, format.format.height,
> -			format.format.code, BRU_NAME(pipe->bru), i);
> -	}
> -
> -	format.pad = pipe->bru->source_pad;
> +	format.pad = RWPF_PAD_SINK;
>  	format.format.width = cfg->width;
>  	format.format.height = cfg->height;
>  	format.format.code = MEDIA_BUS_FMT_ARGB8888_1X32;
>  	format.format.field = V4L2_FIELD_NONE;
>  
> -	ret = v4l2_subdev_call(&pipe->bru->subdev, pad, set_fmt, NULL,
> -			       &format);
> -	if (ret < 0)
> -		return ret;
> -
> -	dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on %s pad %u\n",
> -		__func__, format.format.width, format.format.height,
> -		format.format.code, BRU_NAME(pipe->bru), i);
> -
> -	format.pad = RWPF_PAD_SINK;
>  	ret = v4l2_subdev_call(&pipe->output->entity.subdev, pad, set_fmt, NULL,
>  			       &format);
>  	if (ret < 0)
> 
