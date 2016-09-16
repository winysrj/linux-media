Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:57485 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757861AbcIPN7N (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 09:59:13 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0ODL00HQIO6LLF80@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 16 Sep 2016 14:59:09 +0100 (BST)
Received: from eusmges5.samsung.com (unknown [203.254.199.245])
 by     eucas1p2.samsung.com (KnoxPortal)
 with ESMTP id  20160916135908eucas1p26dc9e17ea7af6789d19c8b8ec85a8153~00m47bspE3029230292eucas1p2M
        for <linux-media@vger.kernel.org>; Fri, 16 Sep 2016 13:59:08 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180])
 by     eucas1p1.samsung.com (KnoxPortal)
 with ESMTP id  20160916135908eucas1p120b1cdfc27742ce8771116e5f37e6fd1~00m4UtzG61753017530eucas1p11
        for <linux-media@vger.kernel.org>; Fri, 16 Sep 2016 13:59:08 +0000 (GMT)
Received: from [106.116.147.40] by eusync4.samsung.com
 (Oracle        Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with   ESMTPA id <0ODL00CNBO6JCG80@eusync4.samsung.com> for
        linux-media@vger.kernel.org; Fri, 16 Sep 2016 14:59:07 +0100 (BST)
To: LMML <linux-media@vger.kernel.org>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PULL] Samsung SoC updates for v4.9, part 2
Message-id: <34c3d2d7-c80c-0438-7a3b-8b4636f65d97@samsung.com>
Date: Fri, 16 Sep 2016 15:59:06 +0200
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <CGME20160916135908eucas1p120b1cdfc27742ce8771116e5f37e6fd1@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit c3b809834db8b1a8891c7ff873a216eac119628d:

  [media] pulse8-cec: fix compiler warning (2016-09-12 06:42:44 -0300)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for-v4.9/media/next-2

for you to fetch changes up to 131ea909aa6a0befe0fc23d32fa5725042373d22:

  exynos4-is: add of_platform_populate() call for FIMC-IS child devices (2016-09-16 15:55:12 +0200)

----------------------------------------------------------------
Christophe JAILLET (1):
      s5p-cec: Fix memory allocation failure check

Marek Szyprowski (4):
      s5p-jpeg: fix system and runtime PM integration
      s5p-cec: fix system and runtime PM integration
      exynos4-is: Add support for all required clocks
      exynos4-is: Improve clock management

Sylwester Nawrocki (5):
      exynos4-is: Add missing entity function initialization
      s5k6a3: Add missing entity function initialization
      s5c73m3: Fix entity function assignment for the OIF subdev
      exynos4-is: Clear isp-i2c adapter power.ignore_children flag
      exynos4-is: add of_platform_populate() call for FIMC-IS child devices

 .../bindings/media/exynos4-fimc-is.txt          |  7 +++---
 drivers/media/i2c/s5c73m3/s5c73m3-core.c        |  2 +-
 drivers/media/i2c/s5k6a3.c                      |  1 +
 .../media/platform/exynos4-is/fimc-capture.c    |  1 +
 drivers/media/platform/exynos4-is/fimc-is-i2c.c | 24 ++++++++++++++------
 drivers/media/platform/exynos4-is/fimc-is.c     | 13 ++++++++++-
 drivers/media/platform/exynos4-is/fimc-is.h     |  3 +++
 drivers/media/platform/exynos4-is/fimc-isp.c    |  1 +
 drivers/media/platform/exynos4-is/fimc-lite.c   | 17 ++++----------
 drivers/media/platform/exynos4-is/mipi-csis.c   |  1 +
 drivers/media/platform/s5p-jpeg/jpeg-core.c     | 21 ++---------------
 drivers/staging/media/s5p-cec/s5p_cec.c         | 19 +++-------------
 12 files changed, 51 insertions(+), 59 deletions(-)

--
Thanks, 
Sylwester
