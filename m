Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:16591 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab3LRPOj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Dec 2013 10:14:39 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MY000M55D0D6310@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 18 Dec 2013 15:14:37 +0000 (GMT)
Received: from [106.116.147.32] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MY000A0KD0C3370@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 18 Dec 2013 15:14:37 +0000 (GMT)
Message-id: <52B1BBD7.3020101@samsung.com>
Date: Wed, 18 Dec 2013 16:14:31 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] s5p-jpeg codec driver update for Exynos4x12 SoCs
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

These are remaining patches with the namespace issue corrected.

The following changes since commit c0ec1c4dd7d6b2bfb1eca116f9df4578d9193623:

  [media] a8293: add small sleep in order to settle LNB voltage (2013-12-18
07:18:31 -0200)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git v3.14-s5p-jpeg-exynos4x12-2

for you to fetch changes up to 76762adeb4d37810bf61d3c664a647dd8fc8d4c9:

  s5p-jpeg: Adjust g_volatile_ctrl callback to Exynos4x12 needs (2013-12-18
16:10:19 +0100)

----------------------------------------------------------------
Jacek Anaszewski (8):
      s5p-jpeg: Split jpeg-hw.h to jpeg-hw-s5p.c and jpeg-hw-s5p.c
      s5p-jpeg: Add hardware API for the exynos4x12 JPEG codec
      s5p-jpeg: Retrieve "YCbCr subsampling" field from the jpeg header
      s5p-jpeg: Ensure correct capture format for Exynos4x12
      s5p-jpeg: Allow for wider JPEG subsampling scope for Exynos4x12 encoder
      s5p-jpeg: Synchronize V4L2_CID_JPEG_CHROMA_SUBSAMPLING control value
      s5p-jpeg: Ensure setting correct value of the chroma subsampling control
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

Thanks,
Sylwester
