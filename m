Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:15270 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758563Ab3JQSH1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 14:07:27 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 0/6] Add device tree support for Exynos4 SoC camera subsystem
Date: Thu, 17 Oct 2013 20:06:45 +0200
Message-id: <1382033211-32329-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series is intended to add device tree support for both cameras
on the Exynos4412 SoC Trats 2 board. It converts related drivers to use
the v4l2-async API and expose the sensor's master clock, supplied by the
camera host interface, through the common clock API.

This changeset is an updated version of my patch series [1]. I didn't
receive any feedback until then and the changes in this iteration are
rather minor. I'm going to send a pull request including those patches
this week.

[1] http://www.spinics.net/lists/linux-media/msg67574.html

Thanks,
Sylwester

Sylwester Nawrocki (6):
  V4L: s5k6a3: Add DT binding documentation
  V4L: Add driver for s5k6a3 image sensor
  V4L: s5c73m3: Add device tree support
  exynos4-is: Add clock provider for the external clocks
  exynos4-is: Use external s5k6a3 sensor driver
  exynos4-is: Add support for asynchronous subdevices registration

 .../devicetree/bindings/media/samsung-fimc.txt     |   19 +-
 .../devicetree/bindings/media/samsung-s5c73m3.txt  |   95 +++++
 .../devicetree/bindings/media/samsung-s5k6a3.txt   |   32 ++
 drivers/media/i2c/Kconfig                          |    8 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |  208 ++++++++---
 drivers/media/i2c/s5c73m3/s5c73m3-spi.c            |    6 +
 drivers/media/i2c/s5c73m3/s5c73m3.h                |    4 +
 drivers/media/i2c/s5k6a3.c                         |  387 ++++++++++++++++++++
 drivers/media/platform/exynos4-is/fimc-is-regs.c   |    2 +-
 drivers/media/platform/exynos4-is/fimc-is-sensor.c |  285 +-------------
 drivers/media/platform/exynos4-is/fimc-is-sensor.h |   49 +--
 drivers/media/platform/exynos4-is/fimc-is.c        |   97 ++---
 drivers/media/platform/exynos4-is/fimc-is.h        |    4 +-
 drivers/media/platform/exynos4-is/media-dev.c      |  327 ++++++++++++-----
 drivers/media/platform/exynos4-is/media-dev.h      |   31 +-
 16 files changed, 1024 insertions(+), 531 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/samsung-s5c73m3.txt
 create mode 100644 Documentation/devicetree/bindings/media/samsung-s5k6a3.txt
 create mode 100644 drivers/media/i2c/s5k6a3.c

--
1.7.9.5

