Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:29698 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab3FNRq1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jun 2013 13:46:27 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: kishon@ti.com
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, kyungmin.park@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	kgene.kim@samsung.com, dh09.lee@samsung.com, jg1.han@samsung.com,
	linux-fbdev@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC PATCH 0/5] Generic PHY driver for Exynos SoCs MIPI CSI-2/DSIM
 DPHYs
Date: Fri, 14 Jun 2013 19:45:46 +0200
Message-id: <1371231951-1969-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

The following is a simple driver for the Samsung S5P/Exynos SoCs MIPI CSI-2
receiver and MIPI DSI transmitter DPHYs, using the generic PHY framework [1].
Previously the MIPI CSIS and MIPI DSIM used a platform callback to control
the PHY power enable and reset bits. The callback can be dropped now and
those drivers don't depend any more on any platform code.

Any comments are welcome.

Thanks,
Sylwester

[1] https://lkml.org/lkml/2013/6/13/97

Sylwester Nawrocki (5):
  phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs
  ARM: dts: Add MIPI PHY node to exynos4.dtsi
  video: exynos_dsi: Use generic PHY driver
  exynos4-is: Use generic MIPI CSIS PHY driver
  ARM: Samsung: Remove MIPI PHY setup code

 .../bindings/phy/exynos-video-mipi-phy.txt         |   16 ++
 arch/arm/boot/dts/exynos4.dtsi                     |   12 ++
 arch/arm/mach-exynos/include/mach/regs-pmu.h       |    5 -
 arch/arm/mach-s5pv210/include/mach/regs-clock.h    |    4 -
 arch/arm/plat-samsung/Makefile                     |    1 -
 arch/arm/plat-samsung/setup-mipiphy.c              |   60 -------
 drivers/media/platform/exynos4-is/mipi-csis.c      |   11 +-
 drivers/phy/Kconfig                                |   10 ++
 drivers/phy/Makefile                               |    3 +-
 drivers/phy/exynos_video_mipi_phy.c                |  166 ++++++++++++++++++++
 drivers/video/display/source-exynos_dsi.c          |   36 ++---
 include/linux/platform_data/mipi-csis.h            |    9 --
 include/video/exynos_dsi.h                         |    5 -
 13 files changed, 226 insertions(+), 112 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/exynos-video-mipi-phy.txt
 delete mode 100644 arch/arm/plat-samsung/setup-mipiphy.c
 create mode 100644 drivers/phy/exynos_video_mipi_phy.c

--
1.7.9.5

