Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:23304 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbaEHRe1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 May 2014 13:34:27 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: robh+dt@kernel.org, mark.rutland@arm.com,
	devicetree@vger.kernel.org, kyungmin.park@samsung.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH V2 0/4] Exynos4 SoC camera subsystem driver cleanups
Date: Thu, 08 May 2014 19:34:07 +0200
Message-id: <1399570448-29737-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series includes some bug fixes for the Exynos4/S5P SoC camera
interface drivers and removes (ab)use of "simple-bus" compatible string.

Comparing to previous version I've excluded patches dropping support
for non-dt platforms and added two further bug fixes.
of_platform_populate() is used instead of manually parsing the device
tree and creating devices and the cleanup function has been moved to
the core. This series depends on patch:
http://www.kernelhub.org/?msg=466319&p=2

Sylwester Nawrocki (4):
  exynos4-is: Free FIMC-IS CPU memory only when allocated
  exynos4-is: Move firmware request to subdev open()
  exynos4-is: Remove requirement for "simple-bus" compatible
  ARM: dts: exynos4: Remove simple-bus compatibles from the camera
    subsystem

 .../devicetree/bindings/media/samsung-fimc.txt     |    6 +--
 arch/arm/boot/dts/exynos4.dtsi                     |    2 +-
 arch/arm/boot/dts/exynos4x12.dtsi                  |    2 +-
 drivers/media/platform/exynos4-is/fimc-is.c        |   50 ++++++++++----------
 drivers/media/platform/exynos4-is/fimc-is.h        |    2 +-
 drivers/media/platform/exynos4-is/fimc-isp.c       |   10 +++-
 drivers/media/platform/exynos4-is/media-dev.c      |   21 ++++++--
 7 files changed, 58 insertions(+), 35 deletions(-)

--
1.7.9.5

