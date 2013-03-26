Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:53839 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab3CZRaL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 13:30:11 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 00/10] s5p-fimc: Exynos4x12 FIMC-IS support prerequisite
Date: Tue, 26 Mar 2013 18:29:42 +0100
Message-id: <1364318992-20562-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series contains a few fixes to the s5p-fimc driver and changes
necessary for the Exynos4x12 FIMC-IS support.

The changes are listed at each patch, if there were any. I have removed
two patches, adding support for setting parent clocks and added a patch
changing the driver directory to drivers/media/platform/exynos4-is.

This series, including dependencies, can be browsed at:
http://git.linuxtv.org/snawrocki/samsung.git/exynos4-fimc-is-v2

Andrzej Hajda (1):
  s5p-fimc: Add error checks for pipeline stream on callbacks

Sylwester Nawrocki (9):
  V4L: Add MATRIX option to V4L2_CID_EXPOSURE_METERING control
  s5p-fimc: Update graph traversal for entities with multiple source
    pads
  s5p-fimc: Add support for PIXELASYNCMx clocks
  s5p-fimc: Add support for ISP Writeback data input bus type
  s5p-fimc: Ensure CAMCLK clock can be enabled by FIMC-LITE devices
  s5p-fimc: Ensure proper s_stream() call order in the ISP datapaths
  s5p-fimc: Ensure proper s_power() call order in the ISP datapaths
  s5p-fimc: Remove dependency on fimc-core.h in fimc-lite driver
  s5p-fimc: Change the driver directory name to exynos4-is

 Documentation/DocBook/media/v4l/controls.xml       |    7 +
 drivers/media/platform/Kconfig                     |    2 +-
 drivers/media/platform/Makefile                    |    2 +-
 .../platform/{s5p-fimc => exynos4-is}/Kconfig      |    9 +-
 .../platform/{s5p-fimc => exynos4-is}/Makefile     |    2 +-
 .../{s5p-fimc => exynos4-is}/fimc-capture.c        |  194 +++++++++++++-------
 .../platform/{s5p-fimc => exynos4-is}/fimc-core.c  |   12 +-
 .../platform/{s5p-fimc => exynos4-is}/fimc-core.h  |   48 ++---
 .../{s5p-fimc => exynos4-is}/fimc-lite-reg.c       |    0
 .../{s5p-fimc => exynos4-is}/fimc-lite-reg.h       |    0
 .../platform/{s5p-fimc => exynos4-is}/fimc-lite.c  |    3 +-
 .../platform/{s5p-fimc => exynos4-is}/fimc-lite.h  |    3 +-
 .../platform/{s5p-fimc => exynos4-is}/fimc-m2m.c   |    3 +-
 .../platform/{s5p-fimc => exynos4-is}/fimc-reg.c   |   75 ++++++--
 .../platform/{s5p-fimc => exynos4-is}/fimc-reg.h   |   11 ++
 .../fimc-mdevice.c => exynos4-is/media-dev.c}      |  182 +++++++++++++-----
 .../fimc-mdevice.h => exynos4-is/media-dev.h}      |   12 ++
 .../platform/{s5p-fimc => exynos4-is}/mipi-csis.c  |    0
 .../platform/{s5p-fimc => exynos4-is}/mipi-csis.h  |    0
 drivers/media/v4l2-core/v4l2-ctrls.c               |    1 +
 include/media/s5p_fimc.h                           |   34 ++++
 include/uapi/linux/v4l2-controls.h                 |    1 +
 22 files changed, 428 insertions(+), 173 deletions(-)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/Kconfig (86%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/Makefile (94%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-capture.c (93%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-core.c (99%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-core.h (94%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-lite-reg.c (100%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-lite-reg.h (100%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-lite.c (99%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-lite.h (99%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-m2m.c (99%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-reg.c (92%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-reg.h (96%)
 rename drivers/media/platform/{s5p-fimc/fimc-mdevice.c => exynos4-is/media-dev.c} (89%)
 rename drivers/media/platform/{s5p-fimc/fimc-mdevice.h => exynos4-is/media-dev.h} (92%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/mipi-csis.c (100%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/mipi-csis.h (100%)

--
1.7.9.5

