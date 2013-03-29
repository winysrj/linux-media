Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:13363 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab3C2SMz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Mar 2013 14:12:55 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MKF00M67P9H6290@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 29 Mar 2013 18:12:53 +0000 (GMT)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MKF0044UP9H0F00@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 29 Mar 2013 18:12:53 +0000 (GMT)
Message-id: <5155D9A4.7050504@samsung.com>
Date: Fri, 29 Mar 2013 19:12:52 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.10] s5p-fimc DT support and various updates
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This series includes s5p-fimc driver conversion to use the vb2 helpers,
the device tree support and prerequisites for the Exynos4x12 ISP driver.

Please note it depends on the patch adding V4L2 DT parsing library [1].
I have a few more patches that depend on fixes submitted for 3.9 and I
intend to send those next week to you.

[1] https://patchwork.linuxtv.org/patch/17708

Thanks,
Sylwester

The following changes since commit 27ab1e94d69d9139d530a661832c7b3a047a69e0:

  [media] Add a V4L2 OF parser (2013-03-29 17:34:55 +0100)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git v4l_dt_exynos

for you to fetch changes up to 8d9a7d145c7166c9d778de6a9680aad9f5bc7128:

  s5p-fimc: Change the driver directory name to exynos4-is (2013-03-29 18:22:23 +0100)

----------------------------------------------------------------
Andrzej Hajda (1):
      s5p-fimc: Add error checks for pipeline stream on callbacks

Sylwester Nawrocki (18):
      s5p-fimc: Use video entity for marking media pipeline as streaming
      s5p-fimc: Use vb2 ioctl/fop helpers in FIMC capture driver
      s5p-fimc: Use vb2 ioctl helpers in fimc-lite
      s5p-csis: Add device tree support
      s5p-fimc: Add device tree support for FIMC device driver
      s5p-fimc: Add device tree support for FIMC-LITE device driver
      s5p-fimc: Add device tree support for the media device driver
      s5p-fimc: Add device tree based sensors registration
      s5p-fimc: Use pinctrl API for camera ports configuration
      V4L: Add MATRIX option to V4L2_CID_EXPOSURE_METERING control
      s5p-fimc: Update graph traversal for entities with multiple source pads
      s5p-fimc: Add support for PIXELASYNCMx clocks
      s5p-fimc: Add support for ISP Writeback data input bus type
      s5p-fimc: Ensure CAMCLK clock can be enabled by FIMC-LITE devices
      s5p-fimc: Ensure proper s_stream() call order in the ISP datapaths
      s5p-fimc: Ensure proper s_power() call order in the ISP datapaths
      s5p-fimc: Remove dependency on fimc-core.h in fimc-lite driver
      s5p-fimc: Change the driver directory name to exynos4-is

 Documentation/DocBook/media/v4l/controls.xml       |    7 +
 .../devicetree/bindings/media/exynos-fimc-lite.txt |   14 +
 .../devicetree/bindings/media/samsung-fimc.txt     |  199 +++++++
 .../bindings/media/samsung-mipi-csis.txt           |   81 +++
 drivers/media/platform/Kconfig                     |    2 +-
 drivers/media/platform/Makefile                    |    2 +-
 .../platform/{s5p-fimc => exynos4-is}/Kconfig      |    9 +-
 .../platform/{s5p-fimc => exynos4-is}/Makefile     |    2 +-
 .../{s5p-fimc => exynos4-is}/fimc-capture.c        |  378 +++++++------
 .../platform/{s5p-fimc => exynos4-is}/fimc-core.c  |  251 +++++----
 .../platform/{s5p-fimc => exynos4-is}/fimc-core.h  |   69 +--
 .../{s5p-fimc => exynos4-is}/fimc-lite-reg.c       |    0
 .../{s5p-fimc => exynos4-is}/fimc-lite-reg.h       |    0
 .../platform/{s5p-fimc => exynos4-is}/fimc-lite.c  |  243 ++++-----
 .../platform/{s5p-fimc => exynos4-is}/fimc-lite.h  |    3 +-
 .../platform/{s5p-fimc => exynos4-is}/fimc-m2m.c   |   14 +-
 .../platform/{s5p-fimc => exynos4-is}/fimc-reg.c   |   81 ++-
 .../platform/{s5p-fimc => exynos4-is}/fimc-reg.h   |   11 +
 .../fimc-mdevice.c => exynos4-is/media-dev.c}      |  554 +++++++++++++++++---
 .../fimc-mdevice.h => exynos4-is/media-dev.h}      |   28 +
 .../platform/{s5p-fimc => exynos4-is}/mipi-csis.c  |  155 ++++--
 .../platform/{s5p-fimc => exynos4-is}/mipi-csis.h  |    1 +
 drivers/media/v4l2-core/v4l2-ctrls.c               |    1 +
 include/media/s5p_fimc.h                           |   51 ++
 include/uapi/linux/v4l2-controls.h                 |    1 +
 25 files changed, 1511 insertions(+), 646 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/exynos-fimc-lite.txt
 create mode 100644 Documentation/devicetree/bindings/media/samsung-fimc.txt
 create mode 100644 Documentation/devicetree/bindings/media/samsung-mipi-csis.txt
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/Kconfig (86%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/Makefile (94%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-capture.c (88%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-core.c (87%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-core.h (92%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-lite-reg.c (100%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-lite-reg.h (100%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-lite.c (90%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-lite.h (99%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-m2m.c (98%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-reg.c (92%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-reg.h (96%)
 rename drivers/media/platform/{s5p-fimc/fimc-mdevice.c => exynos4-is/media-dev.c} (66%)
 rename drivers/media/platform/{s5p-fimc/fimc-mdevice.h => exynos4-is/media-dev.h} (80%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/mipi-csis.c (86%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/mipi-csis.h (93%)
