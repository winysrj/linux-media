Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:46305 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751054AbdCYMC7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Mar 2017 08:02:59 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 7/8] [media] rc: promote lirc_sir out of staging
Date: Sat, 25 Mar 2017 12:02:25 +0000
Message-Id: <bfac2cfec97b87fe57b95e0f7b4b6ea68f2c5b58.1490443026.git.sean@mess.org>
In-Reply-To: <cover.1490443026.git.sean@mess.org>
References: <cover.1490443026.git.sean@mess.org>
In-Reply-To: <cover.1490443026.git.sean@mess.org>
References: <cover.1490443026.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename lirc_sir to sir_ir in the process.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/Kconfig                                     | 9 +++++++++
 drivers/media/rc/Makefile                                    | 1 +
 drivers/{staging/media/lirc/lirc_sir.c => media/rc/sir_ir.c} | 0
 drivers/staging/media/lirc/Kconfig                           | 6 ------
 drivers/staging/media/lirc/Makefile                          | 1 -
 5 files changed, 10 insertions(+), 7 deletions(-)
 rename drivers/{staging/media/lirc/lirc_sir.c => media/rc/sir_ir.c} (100%)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index d1d3fd0..f12840f 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -419,6 +419,15 @@ config IR_SERIAL
 	   To compile this driver as a module, choose M here: the module will
 	   be called serial-ir.
 
+config IR_SIR
+        tristate "Built-in SIR IrDA port"
+        depends on RC_CORE
+        ---help---
+	   Say Y if you want to use a IrDA SIR port Transceivers.
+
+	   To compile this driver as a module, choose M here: the module will
+	   be called sir-ir.
+
 config IR_SERIAL_TRANSMITTER
 	bool "Serial Port Transmitter"
 	default y
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index 679aa0a..245e2c2 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -39,4 +39,5 @@ obj-$(CONFIG_RC_ST) += st_rc.o
 obj-$(CONFIG_IR_SUNXI) += sunxi-cir.o
 obj-$(CONFIG_IR_IMG) += img-ir/
 obj-$(CONFIG_IR_SERIAL) += serial_ir.o
+obj-$(CONFIG_IR_SIR) += sir_ir.o
 obj-$(CONFIG_IR_MTK) += mtk-cir.o
diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/media/rc/sir_ir.c
similarity index 100%
rename from drivers/staging/media/lirc/lirc_sir.c
rename to drivers/media/rc/sir_ir.c
diff --git a/drivers/staging/media/lirc/Kconfig b/drivers/staging/media/lirc/Kconfig
index bc67da2..e020651 100644
--- a/drivers/staging/media/lirc/Kconfig
+++ b/drivers/staging/media/lirc/Kconfig
@@ -18,12 +18,6 @@ config LIRC_SASEM
 	help
 	  Driver for the Sasem OnAir Remocon-V or Dign HV5 HTPC IR/VFD Module
 
-config LIRC_SIR
-	tristate "Built-in SIR IrDA port"
-	depends on RC_CORE
-	help
-	  Driver for the SIR IrDA port
-
 config LIRC_ZILOG
 	tristate "Zilog/Hauppauge IR Transmitter"
 	depends on LIRC && I2C
diff --git a/drivers/staging/media/lirc/Makefile b/drivers/staging/media/lirc/Makefile
index 28740c9..70f2237 100644
--- a/drivers/staging/media/lirc/Makefile
+++ b/drivers/staging/media/lirc/Makefile
@@ -4,5 +4,4 @@
 # Each configuration option enables a list of files.
 
 obj-$(CONFIG_LIRC_SASEM)	+= lirc_sasem.o
-obj-$(CONFIG_LIRC_SIR)		+= lirc_sir.o
 obj-$(CONFIG_LIRC_ZILOG)	+= lirc_zilog.o
-- 
2.9.3
