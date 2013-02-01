Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:55359 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab3BATJr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 14:09:47 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, kgene.kim@samsung.com,
	swarren@wwwdotorg.org, rob.herring@calxeda.com,
	prabhakar.lad@ti.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v4 00/10] Device tree support for Exynos SoC camera subsystem
Date: Fri, 01 Feb 2013 20:09:21 +0100
Message-id: <1359745771-23684-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an updated patch series adding initial support for the Exynos4
SoC series camera subsystem. It is based on the video interfaces common
device tree bindings and depends on patch series [1]. The full source
tree can be browsed at [2].

I've dropped the RFC tag from this series and I'm going to continue with
adding support for asynchronous sensor subdevs registration and the
FIMC-IS on top of it. Unless there are further changes in the bindings.

Still, any comments are welcome.
The changes are listed in each patch, if any.

This series likely won't make it to v3.9. It would be nice, but there
seems not to be much interest in getting [1] in the mainline and the
reviews are relatively slow.

Any Ack/nack from the device tree maintainers are welcome, so I could
finally have this patch set merged and carry on with other, even more
interesting things. :)

Thanks,
Sylwester

[1] http://www.spinics.net/lists/linux-media/msg59471.html
[2] http://git.linuxtv.org/snawrocki/samsung.git/exynos_fimc

Sylwester Nawrocki (10):
  s5p-csis: Add device tree support
  s5p-fimc: Add device tree support for FIMC devices
  s5p-fimc: Add device tree support for FIMC-LITE devices
  s5p-fimc: Add device tree support for the main media device driver
  s5p-fimc: Add device tree based sensors registration
  s5p-fimc: Use pinctrl API for camera ports configuration
  ARM: dts: Add camera to node exynos4.dtsi
  ARM: dts: Add ISP power domain node for Exynos4x12
  ARM: dts: Add FIMC and MIPI CSIS device nodes for Exynos4x12
  ARM: dts: Correct camera pinctrl nodes for Exynos4x12 SoCs

 .../devicetree/bindings/media/soc/samsung-fimc.txt |  183 +++++++++++
 .../bindings/media/soc/samsung-mipi-csis.txt       |   82 +++++
 arch/arm/boot/dts/exynos4.dtsi                     |   64 ++++
 arch/arm/boot/dts/exynos4x12-pinctrl.dtsi          |   26 +-
 arch/arm/boot/dts/exynos4x12.dtsi                  |   52 ++++
 drivers/media/platform/s5p-fimc/fimc-capture.c     |    2 +-
 drivers/media/platform/s5p-fimc/fimc-core.c        |   94 ++++--
 drivers/media/platform/s5p-fimc/fimc-lite.c        |   65 ++--
 drivers/media/platform/s5p-fimc/fimc-mdevice.c     |  319 ++++++++++++++++++--
 drivers/media/platform/s5p-fimc/fimc-mdevice.h     |    4 +
 drivers/media/platform/s5p-fimc/mipi-csis.c        |  154 +++++++---
 drivers/media/platform/s5p-fimc/mipi-csis.h        |    1 +
 include/media/s5p_fimc.h                           |   17 ++
 13 files changed, 936 insertions(+), 127 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/soc/samsung-fimc.txt
 create mode 100644 Documentation/devicetree/bindings/media/soc/samsung-mipi-csis.txt

--
1.7.9.5

