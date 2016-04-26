Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:52336 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448AbcDZXv5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Apr 2016 19:51:57 -0400
From: Tony Lindgren <tony@atomide.com>
To: linux-omap@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Sebastian Reichel <sre@kernel.org>,
	Pavel Machel <pavel@ucw.cz>,
	Timo Kokkonen <timo.t.kokkonen@iki.fi>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Neil Armstrong <narmstrong@baylibre.com>
Subject: [PATCH 0/2] Fix ir-rx51 by using PWM pdata
Date: Tue, 26 Apr 2016 16:51:47 -0700
Message-Id: <1461714709-10455-1-git-send-email-tony@atomide.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Here are minimal fixes to get ir-rx51 going again. Then further
fixes can be done as noted in the second patch.

Regards,

Tony


Tony Lindgren (2):
  ARM: OMAP2+: Add more functions to pwm pdata for ir-rx51
  [media] ir-rx51: Fix build after multiarch changes broke it

 arch/arm/mach-omap2/board-rx51-peripherals.c   | 35 ++++++++-
 arch/arm/mach-omap2/pdata-quirks.c             | 33 ++++++++-
 drivers/media/rc/Kconfig                       |  2 +-
 drivers/media/rc/ir-rx51.c                     | 99 ++++++++++++++------------
 include/linux/platform_data/media/ir-rx51.h    |  1 +
 include/linux/platform_data/pwm_omap_dmtimer.h | 21 ++++++
 6 files changed, 141 insertions(+), 50 deletions(-)

-- 
2.8.1

