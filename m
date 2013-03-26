Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:50784 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965689Ab3CZQkN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 12:40:13 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v5 0/6] Device tree support for Exynos SoC camera subsystem
Date: Tue, 26 Mar 2013 17:39:52 +0100
Message-id: <1364315998-19372-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes in this iteration include mostly adaptation to changes at the
V4L2 OF parser lib and an addition of clocks/clock-names properties
in the bindings of the IP blocks.

If there is no more comments I intend to send a pull request including
the DT bindings documentation, the V4L2 OF parser and these patches at
end of this week.

This patch series with all dependencies can be found at:
http://git.linuxtv.org/snawrocki/samsung.git/devicetree-fimc-v5

Sylwester Nawrocki (6):
  s5p-csis: Add device tree support
  s5p-fimc: Add device tree support for FIMC device driver
  s5p-fimc: Add device tree support for FIMC-LITE device driver
  s5p-fimc: Add device tree support for the media device driver
  s5p-fimc: Add device tree based sensors registration
  s5p-fimc: Use pinctrl API for camera ports configuration

 .../devicetree/bindings/media/exynos-fimc-lite.txt |   14 +
 .../devicetree/bindings/media/samsung-fimc.txt     |  200 +++++++++++
 .../bindings/media/samsung-mipi-csis.txt           |   81 +++++
 drivers/media/platform/s5p-fimc/fimc-capture.c     |    6 +-
 drivers/media/platform/s5p-fimc/fimc-core.c        |  239 +++++++------
 drivers/media/platform/s5p-fimc/fimc-core.h        |   21 +-
 drivers/media/platform/s5p-fimc/fimc-lite.c        |   63 +++-
 drivers/media/platform/s5p-fimc/fimc-m2m.c         |    2 +-
 drivers/media/platform/s5p-fimc/fimc-mdevice.c     |  370 +++++++++++++++++---
 drivers/media/platform/s5p-fimc/fimc-mdevice.h     |   16 +
 drivers/media/platform/s5p-fimc/fimc-reg.c         |    6 +-
 drivers/media/platform/s5p-fimc/mipi-csis.c        |  155 ++++++--
 drivers/media/platform/s5p-fimc/mipi-csis.h        |    1 +
 include/media/s5p_fimc.h                           |   17 +
 14 files changed, 982 insertions(+), 209 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/exynos-fimc-lite.txt
 create mode 100644 Documentation/devicetree/bindings/media/samsung-fimc.txt
 create mode 100644 Documentation/devicetree/bindings/media/samsung-mipi-csis.txt

--
1.7.9.5

