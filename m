Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58780 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab1DGQrs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Apr 2011 12:47:48 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 07 Apr 2011 18:47:34 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/3] v4l: Move S5P FIMC driver into Video Capture Devices
In-reply-to: <1302194855-29205-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	kgene.kim@samsung.com, sungchun.kang@samsung.com,
	jonghun.han@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1302194855-29205-3-git-send-email-s.nawrocki@samsung.com>
References: <1302194855-29205-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

s5p-fimc now also implements a camera capture video node so move
it under the "Video capture devices" Kconfig menu. Also update
the entry to reflect the driver's coverage of EXYNOS4 SoCs.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/Kconfig |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 4498b94..492f2ef 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -927,6 +927,14 @@ config VIDEO_MX2
 	  This is a v4l2 driver for the i.MX27 and the i.MX25 Camera Sensor
 	  Interface
 
+config  VIDEO_SAMSUNG_S5P_FIMC
+	tristate "S5P and EXYNOS4 camera host interface driver"
+	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
+	select VIDEOBUF2_DMA_CONTIG
+	select V4L2_MEM2MEM_DEV
+	---help---
+	  This is a v4l2 driver for the S5P and EXYNOS4 camera host interface
+	  and video postprocessor.
 
 #
 # USB Multimedia device configuration
@@ -1022,13 +1030,4 @@ config VIDEO_MEM2MEM_TESTDEV
 	  This is a virtual test device for the memory-to-memory driver
 	  framework.
 
-config  VIDEO_SAMSUNG_S5P_FIMC
-	tristate "Samsung S5P FIMC (video postprocessor) driver"
-	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
-	select VIDEOBUF2_DMA_CONTIG
-	select V4L2_MEM2MEM_DEV
-	help
-	  This is a v4l2 driver for the S5P camera interface
-	  (video postprocessor)
-
 endif # V4L_MEM2MEM_DRIVERS
-- 
1.7.4.3
