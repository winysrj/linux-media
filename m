Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:46583 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759389Ab3JPQ2m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Oct 2013 12:28:42 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-fbdev@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
	<kishon@ti.com>
Subject: [PATCH 0/7] video phy's adaptation to *generic phy framework*
Date: Wed, 16 Oct 2013 21:58:09 +0530
Message-ID: <1381940896-9355-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Greg,

This series includes video PHY adaptation to Generic PHY Framework.
With the adaptation they were able to get rid of plat data callbacks.

Since you've taken the Generic PHY Framework, I think this series should
also go into your tree.

We should thank Sylwester for actively testing and giving comments from
the initial versions of Generic Phy Framework. Both Sylwester and Jingoo
had been floating many revisions of their adaptation to Generic PHY
Framework.

This has been in my repo for quite some time and has got acks from
samsung maintainer and video maintainer.

If you want me to change anything, please let me know.

This patch series can be found @
git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git testing

Jingoo Han (3):
  phy: Add driver for Exynos DP PHY
  video: exynos_dp: remove non-DT support for Exynos Display Port
  video: exynos_dp: Use the generic PHY driver

Sylwester Nawrocki (4):
  phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs
  exynos4-is: Use the generic MIPI CSIS PHY driver
  video: exynos_mipi_dsim: Use the generic PHY driver
  ARM: Samsung: Remove the MIPI PHY setup code

 .../devicetree/bindings/phy/samsung-phy.txt        |   22 +++
 .../devicetree/bindings/video/exynos_dp.txt        |   17 +-
 arch/arm/mach-exynos/include/mach/regs-pmu.h       |    5 -
 arch/arm/mach-s5pv210/include/mach/regs-clock.h    |    4 -
 arch/arm/plat-samsung/Kconfig                      |    5 -
 arch/arm/plat-samsung/Makefile                     |    1 -
 arch/arm/plat-samsung/setup-mipiphy.c              |   60 -------
 drivers/media/platform/exynos4-is/Kconfig          |    2 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |   13 +-
 drivers/phy/Kconfig                                |   13 ++
 drivers/phy/Makefile                               |    8 +-
 drivers/phy/phy-exynos-dp-video.c                  |  111 ++++++++++++
 drivers/phy/phy-exynos-mipi-video.c                |  176 ++++++++++++++++++++
 drivers/video/exynos/Kconfig                       |    3 +-
 drivers/video/exynos/exynos_dp_core.c              |  132 ++++-----------
 drivers/video/exynos/exynos_dp_core.h              |  110 ++++++++++++
 drivers/video/exynos/exynos_dp_reg.c               |    2 -
 drivers/video/exynos/exynos_mipi_dsi.c             |   19 ++-
 include/linux/platform_data/mipi-csis.h            |    9 -
 include/video/exynos_dp.h                          |  131 ---------------
 include/video/exynos_mipi_dsim.h                   |    5 +-
 21 files changed, 508 insertions(+), 340 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/samsung-phy.txt
 delete mode 100644 arch/arm/plat-samsung/setup-mipiphy.c
 create mode 100644 drivers/phy/phy-exynos-dp-video.c
 create mode 100644 drivers/phy/phy-exynos-mipi-video.c
 delete mode 100644 include/video/exynos_dp.h

-- 
1.7.10.4

