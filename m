Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10925 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932770AbaEEOqJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 May 2014 10:46:09 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N5300HBTVOKF000@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 05 May 2014 15:45:56 +0100 (BST)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0N5300DA5VOVF910@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 05 May 2014 15:46:07 +0100 (BST)
Message-id: <5367A422.5030103@samsung.com>
Date: Mon, 05 May 2014 16:45:54 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] Samsung Exynos JPEG codec and FIMC driver updates
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This includes a few bug fixes for the Samsung SoC FIMC m2m driver
and fixes and cleanups at the s5p-jpeg driver, as a prerequisite 
to support JPEG codec IP found on the Exynos3250 SoCs.

The following changes since commit 393cbd8dc532c1ebed60719da8d379f50d445f28:

  [media] smiapp: Use %u for printing u32 value (2014-04-23 16:05:06 -0300)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for-v3.16

for you to fetch changes up to 13b46c7a03adbcc347b77a13ed27066bc92d515c:

  s5p-jpeg: Fix NV12 format entry related to S5C2120 SoC (2014-05-05 16:22:01 +0200)

----------------------------------------------------------------
Jacek Anaszewski (8):
      s5p-jpeg: Add fmt_ver_flag field to the s5p_jpeg_variant structure
      s5p-jpeg: Perform fourcc downgrade only for Exynos4x12 SoCs
      s5p-jpeg: Add m2m_ops field to the s5p_jpeg_variant structure
      s5p-jpeg: g_selection callback should always succeed
      s5p-jpeg: Fix sysmmu page fault
      s5p-jpeg: Prevent JPEG 4:2:0 > YUV 4:2:0 decompression
      s5p-jpeg: Fix build break when CONFIG_OF is undefined
      s5p-jpeg: Fix NV12 format entry related to S5C2120 SoC

Nicolas Dufresne (3):
      s5p-fimc: Iterate for each memory plane
      s5p-fimc: Changed RGB32 to BGR32
      s5p-fimc: Reuse calculated sizes

 drivers/media/platform/exynos4-is/fimc-core.c |    6 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c  |    6 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c   |  118 +++++++++++++++++--------
 drivers/media/platform/s5p-jpeg/jpeg-core.h   |    6 +-
 4 files changed, 93 insertions(+), 43 deletions(-)

--
Thanks,
Sylwester
