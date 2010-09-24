Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:45421 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755601Ab0IXG5A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 02:57:00 -0400
Date: Fri, 24 Sep 2010 08:57:06 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Tony Lindgren <tony@atomide.com>
cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Discussion of the Amstrad E3 emailer hardware/software
	<e3-hacking@earth.li>
Subject: Re: [PATCH v2 5/6] OMAP1: Amstrad Delta: add support for camera
In-Reply-To: <20100924004936.GZ4211@atomide.com>
Message-ID: <Pine.LNX.4.64.1009240854470.14966@axis700.grange>
References: <201009110317.54899.jkrzyszt@tis.icnet.pl> <20100923231415.GU4211@atomide.com>
 <20100923232617.GW4211@atomide.com> <201009240200.23301.jkrzyszt@tis.icnet.pl>
 <20100924004936.GZ4211@atomide.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 23 Sep 2010, Tony Lindgren wrote:

> * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [100923 16:52]:
> > Friday 24 September 2010 01:26:17 Tony Lindgren napisał(a):
> > > * Tony Lindgren <tony@atomide.com> [100923 16:06]:
> > > > * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [100910 18:20]:
> > > > > This patch adds configuration data and initialization code required for
> > > > > camera support to the Amstrad Delta board.
> > > > >
> > > > > Three devices are declared: SoC camera, OMAP1 camera interface and
> > > > > OV6650 sensor.
> > > > >
> > > > > Default 12MHz clock has been selected for driving the sensor. Pixel
> > > > > clock has been limited to get reasonable frame rates, not exceeding the
> > > > > board capabilities. Since both devices (interface and sensor) support
> > > > > both pixel clock polarities, decision on polarity selection has been
> > > > > left to drivers. Interface GPIO line has been found not functional,
> > > > > thus not configured.
> > > > >
> > > > > Created and tested against linux-2.6.36-rc3.
> > > > >
> > > > > Works on top of previous patches from the series, at least 1/6, 2/6 and
> > > > > 3/6.
> > > >
> > > > Queuing these last two patches of the series (5/6 and 6/6) for the
> > > > upcoming merge window.
> > >
> > > BTW, these still depend on updated 2/6 to make compile happy.
> > 
> > Not so simple: still depends on struct omap1_cam_platform_data definition from 
> > <media/omap1_camera.h>, included from <mach/camera.h>. Are you ready to 
> > accept another temporary workaround?
> 
> Heh I guess so. Or do you want to queue everything via linux-media?

Yes, we often have to select via which tree to go, then the maintainer of 
the other tree just acks the patches. Sometimes we push them via different 
trees and try to enforce a specific merge order...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
