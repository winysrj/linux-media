Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:45254 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab2GEKOM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 06:14:12 -0400
Received: from epcpsbgm1.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M6O002JVN3DED40@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Jul 2012 19:14:11 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M6O00CZLN377P60@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Jul 2012 19:14:10 +0900 (KST)
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org
Cc: sungchun.kang@samsung.com, khw0178.kim@samsung.com,
	mchehab@infradead.org, laurent.pinchart@ideasonboard.com,
	sy0816.kang@samsung.com, s.nawrocki@samsung.com,
	posciak@google.com, alim.akhtar@gmail.com, prashanth.g@samsung.com,
	joshi@samsung.com, ameersk@gmail.com
Subject: [PATCH v2 00/01] Add new driver for generic scaler
Date: Thu, 05 Jul 2012 15:57:40 +0530
Message-id: <1341484061-10914-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add support gscaler device which is a new device
for scaling and color space conversion on EXYNOS5 SoCs.

This device supports the followings as key feature.
 1) Input image format
   - RGB888/565, YUV422 1P/2P, YUV420 2P/3P, TILE
 2) Output image format
   - RGB888/565, YUV422 1P/2P, YUV420 2P/3P, YUV444
 3) Input rotation
   - 0/90/180/270 degree, X/Y Flip
 4) Scale ratio
   - 1/16 scale down to 8 scale up
 5) CSC
   - RGB to YUV / YUV to RGB
 6) Size
   - 2048 x 2048 for tile or rotation
   - 4800 x 3344 other case

changes since v1:
- Rebased on latest media-next tree
	http://linuxtv.org/git/mchehab/media-next.git
- Addressed review comments from Sylwester Nawrocki
	http://patchwork.linuxtv.org/patch/9909/
- Removed gscaler capture, output and media device features from V1,
  as we have a plan to incremently add those gscaler features soon.
- adds NV12 format support 
- adds custom controls specific to gscaler driver

Shaik Ameer Basha (1):
  media: gscaler: Add new driver for generic scaler

 drivers/media/video/Kconfig               |   10 +
 drivers/media/video/Makefile              |    1 +
 drivers/media/video/exynos/Kconfig        |   11 +
 drivers/media/video/exynos/Makefile       |    1 +
 drivers/media/video/exynos/gsc/Kconfig    |    7 +
 drivers/media/video/exynos/gsc/Makefile   |    3 +
 drivers/media/video/exynos/gsc/gsc-core.c | 1304 +++++++++++++++++++++++++++++
 drivers/media/video/exynos/gsc/gsc-core.h |  652 ++++++++++++++
 drivers/media/video/exynos/gsc/gsc-m2m.c  |  751 +++++++++++++++++
 drivers/media/video/exynos/gsc/gsc-regs.c |  579 +++++++++++++
 drivers/media/video/exynos/gsc/gsc-regs.h |  211 +++++
 include/linux/videodev2.h                 |    2 +
 12 files changed, 3532 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/exynos/Kconfig
 create mode 100644 drivers/media/video/exynos/Makefile
 create mode 100644 drivers/media/video/exynos/gsc/Kconfig
 create mode 100644 drivers/media/video/exynos/gsc/Makefile
 create mode 100644 drivers/media/video/exynos/gsc/gsc-core.c
 create mode 100644 drivers/media/video/exynos/gsc/gsc-core.h
 create mode 100644 drivers/media/video/exynos/gsc/gsc-m2m.c
 create mode 100644 drivers/media/video/exynos/gsc/gsc-regs.c
 create mode 100644 drivers/media/video/exynos/gsc/gsc-regs.h

