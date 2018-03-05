Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:56723 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751462AbeCEPeE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Mar 2018 10:34:04 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/3] media: rc: new driver for early iMon device
Date: Mon,  5 Mar 2018 15:34:02 +0000
Message-Id: <20180305153402.24141-3-sean@mess.org>
In-Reply-To: <20180305153402.24141-1-sean@mess.org>
References: <20180305153402.24141-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These devices were supported by the lirc_imon.c driver which was removed
from staging in commit f41003a23a02 ("[media] staging: lirc_imon: port
remaining usb ids to imon and remove").

Signed-off-by: Sean Young <sean@mess.org>
---
 MAINTAINERS                 |   7 ++
 drivers/media/rc/Kconfig    |  12 +++
 drivers/media/rc/Makefile   |   1 +
 drivers/media/rc/imon_raw.c | 193 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 213 insertions(+)
 create mode 100644 drivers/media/rc/imon_raw.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 0eea2f0e9456..3e23fb9e3991 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6903,6 +6903,13 @@ M:	James Hogan <jhogan@kernel.org>
 S:	Maintained
 F:	drivers/media/rc/img-ir/
 
+IMON SOUNDGRAPH USB IR RECEIVER
+M:	Sean Young <sean@mess.org>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/rc/imon_raw.c
+F:	drivers/media/rc/imon.c
+
 IMS TWINTURBO FRAMEBUFFER DRIVER
 L:	linux-fbdev@vger.kernel.org
 S:	Orphan
diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 447f82c1f65a..7ad05a6ef350 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -175,6 +175,18 @@ config IR_IMON
 	   To compile this driver as a module, choose M here: the
 	   module will be called imon.
 
+config IR_IMON_RAW
+	tristate "SoundGraph iMON Receiver (early raw IR models)"
+	depends on USB_ARCH_HAS_HCD
+	depends on RC_CORE
+	select USB
+	---help---
+	   Say Y here if you want to use a SoundGraph iMON IR Receiver,
+	   early raw models.
+
+	   To compile this driver as a module, choose M here: the
+	   module will be called imon_raw.
+
 config IR_MCEUSB
 	tristate "Windows Media Center Ed. eHome Infrared Transceiver"
 	depends on USB_ARCH_HAS_HCD
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index 0e857816ac2d..e098e127b26a 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_IR_XMP_DECODER) += ir-xmp-decoder.o
 obj-$(CONFIG_RC_ATI_REMOTE) += ati_remote.o
 obj-$(CONFIG_IR_HIX5HD2) += ir-hix5hd2.o
 obj-$(CONFIG_IR_IMON) += imon.o
+obj-$(CONFIG_IR_IMON_RAW) += imon_raw.o
 obj-$(CONFIG_IR_ITE_CIR) += ite-cir.o
 obj-$(CONFIG_IR_MCEUSB) += mceusb.o
 obj-$(CONFIG_IR_FINTEK) += fintek-cir.o
diff --git a/drivers/media/rc/imon_raw.c b/drivers/media/rc/imon_raw.c
new file mode 100644
index 000000000000..92dfe972c4b8
--- /dev/null
+++ b/drivers/media/rc/imon_raw.c
@@ -0,0 +1,193 @@
+// SPDX-License-Identifier: GPL-2.0+
+//
+// Copyright (C) 2018 Sean Young <sean@mess.org>
+
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/usb/input.h>
+#include <media/rc-core.h>
+
+/* Each bit is 250us */
+#define BIT_DURATION		250000
+
+struct imon {
+	struct device *dev;
+	struct urb *ir_urb;
+	struct rc_dev *rcdev;
+	u8 ir_buf[8];
+	char phys[64];
+};
+
+/*
+ * ffs/find_next_bit() searches in the wrong direction, so open-code our own.
+ */
+static int is_bit_set(u8 *buf, int bit)
+{
+	return buf[bit / 8] & (0x80 >> (bit & 7));
+}
+
+static void imon_ir_data(struct imon *imon)
+{
+	DEFINE_IR_RAW_EVENT(rawir);
+	int offset = 0, size = 5 * 8;
+	int bit;
+
+	dev_dbg(imon->dev, "data: %*ph", 8, imon->ir_buf);
+
+	while (offset < size) {
+		bit = offset;
+		while (!is_bit_set(imon->ir_buf, bit) && bit < size)
+			bit++;
+		dev_dbg(imon->dev, "zero: %d", bit - offset);
+		if (bit > offset) {
+			rawir.pulse = true;
+			rawir.duration = (bit - offset) * BIT_DURATION;
+			ir_raw_event_store_with_filter(imon->rcdev, &rawir);
+		}
+
+		if (bit >= size)
+			break;
+
+		offset = bit;
+		while (is_bit_set(imon->ir_buf, bit) && bit < size)
+			bit++;
+		dev_dbg(imon->dev, "set: %d", bit - offset);
+
+		rawir.pulse = false;
+		rawir.duration = (bit - offset) * BIT_DURATION;
+		ir_raw_event_store_with_filter(imon->rcdev, &rawir);
+
+		offset = bit;
+	}
+
+	if (imon->ir_buf[7] == 0x0a) {
+		ir_raw_event_set_idle(imon->rcdev, true);
+		ir_raw_event_handle(imon->rcdev);
+	}
+}
+
+static void imon_ir_rx(struct urb *urb)
+{
+	struct imon *imon = urb->context;
+	int ret;
+
+	switch (urb->status) {
+	case 0:
+		if (imon->ir_buf[7] != 0xff)
+			imon_ir_data(imon);
+		break;
+	case -ECONNRESET:
+	case -ENOENT:
+	case -ESHUTDOWN:
+		usb_unlink_urb(urb);
+		return;
+	case -EPIPE:
+	default:
+		dev_dbg(imon->dev, "error: urb status = %d", urb->status);
+		break;
+	}
+
+	ret = usb_submit_urb(urb, GFP_ATOMIC);
+	if (ret && ret != -ENODEV)
+		dev_warn(imon->dev, "failed to resubmit urb: %d", ret);
+}
+
+static int imon_probe(struct usb_interface *intf,
+		      const struct usb_device_id *id)
+{
+	struct usb_endpoint_descriptor *ir_ep = NULL;
+	struct usb_host_interface *idesc;
+	struct usb_device *udev;
+	struct rc_dev *rcdev;
+	struct imon *imon;
+	int i, ret;
+
+	udev = interface_to_usbdev(intf);
+	idesc = intf->cur_altsetting;
+
+	for (i = 0; i < idesc->desc.bNumEndpoints; i++) {
+		struct usb_endpoint_descriptor *ep = &idesc->endpoint[i].desc;
+
+		if (usb_endpoint_is_int_in(ep)) {
+			ir_ep = ep;
+			break;
+		}
+	}
+
+	if (!ir_ep) {
+		dev_err(&intf->dev, "IR endpoint missing");
+		return -ENODEV;
+	}
+
+	imon = devm_kzalloc(&intf->dev, sizeof(*imon), GFP_KERNEL);
+	if (!imon)
+		return -ENOMEM;
+
+	imon->ir_urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!imon->ir_urb)
+		return -ENOMEM;
+
+	imon->dev = &intf->dev;
+	usb_fill_int_urb(imon->ir_urb, udev,
+			 usb_rcvintpipe(udev, ir_ep->bEndpointAddress),
+			 imon->ir_buf, sizeof(imon->ir_buf),
+			 imon_ir_rx, imon, ir_ep->bInterval);
+
+	rcdev = devm_rc_allocate_device(&intf->dev, RC_DRIVER_IR_RAW);
+	if (!rcdev)
+		return -ENOMEM;
+
+	usb_make_path(udev, imon->phys, sizeof(imon->phys));
+
+	rcdev->device_name = "iMON Station";
+	rcdev->driver_name = KBUILD_MODNAME;
+	rcdev->input_phys = imon->phys;
+	usb_to_input_id(udev, &rcdev->input_id);
+	rcdev->dev.parent = &intf->dev;
+	rcdev->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
+	rcdev->map_name = RC_MAP_IMON_RSC;
+	rcdev->rx_resolution = BIT_DURATION;
+	rcdev->priv = imon;
+
+	ret = devm_rc_register_device(&intf->dev, rcdev);
+	if (ret)
+		return ret;
+
+	imon->rcdev = rcdev;
+
+	ret = usb_submit_urb(imon->ir_urb, GFP_KERNEL);
+	if (ret)
+		return ret;
+
+	usb_set_intfdata(intf, imon);
+
+	return 0;
+}
+
+static void imon_disconnect(struct usb_interface *intf)
+{
+	struct imon *imon = usb_get_intfdata(intf);
+
+	usb_kill_urb(imon->ir_urb);
+	usb_free_urb(imon->ir_urb);
+}
+
+static const struct usb_device_id imon_table[] = {
+	/* SoundGraph iMON (IR only) -- sg_imon.inf */
+	{ USB_DEVICE(0x04e8, 0xff30) },
+	{}
+};
+
+static struct usb_driver imon_driver = {
+	.name = KBUILD_MODNAME,
+	.probe = imon_probe,
+	.disconnect = imon_disconnect,
+	.id_table = imon_table
+};
+
+module_usb_driver(imon_driver);
+
+MODULE_DESCRIPTION("Early raw iMON IR devices");
+MODULE_AUTHOR("Sean Young <sean@mess.org>");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(usb, imon_table);
-- 
2.14.3
