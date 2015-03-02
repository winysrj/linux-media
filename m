Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45345 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbbCBRF4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2015 12:05:56 -0500
Date: Mon, 2 Mar 2015 17:05:38 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org
Cc: Andrew Lunn <andrew@lunn.ch>, Jaroslav Kysela <perex@perex.cz>,
	Jason Cooper <jason@lakedaemon.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mike Turquette <mturquette@linaro.org>,
	Roland Stigge <stigge@antcom.de>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Stephen Boyd <sboyd@codeaurora.org>,
	Takashi Iwai <tiwai@suse.de>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 00/10] initial clkdev cleanups
Message-ID: <20150302170538.GQ8656@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here's some initial clkdev cleanups.  These are targetted for the next
merge window, and while the initial patches can be merged independently,
I'd prefer to keep the series together as further work on solving the
problems which unique struct clk's has introduced is needed.

The initial cleanups are more about using the correct clkdev function
than anything else: there's no point interating over a array of
clk_lookup structs, adding each one in turn when we have had a function
which does this since forever.

I'm also killing a chunk of seemingly unused code in the omap3isp driver.

Lastly, I'm introducing a clkdev_create() helper, which combines the
clkdev_alloc() + clkdev_add() pattern which keeps cropping up.

Individual patches copied to appropriate people, but they will all appear
on the mailing lists.

 arch/arm/mach-lpc32xx/clock.c                |  5 +--
 arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c | 12 ++-----
 arch/arm/mach-omap2/omap_device.c            | 24 +++++--------
 arch/arm/plat-orion/common.c                 |  6 +---
 arch/sh/kernel/cpu/sh4a/clock-sh7734.c       |  3 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7757.c       |  4 +--
 arch/sh/kernel/cpu/sh4a/clock-sh7785.c       |  4 +--
 arch/sh/kernel/cpu/sh4a/clock-sh7786.c       |  4 +--
 arch/sh/kernel/cpu/sh4a/clock-shx3.c         |  4 +--
 drivers/clk/clk-s2mps11.c                    |  4 +--
 drivers/clk/clkdev.c                         | 52 +++++++++++++++++++++-------
 drivers/clk/versatile/clk-impd1.c            |  4 +--
 drivers/media/platform/omap3isp/isp.c        | 18 ----------
 drivers/media/platform/omap3isp/isp.h        |  1 -
 include/linux/clkdev.h                       |  3 ++
 include/media/omap3isp.h                     |  6 ----
 sound/soc/sh/migor.c                         |  3 +-
 17 files changed, 68 insertions(+), 89 deletions(-)

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
