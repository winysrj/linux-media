Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:45531 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab3HWSVy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Aug 2013 14:21:54 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MRZ00GZNXOGSNB0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Aug 2013 19:21:52 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MRZ00ABHXOF3770@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Aug 2013 19:21:52 +0100 (BST)
Message-id: <5217A83F.4060800@samsung.com>
Date: Fri, 23 Aug 2013 20:21:51 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.12] Samsung driver cleanup and fixes
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This changeset includes mostly fixes and cleanups for the exynos4-is drivers,
s5p-tv regression fix and some s5k6aa/ov9650 sensor driver bug fixes.

The following changes since commit 976f375df1730dd16aa7c101298ec47bdd338d79:

  [media] media/v4l2: VIDEO_SH_VEU should depend on HAS_DMA (2013-08-23
05:46:08 -0300)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for-3.12-3

for you to fetch changes up to 419da960b12a6d0d48bd12da1df0989206f073fc:

  ov9650: off by one in ov965x_enum_frame_sizes() (2013-08-23 18:51:42 +0200)

----------------------------------------------------------------
Andrzej Hajda (1):
      exynos4-is: Ensure the FIMC gate clock is disabled at driver remove()

Dan Carpenter (4):
      exynos4-is: Print error message on timeout
      s3c-camif: forever loop in camif_hw_set_source_format()
      s5k6aa: off by one in s5k6aa_enum_frame_interval()
      ov9650: off by one in ov965x_enum_frame_sizes()

Sachin Kamat (1):
      exynos4-is: Annotate unused functions

Sylwester Nawrocki (5):
      exynos4-is: Initialize the ISP subdev sd->owner field
      exynos4-is: Add missing MODULE_LICENSE for exynos-fimc-is.ko
      exynos4-is: Add missing v4l2_device_unregister() call in fimc_md_remove()
      exynos4-is: Simplify sclk_cam clocks handling
      s5p-tv: Include missing v4l2-dv-timings.h header file

Tomasz Figa (1):
      exynos4-is: Handle suspend/resume of fimc-is-i2c correctly

 drivers/media/i2c/ov9650.c                        |    2 +-
 drivers/media/i2c/s5k6aa.c                        |    2 +-
 drivers/media/platform/exynos4-is/fimc-core.c     |    2 ++
 drivers/media/platform/exynos4-is/fimc-is-i2c.c   |   33 ++++++++++++++++++---
 drivers/media/platform/exynos4-is/fimc-is-param.c |    2 +-
 drivers/media/platform/exynos4-is/fimc-is-regs.c  |    4 +--
 drivers/media/platform/exynos4-is/fimc-is.c       |    1 +
 drivers/media/platform/exynos4-is/fimc-isp.c      |    2 ++
 drivers/media/platform/exynos4-is/media-dev.c     |   15 ++++------
 drivers/media/platform/s3c-camif/camif-regs.c     |    8 ++---
 drivers/media/platform/s5p-tv/hdmi_drv.c          |    1 +
 11 files changed, 49 insertions(+), 23 deletions(-)


Thank you,
-- 
Sylwester Nawrocki
Samsung R&D Institute Poland
