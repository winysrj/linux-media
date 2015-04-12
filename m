Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58864 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751152AbbDLObR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Apr 2015 10:31:17 -0400
Date: Sun, 12 Apr 2015 17:31:09 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Tony Lindgren <tony@atomide.com>,
	Tero Kristo <t-kristo@ti.com>,
	linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] v4l: omap4iss: Replace outdated OMAP4 control pad API
 with syscon
Message-ID: <20150412143109.GP20756@valkosipuli.retiisi.org.uk>
References: <3292592.cickJMVhRq@wuerfel>
 <1428841693-15109-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1428841693-15109-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Sun, Apr 12, 2015 at 03:28:13PM +0300, Laurent Pinchart wrote:
> diff --git a/drivers/staging/media/omap4iss/iss_csiphy.c b/drivers/staging/media/omap4iss/iss_csiphy.c
> index 7c3d55d..748607f 100644
> --- a/drivers/staging/media/omap4iss/iss_csiphy.c
> +++ b/drivers/staging/media/omap4iss/iss_csiphy.c
> @@ -13,6 +13,7 @@
>  
>  #include <linux/delay.h>
>  #include <linux/device.h>
> +#include <linux/regmap.h>
>  
>  #include "../../../../arch/arm/mach-omap2/control.h"
>  
> @@ -140,9 +141,11 @@ int omap4iss_csiphy_config(struct iss_device *iss,
>  	 * - bit [18] : CSIPHY1 CTRLCLK enable
>  	 * - bit [17:16] : CSIPHY1 config: 00 d-phy, 01/10 ccp2
>  	 */
> -	cam_rx_ctrl = omap4_ctrl_pad_readl(
> -			OMAP4_CTRL_MODULE_PAD_CORE_CONTROL_CAMERA_RX);
> -
> +	/*
> +	 * TODO: When implementing DT support specify the CONTROL_CAMERA_RX
> +	 * register offset in the syscon property instead of hardcoding it.
> +	 */
> +	regmap_read(iss->syscon, 0x68, &cam_rx_ctrl);

Do you use platform data now? I guess the address is the same on all SoCs
that use the OMAP 4 ISS?

Acked-by: Sakari Alius <sakari.ailus@iki.fi>

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
