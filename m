Return-path: <mchehab@pedra>
Received: from msa105.auone-net.jp ([61.117.18.165]:56966 "EHLO
	msa105.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab1DMOO1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2011 10:14:27 -0400
Date: Wed, 13 Apr 2011 22:56:56 +0900
From: Akira Tsukamoto <akira-t@s9.dion.ne.jp>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: soc_camera with V4L2 driver 
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1104131540100.3565@axis700.grange>
References: <20110413222332.59A5.B41FCDD0@s9.dion.ne.jp> <Pine.LNX.4.64.1104131540100.3565@axis700.grange>
Message-Id: <20110413225655.7E32.B41FCDD0@s9.dion.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Guennadi,

Thank you for the quick response.

> > I am implementing 2mega pixel camera driver made by sharp and
> > attached my primal kernel driver.
> > (I still do not have the data sheet yet...)
> 
> Thanks for attaching your driver. You can have a look at another driver 
> for a Sharp camera sensor:
> 
> drivers/media/video/rj54n1cb0c.c
> 
> and at its platform glue in arch/sh/boards/mach-kfr2r09/setup.c, there you 
> find
> 
> struct platform_device kfr2r09_camera
> 
> which links to
> 
> struct soc_camera_link rj54n1_link
> 
> etc. It would also help to know, with which SoC you're working, because in 
> your platform code you'll need both platform data for the sensor and for 
> the host. Feel free to ask, if you have more questions, but please also cc 
> the mailing list.

Great!
I will look into rj54n1cb0c.c and mach-kfr2r09/setup.c of the:

struct soc_camera_link rj54n1_link

The ARM CPU is Renesas SoC.

> > On Wed, 13 Apr 2011 08:29:31 -0300
> > Mauro Carvalho Chehab <mchehab@infradead.org> mentioned:
> > > > Thank you for the great advice.
> > > > How do I bind the driver to soc_camera in my attached file?
> > > 
> > > You'll need to add some glue on it, via platform_data. I never wrote such glue for soc_camera,
> > > so I can't give you the exact directions, but feel free to contact Guennadi (soc_camera author
> > > and maintainer) to get more details.
> > 
> > How do I glue together my attached driver with your soc_camera?
> > May I have a pointer or suggestion?
> > 
> > I was project leader of PlayStaion3 Linux and now moved 
> > Nomovok to develop ARM based embedded devices.

With kind regards,

Akira

> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

-- 
Akira Tsukamoto <akira-t@s9.dion.ne.jp>

