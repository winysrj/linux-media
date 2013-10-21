Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24552 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab3JUOEQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Oct 2013 10:04:16 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MV000JH3V0APFC0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Oct 2013 15:04:14 +0100 (BST)
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MV000ECNV32TC40@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Oct 2013 15:04:14 +0100 (BST)
Message-id: <52653459.4000609@samsung.com>
Date: Mon, 21 Oct 2013 16:04:09 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.13 v2] s5p/exynos driver updates
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This is an updated version with one more patch added.

Patches included here are mostly s5p/exynos driver cleanups and fixes;
an addition of the v4l2-m2m ioctl helper functions and device tree support
for the exynos4 camera subsystem driver and s5k6a3, s5c73m3 sensors.

The following changes since commit 8ca5d2d8e58df7235b77ed435e63c484e123fede:

  [media] uvcvideo: Fix data type for pan/tilt control (2013-10-17 06:55:29 -0300)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for-v3.13-1

for you to fetch changes up to aa9a5054cc14b947094eeda4787433fc646239e3:

  exynos4-is: Simplify fimc-is hardware polling helpers (2013-10-21 15:56:42 +0200)

----------------------------------------------------------------
Mateusz Krawczuk (3):
      s5p-tv: sdo: Restore vpll clock rate after streamoff
      s5p-tv: sdo: Prepare for common clock framework
      s5p-tv: mixer: Prepare for common clock framework

Roel Kluin (1):
      exynos4-is: fimc-lite: Index out of bounds if no pixelcode found

Seung-Woo Kim (1):
      s5p-jpeg: fix encoder and decoder video dev names

Sylwester Nawrocki (14):
      V4L: Add mem2mem ioctl and file operation helpers
      mem2mem_testdev: Use mem-to-mem ioctl and vb2 helpers
      exynos4-is: Use mem-to-mem ioctl helpers
      s5p-jpeg: Use mem-to-mem ioctl helpers
      s5p-g2d: Use mem-to-mem ioctl helpers
      s5p-jpeg: Add initial device tree support for S5PV210/Exynos4210 SoCs
      V4L: s5k6a3: Add DT binding documentation
      V4L: Add driver for s5k6a3 image sensor
      V4L: s5c73m3: Add device tree support
      exynos4-is: Add clock provider for the external clocks
      exynos4-is: Use external s5k6a3 sensor driver
      exynos4-is: Add support for asynchronous subdevices registration
      exynos4-is: Add the FIMC-IS ISP capture DMA driver
      exynos4-is: Simplify fimc-is hardware polling helpers

 .../bindings/media/exynos-jpeg-codec.txt           |   11 +
 .../devicetree/bindings/media/samsung-fimc.txt     |   19 +-
 .../devicetree/bindings/media/samsung-s5c73m3.txt  |   95 +++
 .../devicetree/bindings/media/samsung-s5k6a3.txt   |   32 +
 drivers/media/i2c/Kconfig                          |    8 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |  208 ++++--
 drivers/media/i2c/s5c73m3/s5c73m3-spi.c            |    6 +
 drivers/media/i2c/s5c73m3/s5c73m3.h                |    4 +
 drivers/media/i2c/s5k6a3.c                         |  391 ++++++++++++
 drivers/media/platform/exynos4-is/Kconfig          |    9 +
 drivers/media/platform/exynos4-is/Makefile         |    4 +
 drivers/media/platform/exynos4-is/fimc-core.h      |    2 -
 drivers/media/platform/exynos4-is/fimc-is-param.c  |    2 +-
 drivers/media/platform/exynos4-is/fimc-is-param.h  |    5 +
 drivers/media/platform/exynos4-is/fimc-is-regs.c   |   52 +-
 drivers/media/platform/exynos4-is/fimc-is-regs.h   |    2 +-
 drivers/media/platform/exynos4-is/fimc-is-sensor.c |  285 +--------
 drivers/media/platform/exynos4-is/fimc-is-sensor.h |   49 +-
 drivers/media/platform/exynos4-is/fimc-is.c        |   98 ++-
 drivers/media/platform/exynos4-is/fimc-is.h        |    9 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |  660 ++++++++++++++++++++
 drivers/media/platform/exynos4-is/fimc-isp-video.h |   44 ++
 drivers/media/platform/exynos4-is/fimc-isp.c       |   29 +-
 drivers/media/platform/exynos4-is/fimc-isp.h       |   27 +-
 drivers/media/platform/exynos4-is/fimc-lite-reg.c  |    4 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |  148 +----
 drivers/media/platform/exynos4-is/media-dev.c      |  350 ++++++++---
 drivers/media/platform/exynos4-is/media-dev.h      |   31 +-
 drivers/media/platform/mem2mem_testdev.c           |  152 +----
 drivers/media/platform/s5p-g2d/g2d.c               |  124 +---
 drivers/media/platform/s5p-g2d/g2d.h               |    1 -
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |  154 ++---
 drivers/media/platform/s5p-jpeg/jpeg-core.h        |    2 -
 drivers/media/platform/s5p-tv/mixer_drv.c          |   34 +-
 drivers/media/platform/s5p-tv/sdo_drv.c            |   39 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |  126 ++++
 include/media/v4l2-fh.h                            |    4 +
 include/media/v4l2-mem2mem.h                       |   24 +
 39 files changed, 2190 insertions(+), 1055 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
 create mode 100644 Documentation/devicetree/bindings/media/samsung-s5c73m3.txt
 create mode 100644 Documentation/devicetree/bindings/media/samsung-s5k6a3.txt
 create mode 100644 drivers/media/i2c/s5k6a3.c
 create mode 100644 drivers/media/platform/exynos4-is/fimc-isp-video.c
 create mode 100644 drivers/media/platform/exynos4-is/fimc-isp-video.h

Thanks,
Sylwester
