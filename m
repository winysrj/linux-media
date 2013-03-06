Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:58831 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757581Ab3CFLyW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 06:54:22 -0500
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, shaik.samsung@gmail.com
Subject: [RFC 00/12] Adding media device driver for Exynos imaging subsystem
Date: Wed,  6 Mar 2013 17:23:46 +0530
Message-Id: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following patchset features:

1] Creating a common pipeline framework which can be used by all
Exynos series SoCs for developing media device drivers.
2] Modified the existing fimc-mdevice for exynos4 to use the common
pipeline framework.
3] Adding of media device driver for Exynos5 Imaging subsystem.
4] Upgrading mipi-csis and fimc-lite drivers for Exynos5 SoCs.
5] Adding DT support to m5mols driver and tested with Exynos5 media
device driver.

Current changes are not tested on exynos4 series SoCs. Current media
device driver only support one pipeline (pipeline0) which consists of 
	Sensor --> MIPI-CSIS --> FIMC-LITE
	Sensor --> FIMC-LITE
G-Scaler support to pipeline0 will be added later.

Once the fimc-is device driver is posted, one more pipeline (pipeline1)
will be added for exynos5 media device driver for fimc-is sub-devices.

This patchset is rebased on:
git://linuxtv.org/media_tree.git:staging/for_v3.9

This patchset depends on:
    from Thomas Abraham:
    [1] pinctrl: exynos: add support for Samsung's Exynos5250
    [2] ARM: dts: add pinctrl nodes for Exynos5250 SoC

from Sylwester Nawrocki:
    [1] Device tree support for Exynos SoC camera subsystem

Shaik Ameer Basha (12):
  media: s5p-fimc: modify existing mdev to use common pipeline
  fimc-lite: Adding Exynos5 compatibility to fimc-lite driver
  media: fimc-lite: Adding support for Exynos5
  s5p-csis: Adding Exynos5250 compatibility
  ARM: EXYNOS: Add devicetree node for mipi-csis driver for exynos5
  ARM: EXYNOS: Add devicetree node for FIMC-LITE driver for exynos5
  media: exynos5-is: Adding media device driver for exynos5
  ARM: dts: add camera specific pinctrl nodes for Exynos5250 SoC
  ARM: dts: Adding pinctrl support to Exynos5250 i2c nodes
  ARM: dts: Adding media device nodes to Exynos5 SoCs
  media: m5mols: Adding dt support to m5mols driver
  ARM: dts: Add camera node to exynos5250-smdk5250.dts

 arch/arm/boot/dts/exynos5250-pinctrl.dtsi        |   41 +
 arch/arm/boot/dts/exynos5250-smdk5250.dts        |   65 +-
 arch/arm/boot/dts/exynos5250.dtsi                |   54 +
 arch/arm/mach-exynos/clock-exynos5.c             |   20 +-
 arch/arm/mach-exynos/include/mach/map.h          |    7 +
 arch/arm/mach-exynos/mach-exynos5-dt.c           |   10 +
 drivers/media/i2c/m5mols/m5mols_core.c           |   54 +-
 drivers/media/platform/Kconfig                   |    1 +
 drivers/media/platform/Makefile                  |    1 +
 drivers/media/platform/exynos5-is/Kconfig        |    7 +
 drivers/media/platform/exynos5-is/Makefile       |    4 +
 drivers/media/platform/exynos5-is/exynos5-mdev.c | 1309 ++++++++++++++++++++++
 drivers/media/platform/exynos5-is/exynos5-mdev.h |  107 ++
 drivers/media/platform/s5p-fimc/fimc-capture.c   |   96 +-
 drivers/media/platform/s5p-fimc/fimc-core.h      |    4 +-
 drivers/media/platform/s5p-fimc/fimc-lite-reg.c  |   16 +-
 drivers/media/platform/s5p-fimc/fimc-lite-reg.h  |   41 +-
 drivers/media/platform/s5p-fimc/fimc-lite.c      |  292 ++++-
 drivers/media/platform/s5p-fimc/fimc-lite.h      |   12 +-
 drivers/media/platform/s5p-fimc/fimc-mdevice.c   |  186 ++-
 drivers/media/platform/s5p-fimc/fimc-mdevice.h   |   41 +-
 drivers/media/platform/s5p-fimc/mipi-csis.c      |    1 +
 include/media/s5p_fimc.h                         |   66 +-
 23 files changed, 2261 insertions(+), 174 deletions(-)
 create mode 100644 drivers/media/platform/exynos5-is/Kconfig
 create mode 100644 drivers/media/platform/exynos5-is/Makefile
 create mode 100644 drivers/media/platform/exynos5-is/exynos5-mdev.c
 create mode 100644 drivers/media/platform/exynos5-is/exynos5-mdev.h

-- 
1.7.9.5

