Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:46805 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721Ab2K1TJj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 14:09:39 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ME700HZQP81F3B0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Nov 2012 04:09:37 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0ME7006TUP7TOU90@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Nov 2012 04:09:37 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, kyungmin.park@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 00/12] Exynos FIMC driver updates
Date: Wed, 28 Nov 2012 20:09:17 +0100
Message-id: <1354129766-2821-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series contains mainly prerequisite changes for adding
FIMC-IS (camera ISP) device support for Exynos4x12 SoCs.
The ISP driver itself is under development and I intend to post
initial version of it soon.

Sylwester Nawrocki (12):
  V4L: DocBook: Add V4L2_MBUS_FMT_YUV10_1X30 media bus pixel code
  s5p-fimc: Fix horizontal/vertical image flip
  fimc-lite: Register dump function cleanup
  s5p-fimc: Clean up capture enable/disable helpers
  s5p-fimc: Add variant data structure for Exynos4x12
  s5p-csis: Add support for raw Bayer pixel formats
  s5p-csis: Enable only data lanes that are actively used
  s5p-csis: Correct the event counters logging
  s5p-csis: Add registers logging for debugging
  fimc-lite: Remove empty subdev s_power callback
  s5p-fimc: Add sensor group ids for fimc-is
  fimc-lite: Add ISP FIFO output support

 Documentation/DocBook/media/v4l/subdev-formats.xml |  718 ++++++--------------
 Documentation/DocBook/media_api.tmpl               |    1 +
 drivers/media/platform/s5p-fimc/fimc-capture.c     |    8 +-
 drivers/media/platform/s5p-fimc/fimc-core.c        |   90 ++-
 drivers/media/platform/s5p-fimc/fimc-core.h        |    8 +-
 drivers/media/platform/s5p-fimc/fimc-lite-reg.c    |    6 +-
 drivers/media/platform/s5p-fimc/fimc-lite.c        |  156 +++--
 drivers/media/platform/s5p-fimc/fimc-lite.h        |    7 +-
 drivers/media/platform/s5p-fimc/fimc-m2m.c         |    2 +-
 drivers/media/platform/s5p-fimc/fimc-mdevice.c     |   23 +-
 drivers/media/platform/s5p-fimc/fimc-mdevice.h     |   12 +-
 drivers/media/platform/s5p-fimc/fimc-reg.c         |   48 +-
 drivers/media/platform/s5p-fimc/fimc-reg.h         |    4 +-
 drivers/media/platform/s5p-fimc/mipi-csis.c        |   58 +-
 include/uapi/linux/v4l2-mediabus.h                 |    3 +-
 15 files changed, 487 insertions(+), 657 deletions(-)

--
1.7.9.5

