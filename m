Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:26908 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370Ab2ICNF6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2012 09:05:58 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org, linux-media@vger.kernel.org
Cc: kgene.kim@samsung.com, k.debski@samsung.com, jtp.park@samsung.com,
	ch.naveen@samsung.com, arun.kk@samsung.com,
	thomas.abraham@linaro.org, kmpark@infradead.org, joshi@samsung.com
Subject: [PATCH v1 0/2] Add MFC device tree support
Date: Mon, 03 Sep 2012 22:22:56 +0530
Message-id: <1346691178-29580-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset adds device tree support for s5p-mfc driver.
The first patch adds DT support for both Exynos4 and 5 SoCs
which has different versions of MFC. The second patch which
adds DT support for the driver has to be applied over the 
patchset [1] which adds the MFCv6 support.

Changelog:
- Moved board specific DT information to different dtsi file
- Changed compatible name for the device
- Addressed other review comments

[1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg51284.html

Arun Kumar K (1):
  [media] s5p-mfc: Add device tree support

Naveen Krishna Chatradhi (1):
  ARM: EXYNOS: Add MFC device tree support

 .../devicetree/bindings/media/s5p-mfc.txt          |   27 +++++
 arch/arm/boot/dts/exynos4210-origen.dts            |    7 ++
 arch/arm/boot/dts/exynos4210.dtsi                  |    6 +
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |    7 ++
 arch/arm/boot/dts/exynos5250.dtsi                  |    6 +
 arch/arm/mach-exynos/Kconfig                       |    2 +
 arch/arm/mach-exynos/clock-exynos5.c               |    2 +-
 arch/arm/mach-exynos/mach-exynos4-dt.c             |    9 ++
 arch/arm/mach-exynos/mach-exynos5-dt.c             |    9 ++
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |  104 +++++++++++++++++---
 10 files changed, 162 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/s5p-mfc.txt

