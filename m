Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59116 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaHPAPy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Aug 2014 20:15:54 -0400
Message-ID: <53EEA2B9.7090502@infradead.org>
Date: Fri, 15 Aug 2014 17:15:53 -0700
From: Randy Dunlap <rdunlap@infradead.org>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Fengguang Wu <fengguang.wu@intel.com>,
	Jim Davis <jim.epost@gmail.com>,
	Holger Waechtler <holger@convergence.de>,
	Oliver Endriss <o.endriss@gmx.de>
Subject: [PATCH v2] media: ttpci: fix av7110 build to be compatible with CONFIG_INPUT_EVDEV
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <rdunlap@infradead.org>

Fix build when CONFIG_INPUT_EVDEV=m and DVB_AV7110=y.
Only build av7110_ir.c when CONFIG_INPUT_EVDEV is compatible with
CONFIG_DVB_AV7110.

Fixes these build errors:

drivers/built-in.o: In function `input_sync':
av7110_ir.c:(.text+0x1223ac): undefined reference to `input_event'
drivers/built-in.o: In function `av7110_emit_key':
av7110_ir.c:(.text+0x12247c): undefined reference to `input_event'
av7110_ir.c:(.text+0x122495): undefined reference to `input_event'
av7110_ir.c:(.text+0x122569): undefined reference to `input_event'
av7110_ir.c:(.text+0x1225a7): undefined reference to `input_event'
drivers/built-in.o:av7110_ir.c:(.text+0x122629): more undefined
references to `input_event' follow
drivers/built-in.o: In function `av7110_ir_init':
(.text+0x1227e4): undefined reference to `input_allocate_device'
drivers/built-in.o: In function `av7110_ir_init':
(.text+0x12298f): undefined reference to `input_register_device'
drivers/built-in.o: In function `av7110_ir_init':
(.text+0x12299e): undefined reference to `input_free_device'
drivers/built-in.o: In function `av7110_ir_exit':
(.text+0x122a94): undefined reference to `input_unregister_device'

drivers/built-in.o: In function `av7110_detach':
av7110.c:(.text+0x228d4a): undefined reference to `av7110_ir_exit'
drivers/built-in.o: In function `arm_thread':
av7110.c:(.text+0x22a404): undefined reference to `av7110_check_ir_config'
av7110.c:(.text+0x22a626): undefined reference to `av7110_check_ir_config'
drivers/built-in.o: In function `av7110_attach':
av7110.c:(.text+0x22b08c): undefined reference to `av7110_ir_init'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Jim Davis <jim.epost@gmail.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Holger Waechtler <holger@convergence.de>
Cc: Oliver Endriss <o.endriss@gmx.de>
---
 drivers/media/pci/ttpci/Kconfig  |    4 ++++
 drivers/media/pci/ttpci/Makefile |    2 +-
 drivers/media/pci/ttpci/av7110.c |    8 ++++----
 3 files changed, 9 insertions(+), 5 deletions(-)

Mauro: please drop the v1 patch, which is commit ID
277c0ffaea64c71c39f03b9ee6818de600c38fc3 in your tree and
http://patchwork.linuxtv.org/patch/25342/ in patchwork.


Index: lnx-316/drivers/media/pci/ttpci/Kconfig
===================================================================
--- lnx-316.orig/drivers/media/pci/ttpci/Kconfig
+++ lnx-316/drivers/media/pci/ttpci/Kconfig
@@ -1,8 +1,12 @@
+config DVB_AV7110_IR
+	bool
+
 config DVB_AV7110
 	tristate "AV7110 cards"
 	depends on DVB_CORE && PCI && I2C
 	select TTPCI_EEPROM
 	select VIDEO_SAA7146_VV
+	select DVB_AV7110_IR if INPUT_EVDEV=y || INPUT_EVDEV=DVB_AV7110
 	depends on VIDEO_DEV	# dependencies of VIDEO_SAA7146_VV
 	select DVB_VES1820 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_VES1X93 if MEDIA_SUBDRV_AUTOSELECT
Index: lnx-316/drivers/media/pci/ttpci/Makefile
===================================================================
--- lnx-316.orig/drivers/media/pci/ttpci/Makefile
+++ lnx-316/drivers/media/pci/ttpci/Makefile
@@ -5,7 +5,7 @@
 
 dvb-ttpci-objs := av7110_hw.o av7110_v4l.o av7110_av.o av7110_ca.o av7110.o av7110_ipack.o
 
-ifdef CONFIG_INPUT_EVDEV
+ifdef CONFIG_DVB_AV7110_IR
 dvb-ttpci-objs += av7110_ir.o
 endif
 
Index: lnx-316/drivers/media/pci/ttpci/av7110.c
===================================================================
--- lnx-316.orig/drivers/media/pci/ttpci/av7110.c
+++ lnx-316/drivers/media/pci/ttpci/av7110.c
@@ -235,7 +235,7 @@ static void recover_arm(struct av7110 *a
 
 	restart_feeds(av7110);
 
-#if IS_ENABLED(CONFIG_INPUT_EVDEV)
+#if IS_ENABLED(CONFIG_DVB_AV7110_IR)
 	av7110_check_ir_config(av7110, true);
 #endif
 }
@@ -268,7 +268,7 @@ static int arm_thread(void *data)
 		if (!av7110->arm_ready)
 			continue;
 
-#if IS_ENABLED(CONFIG_INPUT_EVDEV)
+#if IS_ENABLED(CONFIG_DVB_AV7110_IR)
 		av7110_check_ir_config(av7110, false);
 #endif
 
@@ -2725,7 +2725,7 @@ static int av7110_attach(struct saa7146_
 
 	mutex_init(&av7110->ioctl_mutex);
 
-#if IS_ENABLED(CONFIG_INPUT_EVDEV)
+#if IS_ENABLED(CONFIG_DVB_AV7110_IR)
 	av7110_ir_init(av7110);
 #endif
 	printk(KERN_INFO "dvb-ttpci: found av7110-%d.\n", av7110_num);
@@ -2768,7 +2768,7 @@ static int av7110_detach(struct saa7146_
 	struct av7110 *av7110 = saa->ext_priv;
 	dprintk(4, "%p\n", av7110);
 
-#if IS_ENABLED(CONFIG_INPUT_EVDEV)
+#if IS_ENABLED(CONFIG_DVB_AV7110_IR)
 	av7110_ir_exit(av7110);
 #endif
 	if (budgetpatch || av7110->full_ts) {
