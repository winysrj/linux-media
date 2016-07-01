Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32162 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbcGAMwK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2016 08:52:10 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0O9M00H1KZ8F3M20@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Jul 2016 13:41:03 +0100 (BST)
Received: from AMDN2410 ([106.120.46.21])
 by eusync2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTPA id <0O9M00FPMZ8EBP40@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Jul 2016 13:41:03 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL] mem2mem changes
Date: Fri, 01 Jul 2016 14:41:02 +0200
Message-id: <00a801d1d395$d3fb1390$7bf13ab0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 0db5c79989de2c68d5abb7ba891bfdb3cd3b7e05:

  [media] media-devnode.h: Fix documentation (2016-06-16 08:14:56 -0300)

are available in the git repository at:

  git://linuxtv.org/kdebski/media_tree_2.git master-20160627

for you to fetch changes up to 54fd06bfa3aed1c14731a372be92c15d3cdd6998:

  exynos4-is: Fix buffer release issue on fimc m2m video nodes (2016-06-30
16:03:02 +0200)

----------------------------------------------------------------
Javier Martinez Canillas (5):
      s5p-mfc: fix typo in s5p_mfc_dec function comment
      s5p-mfc: don't print errors on VIDIOC_REQBUFS unsupported mem type
      s5p-mfc: use vb2_is_streaming() to check vb2 queue status
      s5p-mfc: set capablity bus_info as required by VIDIOC_QUERYCAP
      s5p-mfc: improve v4l2_capability driver and card fields

Marek Szyprowski (1):
      media: s5p-mfc: fix error path in driver probe

Shuah Khan (3):
      media: s5p-mfc fix video device release double release in probe error
path
      media: s5p-mfc fix memory leak in s5p_mfc_remove()
      media: s5p-mfc fix null pointer deference in clk_core_enable()

Sylwester Nawrocki (1):
      exynos4-is: Fix buffer release issue on fimc m2m video nodes

 drivers/media/platform/exynos4-is/fimc-m2m.c    | 24
++++++++++--------------
 drivers/media/platform/s5p-mfc/s5p_mfc.c        | 19 +++++++++++--------
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  2 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    | 15 ++++++++-------
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |  7 ++++---
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c     | 12 +++++++++---
 6 files changed, 44 insertions(+), 35 deletions(-)

