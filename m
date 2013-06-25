Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:31115 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab3FYKsa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jun 2013 06:48:30 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MOY009453CM3O50@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 Jun 2013 19:48:29 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, a.hajda@samsung.com,
	j.anaszewski@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 0/6] exynos4-is: TRY format propagation fixes
Date: Tue, 25 Jun 2013 12:48:11 +0200
Message-id: <1372157297-29195-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series includes fixes for issues found while working on a libv4l
plugin for the exynos4-is driver, i.e. TRY format propagation, colorspace
handling and initial format setting on some exynos4-is subdevs.

Sylwester Nawrocki (6):
  exynos4-is: Fix format propagation on FIMC-LITE.n subdevs
  exynos4-is: Set valid initial format at FIMC-LITE
  exynos4-is: Fix format propagation on FIMC-IS-ISP subdev
  exynos4-is: Set valid initial format on FIMC-IS-ISP subdev pads
  exynos4-is: Set valid initial format on FIMC.n subdevs
  exynos4-is: Correct colorspace handling at FIMC-LITE

 drivers/media/platform/exynos4-is/fimc-capture.c |   19 +++-
 drivers/media/platform/exynos4-is/fimc-core.h    |    2 +
 drivers/media/platform/exynos4-is/fimc-isp.c     |  112 +++++++++++++-----
 drivers/media/platform/exynos4-is/fimc-isp.h     |    3 +-
 drivers/media/platform/exynos4-is/fimc-lite.c    |  132 +++++++++++++++-------
 drivers/media/platform/exynos4-is/fimc-lite.h    |    2 +
 include/media/s5p_fimc.h                         |    2 +
 7 files changed, 200 insertions(+), 72 deletions(-)

--
1.7.9.5

