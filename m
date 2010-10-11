Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:39577 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754835Ab0JKP0Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 11:26:16 -0400
Date: Mon, 11 Oct 2010 17:26:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Bastian Hecht <hechtb@googlemail.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: OMAP 3530 camera ISP forks and new media framework
In-Reply-To: <AANLkTikBWjgNmDdG6dCXQQmcDRBUc4gP7717uqAY3+_J@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1010111718010.11865@axis700.grange>
References: <AANLkTimyR117ZiHq8GFz4YW5tBtW3k82NzGVZqKoVTbY@mail.gmail.com>
 <Pine.LNX.4.64.1010072012280.15141@axis700.grange>
 <AANLkTinJhywDoZg5F2tvqdW44to-6P4hgNd9Fav9qTv8@mail.gmail.com>
 <201010111514.37592.laurent.pinchart@ideasonboard.com>
 <AANLkTikBWjgNmDdG6dCXQQmcDRBUc4gP7717uqAY3+_J@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 11 Oct 2010, Bastian Hecht wrote:

> 2010/10/11 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> > Hi Bastian,
> >
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
> your framework is too much for me to start with).

AFAIR, you said, that register sets of mt9t031 and mt9p031 are identical, 
so, I think, I will be against mainlining a new driver for the "same" 
hardware for the pad-level ops, duplicating an soc-camera driver. Apart 
from creating a one-off redundancy, this looks like an extremely negative 
precedent to me.

That said, please, double check your estimate as "identical." If there are 
differences, say, even in only 10% of registers, it might still be 
justified to make a new driver. mt9m001 and mt9t031 are also "very 
similar," still, it appeared to me at that time, that a new driver would 
be cleaner, than a single driver full of forks or other indirections.

Thanks
Guennadi

> So in this driver I
> tell the framework that I can do i2c probing, some subdev_core_ops and
> some subdev_video_ops. I define these functions that mostly do some
> basic i2c communication to the sensor chip. I guess I can handle that
> as there are so many examples out there.
> 
> But where do I stack that on top? On the camera bridge host, but if it
> isn't omap34xxcam, which driver can I use? How are they connected?
> 
> Thanks,
> 
>  Bastian
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
