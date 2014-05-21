Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56215 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaEUJjJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 May 2014 05:39:09 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N5X00LMT452FO50@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 May 2014 10:39:02 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0N5X00LG1456DK50@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 May 2014 10:39:07 +0100 (BST)
Message-id: <537C7439.6080507@samsung.com>
Date: Wed, 21 May 2014 11:39:05 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.16] exynos4-is driver cleanup
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This two patches is the exynos4-is driver cleanup, i.e. removing unused
code to support non-dt platforms. One of the patches touches arch/arm and
it has been acked by Mr. Kim.
Please note this branch includes two patches from my previous pull request
[1], which I hoped to be merged for 3.15.

[1] https://patchwork.linuxtv.org/patch/23891/

The following changes since commit 491a5efdef074fac14b99e2c85d2fe7a08f9e73d:

  exynos4-is: Free FIMC-IS CPU memory only when allocated (2014-05-21 11:22:04 +0200)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for-v3.16-2

for you to fetch changes up to f7c0dfda8531ed4236a5c716b4c044e85f1ec3d0:

  exynos4-is: Remove support for non-dt platforms (2014-05-21 11:22:27 +0200)

----------------------------------------------------------------
Sylwester Nawrocki (2):
      ARM: S5PV210: Remove camera support from mach-goni.c
      exynos4-is: Remove support for non-dt platforms

 Documentation/video4linux/fimc.txt                 |   30 --
 MAINTAINERS                                        |    1 -
 arch/arm/mach-s5pv210/mach-goni.c                  |   51 ---
 drivers/media/platform/exynos4-is/Kconfig          |    3 +-
 drivers/media/platform/exynos4-is/common.c         |    2 +-
 drivers/media/platform/exynos4-is/fimc-core.h      |    2 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |    2 +-
 drivers/media/platform/exynos4-is/fimc-isp.h       |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite-reg.c  |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite.h      |    2 +-
 drivers/media/platform/exynos4-is/fimc-reg.c       |    2 +-
 drivers/media/platform/exynos4-is/media-dev.c      |  329 ++------------------
 drivers/media/platform/exynos4-is/media-dev.h      |    6 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |   43 +--
 include/linux/platform_data/mipi-csis.h            |   28 --
 include/media/{s5p_fimc.h => exynos-fimc.h}        |   21 --
 17 files changed, 50 insertions(+), 478 deletions(-)
 delete mode 100644 include/linux/platform_data/mipi-csis.h
 rename include/media/{s5p_fimc.h => exynos-fimc.h} (87%)

--
Regards,
Sylwester
