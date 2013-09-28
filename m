Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:36794 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab3I1T2G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Sep 2013 15:28:06 -0400
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: kishon@ti.com
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, linux-arm-kernel@lists.infradead.org,
	kgene.kim@samsung.com, dh09.lee@samsung.com, jg1.han@samsung.com,
	tomi.valkeinen@ti.com, plagnioj@jcrosoft.com,
	linux-fbdev@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH V5 0/5] Generic PHY driver for the Exynos SoC MIPI CSI-2/DSI DPHYs
Date: Sat, 28 Sep 2013 21:27:42 +0200
Message-Id: <1380396467-29278-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds a simple driver for the Samsung S5P/Exynos SoC
series MIPI CSI-2 receiver (MIPI CSIS) and MIPI DSI transmitter (MIPI
DSIM) DPHYs, using the generic PHY framework. Previously the MIPI
CSIS and MIPI DSIM used a platform callback to control the PHY power
enable and reset bits. This non-generic platform code supporting only
limited set of SoCs is now removed.
This completes migration to the device tree of the Exynos/S5P MIPI CSI
slave device driver.

Changes since v4:
 - updated to the latest version of the generic PHY framework - removed
   PHY labels from the platform data structure. There is already no need
   for non-dt support in this PHY driver so the platform data where any
   struct phy_init_data would be passed is not added.

Changes since v3 (only patch 1/5):
 - replaced spin_(un)lock_irq_{save,restore} with spin_{lock,unlock}.
 - DT binding file renamed to samsung-phy.txt, so it can be used for
   other PHYs as well,
 - removed <linux/delay.h> inclusion,
 - added missing spin_lock_init().

Changes since v2:
 - adapted to the generic PHY API v9: use phy_set/get_drvdata(),
 - fixed of_xlate callback to return ERR_PTR() instead of NULL,
 - namespace cleanup, put "GPL v2" as MODULE_LICENSE, removed pr_debug,
 - removed phy id check in __set_phy_state().

Changes since v1:
 - enabled build as module and with CONFIG_OF disabled,
 - added phy_id enum,
 - of_address_to_resource() replaced with platform_get_resource(),
 - adapted to changes in the PHY API v7, v8 - added phy labels,
 - added MODULE_DEVICE_TABLE() entry,
 - the driver file renamed to phy-exynos-mipi-video.c,
 - changed DT compatible string to "samsung,s5pv210-mipi-video-phy",
 - corrected the compatible property's description.
 - patch 3/5 "video: exynos_dsi: Use generic PHY driver" replaced
   with a patch modifying the MIPI DSIM driver which is currently
   in mainline.

Sylwester Nawrocki (5):
  ARM: dts: Add MIPI PHY node to exynos4.dtsi
  phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs
  [media] exynos4-is: Use the generic MIPI CSIS PHY driver
  video: exynos_mipi_dsim: Use the generic PHY driver
  ARM: Samsung: Remove the MIPI PHY setup code

 .../devicetree/bindings/phy/samsung-phy.txt        |   14 ++
 arch/arm/boot/dts/exynos4.dtsi                     |   10 +
 arch/arm/mach-exynos/include/mach/regs-pmu.h       |    5 -
 arch/arm/mach-s5pv210/include/mach/regs-clock.h    |    4 -
 arch/arm/plat-samsung/Kconfig                      |    5 -
 arch/arm/plat-samsung/Makefile                     |    1 -
 arch/arm/plat-samsung/setup-mipiphy.c              |   60 -------
 drivers/media/platform/exynos4-is/Kconfig          |    2 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |   13 +-
 drivers/phy/Kconfig                                |    6 +
 drivers/phy/Makefile                               |    7 +-
 drivers/phy/phy-exynos-mipi-video.c                |  176 ++++++++++++++++++++
 drivers/video/exynos/Kconfig                       |    1 +
 drivers/video/exynos/exynos_mipi_dsi.c             |   19 +-
 include/linux/platform_data/mipi-csis.h            |    9 -
 include/video/exynos_mipi_dsim.h                   |    5 +-
 16 files changed, 234 insertions(+), 103 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/samsung-phy.txt
 delete mode 100644 arch/arm/plat-samsung/setup-mipiphy.c
 create mode 100644 drivers/phy/phy-exynos-mipi-video.c

--
1.7.4.1

