Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38705 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbbKWPyz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2015 10:54:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v8 17/55] [media] omap3isp: separate links creation from entities init
Date: Mon, 23 Nov 2015 17:55:03 +0200
Message-ID: <1854108.dJ5m23VzOc@avalon>
In-Reply-To: <c81b0942c0405f447e4736fcda37f63509dc0526.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com> <c81b0942c0405f447e4736fcda37f63509dc0526.1440902901.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier and Mauro,

Thank you for the patch.

On Monday 12 October 2015 13:43:05 Mauro Carvalho Chehab wrote:
> From: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> The omap3isp driver initializes the entities and creates the pads links
> before the entities are registered with the media device. This does not
> work now that object IDs are used to create links so the media_device
> has to be set.
> 
> Split out the pads links creation from the entity initialization so are
> made after the entities registration.

Is a part of this sentence missing ?

> Suggested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> Series-to: linux-kernel@vger.kernel.org
> Series-cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Series-cc: linux-media@vger.kernel.org
> Series-cc: Shuah Khan <shuahkh@osg.samsung.com>
> Series-cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Cover-letter:

I don't think those are known tags. Could you rework the commit message to 
merge both part into something coherent without copying the cover letter ?

> Patches to test MC next gen patches in OMAP3 ISP
> Hello,
> 
> This series contains two patches that are needed to test the
> "[PATCH v7 00/44] MC next generation patches" [0] in a OMAP3
> board by using the omap3isp driver.
> 
> I found two issues during testing, the first one is that the
> media_entity_cleanup() function tries to empty the pad links
> list but the list is initialized when a entity is registered
> causing a NULL pointer deference error.
> 
> The second issue is that the omap3isp driver creates links
> when the entities are initialized but before the media device
> is registered causing a NULL pointer deference as well.
> 
> Patch 1/1 fixes the first issue by removing the links list
> empty logic from media_entity_cleanup() since that is made
> in media_device_unregister_entity() and 2/2 fixes the second
> issue by separating the entities initialization from the pads
> links creation after the entities have been registered.
> 
> Patch 1/1 was posted before [1] but forgot to add the [media]
> prefix in the subject line so I'm including in this set again.
> Sorry about that.
> 
> The testing was made on an OMAP3 DM3735 IGEPv2 board and test
> that the media-ctl -p prints out the topology. More extensive
> testing will be made but I wanted to share these patches in
> order to make easier for other people that were looking at it.
> 
> [0]: https://www.mail-archive.com/linux-media@vger.kernel.org/msg91528.html
> [1]: https://lkml.org/lkml/2015/8/24/649
> 
> Best regards,
> Javier
> END
> 
> Change-Id: I44abb9b67d6378cbd54ba4e0673a5d6d5721fc77

No gerrit craziness please.

> ---
>  drivers/media/platform/omap3isp/isp.c        | 152 ++++++++++++++----------
>  drivers/media/platform/omap3isp/ispccdc.c    |  22 ++--
>  drivers/media/platform/omap3isp/ispccdc.h    |   1 +
>  drivers/media/platform/omap3isp/ispccp2.c    |  22 ++--
>  drivers/media/platform/omap3isp/ispccp2.h    |   1 +
>  drivers/media/platform/omap3isp/ispcsi2.c    |  22 ++--
>  drivers/media/platform/omap3isp/ispcsi2.h    |   1 +
>  drivers/media/platform/omap3isp/isppreview.c |  33 +++---
>  drivers/media/platform/omap3isp/isppreview.h |   1 +
>  drivers/media/platform/omap3isp/ispresizer.c |  33 +++---
>  drivers/media/platform/omap3isp/ispresizer.h |   1 +
>  11 files changed, 185 insertions(+), 104 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index aa13b17d19a0..b8f6f81d2db2
> 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -1933,6 +1933,100 @@ done:
>  	return ret;
>  }
> 
> +/*
> + * isp_create_pads_links - Pads links creation for the subdevices
> + * @isp : Pointer to ISP device

Missing blank line here. And missing description of the function for that 
matter. You can use

"This function creates all links between ISP internal and external entities."

> + * return negative error code or zero on success

In kerneldoc style that should be

Return: A negative error code on failure or zero on success. Possible error 
codes are those returned by media_create_pad_link().

Same for the other functions below, the return line should start with 
"Return:".

> + */
> +static int isp_create_pads_links(struct isp_device *isp)

This should be called isp_create_pad_links() if you want the include the pad 
prefix, but I'd just name it isp_create_links() as the driver doesn't handle 
any other kind of links. Same for all the *_create_pads_links() functions 
below.

> +{
> +	int ret;
> +
> +	ret = omap3isp_csi2_create_pads_links(isp);
> +	if (ret < 0) {
> +		dev_err(isp->dev, "CSI2 pads links creation failed\n");

That's lots of error strings. You would save memory by turning the messages 
into "%s pads links creation failed\n", "CSI2" as the compiler will then avoid 
multiple copies of the first string.

I would actually remove the messages as the only source of error is a memory 
allocation failure, which will already print a message. You could add a single 
dev_err() in the location where isp_create_pads_links() is called if you want 
to.

> +		return ret;
> +	}
> +
> +	ret = omap3isp_ccp2_create_pads_links(isp);
> +	if (ret < 0) {
> +		dev_err(isp->dev, "CCP2 pads links creation failed\n");
> +		return ret;
> +	}
> +
> +	ret = omap3isp_ccdc_create_pads_links(isp);
> +	if (ret < 0) {
> +		dev_err(isp->dev, "CCDC pads links creation failed\n");
> +		return ret;
> +	}
> +
> +	ret = omap3isp_preview_create_pads_links(isp);
> +	if (ret < 0) {
> +		dev_err(isp->dev, "Preview pads links creation failed\n");
> +		return ret;
> +	}
> +
> +	ret = omap3isp_resizer_create_pads_links(isp);
> +	if (ret < 0) {
> +		dev_err(isp->dev, "Resizer pads links creation failed\n");
> +		return ret;
> +	}
> +
> +	/* Connect the submodules. */

I'd write "Create links between entities." and add a comment at the beginning 
of the function that states "Create links between entities and video nodes.".

> +	ret = media_create_pad_link(
> +			&isp->isp_csi2a.subdev.entity, CSI2_PAD_SOURCE,
> +			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SINK, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = media_create_pad_link(
> +			&isp->isp_ccp2.subdev.entity, CCP2_PAD_SOURCE,
> +			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SINK, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = media_create_pad_link(
> +			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_VP,
> +			&isp->isp_prev.subdev.entity, PREV_PAD_SINK, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = media_create_pad_link(
> +			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_OF,
> +			&isp->isp_res.subdev.entity, RESZ_PAD_SINK, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = media_create_pad_link(
> +			&isp->isp_prev.subdev.entity, PREV_PAD_SOURCE,
> +			&isp->isp_res.subdev.entity, RESZ_PAD_SINK, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = media_create_pad_link(
> +			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_VP,
> +			&isp->isp_aewb.subdev.entity, 0,
> +			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = media_create_pad_link(
> +			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_VP,
> +			&isp->isp_af.subdev.entity, 0,
> +			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = media_create_pad_link(
> +			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_VP,
> +			&isp->isp_hist.subdev.entity, 0,
> +			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}

[snip]

> @@ -2468,6 +2508,10 @@ static int isp_probe(struct platform_device *pdev)
>  	if (ret < 0)
>  		goto error_modules;
> 
> +	ret = isp_create_pads_links(isp);
> +	if (ret < 0)
> +		goto error_register_entities;
> +
>  	isp->notifier.bound = isp_subdev_notifier_bound;
>  	isp->notifier.complete = isp_subdev_notifier_complete;
> 
> diff --git a/drivers/media/platform/omap3isp/ispccdc.c
> b/drivers/media/platform/omap3isp/ispccdc.c index
> 27555e4f4aa8..9a811f5741fa 100644
> --- a/drivers/media/platform/omap3isp/ispccdc.c
> +++ b/drivers/media/platform/omap3isp/ispccdc.c
> @@ -2666,16 +2666,8 @@ static int ccdc_init_entities(struct isp_ccdc_device
> *ccdc) if (ret < 0)
>  		goto error_video;
> 
> -	/* Connect the CCDC subdev to the video node. */
> -	ret = media_create_pad_link(&ccdc->subdev.entity, CCDC_PAD_SOURCE_OF,
> -			&ccdc->video_out.video.entity, 0, 0);
> -	if (ret < 0)
> -		goto error_link;
> -
>  	return 0;
> 
> -error_link:
> -	omap3isp_video_cleanup(&ccdc->video_out);
>  error_video:

As there's now a single error label I'd rename it to just "error:". Same 
comment for the other ISP modules.

>  	media_entity_cleanup(me);
>  	return ret;
> @@ -2721,6 +2713,20 @@ int omap3isp_ccdc_init(struct isp_device *isp)
>  }
> 
>  /*
> + * omap3isp_ccdc_create_pads_links - CCDC pads links creation
> + * @isp : Pointer to ISP device
> + * return negative error code or zero on success
> + */
> +int omap3isp_ccdc_create_pads_links(struct isp_device *isp)
> +{
> +	struct isp_ccdc_device *ccdc = &isp->isp_ccdc;
> +
> +	/* Connect the CCDC subdev to the video node. */
> +	return media_create_pad_link(&ccdc->subdev.entity, CCDC_PAD_SOURCE_OF,
> +				     &ccdc->video_out.video.entity, 0, 0);
> +}

Given that this function and the other similar functions for other modules 
just link entities and video devices, it could make sense to inline them 
directly in the caller in order to group all the link create calls together. 
No strong opinion though, I'll leave it up to you and on whether you want to 
fix the kerneldoc or remove it ;-)

> +
> +/*
>   * omap3isp_ccdc_cleanup - CCDC module cleanup.
>   * @isp: Device pointer specific to the OMAP3 ISP.
>   */

[snip]

-- 
Regards,

Laurent Pinchart

