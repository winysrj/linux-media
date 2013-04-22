Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:23795 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab3DVOEi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 10:04:38 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLN00LHRTRIXBI0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Apr 2013 23:04:37 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 00/12] exynos4-is driver fixes
Date: Mon, 22 Apr 2013 16:03:35 +0200
Message-id: <1366639427-14253-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series includes fixes for several issues found during
testing all exynos4-is device drivers build as modules. The exynos4-is
build with all sub-drivers as 'M' is hopefully now free of all serious
issues, but one. I.e. the requirement now is to have all sub-device
drivers, including the sensor subdev drivers, built as modules.

The problem when some of the sub-device drivers is statically linked
is that the media links of a media entity just unregistered from
the media device are not fully cleaned up in the media controller
API. This means other entities can have dangling pointers to the links
array owned by en entity just removed and freed. The problem is not
existent when all media entites are registered/unregistred together.
In such a case it doesn't hurt that media_entity_cleanup() function
just frees the links array.

I will post a separate RFC patch to address this issue, since it is
not trivial where the link references should be removed from all
involved media entities.

I verified that adding a call to media_entity_remove_links() as in
patch [1] to the v4l2_sdubdev_unregister_function() eliminates all
weird crashes present before, when inserting/removing all the host
driver modules while the sensor driver stays loaded.

[1] http://git.linuxtv.org/snawrocki/samsung.git/commitdiff/f7007880a37c28beef845aa0787696aa8cead1cd

Sylwester Nawrocki (12):
  s5c73m3: Fix remove() callback to free requested resources
  s5c73m3: Add missing subdev .unregistered callback
  exynos4-is: Remove redundant MODULE_DEVICE_TABLE entries
  exynos4-is: Fix initialization of subdev 'flags' field
  exynos4-is: Fix regulator/gpio resource releasing on the driver
    removal
  exynos4-is: Don't overwrite subdevdata in the fimc-is sensor driver
  exynos4-is: Unregister fimc-is subdevs from the media device properly
  exynos4-is: Set fimc-lite subdev subdev owner module
  exynos4-is: Remove redundant module_put() for MIPI-CSIS module
  exynos4-is: Remove debugfs entries properly
  exynos4-is: Change function call order in fimc_is_module_exit()
  exynos4-is: Fix runtime PM handling on fimc-is probe error path

 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |   21 +++++++++---
 drivers/media/platform/exynos4-is/fimc-capture.c   |    2 +-
 drivers/media/platform/exynos4-is/fimc-is-i2c.c    |    3 --
 drivers/media/platform/exynos4-is/fimc-is-sensor.c |   35 +++++---------------
 drivers/media/platform/exynos4-is/fimc-is-sensor.h |    6 ++++
 drivers/media/platform/exynos4-is/fimc-is.c        |   15 ++++-----
 drivers/media/platform/exynos4-is/fimc-isp.c       |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |    3 +-
 drivers/media/platform/exynos4-is/media-dev.c      |    5 ++-
 9 files changed, 46 insertions(+), 46 deletions(-)

--
1.7.9.5

