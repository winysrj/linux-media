Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:60550 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab3EIPhF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 May 2013 11:37:05 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MMJ00EQ1FDP2XF0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 May 2013 00:37:03 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hj210.choi@samsung.com, dh09.lee@samsung.com, a.hajda@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 00/13] Media link_notify behaviour change an exynos4-is
 updates
Date: Thu, 09 May 2013 17:36:32 +0200
Message-id: <1368113805-20233-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

This patch set includes change of the link_notify callback semantics.
This callback will now be invoked always before _and_ after link's state
modification by the core.

Currently this callback is only used by the omap3isp and exynos4-is
drivers, thus those drivers are also modified in patch
[09/13] media: Change media device link_notify behaviour

Any comments/suggestions on this patch are welcome.

The rest of the series includes improvements, bug fixes and preprequsite
patches for the exynos4-is driver to make some modules easier to reuse
in the upcoming exynos5-is driver and to prepare it for addition of
remaining subdevs and video nodes.

This series depends on "[RFC PATCH 0/2] Media entity links handling"
http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/64214

Thanks,
Sylwester

Sylwester Nawrocki (13):
  exynos4-is: Remove platform_device_id table at fimc-lite driver
  exynos4-is: Correct querycap ioctl handling at fimc-lite driver
  exynos4-is: Move common functions to a separate module
  exynos4-is: Add struct exynos_video_entity
  exynos4-is: Preserve state of controls between /dev/video open/close
  exynos4-is: Media graph/video device locking rework
  exynos4-is: Do not use asynchronous runtime PM in release fop
  exynos4-is: Use common exynos_media_pipeline data structure
  media: Change media device link_notify behaviour
  exynos4-is: Extend link_notify handler to support fimc-is/lite
    pipelines
  exynos4-is: Fix sensor subdev -> FIMC notification setup
  exynos4-is: Add locking at fimc(-lite) subdev unregistered handler
  exynos4-is: Remove WARN_ON() from __fimc_pipeline_close()

 drivers/media/media-entity.c                      |   18 +-
 drivers/media/platform/exynos4-is/Kconfig         |    5 +
 drivers/media/platform/exynos4-is/Makefile        |    2 +
 drivers/media/platform/exynos4-is/common.c        |   41 ++++
 drivers/media/platform/exynos4-is/common.h        |   12 +
 drivers/media/platform/exynos4-is/fimc-capture.c  |  253 ++++++++++---------
 drivers/media/platform/exynos4-is/fimc-core.h     |   11 +-
 drivers/media/platform/exynos4-is/fimc-lite-reg.c |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c     |  132 +++++-----
 drivers/media/platform/exynos4-is/fimc-lite.h     |    8 +-
 drivers/media/platform/exynos4-is/fimc-reg.c      |    7 +-
 drivers/media/platform/exynos4-is/media-dev.c     |  268 ++++++++++++++-------
 drivers/media/platform/exynos4-is/media-dev.h     |   51 +++-
 drivers/media/platform/omap3isp/isp.c             |   41 ++--
 include/media/media-device.h                      |    9 +-
 include/media/s5p_fimc.h                          |   56 +++--
 16 files changed, 556 insertions(+), 360 deletions(-)
 create mode 100644 drivers/media/platform/exynos4-is/common.c
 create mode 100644 drivers/media/platform/exynos4-is/common.h

--
1.7.9.5

