Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38695 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbaCKSnx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 14:43:53 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N2A00GK4C13UK80@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 11 Mar 2014 18:43:51 +0000 (GMT)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0N2A000RYC12SK70@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 11 Mar 2014 18:43:50 +0000 (GMT)
Message-id: <531F5962.3060009@samsung.com>
Date: Tue, 11 Mar 2014 19:43:46 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] Samsung media drivers update
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 0d49e7761173520ff02cec6f11d581f8ebca764d:

  drx-j: Fix post-BER calculus on QAM modulation (2014-03-11 07:43:54 -0300)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for-v3.15

for you to fetch changes up to 431c29861868255e1d84cd34cf48e48547831ff9:

  s5p-fimc: Remove reference to outdated macro (2014-03-11 17:58:17 +0100)

This includes device tree support for Samsung S5C73M3 camera, separate subdev 
driver for S56K6A3 image sensor, related update of the Exynos4 camera subsystem
DT bindings and v4l2-asyc API support at the driver, a FIMC-IS ISP sub-IP
capture DMA driver and some minor s5p-* driver cleanups.

----------------------------------------------------------------
Jacek Anaszewski (1):
      s5p-jpeg: Fix broken indentation in jpeg-regs.h

Paul Bolle (1):
      s5p-fimc: Remove reference to outdated macro

Sylwester Nawrocki (9):
      Documentation: dt: Add binding documentation for S5K6A3 image sensor
      Documentation: dt: Add binding documentation for S5C73M3 camera
      Documentation: devicetree: Update Samsung FIMC DT binding
      V4L: Add driver for s5k6a3 image sensor
      V4L: s5c73m3: Add device tree support
      exynos4-is: Use external s5k6a3 sensor driver
      exynos4-is: Add clock provider for the SCLK_CAM clock outputs
      exynos4-is: Add support for asynchronous subdevices registration
      exynos4-is: Add the FIMC-IS ISP capture DMA driver

 .../devicetree/bindings/media/samsung-fimc.txt     |   44 +-
 .../devicetree/bindings/media/samsung-s5c73m3.txt  |   97 +++
 .../devicetree/bindings/media/samsung-s5k6a3.txt   |   33 +
 Documentation/video4linux/fimc.txt                 |    5 +-
 drivers/media/i2c/Kconfig                          |    8 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |  207 ++++--
 drivers/media/i2c/s5c73m3/s5c73m3-spi.c            |    6 +
 drivers/media/i2c/s5c73m3/s5c73m3.h                |    4 +
 drivers/media/i2c/s5k6a3.c                         |  389 ++++++++++++
 drivers/media/platform/exynos4-is/Kconfig          |    9 +
 drivers/media/platform/exynos4-is/Makefile         |    4 +
 drivers/media/platform/exynos4-is/fimc-is-param.c  |    2 +-
 drivers/media/platform/exynos4-is/fimc-is-param.h  |    5 +
 drivers/media/platform/exynos4-is/fimc-is-regs.c   |   16 +-
 drivers/media/platform/exynos4-is/fimc-is-regs.h   |    1 +
 drivers/media/platform/exynos4-is/fimc-is-sensor.c |  285 +--------
 drivers/media/platform/exynos4-is/fimc-is-sensor.h |   49 +-
 drivers/media/platform/exynos4-is/fimc-is.c        |   98 ++-
 drivers/media/platform/exynos4-is/fimc-is.h        |    9 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |  660 ++++++++++++++++++++
 drivers/media/platform/exynos4-is/fimc-isp-video.h |   44 ++
 drivers/media/platform/exynos4-is/fimc-isp.c       |   29 +-
 drivers/media/platform/exynos4-is/fimc-isp.h       |   27 +-
 drivers/media/platform/exynos4-is/media-dev.c      |  363 ++++++++---
 drivers/media/platform/exynos4-is/media-dev.h      |   32 +-
 drivers/media/platform/s5p-jpeg/jpeg-regs.h        |   24 +-
 27 files changed, 1886 insertions(+), 565 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/samsung-s5c73m3.txt
 create mode 100644 Documentation/devicetree/bindings/media/samsung-s5k6a3.txt
 create mode 100644 drivers/media/i2c/s5k6a3.c
 create mode 100644 drivers/media/platform/exynos4-is/fimc-isp-video.c
 create mode 100644 drivers/media/platform/exynos4-is/fimc-isp-video.h

--
Thanks,
Sylwester
