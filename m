Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57895 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751095AbeDDJeX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Apr 2018 05:34:23 -0400
Message-ID: <1522834461.5562.13.camel@pengutronix.de>
Subject: Re: [PATCH] media: platform: video-mux: propagate format from sink
 to source
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Chris Lesiak <chris.lesiak@licor.com>, linux-media@vger.kernel.org
Date: Wed, 04 Apr 2018 11:34:21 +0200
In-Reply-To: <20180403195022.31188-1-chris.lesiak@licor.com>
References: <20180403195022.31188-1-chris.lesiak@licor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chris,

On Tue, 2018-04-03 at 14:50 -0500, Chris Lesiak wrote:
> Propagate the v4l2_mbus_framefmt to the source pad when either a sink
> pad is activated or when the format of the active sink pad changes.

Thank you, this fixes the V4L2_SUBDEV_FORMAT_TRY use case as well as
propagation of the active format when the user calls VIDIOC_SUBDEV_S_FMT
on the sink pad and then only VIDIOC_SUBDEV_G_FMT on the source pad.

> Signed-off-by: Chris Lesiak <chris.lesiak@licor.com>
> ---
>  drivers/media/platform/video-mux.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/video-mux.c b/drivers/media/platform/video-mux.c
> index ee89ad76bee2..1fb887293337 100644
> --- a/drivers/media/platform/video-mux.c
> +++ b/drivers/media/platform/video-mux.c
> @@ -45,6 +45,7 @@ static int video_mux_link_setup(struct media_entity *entity,
>  {
>  	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
>  	struct video_mux *vmux = v4l2_subdev_to_video_mux(sd);
> +	u16 source_pad = entity->num_pads - 1;
>  	int ret = 0;
>  
>  	/*
> @@ -74,6 +75,9 @@ static int video_mux_link_setup(struct media_entity *entity,
>  		if (ret < 0)
>  			goto out;
>  		vmux->active = local->index;
> +
> +		/* Propagate the active format to the source */
> +		vmux->format_mbus[source_pad] = vmux->format_mbus[vmux->active];
>  	} else {
>  		if (vmux->active != local->index)
>  			goto out;
> @@ -162,14 +166,20 @@ static int video_mux_set_format(struct v4l2_subdev *sd,
>  			    struct v4l2_subdev_format *sdformat)
>  {
>  	struct video_mux *vmux = v4l2_subdev_to_video_mux(sd);
> -	struct v4l2_mbus_framefmt *mbusformat;
> +	struct v4l2_mbus_framefmt *mbusformat, *source_mbusformat;
>  	struct media_pad *pad = &vmux->pads[sdformat->pad];
> +	u16 source_pad = sd->entity.num_pads - 1;
>  
>  	mbusformat = __video_mux_get_pad_format(sd, cfg, sdformat->pad,
>  					    sdformat->which);
>  	if (!mbusformat)
>  		return -EINVAL;
>  
> +	source_mbusformat = __video_mux_get_pad_format(sd, cfg, source_pad,
> +						       sdformat->which);
> +	if (!source_mbusformat)
> +		return -EINVAL;
> +
>  	mutex_lock(&vmux->lock);

This is superfluous if pad->index != vmux->active and the same as
mbusformat for the source pad, but I think to achieve easily readable
code, this is ok.

>  	/* Source pad mirrors active sink pad, no limitations on sink pads */
> @@ -178,6 +188,10 @@ static int video_mux_set_format(struct v4l2_subdev *sd,
>  
>  	*mbusformat = sdformat->format;
>  
> +	/* Propagate the format from an active sink to source */
> +	if ((pad->flags & MEDIA_PAD_FL_SINK) && (pad->index == vmux->active))

The flags check could be removed. It is not necessary since vmux->active 
is never set to the source pad index.

> +		*source_mbusformat = sdformat->format;
> +
>  	mutex_unlock(&vmux->lock);
>  
>  	return 0;

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
