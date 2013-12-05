Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:20418 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab3LELjj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Dec 2013 06:39:39 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MXC00KF20E1OW10@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Dec 2013 11:39:37 +0000 (GMT)
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MXC00L7Y0E1IG20@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Dec 2013 11:39:37 +0000 (GMT)
Message-id: <52A065F8.8070404@samsung.com>
Date: Thu, 05 Dec 2013 12:39:36 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] s5p-jpeg codec driver update for Exynos4x12 SoCs
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 3f823e094b935c1882605f8720336ee23433a16d:

  [media] exynos4-is: Simplify fimc-is hardware polling helpers (2013-12-04 15:54:19 -0200)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git v3.14-s5p-jpeg-exynos4x12

for you to fetch changes up to 4990e9e72df0382a032fdb20b187ec34f13f7ddc:

  s5p-jpeg: Adjust g_volatile_ctrl callback to Exynos4x12 needs (2013-12-04 23:56:52 +0100)

----------------------------------------------------------------
Jacek Anaszewski (16):
      s5p-jpeg: Reorder quantization tables
      s5p-jpeg: Fix output YUV 4:2:0 fourcc for decoder
      s5p-jpeg: Fix erroneous condition while validating bytesperline value
      s5p-jpeg: Remove superfluous call to the jpeg_bound_align_image function
      s5p-jpeg: Rename functions specific to the S5PC210 SoC accordingly
      s5p-jpeg: Fix clock resource management
      s5p-jpeg: Fix lack of spin_lock protection
      s5p-jpeg: Synchronize cached controls with V4L2 core
      s5p-jpeg: Split jpeg-hw.h to jpeg-hw-s5p.c and jpeg-hw-s5p.c
      s5p-jpeg: Add hardware API for the exynos4x12 JPEG codec
      s5p-jpeg: Retrieve "YCbCr subsampling" field from the jpeg header
      s5p-jpeg: Ensure correct capture format for Exynos4x12
      s5p-jpeg: Allow for wider JPEG subsampling scope for Exynos4x12 encoder
      s5p-jpeg: Synchronize V4L2_CID_JPEG_CHROMA_SUBSAMPLING control value
      s5p-jpeg: Ensure setting correct value of the chroma subsampling control
      s5p-jpeg: Adjust g_volatile_ctrl callback to Exynos4x12 needs

Seung-Woo Kim (1):
      s5p-jpeg: Fix encoder and decoder video dev names

Sylwester Nawrocki (1):
      s5p-jpeg: Add initial device tree support for S5PV210/Exynos4210 SoCs

 .../bindings/media/exynos-jpeg-codec.txt           |   11 +
 drivers/media/platform/s5p-jpeg/Makefile           |    2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        | 1097 ++++++++++++++++----
 drivers/media/platform/s5p-jpeg/jpeg-core.h        |   75 +-
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos.c   |  293 ++++++
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos.h   |   44 +
 .../platform/s5p-jpeg/{jpeg-hw.h => jpeg-hw-s5p.c} |   82 +-
 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h      |   63 ++
 drivers/media/platform/s5p-jpeg/jpeg-regs.h        |  215 +++-
 9 files changed, 1634 insertions(+), 248 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos.c
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos.h
 rename drivers/media/platform/s5p-jpeg/{jpeg-hw.h => jpeg-hw-s5p.c} (71%)
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h
