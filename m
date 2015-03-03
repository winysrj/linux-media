Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27680 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbbCCP44 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Mar 2015 10:56:56 -0500
Message-ID: <1425398207.14897.152.camel@linux.intel.com>
Subject: Re: [PATCH 00/10] initial clkdev cleanups
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org, Roland Stigge <stigge@antcom.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Mike Turquette <mturquette@linaro.org>,
	Jason Cooper <jason@lakedaemon.net>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Takashi Iwai <tiwai@suse.de>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Tony Lindgren <tony@atomide.com>,
	Mark Brown <broonie@kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date: Tue, 03 Mar 2015 17:56:47 +0200
In-Reply-To: <54F4DB34.9000507@codeaurora.org>
References: <20150302170538.GQ8656@n2100.arm.linux.org.uk>
	 <54F4DB34.9000507@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2015-03-02 at 13:50 -0800, Stephen Boyd wrote:
> On 03/02/15 09:05, Russell King - ARM Linux wrote:
> > Here's some initial clkdev cleanups.  These are targetted for the next
> > merge window, and while the initial patches can be merged independently,
> > I'd prefer to keep the series together as further work on solving the
> > problems which unique struct clk's has introduced is needed.


> > I'm also killing a chunk of seemingly unused code in the omap3isp driver.
> >
> > Lastly, I'm introducing a clkdev_create() helper, which combines the
> > clkdev_alloc() + clkdev_add() pattern which keeps cropping up.
> >
> 
> We already have a solution to that problem with clk_register_clkdev().
> Andy has done some work to make clk_register_clkdev() return a struct
> clk_lookup pointer[1]. Maybe we can do that instead of introducing a new
> clkdev_create() function. There is some benefit to having a new function
> though so that we can avoid a flag day, although it looks like the flag
> day is small in this case so it might not actually matter.

> [1] https://www.marc.info/?l=linux-kernel&m=142469226512289

Agree with Stephen, why should we have the second function doing the
same? Just name changing?

I think you may just incorporate that patch into your series.

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

