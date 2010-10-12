Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:53049 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282Ab0JLM7K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Oct 2010 08:59:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastian Hecht <hechtb@googlemail.com>
Subject: Re: OMAP 3530 camera ISP forks and new media framework
Date: Tue, 12 Oct 2010 14:58:55 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <AANLkTimyR117ZiHq8GFz4YW5tBtW3k82NzGVZqKoVTbY@mail.gmail.com> <201010111707.21537.laurent.pinchart@ideasonboard.com> <AANLkTiks9qzC6W4iyu2_QWkWeK-cN-pTOS=trGxeRF=6@mail.gmail.com>
In-Reply-To: <AANLkTiks9qzC6W4iyu2_QWkWeK-cN-pTOS=trGxeRF=6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010121458.57150.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bastian,

On Tuesday 12 October 2010 14:10:00 Bastian Hecht wrote:
> 2010/10/11 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> > On Monday 11 October 2010 16:58:35 Bastian Hecht wrote:
> >> 2010/10/11 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> >> > On Monday 11 October 2010 14:59:15 Bastian Hecht wrote:
> >> >> So... let's see if i got some things right, please let me now if you
> >> >> disagree:
> >> >> 
> >> >> - I do want to use the omap34xxcam.c driver as it is for the newest
> >> >> framework and I get most support for it
> >> > 
> >> > That's a bad start. With the latest driver, omap34xxcam.c doesn't
> >> > exist anymore :-)
> >> 
> >> Nice :S
> >> 
> >> I think I take the mt9t001 approach (Sorry Guennadi, I think modifying
> >> your framework is too much for me to start with). So in this driver I
> >> tell the framework that I can do i2c probing, some subdev_core_ops and
> >> some subdev_video_ops. I define these functions that mostly do some
> >> basic i2c communication to the sensor chip. I guess I can handle that
> >> as there are so many examples out there.
> > 
> > The best solution would be to add mt9p031 support to the mt9t001 driver.
> > If that's too difficult to start with, you can copy mt9t001 to mt9p031
> > and modify the driver as needed and merge the two drivers when you will
> > be satisfied with the result.
> 
> OK, now I built the nokia kernel for the omap3-isp and made your
> mt9t001.c work for it.
> In mt9t001.c you call i2c_add_driver(&mt9t001_driver);
> As far I as I figured out the driver core system looks for matches
> between registered devices in arch/arm/omap/devices.c and appropriate
> drivers.

The driver core looks for matches between registered drivers and registered 
devices. Devices are registered in lots of places, arch/arm/omap/devices.c is 
only one of them. Board-specific devices are registered (or at least declared) 
in a board file located (for this architecture) in arch/arm/mach-omap2/.

> Is the next step to include a static struct platform_device into
> devices.c? Or is there a special i2c_device struct that I have to use?

The OMAP3 ISP driver requires platform data that contain, among other 
information, the list of I2C subdevices. Have a look at arch/arm/mach-
omap2/board-rx51-camera.c.

-- 
Regards,

Laurent Pinchart
