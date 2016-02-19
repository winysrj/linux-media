Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58870 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1428138AbcBSQYP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2016 11:24:15 -0500
Date: Fri, 19 Feb 2016 14:24:10 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Josh Wu <josh.wu@atmel.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [RFC] Move some soc-camera drivers to staging in preparation
 for removal
Message-ID: <20160219142410.478488cc@recife.lan>
In-Reply-To: <56C71778.2030706@xs4all.nl>
References: <56C71778.2030706@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 19 Feb 2016 14:24:08 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi all,
> 
> The soc-camera framework is a problem for reusability of sub-device drivers since
> those need access to the soc-camera framework. Which defeats the purpose of the
> sub-device framework. It is the reason why we still have a media/i2c/soc-camera
> directory for subdevs that can only work with soc-camera.
> 
> Ideally I would like to drop soc-camera completely, but it is still in use.
> 
> One of the largest users is Renesas with their r-car SoC, but Niklas Söderlund
> made a replacement driver that should make it possible to remove the soc-camera
> r-car driver, hopefully this year.
> 
> What I would like to do is to move soc-camera drivers that we consider obsolete
> to staging, and remove them in 1-2 kernel cycles if nobody steps up.
> 
> See also this past thread from Guennadi:
> 
> http://www.spinics.net/lists/linux-media/msg89253.html
> 
> And yes, I said in that thread that I was OK with keeping soc-camera as-is. But
> it still happens that companies pick this framework for new devices (the driver
> for the Tegra K1 for example). It is another reason besides the reusability issue
> for remove this framework more aggressively then I intended originally.
> 
> 
> We have the following drivers:
> 
> - pxa_camera for the PXA27x Quick Capture Interface
> 
>   Apparently this architecture still gets attention (see the link to the thread
>   above). But it does use vb1 which we really want to phase out soon. Does anyone
>   know if this driver still works with the latest kernel? Because it is using vb1
>   it is a strong candidate for removing it (or replacing it with something better
>   if someone steps up).
> 
> - mx2_camera: i.MX27 Camera Sensor Interface
> 
>   Have not seen any development since April 2013 (mx2-camera: move interface
>   activation and deactivation to clock callbacks by Guennadi). No idea if it still
>   works or if it is still in use. Does anyone know?
> 
> - mx3_camera: i.MX3x Camera Sensor Interface
> 
>   Have not seen any development since July 2013 (add support for asynchronous
>   subdevice registration by Guennadi). Same as for mx2_camera: does it still work?
>   Is it still in use?
> 
> - omap1_camera: OMAP1 Camera Interface
> 
>   It uses vb1, so that's one very good reason for removing it. And as far as I
>   know it is unused and likely won't work.
> 
> - sh_mobile_ceu_camera: SuperH Mobile CEU Interface
> 
>   I worked on this, but I know it does function anymore. I'd say that this can
>   be removed.
> 
> - sh_mobile_csi2: SuperH Mobile MIPI CSI-2 Interface
> 
>   I don't have hardware to test, but I'd be surprised if it still works. Can
>   someone test? If it is broken, then it can be moved to staging.
> 
> - rcar_vin: R-Car Video Input (VIN)
>   Will be replaced with a regular driver as mentioned above.
> 
> - atmel-isi: ATMEL Image Sensor Interface (ISI)
> 
>   I believe this is still actively maintained. Would someone be willing to
>   convert this? It doesn't look like a complex driver.
> 
> Now I am not planning to remove soc-camera (yet), but at least we should get
> rid of unmaintained drivers, especially if they don't work anymore or if they
> use the old vb1 mess.
> 
> And we can then take a good look at what remains.

You're forgetting the I2C sensor cam drivers. There are 14 such drivers
under drivers/media/i2c/soc_camera/.

I guess we should try to remove the soc_camera.h dependency from them,
making the still alive drivers to use the I2C sensor drivers directly.

The point is that such sensors could be useful somewhere else.
For example, there are at least one or two such drivers that could be used
on em28xx-based cameras to replace some really ugly hacks there. Also,
gspca have sensor i2c code hardcoded on it.

So, I would hate to lose those sensor drivers in the process.

Regards,
Mauro
-- 
Thanks,
Mauro
