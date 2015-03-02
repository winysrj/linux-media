Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39846 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbbCBVur (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2015 16:50:47 -0500
Message-ID: <54F4DB34.9000507@codeaurora.org>
Date: Mon, 02 Mar 2015 13:50:44 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Roland Stigge <stigge@antcom.de>, Andrew Lunn <andrew@lunn.ch>,
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
Subject: Re: [PATCH 00/10] initial clkdev cleanups
References: <20150302170538.GQ8656@n2100.arm.linux.org.uk>
In-Reply-To: <20150302170538.GQ8656@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/02/15 09:05, Russell King - ARM Linux wrote:
> Here's some initial clkdev cleanups.  These are targetted for the next
> merge window, and while the initial patches can be merged independently,
> I'd prefer to keep the series together as further work on solving the
> problems which unique struct clk's has introduced is needed.
>
> The initial cleanups are more about using the correct clkdev function
> than anything else: there's no point interating over a array of
> clk_lookup structs, adding each one in turn when we have had a function
> which does this since forever.

The clkdev_add_table() conversions look good.

>
> I'm also killing a chunk of seemingly unused code in the omap3isp driver.
>
> Lastly, I'm introducing a clkdev_create() helper, which combines the
> clkdev_alloc() + clkdev_add() pattern which keeps cropping up.
>

We already have a solution to that problem with clk_register_clkdev().
Andy has done some work to make clk_register_clkdev() return a struct
clk_lookup pointer[1]. Maybe we can do that instead of introducing a new
clkdev_create() function. There is some benefit to having a new function
though so that we can avoid a flag day, although it looks like the flag
day is small in this case so it might not actually matter.

[1] https://www.marc.info/?l=linux-kernel&m=142469226512289

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

