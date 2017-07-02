Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:49319 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751863AbdGBTiA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 2 Jul 2017 15:38:00 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] [media] rc-core: do not depend on MEDIA_SUPPORT
Date: Sun,  2 Jul 2017 20:37:58 +0100
Message-Id: <1499024278-809-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no dependency between the two, so remove the dependency in
Kconfig files.

Signed-off-by: Sean Young <sean@mess.org>
---
 arch/arm/configs/imx_v6_v7_defconfig  |  2 +-
 arch/arm/configs/omap2plus_defconfig  |  2 +-
 arch/arm/configs/sunxi_defconfig      |  2 +-
 arch/mips/configs/pistachio_defconfig |  4 ++--
 drivers/media/Kconfig                 | 17 ++---------------
 drivers/media/rc/Kconfig              | 19 ++++++++++++++++---
 6 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/arm/configs/imx_v6_v7_defconfig b/arch/arm/configs/imx_v6_v7_defconfig
index bb6fa56..2392824 100644
--- a/arch/arm/configs/imx_v6_v7_defconfig
+++ b/arch/arm/configs/imx_v6_v7_defconfig
@@ -222,7 +222,7 @@ CONFIG_REGULATOR_MC13892=y
 CONFIG_REGULATOR_PFUZE100=y
 CONFIG_MEDIA_SUPPORT=y
 CONFIG_MEDIA_CAMERA_SUPPORT=y
-CONFIG_MEDIA_RC_SUPPORT=y
+CONFIG_RC_CORE=y
 CONFIG_RC_DEVICES=y
 CONFIG_IR_GPIO_CIR=y
 CONFIG_MEDIA_USB_SUPPORT=y
diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index a120ae8..0414acf 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -304,7 +304,7 @@ CONFIG_REGULATOR_TPS65910=y
 CONFIG_REGULATOR_TWL4030=y
 CONFIG_MEDIA_SUPPORT=m
 CONFIG_MEDIA_CAMERA_SUPPORT=y
-CONFIG_MEDIA_RC_SUPPORT=y
+CONFIG_RC_CORE=m
 CONFIG_MEDIA_CONTROLLER=y
 CONFIG_VIDEO_V4L2_SUBDEV_API=y
 CONFIG_LIRC=m
diff --git a/arch/arm/configs/sunxi_defconfig b/arch/arm/configs/sunxi_defconfig
index 5cd5dd70..6a0920c 100644
--- a/arch/arm/configs/sunxi_defconfig
+++ b/arch/arm/configs/sunxi_defconfig
@@ -96,7 +96,7 @@ CONFIG_REGULATOR_FIXED_VOLTAGE=y
 CONFIG_REGULATOR_AXP20X=y
 CONFIG_REGULATOR_GPIO=y
 CONFIG_MEDIA_SUPPORT=y
-CONFIG_MEDIA_RC_SUPPORT=y
+CONFIG_RC_CORE=y
 CONFIG_RC_DEVICES=y
 CONFIG_IR_SUNXI=y
 CONFIG_DRM=y
diff --git a/arch/mips/configs/pistachio_defconfig b/arch/mips/configs/pistachio_defconfig
index 7d32fbb..f4c57d1 100644
--- a/arch/mips/configs/pistachio_defconfig
+++ b/arch/mips/configs/pistachio_defconfig
@@ -11,7 +11,7 @@ CONFIG_DEFAULT_HOSTNAME="localhost"
 CONFIG_SYSVIPC=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
-CONFIG_IKCONFIG=m
+CONFIG_IKCONFIGRC_CORE=m
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=18
 CONFIG_CGROUPS=y
@@ -207,7 +207,7 @@ CONFIG_IMGPDC_WDT=y
 CONFIG_REGULATOR_FIXED_VOLTAGE=y
 CONFIG_REGULATOR_GPIO=y
 CONFIG_MEDIA_SUPPORT=y
-CONFIG_MEDIA_RC_SUPPORT=y
+CONFIG_RC_CORE=y
 # CONFIG_RC_DECODERS is not set
 CONFIG_RC_DEVICES=y
 CONFIG_IR_IMG=y
diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 55d9c2b..421999b 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -8,6 +8,8 @@ config CEC_CORE
 config CEC_NOTIFIER
 	bool
 
+source "drivers/media/rc/Kconfig"
+
 menuconfig MEDIA_SUPPORT
 	tristate "Multimedia support"
 	depends on HAS_IOMEM
@@ -72,20 +74,6 @@ config MEDIA_SDR_SUPPORT
 
 	  Say Y when you have a software defined radio device.
 
-config MEDIA_RC_SUPPORT
-	bool "Remote Controller support"
-	depends on INPUT
-	---help---
-	  Enable support for Remote Controllers on Linux. This is
-	  needed in order to support several video capture adapters,
-	  standalone IR receivers/transmitters, and RF receivers.
-
-	  Enable this option if you have a video capture board even
-	  if you don't need IR, as otherwise, you may not be able to
-	  compile the driver for your adapter.
-
-	  Say Y when you have a TV or an IR device.
-
 config MEDIA_CEC_SUPPORT
        bool "HDMI CEC support"
        ---help---
@@ -175,7 +163,6 @@ config TTPCI_EEPROM
 source "drivers/media/dvb-core/Kconfig"
 
 comment "Media drivers"
-source "drivers/media/rc/Kconfig"
 
 #
 # V4L platform/mem2mem drivers
diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index c5338e3..bca77f0 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -1,9 +1,20 @@
-config RC_CORE
-	tristate
-	depends on MEDIA_RC_SUPPORT
+
+menuconfig RC_CORE
+	tristate "Remote Controller support"
 	depends on INPUT
 	default y
+	---help---
+	  Enable support for Remote Controllers on Linux. This is
+	  needed in order to support several video capture adapters,
+	  standalone IR receivers/transmitters, and RF receivers.
+
+	  Enable this option if you have a video capture board even
+	  if you don't need IR, as otherwise, you may not be able to
+	  compile the driver for your adapter.
 
+	  Say Y when you have a TV or an IR device.
+
+if RC_CORE
 source "drivers/media/rc/keymaps/Kconfig"
 
 menuconfig RC_DECODERS
@@ -459,3 +470,5 @@ config IR_SIR
 	   be called sir-ir.
 
 endif #RC_DEVICES
+
+endif #RC_CORE
-- 
2.9.4
