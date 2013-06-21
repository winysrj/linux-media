Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:23891 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab3FUM4Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 08:56:16 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MOQ003PEULMNPE0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 21 Jun 2013 21:56:15 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, j.anaszewski@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 0/6] exynos4-is: TRY format propagation fixes
Date: Fri, 21 Jun 2013 14:55:52 +0200
Message-id: <1371819358-13106-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series includes fixes of TRY format propagation, colospace
handling and intial format setting on some exynos4-is subdevs.

Sylwester Nawrocki (6):
  exynos4-is: Fix format propagation on FIMC-LITE.n subdevs
  exynos4-is: Set valid initial format at FIMC-LITE
  exynos4-is: Fix format propagation on FIMC-IS-ISP subdev
  exynos4-is: Set valid initial format on FIMC-IS-ISP subdev pads
  exynos4-is: Set valid initial format on FIMC.n subdevs
  exynos4-is: Correct colorspace handling at FIMC-LITE

 drivers/media/platform/exynos4-is/fimc-capture.c |   19 +++-
 drivers/media/platform/exynos4-is/fimc-core.h    |    2 +
 drivers/media/platform/exynos4-is/fimc-isp.c     |  108 ++++++++++++++++------
 drivers/media/platform/exynos4-is/fimc-isp.h     |    3 +-
 drivers/media/platform/exynos4-is/fimc-lite.c    |   95 +++++++++++++------
 drivers/media/platform/exynos4-is/fimc-lite.h    |    2 +
 include/media/s5p_fimc.h                         |    2 +
 7 files changed, 171 insertions(+), 60 deletions(-)

--
1.7.9.5

