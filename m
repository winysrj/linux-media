Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:33733 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbbDCRMI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2015 13:12:08 -0400
Date: Fri, 3 Apr 2015 18:11:49 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org
Cc: Andrew Lunn <andrew@lunn.ch>, Daniel Mack <daniel@zonque.org>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Jason Cooper <jason@lakedaemon.net>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mike Turquette <mturquette@linaro.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Roland Stigge <stigge@antcom.de>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Sekhar Nori <nsekhar@ti.com>,
	Stephen Boyd <sboyd@codeaurora.org>,
	Takashi Iwai <tiwai@suse.de>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 00/14] Fix fallout from per-user struct clk patches
Message-ID: <20150403171149.GC13898@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry for posting this soo close to the 4.1 merge window, I had
completely forgotten about this chunk of work I did earlier this
month.

The per-user struct clk patches rather badly broke clkdev and
various other places.  This was reported, but was forgotten about.
Really, the per-user clk stuff should've been reverted, but we've
lived with it far too long for that.

So, our only other option is to now rush these patches into 4.1
and hope for the best.

The series cleans up quite a number of places too...

 arch/arm/mach-davinci/da850.c                |  1 +
 arch/arm/mach-lpc32xx/clock.c                |  5 +-
 arch/arm/mach-omap1/board-nokia770.c         |  2 +-
 arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c | 12 +---
 arch/arm/mach-omap2/omap_device.c            | 24 +++-----
 arch/arm/mach-pxa/eseries.c                  |  1 +
 arch/arm/mach-pxa/lubbock.c                  |  1 +
 arch/arm/mach-pxa/tosa.c                     |  1 +
 arch/arm/plat-orion/common.c                 |  6 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7734.c       |  3 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7757.c       |  4 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7785.c       |  4 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7786.c       |  4 +-
 arch/sh/kernel/cpu/sh4a/clock-shx3.c         |  4 +-
 drivers/clk/clk-s2mps11.c                    |  4 +-
 drivers/clk/clkdev.c                         | 83 ++++++++++++++++++++--------
 drivers/media/platform/omap3isp/isp.c        | 18 ------
 drivers/media/platform/omap3isp/isp.h        |  1 -
 include/linux/clk.h                          | 27 ++++-----
 include/linux/clkdev.h                       |  6 +-
 include/media/omap3isp.h                     |  6 --
 sound/soc/sh/migor.c                         |  3 +-
 22 files changed, 108 insertions(+), 112 deletions(-)

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
