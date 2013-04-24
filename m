Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:35129 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635Ab3DXRBc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Apr 2013 13:01:32 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLR00MCKRAIGJ20@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 24 Apr 2013 18:01:30 +0100 (BST)
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MLR00IPYRAIFK60@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 24 Apr 2013 18:01:30 +0100 (BST)
Message-id: <51780FE9.5020703@samsung.com>
Date: Wed, 24 Apr 2013 19:01:29 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.10] Samsung SoC media driver fixes
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

The following series includes mostly fixes for the Exynos4x12 ISP driver
and some bug fixes for issues that surfaced while testing all exynos4-is
drivers built as modules. Currently there is one more bug fix patch queued
in -next through arm-soc tree that is needed to build the MIPI-CSIS subdev
as module (30da66eafc015cd7e952829e) and I overlooked it got delayed in
mainline for some reasons.

The following changes since commit 5f3f254f7c138a22a544b80ce2c14a3fc4ed711e:

  [media] media/rc/imon.c: kill urb when send_packet() is interrupted
(2013-04-23 17:50:34 -0300)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for_v3.10_rc2

for you to fetch changes up to ee0c617b0448306bd8787894f68d9b50b88dc734:

  exynos4-is: Copy timestamps from M2M OUTPUT to CAPTURE buffer queue
(2013-04-24 18:07:49 +0200)

----------------------------------------------------------------
Sachin Kamat (2):
      exynos4-is: Fix potential null pointer dereferencing
      exynos4-is: Convert index variable to signed

Sylwester Nawrocki (15):
      s5c73m3: Fix remove() callback to free requested resources
      s5c73m3: Add missing subdev .unregistered callback
      exynos4-is: Remove redundant MODULE_DEVICE_TABLE entries
      exynos4-is: Fix initialization of subdev 'flags' field
      exynos4-is: Fix regulator/gpio resource releasing on the driver removal
      exynos4-is: Don't overwrite subdevdata in the fimc-is sensor driver
      exynos4-is: Unregister fimc-is subdevs from the media device properly
      exynos4-is: Set fimc-lite subdev owner module
      exynos4-is: Remove redundant module_put() for MIPI-CSIS module
      exynos4-is: Remove debugfs entries properly
      exynos4-is: Change function call order in fimc_is_module_exit()
      exynos4-is: Fix runtime PM handling on fimc-is probe error path
      exynos4-is: Fix driver name reported in vidioc_querycap
      exynos4-is: Fix TRY format propagation at MIPI-CSIS subdev
      exynos4-is: Copy timestamps from M2M OUTPUT to CAPTURE buffer queue

Wei Yongjun (1):
      s5p-mfc: fix error return code in s5p_mfc_probe()

 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |   21 +++++++++---
 drivers/media/platform/exynos4-is/fimc-capture.c   |   13 +++-----
 drivers/media/platform/exynos4-is/fimc-core.c      |   17 ++++++++--
 drivers/media/platform/exynos4-is/fimc-core.h      |    6 ++--
 drivers/media/platform/exynos4-is/fimc-is-i2c.c    |    3 --
 drivers/media/platform/exynos4-is/fimc-is-sensor.c |   35 +++++---------------
 drivers/media/platform/exynos4-is/fimc-is-sensor.h |    6 ++++
 drivers/media/platform/exynos4-is/fimc-is.c        |   15 ++++-----
 drivers/media/platform/exynos4-is/fimc-isp.c       |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |    3 +-
 drivers/media/platform/exynos4-is/fimc-lite.h      |    2 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |   26 ++++++++-------
 drivers/media/platform/exynos4-is/media-dev.c      |    5 ++-
 drivers/media/platform/exynos4-is/mipi-csis.c      |   14 +++-----
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |    3 +-
 15 files changed, 89 insertions(+), 82 deletions(-)


Thanks,
Sylwester
