Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:53939 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab3LMPO5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 10:14:57 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 05/11] media: rc: img-ir: add to build
Date: Fri, 13 Dec 2013 15:12:53 +0000
Message-ID: <1386947579-26703-6-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1386947579-26703-1-git-send-email-james.hogan@imgtec.com>
References: <1386947579-26703-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add ImgTec IR decoder driver to the build system.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/rc/Kconfig         |  2 ++
 drivers/media/rc/Makefile        |  1 +
 drivers/media/rc/img-ir/Kconfig  | 26 ++++++++++++++++++++++++++
 drivers/media/rc/img-ir/Makefile |  6 ++++++
 4 files changed, 35 insertions(+)
 create mode 100644 drivers/media/rc/img-ir/Kconfig
 create mode 100644 drivers/media/rc/img-ir/Makefile

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 904f11367c29..43b71813862e 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -300,6 +300,8 @@ config IR_RX51
 	   The driver uses omap DM timers for generating the carrier
 	   wave and pulses.
 
+source "drivers/media/rc/img-ir/Kconfig"
+
 config RC_LOOPBACK
 	tristate "Remote Control Loopback Driver"
 	depends on RC_CORE
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index f4eb32c0a455..cbe3d44f7fab 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -31,3 +31,4 @@ obj-$(CONFIG_IR_GPIO_CIR) += gpio-ir-recv.o
 obj-$(CONFIG_IR_IGUANA) += iguanair.o
 obj-$(CONFIG_IR_TTUSBIR) += ttusbir.o
 obj-$(CONFIG_RC_ST) += st_rc.o
+obj-$(CONFIG_IR_IMG) += img-ir/
diff --git a/drivers/media/rc/img-ir/Kconfig b/drivers/media/rc/img-ir/Kconfig
new file mode 100644
index 000000000000..60eaba6a0843
--- /dev/null
+++ b/drivers/media/rc/img-ir/Kconfig
@@ -0,0 +1,26 @@
+config IR_IMG
+	tristate "ImgTec IR Decoder"
+	depends on RC_CORE
+	select IR_IMG_HW if !IR_IMG_RAW
+	help
+	   Say Y or M here if you want to use the ImgTec infrared decoder
+	   functionality found in SoCs such as TZ1090.
+
+config IR_IMG_RAW
+	bool "Raw decoder"
+	depends on IR_IMG
+	help
+	   Say Y here to enable the raw mode driver which passes raw IR signal
+	   changes to the IR raw decoders for software decoding. This is much
+	   less reliable (due to lack of timestamps) and consumes more
+	   processing power than using hardware decode, but can be useful for
+	   testing, debug, and to make more protocols available.
+
+config IR_IMG_HW
+	bool "Hardware decoder"
+	depends on IR_IMG
+	help
+	   Say Y here to enable the hardware decode driver which decodes the IR
+	   signals in hardware. This is more reliable, consumes less processing
+	   power since only a single interrupt is received for each scancode,
+	   and allows an IR scancode to be used as a wake event.
diff --git a/drivers/media/rc/img-ir/Makefile b/drivers/media/rc/img-ir/Makefile
new file mode 100644
index 000000000000..4ef86edec873
--- /dev/null
+++ b/drivers/media/rc/img-ir/Makefile
@@ -0,0 +1,6 @@
+img-ir-y			:= img-ir-core.o
+img-ir-$(CONFIG_IR_IMG_RAW)	+= img-ir-raw.o
+img-ir-$(CONFIG_IR_IMG_HW)	+= img-ir-hw.o
+img-ir-objs			:= $(img-ir-y)
+
+obj-$(CONFIG_IR_IMG)		+= img-ir.o
-- 
1.8.1.2


