Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:42550 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073AbaJWVEw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Oct 2014 17:04:52 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org,
	"Jan M. Hochstein" <hochstein@algo.informatik.tu-darmstadt.de>
Subject: [REVIEW PATCH v1 1/2] [media] rc: port IgorPlug-USB to rc-core
Date: Thu, 23 Oct 2014 21:58:22 +0100
Message-Id: <1414097903-1664-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a complete re-write inspired by the original lirc driver.

Signed-off-by: Sean Young <sean@mess.org>
---
 MAINTAINERS                    |    6 +
 drivers/media/rc/Kconfig       |   15 +++
 drivers/media/rc/Makefile      |    1 +
 drivers/media/rc/igorplugusb.c |  261 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 283 insertions(+)
 create mode 100644 drivers/media/rc/igorplugusb.c

diff --git a/MAINTAINERS b/MAINTAINERS
index a20df9b..33f4c1a4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4688,6 +4688,12 @@ F:	net/mac802154/
 F:	drivers/net/ieee802154/
 F:	Documentation/networking/ieee802154.txt
 
+IGORPLUG-USB IR RECEIVER
+M:	Sean Young <sean@mess.org>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/rc/igorplugusb.c
+
 IGUANAWORKS USB IR TRANSCEIVER
 M:	Sean Young <sean@mess.org>
 L:	linux-media@vger.kernel.org
diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 8ce0810..1aea732 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -277,6 +277,21 @@ config IR_WINBOND_CIR
 	   To compile this driver as a module, choose M here: the module will
 	   be called winbond_cir.
 
+config IR_IGORPLUGUSB
+	tristate "IgorPlug-USB IR Receiver"
+	depends on USB_ARCH_HAS_HCD
+	depends on RC_CORE
+	select USB
+	---help---
+	   Say Y here if you want to use the IgorPlug-USB IR Receiver by
+	   Igor Cesko. This device is included on the Fit-PC2.
+
+	   Note that this device can only record bursts of 36 IR pulses and
+	   spaces, which is not enough for the NEC, Sanyo and RC-6 protocol.
+
+	   To compile this driver as a module, choose M here: the module will
+	   be called igorplugusb.
+
 config IR_IGUANA
 	tristate "IguanaWorks USB IR Transceiver"
 	depends on USB_ARCH_HAS_HCD
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index 0989f94..8f509e0 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_IR_STREAMZAP) += streamzap.o
 obj-$(CONFIG_IR_WINBOND_CIR) += winbond-cir.o
 obj-$(CONFIG_RC_LOOPBACK) += rc-loopback.o
 obj-$(CONFIG_IR_GPIO_CIR) += gpio-ir-recv.o
+obj-$(CONFIG_IR_IGORPLUGUSB) += igorplugusb.o
 obj-$(CONFIG_IR_IGUANA) += iguanair.o
 obj-$(CONFIG_IR_TTUSBIR) += ttusbir.o
 obj-$(CONFIG_RC_ST) += st_rc.o
diff --git a/drivers/media/rc/igorplugusb.c b/drivers/media/rc/igorplugusb.c
new file mode 100644
index 0000000..b36e515
--- /dev/null
+++ b/drivers/media/rc/igorplugusb.c
@@ -0,0 +1,261 @@
+/*
+ * IgorPlug-USB IR Receiver
+ *
+ * Copyright (C) 2014 Sean Young <sean@mess.org>
+ *
+ * Supports the standard homebrew IgorPlugUSB receiver with Igor's firmware.
+ * See http://www.cesko.host.sk/IgorPlugUSB/IgorPlug-USB%20(AVR)_eng.htm
+ *
+ * Based on the lirc_igorplugusb.c driver:
+ *	Copyright (C) 2004 Jan M. Hochstein
+ *	<hochstein@algo.informatik.tu-darmstadt.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/usb/input.h>
+#include <media/rc-core.h>
+
+#define DRIVER_DESC		"IgorPlug-USB IR Receiver"
+#define DRIVER_NAME		"igorplugusb"
+
+#define HEADERLEN		3
+#define BUFLEN			36
+#define MAX_PACKET		(HEADERLEN + BUFLEN)
+
+#define SET_INFRABUFFER_EMPTY	1
+#define GET_INFRACODE		2
+
+
+struct igorplugusb {
+	struct rc_dev *rc;
+	struct device *dev;
+
+	struct urb *urb;
+	struct usb_ctrlrequest request;
+
+	struct timer_list timer;
+
+	uint8_t buf_in[MAX_PACKET];
+
+	char phys[64];
+};
+
+static void igorplugusb_cmd(struct igorplugusb *ir, int cmd);
+
+static void igorplugusb_irdata(struct igorplugusb *ir, unsigned len)
+{
+	DEFINE_IR_RAW_EVENT(rawir);
+	unsigned i, start, overflow;
+
+	dev_dbg(ir->dev, "irdata: %*ph (len=%u)", len, ir->buf_in, len);
+
+	/*
+	 * If more than 36 pulses and spaces follow each other, the igorplugusb
+	 * overwrites its buffer from the beginning. The overflow value is the
+	 * last offset which was not overwritten. Everything from this offset
+	 * onwards occurred before everything until this offset.
+	 */
+	overflow = ir->buf_in[2];
+	i = start = overflow + HEADERLEN;
+
+	if (start >= len) {
+		dev_err(ir->dev, "receive overflow invalid: %u", overflow);
+	} else {
+		if (overflow > 0)
+			dev_warn(ir->dev, "receive overflow, at least %u lost",
+								overflow);
+
+		do {
+			rawir.duration = ir->buf_in[i] * 85333;
+			rawir.pulse = i & 1;
+
+			ir_raw_event_store_with_filter(ir->rc, &rawir);
+
+			if (++i == len)
+				i = HEADERLEN;
+		} while (i != start);
+
+		/* add a trailing space */
+		rawir.duration = ir->rc->timeout;
+		rawir.pulse = false;
+		ir_raw_event_store_with_filter(ir->rc, &rawir);
+
+		ir_raw_event_handle(ir->rc);
+	}
+
+	igorplugusb_cmd(ir, SET_INFRABUFFER_EMPTY);
+}
+
+static void igorplugusb_callback(struct urb *urb)
+{
+	struct usb_ctrlrequest *req;
+	struct igorplugusb *ir = urb->context;
+
+	req = (struct usb_ctrlrequest *)urb->setup_packet;
+
+	switch (urb->status) {
+	case 0:
+		if (req->bRequest == GET_INFRACODE &&
+					urb->actual_length > HEADERLEN)
+			igorplugusb_irdata(ir, urb->actual_length);
+		else /* request IR */
+			mod_timer(&ir->timer, jiffies + msecs_to_jiffies(50));
+		break;
+	case -EPROTO:
+	case -ECONNRESET:
+	case -ENOENT:
+	case -ESHUTDOWN:
+		usb_unlink_urb(urb);
+		return;
+	default:
+		dev_warn(ir->dev, "Error: urb status = %d\n", urb->status);
+		igorplugusb_cmd(ir, SET_INFRABUFFER_EMPTY);
+		break;
+	}
+}
+
+static void igorplugusb_cmd(struct igorplugusb *ir, int cmd)
+{
+	int ret;
+
+	ir->request.bRequest = cmd;
+	ir->urb->transfer_flags = 0;
+	ret = usb_submit_urb(ir->urb, GFP_ATOMIC);
+	if (ret)
+		dev_err(ir->dev, "submit urb failed: %d", ret);
+}
+
+static void igorplugusb_timer(unsigned long data)
+{
+	struct igorplugusb *ir = (struct igorplugusb *)data;
+
+	igorplugusb_cmd(ir, GET_INFRACODE);
+}
+
+static int igorplugusb_probe(struct usb_interface *intf,
+					const struct usb_device_id *id)
+{
+	struct usb_device *udev;
+	struct usb_host_interface *idesc;
+	struct usb_endpoint_descriptor *ep;
+	struct igorplugusb *ir;
+	struct rc_dev *rc;
+	int ret;
+
+	udev = interface_to_usbdev(intf);
+	idesc = intf->cur_altsetting;
+
+	if (idesc->desc.bNumEndpoints != 1) {
+		dev_err(&intf->dev, "incorrect number of endpoints");
+		return -ENODEV;
+	}
+
+	ep = &idesc->endpoint[0].desc;
+	if (!usb_endpoint_dir_in(ep) || !usb_endpoint_xfer_control(ep)) {
+		dev_err(&intf->dev, "endpoint incorrect");
+		return -ENODEV;
+	}
+
+	ir = devm_kzalloc(&intf->dev, sizeof(*ir), GFP_KERNEL);
+	if (!ir)
+		return -ENOMEM;
+
+	ir->dev = &intf->dev;
+
+	setup_timer(&ir->timer, igorplugusb_timer, (unsigned long)ir);
+
+	ir->request.bRequest = GET_INFRACODE;
+	ir->request.bRequestType = USB_TYPE_VENDOR | USB_DIR_IN;
+	ir->request.wLength = cpu_to_le16(sizeof(ir->buf_in));
+
+	ir->urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!ir->urb)
+		return -ENOMEM;
+
+	usb_fill_control_urb(ir->urb, udev,
+		usb_rcvctrlpipe(udev, 0), (uint8_t *)&ir->request,
+		ir->buf_in, sizeof(ir->buf_in), igorplugusb_callback, ir);
+
+	usb_make_path(udev, ir->phys, sizeof(ir->phys));
+
+	rc = rc_allocate_device();
+	rc->input_name = DRIVER_DESC;
+	rc->input_phys = ir->phys;
+	usb_to_input_id(udev, &rc->input_id);
+	rc->dev.parent = &intf->dev;
+	rc->driver_type = RC_DRIVER_IR_RAW;
+	/*
+	 * This device can only store 36 pulses + spaces, which is not enough
+	 * for the NEC protocol and many others.
+	 */
+	rc->allowed_protocols = RC_BIT_ALL & ~(RC_BIT_NEC | RC_BIT_RC6_6A_20 |
+			RC_BIT_RC6_6A_24 | RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE |
+			RC_BIT_SONY20 | RC_BIT_MCE_KBD | RC_BIT_SANYO);
+
+	rc->priv = ir;
+	rc->driver_name = DRIVER_NAME;
+	rc->map_name = RC_MAP_HAUPPAUGE;
+	rc->timeout = MS_TO_NS(100);
+	rc->rx_resolution = 85333;
+
+	ir->rc = rc;
+	ret = rc_register_device(rc);
+	if (ret) {
+		dev_err(&intf->dev, "failed to register rc device: %d", ret);
+		rc_free_device(rc);
+		usb_free_urb(ir->urb);
+		return ret;
+	}
+
+	usb_set_intfdata(intf, ir);
+
+	igorplugusb_cmd(ir, SET_INFRABUFFER_EMPTY);
+
+	return 0;
+}
+
+static void igorplugusb_disconnect(struct usb_interface *intf)
+{
+	struct igorplugusb *ir = usb_get_intfdata(intf);
+
+	rc_unregister_device(ir->rc);
+	del_timer_sync(&ir->timer);
+	usb_set_intfdata(intf, NULL);
+	usb_kill_urb(ir->urb);
+	usb_free_urb(ir->urb);
+}
+
+static struct usb_device_id igorplugusb_table[] = {
+	/* Igor Plug USB (Atmel's Manufact. ID) */
+	{ USB_DEVICE(0x03eb, 0x0002) },
+	/* Fit PC2 Infrared Adapter */
+	{ USB_DEVICE(0x03eb, 0x21fe) },
+	/* Terminating entry */
+	{ }
+};
+
+static struct usb_driver igorplugusb_driver = {
+	.name =	DRIVER_NAME,
+	.probe = igorplugusb_probe,
+	.disconnect = igorplugusb_disconnect,
+	.id_table = igorplugusb_table
+};
+
+module_usb_driver(igorplugusb_driver);
+
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_AUTHOR("Sean Young <sean@mess.org>");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(usb, igorplugusb_table);
-- 
1.7.10.4

