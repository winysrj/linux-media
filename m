Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:64254 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab3CZSOk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 14:14:40 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 0/7] V4L2 driver for Exynos4x12 Imaging Subsystem
Date: Tue, 26 Mar 2013 19:14:16 +0100
Message-id: <1364321663-21010-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This iteration includes couple bug fixes and minor cleanup comparing
to the original version (original cover letter can be found below).
A patch adding ISP capture node has been removed as I'll need more
time to enable this feature and I'd like to possibly have this series
included in 3.10.
                       -------

This patch series is an initial version of a driver for the camera ISP
subsystem (FIMC-IS) found in Samsung Exynos4x12 SoCs.

The FIMC-IS subsystem is build around a ARM Cortex-A5 CPU that controls
its dedicated peripherals, like I2C, SPI, UART, PWM, ADC,...  and the
ISP chain. There are 3 hardware image processing blocks: ISP, DRC
(dynamic range compression) and FD (face detection) that are normally
controlled by the Cortex-A5 firmware.

The driver currently exposes two additional sub-devices to user space:
the image sensor and FIMC-IS-ISP sub-device. Another one might be
added in future for the FD features.

The FIMC-IS has various data inputs, it can capture data from memory
or from other SoC IP blocks (FIMC-LITE). It is currently plugged
between FIMC-LITE and FIMC IP blocks, so there is a media pipeline
like:

sensor -> MIPI-CSIS -> FIMC-LITE -> FIMC-IS-ISP -> FIMC -> memory

A raw Bayer image data can be captured from the ISP block which has
it's own DMA engines. Support for this is not really included in
this series though, only a video capture node driver stubs are added.

This is a bit complicated code, nevertheless I would really appreciate
any review comments you might have.

And this is just a basic set of futures this patch series addresses.
Others include input/output DMA support for the DRC and FD blocks,
support for more ISP controls, etc.


Full git tree with all dependencies can be found at:
http://git.linuxtv.org/snawrocki/samsung.git/exynos4-fimc-is-v2

Sylwester Nawrocki (7):
  exynos4-is: Add Exynos4x12 FIMC-IS driver
  exynos4-is: Add FIMC-IS ISP I2C bus driver
  exynos4-is: Add FIMC-IS parameter region definitions
  exynos4-is: Add common FIMC-IS image sensor driver
  exynos4-is: Add Exynos4x12 FIMC-IS device tree bindings documentation
  s5p-fimc: Add fimc-is subdevs registration
  s5p-fimc: Create media links for the FIMC-IS entities

 .../devicetree/bindings/media/exynos4-fimc-is.txt  |   45 +
 drivers/media/platform/exynos4-is/Kconfig          |   13 +
 drivers/media/platform/exynos4-is/Makefile         |    3 +
 .../media/platform/exynos4-is/fimc-is-command.h    |  147 +++
 drivers/media/platform/exynos4-is/fimc-is-errno.c  |  272 ++++++
 drivers/media/platform/exynos4-is/fimc-is-errno.h  |  248 +++++
 drivers/media/platform/exynos4-is/fimc-is-i2c.c    |   81 ++
 drivers/media/platform/exynos4-is/fimc-is-i2c.h    |   15 +
 drivers/media/platform/exynos4-is/fimc-is-param.c  |  971 +++++++++++++++++++
 drivers/media/platform/exynos4-is/fimc-is-param.h  | 1022 ++++++++++++++++++++
 drivers/media/platform/exynos4-is/fimc-is-regs.c   |  242 +++++
 drivers/media/platform/exynos4-is/fimc-is-regs.h   |  164 ++++
 drivers/media/platform/exynos4-is/fimc-is-sensor.c |  307 ++++++
 drivers/media/platform/exynos4-is/fimc-is-sensor.h |   80 ++
 drivers/media/platform/exynos4-is/fimc-is.c        |  962 ++++++++++++++++++
 drivers/media/platform/exynos4-is/fimc-is.h        |  340 +++++++
 drivers/media/platform/exynos4-is/fimc-isp.c       |  707 ++++++++++++++
 drivers/media/platform/exynos4-is/fimc-isp.h       |  181 ++++
 drivers/media/platform/exynos4-is/media-dev.c      |  120 ++-
 drivers/media/platform/exynos4-is/media-dev.h      |   13 +
 20 files changed, 5911 insertions(+), 22 deletions(-)
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
1.7.9.5

