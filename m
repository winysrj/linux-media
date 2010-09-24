Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:52393 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab0IXLJL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 07:09:11 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v2 5/6] OMAP1: Amstrad Delta: add support for camera
Date: Fri, 24 Sep 2010 13:08:38 +0200
Cc: Tony Lindgren <tony@atomide.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Discussion of the Amstrad E3 emailer hardware/software"
	<e3-hacking@earth.li>
References: <201009110317.54899.jkrzyszt@tis.icnet.pl> <20100924004936.GZ4211@atomide.com> <Pine.LNX.4.64.1009240854470.14966@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1009240854470.14966@axis700.grange>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <201009241308.39948.jkrzyszt@tis.icnet.pl>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Friday 24 September 2010 08:57:06 Guennadi Liakhovetski napisał(a):
> On Thu, 23 Sep 2010, Tony Lindgren wrote:
> > * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [100923 16:52]:
> > > Friday 24 September 2010 01:26:17 Tony Lindgren napisał(a):
> > > > * Tony Lindgren <tony@atomide.com> [100923 16:06]:
> > > > > * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [100910 18:20]:
> > > > > > This patch adds configuration data and initialization code
> > > > > > required for camera support to the Amstrad Delta board.
> > > > > >
> > > > > > Three devices are declared: SoC camera, OMAP1 camera interface
> > > > > > and OV6650 sensor.
> > > > > >
> > > > > > Default 12MHz clock has been selected for driving the sensor.
> > > > > > Pixel clock has been limited to get reasonable frame rates, not
> > > > > > exceeding the board capabilities. Since both devices (interface
> > > > > > and sensor) support both pixel clock polarities, decision on
> > > > > > polarity selection has been left to drivers. Interface GPIO line
> > > > > > has been found not functional, thus not configured.
> > > > > >
> > > > > > Created and tested against linux-2.6.36-rc3.
> > > > > >
> > > > > > Works on top of previous patches from the series, at least 1/6,
> > > > > > 2/6 and 3/6.
> > > > >
> > > > > Queuing these last two patches of the series (5/6 and 6/6) for the
> > > > > upcoming merge window.
> > > >
> > > > BTW, these still depend on updated 2/6 to make compile happy.
> > >
> > > Not so simple: still depends on struct omap1_cam_platform_data
> > > definition from <media/omap1_camera.h>, included from <mach/camera.h>.
> > > Are you ready to accept another temporary workaround?
> >
> > Heh I guess so. Or do you want to queue everything via linux-media?

AFAIK we can expect my arch/arm/mach-omap1/devices.c changes already resulting 
in a confilct with some ASoC OMAP related changes going via the sound tree, 
so the 2/6 should be better queued via the OMAP tree for Tony to keep control 
over it, with the rest of the seriers going either way.

> Yes, we often have to select via which tree to go, then the maintainer of
> the other tree just acks the patches. Sometimes we push them via different
> trees and try to enforce a specific merge order...

What about

+ void omap1_set_camera_info(struct omap1_cam_platform_data *);

put temporarily into to the arch/arm/mach-omap1/board-ams-delta.c instead of 
including <mach/camera.h>, that could be replaced with <media/omap1_camera.h> 
then? May sound better than redefining struct omap1_cam_platform_data there, 
and should be safe to push everything except 2/6 via the media tree.

Then, replace the above hack back with #include <mach/camera.h> as a fix after 
both are merged.

Thanks,
Janusz
