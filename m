Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:60903 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750880Ab0IXGyN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 02:54:13 -0400
Date: Fri, 24 Sep 2010 08:54:20 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Tony Lindgren <tony@atomide.com>
cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Discussion of the Amstrad E3 emailer hardware/software
	<e3-hacking@earth.li>
Subject: Re: [RESEND][PATCH v2 2/6] OMAP1: Add support for SoC camera interface
In-Reply-To: <20100923235444.GX4211@atomide.com>
Message-ID: <Pine.LNX.4.64.1009240853080.14966@axis700.grange>
References: <201009110317.54899.jkrzyszt@tis.icnet.pl>
 <201009110334.03905.jkrzyszt@tis.icnet.pl> <20100923232309.GV4211@atomide.com>
 <201009240144.47422.jkrzyszt@tis.icnet.pl> <20100923235444.GX4211@atomide.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 23 Sep 2010, Tony Lindgren wrote:

> * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [100923 16:37]:
> > Friday 24 September 2010 01:23:10 Tony Lindgren napisał(a):
> > >
> > > I think you can just move the OMAP1_CAMERA_IOSIZE to the devices.c or
> > > someplace like that?
> > 
> > Tony,
> > Not exactly. I use the OMAP1_CAMERA_IOSIZE inside the driver when reserving 
> > space for register cache.
> > 
> > I think that I could just duplicate its definition in the devices.c for now, 
> > than clean things up with a folloup patch when both parts already get merged. 
> > Would this be acceptable?
> 
> Yeah, that sounds good to me.

...better yet put a zero-length cache array at the end of your struct 
omap1_cam_dev and allocate it dynamically, calculated from the resource 
size.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
