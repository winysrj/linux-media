Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48528 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044Ab1EYQlC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 12:41:02 -0400
Received: by mail-fx0-f46.google.com with SMTP id 17so5500911fxm.19
        for <linux-media@vger.kernel.org>; Wed, 25 May 2011 09:41:01 -0700 (PDT)
From: Christoph Pinkl <christoph.pinkl@gmail.com>
To: linux-media@vger.kernel.org
Cc: Christoph Pinkl <christoph.pinkl@gmail.com>
Subject: [PATCH] Add remote control support for mantis
Date: Wed, 25 May 2011 18:40:33 +0200
Message-Id: <1306341633-1975-1-git-send-email-christoph.pinkl@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Signed-off-by: Christoph Pinkl <christoph.pinkl@gmail.com>
---
 drivers/media/dvb/mantis/hopper_cards.c            |    2 +-
 drivers/media/dvb/mantis/mantis_cards.c            |   27 +++-
 drivers/media/dvb/mantis/mantis_common.h           |   23 ++-
 drivers/media/dvb/mantis/mantis_input.c            |  168 +++++++-------------
 drivers/media/dvb/mantis/mantis_input.h            |   28 ++++
 drivers/media/dvb/mantis/mantis_uart.c             |   18 +--
 drivers/media/dvb/mantis/mantis_vp1041.c           |   20 +++
 drivers/media/dvb/mantis/mantis_vp2033.c           |    4 +
 drivers/media/dvb/mantis/mantis_vp2040.c           |    4 +
 drivers/media/rc/keymaps/Makefile                  |    3 +
 .../media/rc/keymaps/rc-terratec-cinergy-c-pci.c   |   85 ++++++++++
 .../media/rc/keymaps/rc-terratec-cinergy-s2-hd.c   |   85 ++++++++++
 drivers/media/rc/keymaps/rc-twinhan-dtv-cab-ci.c   |   95 +++++++++++
 include/media/rc-map.h                             |    3 +
 14 files changed, 438 insertions(+), 127 deletions(-)
 create mode 100644 drivers/media/dvb/mantis/mantis_input.h
 create mode 100644 drivers/media/rc/keymaps/rc-terratec-cinergy-c-pci.c
 create mode 100644 drivers/media/rc/keymaps/rc-terratec-cinergy-s2-hd.c
 create mode 100644 drivers/media/rc/keymaps/rc-twinhan-dtv-cab-ci.c

diff --git a/drivers/media/dvb/mantis/hopper_cards.c b/drivers/media/dvb/mantis/hopper_cards.c
index 1402062..0b76664 100644
--- a/drivers/media/dvb/mantis/hopper_cards.c
+++ b/drivers/media/dvb/mantis/hopper_cards.c
@@ -107,7 +107,7 @@ static irqreturn_t hopper_irq_handler(int irq, void *dev_id)
 	}
 	if (stat & MANTIS_INT_IRQ1) {
 		dprintk(MANTIS_DEBUG, 0, "<%s>", label[2]);
-		schedule_work(&mantis->uart_work);
+		tasklet_schedule(&mantis->uart_tasklet);
 	}
 	if (stat & MANTIS_INT_OCERR) {
 		dprintk(MANTIS_DEBUG, 0, "<%s>", label[3]);
diff --git a/drivers/media/dvb/mantis/mantis_cards.c b/drivers/media/dvb/mantis/mantis_cards.c
index 05cbb9d..8eca749 100644
--- a/drivers/media/dvb/mantis/mantis_cards.c
+++ b/drivers/media/dvb/mantis/mantis_cards.c
@@ -49,6 +49,7 @@
 #include "mantis_pci.h"
 #include "mantis_i2c.h"
 #include "mantis_reg.h"
+#include "mantis_input.h"
 
 static unsigned int verbose;
 module_param(verbose, int, 0644);
@@ -115,7 +116,7 @@ static irqreturn_t mantis_irq_handler(int irq, void *dev_id)
 	}
 	if (stat & MANTIS_INT_IRQ1) {
 		dprintk(MANTIS_DEBUG, 0, "<%s>", label[2]);
-		schedule_work(&mantis->uart_work);
+		tasklet_schedule(&mantis->uart_tasklet);
 	}
 	if (stat & MANTIS_INT_OCERR) {
 		dprintk(MANTIS_DEBUG, 0, "<%s>", label[3]);
@@ -180,6 +181,14 @@ static int __devinit mantis_pci_probe(struct pci_dev *pdev, const struct pci_dev
 	config->irq_handler	= &mantis_irq_handler;
 	mantis->hwconfig	= config;
 
+	if (mantis->hwconfig->config_init != NULL) {
+		dprintk(MANTIS_ERROR, 1,
+			"Mantis-subsystem: vendor:0x%04x, device:0x%04x\n",
+			mantis->pdev->subsystem_vendor,
+			mantis->pdev->subsystem_device);
+		mantis->hwconfig->config_init(mantis);
+	}
+
 	err = mantis_pci_init(mantis);
 	if (err) {
 		dprintk(MANTIS_ERROR, 1, "ERROR: Mantis PCI initialization failed <%d>", err);
@@ -215,21 +224,32 @@ static int __devinit mantis_pci_probe(struct pci_dev *pdev, const struct pci_dev
 		dprintk(MANTIS_ERROR, 1, "ERROR: Mantis DVB initialization failed <%d>", err);
 		goto fail4;
 	}
+
+	err = mantis_input_init(mantis);
+	if (err < 0) {
+		dprintk(MANTIS_ERROR, 1, "ERROR: Mantis INPUT initialization failed <%d>", err);
+		goto fail6;
+	}
+
+
 	err = mantis_uart_init(mantis);
 	if (err < 0) {
 		dprintk(MANTIS_ERROR, 1, "ERROR: Mantis UART initialization failed <%d>", err);
-		goto fail6;
+		goto fail7;
 	}
 
 	devs++;
 
 	return err;
 
-
+fail7:
 	dprintk(MANTIS_ERROR, 1, "ERROR: Mantis UART exit! <%d>", err);
 	mantis_uart_exit(mantis);
 
 fail6:
+	dprintk(MANTIS_ERROR, 1, "ERROR: Mantis INPUT exit! <%d>", err);
+	mantis_input_exit(mantis);
+
 fail4:
 	dprintk(MANTIS_ERROR, 1, "ERROR: Mantis DMA exit! <%d>", err);
 	mantis_dma_exit(mantis);
@@ -257,6 +277,7 @@ static void __devexit mantis_pci_remove(struct pci_dev *pdev)
 	if (mantis) {
 
 		mantis_uart_exit(mantis);
+		mantis_input_exit(mantis);
 		mantis_dvb_exit(mantis);
 		mantis_dma_exit(mantis);
 		mantis_i2c_exit(mantis);
diff --git a/drivers/media/dvb/mantis/mantis_common.h b/drivers/media/dvb/mantis/mantis_common.h
index bd400d2..a61046d 100644
--- a/drivers/media/dvb/mantis/mantis_common.h
+++ b/drivers/media/dvb/mantis/mantis_common.h
@@ -23,6 +23,9 @@
 
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
+#include <linux/input.h>
+#include <linux/spinlock.h>
+#include <media/rc-core.h>
 
 #include "mantis_uart.h"
 
@@ -91,8 +94,12 @@ struct mantis_hwconfig {
 	enum mantis_parity	parity;
 	u32			bytes;
 
+	char			*ir_codes;
+	void (*ir_work)(struct mantis_pci *mantis, u8 buf[]);
+
 	irqreturn_t (*irq_handler)(int irq, void *dev_id);
 	int (*frontend_init)(struct mantis_pci *mantis, struct dvb_frontend *fe);
+	void (*config_init)(struct mantis_pci *mantis);
 
 	u8			power;
 	u8			reset;
@@ -100,6 +107,12 @@ struct mantis_hwconfig {
 	enum mantis_i2c_mode	i2c_mode;
 };
 
+struct mantis_ir {
+	struct rc_dev		*rc_dev;
+	char			rc_name[80];
+	char			rc_phys[80];
+};
+
 struct mantis_pci {
 	unsigned int		verbose;
 
@@ -167,13 +180,11 @@ struct mantis_pci {
 
 	struct mantis_ca	*mantis_ca;
 
-	wait_queue_head_t	uart_wq;
-	struct work_struct	uart_work;
-	spinlock_t		uart_lock;
+	struct tasklet_struct	uart_tasklet;
+
+	/* Remote Control handling */
+	struct mantis_ir	rc;
 
-	struct rc_dev		*rc;
-	char			input_name[80];
-	char			input_phys[80];
 };
 
 #define MANTIS_HIF_STATUS	(mantis->gpio_status)
diff --git a/drivers/media/dvb/mantis/mantis_input.c b/drivers/media/dvb/mantis/mantis_input.c
index db6d54d..615429d 100644
--- a/drivers/media/dvb/mantis/mantis_input.c
+++ b/drivers/media/dvb/mantis/mantis_input.c
@@ -18,7 +18,6 @@
 	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
-#include <media/rc-core.h>
 #include <linux/pci.h>
 
 #include "dmxdev.h"
@@ -28,132 +27,87 @@
 #include "dvb_net.h"
 
 #include "mantis_common.h"
+#include "mantis_input.h"
 #include "mantis_reg.h"
 #include "mantis_uart.h"
 
 #define MODULE_NAME "mantis_core"
-#define RC_MAP_MANTIS "rc-mantis"
-
-static struct rc_map_table mantis_ir_table[] = {
-	{ 0x29, KEY_POWER	},
-	{ 0x28, KEY_FAVORITES	},
-	{ 0x30, KEY_TEXT	},
-	{ 0x17, KEY_INFO	}, /* Preview */
-	{ 0x23, KEY_EPG		},
-	{ 0x3b, KEY_F22		}, /* Record List */
-	{ 0x3c, KEY_1		},
-	{ 0x3e, KEY_2		},
-	{ 0x39, KEY_3		},
-	{ 0x36, KEY_4		},
-	{ 0x22, KEY_5		},
-	{ 0x20, KEY_6		},
-	{ 0x32, KEY_7		},
-	{ 0x26, KEY_8		},
-	{ 0x24, KEY_9		},
-	{ 0x2a, KEY_0		},
-
-	{ 0x33, KEY_CANCEL	},
-	{ 0x2c, KEY_BACK	},
-	{ 0x15, KEY_CLEAR	},
-	{ 0x3f, KEY_TAB		},
-	{ 0x10, KEY_ENTER	},
-	{ 0x14, KEY_UP		},
-	{ 0x0d, KEY_RIGHT	},
-	{ 0x0e, KEY_DOWN	},
-	{ 0x11, KEY_LEFT	},
-
-	{ 0x21, KEY_VOLUMEUP	},
-	{ 0x35, KEY_VOLUMEDOWN	},
-	{ 0x3d, KEY_CHANNELDOWN	},
-	{ 0x3a, KEY_CHANNELUP	},
-	{ 0x2e, KEY_RECORD	},
-	{ 0x2b, KEY_PLAY	},
-	{ 0x13, KEY_PAUSE	},
-	{ 0x25, KEY_STOP	},
-
-	{ 0x1f, KEY_REWIND	},
-	{ 0x2d, KEY_FASTFORWARD	},
-	{ 0x1e, KEY_PREVIOUS	}, /* Replay |< */
-	{ 0x1d, KEY_NEXT	}, /* Skip   >| */
-
-	{ 0x0b, KEY_CAMERA	}, /* Capture */
-	{ 0x0f, KEY_LANGUAGE	}, /* SAP */
-	{ 0x18, KEY_MODE	}, /* PIP */
-	{ 0x12, KEY_ZOOM	}, /* Full screen */
-	{ 0x1c, KEY_SUBTITLE	},
-	{ 0x2f, KEY_MUTE	},
-	{ 0x16, KEY_F20		}, /* L/R */
-	{ 0x38, KEY_F21		}, /* Hibernate */
-
-	{ 0x37, KEY_SWITCHVIDEOMODE }, /* A/V */
-	{ 0x31, KEY_AGAIN	}, /* Recall */
-	{ 0x1a, KEY_KPPLUS	}, /* Zoom+ */
-	{ 0x19, KEY_KPMINUS	}, /* Zoom- */
-	{ 0x27, KEY_RED		},
-	{ 0x0C, KEY_GREEN	},
-	{ 0x01, KEY_YELLOW	},
-	{ 0x00, KEY_BLUE	},
-};
-
-static struct rc_map_list ir_mantis_map = {
-	.map = {
-		.scan = mantis_ir_table,
-		.size = ARRAY_SIZE(mantis_ir_table),
-		.rc_type = RC_TYPE_UNKNOWN,
-		.name = RC_MAP_MANTIS,
-	}
-};
 
 int mantis_input_init(struct mantis_pci *mantis)
 {
-	struct rc_dev *dev;
+	struct rc_dev *rc_dev;
+	struct mantis_ir *mir = &mantis->rc;
 	int err;
 
-	err = rc_map_register(&ir_mantis_map);
-	if (err)
-		goto out;
 
-	dev = rc_allocate_device();
-	if (!dev) {
-		dprintk(MANTIS_ERROR, 1, "Remote device allocation failed");
-		err = -ENOMEM;
-		goto out_map;
+	if (!mantis->hwconfig->ir_codes) {
+		dprintk(MANTIS_DEBUG, 1, "No RC codes available");
+		return 0;
 	}
 
-	sprintf(mantis->input_name, "Mantis %s IR receiver", mantis->hwconfig->model_name);
-	sprintf(mantis->input_phys, "pci-%s/ir0", pci_name(mantis->pdev));
-
-	dev->input_name         = mantis->input_name;
-	dev->input_phys         = mantis->input_phys;
-	dev->input_id.bustype   = BUS_PCI;
-	dev->input_id.vendor    = mantis->vendor_id;
-	dev->input_id.product   = mantis->device_id;
-	dev->input_id.version   = 1;
-	dev->driver_name        = MODULE_NAME;
-	dev->map_name           = RC_MAP_MANTIS;
-	dev->dev.parent         = &mantis->pdev->dev;
+	rc_dev = rc_allocate_device();
+	if (!rc_dev) {
+		dprintk(MANTIS_ERROR, 1, "Input device allocate failed");
+		return -ENOMEM;
+	}
 
-	err = rc_register_device(dev);
+	mir->rc_dev = rc_dev;
+
+	snprintf(mir->rc_name, sizeof(mir->rc_name),
+		"Mantis %s IR Receiver", mantis->hwconfig->model_name);
+	snprintf(mir->rc_phys, sizeof(mir->rc_phys),
+		"pci-%s/ir0", pci_name(mantis->pdev));
+
+	dprintk(MANTIS_ERROR, 1, "Input device %s PCI: %s",
+		mir->rc_name, mir->rc_phys);
+
+	rc_dev->input_name = mir->rc_name;
+	rc_dev->input_phys = mir->rc_phys;
+	rc_dev->input_id.bustype = BUS_PCI;
+	rc_dev->input_id.vendor	= mantis->vendor_id;
+	rc_dev->input_id.product = mantis->device_id;
+	rc_dev->input_id.version = 1;
+	rc_dev->priv = mir;
+	rc_dev->driver_name = MODULE_NAME;
+	rc_dev->driver_type = RC_DRIVER_SCANCODE;
+	rc_dev->map_name = mantis->hwconfig->ir_codes;
+	rc_dev->allowed_protos = RC_TYPE_UNKNOWN;
+
+	err = rc_register_device(rc_dev);
 	if (err) {
 		dprintk(MANTIS_ERROR, 1, "IR device registration failed, ret = %d", err);
-		goto out_dev;
+		mir->rc_dev = NULL;
+		rc_free_device(rc_dev);
+		return -ENODEV;
 	}
 
-	mantis->rc = dev;
+	dprintk(MANTIS_INFO, 1, "Input device registered");
 	return 0;
-
-out_dev:
-	rc_free_device(dev);
-out_map:
-	rc_map_unregister(&ir_mantis_map);
-out:
-	return err;
 }
+EXPORT_SYMBOL_GPL(mantis_input_init);
 
-int mantis_exit(struct mantis_pci *mantis)
+void mantis_input_exit(struct mantis_pci *mantis)
 {
-	rc_unregister_device(mantis->rc);
-	rc_map_unregister(&ir_mantis_map);
-	return 0;
+	struct rc_dev *rc_dev = mantis->rc.rc_dev;
+
+	if (!rc_dev)
+		return;
+
+	rc_unregister_device(rc_dev);
+	mantis->rc.rc_dev = NULL;
 }
+EXPORT_SYMBOL_GPL(mantis_input_exit);
+
+void mantis_input_process(struct mantis_pci *mantis, u8 buf[])
+{
+	struct mantis_hwconfig *config = mantis->hwconfig;
+	struct mantis_ir *mir = &mantis->rc;
+	int i;
 
+	for (i = 0; i < (config->bytes + 1); i++) {
+		dprintk(MANTIS_ERROR, 0, "RC Input Sendkey:%d <%02x>\n", i, buf[i]);
+		rc_keydown(mir->rc_dev, buf[i], 0);
+	}
+
+}
+EXPORT_SYMBOL_GPL(mantis_input_process);
diff --git a/drivers/media/dvb/mantis/mantis_input.h b/drivers/media/dvb/mantis/mantis_input.h
new file mode 100644
index 0000000..a00666f
--- /dev/null
+++ b/drivers/media/dvb/mantis/mantis_input.h
@@ -0,0 +1,28 @@
+/*
+	Mantis PCI bridge driver
+
+	Copyright (C) Manu Abraham (abraham.manu@gmail.com)
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program; if not, write to the Free Software
+	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef __MANTIS_INPUT_H
+#define __MANTIS_INPUT_H
+
+extern int mantis_input_init(struct mantis_pci *mantis);
+extern void mantis_input_exit(struct mantis_pci *mantis);
+extern void mantis_input_process(struct mantis_pci *mantis, u8 buf[]);
+
+#endif /* __MANTIS_INPUT_H */
diff --git a/drivers/media/dvb/mantis/mantis_uart.c b/drivers/media/dvb/mantis/mantis_uart.c
index f807c8b..f6f343e 100644
--- a/drivers/media/dvb/mantis/mantis_uart.c
+++ b/drivers/media/dvb/mantis/mantis_uart.c
@@ -19,7 +19,6 @@
 */
 
 #include <linux/kernel.h>
-#include <linux/spinlock.h>
 
 #include <linux/signal.h>
 #include <linux/sched.h>
@@ -34,6 +33,7 @@
 #include "mantis_common.h"
 #include "mantis_reg.h"
 #include "mantis_uart.h"
+#include "mantis_input.h"
 
 struct mantis_uart_params {
 	enum mantis_baud	baud_rate;
@@ -90,9 +90,9 @@ int mantis_uart_read(struct mantis_pci *mantis, u8 *data)
 	return 0;
 }
 
-static void mantis_uart_work(struct work_struct *work)
+void mantis_uart_work(unsigned long data)
 {
-	struct mantis_pci *mantis = container_of(work, struct mantis_pci, uart_work);
+	struct mantis_pci *mantis = (struct mantis_pci *) data;
 	struct mantis_hwconfig *config = mantis->hwconfig;
 	u8 buf[16];
 	int i;
@@ -101,8 +101,10 @@ static void mantis_uart_work(struct work_struct *work)
 
 	for (i = 0; i < (config->bytes + 1); i++)
 		dprintk(MANTIS_INFO, 1, "UART BUF:%d <%02x> ", i, buf[i]);
-
 	dprintk(MANTIS_DEBUG, 0, "\n");
+
+	if (config->ir_work)
+		config->ir_work(mantis, buf);
 }
 
 static int mantis_uart_setup(struct mantis_pci *mantis,
@@ -151,10 +153,8 @@ int mantis_uart_init(struct mantis_pci *mantis)
 		rates[params.baud_rate].string,
 		parity[params.parity].string);
 
-	init_waitqueue_head(&mantis->uart_wq);
-	spin_lock_init(&mantis->uart_lock);
-
-	INIT_WORK(&mantis->uart_work, mantis_uart_work);
+	tasklet_init(&mantis->uart_tasklet, mantis_uart_work,
+		(unsigned long) mantis);
 
 	/* disable interrupt */
 	mmwrite(mmread(MANTIS_UART_CTL) & 0xffef, MANTIS_UART_CTL);
@@ -171,7 +171,6 @@ int mantis_uart_init(struct mantis_pci *mantis)
 	mmwrite(mmread(MANTIS_INT_MASK) | 0x800, MANTIS_INT_MASK);
 	mmwrite(mmread(MANTIS_UART_CTL) | MANTIS_UART_RXINT, MANTIS_UART_CTL);
 
-	schedule_work(&mantis->uart_work);
 	dprintk(MANTIS_DEBUG, 1, "UART successfully initialized");
 
 	return 0;
@@ -182,6 +181,5 @@ void mantis_uart_exit(struct mantis_pci *mantis)
 {
 	/* disable interrupt */
 	mmwrite(mmread(MANTIS_UART_CTL) & 0xffef, MANTIS_UART_CTL);
-	flush_work_sync(&mantis->uart_work);
 }
 EXPORT_SYMBOL_GPL(mantis_uart_exit);
diff --git a/drivers/media/dvb/mantis/mantis_vp1041.c b/drivers/media/dvb/mantis/mantis_vp1041.c
index 38a436c..dec4fb1 100644
--- a/drivers/media/dvb/mantis/mantis_vp1041.c
+++ b/drivers/media/dvb/mantis/mantis_vp1041.c
@@ -21,6 +21,8 @@
 #include <linux/signal.h>
 #include <linux/sched.h>
 #include <linux/interrupt.h>
+#include <linux/pci.h>
+
 
 #include "dmxdev.h"
 #include "dvbdev.h"
@@ -29,6 +31,7 @@
 #include "dvb_net.h"
 
 #include "mantis_common.h"
+#include "mantis_input.h"
 #include "mantis_ioc.h"
 #include "mantis_dvb.h"
 #include "mantis_vp1041.h"
@@ -343,6 +346,20 @@ static int vp1041_frontend_init(struct mantis_pci *mantis, struct dvb_frontend *
 	return 0;
 }
 
+static void vp1041_config_init(struct mantis_pci *mantis)
+{
+	struct mantis_hwconfig *config = mantis->hwconfig;
+
+	switch (mantis->pdev->subsystem_vendor) {
+	case TWINHAN_TECHNOLOGIES:
+		if (mantis->pdev->subsystem_device == MANTIS_VP_1041_DVB_S2)
+			config->ir_codes = RC_MAP_TWINHAN_DTV_CAB_CI;
+		break;
+	default:
+		config->ir_codes = RC_MAP_TERRATEC_CINERGY_S2_HD;
+	}
+}
+
 struct mantis_hwconfig vp1041_config = {
 	.model_name	= MANTIS_MODEL_NAME,
 	.dev_type	= MANTIS_DEV_TYPE,
@@ -352,6 +369,9 @@ struct mantis_hwconfig vp1041_config = {
 	.parity		= MANTIS_PARITY_NONE,
 	.bytes		= 0,
 
+	.ir_work	= mantis_input_process,
+
+	.config_init	= vp1041_config_init,
 	.frontend_init	= vp1041_frontend_init,
 	.power		= GPIF_A12,
 	.reset		= GPIF_A13,
diff --git a/drivers/media/dvb/mantis/mantis_vp2033.c b/drivers/media/dvb/mantis/mantis_vp2033.c
index 06da0dd..20a9823 100644
--- a/drivers/media/dvb/mantis/mantis_vp2033.c
+++ b/drivers/media/dvb/mantis/mantis_vp2033.c
@@ -30,6 +30,7 @@
 
 #include "tda1002x.h"
 #include "mantis_common.h"
+#include "mantis_input.h"
 #include "mantis_ioc.h"
 #include "mantis_dvb.h"
 #include "mantis_vp2033.h"
@@ -181,6 +182,9 @@ struct mantis_hwconfig vp2033_config = {
 	.parity		= MANTIS_PARITY_NONE,
 	.bytes		= 0,
 
+	.ir_codes	= RC_MAP_TWINHAN_DTV_CAB_CI,
+	.ir_work	= mantis_input_process,
+
 	.frontend_init	= vp2033_frontend_init,
 	.power		= GPIF_A12,
 	.reset		= GPIF_A13,
diff --git a/drivers/media/dvb/mantis/mantis_vp2040.c b/drivers/media/dvb/mantis/mantis_vp2040.c
index f72b137..8c4da6b 100644
--- a/drivers/media/dvb/mantis/mantis_vp2040.c
+++ b/drivers/media/dvb/mantis/mantis_vp2040.c
@@ -30,6 +30,7 @@
 
 #include "tda1002x.h"
 #include "mantis_common.h"
+#include "mantis_input.h"
 #include "mantis_ioc.h"
 #include "mantis_dvb.h"
 #include "mantis_vp2040.h"
@@ -180,6 +181,9 @@ struct mantis_hwconfig vp2040_config = {
 	.parity		= MANTIS_PARITY_NONE,
 	.bytes		= 0,
 
+	.ir_codes	= RC_MAP_TERRATEC_CINERGY_C_PCI,
+	.ir_work	= mantis_input_process,
+
 	.frontend_init	= vp2040_frontend_init,
 	.power		= GPIF_A12,
 	.reset		= GPIF_A13,
diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index b57fc83..1237262 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -73,6 +73,8 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-streamzap.o \
 			rc-tbs-nec.o \
 			rc-technisat-usb2.o \
+			rc-terratec-cinergy-c-pci.o \
+			rc-terratec-cinergy-s2-hd.o \
 			rc-terratec-cinergy-xs.o \
 			rc-terratec-slim.o \
 			rc-terratec-slim-2.o \
@@ -81,6 +83,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-total-media-in-hand.o \
 			rc-trekstor.o \
 			rc-tt-1500.o \
+			rc-twinhan-dtv-cab-ci.o \
 			rc-twinhan1027.o \
 			rc-videomate-m1f.o \
 			rc-videomate-s350.o \
diff --git a/drivers/media/rc/keymaps/rc-terratec-cinergy-c-pci.c b/drivers/media/rc/keymaps/rc-terratec-cinergy-c-pci.c
new file mode 100644
index 0000000..a381a4c
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-terratec-cinergy-c-pci.c
@@ -0,0 +1,85 @@
+/* keytable for Terratec Cinergy C PCI Remote Controller
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <media/rc-map.h>
+
+static struct rc_map_table terratec_cinergy_c_pci[] = {
+	{ 0x3e, KEY_POWER},
+	{ 0x3d, KEY_1},
+	{ 0x3c, KEY_2},
+	{ 0x3b, KEY_3},
+	{ 0x3a, KEY_4},
+	{ 0x39, KEY_5},
+	{ 0x38, KEY_6},
+	{ 0x37, KEY_7},
+	{ 0x36, KEY_8},
+	{ 0x35, KEY_9},
+	{ 0x34, KEY_VIDEO_NEXT}, /* AV */
+	{ 0x33, KEY_0},
+	{ 0x32, KEY_REFRESH},
+	{ 0x30, KEY_EPG},
+	{ 0x2f, KEY_UP},
+	{ 0x2e, KEY_LEFT},
+	{ 0x2d, KEY_OK},
+	{ 0x2c, KEY_RIGHT},
+	{ 0x2b, KEY_DOWN},
+	{ 0x29, KEY_INFO},
+	{ 0x28, KEY_RED},
+	{ 0x27, KEY_GREEN},
+	{ 0x26, KEY_YELLOW},
+	{ 0x25, KEY_BLUE},
+	{ 0x24, KEY_CHANNELUP},
+	{ 0x23, KEY_VOLUMEUP},
+	{ 0x22, KEY_MUTE},
+	{ 0x21, KEY_VOLUMEDOWN},
+	{ 0x20, KEY_CHANNELDOWN},
+	{ 0x1f, KEY_PAUSE},
+	{ 0x1e, KEY_HOME},
+	{ 0x1d, KEY_MENU}, /* DVD Menu */
+	{ 0x1c, KEY_SUBTITLE},
+	{ 0x1b, KEY_TEXT}, /* Teletext */
+	{ 0x1a, KEY_DELETE},
+	{ 0x19, KEY_TV},
+	{ 0x18, KEY_DVD},
+	{ 0x17, KEY_STOP},
+	{ 0x16, KEY_VIDEO},
+	{ 0x15, KEY_AUDIO}, /* Music */
+	{ 0x14, KEY_SCREEN}, /* Pic */
+	{ 0x13, KEY_PLAY},
+	{ 0x12, KEY_BACK},
+	{ 0x11, KEY_REWIND},
+	{ 0x10, KEY_FASTFORWARD},
+	{ 0x0b, KEY_PREVIOUS},
+	{ 0x07, KEY_RECORD},
+	{ 0x03, KEY_NEXT},
+
+};
+
+static struct rc_map_list terratec_cinergy_c_pci_map = {
+	.map = {
+		.scan    = terratec_cinergy_c_pci,
+		.size    = ARRAY_SIZE(terratec_cinergy_c_pci),
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.name    = RC_MAP_TERRATEC_CINERGY_C_PCI,
+	}
+};
+
+static int __init init_rc_map_terratec_cinergy_c_pci(void)
+{
+	return rc_map_register(&terratec_cinergy_c_pci_map);
+}
+
+static void __exit exit_rc_map_terratec_cinergy_c_pci(void)
+{
+	rc_map_unregister(&terratec_cinergy_c_pci_map);
+}
+
+module_init(init_rc_map_terratec_cinergy_c_pci)
+module_exit(exit_rc_map_terratec_cinergy_c_pci)
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/rc/keymaps/rc-terratec-cinergy-s2-hd.c b/drivers/media/rc/keymaps/rc-terratec-cinergy-s2-hd.c
new file mode 100644
index 0000000..9d59c2e
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-terratec-cinergy-s2-hd.c
@@ -0,0 +1,85 @@
+/* keytable for Terratec Cinergy S2 HD Remote Controller
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <media/rc-map.h>
+
+static struct rc_map_table terratec_cinergy_s2_hd[] = {
+	{ 0x03, KEY_NEXT},               /* >| */
+	{ 0x07, KEY_RECORD},
+	{ 0x0b, KEY_PREVIOUS},           /* |< */
+	{ 0x10, KEY_FASTFORWARD},        /* >> */
+	{ 0x11, KEY_REWIND},             /* << */
+	{ 0x12, KEY_ESC},                /* Back */
+	{ 0x13, KEY_PLAY},
+	{ 0x14, KEY_IMAGES},
+	{ 0x15, KEY_AUDIO},
+	{ 0x16, KEY_MEDIA},              /* Video-Menu */
+	{ 0x17, KEY_STOP},
+	{ 0x18, KEY_DVD},
+	{ 0x19, KEY_TV},
+	{ 0x1a, KEY_DELETE},
+	{ 0x1b, KEY_TEXT},
+	{ 0x1c, KEY_SUBTITLE},
+	{ 0x1d, KEY_MENU},               /* DVD-Menu */
+	{ 0x1e, KEY_HOME},
+	{ 0x1f, KEY_PAUSE},
+	{ 0x20, KEY_CHANNELDOWN},
+	{ 0x21, KEY_VOLUMEDOWN},
+	{ 0x22, KEY_MUTE},
+	{ 0x23, KEY_VOLUMEUP},
+	{ 0x24, KEY_CHANNELUP},
+	{ 0x25, KEY_BLUE},
+	{ 0x26, KEY_YELLOW},
+	{ 0x27, KEY_GREEN},
+	{ 0x28, KEY_RED},
+	{ 0x29, KEY_INFO},
+	{ 0x2b, KEY_DOWN},
+	{ 0x2c, KEY_RIGHT},
+	{ 0x2d, KEY_OK},
+	{ 0x2e, KEY_LEFT},
+	{ 0x2f, KEY_UP},
+	{ 0x30, KEY_EPG},
+	{ 0x32, KEY_VIDEO},              /* A<=>B */
+	{ 0x33, KEY_0},
+	{ 0x34, KEY_VCR},                /* AV */
+	{ 0x35, KEY_9},
+	{ 0x36, KEY_8},
+	{ 0x37, KEY_7},
+	{ 0x38, KEY_6},
+	{ 0x39, KEY_5},
+	{ 0x3a, KEY_4},
+	{ 0x3b, KEY_3},
+	{ 0x3c, KEY_2},
+	{ 0x3d, KEY_1},
+	{ 0x3e, KEY_POWER},
+
+};
+
+static struct rc_map_list terratec_cinergy_s2_hd_map = {
+	.map = {
+		.scan    = terratec_cinergy_s2_hd,
+		.size    = ARRAY_SIZE(terratec_cinergy_s2_hd),
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.name    = RC_MAP_TERRATEC_CINERGY_S2_HD,
+	}
+};
+
+static int __init init_rc_map_terratec_cinergy_s2_hd(void)
+{
+	return rc_map_register(&terratec_cinergy_s2_hd_map);
+}
+
+static void __exit exit_rc_map_terratec_cinergy_s2_hd(void)
+{
+	rc_map_unregister(&terratec_cinergy_s2_hd_map);
+}
+
+module_init(init_rc_map_terratec_cinergy_s2_hd)
+module_exit(exit_rc_map_terratec_cinergy_s2_hd)
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/rc/keymaps/rc-twinhan-dtv-cab-ci.c b/drivers/media/rc/keymaps/rc-twinhan-dtv-cab-ci.c
new file mode 100644
index 0000000..2b30374
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-twinhan-dtv-cab-ci.c
@@ -0,0 +1,95 @@
+/* keytable for Twinhan DTV CAB CI Remote Controller
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <media/rc-map.h>
+
+static struct rc_map_table twinhan_dtv_cab_ci[] = {
+	{ 0x29, KEY_POWER},
+	{ 0x28, KEY_FAVORITES},
+	{ 0x30, KEY_TEXT},
+	{ 0x17, KEY_INFO},              /* Preview */
+	{ 0x23, KEY_EPG},
+	{ 0x3b, KEY_F22},               /* Record List */
+
+	{ 0x3c, KEY_1},
+	{ 0x3e, KEY_2},
+	{ 0x39, KEY_3},
+	{ 0x36, KEY_4},
+	{ 0x22, KEY_5},
+	{ 0x20, KEY_6},
+	{ 0x32, KEY_7},
+	{ 0x26, KEY_8},
+	{ 0x24, KEY_9},
+	{ 0x2a, KEY_0},
+
+	{ 0x33, KEY_CANCEL},
+	{ 0x2c, KEY_BACK},
+	{ 0x15, KEY_CLEAR},
+	{ 0x3f, KEY_TAB},
+	{ 0x10, KEY_ENTER},
+	{ 0x14, KEY_UP},
+	{ 0x0d, KEY_RIGHT},
+	{ 0x0e, KEY_DOWN},
+	{ 0x11, KEY_LEFT},
+
+	{ 0x21, KEY_VOLUMEUP},
+	{ 0x35, KEY_VOLUMEDOWN},
+	{ 0x3d, KEY_CHANNELDOWN},
+	{ 0x3a, KEY_CHANNELUP},
+	{ 0x2e, KEY_RECORD},
+	{ 0x2b, KEY_PLAY},
+	{ 0x13, KEY_PAUSE},
+	{ 0x25, KEY_STOP},
+
+	{ 0x1f, KEY_REWIND},
+	{ 0x2d, KEY_FASTFORWARD},
+	{ 0x1e, KEY_PREVIOUS},          /* Replay |< */
+	{ 0x1d, KEY_NEXT},              /* Skip   >| */
+
+	{ 0x0b, KEY_CAMERA},            /* Capture */
+	{ 0x0f, KEY_LANGUAGE},          /* SAP */
+	{ 0x18, KEY_MODE},              /* PIP */
+	{ 0x12, KEY_ZOOM},              /* Full screen */
+	{ 0x1c, KEY_SUBTITLE},
+	{ 0x2f, KEY_MUTE},
+	{ 0x16, KEY_F20},               /* L/R */
+	{ 0x38, KEY_F21},               /* Hibernate */
+
+	{ 0x37, KEY_SWITCHVIDEOMODE},   /* A/V */
+	{ 0x31, KEY_AGAIN},             /* Recall */
+	{ 0x1a, KEY_KPPLUS},            /* Zoom+ */
+	{ 0x19, KEY_KPMINUS},           /* Zoom- */
+	{ 0x27, KEY_RED},
+	{ 0x0C, KEY_GREEN},
+	{ 0x01, KEY_YELLOW},
+	{ 0x00, KEY_BLUE},
+};
+
+static struct rc_map_list twinhan_dtv_cab_ci_map = {
+	.map = {
+		.scan    = twinhan_dtv_cab_ci,
+		.size    = ARRAY_SIZE(twinhan_dtv_cab_ci),
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.name    = RC_MAP_TWINHAN_DTV_CAB_CI,
+	}
+};
+
+static int __init init_rc_map_twinhan_dtv_cab_ci(void)
+{
+	return rc_map_register(&twinhan_dtv_cab_ci_map);
+}
+
+static void __exit exit_rc_map_twinhan_dtv_cab_ci(void)
+{
+	rc_map_unregister(&twinhan_dtv_cab_ci_map);
+}
+
+module_init(init_rc_map_twinhan_dtv_cab_ci)
+module_exit(exit_rc_map_twinhan_dtv_cab_ci)
+
+MODULE_LICENSE("GPL");
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 4e1409e..8628f07 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -132,6 +132,8 @@ void rc_map_init(void);
 #define RC_MAP_STREAMZAP                 "rc-streamzap"
 #define RC_MAP_TBS_NEC                   "rc-tbs-nec"
 #define RC_MAP_TECHNISAT_USB2            "rc-technisat-usb2"
+#define RC_MAP_TERRATEC_CINERGY_C_PCI    "rc-terratec-cinergy-c-pci"
+#define RC_MAP_TERRATEC_CINERGY_S2_HD    "rc-terratec-cinergy-s2-hd"
 #define RC_MAP_TERRATEC_CINERGY_XS       "rc-terratec-cinergy-xs"
 #define RC_MAP_TERRATEC_SLIM             "rc-terratec-slim"
 #define RC_MAP_TERRATEC_SLIM_2           "rc-terratec-slim-2"
@@ -140,6 +142,7 @@ void rc_map_init(void);
 #define RC_MAP_TOTAL_MEDIA_IN_HAND       "rc-total-media-in-hand"
 #define RC_MAP_TREKSTOR                  "rc-trekstor"
 #define RC_MAP_TT_1500                   "rc-tt-1500"
+#define RC_MAP_TWINHAN_DTV_CAB_CI        "rc-twinhan-dtv-cab-ci"
 #define RC_MAP_TWINHAN_VP1027_DVBS       "rc-twinhan1027"
 #define RC_MAP_VIDEOMATE_M1F             "rc-videomate-m1f"
 #define RC_MAP_VIDEOMATE_S350            "rc-videomate-s350"
-- 
1.7.0.4

