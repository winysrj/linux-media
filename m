Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60484 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab2JVKzk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Oct 2012 06:55:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] omap3isp: Find source pad from external entity
Date: Mon, 22 Oct 2012 12:56:30 +0200
Message-ID: <1393695.KmiVKK1Qa1@avalon>
In-Reply-To: <1350769698-24752-2-git-send-email-sakari.ailus@iki.fi>
References: <20121020214803.GR21261@valkosipuli.retiisi.org.uk> <1350769698-24752-2-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Sunday 21 October 2012 00:48:18 Sakari Ailus wrote:
> No longer assume pad number 0 is the source pad of the external entity. Find
> the source pad from the external entity and use it instead.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/platform/omap3isp/isp.c |   14 +++++++++++++-
>  1 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index 5ea5520..5f75798 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -1767,6 +1767,7 @@ static int isp_register_entities(struct isp_device
> *isp) struct media_entity *input;
>  		unsigned int flags;
>  		unsigned int pad;
> +		unsigned int i;
> 
>  		sensor = isp_register_subdev_group(isp, subdevs->subdevs);
>  		if (sensor == NULL)
> @@ -1814,7 +1815,18 @@ static int isp_register_entities(struct isp_device
> *isp) goto done;
>  		}
> 
> -		ret = media_entity_create_link(&sensor->entity, 0, input, pad,
> +		for (i = 0; i < sensor->entity.num_pads; i++) {
> +			if (sensor->entity.pads[i].flags & MEDIA_PAD_FL_SOURCE)
> +				break;
> +		}
> +		if (i == sensor->entity.num_pads) {
> +			dev_err(isp->dev,
> +				"no source pads in external entities\n");

Nitpicking, "no source pad in external entity". If that's fine with you I'll 
modify this when applying this patch to my tree.

> +			ret = -EINVAL;
> +			goto done;
> +		}
> +
> +		ret = media_entity_create_link(&sensor->entity, i, input, pad,
>  					       flags);
>  		if (ret < 0)
>  			goto done;

-- 
Regards,

Laurent Pinchart

