Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:49414 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab3EaOh4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 10:37:56 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNO005753B7MTS0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 May 2013 23:37:55 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hj210.choi@samsung.com,
	arun.kk@samsung.com, shaik.ameer@samsung.com,
	kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [REVIEW PATCH v2 00/11] Media link_notify behaviour change and
 exynos4-is updates
Date: Fri, 31 May 2013 16:37:16 +0200
Message-id: <1370011047-11488-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

This is an updated version of a patch set [1], main changes include:
 - In patch "media: Change media device link_notify behaviour"
     - fixed link flags handling in __media_entity_setup_link(),
     - swapped MEDIA_DEV_NOTIFY_PRE_LINK_CH and MEDIA_DEV_NOTIFY_POST_LINK_CH
       at the omap3isp chunk to retain original behaviour,
 - In patch "exynos4-is: Media graph/video device locking rework"
   fixed use_count handling in fimc_lite_release() function;
 - removed patches:
   exynos4-is: Remove platform_device_id table at fimc-lite driver
   exynos4-is: Correct querycap ioctl handling at fimc-lite driver
   as those were quite obvious and I've already added them to my
   tree for 3.11;

The changes are listed at each patch if any. Below is an original cover
letter of v1.


This patch set includes change of the link_notify callback semantics.
This callback will now be invoked always before _and_ after link's state
modification by the core.

Currently this callback is only used by the omap3isp and exynos4-is
drivers, thus those drivers are also modified in patch
[07/11] media: Change media device link_notify behaviour

Any comments/suggestions on this patch are welcome.

The rest of the series includes improvements, bug fixes and preprequsite
patches for the exynos4-is driver to make some modules easier to reuse
in the upcoming exynos5-is driver and to prepare it for addition of
remaining subdevs and video nodes.

This series depends on "[RFC PATCH 0/2] Media entity links handling"
http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/64214

Thanks,
Sylwester

[1] http://www.spinics.net/lists/linux-media/msg63423.html

Sylwester Nawrocki (11):
  exynos4-is: Move common functions to a separate module
  exynos4-is: Add struct exynos_video_entity
  exynos4-is: Preserve state of controls between /dev/video open/close
  exynos4-is: Media graph/video device locking rework
  exynos4-is: Do not use asynchronous runtime PM in release fop
  exynos4-is: Use common exynos_media_pipeline data structure
  exynos4-is: Remove WARN_ON() from __fimc_pipeline_close()
  exynos4-is: Fix sensor subdev -> FIMC notification setup
  exynos4-is: Add locking at fimc(-lite) subdev unregistered handler
  media: Change media device link_notify behaviour
  exynos4-is: Extend link_notify handler to support fimc-is/lite
    pipelines

 drivers/media/media-entity.c                      |   18 +-
 drivers/media/platform/exynos4-is/Kconfig         |    7 +-
 drivers/media/platform/exynos4-is/Makefile        |    5 +-
 drivers/media/platform/exynos4-is/common.c        |   41 ++++
 drivers/media/platform/exynos4-is/common.h        |   12 +
 drivers/media/platform/exynos4-is/fimc-capture.c  |  255 +++++++++++---------
 drivers/media/platform/exynos4-is/fimc-core.h     |   11 +-
 drivers/media/platform/exynos4-is/fimc-lite-reg.c |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c     |  103 ++++----
 drivers/media/platform/exynos4-is/fimc-lite.h     |    8 +-
 drivers/media/platform/exynos4-is/fimc-reg.c      |    7 +-
 drivers/media/platform/exynos4-is/media-dev.c     |  268 ++++++++++++++-------
 drivers/media/platform/exynos4-is/media-dev.h     |   46 +++-
 drivers/media/platform/omap3isp/isp.c             |   41 ++--
 include/media/media-device.h                      |    9 +-
 include/media/s5p_fimc.h                          |   56 +++--
 16 files changed, 543 insertions(+), 346 deletions(-)
 create mode 100644 drivers/media/platform/exynos4-is/common.c
 create mode 100644 drivers/media/platform/exynos4-is/common.h

--
1.7.9.5

