Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:30845 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab2GaN3M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 09:29:12 -0400
Received: from epcpsbgm1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8100AGL1FG2Q80@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 31 Jul 2012 22:28:41 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M8100ALP1FF8G60@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 31 Jul 2012 22:28:41 +0900 (KST)
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org
Cc: sungchun.kang@samsung.com, khw0178.kim@samsung.com,
	mchehab@infradead.org, laurent.pinchart@ideasonboard.com,
	sy0816.kang@samsung.com, s.nawrocki@samsung.com,
	posciak@google.com, hverkuil@xs4all.nl, alim.akhtar@gmail.com,
	prashanth.g@samsung.com, joshi@samsung.com,
	shaik.samsung@gmail.com, shaik.ameer@samsung.com
Subject: [PATCH v5 0/5] Add new driver for generic scaler
Date: Tue, 31 Jul 2012 19:14:01 +0530
Message-id: <1343742246-27579-1-git-send-email-shaik.ameer@samsung.com>
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

changes since v4:
- Rebased on latest media-tree git, branch staging/for_v3.6.
        http://linuxtv.org/git/media_tree.git
- Addressed review comments from Hans Verkuil
	http://www.mail-archive.com/linux-media@vger.kernel.org/msg49754.html
- Removed the "v4l: Add fourcc definitions for new formats" patch dependency.

Shaik Ameer Basha (2):
  v4l: Add new YVU420 multi planar fourcc definition
  media: gscaler: Add Makefile for G-Scaler Driver

Sungchun Kang (3):
  media: gscaler: Add new driver for generic scaler
  media: gscaler: Add core functionality for the G-Scaler driver
  media: gscaler: Add m2m functionality for the G-Scaler driver

 Documentation/DocBook/media/v4l/pixfmt-yvu420m.xml |  154 +++
 Documentation/DocBook/media/v4l/pixfmt.xml         |    1 +
 drivers/media/video/Kconfig                        |    8 +
 drivers/media/video/Makefile                       |    2 +
 drivers/media/video/exynos-gsc/Makefile            |    3 +
 drivers/media/video/exynos-gsc/gsc-core.c          | 1254 ++++++++++++++++++++
 drivers/media/video/exynos-gsc/gsc-core.h          |  532 +++++++++
 drivers/media/video/exynos-gsc/gsc-m2m.c           |  771 ++++++++++++
 drivers/media/video/exynos-gsc/gsc-regs.c          |  425 +++++++
 drivers/media/video/exynos-gsc/gsc-regs.h          |  172 +++
 include/linux/videodev2.h                          |    1 +
 11 files changed, 3323 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-yvu420m.xml
 create mode 100644 drivers/media/video/exynos-gsc/Makefile
 create mode 100644 drivers/media/video/exynos-gsc/gsc-core.c
 create mode 100644 drivers/media/video/exynos-gsc/gsc-core.h
 create mode 100644 drivers/media/video/exynos-gsc/gsc-m2m.c
 create mode 100644 drivers/media/video/exynos-gsc/gsc-regs.c
 create mode 100644 drivers/media/video/exynos-gsc/gsc-regs.h

