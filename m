Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:18685 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab2BPRWM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Feb 2012 12:22:12 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LZH00LQ7XKYPJ80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Feb 2012 17:22:10 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZH00BR6XKYPG@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Feb 2012 17:22:10 +0000 (GMT)
Date: Thu, 16 Feb 2012 18:22:01 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/6] s5p-csis: Add explicit dependency on REGULATOR
In-reply-to: <1329412925-5872-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1329412925-5872-3-git-send-email-s.nawrocki@samsung.com>
References: <1329412925-5872-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver used the regulator API so it should depend on REGULATOR.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 9adada0..0eb7f3f 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -1116,7 +1116,8 @@ config VIDEO_ATMEL_ISI
 
 config VIDEO_S5P_MIPI_CSIS
 	tristate "Samsung S5P and EXYNOS4 MIPI CSI receiver driver"
-	depends on VIDEO_V4L2 && PM_RUNTIME && PLAT_S5P && VIDEO_V4L2_SUBDEV_API
+	depends on VIDEO_V4L2 && PM_RUNTIME && PLAT_S5P && \
+		   VIDEO_V4L2_SUBDEV_API && REGULATOR
 	---help---
 	  This is a v4l2 driver for Samsung S5P/EXYNOS4 MIPI-CSI receiver.
 
-- 
1.7.9

