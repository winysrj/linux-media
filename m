Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:42712 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678Ab1KPPMT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Nov 2011 10:12:19 -0500
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id pAGFCHRg027515
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 16 Nov 2011 09:12:19 -0600
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Taneja, Archit" <archit@ti.com>
Subject: RE: [PATCH] omap_vout: fix crash if no driver for a display
Date: Wed, 16 Nov 2011 15:12:11 +0000
Message-ID: <79CD15C6BA57404B839C016229A409A80324BF@DBDE01.ent.ti.com>
References: <1321259339-5202-1-git-send-email-tomi.valkeinen@ti.com>
In-Reply-To: <1321259339-5202-1-git-send-email-tomi.valkeinen@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Valkeinen, Tomi
> Sent: Monday, November 14, 2011 1:59 PM
> To: linux-media@vger.kernel.org; Hiremath, Vaibhav
> Cc: Taneja, Archit; Valkeinen, Tomi
> Subject: [PATCH] omap_vout: fix crash if no driver for a display
> 
> omap_vout crashes on start if a corresponding driver is not loaded for a
> display device.
> 
> This patch changes omap_vout init sequence to skip devices without a
> driver.
> 
> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> ---
>  drivers/media/video/omap/omap_vout.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/omap/omap_vout.c
> b/drivers/media/video/omap/omap_vout.c
> index 9c5c19f..2d2a136 100644
> --- a/drivers/media/video/omap/omap_vout.c
> +++ b/drivers/media/video/omap/omap_vout.c
> @@ -2169,6 +2169,14 @@ static int __init omap_vout_probe(struct
> platform_device *pdev)
>  	vid_dev->num_displays = 0;
>  	for_each_dss_dev(dssdev) {
>  		omap_dss_get_device(dssdev);
> +
> +		if (!dssdev->driver) {
> +			dev_warn(&pdev->dev, "no driver for display: %s\n",
> +					dssdev->name);
> +			omap_dss_put_device(dssdev);
> +			continue;
> +		}
> +
>  		vid_dev->displays[vid_dev->num_displays++] = dssdev;
>  	}
> 

Acked-by: Vaibhav Hiremath <hvaibhav@ti.com>

Thanks,
Vaibhav


> --
> 1.7.4.1

