Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:20737 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab2LJTqS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 14:46:18 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, grant.likely@secretlab.ca,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 00/12] Device tree support for Exynos4 SoC camera drivers
Date: Mon, 10 Dec 2012 20:45:54 +0100
Message-id: <1355168766-6068-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds support for Samsung Exynos4 SoC camera subsystem
drivers. It depends on the video input interfaces bindings and the V4L2 OF
parsing helpers.

Full tree containing these patches can be browsed at:
http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/v3.7-rc8-pq-camera-dt

Sylwester Nawrocki (12):
  s5p-csis: Add device tree support
  s5p-fimc: Add device tree support for FIMC devices
  s5p-fimc: Add device tree support for FIMC-LITE
  s5p-fimc: Instantiate media device from device tree
  s5p-fimc: Add device tree based sensors registration
  s5p-fimc: Use pinctrl API for camera ports configuration
  ARM: EXYNOS4: Add OF_DEV_AUXDATA for FIMC, FIMC-LITE and CSIS
  ARM: dts: Add camera node exynos4.dtsi
  ARM: dts: Add ISP power domain node for Exynos4x12
  ARM: dts: Add FIMC and MIPI CSIS device nodes for Exynos4x12
  ARM: dts: Add camera pinctrl nodes for Exynos4x12 SoCs
  ARM: dts: Add camera device nodes nodes for PQ board

 .../devicetree/bindings/media/soc/samsung-fimc.txt |  183 ++++++++
 .../bindings/media/soc/samsung-mipi-csis.txt       |   82 ++++
 arch/arm/boot/dts/exynos4.dtsi                     |   64 +++
 arch/arm/boot/dts/exynos4412-slp_pq.dts            |  130 ++++++
 arch/arm/boot/dts/exynos4x12-pinctrl.dtsi          |   33 +-
 arch/arm/boot/dts/exynos4x12.dtsi                  |   41 ++
 arch/arm/mach-exynos/mach-exynos4-dt.c             |   16 +
 drivers/media/platform/s5p-fimc/fimc-capture.c     |    2 +-
 drivers/media/platform/s5p-fimc/fimc-core.c        |   84 ++--
 drivers/media/platform/s5p-fimc/fimc-lite.c        |   65 ++-
 drivers/media/platform/s5p-fimc/fimc-mdevice.c     |  462 ++++++++++++++------
 drivers/media/platform/s5p-fimc/fimc-mdevice.h     |   10 +
 drivers/media/platform/s5p-fimc/mipi-csis.c        |  155 +++++--
 drivers/media/platform/s5p-fimc/mipi-csis.h        |    1 +
 14 files changed, 1109 insertions(+), 219 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/soc/samsung-fimc.txt
 create mode 100644 Documentation/devicetree/bindings/media/soc/samsung-mipi-csis.txt

--
1.7.9.5

