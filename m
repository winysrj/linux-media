Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:43933 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab3H2JZd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Aug 2013 05:25:33 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: mturquette@linaro.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, arun.kk@samsung.com,
	hverkuil@xs4all.nl, sakari.ailus@iki.fi, a.hajda@samsung.com,
	kyungmin.park@samsung.com, t.figa@samsung.com,
	linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com,
	swarren@wwwdotorg.org, pawel.moll@arm.com, rob.herring@calxeda.com,
	galak@codeaurora.org, devicetree@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RESEND PATCH v2 0/7] Add device tree support for Exynos4412 Trats2
 cameras
Date: Thu, 29 Aug 2013 11:24:31 +0200
Message-id: <1377768278-15391-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[Sigh, I've forgotten to Cc some mailing lists when submitting this
 previously, resending with device tree and samsung-soc ML added]

This series is intended to add device tree support for both cameras
on the Exynos4412 SoC Trats 2 board. It converts related drivers to use
the v4l2-async API and expose the sensor's master clock supplied by the
camera host interface through the common clock API.

This changeset is an updated version of my patch series [1] separating
the sensor subdev driver from the exynos4-fimc-is module and adding
asynchronous sensor registration support. There is also included next
iteration of the patch adding DT bits to the rear facing S5C73M3 camera
module driver [2].

The S5K6A3 is a raw image sensor of the front facing camera connected
to the SoC local ISP (FIMC-IS).

This series has run-time dependency on the patches adding clk_unregister()
implementation [3].

Any feedback, especially on the "s5k6a3: Add DT binding documentation"
patch, where I've described some issue with the common video-interfaces
binding is welcome.

[1] http://www.spinics.net/lists/linux-media/msg66073.html
[2] https://linuxtv.org/patch/19386/
[3] https://lkml.org/lkml/2013/8/24/63

Thanks,
Sylwester

Andrzej Hajda (1):
  V4L: s5c73m3: Add device tree support

Sylwester Nawrocki (6):
  V4L: s5k6a3: Add DT binding documentation
  V4L: Add driver for s5k6a3 image sensor
  V4L: s5k6a3: Add support for asynchronous subdev registration
  exynos4-is: Add clock provider for the external clocks
  exynos4-is: Use external s5k6a3 sensor driver
  exynos4-is: Add support for asynchronous sensor subddevs registration

 .../devicetree/bindings/media/samsung-fimc.txt     |   21 +-
 .../devicetree/bindings/media/samsung-s5c73m3.txt  |   95 ++++++
 .../devicetree/bindings/media/samsung-s5k6a3.txt   |   31 ++
 drivers/media/i2c/Kconfig                          |    8 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |  206 +++++++++---
 drivers/media/i2c/s5c73m3/s5c73m3-spi.c            |    6 +
 drivers/media/i2c/s5c73m3/s5c73m3.h                |    4 +
 drivers/media/i2c/s5k6a3.c                         |  340 ++++++++++++++++++++
 drivers/media/platform/exynos4-is/fimc-is-regs.c   |    2 +-
 drivers/media/platform/exynos4-is/fimc-is-sensor.c |  285 +---------------
 drivers/media/platform/exynos4-is/fimc-is-sensor.h |   49 +--
 drivers/media/platform/exynos4-is/fimc-is.c        |   97 +++---
 drivers/media/platform/exynos4-is/fimc-is.h        |    4 +-
 drivers/media/platform/exynos4-is/media-dev.c      |  335 +++++++++++++------
 drivers/media/platform/exynos4-is/media-dev.h      |   31 +-
 16 files changed, 984 insertions(+), 531 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/samsung-s5c73m3.txt
 create mode 100644 Documentation/devicetree/bindings/media/samsung-s5k6a3.txt
 create mode 100644 drivers/media/i2c/s5k6a3.c

--
1.7.9.5

