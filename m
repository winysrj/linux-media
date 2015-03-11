Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39544 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbbCKXHu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2015 19:07:50 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	pali.rohar@gmail.com, Mike Rapoport <mike@compulab.co.il>,
	Igor Grinberg <grinberg@compulab.co.il>
Subject: Re: [RFC 06/18] omap3isp: Refactor device configuration structs for Device Tree
Date: Thu, 12 Mar 2015 01:07:51 +0200
Message-ID: <101867645.hqvO850At0@avalon>
In-Reply-To: <1425764475-27691-7-git-send-email-sakari.ailus@iki.fi>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi> <1425764475-27691-7-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Saturday 07 March 2015 23:41:03 Sakari Ailus wrote:
> Make omap3isp configuration data structures more suitable for consumption by
> the DT by separating the I2C bus information of all the sub-devices in a
> group and the ISP bus information from each other. The ISP bus information
> is made a pointer instead of being directly embedded in the struct.
> 
> In the case of the DT only the sensor specific information on the ISP bus
> configuration is retained. The structs are renamed to reflect that.
> 
> After this change the structs needed to describe device configuration can be
> allocated and accessed separately without those needed only in the case of
> platform data. The platform data related structs can be later removed once
> the support for platform data can be removed.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Mike Rapoport <mike@compulab.co.il>
> Cc: Igor Grinberg <grinberg@compulab.co.il>
> ---
>  arch/arm/mach-omap2/board-cm-t35.c          |   57 +++++++-----------
>  drivers/media/platform/omap3isp/isp.c       |   86 ++++++++++++------------
>  drivers/media/platform/omap3isp/isp.h       |    2 +-
>  drivers/media/platform/omap3isp/ispccdc.c   |   26 ++++----
>  drivers/media/platform/omap3isp/ispccp2.c   |   22 +++----
>  drivers/media/platform/omap3isp/ispcsi2.c   |    8 +--
>  drivers/media/platform/omap3isp/ispcsiphy.c |   21 ++++---
>  include/media/omap3isp.h                    |   34 +++++------
>  8 files changed, 119 insertions(+), 137 deletions(-)

[snip]

> diff --git a/drivers/media/platform/omap3isp/ispccdc.c
> b/drivers/media/platform/omap3isp/ispccdc.c index 587489a..1c0a552 100644
> --- a/drivers/media/platform/omap3isp/ispccdc.c
> +++ b/drivers/media/platform/omap3isp/ispccdc.c
> @@ -958,11 +958,11 @@ void omap3isp_ccdc_max_rate(struct isp_ccdc_device
> *ccdc, /*
>   * ccdc_config_sync_if - Set CCDC sync interface configuration
>   * @ccdc: Pointer to ISP CCDC device.
> - * @pdata: Parallel interface platform data (may be NULL)
> + * @buscfg: Parallel interface platform data (may be NULL)

The parameter is called parcfg below.

With this fixed,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>   * @data_size: Data size
>   */
>  static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
> -				struct isp_parallel_platform_data *pdata,
> +				struct isp_parallel_cfg *parcfg,
>  				unsigned int data_size)
>  {
>  	struct isp_device *isp = to_isp_device(ccdc);

-- 
Regards,

Laurent Pinchart

