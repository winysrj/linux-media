Return-path: <mchehab@pedra>
Received: from devils.ext.ti.com ([198.47.26.153]:42797 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab0JREG4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 00:06:56 -0400
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id o9I46tw9026819
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 17 Oct 2010 23:06:56 -0500
From: Samreen <samreen@ti.com>
To: Vaibhav Hiremath <hvaibhav@ti.com>
Cc: linux-media@vger.kernel.org, Samreen <samreen@ti.com>
Subject: [PATCH 1/1] OMAP3: V4L2: Kconfig changes to enable V4L2 options on OMAP3
Date: Mon, 18 Oct 2010 09:32:14 +0530
Message-Id: <1287374534-10722-1-git-send-email-samreen@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The defconfig options for V4L2 are taken in the respective Kconfig
to enable V4L2 by default on OMAP3 platforms

Signed-off-by: Samreen <samreen@ti.com>
---
 drivers/media/Kconfig            |    2 ++
 drivers/media/video/omap/Kconfig |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index a28541b..2592d88 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -5,6 +5,7 @@
 menuconfig MEDIA_SUPPORT
 	tristate "Multimedia support"
 	depends on HAS_IOMEM
+	default y if ARCH_OMAP2 || ARCH_OMAP3
 	help
 	  If you want to use Video for Linux, DVB for Linux, or DAB adapters,
 	  enable this option and other options below.
@@ -19,6 +20,7 @@ comment "Multimedia core support"
 
 config VIDEO_DEV
 	tristate "Video For Linux"
+	default y if ARCH_OMAP2 || ARCH_OMAP3
 	---help---
 	  V4L core support for video capture and overlay devices, webcams and
 	  AM/FM radio cards.
diff --git a/drivers/media/video/omap/Kconfig b/drivers/media/video/omap/Kconfig
index e63233f..f3e33c3 100644
--- a/drivers/media/video/omap/Kconfig
+++ b/drivers/media/video/omap/Kconfig
@@ -6,6 +6,6 @@ config VIDEO_OMAP2_VOUT
 	select OMAP2_DSS
 	select OMAP2_VRAM
 	select OMAP2_VRFB
-	default n
+	default y
 	---help---
 	  V4L2 Display driver support for OMAP2/3 based boards.
-- 
1.5.6.3

