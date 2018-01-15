Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:40191 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932627AbeAOJ62 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 04:58:28 -0500
From: Sean Young <sean@mess.org>
To: Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 5/5] media: rc: new driver for Sasem Remote Controller VFD/IR
Date: Mon, 15 Jan 2018 09:58:24 +0000
Message-Id: <342710d498a45fb0bb90d381976e0d0ddac18131.1516008708.git.sean@mess.org>
In-Reply-To: <cover.1516008708.git.sean@mess.org>
References: <cover.1516008708.git.sean@mess.org>
MIME-Version: 1.0
In-Reply-To: <cover.1516008708.git.sean@mess.org>
References: <cover.1516008708.git.sean@mess.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This device is built into the Ahanix D.Vine 5 HTPC case. It has an LCD
device, and an IR receiver.

The LCD can be controlled via the charlcd driver. Unfortunately the device
does not seem to provide a method for accessing the character generator
ram.

Signed-off-by: Sean Young <sean@mess.org>
---
 MAINTAINERS                 |   6 +
 drivers/media/rc/Kconfig    |  16 +++
 drivers/media/rc/Makefile   |   1 +
 drivers/media/rc/sasem_ir.c | 297 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 320 insertions(+)
 create mode 100644 drivers/media/rc/sasem_ir.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 58797b83dd8d..a06801032ee3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12066,6 +12066,12 @@ F:	drivers/phy/samsung/phy-s5pv210-usb2.c
 F:	drivers/phy/samsung/phy-samsung-usb2.c
 F:	drivers/phy/samsung/phy-samsung-usb2.h
 
+SASEM REMOTE CONTROLLER
+M:	Sean Young <sean@mess.org>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/rc/sasem_ir.c
+
 SC1200 WDT DRIVER
 M:	Zwane Mwaikambo <zwanem@gmail.com>
 S:	Maintained
diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 7919f4a36ad2..bffa39e06a68 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -457,6 +457,22 @@ config IR_SERIAL
 	   To compile this driver as a module, choose M here: the module will
 	   be called serial-ir.
 
+config IR_SASEM
+	tristate "Sasem Remote Controller"
+	depends on USB_ARCH_HAS_HCD
+	depends on RC_CORE
+	select USB
+	select CHARLCD
+	---help---
+	   Driver for the Sasem OnAir Remocon-V or Dign HV5 HTPC IR/VFD Module
+
+	   The LCD can be controlled via the charlcd driver. Unfortunately the
+	   device does not seem to provide a method for accessing the
+	   character generator ram.
+
+	   To compile this driver as a module, choose M here: the module will
+	   be called sesam_ir.
+
 config IR_SERIAL_TRANSMITTER
 	bool "Serial Port Transmitter"
 	default y
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index e098e127b26a..9b474c8b49dc 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_IR_TTUSBIR) += ttusbir.o
 obj-$(CONFIG_RC_ST) += st_rc.o
 obj-$(CONFIG_IR_SUNXI) += sunxi-cir.o
 obj-$(CONFIG_IR_IMG) += img-ir/
+obj-$(CONFIG_IR_SASEM) += sasem_ir.o
 obj-$(CONFIG_IR_SERIAL) += serial_ir.o
 obj-$(CONFIG_IR_SIR) += sir_ir.o
 obj-$(CONFIG_IR_MTK) += mtk-cir.o
diff --git a/drivers/media/rc/sasem_ir.c b/drivers/media/rc/sasem_ir.c
new file mode 100644
index 000000000000..33d3b8bdb56d
--- /dev/null
+++ b/drivers/media/rc/sasem_ir.c
@@ -0,0 +1,297 @@
+// SPDX-License-Identifier: GPL-2.0+
+//
+// Copyright (C) 2018 Sean Young <sean@mess.org>
+
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/usb/input.h>
+#include <misc/charlcd.h>
+
+#include <media/rc-core.h>
+
+struct sasem {
+	struct device *dev;
+	struct urb *ir_urb;
+	struct urb *vfd_urb;
+	struct rc_dev *rcdev;
+	struct completion completion;
+	u8 ir_buf[8];
+	u8 vfd_buf[8];
+	unsigned int offset;
+	char phys[64];
+};
+
+static void sasem_ir_rx(struct urb *urb)
+{
+	struct sasem *sasem = urb->context;
+	enum rc_proto proto;
+	u32 code;
+	int ret;
+
+	switch (urb->status) {
+	case 0:
+		dev_dbg(sasem->dev, "data: %*ph", 8, sasem->ir_buf);
+		/*
+		 * Note that sanyo and jvc protocols are also supported,
+		 * but the scancode seems garbled. More testing needed.
+		 */
+		switch (sasem->ir_buf[0]) {
+		case 0xc:
+			code = ir_nec_bytes_to_scancode(sasem->ir_buf[1],
+				sasem->ir_buf[2], sasem->ir_buf[3],
+				sasem->ir_buf[4], &proto);
+			rc_keydown(sasem->rcdev, proto, code, 0);
+			break;
+		case 0x8:
+			rc_repeat(sasem->rcdev);
+			break;
+		}
+		break;
+	case -ECONNRESET:
+	case -ENOENT:
+	case -ESHUTDOWN:
+		usb_unlink_urb(urb);
+		return;
+	case -EPIPE:
+	default:
+		dev_dbg(sasem->dev, "error: urb status = %d", urb->status);
+		break;
+	}
+
+	ret = usb_submit_urb(urb, GFP_ATOMIC);
+	if (ret && ret != -ENODEV)
+		dev_warn(sasem->dev, "failed to resubmit urb: %d", ret);
+}
+
+static void sasem_vfd_complete(struct urb *urb)
+{
+	struct sasem *sasem = urb->context;
+
+	if (urb->status)
+		dev_info(sasem->dev, "error: vfd urb status = %d", urb->status);
+
+	complete(&sasem->completion);
+}
+
+static int sasem_vfd_send(struct sasem *sasem)
+{
+	int ret;
+
+	reinit_completion(&sasem->completion);
+
+	ret = usb_submit_urb(sasem->vfd_urb, GFP_KERNEL);
+	if (ret)
+		return ret;
+
+	if (wait_for_completion_timeout(&sasem->completion, 1000) == 0)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static void sasem_lcd_flush(struct charlcd *lcd)
+{
+	struct sasem *sasem = lcd->drvdata;
+
+	if (sasem->offset > 0) {
+		while (sasem->offset < 8)
+			sasem->vfd_buf[sasem->offset++] = 0;
+
+		sasem_vfd_send(sasem);
+
+		sasem->offset = 0;
+	}
+}
+
+static void sasem_lcd_write_cmd(struct charlcd *lcd, int cmd)
+{
+	struct sasem *sasem = lcd->drvdata;
+
+	dev_dbg(sasem->dev, "lcd_write_cmd: %02x", cmd);
+
+	if (sasem->offset >= 6)
+		sasem_lcd_flush(lcd);
+
+	if (cmd & 0x80) {
+		sasem->vfd_buf[sasem->offset++] = 0x09;
+		sasem->vfd_buf[sasem->offset++] = ((cmd & 0x7f) + 1) ^ 0x40;
+	} else {
+		sasem->vfd_buf[sasem->offset++] = 0x07;
+
+		/* The interface between Sasem and NEC µPD16314 is 4-bit */
+		if ((cmd & 0xe0) == 0x20)
+			cmd &= ~0x10;
+		sasem->vfd_buf[sasem->offset++] = cmd;
+	}
+}
+
+static void sasem_lcd_write_data(struct charlcd *lcd, int data)
+{
+	struct sasem *sasem = lcd->drvdata;
+
+	dev_dbg(sasem->dev, "lcd_write_data: %02x", data);
+
+	if (sasem->offset >= 7)
+		sasem_lcd_flush(lcd);
+
+	sasem->vfd_buf[sasem->offset++] = data;
+}
+
+static const struct charlcd_ops sasem_lcd_ops = {
+	.write_cmd = sasem_lcd_write_cmd,
+	.write_data = sasem_lcd_write_data,
+	.flush = sasem_lcd_flush
+};
+
+static int sasem_probe(struct usb_interface *intf,
+		       const struct usb_device_id *id)
+{
+	struct usb_endpoint_descriptor *ir_ep = NULL;
+	struct usb_endpoint_descriptor *vfd_ep = NULL;
+	struct usb_host_interface *idesc;
+	struct usb_device *udev;
+	struct rc_dev *rcdev;
+	struct charlcd *lcd;
+	struct sasem *sasem;
+	int i, ret;
+
+	udev = interface_to_usbdev(intf);
+	idesc = intf->cur_altsetting;
+
+	for (i = 0; i < idesc->desc.bNumEndpoints; i++) {
+		struct usb_endpoint_descriptor *ep = &idesc->endpoint[i].desc;
+
+		if (usb_endpoint_is_int_in(ep) && !ir_ep)
+			ir_ep = ep;
+		else if (usb_endpoint_is_int_out(ep) && !vfd_ep)
+			vfd_ep = ep;
+	}
+
+	if (!ir_ep || !vfd_ep) {
+		dev_err(&intf->dev, "usb endpoint missing");
+		return -ENODEV;
+	}
+
+	lcd = charlcd_alloc(sizeof(*sasem));
+	if (!lcd)
+		return -ENOMEM;
+
+	sasem = lcd->drvdata;
+
+	sasem->ir_urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!sasem->ir_urb) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	sasem->dev = &intf->dev;
+	usb_fill_int_urb(sasem->ir_urb, udev,
+			 usb_rcvintpipe(udev, ir_ep->bEndpointAddress),
+			 sasem->ir_buf, sizeof(sasem->ir_buf),
+			 sasem_ir_rx, sasem, ir_ep->bInterval);
+
+	rcdev = devm_rc_allocate_device(&intf->dev, RC_DRIVER_SCANCODE);
+	if (!rcdev) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	usb_make_path(udev, sasem->phys, sizeof(sasem->phys));
+
+	rcdev->device_name = "Sasem Remote Controller";
+	rcdev->driver_name = KBUILD_MODNAME;
+	rcdev->input_phys = sasem->phys;
+	usb_to_input_id(udev, &rcdev->input_id);
+	rcdev->dev.parent = &intf->dev;
+	rcdev->allowed_protocols = RC_PROTO_BIT_NEC;
+	rcdev->map_name = RC_MAP_DIGN;
+	rcdev->priv = sasem;
+
+	ret = devm_rc_register_device(&intf->dev, rcdev);
+	if (ret)
+		goto out_free;
+
+	sasem->rcdev = rcdev;
+
+	lcd->height = 2;
+	lcd->width = 16;
+	lcd->bwidth = 16;
+	lcd->ops = &sasem_lcd_ops;
+
+	init_completion(&sasem->completion);
+
+	sasem->vfd_urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!sasem->vfd_urb) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	usb_fill_int_urb(sasem->vfd_urb, udev,
+			 usb_sndintpipe(udev, vfd_ep->bEndpointAddress),
+			 sasem->vfd_buf, sizeof(sasem->vfd_buf),
+			 sasem_vfd_complete, sasem, vfd_ep->bInterval);
+
+	/*
+	 * After usb is plugged in, the device programs the LCD with
+	 * 'Welcome DIGN Home Theatre PC'. Wait for this to complete,
+	 * else our commands will be mixed up with these commands.
+	 */
+	msleep(20);
+
+	ret = charlcd_register(lcd);
+	if (ret)
+		goto out_free;
+
+	ret = usb_submit_urb(sasem->ir_urb, GFP_KERNEL);
+	if (ret)
+		goto out_lcd;
+
+	usb_set_intfdata(intf, lcd);
+
+	return 0;
+
+out_lcd:
+	charlcd_unregister(lcd);
+out_free:
+	usb_free_urb(sasem->ir_urb);
+	usb_free_urb(sasem->vfd_urb);
+	kfree(lcd);
+
+	return ret;
+}
+
+static void sasem_disconnect(struct usb_interface *intf)
+{
+	struct charlcd *lcd = usb_get_intfdata(intf);
+	struct sasem *sasem = lcd->drvdata;
+
+	charlcd_unregister(lcd);
+
+	usb_kill_urb(sasem->ir_urb);
+	usb_free_urb(sasem->ir_urb);
+	usb_kill_urb(sasem->vfd_urb);
+	usb_free_urb(sasem->vfd_urb);
+
+	kfree(lcd);
+}
+
+static const struct usb_device_id sasem_table[] = {
+	/* Sasem USB Control Board */
+	{ USB_DEVICE(0x11ba, 0x0101) },
+
+	{}
+};
+
+static struct usb_driver sasem_driver = {
+	.name = KBUILD_MODNAME,
+	.probe = sasem_probe,
+	.disconnect = sasem_disconnect,
+	.id_table = sasem_table
+};
+
+module_usb_driver(sasem_driver);
+
+MODULE_DESCRIPTION("Sasem Remote Controller");
+MODULE_AUTHOR("Sean Young <sean@mess.org>");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(usb, sasem_table);
-- 
2.14.3
