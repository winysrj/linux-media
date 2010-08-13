Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:58205 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761746Ab0HMPrg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Aug 2010 11:47:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: Must omap34xxcam be a module?
Date: Fri, 13 Aug 2010 17:47:30 +0200
Cc: "sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>,
	linux-media@vger.kernel.org
References: <4C655A01.7010807@matrix-vision.de>
In-Reply-To: <4C655A01.7010807@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008131747.31412.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi Michael,

On Friday 13 August 2010 16:43:13 Michael Jones wrote:
> Hi Laurent & Sakari,
> 
> Regarding the omap3camera/devel branch:
> 
> In v4l2-common.c:v4l2_i2c_new_subdev_board(), request_module() is called to
> ensure that the sensor driver is already registered before registering the
> sensor device.  When I compile-in both my sensor driver and omap34xxcam
> with the kernel, this call to request_module() fails, and indeed
> omap34xxcam is initialized before my sensor driver, causing the
> omap34xxcam device registration to fail.
>
> When I leave omap34xxcam compiled-in and try to just let it load the sensor
> module when needed on bootup, request_module() fails.  I haven't managed to
> track down why that is.

That's because userspace isn't available yet when the omap34xxcam driver is 
initialized, so there's no way to load a module at that time.

> When I compile both omap34xxcam and my sensor driver as modules, and
> load them after boot-up, registration succeeds.
> 
> Is it neccessary for omap34xxcam and its subdevices to be modules?  How are
> you guys building these?

At the moment it's indeed necessary. It's a V4L2 core issue, not specific to 
omap34xxcam. I'm not aware of plans to fix this, but a proposal is welcome :-)

> Full disclosure: my sensor is actually an SPI device, but the
> v4l2_spi_new_subdev() function I'm actually using seems to be _very_
> analogous to its I2C counterpart, so I'm assuming SPI is not responsible.

The same issue exists with I2C, SPI is not responsible.

-- 
Regards,

Laurent Pinchart
