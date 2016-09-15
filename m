Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52628 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751031AbcIOUyk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 16:54:40 -0400
Date: Thu, 15 Sep 2016 23:54:04 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Helen Koike <helen.koike@collabora.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH] [v4l-utils] libv4l2subdev: Propagate format deep in the
 topology
Message-ID: <20160915205404.GH5086@valkosipuli.retiisi.org.uk>
References: <5776a3af5046c55b4efa3b936a1ca68466098207.1473796687.git.helen.koike@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5776a3af5046c55b4efa3b936a1ca68466098207.1473796687.git.helen.koike@collabora.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helen,

Thanks for the patch!

On Tue, Sep 13, 2016 at 05:09:58PM -0300, Helen Koike wrote:
> The format was only being propagated to the subdevices directly
> connected to the node being changed.
> Continue propagating the format to all the subdevices in the video pipe.
> 
> Signed-off-by: Helen Koike <helen.koike@collabora.com>
> ---
> 
> Only one level of propagation was not that useful for me so I made it to completely
> propagate the format through the topology, I hope this patch to be useful to others.

I'd say most of the time a single sub-device is configured at a time --- the
current implementation does set the format set by the user on a source pad
on the sink pad at the other end of an enabled link as well, but that's just
for the convenience.

Your patch changes this to do a lot more than that. I'm not saying that the
functionality isn't needed, but it would have to be behind a specific flag
as it only caters for the needs of a somewhat special case: you wish to
propagate the same format all the way to the end of the pipeline.
Additionally, just changing the behaviour does break the existing users of
media-ctl.

Sub-devices propagate the cropping and composing (i.e. scaling)
configuration downstream inside a single sub-device. This (very likely)
consequently changes the format on the source pads as well, and should be
similarly propagated downstream.

I think how this could be added to media-ctl is by adding a new command line
option, and amending the functionality with propagating the selections as
well.

The propagation should only be performed after full configuration of a
sub-device is done: a single command line may well first change the format
on a sub-device sink pad, then cropping and finally composition
configuration, all of which are internally propagated in the sub-device
before the following configuration step is taken. I don't think we wish to
propagate each step over the full pipeline downstream.

As per where would I put this --- I'm not fully certain libv4l2subdev is the
right place for the functionality, at least it'd widen the scope for the
library somewhat. I started writing (but unfortunately not being able to
finish it) a pipeline configuration library with the intent of providing
functionality of a regular V4L2 device node on a device the full
configuration (links, sub-device formats etc.) is up to the user. The
library was called libautopipe, I think this could be a beginning of such a
library.

I wonder what Laurent thinks.

> 
>  utils/media-ctl/libv4l2subdev.c | 43 +++++++++++++++++++++++------------------
>  1 file changed, 24 insertions(+), 19 deletions(-)
> 
> diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
> index 3dcf943..8333557 100644
> --- a/utils/media-ctl/libv4l2subdev.c
> +++ b/utils/media-ctl/libv4l2subdev.c
> @@ -644,6 +644,28 @@ static int set_frame_interval(struct media_entity *entity,
>  	return 0;
>  }
>  
> +static void propagate_set_fmt(struct media_entity *entity)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < entity->num_links; ++i) {
> +		struct media_link *link = &entity->links[i];
> +		struct v4l2_mbus_framefmt format;
> +
> +		if (!(link->flags & MEDIA_LNK_FL_ENABLED))
> +			continue;
> +
> +		/* If we found a source pad, propagate it's format to the remote sink */
> +		if (link->source->entity == entity &&
> +		    link->sink->entity->info.type == MEDIA_ENT_T_V4L2_SUBDEV) {
> +
> +			v4l2_subdev_get_format(entity, &format, link->source->index,
> +						V4L2_SUBDEV_FORMAT_ACTIVE);
> +			set_format(link->sink, &format);
> +			propagate_set_fmt(link->sink->entity);
> +		}
> +	}
> +}
>  
>  static int v4l2_subdev_parse_setup_format(struct media_device *media,
>  					  const char *p, char **endp)
> @@ -653,7 +675,6 @@ static int v4l2_subdev_parse_setup_format(struct media_device *media,
>  	struct v4l2_rect crop = { -1, -1, -1, -1 };
>  	struct v4l2_rect compose = crop;
>  	struct v4l2_fract interval = { 0, 0 };
> -	unsigned int i;
>  	char *end;
>  	int ret;
>  
> @@ -690,24 +711,8 @@ static int v4l2_subdev_parse_setup_format(struct media_device *media,
>  		return ret;
>  
>  
> -	/* If the pad is an output pad, automatically set the same format on
> -	 * the remote subdev input pads, if any.
> -	 */
> -	if (pad->flags & MEDIA_PAD_FL_SOURCE) {
> -		for (i = 0; i < pad->entity->num_links; ++i) {
> -			struct media_link *link = &pad->entity->links[i];
> -			struct v4l2_mbus_framefmt remote_format;
> -
> -			if (!(link->flags & MEDIA_LNK_FL_ENABLED))
> -				continue;
> -
> -			if (link->source == pad &&
> -			    link->sink->entity->info.type == MEDIA_ENT_T_V4L2_SUBDEV) {
> -				remote_format = format;
> -				set_format(link->sink, &remote_format);
> -			}
> -		}
> -	}
> +	/* Automaticaly propagate formats through the video pipe */
> +	propagate_set_fmt(pad->entity);
>  
>  	*endp = end;
>  	return 0;
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
