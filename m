Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:40542 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932157AbeDWVCw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 17:02:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: architt@codeaurora.org, a.hajda@samsung.com, airlied@linux.ie,
        daniel@ffwll.ch, peda@axentia.se,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] drm: connector: Remove DRM_BUS_FLAG_DATA_* flags
Date: Tue, 24 Apr 2018 00:03:04 +0300
Message-ID: <5371494.OmLzBJ8YyX@avalon>
In-Reply-To: <1524130269-32688-9-git-send-email-jacopo+renesas@jmondi.org>
References: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org> <1524130269-32688-9-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for the patch.

On Thursday, 19 April 2018 12:31:09 EEST Jacopo Mondi wrote:
> DRM_BUS_FLAG_DATA_* flags, defined in drm_connector.h header file are
> used to swap ordering of LVDS RGB format to accommodate DRM objects
> that need to handle LVDS components ordering.
> 
> Now that the only 2 users of DRM_BUS_FLAG_DATA_* flags have been ported
> to use the newly introduced MEDIA_BUS_FMT_RGB888_1X7X*_LE media bus
> formats, remove them.

I'm not opposed to this (despite my review of patch 5/8), but I think the _LE 
suffix isn't the right name for the new formats. _BE and _LE relate to byte 
swapping, while here you really need to describe full mirroring. Maybe a 
_MIRROR variant would be more appropriate ?

> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  include/drm/drm_connector.h | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/include/drm/drm_connector.h b/include/drm/drm_connector.h
> index 675cc3f..9e0d6d5 100644
> --- a/include/drm/drm_connector.h
> +++ b/include/drm/drm_connector.h
> @@ -286,10 +286,6 @@ struct drm_display_info {
>  #define DRM_BUS_FLAG_PIXDATA_POSEDGE	(1<<2)
>  /* drive data on neg. edge */
>  #define DRM_BUS_FLAG_PIXDATA_NEGEDGE	(1<<3)
> -/* data is transmitted MSB to LSB on the bus */
> -#define DRM_BUS_FLAG_DATA_MSB_TO_LSB	(1<<4)
> -/* data is transmitted LSB to MSB on the bus */
> -#define DRM_BUS_FLAG_DATA_LSB_TO_MSB	(1<<5)
> 
>  	/**
>  	 * @bus_flags: Additional information (like pixel signal polarity) for


-- 
Regards,

Laurent Pinchart
