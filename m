Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:65526 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbZKTHOL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2009 02:14:11 -0500
Message-ID: <4B0641C2.1050200@freemail.hu>
Date: Fri, 20 Nov 2009 08:14:10 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>, linux-input@vger.kernel.org
CC: Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC, PATCH 1/2] gspca: add input support for interrupt endpoints
References: <4B04F7E0.1090803@freemail.hu> <4B05074B.1030407@redhat.com>
In-Reply-To: <4B05074B.1030407@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
Hans de Goede wrote:
> Hi Márton,
> 
> On 11/19/2009 08:46 AM, Németh Márton wrote:
>> Add helper functions for interrupt endpoint based input handling.
> First of all many many thanks for doing this!

You are welcome :-) . My goal is to just make my webcam working properly...

>> maybe a new configuration option should be also introduced?
> 
> I'm personally not a big fan of adding more configuration options,
> what should be done instead is make the compilation dependent on the
> CONFIG_INPUT kernel config option, I see no reason not to enable this
> when CONFIG_INPUT is enabled.

I added dependency on CONFIG_INPUT.

> Some other remarks, you are using:
> printk(KERN_DEBUG
> In various places, please use
> PDEBUG(D_FOO
> instead so that the output can be controlled using the gspca module's
> debug parameter.

I created a PDEBUG_INPUT() for this otherwise there is a circular dependency
between gspca_main and gspca_input because of the variable gspca_debug.

> And in gspca_input_connect() you are setting name to "pac7302", this
> needs to be generalized somehow,

I use now gspca_dev->sd_desc->name.

> and also you are not setting the
> input device's parent there, I think we need to fix that too
> (although I'm not sure what it should be set to).

I don't know what to use there, maybe somebody on the linux-input
mailing list could tell.

Also, I am not sure about setting of input_dev->id.version.

Unfortunately I still get the following error when I start streaming,
stop streaming or unplug the device:

[ 6876.780726] uhci_hcd 0000:00:10.1: dma_pool_free buffer-32, de0ad168/1e0ad168 (bad dma)

Please find the new version of this patch later in this mail.

Regards,

	Márton Németh
---
From: Márton Németh <nm127@freemail.hu>

Add helper functions for interrupt endpoint based input handling.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r abfdd03b800d linux/drivers/media/video/gspca/Makefile
--- a/linux/drivers/media/video/gspca/Makefile	Thu Nov 19 10:34:21 2009 +0100
+++ b/linux/drivers/media/video/gspca/Makefile	Fri Nov 20 07:56:22 2009 +0100
@@ -1,4 +1,7 @@
 obj-$(CONFIG_USB_GSPCA)          += gspca_main.o
+ifeq ($(CONFIG_INPUT),y)
+    obj-$(CONFIG_USB_GSPCA)          += gspca_input.o
+endif
 obj-$(CONFIG_USB_GSPCA_CONEX)    += gspca_conex.o
 obj-$(CONFIG_USB_GSPCA_ETOMS)    += gspca_etoms.o
 obj-$(CONFIG_USB_GSPCA_FINEPIX)  += gspca_finepix.o
@@ -30,6 +33,7 @@
 obj-$(CONFIG_USB_GSPCA_ZC3XX)    += gspca_zc3xx.o

 gspca_main-objs     := gspca.o
+gspca_input-objs    := input.o
 gspca_conex-objs    := conex.o
 gspca_etoms-objs    := etoms.o
 gspca_finepix-objs  := finepix.o
diff -r abfdd03b800d linux/drivers/media/video/gspca/gspca.c
--- a/linux/drivers/media/video/gspca/gspca.c	Thu Nov 19 10:34:21 2009 +0100
+++ b/linux/drivers/media/video/gspca/gspca.c	Fri Nov 20 07:56:22 2009 +0100
@@ -40,6 +40,9 @@
 #include <media/v4l2-ioctl.h>

 #include "gspca.h"
+
+#include <linux/input.h>
+#include "input.h"

 /* global values */
 #define DEF_NURBS 3		/* default number of URBs */
@@ -499,11 +502,13 @@
 			i, ep->desc.bEndpointAddress);
 	gspca_dev->alt = i;		/* memorize the current alt setting */
 	if (gspca_dev->nbalt > 1) {
+		gspca_input_destroy_urb(gspca_dev);
 		ret = usb_set_interface(gspca_dev->dev, gspca_dev->iface, i);
 		if (ret < 0) {
 			err("set alt %d err %d", i, ret);
-			return NULL;
+			ep = NULL;
 		}
+		gspca_input_create_urb(gspca_dev);
 	}
 	return ep;
 }
@@ -707,7 +712,9 @@
 		if (gspca_dev->sd_desc->stopN)
 			gspca_dev->sd_desc->stopN(gspca_dev);
 		destroy_urbs(gspca_dev);
+		gspca_input_destroy_urb(gspca_dev);
 		gspca_set_alt0(gspca_dev);
+		gspca_input_create_urb(gspca_dev);
 	}

 	/* always call stop0 to free the subdriver's resources */
@@ -2088,6 +2095,11 @@

 	usb_set_intfdata(intf, gspca_dev);
 	PDEBUG(D_PROBE, "/dev/video%d created", gspca_dev->vdev.num);
+
+	ret = gspca_input_connect(gspca_dev, id);
+	if (0 <= ret)
+		ret = gspca_input_create_urb(gspca_dev);
+
 	return 0;
 out:
 	kfree(gspca_dev->usb_buf);
@@ -2105,6 +2117,7 @@
 void gspca_disconnect(struct usb_interface *intf)
 {
 	struct gspca_dev *gspca_dev = usb_get_intfdata(intf);
+	struct input_dev *input_dev;

 	PDEBUG(D_PROBE, "/dev/video%d disconnect", gspca_dev->vdev.num);
 	mutex_lock(&gspca_dev->usb_lock);
@@ -2113,6 +2126,13 @@
 	if (gspca_dev->streaming) {
 		destroy_urbs(gspca_dev);
 		wake_up_interruptible(&gspca_dev->wq);
+	}
+
+	gspca_input_destroy_urb(gspca_dev);
+	input_dev = gspca_dev->input_dev;
+	if (input_dev) {
+		gspca_dev->input_dev = NULL;
+		input_unregister_device(input_dev);
 	}

 	/* the device is freed at exit of this function */
@@ -2140,6 +2160,7 @@
 	if (gspca_dev->sd_desc->stopN)
 		gspca_dev->sd_desc->stopN(gspca_dev);
 	destroy_urbs(gspca_dev);
+	gspca_input_destroy_urb(gspca_dev);
 	gspca_set_alt0(gspca_dev);
 	if (gspca_dev->sd_desc->stop0)
 		gspca_dev->sd_desc->stop0(gspca_dev);
@@ -2153,6 +2174,7 @@

 	gspca_dev->frozen = 0;
 	gspca_dev->sd_desc->init(gspca_dev);
+	gspca_input_create_urb(gspca_dev);
 	if (gspca_dev->streaming)
 		return gspca_init_transfer(gspca_dev);
 	return 0;
diff -r abfdd03b800d linux/drivers/media/video/gspca/gspca.h
--- a/linux/drivers/media/video/gspca/gspca.h	Thu Nov 19 10:34:21 2009 +0100
+++ b/linux/drivers/media/video/gspca/gspca.h	Fri Nov 20 07:56:22 2009 +0100
@@ -81,6 +81,9 @@
 typedef void (*cam_pkt_op) (struct gspca_dev *gspca_dev,
 				u8 *data,
 				int len);
+typedef int (*cam_int_pkt_op) (struct gspca_dev *gspca_dev,
+				u8 *data,
+				int len);

 struct ctrl {
 	struct v4l2_queryctrl qctrl;
@@ -116,6 +119,9 @@
 	cam_reg_op get_register;
 #endif
 	cam_ident_op get_chip_ident;
+#ifdef CONFIG_INPUT
+	cam_int_pkt_op int_pkt_scan;
+#endif
 };

 /* packet types when moving from iso buf to frame buf */
@@ -138,6 +144,9 @@
 	struct module *module;		/* subdriver handling the device */
 	struct usb_device *dev;
 	struct file *capt_file;		/* file doing video capture */
+#ifdef CONFIG_INPUT
+	struct input_dev *input_dev;
+#endif

 	struct cam cam;				/* device information */
 	const struct sd_desc *sd_desc;		/* subdriver description */
@@ -147,6 +156,9 @@
 #define USB_BUF_SZ 64
 	__u8 *usb_buf;				/* buffer for USB exchanges */
 	struct urb *urb[MAX_NURBS];
+#ifdef CONFIG_INPUT
+	struct urb *int_urb;
+#endif

 	__u8 *frbuf;				/* buffer for nframes */
 	struct gspca_frame frame[GSPCA_MAX_FRAMES];
diff -r abfdd03b800d linux/drivers/media/video/gspca/input.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/video/gspca/input.c	Fri Nov 20 07:56:22 2009 +0100
@@ -0,0 +1,197 @@
+/*
+ * Input handling for gspca USB camera drivers
+ *
+ * Copyright (C) 2009 Márton Németh <nm127@freemail.hu>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#define MODULE_NAME "gspca_input"
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/input.h>
+
+#include "gspca.h"
+#include "input.h"
+
+MODULE_AUTHOR("Márton Németh <nm127@freemail.hu>");
+MODULE_DESCRIPTION("GSPCA USB Camera Input Driver");
+MODULE_LICENSE("GPL");
+
+#define DRIVER_VERSION_NUMBER	KERNEL_VERSION(0, 0, 1)
+
+#ifdef GSPCA_DEBUG
+int gspca_input_debug = D_ERR | D_PROBE;
+module_param_named(debug, gspca_input_debug, int, 0644);
+MODULE_PARM_DESC(debug,
+		"Debug (bit) 0x01:error 0x02:probe 0x04:config"
+		" 0x08:stream 0x10:frame 0x20:packet 0x40:USBin 0x80:USBout"
+		" 0x0100: v4l2");
+#define PDEBUG_INPUT(level, fmt, args...) \
+	do {\
+		if (gspca_input_debug & (level)) \
+			printk(KERN_INFO MODULE_NAME ": " fmt "\n", ## args); \
+	} while (0)
+#else
+#define PDEBUG_INPUT(level, fmt, args...)
+#endif
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19)
+static void int_irq(struct urb *urb, struct pt_regs *regs)
+#else
+static void int_irq(struct urb *urb)
+#endif
+{
+	struct gspca_dev *gspca_dev = (struct gspca_dev *) urb->context;
+	int ret;
+
+	if (urb->status == 0) {
+		if (gspca_dev->sd_desc->int_pkt_scan(gspca_dev,
+		    urb->transfer_buffer, urb->actual_length) < 0) {
+			PDEBUG_INPUT(D_ERR, "Unknown packet received");
+		}
+
+		ret = usb_submit_urb(urb, GFP_ATOMIC);
+		if (ret < 0)
+			PDEBUG_INPUT(D_ERR, "Resubmit URB failed with error %i", ret);
+	}
+}
+
+int gspca_input_connect(struct gspca_dev *gspca_dev, const struct usb_device_id *id)
+{
+	struct input_dev *input_dev;
+	int err = 0;
+
+	gspca_dev->input_dev = NULL;
+	if (gspca_dev->sd_desc->int_pkt_scan)  {
+		input_dev = input_allocate_device();
+		if (!input_dev)
+			return -ENOMEM;
+
+		input_dev->name = gspca_dev->sd_desc->name;
+		//input_dev->phys = "camera";
+		input_dev->id.bustype = BUS_USB;
+		input_dev->id.vendor = le16_to_cpu(id->idVendor);
+		input_dev->id.product = le16_to_cpu(id->idProduct);
+		input_dev->id.version = le16_to_cpu(id->bcdDevice_hi);
+		//input_dev->id.version = le16_to_cpu(id->bcdDevice_lo);
+
+		input_dev->evbit[0] = BIT_MASK(EV_KEY);
+		input_dev->keybit[BIT_WORD(KEY_CAMERA)] = BIT_MASK(KEY_CAMERA);
+		//input_dev->dev.parent = ;
+
+		err = input_register_device(input_dev);
+		if (err) {
+			PDEBUG_INPUT(D_ERR, "Input device registration failed with error %i", err);
+			input_dev->dev.parent = NULL;
+			input_free_device(input_dev);
+		} else {
+			gspca_dev->input_dev = input_dev;
+		}
+	}
+
+	return err;
+}
+EXPORT_SYMBOL(gspca_input_connect);
+
+int gspca_input_create_urb(struct gspca_dev *gspca_dev)
+{
+	int ret = -EINVAL;
+	struct usb_interface *intf;
+	struct usb_host_interface *intf_desc;
+	struct usb_endpoint_descriptor *ep;
+	int i;
+	struct urb *urb;
+	void* buffer = NULL;
+	unsigned int buffer_len;
+	int interval;
+	struct usb_device *dev;
+
+	if (gspca_dev->sd_desc->int_pkt_scan)  {
+		intf = usb_ifnum_to_if(gspca_dev->dev, gspca_dev->iface);
+		intf_desc = intf->cur_altsetting;
+		for (i = 0; i < intf_desc->desc.bNumEndpoints; i++) {
+			ep = &intf_desc->endpoint[i].desc;
+			if ((ep->bEndpointAddress & USB_DIR_IN) &&
+			    ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
+				== USB_ENDPOINT_XFER_INT)) {
+
+				buffer_len = ep->wMaxPacketSize;
+				interval = ep->bInterval;
+				PDEBUG_INPUT(D_PROBE, "found int in endpoint: 0x%x, buffer_len=%u, interval=%u",
+					ep->bEndpointAddress, buffer_len, interval);
+
+				dev = gspca_dev->dev;
+				gspca_dev->int_urb = NULL;
+
+				buffer = kmalloc(ep->wMaxPacketSize, GFP_KERNEL);
+				if (buffer)
+					urb = usb_alloc_urb(0, GFP_KERNEL);
+				else {
+					PDEBUG_INPUT(D_ERR, "buffer allocation failed\n");
+					kfree(buffer);
+					urb = NULL;
+				}
+				if (buffer && urb) {
+					usb_fill_int_urb(urb, dev,
+						usb_rcvintpipe(dev, ep->bEndpointAddress),
+						buffer, buffer_len,
+						int_irq, (void*)gspca_dev, interval);
+					gspca_dev->int_urb = urb;
+					ret = usb_submit_urb(urb, GFP_KERNEL);
+					if (ret < 0)
+						PDEBUG_INPUT(D_ERR, "submit URB failed with error %i", ret);
+				} else
+					PDEBUG_INPUT(D_ERR, "URB allocation failed");
+			}
+		}
+	}
+	return ret;
+}
+EXPORT_SYMBOL(gspca_input_create_urb);
+
+void gspca_input_destroy_urb(struct gspca_dev *gspca_dev)
+{
+	struct urb *urb;
+
+	urb = gspca_dev->int_urb;
+	if (urb) {
+		gspca_dev->int_urb = NULL;
+		usb_kill_urb(urb);
+		usb_buffer_free(gspca_dev->dev,
+				urb->transfer_buffer_length,
+				urb->transfer_buffer,
+				urb->transfer_dma);
+		usb_free_urb(urb);
+	}
+}
+EXPORT_SYMBOL(gspca_input_destroy_urb);
+
+static int __init gspca_input_init(void)
+{
+	info("v%d.%d.%d registered",
+		(DRIVER_VERSION_NUMBER >> 16) & 0xff,
+		(DRIVER_VERSION_NUMBER >> 8) & 0xff,
+		DRIVER_VERSION_NUMBER & 0xff);
+	return 0;
+}
+static void __exit gspca_input_exit(void)
+{
+	info("deregistered");
+}
+
+module_init(gspca_input_init);
+module_exit(gspca_input_exit);
diff -r abfdd03b800d linux/drivers/media/video/gspca/input.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/video/gspca/input.h	Fri Nov 20 07:56:22 2009 +0100
@@ -0,0 +1,36 @@
+/*
+ * Input handling for gspca USB camera drivers
+ *
+ * Copyright (C) 2009 Márton Németh <nm127@freemail.hu>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef GSPCA_INPUT_H
+#define GSPCA_INPUT_H
+
+#include "gspca.h"
+
+#ifdef CONFIG_INPUT
+int gspca_input_connect(struct gspca_dev *gspca_dev, const struct usb_device_id *id);
+int gspca_input_create_urb(struct gspca_dev *gspca_dev);
+void gspca_input_destroy_urb(struct gspca_dev *gspca_dev);
+#else
+#define gspca_input_connect(gspca_dev, id)	0
+#define gspca_input_create_urb(gspca_dev)	0
+#define gspca_input_destroy_urb(gspca_dev)
+#endif
+
+#endif
