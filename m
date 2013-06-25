Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:37075 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab3FYOQX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jun 2013 10:16:23 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org
Cc: kishon@ti.com, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, balbi@ti.com, t.figa@samsung.com,
	devicetree-discuss@lists.ozlabs.org, kgene.kim@samsung.com,
	dh09.lee@samsung.com, jg1.han@samsung.com, inki.dae@samsung.com,
	plagnioj@jcrosoft.com, linux-fbdev@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 0/5] Generic PHY driver for the Exynos SoC MIPI CSI-2/DSI
 DPHYs
Date: Tue, 25 Jun 2013 16:15:30 +0200
Message-id: <1372169735-12501-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds a simple driver for the Samsung S5P/Exynos SoC
series MIPI CSI-2 receiver (MIPI DSIM) and MIPI DSI transmitter (MIPI
DSIM) DPHYs, using the generic PHY framework [1]. Previously the MIPI
CSIS and MIPI DSIM used a platform callback to control the PHY power
enable and reset bits. The platform callback can be dropped now and
those drivers don't depend any more on any platform code.

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

This series depends on the generic PHY framework [1]. It can be browsed
at: http://git.linuxtv.org/snawrocki/samsung.git/exynos-mipi-phy
This branch is based on the 'for-next' branch from
git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
and the patch series:
http://www.spinics.net/lists/arm-kernel/msg254667.html

Thank you for all the review comments.

[1] https://lkml.org/lkml/2013/6/25/22

Sylwester Nawrocki (5):
  phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs
  ARM: dts: Add MIPI PHY node to exynos4.dtsi
  video: exynos_mipi_dsim: Use generic PHY driver
  exynos4-is: Use generic MIPI CSIS PHY driver
  ARM: Samsung: Remove MIPI PHY setup code

 .../phy/samsung,s5pv210-mipi-video-phy.txt         |   14 ++
 arch/arm/boot/dts/exynos4.dtsi                     |   10 ++
 arch/arm/mach-exynos/include/mach/regs-pmu.h       |    5 -
 arch/arm/mach-s5pv210/include/mach/regs-clock.h    |    4 -
 arch/arm/plat-samsung/Kconfig                      |    5 -
 arch/arm/plat-samsung/Makefile                     |    1 -
 arch/arm/plat-samsung/setup-mipiphy.c              |   60 -------
 drivers/media/platform/exynos4-is/mipi-csis.c      |   16 +-
 drivers/phy/Kconfig                                |    9 +
 drivers/phy/Makefile                               |    3 +-
 drivers/phy/phy-exynos-mipi-video.c                |  173 ++++++++++++++++++++
 drivers/video/exynos/exynos_mipi_dsi.c             |   18 +-
 include/linux/platform_data/mipi-csis.h            |   11 +-
 include/video/exynos_mipi_dsim.h                   |    6 +-
 14 files changed, 236 insertions(+), 99 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/samsung,s5pv210-mipi-video-phy.txt
 delete mode 100644 arch/arm/plat-samsung/setup-mipiphy.c
 create mode 100644 drivers/phy/phy-exynos-mipi-video.c

--
1.7.9.5

