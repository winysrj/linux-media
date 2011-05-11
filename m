Return-path: <mchehab@gaivota>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49495 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756844Ab1EKQmF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2011 12:42:05 -0400
Received: by fxm17 with SMTP id 17so500341fxm.19
        for <linux-media@vger.kernel.org>; Wed, 11 May 2011 09:42:03 -0700 (PDT)
From: "Christoph Pinkl" <christoph.pinkl@gmail.com>
To: "'Adrian C.'" <anrxc@sysphere.org>
Cc: <linux-media@vger.kernel.org>
References: <alpine.LNX.2.00.1105040038430.10167@flfcurer.bet> <4DC431C6.1010605@kolumbus.fi> <alpine.LNX.2.00.1105102329290.12340@flfcurer.bet>
In-Reply-To: <alpine.LNX.2.00.1105102329290.12340@flfcurer.bet>
Subject: AW: Remote control not working for Terratec Cinergy C (2.6.37 Mantis driver)
Date: Wed, 11 May 2011 14:32:34 +0200
Message-ID: <4dca81e5.875bdf0a.32db.07e1@mx.google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0001_01CC0FE8.45AF7DE0"
Content-Language: de-at
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This is a multi-part message in MIME format.

------=_NextPart_000_0001_01CC0FE8.45AF7DE0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello,

I've decided to rework my patch once again and send it to the list.=20
It adds support for Remote-Control in the mantis driver and implements =
the
new rc-API.
The patch enables rc for the cards
- vp1041
- vp2033
- vp2040

It's only tested with a Terratec Cinergy S2 HD

Regards
Chris


I've reworked my patch using at home for=20

> -----Urspr=FCngliche Nachricht-----
> Von: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] Im Auftrag von Adrian C.
> Gesendet: Dienstag, 10. Mai 2011 23:30
> An: linux-media@vger.kernel.org
> Betreff: Re: Remote control not working for Terratec Cinergy C (2.6.37
> Mantis driver)
>=20
> On Fri, 6 May 2011, Marko Ristola wrote:
>=20
> > The hardware device is active (it is enabled, messages are sent from
> > the remote to the Kernel Mantis software driver. The bytes can be
> > logged into /var/log/messages file.
> >
> > That's all the driver is designed to do at this point.
>=20
> It doesn't sound promising. Thanks for the update Marko.
>=20
> --
> Adrian C. (anrxc) | anrxc..sysphere.org | PGP ID: D20A0618
> PGP FP: 02A5 628A D8EE 2A93 996E  929F D5CB 31B7 D20A 0618
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

------=_NextPart_000_0001_01CC0FE8.45AF7DE0
Content-Type: application/octet-stream;
	name="mantis_ir.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mantis_ir.patch"

diff --git a/drivers/media/dvb/mantis/hopper_cards.c =
b/drivers/media/dvb/mantis/hopper_cards.c=0A=
index 1402062..0b76664 100644=0A=
--- a/drivers/media/dvb/mantis/hopper_cards.c=0A=
+++ b/drivers/media/dvb/mantis/hopper_cards.c=0A=
@@ -107,7 +107,7 @@ static irqreturn_t hopper_irq_handler(int irq, void =
*dev_id)=0A=
 	}=0A=
 	if (stat & MANTIS_INT_IRQ1) {=0A=
 		dprintk(MANTIS_DEBUG, 0, "<%s>", label[2]);=0A=
-		schedule_work(&mantis->uart_work);=0A=
+		tasklet_schedule(&mantis->uart_tasklet);=0A=
 	}=0A=
 	if (stat & MANTIS_INT_OCERR) {=0A=
 		dprintk(MANTIS_DEBUG, 0, "<%s>", label[3]);=0A=
diff --git a/drivers/media/dvb/mantis/mantis_cards.c =
b/drivers/media/dvb/mantis/mantis_cards.c=0A=
index 05cbb9d..b859d05 100644=0A=
--- a/drivers/media/dvb/mantis/mantis_cards.c=0A=
+++ b/drivers/media/dvb/mantis/mantis_cards.c=0A=
@@ -49,6 +49,7 @@=0A=
 #include "mantis_pci.h"=0A=
 #include "mantis_i2c.h"=0A=
 #include "mantis_reg.h"=0A=
+#include "mantis_input.h"=0A=
 =0A=
 static unsigned int verbose;=0A=
 module_param(verbose, int, 0644);=0A=
@@ -115,7 +116,7 @@ static irqreturn_t mantis_irq_handler(int irq, void =
*dev_id)=0A=
 	}=0A=
 	if (stat & MANTIS_INT_IRQ1) {=0A=
 		dprintk(MANTIS_DEBUG, 0, "<%s>", label[2]);=0A=
-		schedule_work(&mantis->uart_work);=0A=
+		tasklet_schedule(&mantis->uart_tasklet);=0A=
 	}=0A=
 	if (stat & MANTIS_INT_OCERR) {=0A=
 		dprintk(MANTIS_DEBUG, 0, "<%s>", label[3]);=0A=
@@ -215,21 +216,32 @@ static int __devinit mantis_pci_probe(struct =
pci_dev *pdev, const struct pci_dev=0A=
 		dprintk(MANTIS_ERROR, 1, "ERROR: Mantis DVB initialization failed =
<%d>", err);=0A=
 		goto fail4;=0A=
 	}=0A=
+=0A=
+	err =3D mantis_input_init(mantis);=0A=
+	if (err < 0) {=0A=
+		dprintk(MANTIS_ERROR, 1, "ERROR: Mantis INPUT initialization failed =
<%d>", err);=0A=
+		goto fail6;=0A=
+	}=0A=
+=0A=
+=0A=
 	err =3D mantis_uart_init(mantis);=0A=
 	if (err < 0) {=0A=
 		dprintk(MANTIS_ERROR, 1, "ERROR: Mantis UART initialization failed =
<%d>", err);=0A=
-		goto fail6;=0A=
+		goto fail7;=0A=
 	}=0A=
 =0A=
 	devs++;=0A=
 =0A=
 	return err;=0A=
 =0A=
-=0A=
+fail7:=0A=
 	dprintk(MANTIS_ERROR, 1, "ERROR: Mantis UART exit! <%d>", err);=0A=
 	mantis_uart_exit(mantis);=0A=
 =0A=
 fail6:=0A=
+	dprintk(MANTIS_ERROR, 1, "ERROR: Mantis INPUT exit! <%d>", err);=0A=
+	mantis_input_exit(mantis);=0A=
+=0A=
 fail4:=0A=
 	dprintk(MANTIS_ERROR, 1, "ERROR: Mantis DMA exit! <%d>", err);=0A=
 	mantis_dma_exit(mantis);=0A=
@@ -257,6 +269,7 @@ static void __devexit mantis_pci_remove(struct =
pci_dev *pdev)=0A=
 	if (mantis) {=0A=
 =0A=
 		mantis_uart_exit(mantis);=0A=
+		mantis_input_exit(mantis);=0A=
 		mantis_dvb_exit(mantis);=0A=
 		mantis_dma_exit(mantis);=0A=
 		mantis_i2c_exit(mantis);=0A=
diff --git a/drivers/media/dvb/mantis/mantis_common.h =
b/drivers/media/dvb/mantis/mantis_common.h=0A=
index bd400d2..181fdc6 100644=0A=
--- a/drivers/media/dvb/mantis/mantis_common.h=0A=
+++ b/drivers/media/dvb/mantis/mantis_common.h=0A=
@@ -23,6 +23,9 @@=0A=
 =0A=
 #include <linux/mutex.h>=0A=
 #include <linux/workqueue.h>=0A=
+#include <linux/input.h>=0A=
+#include <linux/spinlock.h>=0A=
+#include <media/rc-core.h>=0A=
 =0A=
 #include "mantis_uart.h"=0A=
 =0A=
@@ -91,6 +94,9 @@ struct mantis_hwconfig {=0A=
 	enum mantis_parity	parity;=0A=
 	u32			bytes;=0A=
 =0A=
+	char			*ir_codes;=0A=
+	void (*ir_work)(struct mantis_pci *mantis, u8 buf[]);=0A=
+=0A=
 	irqreturn_t (*irq_handler)(int irq, void *dev_id);=0A=
 	int (*frontend_init)(struct mantis_pci *mantis, struct dvb_frontend =
*fe);=0A=
 =0A=
@@ -100,6 +106,12 @@ struct mantis_hwconfig {=0A=
 	enum mantis_i2c_mode	i2c_mode;=0A=
 };=0A=
 =0A=
+struct mantis_ir {=0A=
+	struct rc_dev		*rc_dev;=0A=
+	char			rc_name[80];=0A=
+	char			rc_phys[80];=0A=
+};=0A=
+=0A=
 struct mantis_pci {=0A=
 	unsigned int		verbose;=0A=
 =0A=
@@ -167,13 +179,11 @@ struct mantis_pci {=0A=
 =0A=
 	struct mantis_ca	*mantis_ca;=0A=
 =0A=
-	wait_queue_head_t	uart_wq;=0A=
-	struct work_struct	uart_work;=0A=
-	spinlock_t		uart_lock;=0A=
+	struct tasklet_struct	uart_tasklet;=0A=
+=0A=
+	/* Remote Control handling */=0A=
+	struct mantis_ir	rc;=0A=
 =0A=
-	struct rc_dev		*rc;=0A=
-	char			input_name[80];=0A=
-	char			input_phys[80];=0A=
 };=0A=
 =0A=
 #define MANTIS_HIF_STATUS	(mantis->gpio_status)=0A=
diff --git a/drivers/media/dvb/mantis/mantis_input.c =
b/drivers/media/dvb/mantis/mantis_input.c=0A=
index db6d54d..3e32121 100644=0A=
--- a/drivers/media/dvb/mantis/mantis_input.c=0A=
+++ b/drivers/media/dvb/mantis/mantis_input.c=0A=
@@ -18,7 +18,6 @@=0A=
 	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.=0A=
 */=0A=
 =0A=
-#include <media/rc-core.h>=0A=
 #include <linux/pci.h>=0A=
 =0A=
 #include "dmxdev.h"=0A=
@@ -28,132 +27,88 @@=0A=
 #include "dvb_net.h"=0A=
 =0A=
 #include "mantis_common.h"=0A=
+#include "mantis_input.h"=0A=
 #include "mantis_reg.h"=0A=
 #include "mantis_uart.h"=0A=
 =0A=
 #define MODULE_NAME "mantis_core"=0A=
-#define RC_MAP_MANTIS "rc-mantis"=0A=
-=0A=
-static struct rc_map_table mantis_ir_table[] =3D {=0A=
-	{ 0x29, KEY_POWER	},=0A=
-	{ 0x28, KEY_FAVORITES	},=0A=
-	{ 0x30, KEY_TEXT	},=0A=
-	{ 0x17, KEY_INFO	}, /* Preview */=0A=
-	{ 0x23, KEY_EPG		},=0A=
-	{ 0x3b, KEY_F22		}, /* Record List */=0A=
-	{ 0x3c, KEY_1		},=0A=
-	{ 0x3e, KEY_2		},=0A=
-	{ 0x39, KEY_3		},=0A=
-	{ 0x36, KEY_4		},=0A=
-	{ 0x22, KEY_5		},=0A=
-	{ 0x20, KEY_6		},=0A=
-	{ 0x32, KEY_7		},=0A=
-	{ 0x26, KEY_8		},=0A=
-	{ 0x24, KEY_9		},=0A=
-	{ 0x2a, KEY_0		},=0A=
-=0A=
-	{ 0x33, KEY_CANCEL	},=0A=
-	{ 0x2c, KEY_BACK	},=0A=
-	{ 0x15, KEY_CLEAR	},=0A=
-	{ 0x3f, KEY_TAB		},=0A=
-	{ 0x10, KEY_ENTER	},=0A=
-	{ 0x14, KEY_UP		},=0A=
-	{ 0x0d, KEY_RIGHT	},=0A=
-	{ 0x0e, KEY_DOWN	},=0A=
-	{ 0x11, KEY_LEFT	},=0A=
-=0A=
-	{ 0x21, KEY_VOLUMEUP	},=0A=
-	{ 0x35, KEY_VOLUMEDOWN	},=0A=
-	{ 0x3d, KEY_CHANNELDOWN	},=0A=
-	{ 0x3a, KEY_CHANNELUP	},=0A=
-	{ 0x2e, KEY_RECORD	},=0A=
-	{ 0x2b, KEY_PLAY	},=0A=
-	{ 0x13, KEY_PAUSE	},=0A=
-	{ 0x25, KEY_STOP	},=0A=
-=0A=
-	{ 0x1f, KEY_REWIND	},=0A=
-	{ 0x2d, KEY_FASTFORWARD	},=0A=
-	{ 0x1e, KEY_PREVIOUS	}, /* Replay |< */=0A=
-	{ 0x1d, KEY_NEXT	}, /* Skip   >| */=0A=
-=0A=
-	{ 0x0b, KEY_CAMERA	}, /* Capture */=0A=
-	{ 0x0f, KEY_LANGUAGE	}, /* SAP */=0A=
-	{ 0x18, KEY_MODE	}, /* PIP */=0A=
-	{ 0x12, KEY_ZOOM	}, /* Full screen */=0A=
-	{ 0x1c, KEY_SUBTITLE	},=0A=
-	{ 0x2f, KEY_MUTE	},=0A=
-	{ 0x16, KEY_F20		}, /* L/R */=0A=
-	{ 0x38, KEY_F21		}, /* Hibernate */=0A=
-=0A=
-	{ 0x37, KEY_SWITCHVIDEOMODE }, /* A/V */=0A=
-	{ 0x31, KEY_AGAIN	}, /* Recall */=0A=
-	{ 0x1a, KEY_KPPLUS	}, /* Zoom+ */=0A=
-	{ 0x19, KEY_KPMINUS	}, /* Zoom- */=0A=
-	{ 0x27, KEY_RED		},=0A=
-	{ 0x0C, KEY_GREEN	},=0A=
-	{ 0x01, KEY_YELLOW	},=0A=
-	{ 0x00, KEY_BLUE	},=0A=
-};=0A=
-=0A=
-static struct rc_map_list ir_mantis_map =3D {=0A=
-	.map =3D {=0A=
-		.scan =3D mantis_ir_table,=0A=
-		.size =3D ARRAY_SIZE(mantis_ir_table),=0A=
-		.rc_type =3D RC_TYPE_UNKNOWN,=0A=
-		.name =3D RC_MAP_MANTIS,=0A=
-	}=0A=
-};=0A=
 =0A=
 int mantis_input_init(struct mantis_pci *mantis)=0A=
 {=0A=
-	struct rc_dev *dev;=0A=
+	struct rc_dev *rc_dev;=0A=
+	struct mantis_ir *mir =3D &mantis->rc;=0A=
 	int err;=0A=
 =0A=
-	err =3D rc_map_register(&ir_mantis_map);=0A=
-	if (err)=0A=
-		goto out;=0A=
 =0A=
-	dev =3D rc_allocate_device();=0A=
-	if (!dev) {=0A=
-		dprintk(MANTIS_ERROR, 1, "Remote device allocation failed");=0A=
-		err =3D -ENOMEM;=0A=
-		goto out_map;=0A=
+	if (!mantis->hwconfig->ir_codes) {=0A=
+		dprintk(MANTIS_DEBUG, 1, "No RC codes available");=0A=
+		return 0;=0A=
 	}=0A=
 =0A=
-	sprintf(mantis->input_name, "Mantis %s IR receiver", =
mantis->hwconfig->model_name);=0A=
-	sprintf(mantis->input_phys, "pci-%s/ir0", pci_name(mantis->pdev));=0A=
-=0A=
-	dev->input_name         =3D mantis->input_name;=0A=
-	dev->input_phys         =3D mantis->input_phys;=0A=
-	dev->input_id.bustype   =3D BUS_PCI;=0A=
-	dev->input_id.vendor    =3D mantis->vendor_id;=0A=
-	dev->input_id.product   =3D mantis->device_id;=0A=
-	dev->input_id.version   =3D 1;=0A=
-	dev->driver_name        =3D MODULE_NAME;=0A=
-	dev->map_name           =3D RC_MAP_MANTIS;=0A=
-	dev->dev.parent         =3D &mantis->pdev->dev;=0A=
+	rc_dev =3D rc_allocate_device();=0A=
+	if (!rc_dev) {=0A=
+		dprintk(MANTIS_ERROR, 1, "Input device allocate failed");=0A=
+		return -ENOMEM;=0A=
+	}=0A=
 =0A=
-	err =3D rc_register_device(dev);=0A=
+	mir->rc_dev =3D rc_dev;=0A=
+=0A=
+	snprintf(mir->rc_name, sizeof(mir->rc_name),=0A=
+		"Mantis %s IR Receiver", mantis->hwconfig->model_name);=0A=
+	snprintf(mir->rc_phys, sizeof(mir->rc_phys),=0A=
+		"pci-%s/ir0", pci_name(mantis->pdev));=0A=
+=0A=
+	dprintk(MANTIS_ERROR, 1, "Input device %s PCI: %s",=0A=
+		mir->rc_name, mir->rc_phys);=0A=
+=0A=
+	rc_dev->input_name =3D mir->rc_name;=0A=
+	rc_dev->input_phys =3D mir->rc_phys;=0A=
+	rc_dev->input_id.bustype =3D BUS_PCI;=0A=
+	rc_dev->input_id.vendor	=3D mantis->vendor_id;=0A=
+	rc_dev->input_id.product =3D mantis->device_id;=0A=
+	rc_dev->input_id.version =3D 1;=0A=
+	rc_dev->priv =3D mir;=0A=
+	rc_dev->driver_name =3D MODULE_NAME;=0A=
+	rc_dev->driver_type =3D RC_DRIVER_SCANCODE;=0A=
+	rc_dev->map_name =3D mantis->hwconfig->ir_codes;=0A=
+	rc_dev->allowed_protos =3D RC_TYPE_UNKNOWN;=0A=
+=0A=
+	err =3D rc_register_device(rc_dev);=0A=
 	if (err) {=0A=
 		dprintk(MANTIS_ERROR, 1, "IR device registration failed, ret =3D %d", =
err);=0A=
-		goto out_dev;=0A=
+		mir->rc_dev =3D NULL;=0A=
+		rc_free_device(rc_dev);=0A=
+		return -ENODEV;=0A=
 	}=0A=
 =0A=
-	mantis->rc =3D dev;=0A=
+	dprintk(MANTIS_INFO, 1, "Input device registered");=0A=
 	return 0;=0A=
-=0A=
-out_dev:=0A=
-	rc_free_device(dev);=0A=
-out_map:=0A=
-	rc_map_unregister(&ir_mantis_map);=0A=
-out:=0A=
-	return err;=0A=
 }=0A=
+EXPORT_SYMBOL_GPL(mantis_input_init);=0A=
 =0A=
-int mantis_exit(struct mantis_pci *mantis)=0A=
+void mantis_input_exit(struct mantis_pci *mantis)=0A=
 {=0A=
-	rc_unregister_device(mantis->rc);=0A=
-	rc_map_unregister(&ir_mantis_map);=0A=
-	return 0;=0A=
+	struct rc_dev *rc_dev =3D mantis->rc.rc_dev;=0A=
+=0A=
+	if (!rc_dev)=0A=
+		return;=0A=
+=0A=
+	rc_unregister_device(rc_dev);=0A=
+	mantis->rc.rc_dev =3D NULL;=0A=
 }=0A=
+EXPORT_SYMBOL_GPL(mantis_input_exit);=0A=
 =0A=
+void mantis_input_process(struct mantis_pci *mantis, u8 buf[])=0A=
+{=0A=
+	struct mantis_hwconfig *config =3D mantis->hwconfig;=0A=
+	struct mantis_ir *mir =3D &mantis->rc;=0A=
+	int i;=0A=
+=0A=
+	for (i =3D 0; i < (config->bytes + 1); i++) {=0A=
+		dprintk(MANTIS_ERROR, 0, "RC Input Sendkey:%d <%02x>\n", i, buf[i]);=0A=
+		rc_keydown(mir->rc_dev, buf[i], 0);=0A=
+		rc_keyup(mir->rc_dev);=0A=
+	}=0A=
+=0A=
+}=0A=
+EXPORT_SYMBOL_GPL(mantis_input_process);=0A=
diff --git a/drivers/media/dvb/mantis/mantis_input.h =
b/drivers/media/dvb/mantis/mantis_input.h=0A=
new file mode 100644=0A=
index 0000000..a00666f=0A=
--- /dev/null=0A=
+++ b/drivers/media/dvb/mantis/mantis_input.h=0A=
@@ -0,0 +1,28 @@=0A=
+/*=0A=
+	Mantis PCI bridge driver=0A=
+=0A=
+	Copyright (C) Manu Abraham (abraham.manu@gmail.com)=0A=
+=0A=
+	This program is free software; you can redistribute it and/or modify=0A=
+	it under the terms of the GNU General Public License as published by=0A=
+	the Free Software Foundation; either version 2 of the License, or=0A=
+	(at your option) any later version.=0A=
+=0A=
+	This program is distributed in the hope that it will be useful,=0A=
+	but WITHOUT ANY WARRANTY; without even the implied warranty of=0A=
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the=0A=
+	GNU General Public License for more details.=0A=
+=0A=
+	You should have received a copy of the GNU General Public License=0A=
+	along with this program; if not, write to the Free Software=0A=
+	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.=0A=
+ */=0A=
+=0A=
+#ifndef __MANTIS_INPUT_H=0A=
+#define __MANTIS_INPUT_H=0A=
+=0A=
+extern int mantis_input_init(struct mantis_pci *mantis);=0A=
+extern void mantis_input_exit(struct mantis_pci *mantis);=0A=
+extern void mantis_input_process(struct mantis_pci *mantis, u8 buf[]);=0A=
+=0A=
+#endif /* __MANTIS_INPUT_H */=0A=
diff --git a/drivers/media/dvb/mantis/mantis_uart.c =
b/drivers/media/dvb/mantis/mantis_uart.c=0A=
index f807c8b..f6f343e 100644=0A=
--- a/drivers/media/dvb/mantis/mantis_uart.c=0A=
+++ b/drivers/media/dvb/mantis/mantis_uart.c=0A=
@@ -19,7 +19,6 @@=0A=
 */=0A=
 =0A=
 #include <linux/kernel.h>=0A=
-#include <linux/spinlock.h>=0A=
 =0A=
 #include <linux/signal.h>=0A=
 #include <linux/sched.h>=0A=
@@ -34,6 +33,7 @@=0A=
 #include "mantis_common.h"=0A=
 #include "mantis_reg.h"=0A=
 #include "mantis_uart.h"=0A=
+#include "mantis_input.h"=0A=
 =0A=
 struct mantis_uart_params {=0A=
 	enum mantis_baud	baud_rate;=0A=
@@ -90,9 +90,9 @@ int mantis_uart_read(struct mantis_pci *mantis, u8 =
*data)=0A=
 	return 0;=0A=
 }=0A=
 =0A=
-static void mantis_uart_work(struct work_struct *work)=0A=
+void mantis_uart_work(unsigned long data)=0A=
 {=0A=
-	struct mantis_pci *mantis =3D container_of(work, struct mantis_pci, =
uart_work);=0A=
+	struct mantis_pci *mantis =3D (struct mantis_pci *) data;=0A=
 	struct mantis_hwconfig *config =3D mantis->hwconfig;=0A=
 	u8 buf[16];=0A=
 	int i;=0A=
@@ -101,8 +101,10 @@ static void mantis_uart_work(struct work_struct =
*work)=0A=
 =0A=
 	for (i =3D 0; i < (config->bytes + 1); i++)=0A=
 		dprintk(MANTIS_INFO, 1, "UART BUF:%d <%02x> ", i, buf[i]);=0A=
-=0A=
 	dprintk(MANTIS_DEBUG, 0, "\n");=0A=
+=0A=
+	if (config->ir_work)=0A=
+		config->ir_work(mantis, buf);=0A=
 }=0A=
 =0A=
 static int mantis_uart_setup(struct mantis_pci *mantis,=0A=
@@ -151,10 +153,8 @@ int mantis_uart_init(struct mantis_pci *mantis)=0A=
 		rates[params.baud_rate].string,=0A=
 		parity[params.parity].string);=0A=
 =0A=
-	init_waitqueue_head(&mantis->uart_wq);=0A=
-	spin_lock_init(&mantis->uart_lock);=0A=
-=0A=
-	INIT_WORK(&mantis->uart_work, mantis_uart_work);=0A=
+	tasklet_init(&mantis->uart_tasklet, mantis_uart_work,=0A=
+		(unsigned long) mantis);=0A=
 =0A=
 	/* disable interrupt */=0A=
 	mmwrite(mmread(MANTIS_UART_CTL) & 0xffef, MANTIS_UART_CTL);=0A=
@@ -171,7 +171,6 @@ int mantis_uart_init(struct mantis_pci *mantis)=0A=
 	mmwrite(mmread(MANTIS_INT_MASK) | 0x800, MANTIS_INT_MASK);=0A=
 	mmwrite(mmread(MANTIS_UART_CTL) | MANTIS_UART_RXINT, MANTIS_UART_CTL);=0A=
 =0A=
-	schedule_work(&mantis->uart_work);=0A=
 	dprintk(MANTIS_DEBUG, 1, "UART successfully initialized");=0A=
 =0A=
 	return 0;=0A=
@@ -182,6 +181,5 @@ void mantis_uart_exit(struct mantis_pci *mantis)=0A=
 {=0A=
 	/* disable interrupt */=0A=
 	mmwrite(mmread(MANTIS_UART_CTL) & 0xffef, MANTIS_UART_CTL);=0A=
-	flush_work_sync(&mantis->uart_work);=0A=
 }=0A=
 EXPORT_SYMBOL_GPL(mantis_uart_exit);=0A=
diff --git a/drivers/media/dvb/mantis/mantis_vp1041.c =
b/drivers/media/dvb/mantis/mantis_vp1041.c=0A=
index 38a436c..34da04a 100644=0A=
--- a/drivers/media/dvb/mantis/mantis_vp1041.c=0A=
+++ b/drivers/media/dvb/mantis/mantis_vp1041.c=0A=
@@ -29,6 +29,7 @@=0A=
 #include "dvb_net.h"=0A=
 =0A=
 #include "mantis_common.h"=0A=
+#include "mantis_input.h"=0A=
 #include "mantis_ioc.h"=0A=
 #include "mantis_dvb.h"=0A=
 #include "mantis_vp1041.h"=0A=
@@ -352,6 +353,9 @@ struct mantis_hwconfig vp1041_config =3D {=0A=
 	.parity		=3D MANTIS_PARITY_NONE,=0A=
 	.bytes		=3D 0,=0A=
 =0A=
+	.ir_codes	=3D RC_MAP_TERRATEC_CINERGY_S2_HD,=0A=
+	.ir_work	=3D mantis_input_process,=0A=
+=0A=
 	.frontend_init	=3D vp1041_frontend_init,=0A=
 	.power		=3D GPIF_A12,=0A=
 	.reset		=3D GPIF_A13,=0A=
diff --git a/drivers/media/dvb/mantis/mantis_vp2033.c =
b/drivers/media/dvb/mantis/mantis_vp2033.c=0A=
index 06da0dd..20a9823 100644=0A=
--- a/drivers/media/dvb/mantis/mantis_vp2033.c=0A=
+++ b/drivers/media/dvb/mantis/mantis_vp2033.c=0A=
@@ -30,6 +30,7 @@=0A=
 =0A=
 #include "tda1002x.h"=0A=
 #include "mantis_common.h"=0A=
+#include "mantis_input.h"=0A=
 #include "mantis_ioc.h"=0A=
 #include "mantis_dvb.h"=0A=
 #include "mantis_vp2033.h"=0A=
@@ -181,6 +182,9 @@ struct mantis_hwconfig vp2033_config =3D {=0A=
 	.parity		=3D MANTIS_PARITY_NONE,=0A=
 	.bytes		=3D 0,=0A=
 =0A=
+	.ir_codes	=3D RC_MAP_TWINHAN_DTV_CAB_CI,=0A=
+	.ir_work	=3D mantis_input_process,=0A=
+=0A=
 	.frontend_init	=3D vp2033_frontend_init,=0A=
 	.power		=3D GPIF_A12,=0A=
 	.reset		=3D GPIF_A13,=0A=
diff --git a/drivers/media/dvb/mantis/mantis_vp2040.c =
b/drivers/media/dvb/mantis/mantis_vp2040.c=0A=
index f72b137..8c4da6b 100644=0A=
--- a/drivers/media/dvb/mantis/mantis_vp2040.c=0A=
+++ b/drivers/media/dvb/mantis/mantis_vp2040.c=0A=
@@ -30,6 +30,7 @@=0A=
 =0A=
 #include "tda1002x.h"=0A=
 #include "mantis_common.h"=0A=
+#include "mantis_input.h"=0A=
 #include "mantis_ioc.h"=0A=
 #include "mantis_dvb.h"=0A=
 #include "mantis_vp2040.h"=0A=
@@ -180,6 +181,9 @@ struct mantis_hwconfig vp2040_config =3D {=0A=
 	.parity		=3D MANTIS_PARITY_NONE,=0A=
 	.bytes		=3D 0,=0A=
 =0A=
+	.ir_codes	=3D RC_MAP_TERRATEC_CINERGY_C_PCI,=0A=
+	.ir_work	=3D mantis_input_process,=0A=
+=0A=
 	.frontend_init	=3D vp2040_frontend_init,=0A=
 	.power		=3D GPIF_A12,=0A=
 	.reset		=3D GPIF_A13,=0A=
diff --git a/drivers/media/rc/keymaps/Makefile =
b/drivers/media/rc/keymaps/Makefile=0A=
index b57fc83..1237262 100644=0A=
--- a/drivers/media/rc/keymaps/Makefile=0A=
+++ b/drivers/media/rc/keymaps/Makefile=0A=
@@ -73,6 +73,8 @@ obj-$(CONFIG_RC_MAP) +=3D rc-adstech-dvb-t-pci.o \=0A=
 			rc-streamzap.o \=0A=
 			rc-tbs-nec.o \=0A=
 			rc-technisat-usb2.o \=0A=
+			rc-terratec-cinergy-c-pci.o \=0A=
+			rc-terratec-cinergy-s2-hd.o \=0A=
 			rc-terratec-cinergy-xs.o \=0A=
 			rc-terratec-slim.o \=0A=
 			rc-terratec-slim-2.o \=0A=
@@ -81,6 +83,7 @@ obj-$(CONFIG_RC_MAP) +=3D rc-adstech-dvb-t-pci.o \=0A=
 			rc-total-media-in-hand.o \=0A=
 			rc-trekstor.o \=0A=
 			rc-tt-1500.o \=0A=
+			rc-twinhan-dtv-cab-ci.o \=0A=
 			rc-twinhan1027.o \=0A=
 			rc-videomate-m1f.o \=0A=
 			rc-videomate-s350.o \=0A=
diff --git a/drivers/media/rc/keymaps/rc-terratec-cinergy-c-pci.c =
b/drivers/media/rc/keymaps/rc-terratec-cinergy-c-pci.c=0A=
new file mode 100644=0A=
index 0000000..a381a4c=0A=
--- /dev/null=0A=
+++ b/drivers/media/rc/keymaps/rc-terratec-cinergy-c-pci.c=0A=
@@ -0,0 +1,85 @@=0A=
+/* keytable for Terratec Cinergy C PCI Remote Controller=0A=
+ *=0A=
+ * This program is free software; you can redistribute it and/or modify=0A=
+ * it under the terms of the GNU General Public License as published by=0A=
+ * the Free Software Foundation; either version 2 of the License, or=0A=
+ * (at your option) any later version.=0A=
+ */=0A=
+=0A=
+#include <media/rc-map.h>=0A=
+=0A=
+static struct rc_map_table terratec_cinergy_c_pci[] =3D {=0A=
+	{ 0x3e, KEY_POWER},=0A=
+	{ 0x3d, KEY_1},=0A=
+	{ 0x3c, KEY_2},=0A=
+	{ 0x3b, KEY_3},=0A=
+	{ 0x3a, KEY_4},=0A=
+	{ 0x39, KEY_5},=0A=
+	{ 0x38, KEY_6},=0A=
+	{ 0x37, KEY_7},=0A=
+	{ 0x36, KEY_8},=0A=
+	{ 0x35, KEY_9},=0A=
+	{ 0x34, KEY_VIDEO_NEXT}, /* AV */=0A=
+	{ 0x33, KEY_0},=0A=
+	{ 0x32, KEY_REFRESH},=0A=
+	{ 0x30, KEY_EPG},=0A=
+	{ 0x2f, KEY_UP},=0A=
+	{ 0x2e, KEY_LEFT},=0A=
+	{ 0x2d, KEY_OK},=0A=
+	{ 0x2c, KEY_RIGHT},=0A=
+	{ 0x2b, KEY_DOWN},=0A=
+	{ 0x29, KEY_INFO},=0A=
+	{ 0x28, KEY_RED},=0A=
+	{ 0x27, KEY_GREEN},=0A=
+	{ 0x26, KEY_YELLOW},=0A=
+	{ 0x25, KEY_BLUE},=0A=
+	{ 0x24, KEY_CHANNELUP},=0A=
+	{ 0x23, KEY_VOLUMEUP},=0A=
+	{ 0x22, KEY_MUTE},=0A=
+	{ 0x21, KEY_VOLUMEDOWN},=0A=
+	{ 0x20, KEY_CHANNELDOWN},=0A=
+	{ 0x1f, KEY_PAUSE},=0A=
+	{ 0x1e, KEY_HOME},=0A=
+	{ 0x1d, KEY_MENU}, /* DVD Menu */=0A=
+	{ 0x1c, KEY_SUBTITLE},=0A=
+	{ 0x1b, KEY_TEXT}, /* Teletext */=0A=
+	{ 0x1a, KEY_DELETE},=0A=
+	{ 0x19, KEY_TV},=0A=
+	{ 0x18, KEY_DVD},=0A=
+	{ 0x17, KEY_STOP},=0A=
+	{ 0x16, KEY_VIDEO},=0A=
+	{ 0x15, KEY_AUDIO}, /* Music */=0A=
+	{ 0x14, KEY_SCREEN}, /* Pic */=0A=
+	{ 0x13, KEY_PLAY},=0A=
+	{ 0x12, KEY_BACK},=0A=
+	{ 0x11, KEY_REWIND},=0A=
+	{ 0x10, KEY_FASTFORWARD},=0A=
+	{ 0x0b, KEY_PREVIOUS},=0A=
+	{ 0x07, KEY_RECORD},=0A=
+	{ 0x03, KEY_NEXT},=0A=
+=0A=
+};=0A=
+=0A=
+static struct rc_map_list terratec_cinergy_c_pci_map =3D {=0A=
+	.map =3D {=0A=
+		.scan    =3D terratec_cinergy_c_pci,=0A=
+		.size    =3D ARRAY_SIZE(terratec_cinergy_c_pci),=0A=
+		.rc_type =3D RC_TYPE_UNKNOWN,	/* Legacy IR type */=0A=
+		.name    =3D RC_MAP_TERRATEC_CINERGY_C_PCI,=0A=
+	}=0A=
+};=0A=
+=0A=
+static int __init init_rc_map_terratec_cinergy_c_pci(void)=0A=
+{=0A=
+	return rc_map_register(&terratec_cinergy_c_pci_map);=0A=
+}=0A=
+=0A=
+static void __exit exit_rc_map_terratec_cinergy_c_pci(void)=0A=
+{=0A=
+	rc_map_unregister(&terratec_cinergy_c_pci_map);=0A=
+}=0A=
+=0A=
+module_init(init_rc_map_terratec_cinergy_c_pci)=0A=
+module_exit(exit_rc_map_terratec_cinergy_c_pci)=0A=
+=0A=
+MODULE_LICENSE("GPL");=0A=
diff --git a/drivers/media/rc/keymaps/rc-terratec-cinergy-s2-hd.c =
b/drivers/media/rc/keymaps/rc-terratec-cinergy-s2-hd.c=0A=
new file mode 100644=0A=
index 0000000..56fa27f=0A=
--- /dev/null=0A=
+++ b/drivers/media/rc/keymaps/rc-terratec-cinergy-s2-hd.c=0A=
@@ -0,0 +1,85 @@=0A=
+/* keytable for Terratec Cinergy S2 HD Remote Controller=0A=
+ *=0A=
+ * This program is free software; you can redistribute it and/or modify=0A=
+ * it under the terms of the GNU General Public License as published by=0A=
+ * the Free Software Foundation; either version 2 of the License, or=0A=
+ * (at your option) any later version.=0A=
+ */=0A=
+=0A=
+#include <media/rc-map.h>=0A=
+=0A=
+static struct rc_map_table terratec_cinergy_s2_hd[] =3D {=0A=
+	{ 0x03, KEY_NEXT},=0A=
+	{ 0x07, KEY_RECORD},=0A=
+	{ 0x0b, KEY_PREVIOUS},=0A=
+	{ 0x10, KEY_FASTFORWARD},=0A=
+	{ 0x11, KEY_REWIND},=0A=
+	{ 0x12, KEY_BACK},=0A=
+	{ 0x13, KEY_PLAYCD},=0A=
+	{ 0x14, KEY_F9},                /* DVD-Menu */=0A=
+	{ 0x15, KEY_AUDIO},=0A=
+	{ 0x16, KEY_VIDEO},=0A=
+	{ 0x17, KEY_STOPCD},=0A=
+	{ 0x18, KEY_DVD},=0A=
+	{ 0x19, KEY_TV},=0A=
+	{ 0x1a, KEY_DELETE},=0A=
+	{ 0x1b, KEY_TEXT},=0A=
+	{ 0x1c, KEY_SUBTITLE},=0A=
+	{ 0x1d, KEY_F10},               /* Photos */=0A=
+	{ 0x1e, KEY_HOME},=0A=
+	{ 0x1f, KEY_PAUSECD},=0A=
+	{ 0x20, KEY_CHANNELDOWN},=0A=
+	{ 0x21, KEY_VOLUMEDOWN},=0A=
+	{ 0x22, KEY_MUTE},=0A=
+	{ 0x23, KEY_VOLUMEUP},=0A=
+	{ 0x24, KEY_CHANNELUP},=0A=
+	{ 0x25, KEY_BLUE},=0A=
+	{ 0x26, KEY_YELLOW},=0A=
+	{ 0x27, KEY_GREEN},=0A=
+	{ 0x28, KEY_RED},=0A=
+	{ 0x29, KEY_INFO},=0A=
+	{ 0x2b, KEY_DOWN},=0A=
+	{ 0x2c, KEY_RIGHT},=0A=
+	{ 0x2d, KEY_ENTER},=0A=
+	{ 0x2e, KEY_LEFT},=0A=
+	{ 0x2f, KEY_UP},=0A=
+	{ 0x30, KEY_EPG},=0A=
+	{ 0x32, KEY_F5},=0A=
+	{ 0x33, KEY_0},=0A=
+	{ 0x34, KEY_VCR},=0A=
+	{ 0x35, KEY_9},=0A=
+	{ 0x36, KEY_8},=0A=
+	{ 0x37, KEY_7},=0A=
+	{ 0x38, KEY_6},=0A=
+	{ 0x39, KEY_5},=0A=
+	{ 0x3a, KEY_4},=0A=
+	{ 0x3b, KEY_3},=0A=
+	{ 0x3c, KEY_2},=0A=
+	{ 0x3d, KEY_1},=0A=
+	{ 0x3e, KEY_POWER},=0A=
+=0A=
+};=0A=
+=0A=
+static struct rc_map_list terratec_cinergy_s2_hd_map =3D {=0A=
+	.map =3D {=0A=
+		.scan    =3D terratec_cinergy_s2_hd,=0A=
+		.size    =3D ARRAY_SIZE(terratec_cinergy_s2_hd),=0A=
+		.rc_type =3D RC_TYPE_UNKNOWN,	/* Legacy IR type */=0A=
+		.name    =3D RC_MAP_TERRATEC_CINERGY_S2_HD,=0A=
+	}=0A=
+};=0A=
+=0A=
+static int __init init_rc_map_terratec_cinergy_s2_hd(void)=0A=
+{=0A=
+	return rc_map_register(&terratec_cinergy_s2_hd_map);=0A=
+}=0A=
+=0A=
+static void __exit exit_rc_map_terratec_cinergy_s2_hd(void)=0A=
+{=0A=
+	rc_map_unregister(&terratec_cinergy_s2_hd_map);=0A=
+}=0A=
+=0A=
+module_init(init_rc_map_terratec_cinergy_s2_hd)=0A=
+module_exit(exit_rc_map_terratec_cinergy_s2_hd)=0A=
+=0A=
+MODULE_LICENSE("GPL");=0A=
diff --git a/drivers/media/rc/keymaps/rc-twinhan-dtv-cab-ci.c =
b/drivers/media/rc/keymaps/rc-twinhan-dtv-cab-ci.c=0A=
new file mode 100644=0A=
index 0000000..2b30374=0A=
--- /dev/null=0A=
+++ b/drivers/media/rc/keymaps/rc-twinhan-dtv-cab-ci.c=0A=
@@ -0,0 +1,95 @@=0A=
+/* keytable for Twinhan DTV CAB CI Remote Controller=0A=
+ *=0A=
+ * This program is free software; you can redistribute it and/or modify=0A=
+ * it under the terms of the GNU General Public License as published by=0A=
+ * the Free Software Foundation; either version 2 of the License, or=0A=
+ * (at your option) any later version.=0A=
+ */=0A=
+=0A=
+#include <media/rc-map.h>=0A=
+=0A=
+static struct rc_map_table twinhan_dtv_cab_ci[] =3D {=0A=
+	{ 0x29, KEY_POWER},=0A=
+	{ 0x28, KEY_FAVORITES},=0A=
+	{ 0x30, KEY_TEXT},=0A=
+	{ 0x17, KEY_INFO},              /* Preview */=0A=
+	{ 0x23, KEY_EPG},=0A=
+	{ 0x3b, KEY_F22},               /* Record List */=0A=
+=0A=
+	{ 0x3c, KEY_1},=0A=
+	{ 0x3e, KEY_2},=0A=
+	{ 0x39, KEY_3},=0A=
+	{ 0x36, KEY_4},=0A=
+	{ 0x22, KEY_5},=0A=
+	{ 0x20, KEY_6},=0A=
+	{ 0x32, KEY_7},=0A=
+	{ 0x26, KEY_8},=0A=
+	{ 0x24, KEY_9},=0A=
+	{ 0x2a, KEY_0},=0A=
+=0A=
+	{ 0x33, KEY_CANCEL},=0A=
+	{ 0x2c, KEY_BACK},=0A=
+	{ 0x15, KEY_CLEAR},=0A=
+	{ 0x3f, KEY_TAB},=0A=
+	{ 0x10, KEY_ENTER},=0A=
+	{ 0x14, KEY_UP},=0A=
+	{ 0x0d, KEY_RIGHT},=0A=
+	{ 0x0e, KEY_DOWN},=0A=
+	{ 0x11, KEY_LEFT},=0A=
+=0A=
+	{ 0x21, KEY_VOLUMEUP},=0A=
+	{ 0x35, KEY_VOLUMEDOWN},=0A=
+	{ 0x3d, KEY_CHANNELDOWN},=0A=
+	{ 0x3a, KEY_CHANNELUP},=0A=
+	{ 0x2e, KEY_RECORD},=0A=
+	{ 0x2b, KEY_PLAY},=0A=
+	{ 0x13, KEY_PAUSE},=0A=
+	{ 0x25, KEY_STOP},=0A=
+=0A=
+	{ 0x1f, KEY_REWIND},=0A=
+	{ 0x2d, KEY_FASTFORWARD},=0A=
+	{ 0x1e, KEY_PREVIOUS},          /* Replay |< */=0A=
+	{ 0x1d, KEY_NEXT},              /* Skip   >| */=0A=
+=0A=
+	{ 0x0b, KEY_CAMERA},            /* Capture */=0A=
+	{ 0x0f, KEY_LANGUAGE},          /* SAP */=0A=
+	{ 0x18, KEY_MODE},              /* PIP */=0A=
+	{ 0x12, KEY_ZOOM},              /* Full screen */=0A=
+	{ 0x1c, KEY_SUBTITLE},=0A=
+	{ 0x2f, KEY_MUTE},=0A=
+	{ 0x16, KEY_F20},               /* L/R */=0A=
+	{ 0x38, KEY_F21},               /* Hibernate */=0A=
+=0A=
+	{ 0x37, KEY_SWITCHVIDEOMODE},   /* A/V */=0A=
+	{ 0x31, KEY_AGAIN},             /* Recall */=0A=
+	{ 0x1a, KEY_KPPLUS},            /* Zoom+ */=0A=
+	{ 0x19, KEY_KPMINUS},           /* Zoom- */=0A=
+	{ 0x27, KEY_RED},=0A=
+	{ 0x0C, KEY_GREEN},=0A=
+	{ 0x01, KEY_YELLOW},=0A=
+	{ 0x00, KEY_BLUE},=0A=
+};=0A=
+=0A=
+static struct rc_map_list twinhan_dtv_cab_ci_map =3D {=0A=
+	.map =3D {=0A=
+		.scan    =3D twinhan_dtv_cab_ci,=0A=
+		.size    =3D ARRAY_SIZE(twinhan_dtv_cab_ci),=0A=
+		.rc_type =3D RC_TYPE_UNKNOWN,	/* Legacy IR type */=0A=
+		.name    =3D RC_MAP_TWINHAN_DTV_CAB_CI,=0A=
+	}=0A=
+};=0A=
+=0A=
+static int __init init_rc_map_twinhan_dtv_cab_ci(void)=0A=
+{=0A=
+	return rc_map_register(&twinhan_dtv_cab_ci_map);=0A=
+}=0A=
+=0A=
+static void __exit exit_rc_map_twinhan_dtv_cab_ci(void)=0A=
+{=0A=
+	rc_map_unregister(&twinhan_dtv_cab_ci_map);=0A=
+}=0A=
+=0A=
+module_init(init_rc_map_twinhan_dtv_cab_ci)=0A=
+module_exit(exit_rc_map_twinhan_dtv_cab_ci)=0A=
+=0A=
+MODULE_LICENSE("GPL");=0A=
diff --git a/include/media/rc-map.h b/include/media/rc-map.h=0A=
index 4e1409e..8628f07 100644=0A=
--- a/include/media/rc-map.h=0A=
+++ b/include/media/rc-map.h=0A=
@@ -132,6 +132,8 @@ void rc_map_init(void);=0A=
 #define RC_MAP_STREAMZAP                 "rc-streamzap"=0A=
 #define RC_MAP_TBS_NEC                   "rc-tbs-nec"=0A=
 #define RC_MAP_TECHNISAT_USB2            "rc-technisat-usb2"=0A=
+#define RC_MAP_TERRATEC_CINERGY_C_PCI    "rc-terratec-cinergy-c-pci"=0A=
+#define RC_MAP_TERRATEC_CINERGY_S2_HD    "rc-terratec-cinergy-s2-hd"=0A=
 #define RC_MAP_TERRATEC_CINERGY_XS       "rc-terratec-cinergy-xs"=0A=
 #define RC_MAP_TERRATEC_SLIM             "rc-terratec-slim"=0A=
 #define RC_MAP_TERRATEC_SLIM_2           "rc-terratec-slim-2"=0A=
@@ -140,6 +142,7 @@ void rc_map_init(void);=0A=
 #define RC_MAP_TOTAL_MEDIA_IN_HAND       "rc-total-media-in-hand"=0A=
 #define RC_MAP_TREKSTOR                  "rc-trekstor"=0A=
 #define RC_MAP_TT_1500                   "rc-tt-1500"=0A=
+#define RC_MAP_TWINHAN_DTV_CAB_CI        "rc-twinhan-dtv-cab-ci"=0A=
 #define RC_MAP_TWINHAN_VP1027_DVBS       "rc-twinhan1027"=0A=
 #define RC_MAP_VIDEOMATE_M1F             "rc-videomate-m1f"=0A=
 #define RC_MAP_VIDEOMATE_S350            "rc-videomate-s350"=0A=

------=_NextPart_000_0001_01CC0FE8.45AF7DE0--

