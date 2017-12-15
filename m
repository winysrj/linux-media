Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44083 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756194AbdLOKNK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 05:13:10 -0500
Subject: Re: [PATCH 2/9] v4l: vsp1: Print the correct blending unit name in
 debug messages
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org
References: <20171203105735.10529-1-laurent.pinchart+renesas@ideasonboard.com>
 <20171203105735.10529-3-laurent.pinchart+renesas@ideasonboard.com>
Reply-To: kieran.bingham@ideasonboard.com
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <e20b4d4a-9e97-e825-9c15-824224819156@ideasonboard.com>
Date: Fri, 15 Dec 2017 10:13:06 +0000
MIME-Version: 1.0
In-Reply-To: <20171203105735.10529-3-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 03/12/17 10:57, Laurent Pinchart wrote:
> The DRM pipelines can use either the BRU or the BRS for blending. Make
> sure the right name is used in debugging messages to avoid confusion.

This could likely tag along with the preceding [PATCH 1/9] on it's short cut to
mainline before the rest of the CRC series is reviewed.

> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/vsp1/vsp1_drm.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index ac85942162c1..0fe541084f5c 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -400,8 +400,11 @@ static int vsp1_du_setup_rpf_pipe(struct vsp1_device *vsp1,
>  	struct v4l2_subdev_selection sel;
>  	struct v4l2_subdev_format format;
>  	const struct v4l2_rect *crop;
> +	const char *bru_name;
>  	int ret;
>  
> +	bru_name = pipe->bru->type == VSP1_ENTITY_BRU ? "BRU" : "BRS";
> +
>  	/*
>  	 * Configure the format on the RPF sink pad and propagate it up to the
>  	 * BRU sink pad.
> @@ -473,9 +476,9 @@ static int vsp1_du_setup_rpf_pipe(struct vsp1_device *vsp1,
>  	if (ret < 0)
>  		return ret;
>  
> -	dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on BRU pad %u\n",
> +	dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on %s pad %u\n",
>  		__func__, format.format.width, format.format.height,
> -		format.format.code, format.pad);
> +		format.format.code, bru_name, format.pad);
>  
>  	sel.pad = bru_input;
>  	sel.target = V4L2_SEL_TGT_COMPOSE;
> @@ -486,10 +489,9 @@ static int vsp1_du_setup_rpf_pipe(struct vsp1_device *vsp1,
>  	if (ret < 0)
>  		return ret;
>  
> -	dev_dbg(vsp1->dev,
> -		"%s: set selection (%u,%u)/%ux%u on BRU pad %u\n",
> +	dev_dbg(vsp1->dev, "%s: set selection (%u,%u)/%ux%u on %s pad %u\n",
>  		__func__, sel.r.left, sel.r.top, sel.r.width, sel.r.height,
> -		sel.pad);
> +		bru_name, sel.pad);
>  
>  	return 0;
>  }
> 
