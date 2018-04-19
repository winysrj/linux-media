Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:48004 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752153AbeDSUA0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 16:00:26 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mips@linux-mips.org, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: [PATCH 0/7] i2c: clean up include/linux/i2c-*
Date: Thu, 19 Apr 2018 22:00:06 +0200
Message-Id: <20180419200015.15095-1-wsa@the-dreams.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move all plain platform_data includes to the platform_data-dir
(except for i2c-pnx which can be moved into the driver itself).

My preference is to take these patches via the i2c tree. I can provide an
immutable branch if needed. But we can also discuss those going in via
arch-trees if dependencies are against us.

The current branch can be found here:

git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/platform_data

and buildbot had no complaints.

Looking forward to comments or Acks, Revs...

Kind regards,

   Wolfram


Wolfram Sang (7):
  i2c: i2c-gpio: move header to platform_data
  i2c: i2c-mux-gpio: move header to platform_data
  i2c: i2c-ocores: move header to platform_data
  i2c: i2c-omap: move header to platform_data
  i2c: i2c-pca-platform: move header to platform_data
  i2c: i2c-xiic: move header to platform_data
  i2c: pnx: move header into the driver

 Documentation/i2c/busses/i2c-ocores                |  2 +-
 Documentation/i2c/muxes/i2c-mux-gpio               |  4 +--
 MAINTAINERS                                        |  8 ++---
 arch/arm/mach-ks8695/board-acs5k.c                 |  2 +-
 arch/arm/mach-omap1/board-htcherald.c              |  2 +-
 arch/arm/mach-omap1/common.h                       |  2 +-
 arch/arm/mach-omap1/i2c.c                          |  2 +-
 arch/arm/mach-omap2/common.h                       |  2 +-
 arch/arm/mach-omap2/omap_hwmod_2420_data.c         |  2 +-
 arch/arm/mach-omap2/omap_hwmod_2430_data.c         |  2 +-
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c         |  2 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |  2 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |  2 +-
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c         |  2 +-
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c          |  2 +-
 arch/arm/mach-pxa/palmz72.c                        |  2 +-
 arch/arm/mach-pxa/viper.c                          |  2 +-
 arch/arm/mach-sa1100/simpad.c                      |  2 +-
 arch/mips/alchemy/board-gpr.c                      |  2 +-
 arch/sh/boards/board-sh7785lcr.c                   |  2 +-
 drivers/i2c/busses/i2c-gpio.c                      |  2 +-
 drivers/i2c/busses/i2c-i801.c                      |  2 +-
 drivers/i2c/busses/i2c-ocores.c                    |  2 +-
 drivers/i2c/busses/i2c-omap.c                      |  2 +-
 drivers/i2c/busses/i2c-pca-platform.c              |  2 +-
 drivers/i2c/busses/i2c-pnx.c                       | 21 +++++++++++-
 drivers/i2c/busses/i2c-xiic.c                      |  2 +-
 drivers/i2c/muxes/i2c-mux-gpio.c                   |  2 +-
 drivers/media/platform/marvell-ccic/mmp-driver.c   |  2 +-
 drivers/mfd/sm501.c                                |  2 +-
 drivers/mfd/timberdale.c                           |  4 +--
 include/linux/i2c-pnx.h                            | 38 ----------------------
 include/linux/{ => platform_data}/i2c-gpio.h       |  0
 include/linux/{ => platform_data}/i2c-mux-gpio.h   |  0
 include/linux/{ => platform_data}/i2c-ocores.h     |  0
 include/linux/{ => platform_data}/i2c-omap.h       |  0
 .../linux/{ => platform_data}/i2c-pca-platform.h   |  0
 include/linux/{ => platform_data}/i2c-xiic.h       |  0
 38 files changed, 55 insertions(+), 74 deletions(-)
 delete mode 100644 include/linux/i2c-pnx.h
 rename include/linux/{ => platform_data}/i2c-gpio.h (100%)
 rename include/linux/{ => platform_data}/i2c-mux-gpio.h (100%)
 rename include/linux/{ => platform_data}/i2c-ocores.h (100%)
 rename include/linux/{ => platform_data}/i2c-omap.h (100%)
 rename include/linux/{ => platform_data}/i2c-pca-platform.h (100%)
 rename include/linux/{ => platform_data}/i2c-xiic.h (100%)

-- 
2.11.0
