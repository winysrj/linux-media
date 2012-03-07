Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51038 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab2CGLDm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2012 06:03:42 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: Re: [PATCH v5 33/35] omap3isp: Find source pad from external entity
Date: Wed, 07 Mar 2012 12:04:01 +0100
Message-ID: <3442301.74He9Ect2M@avalon>
In-Reply-To: <1331051596-8261-33-git-send-email-sakari.ailus@iki.fi>
References: <20120306163239.GN1075@valkosipuli.localdomain> <1331051596-8261-33-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Tuesday 06 March 2012 18:33:14 Sakari Ailus wrote:
> No longer assume pad number 0 is the source pad of the external entity. Find
> the source pad from the external entity and use it instead.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

(with one comment below)

> ---
>  drivers/media/video/omap3isp/isp.c |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/isp.c
> b/drivers/media/video/omap3isp/isp.c index f54953d..0718b0a 100644
> --- a/drivers/media/video/omap3isp/isp.c
> +++ b/drivers/media/video/omap3isp/isp.c
> @@ -1744,6 +1744,7 @@ static int isp_register_entities(struct isp_device
> *isp) struct media_entity *input;
>  		unsigned int flags;
>  		unsigned int pad;
> +		unsigned int i;
> 
>  		sensor = isp_register_subdev_group(isp, subdevs->subdevs);
>  		if (sensor == NULL)
> @@ -1791,7 +1792,17 @@ static int isp_register_entities(struct isp_device
> *isp) goto done;
>  		}
> 
> -		ret = media_entity_create_link(&sensor->entity, 0, input, pad,
> +		for (i = 0; i < sensor->entity.num_pads; i++)
> +			if (sensor->entity.pads[i].flags & MEDIA_PAD_FL_SOURCE)
> +				break;

While not strictly needed, I find the code easier to read with brackets for 
the for statement. It's up to you though.

> +		if (i == sensor->entity.num_pads) {
> +			dev_err(isp->dev,
> +				"no source pads in external entities\n");
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

