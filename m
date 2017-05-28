Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:43392 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750979AbdE1Joh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 05:44:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH for v4.12 1/3] cec: select CEC_CORE instead of depend on it
Date: Sun, 28 May 2017 11:44:24 +0200
Message-Id: <20170528094426.10089-2-hverkuil@xs4all.nl>
In-Reply-To: <20170528094426.10089-1-hverkuil@xs4all.nl>
References: <20170528094426.10089-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The CEC framework is used by both drm and media. That makes it tricky
to get the dependencies right.

This patch moves the CEC_CORE and MEDIA_CEC_NOTIFIER config options
out of the media menu and instead drivers that want to use CEC should
select CEC_CORE and MEDIA_CEC_NOTIFIER (if needed).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/Kconfig                    | 6 ++++++
 drivers/media/Makefile                   | 4 ++--
 drivers/media/cec/Kconfig                | 8 --------
 drivers/media/i2c/Kconfig                | 9 ++++++---
 drivers/media/platform/Kconfig           | 6 ++++--
 drivers/media/platform/vivid/Kconfig     | 3 ++-
 drivers/media/usb/pulse8-cec/Kconfig     | 3 ++-
 drivers/media/usb/rainshadow-cec/Kconfig | 3 ++-
 8 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index b72edd27f880..9ec634e2f2ba 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -2,6 +2,12 @@
 # Multimedia device configuration
 #
 
+config CEC_CORE
+	tristate
+
+config MEDIA_CEC_NOTIFIER
+	bool
+
 menuconfig MEDIA_SUPPORT
 	tristate "Multimedia support"
 	depends on HAS_IOMEM
diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index 523fea3648ad..044503aa8801 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -4,8 +4,6 @@
 
 media-objs	:= media-device.o media-devnode.o media-entity.o
 
-obj-$(CONFIG_CEC_CORE) += cec/
-
 #
 # I2C drivers should come before other drivers, otherwise they'll fail
 # when compiled as builtin drivers
@@ -26,6 +24,8 @@ obj-$(CONFIG_DVB_CORE)  += dvb-core/
 # There are both core and drivers at RC subtree - merge before drivers
 obj-y += rc/
 
+obj-$(CONFIG_CEC_CORE) += cec/
+
 #
 # Finally, merge the drivers that require the core
 #
diff --git a/drivers/media/cec/Kconfig b/drivers/media/cec/Kconfig
index 488fb908244d..5d5091499ab1 100644
--- a/drivers/media/cec/Kconfig
+++ b/drivers/media/cec/Kconfig
@@ -1,11 +1,3 @@
-config CEC_CORE
-	tristate
-	depends on MEDIA_CEC_SUPPORT
-	default y
-
-config MEDIA_CEC_NOTIFIER
-	bool
-
 config MEDIA_CEC_RC
 	bool "HDMI CEC RC integration"
 	depends on CEC_CORE && RC_CORE
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index fd181c99ce11..aaa9471c7d11 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -220,7 +220,8 @@ config VIDEO_ADV7604
 
 config VIDEO_ADV7604_CEC
 	bool "Enable Analog Devices ADV7604 CEC support"
-	depends on VIDEO_ADV7604 && CEC_CORE
+	depends on VIDEO_ADV7604
+	select CEC_CORE
 	---help---
 	  When selected the adv7604 will support the optional
 	  HDMI CEC feature.
@@ -240,7 +241,8 @@ config VIDEO_ADV7842
 
 config VIDEO_ADV7842_CEC
 	bool "Enable Analog Devices ADV7842 CEC support"
-	depends on VIDEO_ADV7842 && CEC_CORE
+	depends on VIDEO_ADV7842
+	select CEC_CORE
 	---help---
 	  When selected the adv7842 will support the optional
 	  HDMI CEC feature.
@@ -478,7 +480,8 @@ config VIDEO_ADV7511
 
 config VIDEO_ADV7511_CEC
 	bool "Enable Analog Devices ADV7511 CEC support"
-	depends on VIDEO_ADV7511 && CEC_CORE
+	depends on VIDEO_ADV7511
+	select CEC_CORE
 	---help---
 	  When selected the adv7511 will support the optional
 	  HDMI CEC feature.
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index ac026ee1ca07..017419bef9b1 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -501,7 +501,8 @@ if CEC_PLATFORM_DRIVERS
 
 config VIDEO_SAMSUNG_S5P_CEC
        tristate "Samsung S5P CEC driver"
-       depends on CEC_CORE && (PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST)
+       depends on PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST
+       select CEC_CORE
        select MEDIA_CEC_NOTIFIER
        ---help---
          This is a driver for Samsung S5P HDMI CEC interface. It uses the
@@ -511,7 +512,8 @@ config VIDEO_SAMSUNG_S5P_CEC
 
 config VIDEO_STI_HDMI_CEC
        tristate "STMicroelectronics STiH4xx HDMI CEC driver"
-       depends on CEC_CORE && (ARCH_STI || COMPILE_TEST)
+       depends on ARCH_STI || COMPILE_TEST
+       select CEC_CORE
        select MEDIA_CEC_NOTIFIER
        ---help---
          This is a driver for STIH4xx HDMI CEC interface. It uses the
diff --git a/drivers/media/platform/vivid/Kconfig b/drivers/media/platform/vivid/Kconfig
index b36ac19dc6e4..154de92dd809 100644
--- a/drivers/media/platform/vivid/Kconfig
+++ b/drivers/media/platform/vivid/Kconfig
@@ -26,7 +26,8 @@ config VIDEO_VIVID
 
 config VIDEO_VIVID_CEC
 	bool "Enable CEC emulation support"
-	depends on VIDEO_VIVID && CEC_CORE
+	depends on VIDEO_VIVID
+	select CEC_CORE
 	---help---
 	  When selected the vivid module will emulate the optional
 	  HDMI CEC feature.
diff --git a/drivers/media/usb/pulse8-cec/Kconfig b/drivers/media/usb/pulse8-cec/Kconfig
index 8937f3986a01..18ead44824ba 100644
--- a/drivers/media/usb/pulse8-cec/Kconfig
+++ b/drivers/media/usb/pulse8-cec/Kconfig
@@ -1,6 +1,7 @@
 config USB_PULSE8_CEC
 	tristate "Pulse Eight HDMI CEC"
-	depends on USB_ACM && CEC_CORE
+	depends on USB_ACM
+	select CEC_CORE
 	select SERIO
 	select SERIO_SERPORT
 	---help---
diff --git a/drivers/media/usb/rainshadow-cec/Kconfig b/drivers/media/usb/rainshadow-cec/Kconfig
index 3eb86607efb8..030ef01b1ff0 100644
--- a/drivers/media/usb/rainshadow-cec/Kconfig
+++ b/drivers/media/usb/rainshadow-cec/Kconfig
@@ -1,6 +1,7 @@
 config USB_RAINSHADOW_CEC
 	tristate "RainShadow Tech HDMI CEC"
-	depends on USB_ACM && CEC_CORE
+	depends on USB_ACM
+	select CEC_CORE
 	select SERIO
 	select SERIO_SERPORT
 	---help---
-- 
2.11.0
