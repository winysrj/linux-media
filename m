Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56550 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757381Ab1FUWzP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2011 18:55:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Stephan Lachowsky <stephan.lachowsky@maxim-ic.com>
Subject: Re: [PATCH] [media] uvcvideo: Fix control mapping for devices with multiple chains
Date: Wed, 22 Jun 2011 00:55:36 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-uvc-devel@lists.berlios.de" <linux-uvc-devel@lists.berlios.de>
References: <1306880661.2916.39.camel@svmlwks101>
In-Reply-To: <1306880661.2916.39.camel@svmlwks101>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106220055.37215.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Stephan,

On Wednesday 01 June 2011 00:24:21 Stephan Lachowsky wrote:
> The search for matching extension units fails to take account of the
> current chain.  In the case where you have two distinct video chains,
> both containing an XU with the same GUID but different unit ids, you
> will be unable to perform a mapping on the second chain because entity
> on the first chain will always be found first
> 
> Fix this by only searching the current chain when performing a control
> mapping.  This is analogous to the search used by uvc_find_control(),
> and is the correct behaviour.

Thanks for the patch. I agree with your analysis, but I'm concerned about 
devices that might have extension units not connected to any chain. They would 
become unaccessible.

Devices for which extension unit control mappings have been published have all 
their XUs connected to a chain, so I'm OK with the patch. I will add a TODO 
comment to remind me of the issue, and I'll solve the problem later if it ever 
occurs.

> Signed-off-by: Stephan Lachowsky <stephan.lachowsky@maxim-ic.com>
> ---
>  drivers/media/video/uvc/uvc_ctrl.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_ctrl.c
> b/drivers/media/video/uvc/uvc_ctrl.c index 59f8a9a..a77648f 100644
> --- a/drivers/media/video/uvc/uvc_ctrl.c
> +++ b/drivers/media/video/uvc/uvc_ctrl.c
> @@ -1565,8 +1565,8 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain
> *chain, return -EINVAL;
>  	}
> 
> -	/* Search for the matching (GUID/CS) control in the given device */
> -	list_for_each_entry(entity, &dev->entities, list) {
> +	/* Search for the matching (GUID/CS) control on the current chain */
> +	list_for_each_entry(entity, &chain->entities, chain) {
>  		unsigned int i;
> 
>  		if (UVC_ENTITY_TYPE(entity) != UVC_VC_EXTENSION_UNIT ||

-- 
Regards,

Laurent Pinchart
