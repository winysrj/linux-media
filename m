Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:23129 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3DJKnR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Apr 2013 06:43:17 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
	shaik.samsung@gmail.com, arun.kk@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 0/7] exynos4-is cleanups and improvements
Date: Wed, 10 Apr 2013 12:42:35 +0200
Message-id: <1365590562-5747-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series includes some cleanups of the recently added FIMC-IS
driver and prerequisite patches for the FIMC-LITE module to make it
easier to reuse in the future exynos5-is driver.

Sylwester Nawrocki (7):
  exynos4-is: Move the subdev group ID definitions to public header
  exynos4-is: Make fimc-lite independent of the pipeline->subdevs array
  exynos4-is: Make fimc-lite independent on struct fimc_sensor_info
  exynos4-is: Improve the ISP chain parameter count calculation
  exynos4-is: Rename the ISP chain configuration data structure
  exynos4-is: Remove meaningless test before bit setting
  exynos4-is: Disable debug trace by default in fimc-isp.c

 drivers/media/platform/exynos4-is/fimc-capture.c  |    7 +-
 drivers/media/platform/exynos4-is/fimc-is-param.c |  277 +++++++++------------
 drivers/media/platform/exynos4-is/fimc-is-param.h |    4 +-
 drivers/media/platform/exynos4-is/fimc-is-regs.c  |   17 +-
 drivers/media/platform/exynos4-is/fimc-is.c       |   24 +-
 drivers/media/platform/exynos4-is/fimc-is.h       |   10 +-
 drivers/media/platform/exynos4-is/fimc-isp.c      |   15 +-
 drivers/media/platform/exynos4-is/fimc-lite.c     |   67 ++---
 drivers/media/platform/exynos4-is/media-dev.c     |   74 +++---
 drivers/media/platform/exynos4-is/media-dev.h     |   15 +-
 include/media/s5p_fimc.h                          |   11 +
 11 files changed, 238 insertions(+), 283 deletions(-)

--
1.7.9.5

