Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:33601 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755064AbdJJHRu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 03:17:50 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Andy Walls <awalls.cx18@gmail.com>
Subject: [PATCH v3 07/26] media: promote lirc_zilog out of staging
Date: Tue, 10 Oct 2017 08:17:48 +0100
Message-Id: <f6bf0820d0ea6048961eda0e6b1f89f01b7686fc.1507618840.git.sean@mess.org>
In-Reply-To: <cover.1507618840.git.sean@mess.org>
References: <cover.1507618840.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename to zilog_ir in the process.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/Kconfig                           | 12 ++++++++
 drivers/media/rc/Makefile                          |  1 +
 .../lirc/lirc_zilog.c => media/rc/zilog_ir.c}      |  0
 drivers/staging/media/Kconfig                      |  3 --
 drivers/staging/media/Makefile                     |  1 -
 drivers/staging/media/lirc/Kconfig                 | 21 -------------
 drivers/staging/media/lirc/Makefile                |  6 ----
 drivers/staging/media/lirc/TODO                    | 36 ----------------------
 8 files changed, 13 insertions(+), 67 deletions(-)
 rename drivers/{staging/media/lirc/lirc_zilog.c => media/rc/zilog_ir.c} (100%)
 delete mode 100644 drivers/staging/media/lirc/Kconfig
 delete mode 100644 drivers/staging/media/lirc/Makefile
 delete mode 100644 drivers/staging/media/lirc/TODO

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index afb3456d4e20..2a47139e5811 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -483,6 +483,18 @@ config IR_TANGO
 	   The HW decoder supports NEC, RC-5, RC-6 IR protocols.
 	   When compiled as a module, look for tango-ir.
 
+config IR_ZILOG
+	tristate "Zilog/Hauppauge IR Transmitter"
+	depends on RC_CORE
+	depends on LIRC
+	depends on I2C
+	---help---
+	   Driver for the Zilog/Hauppauge IR Transmitter, found on
+	   PVR-150/500, HVR-1200/1250/1700/1800, HD-PVR and other cards
+
+	   To compile this driver as a module, choose M here: the
+	   module will be called zilog_ir.
+
 config IR_ZX
 	tristate "ZTE ZX IR remote control"
 	depends on RC_CORE
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index 643797dc971b..a6bf6827b1ed 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -43,5 +43,6 @@ obj-$(CONFIG_IR_IMG) += img-ir/
 obj-$(CONFIG_IR_SERIAL) += serial_ir.o
 obj-$(CONFIG_IR_SIR) += sir_ir.o
 obj-$(CONFIG_IR_MTK) += mtk-cir.o
+obj-$(CONFIG_IR_ZILOG) += zilog_ir.o
 obj-$(CONFIG_IR_ZX) += zx-irdec.o
 obj-$(CONFIG_IR_TANGO) += tango-ir.o
diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/media/rc/zilog_ir.c
similarity index 100%
rename from drivers/staging/media/lirc/lirc_zilog.c
rename to drivers/media/rc/zilog_ir.c
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index f8c25ee082ef..3a09140700e6 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -31,7 +31,4 @@ source "drivers/staging/media/imx/Kconfig"
 
 source "drivers/staging/media/omap4iss/Kconfig"
 
-# Keep LIRC at the end, as it has sub-menus
-source "drivers/staging/media/lirc/Kconfig"
-
 endif
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index ac090c5fce30..9c057126d61f 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -1,7 +1,6 @@
 obj-$(CONFIG_I2C_BCM2048)	+= bcm2048/
 obj-$(CONFIG_DVB_CXD2099)	+= cxd2099/
 obj-$(CONFIG_VIDEO_IMX_MEDIA)	+= imx/
-obj-$(CONFIG_LIRC_STAGING)	+= lirc/
 obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
 obj-$(CONFIG_INTEL_ATOMISP)     += atomisp/
diff --git a/drivers/staging/media/lirc/Kconfig b/drivers/staging/media/lirc/Kconfig
deleted file mode 100644
index 3e350a9922de..000000000000
--- a/drivers/staging/media/lirc/Kconfig
+++ /dev/null
@@ -1,21 +0,0 @@
-#
-# LIRC driver(s) configuration
-#
-menuconfig LIRC_STAGING
-	bool "Linux Infrared Remote Control IR receiver/transmitter drivers"
-	depends on LIRC
-	help
-	  Say Y here, and all supported Linux Infrared Remote Control IR and
-	  RF receiver and transmitter drivers will be displayed. When paired
-	  with a remote control and the lirc daemon, the receiver drivers
-	  allow control of your Linux system via remote control.
-
-if LIRC_STAGING
-
-config LIRC_ZILOG
-	tristate "Zilog/Hauppauge IR Transmitter"
-	depends on LIRC && I2C
-	help
-	  Driver for the Zilog/Hauppauge IR Transmitter, found on
-	  PVR-150/500, HVR-1200/1250/1700/1800, HD-PVR and other cards
-endif
diff --git a/drivers/staging/media/lirc/Makefile b/drivers/staging/media/lirc/Makefile
deleted file mode 100644
index 665562436e30..000000000000
--- a/drivers/staging/media/lirc/Makefile
+++ /dev/null
@@ -1,6 +0,0 @@
-# Makefile for the lirc drivers.
-#
-
-# Each configuration option enables a list of files.
-
-obj-$(CONFIG_LIRC_ZILOG)	+= lirc_zilog.o
diff --git a/drivers/staging/media/lirc/TODO b/drivers/staging/media/lirc/TODO
deleted file mode 100644
index a97800a8e127..000000000000
--- a/drivers/staging/media/lirc/TODO
+++ /dev/null
@@ -1,36 +0,0 @@
-1. Both ir-kbd-i2c and lirc_zilog provide support for RX events for
-the chips supported by lirc_zilog.  Before moving lirc_zilog out of staging:
-
-a. ir-kbd-i2c needs a module parameter added to allow the user to tell
-   ir-kbd-i2c to ignore Z8 IR units.
-
-b. lirc_zilog should provide Rx key presses to the rc core like ir-kbd-i2c
-   does.
-
-
-2. lirc_zilog module ref-counting need examination.  It has not been
-verified that cdev and lirc_dev will take the proper module references on
-lirc_zilog to prevent removal of lirc_zilog when the /dev/lircN device node
-is open.
-
-(The good news is ref-counting of lirc_zilog internal structures appears to be
-complete.  Testing has shown the cx18 module can be unloaded out from under
-irw + lircd + lirc_dev, with the /dev/lirc0 device node open, with no adverse
-effects.  The cx18 module could then be reloaded and irw properly began
-receiving button presses again and ir_send worked without error.)
-
-
-3. Bridge drivers, if able, should provide a chip reset() callback
-to lirc_zilog via struct IR_i2c_init_data.  cx18 and ivtv already have routines
-to perform Z8 chip resets via GPIO manipulations.  This would allow lirc_zilog
-to bring the chip back to normal when it hangs, in the same places the
-original lirc_pvr150 driver code does.  This is not strictly needed, so it
-is not required to move lirc_zilog out of staging.
-
-Note: Both lirc_zilog and ir-kbd-i2c support the Zilog Z8 for IR, as programmed
-and installed on Hauppauge products.  When working on either module, developers
-must consider at least the following bridge drivers which mention an IR Rx unit
-at address 0x71 (indicative of a Z8):
-
-	ivtv cx18 hdpvr pvrusb2 bt8xx cx88 saa7134
-
-- 
2.13.6
