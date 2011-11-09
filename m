Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:57498 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315Ab1KIM34 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2011 07:29:56 -0500
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id pA9CTqaY028319
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 9 Nov 2011 06:29:55 -0600
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Valkeinen, Tomi" <tomi.valkeinen@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Taneja, Archit" <archit@ti.com>
Subject: RE: [PATCH] omap_vout: fix section mismatch
Date: Wed, 9 Nov 2011 12:29:48 +0000
Message-ID: <79CD15C6BA57404B839C016229A409A80283FC@DBDE01.ent.ti.com>
References: <1320745628-20603-1-git-send-email-tomi.valkeinen@ti.com>
	 <79CD15C6BA57404B839C016229A409A802693C@DBDE01.ent.ti.com>
 <1320765839.1907.55.camel@deskari>
In-Reply-To: <1320765839.1907.55.camel@deskari>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Valkeinen, Tomi
> Sent: Tuesday, November 08, 2011 8:54 PM
> To: Hiremath, Vaibhav
> Cc: linux-media@vger.kernel.org; Taneja, Archit
> Subject: RE: [PATCH] omap_vout: fix section mismatch
> 
> On Tue, 2011-11-08 at 15:15 +0000, Hiremath, Vaibhav wrote:
> 
> > I am not sure whether you had tested it, but kernel doesn't boot with
> V4L2 display enabled in defconfig. I have patch to fix this, will submit
> shortly -
> >
> >
> > diff --git a/drivers/media/video/omap/omap_vout.c
> b/drivers/media/video/omap/omap_vout.c
> > index 9c5c19f..9031c39 100644
> > --- a/drivers/media/video/omap/omap_vout.c
> > +++ b/drivers/media/video/omap/omap_vout.c
> > @@ -2140,6 +2140,8 @@ static int omap_vout_remove(struct platform_device
> *pdev)
> >                 omap_vout_cleanup_device(vid_dev->vouts[k]);
> >
> >         for (k = 0; k < vid_dev->num_displays; k++) {
> > +               if (!vid_dev->displays[k] && !vid_dev->displays[k]-
> >driver)
> > +                       continue;
> >                 if (vid_dev->displays[k]->state !=
> OMAP_DSS_DISPLAY_DISABLED)
> >                         vid_dev->displays[k]->driver->disable(vid_dev-
> >displays[k]);
> >
> > @@ -2226,7 +2228,7 @@ static int __init omap_vout_probe(struct
> platform_device *pdev)
> >         for (i = 0; i < vid_dev->num_displays; i++) {
> >                 struct omap_dss_device *display = vid_dev->displays[i];
> >
> > -               if (display->driver->update)
> > +               if (display && display->driver && display->driver-
> >update)
> >                         display->driver->update(display, 0, 0,
> >                                         display->panel.timings.x_res,
> >                                         display->panel.timings.y_res);
> >
> >
> > Reason being,
> >
> > If you have enabled certain device and fail to enable in defconfig, this
> will lead to kernel crash in omap_vout driver.
> 
> Hmm, I didn't quite understand the explanation. But now that you mention
> this, I did have the following patch in one of my work trees, but I seem
> to have forgotten to post it.
> 
> It fixes the case where a display device defined in the board file
> doesn't have a driver loaded. I guess this is the same problem you
> mention? Is my patch fixing the same problem?
> 
> diff --git a/drivers/media/video/omap/omap_vout.c
> b/drivers/media/video/omap/omap_vout.c
> index 30d8896..18fe02f 100644
> --- a/drivers/media/video/omap/omap_vout.c
> +++ b/drivers/media/video/omap/omap_vout.c
> @@ -2159,6 +2159,14 @@ static int __init omap_vout_probe(struct
> platform_device *pdev)
>         vid_dev->num_displays = 0;
>         for_each_dss_dev(dssdev) {
>                 omap_dss_get_device(dssdev);
> +
> +               if (!dssdev->driver) {
> +                       dev_warn(&pdev->dev, "no driver for display: %s\n",
> +                                       dssdev->name);
> +                       omap_dss_put_device(dssdev);
> +                       continue;
> +               }
> +
>                 vid_dev->displays[vid_dev->num_displays++] = dssdev;
>         }
> 

Can you submit the patch? I have tested this and it works for me.

Thanks,
Vaibhav


>  Tomi

