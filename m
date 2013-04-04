Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44700 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763833Ab3DDRPV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Apr 2013 13:15:21 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MKQ00FE3QL7KSB0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Apr 2013 18:15:19 +0100 (BST)
Message-id: <515DB526.1060405@samsung.com>
Date: Thu, 04 Apr 2013 19:15:18 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Cc: Younghwan Joo <yhwan.joo@samsung.com>,
	'Arnd Bergmann' <arnd@arndb.de>
Subject: [GIT PULL FOR 3.10] Exynos4 Imaging Subsystem drivers update
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

This series includes couple fixes for the exynos4-is drivers (previously
s5p-fimc), some cleanups required for ARCH_MULTIPLATFORM support, a fix for
the V4L2 OF parsing lib. The most significant addition is the V4L2 driver
for Exynos4x12 SoCs FIMC-IS - a subsystem consisting of camera ISP, DRC
and face detection IPs controlled by a dedicated ARM Cortex-A5 MCU). It
integrates with the other IP drivers, which I would be commonly referring
to as exynos4-is. Only basic FIMC-IS features are currently supported.
Nevertheless this code is (hopefully) in shape where we could finally move
it upstream and continue any further development in-tree.

The following changes since commit f9f11dfe4831adb1531e1face9dcd9fc57665d2e:

  Merge tag 'v3.9-rc5' into patchwork (2013-04-01 09:54:14 -0300)

are available in the git repository at:


  git://linuxtv.org/snawrocki/samsung.git for_v3.10

for you to fetch changes up to 7de8e890e6b199b2cbb7c9816d6ccc96a2952dbf:

  exynos4-is: Ensure proper media pipeline state on device close (2013-04-03
20:12:55 +0200)

----------------------------------------------------------------
Arnd Bergmann (1):
      exynos: remove unnecessary header inclusions

Sylwester Nawrocki (15):
      exynos4-is: Remove dependency on SYSCON for non-dt platforms
      exynos4-is: Correct clock properties description at the DT binding
documentation
      V4L: Remove incorrect EXPORT_SYMBOL() usage at v4l2-of.c
      exynos4-is: Add Exynos4x12 FIMC-IS driver
      exynos4-is: Add FIMC-IS ISP I2C bus driver
      exynos4-is: Add FIMC-IS parameter region definitions
      exynos4-is: Add common FIMC-IS image sensor driver
      exynos4-is: Add Exynos4x12 FIMC-IS device tree binding documentation
      exynos4-is: Add fimc-is subdevs registration
      exynos4-is: Create media links for the FIMC-IS entities
      exynos4-is: Remove static driver data for Exynos4210 FIMC variants
      exynos4-is: Use common driver data for all FIMC-LITE IP instances
      exynos4-is: Allow colorspace conversion at FIMC-LITE
      exynos4-is: Correct input DMA YUV order configuration
      exynos4-is: Ensure proper media pipeline state on device close

 .../devicetree/bindings/media/exynos4-fimc-is.txt  |   49 +
 .../devicetree/bindings/media/samsung-fimc.txt     |   10 +-
 drivers/media/platform/exynos-gsc/gsc-regs.c       |    1 -
 drivers/media/platform/exynos4-is/Kconfig          |   14 +-
 drivers/media/platform/exynos4-is/Makefile         |    3 +
 drivers/media/platform/exynos4-is/fimc-capture.c   |   18 +-
 drivers/media/platform/exynos4-is/fimc-core.c      |   54 +-
 drivers/media/platform/exynos4-is/fimc-core.h      |   11 +
 .../media/platform/exynos4-is/fimc-is-command.h    |  137 +++
 drivers/media/platform/exynos4-is/fimc-is-errno.c  |  272 ++++++
 drivers/media/platform/exynos4-is/fimc-is-errno.h  |  248 +++++
 drivers/media/platform/exynos4-is/fimc-is-i2c.c    |  129 +++
 drivers/media/platform/exynos4-is/fimc-is-i2c.h    |   15 +
 drivers/media/platform/exynos4-is/fimc-is-param.c  |  955 ++++++++++++++++++
 drivers/media/platform/exynos4-is/fimc-is-param.h  | 1022 ++++++++++++++++++++
 drivers/media/platform/exynos4-is/fimc-is-regs.c   |  242 +++++
 drivers/media/platform/exynos4-is/fimc-is-regs.h   |  164 ++++
 drivers/media/platform/exynos4-is/fimc-is-sensor.c |  322 ++++++
 drivers/media/platform/exynos4-is/fimc-is-sensor.h |   83 ++
 drivers/media/platform/exynos4-is/fimc-is.c        | 1010 +++++++++++++++++++
 drivers/media/platform/exynos4-is/fimc-is.h        |  345 +++++++
 drivers/media/platform/exynos4-is/fimc-isp.c       |  702 ++++++++++++++
 drivers/media/platform/exynos4-is/fimc-isp.h       |  181 ++++
 drivers/media/platform/exynos4-is/fimc-lite-reg.c  |    4 +-
 drivers/media/platform/exynos4-is/fimc-lite-reg.h  |    8 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |  127 ++-
 drivers/media/platform/exynos4-is/fimc-lite.h      |   15 +-
 drivers/media/platform/exynos4-is/fimc-reg.c       |    6 +-
 drivers/media/platform/exynos4-is/fimc-reg.h       |   16 +-
 drivers/media/platform/exynos4-is/media-dev.c      |  116 ++-
 drivers/media/platform/exynos4-is/media-dev.h      |   13 +
 drivers/media/platform/s5p-tv/sii9234_drv.c        |    3 -
 drivers/media/v4l2-core/v4l2-of.c                  |    3 +-
 include/media/s5p_fimc.h                           |    2 +
 include/media/v4l2-of.h                            |    6 +-
 35 files changed, 6145 insertions(+), 161 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/exynos4-fimc-is.txt
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-command.h
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-errno.c
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-errno.h
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-i2c.c
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-i2c.h
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-param.c
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-param.h
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-regs.c
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-regs.h
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-sensor.c
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-sensor.h
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is.c
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is.h
 create mode 100644 drivers/media/platform/exynos4-is/fimc-isp.c
 create mode 100644 drivers/media/platform/exynos4-is/fimc-isp.h

--

Thanks,
Sylwester
