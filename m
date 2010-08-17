Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:49249 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755088Ab0HQNVo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Aug 2010 09:21:44 -0400
Date: Tue, 17 Aug 2010 15:21:57 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Michael Grzeschik <mgr@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH v2 00/11] MT9M111/MT9M131
In-Reply-To: <20100817131742.GB16061@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1008171521210.1364@axis700.grange>
References: <1280833069-26993-1-git-send-email-m.grzeschik@pengutronix.de>
 <20100817131742.GB16061@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Tue, 17 Aug 2010, Michael Grzeschik wrote:

> Hi Robert, Guennadi,
> 
> after the messed up previous patchseries, this v2 series is left
> without any feedback. Hopefully not forgotten. :-)

No, it is not forgotten, please, give me some more time.

Thanks
Guennadi

> 
> Btw: The first two patches are already applied.
> 
> Thanks,
> Michael
> 
> On Tue, Aug 03, 2010 at 12:57:38PM +0200, Michael Grzeschik wrote:
> > Hey everyone,
> > 
> > here is v2 of the previous (a little messy) patchseries. After i
> > figured out that the biggest part of the patches were cutted into
> > unrelated and unneeded pieces here hopefully comes a cleaner patchstack.
> > 
> > The rest of the patches i send last time is living in my git repo for
> > review, until i figured out that the code is mostly needed for the
> > softcropping feature of the camera.
> > 
> > But first things first, here are my changes:
> > 
> > Michael Grzeschik (9):
> >   mt9m111: init chip after read CHIP_VERSION
> >   mt9m111: register cleanup hex to dec bitoffset
> >   mt9m111: added new bit offset defines
> >   mt9m111: changed MIN_DARK_COLS to MT9M131 spec count
> >   mt9m111: cropcap and s_crop check if type is VIDEO_CAPTURE
> >   mt9m111: added current colorspace at g_fmt
> >   mt9m111: added reg_mask function
> >   mt9m111: rewrite set_pixfmt
> >   mt9m111: make use of testpattern
> > 
> > Philipp Wiesner (1):
> >   mt9m111: Added indication that MT9M131 is supported by this driver
> > 
> > Sascha Hauer (1):
> >   v4l2-mediabus: Add pixelcodes for BGR565 formats
> > 
> >  drivers/media/video/Kconfig   |    5 +-
> >  drivers/media/video/mt9m111.c |  283 ++++++++++++++++++++++++-----------------
> >  include/media/v4l2-mediabus.h |    2 +
> >  3 files changed, 174 insertions(+), 116 deletions(-)
> > 
> 
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
