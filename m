Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:45536 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab3F1FVW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 01:21:22 -0400
From: Jingoo Han <jg1.han@samsung.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
	linux-media@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Felipe Balbi <balbi@ti.com>, Tomasz Figa <t.figa@samsung.com>,
	devicetree-discuss@lists.ozlabs.org,
	'Inki Dae' <inki.dae@samsung.com>,
	'Donghwa Lee' <dh09.lee@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
	linux-fbdev@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 0/3] Generic PHY driver for the Exynos SoC DP PHY
Date: Fri, 28 Jun 2013 14:21:15 +0900
Message-id: <001401ce73bf$4f9a67b0$eecf3710$@samsung.com>
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
 drivers/phy/phy-exynos-dp-video.c                  |  130 ++++++++++++++++++++
 drivers/video/exynos/exynos_dp_core.c              |  118 ++------------------
 drivers/video/exynos/exynos_dp_core.h              |    2 +
 include/video/exynos_dp.h                          |    6 +-
 9 files changed, 170 insertions(+), 134 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/samsung,exynos5250-dp-video-phy.txt
 create mode 100644 drivers/phy/phy-exynos-dp-video.c

--
1.7.10.4

