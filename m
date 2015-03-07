Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35137 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbbCGXTY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Mar 2015 18:19:24 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	pali.rohar@gmail.com
Subject: Re: [RFC 02/18] omap3isp: Avoid a BUG_ON() in media_entity_create_link()
Date: Sun, 08 Mar 2015 01:19:24 +0200
Message-ID: <1542562.jWgujH4fk7@avalon>
In-Reply-To: <1425764475-27691-3-git-send-email-sakari.ailus@iki.fi>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi> <1425764475-27691-3-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Saturday 07 March 2015 23:40:59 Sakari Ailus wrote:
> If an uninitialised v4l2_subdev struct was passed to
> media_entity_create_link(), one of the BUG_ON()'s in the function will be
> hit since media_entity.num_pads will be zero. Avoid this by checking whether
> the num_pads field is non-zero for the interface.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/omap3isp/isp.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index fb193b6..4ab674d 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -1946,6 +1946,19 @@ static int isp_register_entities(struct isp_device
> *isp) goto done;
>  		}
> 
> +		/*
> +		 * Not all interfaces are available on all revisions
> +		 * of the ISP. The sub-devices of those interfaces
> +		 * aren't initialised in such a case. Check this by
> +		 * ensuring the num_pads is non-zero.
> +		 */
> +		if (!input->num_pads) {
> +			dev_err(isp->dev, "%s: invalid input %u\n",
> +				entity->name, subdevs->interface);
> +			ret = -EINVAL;
> +			goto done;
> +		}
> +
>  		for (i = 0; i < sensor->entity.num_pads; i++) {
>  			if (sensor->entity.pads[i].flags & MEDIA_PAD_FL_SOURCE)
>  				break;

-- 
Regards,

Laurent Pinchart

