Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:59021 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab3LTWXk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 17:23:40 -0500
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 0/6] exynos4-is: Power management related cleanups
Date: Fri, 20 Dec 2013 23:23:21 +0100
Message-Id: <1387578207-17625-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series removes incorrect dependency of the driver on PM_RUNTIME
and is a preparation for further work on actual implementation of
suspend/resume for the FIMC-IS.

Sylwester Nawrocki (6):
  exynos4-is: Leave FIMC clocks enabled when runtime PM is disabled
  exynos4-is: Activate mipi-csis in probe() if runtime PM is disabled
  exynos4-is: Enable FIMC-LITE clock if runtime PM is not used
  exynos4-is: Correct clean up sequence on error path in
    fimc_is_probe()
  exynos4-is: Enable fimc-is clocks in probe() if runtime PM is
    disabled
  exynos4-is: Remove dependency on PM_RUNTIME from Kconfig

 drivers/media/platform/exynos4-is/Kconfig     |    2 +-
 drivers/media/platform/exynos4-is/fimc-core.c |   29 +++++++++++++-----------
 drivers/media/platform/exynos4-is/fimc-is.c   |   29 +++++++++++++++++++------
 drivers/media/platform/exynos4-is/fimc-lite.c |   24 +++++++++++---------
 drivers/media/platform/exynos4-is/mipi-csis.c |   11 ++++++++-
 5 files changed, 62 insertions(+), 33 deletions(-)

--
1.7.4.1

