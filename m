Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:11548 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab3LCSWQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 13:22:16 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MX8000EHTP2G740@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Dec 2013 18:22:14 +0000 (GMT)
Received: from [106.116.147.32] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MX800D0JTP1H260@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Dec 2013 18:22:14 +0000 (GMT)
Message-id: <529E2155.9090400@samsung.com>
Date: Tue, 03 Dec 2013 19:22:13 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] git://linuxtv.org/snawrocki/samsung.git
 v3.14-m2m-ioctl-helpers
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


The following changes since commit fa507e4d32bf6c35eb5fe7dbc0593ae3723c9575:

  [media] media: marvell-ccic: use devm to release clk (2013-11-29 14:46:47 -0200)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git v3.14-m2m-ioctl-helpers

for you to fetch changes up to 36b62509d06080f3c00100a41a2b5d87a83d1d49:

  s5p-g2d: Use mem-to-mem ioctl helpers (2013-12-02 22:34:35 +0100)

----------------------------------------------------------------
Sylwester Nawrocki (5):
      V4L: Add mem2mem ioctl and file operation helpers
      mem2mem_testdev: Use mem-to-mem ioctl and vb2 helpers
      exynos4-is: Use mem-to-mem ioctl helpers
      s5p-jpeg: Use mem-to-mem ioctl helpers
      s5p-g2d: Use mem-to-mem ioctl helpers

 drivers/media/platform/exynos4-is/fimc-core.h |    2 -
 drivers/media/platform/exynos4-is/fimc-m2m.c  |  148 +++++-------------------
 drivers/media/platform/mem2mem_testdev.c      |  152 +++++--------------------
 drivers/media/platform/s5p-g2d/g2d.c          |  124 ++++----------------
 drivers/media/platform/s5p-g2d/g2d.h          |    1 -
 drivers/media/platform/s5p-jpeg/jpeg-core.c   |  134 ++++------------------
 drivers/media/platform/s5p-jpeg/jpeg-core.h   |    2 -
 drivers/media/v4l2-core/v4l2-mem2mem.c        |  126 ++++++++++++++++++++
 include/media/v4l2-fh.h                       |    4 +
 include/media/v4l2-mem2mem.h                  |   24 ++++
 10 files changed, 253 insertions(+), 464 deletions(-)
