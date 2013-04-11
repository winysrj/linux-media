Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46921 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935832Ab3DKRjW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 13:39:22 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ML300B3VQCXDOC0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 11 Apr 2013 18:39:20 +0100 (BST)
Received: from [106.116.147.32] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0ML3004DUQDKRIA0@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 11 Apr 2013 18:39:20 +0100 (BST)
Message-id: <5166F548.8030800@samsung.com>
Date: Thu, 11 Apr 2013 19:39:20 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] s5p-mfc/exynos4-is clean up
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This change set includes mostly some cleanup/refactoring of the Exynos4
FIMC-IS driver and refactoring to make some modules from exynos4-is
easier to re-use in the future Exynos5 FIMC-IS driver.

The following changes since commit 81e096c8ac6a064854c2157e0bf802dc4906678c:

  [media] budget: Add support for Philips Semi Sylt PCI ref. design (2013-04-08
07:28:01 -0300)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for_v3.10_2

for you to fetch changes up to 163a357478f3da49db43afd0352efcc754017a16:

  exynos4-is: Disable debug trace by default in fimc-isp.c (2013-04-10 14:04:29
+0200)

----------------------------------------------------------------
Sylwester Nawrocki (8):
      s5p-mfc: Remove potential uninitialized variable usage
      exynos4-is: Move the subdev group ID definitions to public header
      exynos4-is: Make fimc-lite independent of the pipeline->subdevs array
      exynos4-is: Make fimc-lite independent of struct fimc_sensor_info
      exynos4-is: Improve the ISP chain parameter count calculation
      exynos4-is: Rename the ISP chain configuration data structure
      exynos4-is: Remove meaningless test before bit setting
      exynos4-is: Disable debug trace by default in fimc-isp.c

 drivers/media/platform/exynos4-is/fimc-capture.c  |    7 +-
 drivers/media/platform/exynos4-is/fimc-is-param.c |  277 +++++++++------------
 drivers/media/platform/exynos4-is/fimc-is-param.h |    4 +-
 drivers/media/platform/exynos4-is/fimc-is-regs.c  |   17 +-
 drivers/media/platform/exynos4-is/fimc-is.c       |   24 +-
 drivers/media/platform/exynos4-is/fimc-is.h       |   10 +-
 drivers/media/platform/exynos4-is/fimc-isp.c      |   15 +-
 drivers/media/platform/exynos4-is/fimc-lite.c     |   67 ++---
 drivers/media/platform/exynos4-is/media-dev.c     |   74 +++---
 drivers/media/platform/exynos4-is/media-dev.h     |   15 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c          |    2 +-
 include/media/s5p_fimc.h                          |   11 +
 12 files changed, 239 insertions(+), 284 deletions(-)


Regards,
Sylwester
