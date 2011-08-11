Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:58017 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975Ab1HKMFP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2011 08:05:15 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Taneja, Archit" <archit@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "koen@dominion.thruhere.net" <koen@dominion.thruhere.net>,
	"Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Thu, 11 Aug 2011 17:35:08 +0530
Subject: RE: [PATCH] [media] OMAP_VOUT: Fix build break caused by
 update_mode removal in DSS2
Message-ID: <19F8576C6E063C45BE387C64729E739404E3BC8DB1@dbde02.ent.ti.com>
References: <1312528761-18241-1-git-send-email-archit@ti.com>
In-Reply-To: <1312528761-18241-1-git-send-email-archit@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Taneja, Archit
> Sent: Friday, August 05, 2011 12:49 PM
> To: Hiremath, Vaibhav; linux-media@vger.kernel.org
> Cc: koen@dominion.thruhere.net; Valkeinen, Tomi; linux-
> omap@vger.kernel.org; Taneja, Archit
> Subject: [PATCH] [media] OMAP_VOUT: Fix build break caused by update_mode
> removal in DSS2
> 
> The DSS2 driver does not support the configuration of the update_mode of a
> panel anymore. Remove the setting of update_mode done in omap_vout_probe().
> Ignore configuration of TE since omap_vout driver doesn't support manual
> update
> displays anyway.
> 
> Signed-off-by: Archit Taneja <archit@ti.com>
> ---
>  drivers/media/video/omap/omap_vout.c |   13 -------------
>  1 files changed, 0 insertions(+), 13 deletions(-)
> 
[Hiremath, Vaibhav] 

Acked-by: Vaibhav Hiremath <hvaibhav@ti.com>
Tested-by: Vaibhav Hiremath <hvaibhav@ti.com>

Since this is bug fix (results in build failure), I will queue up for next rc.

Thanks,
Vaibhav

> diff --git a/drivers/media/video/omap/omap_vout.c
> b/drivers/media/video/omap/omap_vout.c
> index b5ef362..b3a5ecd 100644
> --- a/drivers/media/video/omap/omap_vout.c
> +++ b/drivers/media/video/omap/omap_vout.c
> @@ -2194,19 +2194,6 @@ static int __init omap_vout_probe(struct
> platform_device *pdev)
>  					"'%s' Display already enabled\n",
>  					def_display->name);
>  			}
> -			/* set the update mode */
> -			if (def_display->caps &
> -					OMAP_DSS_DISPLAY_CAP_MANUAL_UPDATE) {
> -				if (dssdrv->enable_te)
> -					dssdrv->enable_te(def_display, 0);
> -				if (dssdrv->set_update_mode)
> -					dssdrv->set_update_mode(def_display,
> -							OMAP_DSS_UPDATE_MANUAL);
> -			} else {
> -				if (dssdrv->set_update_mode)
> -					dssdrv->set_update_mode(def_display,
> -							OMAP_DSS_UPDATE_AUTO);
> -			}
>  		}
>  	}
> 
> --
> 1.7.1

