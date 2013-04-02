Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:21573 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761527Ab3DBQD5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Apr 2013 12:03:57 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: yhwan.joo@samsung.com, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v4 0/7] V4L2 driver for Exynos4x12 Imaging Subsystem
Date: Tue, 02 Apr 2013 18:03:32 +0200
Message-id: <1364918619-9118-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This iteration includes mostly headers inclusion and comments cleanup,
minor DT binding documentation update and added missing cleanup steps
at the I2C bus driver. Detailed changes are listed at individual
patches.

Below is a full cover letter of v3. If there is no more comments
I would send a pull request this week, so further development can
be continued already in tree.

                        ---------
This patch series includes mostly changes in the clocks handling, fix of
coding style issues found with checkpatch.pl and an improvement of the
DT binding documentation.

There is an issue that the ISP clocks (MCU_ISP block clocks) are in the
ISP power domain and the clock registers should not be touched when this
power domain is inactive. At least this applies to part of the CMU_ISP
clocks, as our investigation shows. That is mainly the reason why all ISP
clocks have CLK_IGNORE_UNUSED flag set in patch [1]. That's most likely
not the right solution to this problem. But I'm not sure what could be
other options, probably it would help to make the CMU_ISP clocks provider
aware of the ISP domain. But I can't tell state of which clock registers
is persistent over the ISP power domain on/off cycles.
Without the CLK_IGNORE_UNUSED flags set the system hangs when the clock
core disables unused clocks.

Changes since v2:
 - Improved clocks handling, all required clocks should now be explicitly
   enabled/disabled by the driver as needed. In addition a frequency of
   selected clocks is now being set to ensure the FIMC-IS ISP chain an
   the MCU core clocks frequency is valid, before starting the ISP
   firmware.
 - Added ISP I2C bus clock handling in the dummy I2C bus controller driver.
 - Clock properties added at the DT binding description.

This patch series with all dependencies can be found at:
git://linuxtv.org/snawrocki/samsung.git exynos4-fimc-is-v3

[1] http://www.spinics.net/lists/arm-kernel/msg233534.html

Below is a cover letter of the initial version of this patch series.

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
between FIMC-LITE and FIMC (post-processor)  IP blocks, so there is
a processing chain like:

sensor -> MIPI-CSIS -> FIMC-LITE -> FIMC-IS-ISP -> FIMC -> memory

A raw Bayer image data can be captured from the ISP block which has
it's own DMA engines. Support for this is not really included in
this series, only a video capture node driver stubs are added.

This is a bit complicated code, nevertheless I would really appreciate
any review comments you might have.

And this is just a basic set of futures this patch series addresses.
Others include input/output DMA support for the DRC and FD blocks,
support for more ISP controls, etc.

Full git tree with all dependencies can be found at:
http://git.linuxtv.org/snawrocki/samsung.git/exynos4-fimc-is-v2
                      ----------

Sylwester Nawrocki (7):
  exynos4-is: Add Exynos4x12 FIMC-IS driver
  exynos4-is: Add FIMC-IS ISP I2C bus driver
  exynos4-is: Add FIMC-IS parameter region definitions
  exynos4-is: Add common FIMC-IS image sensor driver
  exynos4-is: Add Exynos4x12 FIMC-IS device tree binding documentation
  exynos4-is: Add fimc-is subdevs registration
  exynos4-is: Create media links for the FIMC-IS entities

 .../devicetree/bindings/media/exynos4-fimc-is.txt  |   49 +
 drivers/media/platform/exynos4-is/Kconfig          |   11 +
 drivers/media/platform/exynos4-is/Makefile         |    3 +
 .../media/platform/exynos4-is/fimc-is-command.h    |  147 +++
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
 drivers/media/platform/exynos4-is/fimc-is.c        | 1009 +++++++++++++++++++
 drivers/media/platform/exynos4-is/fimc-is.h        |  345 +++++++
 drivers/media/platform/exynos4-is/fimc-isp.c       |  702 ++++++++++++++
 drivers/media/platform/exynos4-is/fimc-isp.h       |  181 ++++
 drivers/media/platform/exynos4-is/media-dev.c      |  116 ++-
 drivers/media/platform/exynos4-is/media-dev.h      |   13 +
 20 files changed, 6006 insertions(+), 22 deletions(-)
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

