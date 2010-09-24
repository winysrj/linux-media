Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:40465 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab0IXK3L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 06:29:11 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RESEND][PATCH v2 2/6] OMAP1: Add support for SoC camera interface
Date: Fri, 24 Sep 2010 12:28:24 +0200
Cc: Tony Lindgren <tony@atomide.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"Discussion of the Amstrad E3 emailer hardware/software"
	<e3-hacking@earth.li>
References: <201009110317.54899.jkrzyszt@tis.icnet.pl> <20100923235444.GX4211@atomide.com> <Pine.LNX.4.64.1009240853080.14966@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1009240853080.14966@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201009241228.26466.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Friday 24 September 2010 08:54:20 Guennadi Liakhovetski napisał(a):
> On Thu, 23 Sep 2010, Tony Lindgren wrote:
> > * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [100923 16:37]:
> > > Friday 24 September 2010 01:23:10 Tony Lindgren napisał(a):
> > > > I think you can just move the OMAP1_CAMERA_IOSIZE to the devices.c or
> > > > someplace like that?
> > >
> > > Tony,
> > > Not exactly. I use the OMAP1_CAMERA_IOSIZE inside the driver when
> > > reserving space for register cache.
> > >
> > > I think that I could just duplicate its definition in the devices.c for
> > > now, than clean things up with a folloup patch when both parts already
> > > get merged. Would this be acceptable?
> >
> > Yeah, that sounds good to me.
>
> ...better yet put a zero-length cache array at the end of your struct
> omap1_cam_dev and allocate it dynamically, calculated from the resource
> size.

Guennadi,
Yes, this seems the best solution, thank you.

Tony,
You'll soon get it as you ask: <media/camera.h> no longer included from 
<mach/camera.h>.

Thanks,
Janusz
