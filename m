Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59633 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab1ITNds (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Sep 2011 09:33:48 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LRT00BRNPOAJW@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Sep 2011 14:33:46 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRT00H8YPOAZE@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Sep 2011 14:33:46 +0100 (BST)
Date: Tue, 20 Sep 2011 15:33:43 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] v4l: Move SR030PC30, NOON010PC30,
 M5MOLS drivers to the right location
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1316525623-7180-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SR030PC30, NOON010PC30, M5MOLS are camera sensors so better place
for them is under the "Camera sensors" Kconfig section.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/Kconfig |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 9da6044..f41ae69 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -496,6 +496,20 @@ config VIDEO_TCM825X
 	  This is a driver for the Toshiba TCM825x VGA camera sensor.
 	  It is used for example in Nokia N800.
 
+config VIDEO_SR030PC30
+	tristate "Siliconfile SR030PC30 sensor support"
+	depends on I2C && VIDEO_V4L2
+	---help---
+	  This driver supports SR030PC30 VGA camera from Siliconfile
+
+config VIDEO_NOON010PC30
+	tristate "Siliconfile NOON010PC30 sensor support"
+	depends on I2C && VIDEO_V4L2 && EXPERIMENTAL && VIDEO_V4L2_SUBDEV_API
+	---help---
+	  This driver supports NOON010PC30 CIF camera from Siliconfile
+
+source "drivers/media/video/m5mols/Kconfig"
+
 comment "Flash devices"
 
 config VIDEO_ADP1653
@@ -744,12 +758,6 @@ config VIDEO_M32R_AR_M64278
 	  To compile this driver as a module, choose M here: the
 	  module will be called arv.
 
-config VIDEO_SR030PC30
-	tristate "SR030PC30 VGA camera sensor support"
-	depends on I2C && VIDEO_V4L2
-	---help---
-	  This driver supports SR030PC30 VGA camera from Siliconfile
-
 config VIDEO_VIA_CAMERA
 	tristate "VIAFB camera controller support"
 	depends on FB_VIA
@@ -760,14 +768,6 @@ config VIDEO_VIA_CAMERA
 	   Chrome9 chipsets.  Currently only tested on OLPC xo-1.5 systems
 	   with ov7670 sensors.
 
-config VIDEO_NOON010PC30
-	tristate "NOON010PC30 CIF camera sensor support"
-	depends on I2C && VIDEO_V4L2
-	---help---
-	  This driver supports NOON010PC30 CIF camera from Siliconfile
-
-source "drivers/media/video/m5mols/Kconfig"
-
 config VIDEO_OMAP3
 	tristate "OMAP 3 Camera support (EXPERIMENTAL)"
 	select OMAP_IOMMU
-- 
1.7.6.3

