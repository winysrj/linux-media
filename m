Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:56980 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab3F1HOU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 03:14:20 -0400
From: Jingoo Han <jg1.han@samsung.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org
Cc: 'Kishon Vijay Abraham I' <kishon@ti.com>,
	linux-media@vger.kernel.org, 'Kukjin Kim' <kgene.kim@samsung.com>,
	'Sylwester Nawrocki' <s.nawrocki@samsung.com>,
	'Felipe Balbi' <balbi@ti.com>,
	'Tomasz Figa' <t.figa@samsung.com>,
	devicetree-discuss@lists.ozlabs.org,
	'Inki Dae' <inki.dae@samsung.com>,
	'Donghwa Lee' <dh09.lee@samsung.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Jean-Christophe PLAGNIOL-VILLARD' <plagnioj@jcrosoft.com>,
	linux-fbdev@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>
Subject: [PATCH V2 0/3] Generic PHY driver for the Exynos SoC DP PHY
Date: Fri, 28 Jun 2013 16:14:18 +0900
Message-id: <001e01ce73cf$1ab3ab50$501b01f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds a simple driver for the Samsung Exynos SoC
series DP transmitter PHY, using the generic PHY framework [1].
Previously the DP PHY used a platform callback or internal DT node
to control the PHY power enable bit.
The platform callback and internal DT node can be dropped and this
driver does not need any calls back to the platform code.

These patches was tested on Exynos5250.

This PATCH v2 follows:
 * PATCH v1, sent on June, 28th 2013

Changes between v1 and v2:
  * Replaced exynos_dp_video_phy_xlate() with of_phy_simple_xlate(),
    as Kishon Vijay Abraham I guided.
  * Set the value of phy-cells as 0, because the phy_provider implements
    only one PHY.
  * Removed unnecessary header include.
  * Added '#ifdef CONFIG_OF' and of_match_ptr macro.

This series depends on the generic PHY framework [1]. These patches
refer to Sylwester Nawrocki's patches about Exynos MIPI [2].

[1] https://lkml.org/lkml/2013/6/26/259
[2] http://www.spinics.net/lists/linux-samsung-soc/msg20034.html

Jingoo Han (3):
  phy: Add driver for Exynos DP PHY
  ARM: dts: Add DP PHY node to exynos5250.dtsi
  video: exynos_dp: Use the generic PHY driver

 .../phy/samsung,exynos5250-dp-video-phy.txt        |    7 ++
 .../devicetree/bindings/video/exynos_dp.txt        |   17 ---
 arch/arm/boot/dts/exynos5250.dtsi                  |   13 ++++++++-----
 drivers/phy/Kconfig                                |    8 ++
 drivers/phy/Makefile                               |    3 +-
 drivers/phy/phy-exynos-dp-video.c                  |  122 ++++++++++++++++++++
 drivers/video/exynos/exynos_dp_core.c              |  118 ++------------------
 drivers/video/exynos/exynos_dp_core.h              |    2 +
 include/video/exynos_dp.h                          |    6 +-
 9 files changed, 162 insertions(+), 134 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/samsung,exynos5250-dp-video-phy.txt
 create mode 100644 drivers/phy/phy-exynos-dp-video.c

--
1.7.10.4

