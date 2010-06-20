Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:58975 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757103Ab0FTUQ5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Jun 2010 16:16:57 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH] tm6000: add ir support
Date: Sun, 20 Jun 2010 22:16:52 +0200
Message-Id: <1277065012-19743-1-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/Makefile       |    3 +-
 drivers/staging/tm6000/tm6000-cards.c |   28 +++-
 drivers/staging/tm6000/tm6000-input.c |  365 +++++++++++++++++++++++++++++++++
 drivers/staging/tm6000/tm6000.h       |    9 +
 4 files changed, 403 insertions(+), 2 deletions(-)
 create mode 100644 drivers/staging/tm6000/tm6000-input.c

diff --git a/drivers/staging/tm6000/Makefile b/drivers/staging/tm6000/Makefile
index 4129c18..77e06bf 100644
--- a/drivers/staging/tm6000/Makefile
+++ b/drivers/staging/tm6000/Makefile
@@ -2,7 +2,8 @@ tm6000-objs := tm6000-cards.o \
 		   tm6000-core.o  \
 		   tm6000-i2c.o   \
 		   tm6000-video.o \
-		   tm6000-stds.o
+		   tm6000-stds.o \
+		   tm6000-input.o
 
 obj-$(CONFIG_VIDEO_TM6000) += tm6000.o
 obj-$(CONFIG_VIDEO_TM6000_ALSA) += tm6000-alsa.o
diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 50756e5..9860c55 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -28,6 +28,7 @@
 #include <media/tuner.h>
 #include <media/tvaudio.h>
 #include <media/i2c-addr.h>
+#include <media/rc-map.h>
 
 #include "tm6000.h"
 #include "tm6000-regs.h"
@@ -68,6 +69,8 @@ struct tm6000_board {
 	int             demod_addr;     /* demodulator address */
 
 	struct tm6000_gpio gpio;
+
+	char		*ir_codes;
 };
 
 struct tm6000_board tm6000_boards[] = {
@@ -275,6 +278,7 @@ struct tm6000_board tm6000_boards[] = {
 			.dvb_led	= TM6010_GPIO_5,
 			.ir		= TM6010_GPIO_0,
 		},
+		.ir_codes = RC_MAP_NEC_TERRATEC_CINERGY_XS,
 	},
 	[TM6010_BOARD_TWINHAN_TU501] = {
 		.name         = "Twinhan TU501(704D1)",
@@ -360,6 +364,8 @@ int tm6000_tuner_callback(void *ptr, int component, int command, int arg)
 
 	switch (command) {
 	case XC2028_RESET_CLK:
+		tm6000_ir_wait(dev, 0);
+
 		tm6000_set_reg(dev, REQ_04_EN_DISABLE_MCU_INT,
 					0x02, arg);
 		msleep(10);
@@ -409,13 +415,14 @@ int tm6000_tuner_callback(void *ptr, int component, int command, int arg)
 				msleep(130);
 				break;
 			}
+
+			tm6000_ir_wait(dev, 1);
 			break;
 		case 1:
 			tm6000_set_reg(dev, REQ_04_EN_DISABLE_MCU_INT,
 						0x02, 0x01);
 			msleep(10);
 			break;
-
 		case 2:
 			rc = tm6000_i2c_reset(dev, 100);
 			break;
@@ -635,6 +642,8 @@ static int tm6000_init_dev(struct tm6000_core *dev)
 
 	dev->gpio = tm6000_boards[dev->model].gpio;
 
+	dev->ir_codes = tm6000_boards[dev->model].ir_codes;
+
 	dev->demod_addr = tm6000_boards[dev->model].demod_addr;
 
 	dev->caps = tm6000_boards[dev->model].caps;
@@ -683,6 +692,8 @@ static int tm6000_init_dev(struct tm6000_core *dev)
 	tm6000_add_into_devlist(dev);
 	tm6000_init_extension(dev);
 
+	tm6000_ir_init(dev);
+
 	mutex_unlock(&dev->lock);
 	return 0;
 
@@ -828,6 +839,19 @@ static int tm6000_usb_probe(struct usb_interface *interface,
 							 &dev->isoc_out);
 				}
 				break;
+			case USB_ENDPOINT_XFER_INT:
+				if (!dir_out) {
+					get_max_endpoint(usbdev,
+							&interface->altsetting[i],
+							"INT IN", e,
+							&dev->int_in);
+				} else {
+					get_max_endpoint(usbdev,
+							&interface->altsetting[i],
+							"INT OUT", e,
+							&dev->int_out);
+				}
+				break;
 			}
 		}
 	}
@@ -886,6 +910,8 @@ static void tm6000_usb_disconnect(struct usb_interface *interface)
 
 	mutex_lock(&dev->lock);
 
+	tm6000_ir_fini(dev);
+
 	if (dev->gpio.power_led) {
 		switch (dev->model) {
 		case TM6010_BOARD_HAUPPAUGE_900H:
diff --git a/drivers/staging/tm6000/tm6000-input.c b/drivers/staging/tm6000/tm6000-input.c
new file mode 100644
index 0000000..d44182c
--- /dev/null
+++ b/drivers/staging/tm6000/tm6000-input.c
@@ -0,0 +1,365 @@
+/*
+   tm6000-input.c - driver for TM5600/TM6000/TM6010 USB video capture devices
+
+   Copyright (C) 2010 Stefan Ringel <stefan.ringel@arcor.de>
+
+   This program is free software; you can redistribute it and/or modify
+   it under the terms of the GNU General Public License as published by
+   the Free Software Foundation version 2
+
+   This program is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   You should have received a copy of the GNU General Public License
+   along with this program; if not, write to the Free Software
+   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+
+#include <linux/input.h>
+#include <linux/usb.h>
+
+#include <media/ir-core.h>
+#include <media/ir-common.h>
+
+#include "compat.h"
+#include "tm6000.h"
+#include "tm6000-regs.h"
+
+static unsigned int ir_debug;
+module_param(ir_debug, int, 0644);
+MODULE_PARM_DESC(ir_debug, "enable debug message [IR]");
+
+static unsigned int enable_ir = 1;
+module_param(enable_ir, int, 0644);
+MODULE_PARM_DESC(enable_ir, "enable ir (default is enable");
+
+#undef dprintk
+
+#define dprintk(fmt, arg... ) \
+	if (ir_debug) { \
+		printk(KERN_DEBUG "%s/ir: " fmt, ir->name , ## arg); \
+	}
+
+struct tm6000_ir_poll_result {
+	u8 rc_data[4];
+};
+
+struct tm6000_IR {
+	struct tm6000_core	*dev;
+	struct ir_input_dev	*input;
+	struct ir_input_state	ir;
+	char			name[32];
+	char			phys[32];
+
+	/* poll expernal decoder */
+	int			polling;
+	struct delayed_work	work;
+	u8			wait:1;
+	struct urb		*int_urb;
+	u8			*urb_data;
+	u8			key:1;
+
+	int (*get_key) (struct tm6000_IR *, struct tm6000_ir_poll_result *);
+
+	/* IR device properties */
+	struct ir_dev_props	props;
+};
+
+
+void tm6000_ir_wait(struct tm6000_core *dev, u8 state)
+{
+	struct tm6000_IR *ir = dev->ir;
+
+	if (!dev->ir)
+		return;
+
+	if (state)
+		ir->wait = 1;
+	else
+		ir->wait = 0;
+}
+
+
+static int tm6000_ir_config(struct tm6000_IR *ir)
+{
+	struct tm6000_core *dev = ir->dev;
+	u8 buf[10];
+	int rc;
+
+	/* hack */
+	buf[0] = 0xff;
+	buf[1] = 0xff;
+	buf[2] = 0xf2;
+	buf[3] = 0x2b;
+	buf[4] = 0x20;
+	buf[5] = 0x35;
+	buf[6] = 0x60;
+	buf[7] = 0x04;
+	buf[8] = 0xc0;
+	buf[9] = 0x08;
+
+	rc = tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR |
+		USB_RECIP_DEVICE, REQ_00_SET_IR_VALUE, 0, 0, buf, 0x0a);
+	msleep(100);
+
+	if (rc < 0) {
+		printk(KERN_INFO "IR configuration failed");
+		return rc;
+	}
+	return 0;
+}
+
+static void tm6000_ir_urb_received(struct urb *urb)
+{
+	struct tm6000_core *dev = urb->context;
+	struct tm6000_IR *ir = dev->ir;
+	int rc;
+	
+	if (urb->status != 0)
+		printk(KERN_INFO "not ready\n");
+	else if (urb->actual_length > 0)
+		memcpy (ir->urb_data, urb->transfer_buffer, urb->actual_length);
+
+	dprintk ("data %02x %02x %02x %02x\n", ir->urb_data[0],
+	ir->urb_data[1], ir->urb_data[2], ir->urb_data[3]);
+
+	ir->key = 1;
+
+	rc = usb_submit_urb(urb, GFP_ATOMIC);
+}
+
+static int default_polling_getkey(struct tm6000_IR *ir,
+				struct tm6000_ir_poll_result *poll_result)
+{
+	struct tm6000_core *dev = ir->dev;
+	int rc;
+	u8 buf[2];
+
+	if(ir->wait && !&dev->int_in) {
+		poll_result->rc_data[0] = 0xff;
+		return 0;
+	}
+
+	if (&dev->int_in) {
+		poll_result->rc_data[0] = ir->urb_data[0];
+		poll_result->rc_data[1] = ir->urb_data[1];
+	} else {
+		tm6000_set_reg(dev, REQ_04_EN_DISABLE_MCU_INT, 2, 0);
+		msleep(10);
+		tm6000_set_reg(dev, REQ_04_EN_DISABLE_MCU_INT, 2, 1);
+		msleep(10);
+
+		rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR |
+		 USB_RECIP_DEVICE, REQ_02_GET_IR_CODE, 0, 0, buf, 1);
+
+		msleep(10);
+
+		dprintk ("read data=%02x\n", buf[0]);
+		if (rc < 0) {
+			return rc;
+		}
+		poll_result->rc_data[0] = buf[0];
+	}
+	return 0;
+}
+
+static void tm6000_ir_handle_key(struct tm6000_IR *ir)
+{
+	int result;
+	struct tm6000_ir_poll_result poll_result;
+
+	/* read the registers containing the IR status */
+	result = ir->get_key(ir, &poll_result);
+	if (result < 0) {
+		printk(KERN_INFO "ir->get_key() failed %d\n", result);
+		return;
+	}
+
+	dprintk("ir->get_key result data=%02x %02x\n",
+		poll_result.rc_data[0], poll_result.rc_data[1]);
+
+	if (poll_result.rc_data[0] != 0xff && ir->key == 1) {
+		ir_input_keydown(ir->input->input_dev, &ir->ir,
+			poll_result.rc_data[0] | poll_result.rc_data[1] << 8);
+
+		ir_input_nokey(ir->input->input_dev, &ir->ir);
+		ir->key = 0;
+	}
+	return;
+}
+
+static void tm6000_ir_work(struct work_struct *work)
+{
+	struct tm6000_IR *ir = container_of(work, struct tm6000_IR, work.work);
+
+	tm6000_ir_handle_key(ir);
+	schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
+}
+
+static int tm6000_ir_start(void *priv)
+{
+	struct tm6000_IR *ir = priv;
+
+	INIT_DELAYED_WORK(&ir->work, tm6000_ir_work);
+	schedule_delayed_work(&ir->work, 0);
+
+	return 0;
+}
+
+static void tm6000_ir_stop(void *priv)
+{
+	struct tm6000_IR *ir = priv;
+
+	cancel_delayed_work_sync(&ir->work);
+}
+
+int tm6000_ir_change_protocol(void *priv, u64 ir_type)
+{
+	struct tm6000_IR *ir = priv;
+
+	ir->get_key = default_polling_getkey;
+
+	tm6000_ir_config(ir);
+	/* TODO */
+	return 0;
+}
+
+int tm6000_ir_init(struct tm6000_core *dev)
+{
+	struct tm6000_IR *ir;
+	struct ir_input_dev *ir_input_dev;
+	int err = -ENOMEM;
+	int pipe, size, rc;
+
+	if (!enable_ir)
+		return -ENODEV;
+
+	if (!dev->caps.has_remote)
+		return 0;
+
+	if (!dev->ir_codes)
+		return 0;
+
+	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
+	ir_input_dev = kzalloc(sizeof(*ir_input_dev), GFP_KERNEL);
+	ir_input_dev->input_dev = input_allocate_device();
+	if (!ir || !ir_input_dev || !ir_input_dev->input_dev)
+		goto err_out_free;
+
+	/* record handles to ourself */
+	ir->dev = dev;
+	dev->ir = ir;
+
+	ir->input = ir_input_dev;
+
+	/* input einrichten */
+	ir->props.allowed_protos = IR_TYPE_RC5 | IR_TYPE_NEC;
+	ir->props.priv = ir;
+	ir->props.change_protocol = tm6000_ir_change_protocol;
+	ir->props.open = tm6000_ir_start;
+	ir->props.close = tm6000_ir_stop;
+	ir->props.driver_type = RC_DRIVER_SCANCODE;
+
+	ir->polling = 50;
+
+	snprintf(ir->name, sizeof(ir->name), "tm5600/60x0 IR (%s)",
+						dev->name);
+
+	usb_make_path(dev->udev, ir->phys, sizeof(ir->phys));
+	strlcat(ir->phys, "/input0", sizeof(ir->phys));
+
+	tm6000_ir_change_protocol(ir, IR_TYPE_UNKNOWN);
+	err = ir_input_init(ir_input_dev->input_dev, &ir->ir, IR_TYPE_OTHER);
+	if (err < 0)
+		goto err_out_free;
+
+	ir_input_dev->input_dev->name = ir->name;
+	ir_input_dev->input_dev->phys = ir->phys;
+	ir_input_dev->input_dev->id.bustype = BUS_USB;
+	ir_input_dev->input_dev->id.version = 1;
+	ir_input_dev->input_dev->id.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
+	ir_input_dev->input_dev->id.product = le16_to_cpu(dev->udev->descriptor.idProduct);
+
+	ir_input_dev->input_dev->dev.parent = &dev->udev->dev;
+
+	if (&dev->int_in) {
+		dprintk("IR over int\n");
+
+		ir->int_urb = usb_alloc_urb(0, GFP_KERNEL);
+
+		pipe = usb_rcvintpipe(dev->udev,
+			dev->int_in.endp->desc.bEndpointAddress
+			& USB_ENDPOINT_NUMBER_MASK);
+
+		size = usb_maxpacket(dev->udev, pipe, usb_pipeout(pipe));
+		dprintk("IR max size: %d\n", size);
+
+		ir->int_urb->transfer_buffer = kzalloc(size, GFP_KERNEL);
+		if (ir->int_urb->transfer_buffer == NULL) {
+			usb_free_urb(ir->int_urb);
+			goto err_out_stop;
+		}
+		dprintk("int interval: %d\n", dev->int_in.endp->desc.bInterval);
+		usb_fill_int_urb(ir->int_urb, dev->udev, pipe,
+			ir->int_urb->transfer_buffer, size,
+			tm6000_ir_urb_received, dev,
+			dev->int_in.endp->desc.bInterval);
+		rc = usb_submit_urb(ir->int_urb, GFP_KERNEL);
+		if (rc) {
+			kfree(ir->int_urb->transfer_buffer);
+			usb_free_urb(ir->int_urb);
+			err = rc;
+			goto err_out_stop;
+		}
+		ir->urb_data = kzalloc(size, GFP_KERNEL);
+	}
+
+	/* ir register */
+	err = ir_input_register(ir->input->input_dev, dev->ir_codes,
+		&ir->props, "tm6000");
+	if (err)
+		goto err_out_stop;
+
+	return 0;
+
+err_out_stop:
+	dev->ir = NULL;
+err_out_free:
+	kfree(ir_input_dev);
+	kfree(ir);
+	return err;
+}
+
+int tm6000_ir_fini(struct tm6000_core *dev)
+{
+	struct tm6000_IR *ir = dev->ir;
+
+	/* skip detach on non attached board */
+
+	if (!ir)
+		return 0;
+
+	ir_input_unregister(ir->input->input_dev);
+
+	if (ir->int_urb) {
+		usb_kill_urb(ir->int_urb);
+		kfree(ir->int_urb->transfer_buffer);
+		usb_free_urb(ir->int_urb);
+		ir->int_urb = NULL;
+		kfree(ir->urb_data);
+		ir->urb_data = NULL;
+	}
+
+	kfree(ir->input);
+	ir->input = NULL;
+	kfree(ir);
+	dev->ir = NULL;
+
+	return 0;
+}
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index 89862a4..1ec1bff 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -171,6 +171,8 @@ struct tm6000_core {
 
 	struct tm6000_gpio		gpio;
 
+	char				*ir_codes;
+
 	/* Demodulator configuration */
 	int				demod_addr;	/* demodulator address */
 
@@ -204,6 +206,8 @@ struct tm6000_core {
 	/* audio support */
 	struct snd_tm6000_card		*adev;
 
+	struct tm6000_IR		*ir;
+
 	/* locks */
 	struct mutex			lock;
 
@@ -211,6 +215,7 @@ struct tm6000_core {
 	struct usb_device		*udev;		/* the usb device */
 
 	struct tm6000_endpoint		bulk_in, bulk_out, isoc_in, isoc_out;
+	struct tm6000_endpoint		int_in, int_out;
 
 	/* scaler!=0 if scaler is active*/
 	int				scaler;
@@ -317,6 +322,10 @@ int tm6000_queue_init(struct tm6000_core *dev);
 /* In tm6000-alsa.c */
 /*int tm6000_audio_init(struct tm6000_core *dev, int idx);*/
 
+/* In tm6000-input.c */
+int tm6000_ir_init(struct tm6000_core *dev);
+int tm6000_ir_fini(struct tm6000_core *dev);
+void tm6000_ir_wait(struct tm6000_core *dev, u8 state);
 
 /* Debug stuff */
 
-- 
1.7.1

