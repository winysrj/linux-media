Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:41414 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab3EaMlB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 08:41:01 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNN000KAXW8JPU0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 May 2013 21:41:00 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hj210.choi@samsung.com, kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 0/3] exynos4-is fixes for 3.10
Date: Fri, 31 May 2013 14:40:34 +0200
Message-id: <1370004037-18314-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This includes fixes for couple issues found during further testing
of the exynos4-is driver I'd like to queue for 3.10

Sylwester Nawrocki (3):
  exynos4-is: Prevent NULL pointer dereference when firmware isn't
    loaded
  exynos4-is: Ensure fimc-is clocks are not enabled until properly
    configured
  exynos4-is: Fix reported colorspace at FIMC-IS-ISP subdev

 drivers/media/platform/exynos4-is/fimc-is.c  |   21 ++++++++++-----------
 drivers/media/platform/exynos4-is/fimc-isp.c |    4 ++--
 2 files changed, 12 insertions(+), 13 deletions(-)

--
1.7.9.5

