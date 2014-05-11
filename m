Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback5.mail.ru ([94.100.176.59]:51480 "EHLO
	fallback5.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbaEKIut (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 May 2014 04:50:49 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Shawn Guo <shawn.guo@freescale.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH] ARM: i.MX: Remove excess symbols ARCH_MX1, ARCH_MX25 and MACH_MX27
Date: Sun, 11 May 2014 12:50:06 +0400
Message-Id: <1399798206-17565-1-git-send-email-shc_work@mail.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch removes excess symbols ARCH_MX1, ARCH_MX25 and MACH_MX27.
Instead we use SOC_IMX*.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 arch/arm/mach-imx/Kconfig                 | 12 ------------
 arch/arm/mach-imx/devices/Kconfig         |  2 +-
 drivers/media/platform/soc_camera/Kconfig |  2 +-
 3 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index d56eb1a..c28fa7c 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -67,18 +67,8 @@ config IMX_HAVE_IOMUX_V1
 config ARCH_MXC_IOMUX_V3
 	bool
 
-config ARCH_MX1
-	bool
-
-config ARCH_MX25
-	bool
-
-config MACH_MX27
-	bool
-
 config SOC_IMX1
 	bool
-	select ARCH_MX1
 	select CPU_ARM920T
 	select IMX_HAVE_IOMUX_V1
 	select MXC_AVIC
@@ -91,7 +81,6 @@ config SOC_IMX21
 
 config SOC_IMX25
 	bool
-	select ARCH_MX25
 	select ARCH_MXC_IOMUX_V3
 	select CPU_ARM926T
 	select MXC_AVIC
@@ -103,7 +92,6 @@ config SOC_IMX27
 	select ARCH_HAS_OPP
 	select CPU_ARM926T
 	select IMX_HAVE_IOMUX_V1
-	select MACH_MX27
 	select MXC_AVIC
 	select PINCTRL_IMX27
 
diff --git a/arch/arm/mach-imx/devices/Kconfig b/arch/arm/mach-imx/devices/Kconfig
index 846c019..1f9d4a6 100644
--- a/arch/arm/mach-imx/devices/Kconfig
+++ b/arch/arm/mach-imx/devices/Kconfig
@@ -1,6 +1,6 @@
 config IMX_HAVE_PLATFORM_FEC
 	bool
-	default y if ARCH_MX25 || SOC_IMX27 || SOC_IMX35 || SOC_IMX51 || SOC_IMX53
+	default y if SOC_IMX25 || SOC_IMX27 || SOC_IMX35 || SOC_IMX51 || SOC_IMX53
 
 config IMX_HAVE_PLATFORM_FLEXCAN
 	bool
diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
index 122e03a..f0ccedd 100644
--- a/drivers/media/platform/soc_camera/Kconfig
+++ b/drivers/media/platform/soc_camera/Kconfig
@@ -63,7 +63,7 @@ config VIDEO_OMAP1
 
 config VIDEO_MX2
 	tristate "i.MX27 Camera Sensor Interface driver"
-	depends on VIDEO_DEV && SOC_CAMERA && MACH_MX27
+	depends on VIDEO_DEV && SOC_CAMERA && SOC_IMX27
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This is a v4l2 driver for the i.MX27 Camera Sensor Interface
-- 
1.8.3.2

