Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:49732 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158Ab1KHPPz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Nov 2011 10:15:55 -0500
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id pA8FFqd9001409
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 8 Nov 2011 09:15:54 -0600
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Taneja, Archit" <archit@ti.com>
Subject: RE: [PATCH] omap_vout: fix section mismatch
Date: Tue, 8 Nov 2011 15:15:48 +0000
Message-ID: <79CD15C6BA57404B839C016229A409A802693C@DBDE01.ent.ti.com>
References: <1320745628-20603-1-git-send-email-tomi.valkeinen@ti.com>
In-Reply-To: <1320745628-20603-1-git-send-email-tomi.valkeinen@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Valkeinen, Tomi
> Sent: Tuesday, November 08, 2011 3:17 PM
> To: linux-media@vger.kernel.org; Hiremath, Vaibhav
> Cc: Taneja, Archit; Valkeinen, Tomi
> Subject: [PATCH] omap_vout: fix section mismatch
> 
> Fix the following warning by using platform_driver_probe() instead of
> platform_driver_register():
> 
> WARNING: drivers/media/video/omap/omap-vout.o(.data+0x24): Section
> mismatch in reference from the variable omap_vout_driver to the function
> .init.text:omap_vout_probe()
> The variable omap_vout_driver references
> the function __init omap_vout_probe()
> 
> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> ---
>  drivers/media/video/omap/omap_vout.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/omap/omap_vout.c
> b/drivers/media/video/omap/omap_vout.c
> index 9c5c19f..a323c09 100644
> --- a/drivers/media/video/omap/omap_vout.c
> +++ b/drivers/media/video/omap/omap_vout.c
> @@ -2254,13 +2254,12 @@ static struct platform_driver omap_vout_driver = {
>  	.driver = {
>  		.name = VOUT_NAME,
>  	},
> -	.probe = omap_vout_probe,
>  	.remove = omap_vout_remove,
>  };
> 
>  static int __init omap_vout_init(void)
>  {
> -	if (platform_driver_register(&omap_vout_driver) != 0) {
> +	if (platform_driver_probe(&omap_vout_driver, omap_vout_probe) != 0)
> {
>  		printk(KERN_ERR VOUT_NAME ":Could not register Video
> driver\n");
>  		return -EINVAL;
>  	}
> --
> 1.7.4.1

Thanks Tomi,

Acked-by: Vaibhav Hiremath <hvaibhav@ti.com>
Tested-by: Vaibhav Hiremath <hvaibhav@ti.com>

Not related to this patch, but thought of putting it here for
Wider audience.

I am not sure whether you had tested it, but kernel doesn't boot with V4L2 display enabled in defconfig. I have patch to fix this, will submit shortly -


diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 9c5c19f..9031c39 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -2140,6 +2140,8 @@ static int omap_vout_remove(struct platform_device *pdev)
                omap_vout_cleanup_device(vid_dev->vouts[k]);

        for (k = 0; k < vid_dev->num_displays; k++) {
+               if (!vid_dev->displays[k] && !vid_dev->displays[k]->driver)
+                       continue;
                if (vid_dev->displays[k]->state != OMAP_DSS_DISPLAY_DISABLED)
                        vid_dev->displays[k]->driver->disable(vid_dev->displays[k]);

@@ -2226,7 +2228,7 @@ static int __init omap_vout_probe(struct platform_device *pdev)
        for (i = 0; i < vid_dev->num_displays; i++) {
                struct omap_dss_device *display = vid_dev->displays[i];

-               if (display->driver->update)
+               if (display && display->driver && display->driver->update)
                        display->driver->update(display, 0, 0,
                                        display->panel.timings.x_res,
                                        display->panel.timings.y_res);


Reason being, 

If you have enabled certain device and fail to enable in defconfig, this will lead to kernel crash in omap_vout driver.

Thanks,
Vaibhav 

