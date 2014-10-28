Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49101 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbaJ1XUA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Oct 2014 19:20:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/1] media: Print information on failed link validation
Date: Wed, 29 Oct 2014 01:20:06 +0200
Message-ID: <3033119.78jigqieeC@avalon>
In-Reply-To: <1414537804-25303-1-git-send-email-sakari.ailus@iki.fi>
References: <1412372439-4184-1-git-send-email-sakari.ailus@iki.fi> <1414537804-25303-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Wednesday 29 October 2014 01:10:04 Sakari Ailus wrote:
> From: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> The Media controller doesn't tell much to the user in cases such as pipeline
> startup failure. The link validation is the most common media graph (or in
> V4L2's case, format) related reason for the failure. In more complex
> pipelines the reason may not always be obvious to the user, so point them
> to look at the right direction.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> since v1:
> - Fix language in the second message.
> 
>  drivers/media/media-entity.c |   13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 37c334e..a4030c3 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -279,8 +279,14 @@ __must_check int media_entity_pipeline_start(struct
> media_entity *entity, continue;
> 
>  			ret = entity->ops->link_validate(link);
> -			if (ret < 0 && ret != -ENOIOCTLCMD)
> +			if (ret < 0 && ret != -ENOIOCTLCMD) {
> +				dev_dbg(entity->parent->dev,
> +					"link validation failed for \"%s\":%u -> \"%s\":%u, error 
%d\n",
> +					entity->name, link->source->index,
> +					link->sink->entity->name,
> +					link->sink->index, ret);
>  				goto error;
> +			}
>  		}
> 
>  		/* Either no links or validated links are fine. */
> @@ -288,6 +294,11 @@ __must_check int media_entity_pipeline_start(struct
> media_entity *entity,
> 
>  		if (!bitmap_full(active, entity->num_pads)) {
>  			ret = -EPIPE;
> +			dev_dbg(entity->parent->dev,
> +				"\"%s\":%u must be connected by an enabled link, error %d\n",
> +				entity->name,
> +				find_first_zero_bit(active, entity->num_pads),
> +				ret);

Given that ret is always set to -EPIPE, I wouldn't print ", error %d".

Apart from that,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  			goto error;
>  		}
>  	}

-- 
Regards,

Laurent Pinchart

