Return-path: <linux-media-owner@vger.kernel.org>
Received: from anholt.net ([50.246.234.109]:52084 "EHLO anholt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751870AbdA0Vzy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jan 2017 16:55:54 -0500
From: Eric Anholt <eric@anholt.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Anholt <eric@anholt.net>
Subject: [PATCH 3/6] staging: bcm2835-v4l2: Add a build system for the module.
Date: Fri, 27 Jan 2017 13:55:00 -0800
Message-Id: <20170127215503.13208-4-eric@anholt.net>
In-Reply-To: <20170127215503.13208-1-eric@anholt.net>
References: <20170127215503.13208-1-eric@anholt.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is derived from the downstream tree's build system, but with just
a single Kconfig option.

For now the driver only builds on 32-bit arm -- the aarch64 build
breaks due to the driver using arm-specific cache flushing functions.

Signed-off-by: Eric Anholt <eric@anholt.net>
---
 drivers/staging/media/Kconfig                   |  2 ++
 drivers/staging/media/Makefile                  |  1 +
 drivers/staging/media/platform/bcm2835/Kconfig  | 10 ++++++++++
 drivers/staging/media/platform/bcm2835/Makefile | 11 +++++++++++
 4 files changed, 24 insertions(+)
 create mode 100644 drivers/staging/media/platform/bcm2835/Kconfig
 create mode 100644 drivers/staging/media/platform/bcm2835/Makefile

diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index ffb8fa72c3da..abd0e2d57c20 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -27,6 +27,8 @@ source "drivers/staging/media/davinci_vpfe/Kconfig"
 
 source "drivers/staging/media/omap4iss/Kconfig"
 
+source "drivers/staging/media/platform/bcm2835/Kconfig"
+
 source "drivers/staging/media/s5p-cec/Kconfig"
 
 # Keep LIRC at the end, as it has sub-menus
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index a28e82cf6447..dc89325c463d 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -2,6 +2,7 @@ obj-$(CONFIG_I2C_BCM2048)	+= bcm2048/
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_CEC) += s5p-cec/
 obj-$(CONFIG_DVB_CXD2099)	+= cxd2099/
 obj-$(CONFIG_LIRC_STAGING)	+= lirc/
+obj-$(CONFIG_VIDEO_BCM2835)	+= platform/bcm2835/
 obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
 obj-$(CONFIG_VIDEO_STI_HDMI_CEC) += st-cec/
diff --git a/drivers/staging/media/platform/bcm2835/Kconfig b/drivers/staging/media/platform/bcm2835/Kconfig
new file mode 100644
index 000000000000..7c5245dc3225
--- /dev/null
+++ b/drivers/staging/media/platform/bcm2835/Kconfig
@@ -0,0 +1,10 @@
+config VIDEO_BCM2835
+	tristate "Broadcom BCM2835 camera driver"
+	depends on VIDEO_V4L2 && (ARCH_BCM2835 || COMPILE_TEST)
+	depends on BCM2835_VCHIQ
+	depends on ARM
+	select VIDEOBUF2_VMALLOC
+	help
+	  Say Y here to enable camera host interface devices for
+	  Broadcom BCM2835 SoC. This operates over the VCHIQ interface
+	  to a service running on VideoCore.
diff --git a/drivers/staging/media/platform/bcm2835/Makefile b/drivers/staging/media/platform/bcm2835/Makefile
new file mode 100644
index 000000000000..d7900a5951a8
--- /dev/null
+++ b/drivers/staging/media/platform/bcm2835/Makefile
@@ -0,0 +1,11 @@
+bcm2835-v4l2-$(CONFIG_VIDEO_BCM2835) := \
+	bcm2835-camera.o \
+	controls.o \
+	mmal-vchiq.o
+
+obj-$(CONFIG_VIDEO_BCM2835) += bcm2835-v4l2.o
+
+ccflags-y += \
+	-Idrivers/staging/vc04_services \
+	-Idrivers/staging/vc04_services/interface/vcos/linuxkernel \
+	-D__VCCOREVER__=0x04000000
-- 
2.11.0

