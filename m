Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:39686 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab0JKPH1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 11:07:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastian Hecht <hechtb@googlemail.com>
Subject: Re: OMAP 3530 camera ISP forks and new media framework
Date: Mon, 11 Oct 2010 17:07:20 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <AANLkTimyR117ZiHq8GFz4YW5tBtW3k82NzGVZqKoVTbY@mail.gmail.com> <201010111514.37592.laurent.pinchart@ideasonboard.com> <AANLkTikBWjgNmDdG6dCXQQmcDRBUc4gP7717uqAY3+_J@mail.gmail.com>
In-Reply-To: <AANLkTikBWjgNmDdG6dCXQQmcDRBUc4gP7717uqAY3+_J@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010111707.21537.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bastian,

On Monday 11 October 2010 16:58:35 Bastian Hecht wrote:
> 2010/10/11 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> > On Monday 11 October 2010 14:59:15 Bastian Hecht wrote:
> >> So... let's see if i got some things right, please let me now if you
> >> disagree:
> >> 
> >> - I do want to use the omap34xxcam.c driver as it is for the newest
> >> framework and I get most support for it
> > 
> > That's a bad start. With the latest driver, omap34xxcam.c doesn't exist
> > anymore :-)
> 
> Nice :S
> 
> I think I take the mt9t001 approach (Sorry Guennadi, I think modifying
> your framework is too much for me to start with). So in this driver I
> tell the framework that I can do i2c probing, some subdev_core_ops and
> some subdev_video_ops. I define these functions that mostly do some
> basic i2c communication to the sensor chip. I guess I can handle that
> as there are so many examples out there.

The best solution would be to add mt9p031 support to the mt9t001 driver. If 
that's too difficult to start with, you can copy mt9t001 to mt9p031 and modify 
the driver as needed and merge the two drivers when you will be satisfied with 
the result.

> But where do I stack that on top? On the camera bridge host, but if it
> isn't omap34xxcam, which driver can I use? How are they connected?

http://gitorious.org/maemo-multimedia/omap3isp-rx51

The omap34xxcam.ko and isp-mod.ko modules have been merged into a single 
omap3-isp.ko module. All the driver code is now in drivers/media/video/isp.

-- 
Regards,

Laurent Pinchart
