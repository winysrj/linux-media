Return-path: <mchehab@pedra>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:51067 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab0IWXOR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Sep 2010 19:14:17 -0400
Date: Thu, 23 Sep 2010 16:14:15 -0700
From: Tony Lindgren <tony@atomide.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Discussion of the Amstrad E3 emailer hardware/software
	<e3-hacking@earth.li>
Subject: Re: [PATCH v2 5/6] OMAP1: Amstrad Delta: add support for camera
Message-ID: <20100923231415.GU4211@atomide.com>
References: <201009110317.54899.jkrzyszt@tis.icnet.pl>
 <201009110327.31407.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009110327.31407.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

* Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [100910 18:20]:
> This patch adds configuration data and initialization code required for camera 
> support to the Amstrad Delta board.
> 
> Three devices are declared: SoC camera, OMAP1 camera interface and OV6650 
> sensor.
> 
> Default 12MHz clock has been selected for driving the sensor. Pixel clock has 
> been limited to get reasonable frame rates, not exceeding the board 
> capabilities. Since both devices (interface and sensor) support both pixel 
> clock polarities, decision on polarity selection has been left to drivers.
> Interface GPIO line has been found not functional, thus not configured.
> 
> Created and tested against linux-2.6.36-rc3.
> 
> Works on top of previous patches from the series, at least 1/6, 2/6 and 3/6.

Queuing these last two patches of the series (5/6 and 6/6) for the upcoming
merge window.

Tony
