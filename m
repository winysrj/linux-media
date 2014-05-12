Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:35220 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaELQSE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 May 2014 12:18:04 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N5G00575YM1RNA0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 May 2014 17:18:01 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0N5G002TPYM10WC0@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 May 2014 17:18:01 +0100 (BST)
Message-id: <5370F435.6040703@samsung.com>
Date: Mon, 12 May 2014 18:17:57 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.15] exynos4-is driver fixes
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit e6a623460e5fc960ac3ee9f946d3106233fd28d8:

  [media] media-device: fix infoleak in ioctl media_enum_entities() (2014-05-01 05:53:28 -0700)

are available in the git repository at:

  ssh://linuxtv.org/git/snawrocki/samsung.git v3.15-fixes-2

for you to fetch changes up to 1f9aadef778aa41e5d723817fdd0d4c7c98df4ad:

  exynos4-is: Free FIMC-IS CPU memory only when allocated (2014-05-12 18:09:38 +0200)

----------------------------------------------------------------
Sylwester Nawrocki (2):
      exynos4-is: Fix compilation for !CONFIG_COMMON_CLK
      exynos4-is: Free FIMC-IS CPU memory only when allocated

 drivers/media/platform/exynos4-is/fimc-is.c   |    3 +++
 drivers/media/platform/exynos4-is/media-dev.c |    2 +-
 drivers/media/platform/exynos4-is/media-dev.h |    4 ++++
 3 files changed, 8 insertions(+), 1 deletion(-)
