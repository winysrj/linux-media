Return-path: <mchehab@pedra>
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:49196 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab0IXAti (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Sep 2010 20:49:38 -0400
Date: Thu, 23 Sep 2010 17:49:36 -0700
From: Tony Lindgren <tony@atomide.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Discussion of the Amstrad E3 emailer hardware/software
	<e3-hacking@earth.li>
Subject: Re: [PATCH v2 5/6] OMAP1: Amstrad Delta: add support for camera
Message-ID: <20100924004936.GZ4211@atomide.com>
References: <201009110317.54899.jkrzyszt@tis.icnet.pl>
 <20100923231415.GU4211@atomide.com>
 <20100923232617.GW4211@atomide.com>
 <201009240200.23301.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201009240200.23301.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

* Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [100923 16:52]:
> Friday 24 September 2010 01:26:17 Tony Lindgren napisał(a):
> > * Tony Lindgren <tony@atomide.com> [100923 16:06]:
> > > * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [100910 18:20]:
> > > > This patch adds configuration data and initialization code required for
> > > > camera support to the Amstrad Delta board.
> > > >
> > > > Three devices are declared: SoC camera, OMAP1 camera interface and
> > > > OV6650 sensor.
> > > >
> > > > Default 12MHz clock has been selected for driving the sensor. Pixel
> > > > clock has been limited to get reasonable frame rates, not exceeding the
> > > > board capabilities. Since both devices (interface and sensor) support
> > > > both pixel clock polarities, decision on polarity selection has been
> > > > left to drivers. Interface GPIO line has been found not functional,
> > > > thus not configured.
> > > >
> > > > Created and tested against linux-2.6.36-rc3.
> > > >
> > > > Works on top of previous patches from the series, at least 1/6, 2/6 and
> > > > 3/6.
> > >
> > > Queuing these last two patches of the series (5/6 and 6/6) for the
> > > upcoming merge window.
> >
> > BTW, these still depend on updated 2/6 to make compile happy.
> 
> Not so simple: still depends on struct omap1_cam_platform_data definition from 
> <media/omap1_camera.h>, included from <mach/camera.h>. Are you ready to 
> accept another temporary workaround?

Heh I guess so. Or do you want to queue everything via linux-media?

Tony
