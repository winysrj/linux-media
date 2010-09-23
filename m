Return-path: <mchehab@pedra>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:53749 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab0IWXys (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Sep 2010 19:54:48 -0400
Date: Thu, 23 Sep 2010 16:54:45 -0700
From: Tony Lindgren <tony@atomide.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Discussion of the Amstrad E3 emailer hardware/software
	<e3-hacking@earth.li>
Subject: Re: [RESEND][PATCH v2 2/6] OMAP1: Add support for SoC camera
 interface
Message-ID: <20100923235444.GX4211@atomide.com>
References: <201009110317.54899.jkrzyszt@tis.icnet.pl>
 <201009110334.03905.jkrzyszt@tis.icnet.pl>
 <20100923232309.GV4211@atomide.com>
 <201009240144.47422.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201009240144.47422.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

* Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [100923 16:37]:
> Friday 24 September 2010 01:23:10 Tony Lindgren napisał(a):
> >
> > I think you can just move the OMAP1_CAMERA_IOSIZE to the devices.c or
> > someplace like that?
> 
> Tony,
> Not exactly. I use the OMAP1_CAMERA_IOSIZE inside the driver when reserving 
> space for register cache.
> 
> I think that I could just duplicate its definition in the devices.c for now, 
> than clean things up with a folloup patch when both parts already get merged. 
> Would this be acceptable?

Yeah, that sounds good to me.

Tony
