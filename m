Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:23963 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030794Ab3HITWW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 15:22:22 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: a.hajda@samsung.com, arun.kk@samsung.com,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 00/10] exynos4-is: Asynchronous subdev registration support
Date: Fri, 09 Aug 2013 21:22:02 +0200
Message-id: <1376076122-29963-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series is a refactoring of the exynos4-is driver to get rid
of the common fimc-is-sensor driver and to adapt it to use "standard"
sensor subdev drivers, one per each image sensor type.
Then a clock provider is added and the s5k6a3 subdev is modified to use
one of the clocks exposed by the exynos4-is driver. Finally a v4l2-async
notifier support is added for image sensor subdevs.
I have also included a couple bug fixes not really related to v4l2-async.

This series depends on patches adding clock deregistration support at
the common clock framework [1] and the other series those depend on [2].

The series can be found in git repository:
http://git.linuxtv.org/snawrocki/samsung.git/v3.11-rc2-dts-exynos4-is-clk

[1] http://www.spinics.net/lists/arm-kernel/msg265989.html
[2] http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg481861.html

Sylwester Nawrocki (9):
  V4L: Add driver for s5k6a3 image sensor
  V4L: s5k6a3: Add support for asynchronous subdev registration
  exynos4-is: Initialize the ISP subdev sd->owner field
  exynos4-is: Add missing MODULE_LICENSE for exynos-fimc-is.ko
  exynos4-is: Add missing v4l2_device_unregister() call in
    fimc_md_remove()
  exynos4-is: Simplify sclk_cam clocks handling
  exynos4-is: Add clock provider for the external clocks
  exynos4-is: Use external s5k6a3 sensor driver
  exynos4-is: Add support for asynchronous sensor subddevs registration

Tomasz Figa (1):
  exynos4-is: Handle suspend/resume of fimc-is-i2c correctly

 .../devicetree/bindings/media/samsung-fimc.txt     |   21 +-
 drivers/media/i2c/Kconfig                          |    8 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/s5k6a3.c                         |  357 ++++++++++++++++++++
 drivers/media/platform/exynos4-is/fimc-is-i2c.c    |   33 +-
 drivers/media/platform/exynos4-is/fimc-is-regs.c   |    2 +-
 drivers/media/platform/exynos4-is/fimc-is-sensor.c |  285 +---------------
 drivers/media/platform/exynos4-is/fimc-is-sensor.h |   49 +--
 drivers/media/platform/exynos4-is/fimc-is.c        |   98 +++---
 drivers/media/platform/exynos4-is/fimc-is.h        |    4 +-
 drivers/media/platform/exynos4-is/fimc-isp.c       |    2 +
 drivers/media/platform/exynos4-is/media-dev.c      |  350 +++++++++++++------
 drivers/media/platform/exynos4-is/media-dev.h      |   31 +-
 13 files changed, 746 insertions(+), 495 deletions(-)
 create mode 100644 drivers/media/i2c/s5k6a3.c

--
1.7.9.5

--
Thanks,
Sylwester

