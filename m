Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:42269 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab3KSO1X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Nov 2013 09:27:23 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MWI001GYLHL4W00@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Nov 2013 23:27:21 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 00/16] Add support for Exynox4x12 to the s5p-jpeg driver
Date: Tue, 19 Nov 2013 15:26:52 +0100
Message-id: <1384871228-6648-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The main aim of this series is to add support for Exynos4x12 SoC
for the s5p-jpeg driver. Nonetheless, a room for couple of fixes
and improvements has been found during development, which
is reflected in the corresponding patches.

Thanks,
Jacek Anaszewski

Jacek Anaszewski (16):
  s5p-jpeg: Reorder quantization tables
  s5p-jpeg: Fix output YUV 4:2:0 fourcc for decoder
  s5p-jpeg: Fix erroneous condition while validating bytesperline value
  s5p-jpeg: Remove superfluous call to the jpeg_bound_align_image
    function
  s5p-jpeg: Rename functions specific to the S5PC210 SoC accordingly
  s5p-jpeg: Fix clock resource management
  s5p-jpeg: Fix lack of spin_lock protection
  s5p-jpeg: Synchronize cached controls with V4L2 core
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
 drivers/media/platform/s5p-jpeg/jpeg-core.c        | 1049 ++++++++++++++++----
 drivers/media/platform/s5p-jpeg/jpeg-core.h        |   75 +-
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos.c   |  293 ++++++
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos.h   |   44 +
 .../platform/s5p-jpeg/{jpeg-hw.h => jpeg-hw-s5p.c} |   82 +-
 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h      |   63 ++
 drivers/media/platform/s5p-jpeg/jpeg-regs.h        |  215 +++-
 8 files changed, 1564 insertions(+), 259 deletions(-)
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos.c
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos.h
 rename drivers/media/platform/s5p-jpeg/{jpeg-hw.h => jpeg-hw-s5p.c} (71%)
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h

-- 
1.7.9.5

