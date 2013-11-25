Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:58468 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab3KYJ6k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Nov 2013 04:58:40 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MWT00JDUD1LBV40@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 25 Nov 2013 18:58:33 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, andrzej.p@samsung.com,
	s.nawrocki@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH v2 00/16] Add support for Exynox4x12 to the s5p-jpeg driver
Date: Mon, 25 Nov 2013 10:58:07 +0100
Message-id: <1385373503-1657-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the second version of the series that adds support for the
Exynos4x12 device to the s5p_jpeg driver along with accompanying
fixes. It contains following improvements
(Hans, Sylwester thanks for the review):

- moved adjusting chroma subsampling control value from s_ctrl
  to try_ctrl callback and switched from using v4l2_s_ctrl to
  v4l2_ctrl_s_ctrl
- avoided big switch statement in favour of lookup tables
  for adjusting capture queue fourcc during decoding phase
- avoided unnecessary displacement of clk_get call in the probe function
- renamed decoded_subsampling_to_v4l2 to s5p_jpeg_to_user_subsampling
- added freeing ctrl_handler when v4l2_ctrl_handler_setup fails
- calling s5p_jpeg_runtime_suspend and s5p_jpeg_runtime_resume
  only when pm_runtime_suspended returns false

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
 drivers/media/platform/s5p-jpeg/jpeg-core.c        | 1089 ++++++++++++++++----
 drivers/media/platform/s5p-jpeg/jpeg-core.h        |   75 +-
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos.c   |  293 ++++++
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos.h   |   44 +
 .../platform/s5p-jpeg/{jpeg-hw.h => jpeg-hw-s5p.c} |   82 +-
 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h      |   63 ++
 drivers/media/platform/s5p-jpeg/jpeg-regs.h        |  215 +++-
 8 files changed, 1614 insertions(+), 249 deletions(-)
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos.c
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos.h
 rename drivers/media/platform/s5p-jpeg/{jpeg-hw.h => jpeg-hw-s5p.c} (71%)
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h

-- 
1.7.9.5

