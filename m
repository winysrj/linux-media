Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:64238 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab1HESI4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Aug 2011 14:08:56 -0400
Cc: <hvaibhav@ti.com>, <linux-media@vger.kernel.org>,
	<tomi.valkeinen@ti.com>, <linux-omap@vger.kernel.org>
Message-Id: <8565F923-5F8F-40B1-AFA8-ADE152507223@dominion.thruhere.net>
From: Koen Kooi <koen@beagleboard.org>
To: Archit Taneja <archit@ti.com>
In-Reply-To: <1312528761-18241-1-git-send-email-archit@ti.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH] [media] OMAP_VOUT: Fix build break caused by update_mode removal in DSS2
Date: Fri, 5 Aug 2011 20:08:46 +0200
References: <1312528761-18241-1-git-send-email-archit@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Op 5 aug 2011, om 09:19 heeft Archit Taneja het volgende geschreven:

> The DSS2 driver does not support the configuration of the  
> update_mode of a
> panel anymore. Remove the setting of update_mode done in  
> omap_vout_probe().
> Ignore configuration of TE since omap_vout driver doesn't support  
> manual update
> displays anyway.
>
> Signed-off-by: Archit Taneja <archit@ti.com>

Tested-by: Koen Kooi <koen@dominion.thruhere.net>

> ---
> drivers/media/video/omap/omap_vout.c |   13 -------------
> 1 files changed, 0 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/ 
> video/omap/omap_vout.c
> index b5ef362..b3a5ecd 100644
> --- a/drivers/media/video/omap/omap_vout.c
> +++ b/drivers/media/video/omap/omap_vout.c
> @@ -2194,19 +2194,6 @@ static int __init omap_vout_probe(struct  
> platform_device *pdev)
> 					"'%s' Display already enabled\n",
> 					def_display->name);
> 			}
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
> 		}
> 	}
>
> -- 
> 1.7.1
>

