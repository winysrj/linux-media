Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:63748 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529Ab2GYML1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jul 2012 08:11:27 -0400
Received: from epcpsbgm1.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M7P00ER2TV2A1Q0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 25 Jul 2012 21:11:26 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M7P003GLTUULT60@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 25 Jul 2012 21:11:26 +0900 (KST)
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org
Cc: sungchun.kang@samsung.com, khw0178.kim@samsung.com,
	mchehab@infradead.org, laurent.pinchart@ideasonboard.com,
	sy0816.kang@samsung.com, s.nawrocki@samsung.com,
	posciak@google.com, alim.akhtar@gmail.com, prashanth.g@samsung.com,
	joshi@samsung.com, shaik.samsung@gmail.com, shaik.ameer@samsung.com
Subject: [PATCH v3 0/5] Add new driver for generic scaler
Date: Wed, 25 Jul 2012 17:56:26 +0530
Message-id: <1343219191-3969-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for the gscaler device which is a new device
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

changes since v2:
- Rebased on latest media-tree git, branch staging/for_v3.6.
	http://linuxtv.org/git/media_tree.git
- Addressed review comments from Pawel Osciak and Sylwester Nawrocki
	https://patchwork.kernel.org/patch/1159031/
- Split the v2 patch into multiple patches

Note: This patch set is based on the following two patches
  1] "V4L: Remove "_ACTIVE" from the selection target name definitions"
  2] "v4l: add fourcc definitions for new formats"

Shaik Ameer Basha (2):
  v4l: Add new YVU420 multi planar fourcc definition
  media: gscaler: Add Makefile for G-Scaler Driver

Sungchun Kang (3):
  media: gscaler: Add new driver for generic scaler
  media: gscaler: Add core functionality for the G-Scaler driver
  media: gscaler: Add m2m functionality for the G-Scaler driver

 Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml |   97 ++-
 drivers/media/video/Kconfig                        |    8 +
 drivers/media/video/Makefile                       |    2 +
 drivers/media/video/exynos-gsc/Makefile            |    3 +
 drivers/media/video/exynos-gsc/gsc-core.c          | 1261 ++++++++++++++++++++
 drivers/media/video/exynos-gsc/gsc-core.h          |  537 +++++++++
 drivers/media/video/exynos-gsc/gsc-m2m.c           |  781 ++++++++++++
 drivers/media/video/exynos-gsc/gsc-regs.c          |  450 +++++++
 drivers/media/video/exynos-gsc/gsc-regs.h          |  172 +++
 include/linux/videodev2.h                          |    1 +
 10 files changed, 3298 insertions(+), 14 deletions(-)
 create mode 100644 drivers/media/video/exynos-gsc/Makefile
 create mode 100644 drivers/media/video/exynos-gsc/gsc-core.c
 create mode 100644 drivers/media/video/exynos-gsc/gsc-core.h
 create mode 100644 drivers/media/video/exynos-gsc/gsc-m2m.c
 create mode 100644 drivers/media/video/exynos-gsc/gsc-regs.c
 create mode 100644 drivers/media/video/exynos-gsc/gsc-regs.h

