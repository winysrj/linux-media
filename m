Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:45884 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab3CKTpI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 15:45:08 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC PATCH 0/8] A V4L2 driver for Exynos4x12 Imaging Subsystem
Date: Mon, 11 Mar 2013 20:44:44 +0100
Message-id: <1363031092-29950-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series is an initial version of a driver for the camera ISP
subsystem (FIMC-IS) embedded in Samsung Exynos4x12 SoCs.

The FIMC-IS subsystem is build around a ARM Cortex-A5 CPU that controls
its dedicated peripherals, like I2C, SPI, UART, PWM, ADC,...  and the
ISP chain. There are 3 hardware image processing blocks: ISP, DRC
(dynamic range compression) and FD (face detection) that are normally
controlled by the Cortex-A5 firmware.

The driver currently exposes two additional sub-device to user space:
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

But it all is not immediately needed to make use of this really
great ISP!

A full git tree with all dependencies can be found at:
git://linuxtv.org/snawrocki/samsung.git
http://git.linuxtv.org/snawrocki/samsung.git/exynos4-fimc-is

Sylwester Nawrocki (8):
  s5p-fimc: Add Exynos4x12 FIMC-IS driver
  s5p-fimc: Add FIMC-IS ISP I2C bus driver
  s5p-fimc: Add FIMC-IS parameter region definitions
  s5p-fimc: Add common FIMC-IS image sensor driver
  s5p-fimc: Add ISP video capture driver stubs
  fimc-is: Add Exynos4x12 FIMC-IS device tree bindings documentation
  s5p-fimc: Add fimc-is subdevs registration
  s5p-fimc: Create media links for the FIMC-IS entities

 .../devicetree/bindings/media/exynos4-fimc-is.txt  |   41 +
 drivers/media/platform/s5p-fimc/Kconfig            |   13 +
 drivers/media/platform/s5p-fimc/Makefile           |    4 +
 drivers/media/platform/s5p-fimc/fimc-is-command.h  |  147 +++
 drivers/media/platform/s5p-fimc/fimc-is-errno.c    |  272 ++++++
 drivers/media/platform/s5p-fimc/fimc-is-errno.h    |  248 +++++
 drivers/media/platform/s5p-fimc/fimc-is-i2c.c      |   81 ++
 drivers/media/platform/s5p-fimc/fimc-is-i2c.h      |   15 +
 drivers/media/platform/s5p-fimc/fimc-is-param.c    |  971 +++++++++++++++++++
 drivers/media/platform/s5p-fimc/fimc-is-param.h    | 1018 ++++++++++++++++++++
 drivers/media/platform/s5p-fimc/fimc-is-regs.c     |  242 +++++
 drivers/media/platform/s5p-fimc/fimc-is-regs.h     |  164 ++++
 drivers/media/platform/s5p-fimc/fimc-is-sensor.c   |  308 ++++++
 drivers/media/platform/s5p-fimc/fimc-is-sensor.h   |   80 ++
 drivers/media/platform/s5p-fimc/fimc-is.c          |  970 +++++++++++++++++++
 drivers/media/platform/s5p-fimc/fimc-is.h          |  344 +++++++
 drivers/media/platform/s5p-fimc/fimc-isp-video.c   |  414 ++++++++
 drivers/media/platform/s5p-fimc/fimc-isp-video.h   |   50 +
 drivers/media/platform/s5p-fimc/fimc-isp.c         |  791 +++++++++++++++
 drivers/media/platform/s5p-fimc/fimc-isp.h         |  205 ++++
 drivers/media/platform/s5p-fimc/fimc-mdevice.c     |  129 ++-
 drivers/media/platform/s5p-fimc/fimc-mdevice.h     |   15 +
 22 files changed, 6502 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/exynos4-fimc-is.txt
 create mode 100644 drivers/media/platform/s5p-fimc/fimc-is-command.h
 create mode 100644 drivers/media/platform/s5p-fimc/fimc-is-errno.c
 create mode 100644 drivers/media/platform/s5p-fimc/fimc-is-errno.h
 create mode 100644 drivers/media/platform/s5p-fimc/fimc-is-i2c.c
 create mode 100644 drivers/media/platform/s5p-fimc/fimc-is-i2c.h
 create mode 100644 drivers/media/platform/s5p-fimc/fimc-is-param.c
 create mode 100644 drivers/media/platform/s5p-fimc/fimc-is-param.h
 create mode 100644 drivers/media/platform/s5p-fimc/fimc-is-regs.c
 create mode 100644 drivers/media/platform/s5p-fimc/fimc-is-regs.h
 create mode 100644 drivers/media/platform/s5p-fimc/fimc-is-sensor.c
 create mode 100644 drivers/media/platform/s5p-fimc/fimc-is-sensor.h
 create mode 100644 drivers/media/platform/s5p-fimc/fimc-is.c
 create mode 100644 drivers/media/platform/s5p-fimc/fimc-is.h
 create mode 100644 drivers/media/platform/s5p-fimc/fimc-isp-video.c
 create mode 100644 drivers/media/platform/s5p-fimc/fimc-isp-video.h
 create mode 100644 drivers/media/platform/s5p-fimc/fimc-isp.c
 create mode 100644 drivers/media/platform/s5p-fimc/fimc-isp.h

--
1.7.9.5

