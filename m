Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44275 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933296Ab2EWJyz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:55 -0400
Subject: [PATCH 32/43] rc-core: split IR raw handling to a separate module
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:44:48 +0200
Message-ID: <20120523094448.14474.88355.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move drivers/media/rc/ir-raw.c to drivers/media/rc/rc-ir-raw.c and make it
a separate kernel module (rc-ir-raw.ko to make it clearer that it belongs to
the rc-* family).

Drivers which use IR decoding must use these functions:
	rc_register_ir_raw_device()
	rc_unregister_ir_raw_device()
instead of:
	rc_register_device()
	rc_unregister_device()

This allows scancode drivers to skip lots of unnecessary functionality.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/dvb/dvb-usb/Kconfig           |    2 
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c  |    7 
 drivers/media/dvb/dvb-usb/dvb-usb.h         |    2 
 drivers/media/dvb/siano/Kconfig             |    2 
 drivers/media/dvb/siano/smsir.c             |    4 
 drivers/media/dvb/siano/smsir.h             |    2 
 drivers/media/rc/Kconfig                    |   54 +++-
 drivers/media/rc/Makefile                   |    3 
 drivers/media/rc/ene_ir.c                   |    6 
 drivers/media/rc/fintek-cir.c               |    6 
 drivers/media/rc/gpio-ir-recv.c             |    8 -
 drivers/media/rc/ir-raw.c                   |  372 ---------------------------
 drivers/media/rc/ite-cir.c                  |    6 
 drivers/media/rc/mceusb.c                   |    6 
 drivers/media/rc/nuvoton-cir.c              |    6 
 drivers/media/rc/rc-core-priv.h             |    3 
 drivers/media/rc/rc-ir-raw.c                |  379 +++++++++++++++++++++++++++
 drivers/media/rc/rc-loopback.c              |    6 
 drivers/media/rc/rc-main.c                  |   39 +--
 drivers/media/rc/redrat3.c                  |    6 
 drivers/media/rc/streamzap.c                |    6 
 drivers/media/rc/winbond-cir.c              |    6 
 drivers/media/video/cx23885/Kconfig         |    2 
 drivers/media/video/cx23885/cx23885-input.c |    6 
 drivers/media/video/cx23885/cx23888-ir.c    |    2 
 drivers/media/video/cx25840/cx25840-ir.c    |    2 
 drivers/media/video/cx88/Kconfig            |    2 
 drivers/media/video/cx88/cx88-input.c       |    6 
 drivers/media/video/saa7134/Kconfig         |    2 
 drivers/media/video/saa7134/saa7134-input.c |    4 
 drivers/media/video/saa7134/saa7134.h       |    2 
 include/media/rc-core.h                     |   49 ---
 include/media/rc-ir-raw.h                   |   68 +++++
 33 files changed, 557 insertions(+), 519 deletions(-)
 delete mode 100644 drivers/media/rc/ir-raw.c
 create mode 100644 drivers/media/rc/rc-ir-raw.c
 create mode 100644 include/media/rc-ir-raw.h

diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index a269493..e9c94f2 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -1,6 +1,6 @@
 config DVB_USB
 	tristate "Support for various USB DVB devices"
-	depends on DVB_CORE && USB && I2C && RC_CORE
+	depends on DVB_CORE && USB && I2C && RC_CORE && RC_IR_RAW
 	help
 	  By enabling this you will be able to choose the various supported
 	  USB1.1 and USB2.0 DVB devices.
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
index 909e95c..6f138c3 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
@@ -280,7 +280,10 @@ static int rc_core_dvb_usb_remote_init(struct dvb_usb_device *d)
 	dev->dev.parent = &d->udev->dev;
 	dev->priv = d;
 
-	err = rc_register_device(dev);
+	if (dev->driver_type == RC_DRIVER_IR_RAW)
+		err = rc_register_ir_raw_device(dev);
+	else
+		err = rc_register_device(dev);
 	if (err < 0) {
 		rc_free_device(dev);
 		return err;
@@ -341,6 +344,8 @@ int dvb_usb_remote_exit(struct dvb_usb_device *d)
 		cancel_delayed_work_sync(&d->rc_query_work);
 		if (d->props.rc.mode == DVB_RC_LEGACY)
 			input_unregister_device(d->input_dev);
+		else if (d->rc_dev->driver_type == RC_DRIVER_IR_RAW)
+			rc_unregister_ir_raw_device(d->rc_dev);
 		else
 			rc_unregister_device(d->rc_dev);
 	}
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb.h b/drivers/media/dvb/dvb-usb/dvb-usb.h
index ed886ae..1ce0bb8 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb.h
@@ -14,7 +14,7 @@
 #include <linux/usb.h>
 #include <linux/firmware.h>
 #include <linux/mutex.h>
-#include <media/rc-core.h>
+#include <media/rc-ir-raw.h>
 
 #include "dvb_frontend.h"
 #include "dvb_demux.h"
diff --git a/drivers/media/dvb/siano/Kconfig b/drivers/media/dvb/siano/Kconfig
index bc6456e..fa2923f 100644
--- a/drivers/media/dvb/siano/Kconfig
+++ b/drivers/media/dvb/siano/Kconfig
@@ -4,7 +4,7 @@
 
 config SMS_SIANO_MDTV
 	tristate "Siano SMS1xxx based MDTV receiver"
-	depends on DVB_CORE && RC_CORE && HAS_DMA
+	depends on DVB_CORE && RC_CORE && RC_IR_RAW && HAS_DMA
 	---help---
 	  Choose Y or M here if you have MDTV receiver with a Siano chipset.
 
diff --git a/drivers/media/dvb/siano/smsir.c b/drivers/media/dvb/siano/smsir.c
index b8c5cad..c9a627d 100644
--- a/drivers/media/dvb/siano/smsir.c
+++ b/drivers/media/dvb/siano/smsir.c
@@ -94,7 +94,7 @@ int sms_ir_init(struct smscore_device_t *coredev)
 
 	sms_log("Input device (IR) %s is set for key events", dev->input_name);
 
-	err = rc_register_device(dev);
+	err = rc_register_ir_raw_device(dev);
 	if (err < 0) {
 		sms_err("Failed to register device");
 		rc_free_device(dev);
@@ -108,7 +108,7 @@ int sms_ir_init(struct smscore_device_t *coredev)
 void sms_ir_exit(struct smscore_device_t *coredev)
 {
 	if (coredev->ir.dev)
-		rc_unregister_device(coredev->ir.dev);
+		rc_unregister_ir_raw_device(coredev->ir.dev);
 
 	sms_log("");
 }
diff --git a/drivers/media/dvb/siano/smsir.h b/drivers/media/dvb/siano/smsir.h
index ae92b3a..b583ce9 100644
--- a/drivers/media/dvb/siano/smsir.h
+++ b/drivers/media/dvb/siano/smsir.h
@@ -28,7 +28,7 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #define __SMS_IR_H__
 
 #include <linux/input.h>
-#include <media/rc-core.h>
+#include <media/rc-ir-raw.h>
 
 #define IR_DEFAULT_TIMEOUT		100
 
diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 090872b..851d927 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -26,9 +26,25 @@ config LIRC
 
 source "drivers/media/rc/keymaps/Kconfig"
 
+menuconfig RC_IR_RAW
+	tristate "Remote Controller raw IR adapters"
+	depends on RC_CORE
+	default RC_CORE
+	---help---
+	  Enable support for raw InfraRed Remote Controllers.
+	  These devices measure the pulse/space timings of
+	  IR signals and rely on software decoding of the
+	  signal.
+
+	  Enable this option if you have a video capture board even
+	  if you don't need IR, as otherwise, you may not be able to
+	  compile the driver for your adapter.
+
+if RC_IR_RAW
+
 config IR_NEC_DECODER
 	tristate "Enable IR raw decoder for the NEC protocol"
-	depends on RC_CORE
+	depends on RC_CORE && RC_IR_RAW
 	select BITREVERSE
 	default y
 
@@ -38,7 +54,7 @@ config IR_NEC_DECODER
 
 config IR_RC5_DECODER
 	tristate "Enable IR raw decoder for the RC-5 protocol"
-	depends on RC_CORE
+	depends on RC_CORE && RC_IR_RAW
 	select BITREVERSE
 	default y
 
@@ -48,7 +64,7 @@ config IR_RC5_DECODER
 
 config IR_RC6_DECODER
 	tristate "Enable IR raw decoder for the RC6 protocol"
-	depends on RC_CORE
+	depends on RC_CORE && RC_IR_RAW
 	select BITREVERSE
 	default y
 
@@ -58,7 +74,7 @@ config IR_RC6_DECODER
 
 config IR_JVC_DECODER
 	tristate "Enable IR raw decoder for the JVC protocol"
-	depends on RC_CORE
+	depends on RC_CORE && RC_IR_RAW
 	select BITREVERSE
 	default y
 
@@ -68,7 +84,7 @@ config IR_JVC_DECODER
 
 config IR_SONY_DECODER
 	tristate "Enable IR raw decoder for the Sony protocol"
-	depends on RC_CORE
+	depends on RC_CORE && RC_IR_RAW
 	select BITREVERSE
 	default y
 
@@ -78,7 +94,7 @@ config IR_SONY_DECODER
 
 config IR_SANYO_DECODER
 	tristate "Enable IR raw decoder for the Sanyo protocol"
-	depends on RC_CORE
+	depends on RC_CORE && RC_IR_RAW
 	default y
 
 	---help---
@@ -88,7 +104,7 @@ config IR_SANYO_DECODER
 
 config IR_MCE_KBD_DECODER
 	tristate "Enable IR raw decoder for the MCE keyboard/mouse protocol"
-	depends on RC_CORE
+	depends on RC_CORE && RC_IR_RAW
 	select BITREVERSE
 	default y
 
@@ -99,7 +115,7 @@ config IR_MCE_KBD_DECODER
 
 config IR_LIRC_CODEC
 	tristate "Enable IR to LIRC bridge"
-	depends on RC_CORE
+	depends on RC_CORE && RC_IR_RAW
 	depends on LIRC
 	default y
 
@@ -107,6 +123,8 @@ config IR_LIRC_CODEC
 	   Enable this option to pass raw IR to and from userspace via
 	   the LIRC interface.
 
+endif #RC_IR_RAW
+
 config RC_ATI_REMOTE
 	tristate "ATI / X10 based USB RF remote controls"
 	depends on USB_ARCH_HAS_HCD
@@ -129,7 +147,7 @@ config RC_ATI_REMOTE
 config IR_ENE
 	tristate "ENE eHome Receiver/Transceiver (pnp id: ENE0100/ENE02xxx)"
 	depends on PNP
-	depends on RC_CORE
+	depends on RC_CORE && RC_IR_RAW
 	---help---
 	   Say Y here to enable support for integrated infrared receiver
 	   /transceiver made by ENE.
@@ -155,7 +173,7 @@ config IR_IMON
 config IR_MCEUSB
 	tristate "Windows Media Center Ed. eHome Infrared Transceiver"
 	depends on USB_ARCH_HAS_HCD
-	depends on RC_CORE
+	depends on RC_CORE && RC_IR_RAW
 	select USB
 	---help---
 	   Say Y here if you want to use a Windows Media Center Edition
@@ -167,7 +185,7 @@ config IR_MCEUSB
 config IR_ITE_CIR
 	tristate "ITE Tech Inc. IT8712/IT8512 Consumer Infrared Transceiver"
 	depends on PNP
-	depends on RC_CORE
+	depends on RC_CORE && RC_IR_RAW
 	---help---
 	   Say Y here to enable support for integrated infrared receivers
 	   /transceivers made by ITE Tech Inc. These are found in
@@ -180,7 +198,7 @@ config IR_ITE_CIR
 config IR_FINTEK
 	tristate "Fintek Consumer Infrared Transceiver"
 	depends on PNP
-	depends on RC_CORE
+	depends on RC_CORE && RC_IR_RAW
 	---help---
 	   Say Y here to enable support for integrated infrared receiver
 	   /transciever made by Fintek. This chip is found on assorted
@@ -192,7 +210,7 @@ config IR_FINTEK
 config IR_NUVOTON
 	tristate "Nuvoton w836x7hg Consumer Infrared Transceiver"
 	depends on PNP
-	depends on RC_CORE
+	depends on RC_CORE && RC_IR_RAW
 	---help---
 	   Say Y here to enable support for integrated infrared receiver
 	   /transciever made by Nuvoton (formerly Winbond). This chip is
@@ -205,7 +223,7 @@ config IR_NUVOTON
 config IR_REDRAT3
 	tristate "RedRat3 IR Transceiver"
 	depends on USB_ARCH_HAS_HCD
-	depends on RC_CORE
+	depends on RC_CORE && RC_IR_RAW
 	select USB
 	---help---
 	   Say Y here if you want to use a RedRat3 Infrared Transceiver.
@@ -216,7 +234,7 @@ config IR_REDRAT3
 config IR_STREAMZAP
 	tristate "Streamzap PC Remote IR Receiver"
 	depends on USB_ARCH_HAS_HCD
-	depends on RC_CORE
+	depends on RC_CORE && RC_IR_RAW
 	select USB
 	---help---
 	   Say Y here if you want to use a Streamzap PC Remote
@@ -228,7 +246,7 @@ config IR_STREAMZAP
 config IR_WINBOND_CIR
 	tristate "Winbond IR remote control"
 	depends on X86 && PNP
-	depends on RC_CORE
+	depends on RC_CORE && RC_IR_RAW
 	select NEW_LEDS
 	select LEDS_CLASS
 	select LEDS_TRIGGERS
@@ -244,7 +262,7 @@ config IR_WINBOND_CIR
 
 config RC_LOOPBACK
 	tristate "Remote Control Loopback Driver"
-	depends on RC_CORE
+	depends on RC_CORE && RC_IR_RAW
 	---help---
 	   Say Y here if you want support for the remote control loopback
 	   driver which allows TX data to be sent back as RX data.
@@ -257,7 +275,7 @@ config RC_LOOPBACK
 
 config IR_GPIO_CIR
 	tristate "GPIO IR remote control"
-	depends on RC_CORE
+	depends on RC_CORE && RC_IR_RAW
 	---help---
 	   Say Y if you want to use GPIO based IR Receiver.
 
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index f470a3f..22eda72 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -1,9 +1,10 @@
-rc-core-objs	:= rc-main.o rc-keytable.o ir-raw.o
+rc-core-objs	:= rc-main.o rc-keytable.o
 
 obj-y += keymaps/
 
 obj-$(CONFIG_RC_CORE) += rc-core.o
 obj-$(CONFIG_LIRC) += lirc_dev.o
+obj-$(CONFIG_RC_CORE) += rc-ir-raw.o
 obj-$(CONFIG_IR_NEC_DECODER) += ir-nec-decoder.o
 obj-$(CONFIG_IR_RC5_DECODER) += ir-rc5-decoder.o
 obj-$(CONFIG_IR_RC6_DECODER) += ir-rc6-decoder.o
diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index ec09646..eb107e8 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -39,7 +39,7 @@
 #include <linux/interrupt.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <media/rc-core.h>
+#include <media/rc-ir-raw.h>
 #include "ene_ir.h"
 
 static int sample_period;
@@ -1073,7 +1073,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 		goto error;
 	}
 
-	error = rc_register_device(rdev);
+	error = rc_register_ir_raw_device(rdev);
 	if (error < 0)
 		goto error;
 
@@ -1103,7 +1103,7 @@ static void ene_remove(struct pnp_dev *pnp_dev)
 
 	free_irq(dev->irq, dev);
 	release_region(dev->hw_io, ENE_IO_SIZE);
-	rc_unregister_device(dev->rdev);
+	rc_unregister_ir_raw_device(dev->rdev);
 	kfree(dev);
 }
 
diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index f684dd8..01e6ef8 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -30,7 +30,7 @@
 #include <linux/interrupt.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <media/rc-core.h>
+#include <media/rc-ir-raw.h>
 #include <linux/pci_ids.h>
 
 #include "fintek-cir.h"
@@ -558,7 +558,7 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
 			FINTEK_DRIVER_NAME, (void *)fintek))
 		goto failure2;
 
-	ret = rc_register_device(rdev);
+	ret = rc_register_ir_raw_device(rdev);
 	if (ret)
 		goto failure3;
 
@@ -598,7 +598,7 @@ static void __devexit fintek_remove(struct pnp_dev *pdev)
 	free_irq(fintek->cir_irq, fintek);
 	release_region(fintek->cir_addr, fintek->cir_port_len);
 
-	rc_unregister_device(fintek->rdev);
+	rc_unregister_ir_raw_device(fintek->rdev);
 
 	kfree(fintek);
 }
diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 3ee7455..23141b0 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -18,7 +18,7 @@
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/irq.h>
-#include <media/rc-core.h>
+#include <media/rc-ir-raw.h>
 #include <media/gpio-ir-recv.h>
 
 #define GPIO_IR_DRIVER_NAME	"gpio-rc-recv"
@@ -99,7 +99,7 @@ static int __devinit gpio_ir_recv_probe(struct platform_device *pdev)
 	if (rc < 0)
 		goto err_gpio_direction_input;
 
-	rc = rc_register_device(rcdev);
+	rc = rc_register_ir_raw_device(rcdev);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "failed to register rc device\n");
 		goto err_register_rc_device;
@@ -118,7 +118,7 @@ static int __devinit gpio_ir_recv_probe(struct platform_device *pdev)
 
 err_request_irq:
 	platform_set_drvdata(pdev, NULL);
-	rc_unregister_device(rcdev);
+	rc_unregister_ir_raw_device(rcdev);
 err_register_rc_device:
 err_gpio_direction_input:
 	gpio_free(pdata->gpio_nr);
@@ -136,7 +136,7 @@ static int __devexit gpio_ir_recv_remove(struct platform_device *pdev)
 
 	free_irq(gpio_to_irq(gpio_dev->gpio_nr), gpio_dev);
 	platform_set_drvdata(pdev, NULL);
-	rc_unregister_device(gpio_dev->rcdev);
+	rc_unregister_ir_raw_device(gpio_dev->rcdev);
 	gpio_free(gpio_dev->gpio_nr);
 	rc_free_device(gpio_dev->rcdev);
 	kfree(gpio_dev);
diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
deleted file mode 100644
index 6ef1510..0000000
--- a/drivers/media/rc/ir-raw.c
+++ /dev/null
@@ -1,372 +0,0 @@
-/* ir-raw.c - handle IR pulse/space events
- *
- * Copyright (C) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
- *
- * This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2 of the License.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- */
-
-#include <linux/export.h>
-#include <linux/kthread.h>
-#include <linux/mutex.h>
-#include <linux/kmod.h>
-#include <linux/sched.h>
-#include <linux/freezer.h>
-#include "rc-core-priv.h"
-
-/* Define the max number of pulse/space transitions to buffer */
-#define MAX_IR_EVENT_SIZE      512
-
-/* Used to keep track of IR raw clients, protected by ir_raw_handler_lock */
-static LIST_HEAD(ir_raw_client_list);
-
-/* Used to handle IR raw handler extensions */
-static DEFINE_MUTEX(ir_raw_handler_lock);
-static LIST_HEAD(ir_raw_handler_list);
-static u64 available_protocols;
-
-#ifdef MODULE
-/* Used to load the decoders */
-static struct work_struct wq_load;
-#endif
-
-static int ir_raw_event_thread(void *data)
-{
-	struct ir_raw_event ev;
-	struct ir_raw_handler *handler;
-	struct ir_raw_event_ctrl *raw = (struct ir_raw_event_ctrl *)data;
-	int retval;
-
-	while (!kthread_should_stop()) {
-
-		spin_lock_irq(&raw->lock);
-		retval = kfifo_len(&raw->kfifo);
-
-		if (retval < sizeof(ev)) {
-			set_current_state(TASK_INTERRUPTIBLE);
-
-			if (kthread_should_stop())
-				set_current_state(TASK_RUNNING);
-
-			spin_unlock_irq(&raw->lock);
-			schedule();
-			continue;
-		}
-
-		retval = kfifo_out(&raw->kfifo, &ev, sizeof(ev));
-		spin_unlock_irq(&raw->lock);
-
-		mutex_lock(&ir_raw_handler_lock);
-		list_for_each_entry(handler, &ir_raw_handler_list, list)
-			handler->decode(raw->dev, ev);
-		raw->prev_ev = ev;
-		mutex_unlock(&ir_raw_handler_lock);
-	}
-
-	return 0;
-}
-
-/**
- * ir_raw_event_store() - pass a pulse/space duration to the raw ir decoders
- * @dev:	the struct rc_dev device descriptor
- * @ev:		the struct ir_raw_event descriptor of the pulse/space
- *
- * This routine (which may be called from an interrupt context) stores a
- * pulse/space duration for the raw ir decoding state machines. Pulses are
- * signalled as positive values and spaces as negative values. A zero value
- * will reset the decoding state machines.
- */
-int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev)
-{
-	if (!dev->raw)
-		return -EINVAL;
-
-	IR_dprintk(2, "sample: (%05dus %s)\n",
-		   TO_US(ev->duration), TO_STR(ev->pulse));
-
-	if (kfifo_in(&dev->raw->kfifo, ev, sizeof(*ev)) != sizeof(*ev))
-		return -ENOMEM;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ir_raw_event_store);
-
-/**
- * ir_raw_event_store_edge() - notify raw ir decoders of the start of a pulse/space
- * @dev:	the struct rc_dev device descriptor
- * @type:	the type of the event that has occurred
- *
- * This routine (which may be called from an interrupt context) is used to
- * store the beginning of an ir pulse or space (or the start/end of ir
- * reception) for the raw ir decoding state machines. This is used by
- * hardware which does not provide durations directly but only interrupts
- * (or similar events) on state change.
- */
-int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type)
-{
-	ktime_t			now;
-	s64			delta; /* ns */
-	DEFINE_IR_RAW_EVENT(ev);
-	int			rc = 0;
-
-	if (!dev->raw)
-		return -EINVAL;
-
-	now = ktime_get();
-	delta = ktime_to_ns(ktime_sub(now, dev->raw->last_event));
-
-	/* Check for a long duration since last event or if we're
-	 * being called for the first time, note that delta can't
-	 * possibly be negative.
-	 */
-	if (delta > MS_TO_NS(500) || !dev->raw->last_type)
-		type |= IR_START_EVENT;
-	else
-		ev.duration = delta;
-
-	if (type & IR_START_EVENT)
-		ir_raw_event_reset(dev);
-	else if (dev->raw->last_type & IR_SPACE) {
-		ev.pulse = false;
-		rc = ir_raw_event_store(dev, &ev);
-	} else if (dev->raw->last_type & IR_PULSE) {
-		ev.pulse = true;
-		rc = ir_raw_event_store(dev, &ev);
-	} else
-		return 0;
-
-	dev->raw->last_event = now;
-	dev->raw->last_type = type;
-	return rc;
-}
-EXPORT_SYMBOL_GPL(ir_raw_event_store_edge);
-
-/**
- * ir_raw_event_store_with_filter() - pass next pulse/space to decoders with some processing
- * @dev:	the struct rc_dev device descriptor
- * @type:	the type of the event that has occurred
- *
- * This routine (which may be called from an interrupt context) works
- * in similar manner to ir_raw_event_store_edge.
- * This routine is intended for devices with limited internal buffer
- * It automerges samples of same type, and handles timeouts
- */
-int ir_raw_event_store_with_filter(struct rc_dev *dev, struct ir_raw_event *ev)
-{
-	if (!dev->raw)
-		return -EINVAL;
-
-	/* Ignore spaces in idle mode */
-	if (dev->idle && !ev->pulse)
-		return 0;
-	else if (dev->idle)
-		ir_raw_event_set_idle(dev, false);
-
-	if (!dev->raw->this_ev.duration)
-		dev->raw->this_ev = *ev;
-	else if (ev->pulse == dev->raw->this_ev.pulse)
-		dev->raw->this_ev.duration += ev->duration;
-	else {
-		ir_raw_event_store(dev, &dev->raw->this_ev);
-		dev->raw->this_ev = *ev;
-	}
-
-	/* Enter idle mode if nessesary */
-	if (!ev->pulse && dev->timeout &&
-	    dev->raw->this_ev.duration >= dev->timeout)
-		ir_raw_event_set_idle(dev, true);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ir_raw_event_store_with_filter);
-
-/**
- * ir_raw_event_set_idle() - provide hint to rc-core when the device is idle or not
- * @dev:	the struct rc_dev device descriptor
- * @idle:	whether the device is idle or not
- */
-void ir_raw_event_set_idle(struct rc_dev *dev, bool idle)
-{
-	if (!dev->raw)
-		return;
-
-	IR_dprintk(2, "%s idle mode\n", idle ? "enter" : "leave");
-
-	if (idle) {
-		dev->raw->this_ev.timeout = true;
-		ir_raw_event_store(dev, &dev->raw->this_ev);
-		init_ir_raw_event(&dev->raw->this_ev);
-	}
-
-	if (dev->s_idle)
-		dev->s_idle(dev, idle);
-
-	dev->idle = idle;
-}
-EXPORT_SYMBOL_GPL(ir_raw_event_set_idle);
-
-/**
- * ir_raw_event_handle() - schedules the decoding of stored ir data
- * @dev:	the struct rc_dev device descriptor
- *
- * This routine will tell rc-core to start decoding stored ir data.
- */
-void ir_raw_event_handle(struct rc_dev *dev)
-{
-	unsigned long flags;
-
-	if (!dev->raw)
-		return;
-
-	spin_lock_irqsave(&dev->raw->lock, flags);
-	wake_up_process(dev->raw->thread);
-	spin_unlock_irqrestore(&dev->raw->lock, flags);
-}
-EXPORT_SYMBOL_GPL(ir_raw_event_handle);
-
-/* used internally by the sysfs interface */
-u64
-ir_raw_get_allowed_protocols(void)
-{
-	u64 protocols;
-	mutex_lock(&ir_raw_handler_lock);
-	protocols = available_protocols;
-	mutex_unlock(&ir_raw_handler_lock);
-	return protocols;
-}
-
-/*
- * Used to (un)register raw event clients
- */
-int ir_raw_event_register(struct rc_dev *dev)
-{
-	int rc;
-	struct ir_raw_handler *handler;
-
-	if (!dev)
-		return -EINVAL;
-
-	dev->raw = kzalloc(sizeof(*dev->raw), GFP_KERNEL);
-	if (!dev->raw)
-		return -ENOMEM;
-
-	dev->raw->dev = dev;
-	dev->enabled_protocols = ~0;
-	rc = kfifo_alloc(&dev->raw->kfifo,
-			 sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE,
-			 GFP_KERNEL);
-	if (rc < 0)
-		goto out;
-
-	spin_lock_init(&dev->raw->lock);
-	dev->raw->thread = kthread_run(ir_raw_event_thread, dev->raw,
-				       "rc%u", dev->minor);
-
-	if (IS_ERR(dev->raw->thread)) {
-		rc = PTR_ERR(dev->raw->thread);
-		goto out;
-	}
-
-	mutex_lock(&ir_raw_handler_lock);
-	list_add_tail(&dev->raw->list, &ir_raw_client_list);
-	list_for_each_entry(handler, &ir_raw_handler_list, list)
-		if (handler->raw_register)
-			handler->raw_register(dev);
-	mutex_unlock(&ir_raw_handler_lock);
-
-	return 0;
-
-out:
-	kfree(dev->raw);
-	dev->raw = NULL;
-	return rc;
-}
-
-void ir_raw_event_unregister(struct rc_dev *dev)
-{
-	struct ir_raw_handler *handler;
-
-	if (!dev || !dev->raw)
-		return;
-
-	kthread_stop(dev->raw->thread);
-
-	mutex_lock(&ir_raw_handler_lock);
-	list_del(&dev->raw->list);
-	list_for_each_entry(handler, &ir_raw_handler_list, list)
-		if (handler->raw_unregister)
-			handler->raw_unregister(dev);
-	mutex_unlock(&ir_raw_handler_lock);
-
-	kfifo_free(&dev->raw->kfifo);
-	kfree(dev->raw);
-	dev->raw = NULL;
-}
-
-/*
- * Extension interface - used to register the IR decoders
- */
-
-int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler)
-{
-	struct ir_raw_event_ctrl *raw;
-
-	mutex_lock(&ir_raw_handler_lock);
-	list_add_tail(&ir_raw_handler->list, &ir_raw_handler_list);
-	if (ir_raw_handler->raw_register)
-		list_for_each_entry(raw, &ir_raw_client_list, list)
-			ir_raw_handler->raw_register(raw->dev);
-	available_protocols |= ir_raw_handler->protocols;
-	mutex_unlock(&ir_raw_handler_lock);
-
-	return 0;
-}
-EXPORT_SYMBOL(ir_raw_handler_register);
-
-void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
-{
-	struct ir_raw_event_ctrl *raw;
-
-	mutex_lock(&ir_raw_handler_lock);
-	list_del(&ir_raw_handler->list);
-	if (ir_raw_handler->raw_unregister)
-		list_for_each_entry(raw, &ir_raw_client_list, list)
-			ir_raw_handler->raw_unregister(raw->dev);
-	available_protocols &= ~ir_raw_handler->protocols;
-	mutex_unlock(&ir_raw_handler_lock);
-}
-EXPORT_SYMBOL(ir_raw_handler_unregister);
-
-#ifdef MODULE
-static void init_decoders(struct work_struct *work)
-{
-	/* Load the decoder modules */
-
-	load_nec_decode();
-	load_rc5_decode();
-	load_rc6_decode();
-	load_jvc_decode();
-	load_sony_decode();
-	load_sanyo_decode();
-	load_mce_kbd_decode();
-	load_lirc_codec();
-
-	/* If needed, we may later add some init code. In this case,
-	   it is needed to change the CONFIG_MODULE test at rc-core.h
-	 */
-}
-#endif
-
-void ir_raw_init(void)
-{
-#ifdef MODULE
-	INIT_WORK(&wq_load, init_decoders);
-	schedule_work(&wq_load);
-#endif
-}
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 5abb7c3..6721767 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -40,7 +40,7 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/bitops.h>
-#include <media/rc-core.h>
+#include <media/rc-ir-raw.h>
 #include <linux/pci_ids.h>
 
 #include "ite-cir.h"
@@ -1597,7 +1597,7 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 			ITE_DRIVER_NAME, (void *)itdev))
 		goto failure2;
 
-	ret = rc_register_device(rdev);
+	ret = rc_register_ir_raw_device(rdev);
 	if (ret)
 		goto failure3;
 
@@ -1635,7 +1635,7 @@ static void __devexit ite_remove(struct pnp_dev *pdev)
 	free_irq(dev->cir_irq, dev);
 	release_region(dev->cir_addr, dev->params.io_region_size);
 
-	rc_unregister_device(dev->rdev);
+	rc_unregister_ir_raw_device(dev->rdev);
 
 	kfree(dev);
 }
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index c60ac4e..e9dda87 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -43,7 +43,7 @@
 #include <linux/usb.h>
 #include <linux/usb/input.h>
 #include <linux/pm_wakeup.h>
-#include <media/rc-core.h>
+#include <media/rc-ir-raw.h>
 
 #define DRIVER_VERSION	"1.92"
 #define DRIVER_AUTHOR	"Jarod Wilson <jarod@redhat.com>"
@@ -1189,7 +1189,7 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
 	rc->map_name = mceusb_model[ir->model].rc_map ?
 			mceusb_model[ir->model].rc_map : RC_MAP_RC6_MCE;
 
-	ret = rc_register_device(rc);
+	ret = rc_register_ir_raw_device(rc);
 	if (ret < 0) {
 		dev_err(dev, "remote dev registration failed\n");
 		goto out;
@@ -1378,7 +1378,7 @@ static void __devexit mceusb_dev_disconnect(struct usb_interface *intf)
 		return;
 
 	ir->usbdev = NULL;
-	rc_unregister_device(ir->rc);
+	rc_unregister_ir_raw_device(ir->rc);
 	usb_kill_urb(ir->urb_in);
 	usb_free_urb(ir->urb_in);
 	usb_free_coherent(dev, ir->len_in, ir->buf_in, ir->dma_in);
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 447f0d0..0548db4 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -32,7 +32,7 @@
 #include <linux/interrupt.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <media/rc-core.h>
+#include <media/rc-ir-raw.h>
 #include <linux/pci_ids.h>
 
 #include "nuvoton-cir.h"
@@ -1090,7 +1090,7 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 			NVT_DRIVER_NAME, (void *)nvt))
 		goto failure4;
 
-	ret = rc_register_device(rdev);
+	ret = rc_register_ir_raw_device(rdev);
 	if (ret)
 		goto failure5;
 
@@ -1138,7 +1138,7 @@ static void __devexit nvt_remove(struct pnp_dev *pdev)
 	release_region(nvt->cir_addr, CIR_IOREG_LENGTH);
 	release_region(nvt->cir_wake_addr, CIR_IOREG_LENGTH);
 
-	rc_unregister_device(nvt->rdev);
+	rc_unregister_ir_raw_device(nvt->rdev);
 
 	kfree(nvt);
 }
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 8006c2e..b2a5d99 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -19,6 +19,8 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <media/rc-core.h>
+#include <media/rc-ir-raw.h>
+
 
 struct ir_raw_handler {
 	struct list_head list;
@@ -142,7 +144,6 @@ static inline bool is_timing_event(struct ir_raw_event ev)
 /*
  * Routines from rc-raw.c to be used internally and by decoders
  */
-u64 ir_raw_get_allowed_protocols(void);
 int ir_raw_event_register(struct rc_dev *dev);
 void ir_raw_event_unregister(struct rc_dev *dev);
 int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler);
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
new file mode 100644
index 0000000..a0d3508
--- /dev/null
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -0,0 +1,379 @@
+/* ir-raw.c - handle IR pulse/space events
+ *
+ * Copyright (C) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ */
+
+#include <linux/export.h>
+#include <linux/kthread.h>
+#include <linux/mutex.h>
+#include <linux/kmod.h>
+#include <linux/sched.h>
+#include <linux/freezer.h>
+#include <linux/module.h>
+#include <media/rc-ir-raw.h>
+
+#include "rc-core-priv.h"
+
+/* Define the max number of pulse/space transitions to buffer */
+#define MAX_IR_EVENT_SIZE      512
+
+/* Used to keep track of IR raw clients, protected by ir_raw_handler_lock */
+static LIST_HEAD(ir_raw_client_list);
+
+/* Used to handle IR raw handler extensions */
+static DEFINE_MUTEX(ir_raw_handler_lock);
+static LIST_HEAD(ir_raw_handler_list);
+static u64 available_protocols;
+
+static int ir_raw_event_thread(void *data)
+{
+	struct ir_raw_event ev;
+	struct ir_raw_handler *handler;
+	struct ir_raw_event_ctrl *raw = (struct ir_raw_event_ctrl *)data;
+	int retval;
+
+	while (!kthread_should_stop()) {
+
+		spin_lock_irq(&raw->lock);
+		retval = kfifo_len(&raw->kfifo);
+
+		if (retval < sizeof(ev)) {
+			set_current_state(TASK_INTERRUPTIBLE);
+
+			if (kthread_should_stop())
+				set_current_state(TASK_RUNNING);
+
+			spin_unlock_irq(&raw->lock);
+			schedule();
+			continue;
+		}
+
+		retval = kfifo_out(&raw->kfifo, &ev, sizeof(ev));
+		spin_unlock_irq(&raw->lock);
+
+		mutex_lock(&ir_raw_handler_lock);
+		list_for_each_entry(handler, &ir_raw_handler_list, list)
+			handler->decode(raw->dev, ev);
+		raw->prev_ev = ev;
+		mutex_unlock(&ir_raw_handler_lock);
+	}
+
+	return 0;
+}
+
+/**
+ * ir_raw_event_store() - pass a pulse/space duration to the raw ir decoders
+ * @dev:	the struct rc_dev device descriptor
+ * @ev:		the struct ir_raw_event descriptor of the pulse/space
+ *
+ * This routine (which may be called from an interrupt context) stores a
+ * pulse/space duration for the raw ir decoding state machines. Pulses are
+ * signalled as positive values and spaces as negative values. A zero value
+ * will reset the decoding state machines.
+ */
+int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev)
+{
+	if (!dev->raw)
+		return -EINVAL;
+
+	IR_dprintk(2, "sample: (%05dus %s)\n",
+		   TO_US(ev->duration), TO_STR(ev->pulse));
+
+	if (kfifo_in(&dev->raw->kfifo, ev, sizeof(*ev)) != sizeof(*ev))
+		return -ENOMEM;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ir_raw_event_store);
+
+/**
+ * ir_raw_event_store_edge() - notify raw ir decoders of the start of a pulse/space
+ * @dev:	the struct rc_dev device descriptor
+ * @type:	the type of the event that has occurred
+ *
+ * This routine (which may be called from an interrupt context) is used to
+ * store the beginning of an ir pulse or space (or the start/end of ir
+ * reception) for the raw ir decoding state machines. This is used by
+ * hardware which does not provide durations directly but only interrupts
+ * (or similar events) on state change.
+ */
+int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type)
+{
+	ktime_t			now;
+	s64			delta; /* ns */
+	DEFINE_IR_RAW_EVENT(ev);
+	int			rc = 0;
+
+	if (!dev->raw)
+		return -EINVAL;
+
+	now = ktime_get();
+	delta = ktime_to_ns(ktime_sub(now, dev->raw->last_event));
+
+	/* Check for a long duration since last event or if we're
+	 * being called for the first time, note that delta can't
+	 * possibly be negative.
+	 */
+	if (delta > MS_TO_NS(500) || !dev->raw->last_type)
+		type |= IR_START_EVENT;
+	else
+		ev.duration = delta;
+
+	if (type & IR_START_EVENT)
+		ir_raw_event_reset(dev);
+	else if (dev->raw->last_type & IR_SPACE) {
+		ev.pulse = false;
+		rc = ir_raw_event_store(dev, &ev);
+	} else if (dev->raw->last_type & IR_PULSE) {
+		ev.pulse = true;
+		rc = ir_raw_event_store(dev, &ev);
+	} else
+		return 0;
+
+	dev->raw->last_event = now;
+	dev->raw->last_type = type;
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ir_raw_event_store_edge);
+
+/**
+ * ir_raw_event_store_with_filter() - pass next pulse/space to decoders with some processing
+ * @dev:	the struct rc_dev device descriptor
+ * @type:	the type of the event that has occurred
+ *
+ * This routine (which may be called from an interrupt context) works
+ * in similar manner to ir_raw_event_store_edge.
+ * This routine is intended for devices with limited internal buffer
+ * It automerges samples of same type, and handles timeouts
+ */
+int ir_raw_event_store_with_filter(struct rc_dev *dev, struct ir_raw_event *ev)
+{
+	if (!dev->raw)
+		return -EINVAL;
+
+	/* Ignore spaces in idle mode */
+	if (dev->idle && !ev->pulse)
+		return 0;
+	else if (dev->idle)
+		ir_raw_event_set_idle(dev, false);
+
+	if (!dev->raw->this_ev.duration)
+		dev->raw->this_ev = *ev;
+	else if (ev->pulse == dev->raw->this_ev.pulse)
+		dev->raw->this_ev.duration += ev->duration;
+	else {
+		ir_raw_event_store(dev, &dev->raw->this_ev);
+		dev->raw->this_ev = *ev;
+	}
+
+	/* Enter idle mode if nessesary */
+	if (!ev->pulse && dev->timeout &&
+	    dev->raw->this_ev.duration >= dev->timeout)
+		ir_raw_event_set_idle(dev, true);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ir_raw_event_store_with_filter);
+
+/**
+ * ir_raw_event_set_idle() - provide hint to rc-core when the device is idle or not
+ * @dev:	the struct rc_dev device descriptor
+ * @idle:	whether the device is idle or not
+ */
+void ir_raw_event_set_idle(struct rc_dev *dev, bool idle)
+{
+	if (!dev->raw)
+		return;
+
+	IR_dprintk(2, "%s idle mode\n", idle ? "enter" : "leave");
+
+	if (idle) {
+		dev->raw->this_ev.timeout = true;
+		ir_raw_event_store(dev, &dev->raw->this_ev);
+		init_ir_raw_event(&dev->raw->this_ev);
+	}
+
+	if (dev->s_idle)
+		dev->s_idle(dev, idle);
+
+	dev->idle = idle;
+}
+EXPORT_SYMBOL_GPL(ir_raw_event_set_idle);
+
+/**
+ * ir_raw_event_handle() - schedules the decoding of stored ir data
+ * @dev:	the struct rc_dev device descriptor
+ *
+ * This routine will tell rc-core to start decoding stored ir data.
+ */
+void ir_raw_event_handle(struct rc_dev *dev)
+{
+	unsigned long flags;
+
+	if (!dev->raw)
+		return;
+
+	spin_lock_irqsave(&dev->raw->lock, flags);
+	wake_up_process(dev->raw->thread);
+	spin_unlock_irqrestore(&dev->raw->lock, flags);
+}
+EXPORT_SYMBOL_GPL(ir_raw_event_handle);
+
+/* used internally by the sysfs interface */
+static u64
+ir_raw_get_allowed_protocols(struct rc_dev *dev)
+{
+	u64 protocols;
+	mutex_lock(&ir_raw_handler_lock);
+	protocols = available_protocols;
+	mutex_unlock(&ir_raw_handler_lock);
+	return protocols;
+}
+
+/*
+ * Used to (un)register raw event clients
+ */
+int rc_register_ir_raw_device(struct rc_dev *dev)
+{
+	int rc;
+	struct ir_raw_handler *handler;
+
+	if (!dev)
+		return -EINVAL;
+
+	dev->raw = kzalloc(sizeof(*dev->raw), GFP_KERNEL);
+	if (!dev->raw)
+		return -ENOMEM;
+
+	dev->raw->dev = dev;
+	dev->enabled_protocols = ~0;
+	dev->get_protocols = ir_raw_get_allowed_protocols;
+	dev->driver_type = RC_DRIVER_IR_RAW;
+	spin_lock_init(&dev->raw->lock);
+	rc = kfifo_alloc(&dev->raw->kfifo,
+			 sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE,
+			 GFP_KERNEL);
+	if (rc < 0)
+		goto out;
+
+	dev->raw->thread = kthread_run(ir_raw_event_thread, dev->raw,
+				       "rc-ir-raw-decode");
+	if (IS_ERR(dev->raw->thread)) {
+		rc = PTR_ERR(dev->raw->thread);
+		goto out;
+	}
+
+	rc = rc_register_device(dev);
+	if (rc < 0)
+		goto out_thread;
+
+	mutex_lock(&ir_raw_handler_lock);
+	list_add_tail(&dev->raw->list, &ir_raw_client_list);
+	list_for_each_entry(handler, &ir_raw_handler_list, list)
+		if (handler->raw_register)
+			handler->raw_register(dev);
+	mutex_unlock(&ir_raw_handler_lock);
+
+	return 0;
+
+out_thread:
+	kthread_stop(dev->raw->thread);
+out:
+	kfree(dev->raw);
+	dev->raw = NULL;
+	return rc;
+}
+EXPORT_SYMBOL_GPL(rc_register_ir_raw_device);
+
+void rc_unregister_ir_raw_device(struct rc_dev *dev)
+{
+	struct ir_raw_handler *handler;
+
+	if (!dev || !dev->raw)
+		return;
+
+	kthread_stop(dev->raw->thread);
+
+	mutex_lock(&ir_raw_handler_lock);
+	list_del(&dev->raw->list);
+	list_for_each_entry(handler, &ir_raw_handler_list, list)
+		if (handler->raw_unregister)
+			handler->raw_unregister(dev);
+	mutex_unlock(&ir_raw_handler_lock);
+
+	kfifo_free(&dev->raw->kfifo);
+	kfree(dev->raw);
+	dev->raw = NULL;
+	rc_unregister_device(dev);
+}
+EXPORT_SYMBOL_GPL(rc_unregister_ir_raw_device);
+
+/*
+ * Extension interface - used to register the IR decoders
+ */
+
+int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler)
+{
+	struct ir_raw_event_ctrl *raw;
+
+	mutex_lock(&ir_raw_handler_lock);
+	list_add_tail(&ir_raw_handler->list, &ir_raw_handler_list);
+	if (ir_raw_handler->raw_register)
+		list_for_each_entry(raw, &ir_raw_client_list, list)
+			ir_raw_handler->raw_register(raw->dev);
+	available_protocols |= ir_raw_handler->protocols;
+	mutex_unlock(&ir_raw_handler_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(ir_raw_handler_register);
+
+void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
+{
+	struct ir_raw_event_ctrl *raw;
+
+	mutex_lock(&ir_raw_handler_lock);
+	list_del(&ir_raw_handler->list);
+	if (ir_raw_handler->raw_unregister)
+		list_for_each_entry(raw, &ir_raw_client_list, list)
+			ir_raw_handler->raw_unregister(raw->dev);
+	available_protocols &= ~ir_raw_handler->protocols;
+	mutex_unlock(&ir_raw_handler_lock);
+}
+EXPORT_SYMBOL(ir_raw_handler_unregister);
+
+static struct work_struct wq_load;
+
+static void rc_ir_raw_init_decoders(struct work_struct *work)
+{
+	/* Load the decoder modules */
+	load_nec_decode();
+	load_rc5_decode();
+	load_rc6_decode();
+	load_jvc_decode();
+	load_sony_decode();
+	load_sanyo_decode();
+	load_mce_kbd_decode();
+	load_lirc_codec();
+}
+
+static int __init rc_ir_raw_init(void)
+{
+	INIT_WORK(&wq_load, rc_ir_raw_init_decoders);
+	schedule_work(&wq_load);
+	return 0;
+}
+
+subsys_initcall(rc_ir_raw_init);
+
+MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index af64d15..7775b3e 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -26,7 +26,7 @@
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/sched.h>
-#include <media/rc-core.h>
+#include <media/rc-ir-raw.h>
 
 #define DRIVER_NAME	"rc-loopback"
 #define dprintk(x...)	if (debug) printk(KERN_INFO DRIVER_NAME ": " x)
@@ -242,7 +242,7 @@ static int __init loop_init(void)
 	loopdev.learning	= false;
 	loopdev.carrierreport	= false;
 
-	ret = rc_register_device(rc);
+	ret = rc_register_ir_raw_device(rc);
 	if (ret < 0) {
 		printk(KERN_ERR DRIVER_NAME ": rc_dev registration failed\n");
 		rc_free_device(rc);
@@ -255,7 +255,7 @@ static int __init loop_init(void)
 
 static void __exit loop_exit(void)
 {
-	rc_unregister_device(loopdev.dev);
+	rc_unregister_ir_raw_device(loopdev.dev);
 }
 
 module_init(loop_init);
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 4edaffb..c2c42f9 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -249,10 +249,7 @@ static ssize_t show_protocols(struct device *device,
 	mutex_lock(&dev->lock);
 
 	enabled = dev->enabled_protocols;
-	if (dev->driver_type == RC_DRIVER_SCANCODE)
-		allowed = dev->allowed_protos;
-	else
-		allowed = ir_raw_get_allowed_protocols();
+	allowed = dev->get_protocols(dev);
 
 	IR_dprintk(1, "allowed - 0x%llx, enabled - 0x%llx\n",
 		   (long long)allowed,
@@ -536,9 +533,13 @@ static int rc_remove_keytable(struct rc_dev *dev, unsigned i)
 	return 0;
 }
 
+static u64 rc_get_allowed_protocols(struct rc_dev *dev)
+{
+	return dev ? dev->allowed_protos : 0x0;
+}
+
 int rc_register_device(struct rc_dev *dev)
 {
-	static bool raw_init = false; /* raw decoders loaded? */
 	const char *path;
 	int rc;
 	unsigned int i;
@@ -564,28 +565,19 @@ int rc_register_device(struct rc_dev *dev)
 	dev_set_name(&dev->dev, "rc%u", dev->minor);
 	dev_set_drvdata(&dev->dev, dev);
 
+	if (!dev->get_protocols)
+		dev->get_protocols = rc_get_allowed_protocols;
+
 	if (dev->tx_ir) {
 		rc = kfifo_alloc(&dev->txfifo, RC_TX_KFIFO_SIZE, GFP_KERNEL);
 		if (rc)
 			goto out;
 	}
 
-	if (dev->driver_type == RC_DRIVER_IR_RAW) {
-		/* Load raw decoders, if they aren't already */
-		if (!raw_init) {
-			IR_dprintk(1, "Loading raw decoders\n");
-			ir_raw_init();
-			raw_init = true;
-		}
-		rc = ir_raw_event_register(dev);
-		if (rc < 0)
-			goto out_kfifo;
-	}
-
 	if (dev->change_protocol) {
 		rc = dev->change_protocol(dev, dev->enabled_protocols);
 		if (rc < 0)
-			goto out_raw;
+			goto out_kfifo;
 	}
 
 	rc_dev_table[i] = dev;
@@ -615,9 +607,6 @@ out_device:
 	device_del(&dev->dev);
 out_chardev:
 	rc_dev_table[dev->minor] = NULL;
-out_raw:
-	if (dev->driver_type == RC_DRIVER_IR_RAW)
-		ir_raw_event_unregister(dev);
 out_kfifo:
 	kfifo_free(&dev->txfifo);
 out:
@@ -651,9 +640,6 @@ void rc_unregister_device(struct rc_dev *dev)
 	wake_up_interruptible_all(&dev->rxwait);
 	wake_up_interruptible_all(&dev->txwait);
 
-	if (dev->driver_type == RC_DRIVER_IR_RAW)
-		ir_raw_event_unregister(dev);
-
 	device_unregister(&dev->dev);
 }
 
@@ -914,10 +900,7 @@ void rc_init_ir_rx(struct rc_dev *dev, struct rc_ir_rx *rx)
 	rx->rx_enabled = 0x1;
 	rx->rx_connected = 0x1;
 	rx->protocols_enabled[0] = dev->enabled_protocols;
-	if (dev->driver_type == RC_DRIVER_SCANCODE)
-		rx->protocols_supported[0] = dev->allowed_protos;
-	else
-		rx->protocols_supported[0] = ir_raw_get_allowed_protocols();
+	rx->protocols_supported[0] = dev->get_protocols(dev);
 	rx->timeout = dev->timeout;
 	rx->timeout_min = dev->min_timeout;
 	rx->timeout_max = dev->max_timeout;
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 5eefb0b..394799d 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -50,7 +50,7 @@
 #include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/usb/input.h>
-#include <media/rc-core.h>
+#include <media/rc-ir-raw.h>
 
 /* Driver Information */
 #define DRIVER_VERSION "0.70"
@@ -1037,7 +1037,7 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
 	rc->driver_name = DRIVER_NAME;
 	rc->map_name = RC_MAP_HAUPPAUGE;
 
-	ret = rc_register_device(rc);
+	ret = rc_register_ir_raw_device(rc);
 	if (ret < 0) {
 		dev_err(dev, "remote dev registration failed\n");
 		goto out;
@@ -1201,7 +1201,7 @@ static void __devexit redrat3_dev_disconnect(struct usb_interface *intf)
 	redrat3_disable_detector(rr3);
 
 	usb_set_intfdata(intf, NULL);
-	rc_unregister_device(rr3->rc);
+	rc_unregister_ir_raw_device(rr3->rc);
 	del_timer_sync(&rr3->rx_timeout);
 	redrat3_delete(rr3, udev);
 
diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index fdfedc6..4156197 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -36,7 +36,7 @@
 #include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/usb/input.h>
-#include <media/rc-core.h>
+#include <media/rc-ir-raw.h>
 
 #define DRIVER_VERSION	"1.61"
 #define DRIVER_NAME	"streamzap"
@@ -319,7 +319,7 @@ static struct rc_dev *streamzap_init_rc_dev(struct streamzap_ir *sz)
 	rdev->driver_name = DRIVER_NAME;
 	rdev->map_name = RC_MAP_STREAMZAP;
 
-	ret = rc_register_device(rdev);
+	ret = rc_register_ir_raw_device(rdev);
 	if (ret < 0) {
 		dev_err(dev, "remote input device register failed\n");
 		goto out;
@@ -484,7 +484,7 @@ static void streamzap_disconnect(struct usb_interface *interface)
 		return;
 
 	sz->usbdev = NULL;
-	rc_unregister_device(sz->rdev);
+	rc_unregister_ir_raw_device(sz->rdev);
 	usb_kill_urb(sz->urb_in);
 	usb_free_urb(sz->urb_in);
 	usb_free_coherent(usbdev, sz->buf_in_len, sz->buf_in, sz->dma_in);
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 207410c..5a240ba 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -55,7 +55,7 @@
 #include <linux/slab.h>
 #include <linux/wait.h>
 #include <linux/sched.h>
-#include <media/rc-core.h>
+#include <media/rc-ir-raw.h>
 
 #define DRVNAME "winbond-cir"
 
@@ -1056,7 +1056,7 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 		goto exit_release_sbase;
 	}
 
-	err = rc_register_device(data->dev);
+	err = rc_register_ir_raw_device(data->dev);
 	if (err)
 		goto exit_free_irq;
 
@@ -1107,7 +1107,7 @@ wbcir_remove(struct pnp_dev *device)
 	/* Clear BUFF_EN, END_EN, MATCH_EN */
 	wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_EV_EN, 0x00, 0x07);
 
-	rc_unregister_device(data->dev);
+	rc_unregister_ir_raw_device(data->dev);
 
 	led_trigger_unregister_simple(data->rxtrigger);
 	led_trigger_unregister_simple(data->txtrigger);
diff --git a/drivers/media/video/cx23885/Kconfig b/drivers/media/video/cx23885/Kconfig
index b391e9b..5931e3f 100644
--- a/drivers/media/video/cx23885/Kconfig
+++ b/drivers/media/video/cx23885/Kconfig
@@ -6,7 +6,7 @@ config VIDEO_CX23885
 	select VIDEO_BTCX
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
-	depends on RC_CORE
+	depends on RC_CORE && RC_IR_RAW
 	select VIDEOBUF_DVB
 	select VIDEOBUF_DMA_SG
 	select VIDEO_CX25840
diff --git a/drivers/media/video/cx23885/cx23885-input.c b/drivers/media/video/cx23885/cx23885-input.c
index 6aa96a2..dbf0d34 100644
--- a/drivers/media/video/cx23885/cx23885-input.c
+++ b/drivers/media/video/cx23885/cx23885-input.c
@@ -36,7 +36,7 @@
  */
 
 #include <linux/slab.h>
-#include <media/rc-core.h>
+#include <media/rc-ir-raw.h>
 #include <media/v4l2-subdev.h>
 
 #include "cx23885.h"
@@ -324,7 +324,7 @@ int cx23885_input_init(struct cx23885_dev *dev)
 
 	/* Go */
 	dev->kernel_ir = kernel_ir;
-	ret = rc_register_device(rc);
+	ret = rc_register_ir_raw_device(rc);
 	if (ret)
 		goto err_out_stop;
 
@@ -348,7 +348,7 @@ void cx23885_input_fini(struct cx23885_dev *dev)
 
 	if (dev->kernel_ir == NULL)
 		return;
-	rc_unregister_device(dev->kernel_ir->rc);
+	rc_unregister_ir_raw_device(dev->kernel_ir->rc);
 	kfree(dev->kernel_ir->phys);
 	kfree(dev->kernel_ir->name);
 	kfree(dev->kernel_ir);
diff --git a/drivers/media/video/cx23885/cx23888-ir.c b/drivers/media/video/cx23885/cx23888-ir.c
index c2bc39c..f3609a2 100644
--- a/drivers/media/video/cx23885/cx23888-ir.c
+++ b/drivers/media/video/cx23885/cx23888-ir.c
@@ -26,7 +26,7 @@
 
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
-#include <media/rc-core.h>
+#include <media/rc-ir-raw.h>
 
 #include "cx23885.h"
 
diff --git a/drivers/media/video/cx25840/cx25840-ir.c b/drivers/media/video/cx25840/cx25840-ir.c
index 38ce76e..cd3aca7 100644
--- a/drivers/media/video/cx25840/cx25840-ir.c
+++ b/drivers/media/video/cx25840/cx25840-ir.c
@@ -25,7 +25,7 @@
 #include <linux/kfifo.h>
 #include <linux/module.h>
 #include <media/cx25840.h>
-#include <media/rc-core.h>
+#include <media/rc-ir-raw.h>
 
 #include "cx25840-core.h"
 
diff --git a/drivers/media/video/cx88/Kconfig b/drivers/media/video/cx88/Kconfig
index 3598dc0..63f2351 100644
--- a/drivers/media/video/cx88/Kconfig
+++ b/drivers/media/video/cx88/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_CX88
 	tristate "Conexant 2388x (bt878 successor) support"
-	depends on VIDEO_DEV && PCI && I2C && RC_CORE
+	depends on VIDEO_DEV && PCI && I2C && RC_CORE && RC_IR_RAW
 	select I2C_ALGOBIT
 	select VIDEO_BTCX
 	select VIDEOBUF_DMA_SG
diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index 2962ef7..158c1b6 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -29,7 +29,7 @@
 #include <linux/module.h>
 
 #include "cx88.h"
-#include <media/rc-core.h>
+#include <media/rc-ir-raw.h>
 
 #define MODULE_NAME "cx88xx"
 
@@ -473,7 +473,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	core->ir = ir;
 
 	/* all done */
-	err = rc_register_device(dev);
+	err = rc_register_ir_raw_device(dev);
 	if (err)
 		goto err_out_free;
 
@@ -495,7 +495,7 @@ int cx88_ir_fini(struct cx88_core *core)
 		return 0;
 
 	cx88_ir_stop(core);
-	rc_unregister_device(ir->dev);
+	rc_unregister_ir_raw_device(ir->dev);
 	kfree(ir);
 
 	/* done */
diff --git a/drivers/media/video/saa7134/Kconfig b/drivers/media/video/saa7134/Kconfig
index 39fc018..2b1596f 100644
--- a/drivers/media/video/saa7134/Kconfig
+++ b/drivers/media/video/saa7134/Kconfig
@@ -26,7 +26,7 @@ config VIDEO_SAA7134_ALSA
 
 config VIDEO_SAA7134_RC
 	bool "Philips SAA7134 Remote Controller support"
-	depends on RC_CORE
+	depends on RC_CORE && RC_IR_RAW
 	depends on VIDEO_SAA7134
 	depends on !(RC_CORE=m && VIDEO_SAA7134=y)
 	default y
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 6b5fc7f..9b54082 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -873,7 +873,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	rc->map_name = ir_codes;
 	rc->driver_name = MODULE_NAME;
 
-	err = rc_register_device(rc);
+	err = rc_register_ir_raw_device(rc);
 	if (err)
 		goto err_out_free;
 
@@ -892,7 +892,7 @@ void saa7134_input_fini(struct saa7134_dev *dev)
 		return;
 
 	saa7134_ir_stop(dev);
-	rc_unregister_device(dev->remote->dev);
+	rc_unregister_ir_raw_device(dev->remote->dev);
 	kfree(dev->remote);
 	dev->remote = NULL;
 }
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index 89c8333..56edbf7 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -36,7 +36,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 #include <media/tuner.h>
-#include <media/rc-core.h>
+#include <media/rc-ir-raw.h>
 #include <media/ir-kbd-i2c.h>
 #include <media/videobuf-dma-sg.h>
 #include <sound/core.h>
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 1a38ecc..cf66e91 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -258,6 +258,7 @@ struct ir_raw_event {
  * @max_timeout: maximum timeout supported by device
  * @rx_resolution : resolution (in ns) of input sampler
  * @tx_resolution: resolution (in ns) of output sampler
+ * @get_protocols: returns a bitmask of allowed protocols
  * @change_protocol: allow changing the protocol used on hardware decoders
  * @open: callback to allow drivers to enable polling/irq when IR input device
  *	is opened.
@@ -309,6 +310,7 @@ struct rc_dev {
 	u32				max_timeout;
 	u32				rx_resolution;
 	u32				tx_resolution;
+	u64				(*get_protocols)(struct rc_dev *dev);
 	int				(*change_protocol)(struct rc_dev *dev, u64 rc_type);
 	int				(*open)(struct rc_dev *dev);
 	void				(*close)(struct rc_dev *dev);
@@ -420,53 +422,6 @@ void rc_do_keydown(struct rc_dev *dev, enum rc_type protocol, u64 scancode, u8 t
 #define rc_keydown_notimeout(dev, proto, scan, toggle) rc_do_keydown(dev, proto, scan, toggle, false)
 u32 rc_g_keycode_from_table(struct rc_dev *dev, enum rc_type protocol, u64 scancode);
 
-/*
- * From rc-raw.c
- * The Raw interface is specific to InfraRed. It may be a good idea to
- * split it later into a separate header.
- */
-
-enum raw_event_type {
-	IR_SPACE        = (1 << 0),
-	IR_PULSE        = (1 << 1),
-	IR_START_EVENT  = (1 << 2),
-	IR_STOP_EVENT   = (1 << 3),
-};
-
-#define DEFINE_IR_RAW_EVENT(event) \
-	struct ir_raw_event event = { \
-		{ .duration = 0 } , \
-		.pulse = 0, \
-		.reset = 0, \
-		.timeout = 0, \
-		.carrier_report = 0 }
-
-static inline void init_ir_raw_event(struct ir_raw_event *ev)
-{
-	memset(ev, 0, sizeof(*ev));
-}
-
-#define IR_MAX_DURATION         0xFFFFFFFF      /* a bit more than 4 seconds */
-#define US_TO_NS(usec)		((usec) * 1000)
-#define MS_TO_US(msec)		((msec) * 1000)
-#define MS_TO_NS(msec)		((msec) * 1000 * 1000)
-
-void ir_raw_event_handle(struct rc_dev *dev);
-int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev);
-int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type);
-int ir_raw_event_store_with_filter(struct rc_dev *dev,
-				struct ir_raw_event *ev);
-void ir_raw_event_set_idle(struct rc_dev *dev, bool idle);
-
-static inline void ir_raw_event_reset(struct rc_dev *dev)
-{
-	DEFINE_IR_RAW_EVENT(ev);
-	ev.reset = true;
-
-	ir_raw_event_store(dev, &ev);
-	ir_raw_event_handle(dev);
-}
-
 /* extract mask bits out of data and pack them into the result */
 static inline u32 ir_extract_bits(u32 data, u32 mask)
 {
diff --git a/include/media/rc-ir-raw.h b/include/media/rc-ir-raw.h
new file mode 100644
index 0000000..4c3fe78
--- /dev/null
+++ b/include/media/rc-ir-raw.h
@@ -0,0 +1,68 @@
+/*
+ * Remote Controller IR raw decoding header
+ *
+ * Copyright (C) 2009-2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ */
+
+#ifndef _RC_IR_RAW
+#define _RC_IR_RAW
+
+#include <linux/spinlock.h>
+#include <linux/kfifo.h>
+#include <linux/time.h>
+#include <linux/timer.h>
+#include <media/rc-core.h>
+
+enum raw_event_type {
+	IR_SPACE        = (1 << 0),
+	IR_PULSE        = (1 << 1),
+	IR_START_EVENT  = (1 << 2),
+	IR_STOP_EVENT   = (1 << 3),
+};
+
+#define DEFINE_IR_RAW_EVENT(event) \
+	struct ir_raw_event event = { \
+		{ .duration = 0 } , \
+		.pulse = 0, \
+		.reset = 0, \
+		.timeout = 0, \
+		.carrier_report = 0 }
+
+static inline void init_ir_raw_event(struct ir_raw_event *ev)
+{
+	memset(ev, 0, sizeof(*ev));
+}
+
+#define IR_MAX_DURATION         0xFFFFFFFF      /* a bit more than 4 seconds */
+#define US_TO_NS(usec)		((usec) * 1000)
+#define MS_TO_US(msec)		((msec) * 1000)
+#define MS_TO_NS(msec)		((msec) * 1000 * 1000)
+
+void ir_raw_event_handle(struct rc_dev *dev);
+int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev);
+int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type);
+int ir_raw_event_store_with_filter(struct rc_dev *dev,
+				struct ir_raw_event *ev);
+void ir_raw_event_set_idle(struct rc_dev *dev, bool idle);
+int rc_register_ir_raw_device(struct rc_dev *dev);
+void rc_unregister_ir_raw_device(struct rc_dev *dev);
+
+static inline void ir_raw_event_reset(struct rc_dev *dev)
+{
+	DEFINE_IR_RAW_EVENT(ev);
+	ev.reset = true;
+
+	ir_raw_event_store(dev, &ev);
+	ir_raw_event_handle(dev);
+}
+
+#endif /* _RC_IR_RAW */

