Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:30629 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933734Ab3GWSj4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 14:39:56 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
	arun.kk@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [REVIEW PATCH 0/6] exynos4-is: Asynchronous subdev registration support
Date: Tue, 23 Jul 2013 20:39:31 +0200
Message-id: <1374604777-15523-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series is a refactoring of the exynos4-is driver to get rid
of the common fimc-is-sensor driver and to adapt it to use "standard"
sensor subdev drivers, one per each image sensor type.
Then a clock provider is added to the exynos4-is driver and the s5k6a3
subdev is modified to use one of the clocks registered by exynos4-is.

Arun, I think you could reuse the s5k6a3 sensor for your work on the
Exynos5 FIMC-IS driver. One advantage of separate sensor drivers is
that the power on/off sequences can be written specifically for each
sensor. We are probably going to need such sequences per board in
future. Also having the clock control inside the sensor subdev allows
to better match the hardware power on/off sequence requirements,
however the S5K6A3 sensor can have active clock signal on its clock
input pin even when all its power supplies are turned off.

I'm posting this series before having a proper implementation for
clk_unregister() in the clock framework, so you are not blocked with
your Exynos5 FIMC-IS works.

This series with all dependencies can be found at:
http://git.linuxtv.org/snawrocki/samsung.git/exynos4-is-clk

Thanks,
Sylwester


Sylwester Nawrocki (6):
  V4L: Add driver for s5k6a3 image sensor
  V4L: s5k6a3: Add support for asynchronous subdev registration
  exynos4-is: Simplify sclk_cam clocks handling
  exynos4-is: Add clock provider for the external clocks
  exynos4-is: Use external s5k6a3 sensor driver
  exynos4-is: Add support for asynchronous sensor subddevs registration

 .../devicetree/bindings/media/samsung-fimc.txt     |   17 +-
 drivers/media/i2c/Kconfig                          |    8 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/s5k6a3.c                         |  356 ++++++++++++++++++++
 drivers/media/platform/exynos4-is/fimc-is-regs.c   |    2 +-
 drivers/media/platform/exynos4-is/fimc-is-sensor.c |  285 +---------------
 drivers/media/platform/exynos4-is/fimc-is-sensor.h |   49 +--
 drivers/media/platform/exynos4-is/fimc-is.c        |   96 +++---
 drivers/media/platform/exynos4-is/fimc-is.h        |    4 +-
 drivers/media/platform/exynos4-is/media-dev.c      |  268 ++++++++++-----
 drivers/media/platform/exynos4-is/media-dev.h      |   31 +-
 11 files changed, 650 insertions(+), 467 deletions(-)
 create mode 100644 drivers/media/i2c/s5k6a3.c

--
1.7.9.5

