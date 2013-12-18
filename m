Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:45781 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab3LROtw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Dec 2013 09:49:52 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MY0001RTBV2NY70@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 18 Dec 2013 23:49:50 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH v3 0/8] Add support for Exynos4x12 device to the s5p-jpeg driver
Date: Wed, 18 Dec 2013 15:49:27 +0100
Message-id: <1387378175-23399-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the third version of the series that adds support for the
Exynos4x12 device to the s5p_jpeg driver. It includes following
changes (Mauro - thanks for the review):

  - renamed all occurrences of "exynos" to more precise "exynos4"
  - added "s5p" and "exynos4" prefixes to the HW API functions

Thanks,
Jacek Anaszewski

Jacek Anaszewski (8):
  s5p-jpeg: Split jpeg-hw.h to jpeg-hw-s5p.c and jpeg-hw-s5p.c
  s5p-jpeg: Add hardware API for the exynos4x12 JPEG codec.
  s5p-jpeg: Retrieve "YCbCr subsampling" field from the jpeg header
  s5p-jpeg: Ensure correct capture format for Exynos4x12
  s5p-jpeg: Allow for wider JPEG subsampling scope for Exynos4x12
    encoder
  s5p-jpeg: Synchronize V4L2_CID_JPEG_CHROMA_SUBSAMPLING control value
  s5p-jpeg: Ensure setting correct value of the chroma subsampling
    control
  s5p-jpeg: Adjust g_volatile_ctrl callback to Exynos4x12 needs

 drivers/media/platform/s5p-jpeg/Makefile           |    2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |  946 +++++++++++++++++---
 drivers/media/platform/s5p-jpeg/jpeg-core.h        |   67 +-
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c  |  279 ++++++
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.h  |   42 +
 .../platform/s5p-jpeg/{jpeg-hw.h => jpeg-hw-s5p.c} |   82 +-
 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h      |   63 ++
 drivers/media/platform/s5p-jpeg/jpeg-regs.h        |  209 ++++-
 8 files changed, 1490 insertions(+), 200 deletions(-)
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.h
 rename drivers/media/platform/s5p-jpeg/{jpeg-hw.h => jpeg-hw-s5p.c} (70%)
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h

-- 
1.7.9.5

