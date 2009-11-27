Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:59189 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbZK0Be2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 20:34:28 -0500
Subject: [IR-RFC PATCH v4 6/6] Microsoft mceusb2 driver for in-kernel IR
	subsystem
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-input@vger.kernel.org
From: Jon Smirl <jonsmirl@gmail.com>
Date: Thu, 26 Nov 2009 20:34:31 -0500
Message-ID: <20091127013431.7671.41160.stgit@terra>
In-Reply-To: <20091127013217.7671.32355.stgit@terra>
References: <20091127013217.7671.32355.stgit@terra>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

USB device commonly found on Microsoft Media Center boxes.

Hardware can send and recieve at all common IR frequencies - 36K, 38K, 40K, 56K
---
 drivers/input/ir/Kconfig      |    6 
 drivers/input/ir/Makefile     |    1 
 drivers/input/ir/ir-mceusb2.c |  745 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 752 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/ir/ir-mceusb2.c

diff --git a/drivers/input/ir/Kconfig b/drivers/input/ir/Kconfig
index 172c0c6..b854900 100644
--- a/drivers/input/ir/Kconfig
+++ b/drivers/input/ir/Kconfig
@@ -17,5 +17,11 @@ config IR_GPT
 	default m
 	help
 	  Driver for GPT-based IR receiver found on Digispeaker
+	  
+config IR_MCEUSB2
+	tristate "Microsoft Media Center Ed. Receiver, v2"
+	default m
+	help
+	  Driver for the Microsoft Media Center Ed. Receiver, v2
 
 endif
diff --git a/drivers/input/ir/Makefile b/drivers/input/ir/Makefile
index ab0da3f..0bdafb0 100644
--- a/drivers/input/ir/Makefile
+++ b/drivers/input/ir/Makefile
@@ -8,4 +8,5 @@ ir-objs := ir-core.o ir-configfs.o
 
 
 obj-$(CONFIG_IR_GPT)		+= ir-gpt.o
+obj-$(CONFIG_IR_MCEUSB2)	+= ir-mceusb2.o
 
diff --git a/drivers/input/ir/ir-mceusb2.c b/drivers/input/ir/ir-mceusb2.c
new file mode 100644
index 0000000..1bc1155
--- /dev/null
+++ b/drivers/input/ir/ir-mceusb2.c
@@ -0,0 +1,745 @@
+/*
+ * LIRC driver for Philips eHome USB Infrared Transceiver
+ * and the Microsoft MCE 2005 Remote Control
+ *
+ * (C) by Martin A. Blatter <martin_a_blatter@yahoo.com>
+ *
+ * Transmitter support and reception code cleanup.
+ * (C) by Daniel Melander <lirc@rajidae.se>
+ *
+ * Derived from ATI USB driver by Paul Miller and the original
+ * MCE USB driver by Dan Corti
+ *
+ * This driver will only work reliably with kernel version 2.6.10
+ * or higher, probably because of differences in USB device enumeration
+ * in the kernel code. Device initialization fails most of the time
+ * with earlier kernel versions.
+ *
+ **********************************************************************
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
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/input.h>
+
+#define DRIVER_AUTHOR	"Daniel Melander <lirc@rajidae.se>, " \
+			"Martin Blatter <martin_a_blatter@yahoo.com>"
+#define DRIVER_DESC	"Philips eHome USB IR Transceiver and Microsoft " \
+			"MCE 2005 Remote Control driver"
+#define DRIVER_NAME	"ir_mceusb2"
+
+#define USB_BUFLEN	16	/* USB reception buffer length */
+#define LIRCBUF_SIZE	256	/* LIRC work buffer length */
+
+/* MCE constants */
+#define MCE_CMDBUF_SIZE	384 /* MCE Command buffer length */
+#define MCE_TIME_BASE	50 /* Approx 50us resolution */
+#define MCE_CODE_LENGTH	5 /* Normal length of packet (with header) */
+#define MCE_PACKET_SIZE	4 /* Normal length of packet (without header) */
+#define MCE_PACKET_HEADER 0x84 /* Actual header format is 0x80 + num_bytes */
+#define MCE_CONTROL_HEADER 0x9F /* MCE status header */
+#define MCE_TX_HEADER_LENGTH 3 /* # of bytes in the initializing tx header */
+#define MCE_MAX_CHANNELS 2 /* Two transmitters, hardware dependent? */
+#define MCE_DEFAULT_TX_MASK 0x03 /* Val opts: TX1=0x01, TX2=0x02, ALL=0x03 */
+#define MCE_PULSE_BIT	0x80 /* Pulse bit, MSB set == PULSE else SPACE */
+#define MCE_PULSE_MASK	0x7F /* Pulse mask */
+#define MCE_MAX_PULSE_LENGTH 0x7F /* Longest transmittable pulse symbol */
+#define MCE_PACKET_LENGTH_MASK  0x7 /* Packet length */
+
+
+/* general constants */
+#define SEND_FLAG_IN_PROGRESS	1
+#define SEND_FLAG_COMPLETE	2
+#define RECV_FLAG_IN_PROGRESS	3
+#define RECV_FLAG_COMPLETE	4
+
+#define PHILUSB_RECEIVE		1
+#define PHILUSB_SEND	2
+
+#define VENDOR_PHILIPS		0x0471
+#define VENDOR_SMK		0x0609
+#define VENDOR_TATUNG		0x1460
+#define VENDOR_GATEWAY		0x107b
+#define VENDOR_SHUTTLE		0x1308
+#define VENDOR_SHUTTLE2		0x051c
+#define VENDOR_MITSUMI		0x03ee
+#define VENDOR_TOPSEED		0x1784
+#define VENDOR_RICAVISION	0x179d
+#define VENDOR_ITRON		0x195d
+#define VENDOR_FIC		0x1509
+#define VENDOR_LG		0x043e
+#define VENDOR_MICROSOFT	0x045e
+#define VENDOR_FORMOSA		0x147a
+#define VENDOR_FINTEK		0x1934
+#define VENDOR_PINNACLE		0x2304
+
+static struct usb_device_id usb_remote_table[] = {
+	/* Philips eHome Infrared Transceiver */
+	{ USB_DEVICE(VENDOR_PHILIPS, 0x0815) },
+	/* Philips Infrared Transceiver - HP branded */
+	{ USB_DEVICE(VENDOR_PHILIPS, 0x060c) },
+	/* Philips SRM5100 */
+	{ USB_DEVICE(VENDOR_PHILIPS, 0x060d) },
+	/* Philips Infrared Transceiver - Omaura */
+	{ USB_DEVICE(VENDOR_PHILIPS, 0x060f) },
+	/* SMK/Toshiba G83C0004D410 */
+	{ USB_DEVICE(VENDOR_SMK, 0x031d) },
+	/* SMK eHome Infrared Transceiver (Sony VAIO) */
+	{ USB_DEVICE(VENDOR_SMK, 0x0322) },
+	/* bundled with Hauppauge PVR-150 */
+	{ USB_DEVICE(VENDOR_SMK, 0x0334) },
+	/* Tatung eHome Infrared Transceiver */
+	{ USB_DEVICE(VENDOR_TATUNG, 0x9150) },
+	/* Shuttle eHome Infrared Transceiver */
+	{ USB_DEVICE(VENDOR_SHUTTLE, 0xc001) },
+	/* Shuttle eHome Infrared Transceiver */
+	{ USB_DEVICE(VENDOR_SHUTTLE2, 0xc001) },
+	/* Gateway eHome Infrared Transceiver */
+	{ USB_DEVICE(VENDOR_GATEWAY, 0x3009) },
+	/* Mitsumi */
+	{ USB_DEVICE(VENDOR_MITSUMI, 0x2501) },
+	/* Topseed eHome Infrared Transceiver */
+	{ USB_DEVICE(VENDOR_TOPSEED, 0x0001) },
+	/* Topseed HP eHome Infrared Transceiver */
+	{ USB_DEVICE(VENDOR_TOPSEED, 0x0006) },
+	/* Topseed eHome Infrared Transceiver */
+	{ USB_DEVICE(VENDOR_TOPSEED, 0x0007) },
+	/* Topseed eHome Infrared Transceiver */
+	{ USB_DEVICE(VENDOR_TOPSEED, 0x0008) },
+	/* Ricavision internal Infrared Transceiver */
+	{ USB_DEVICE(VENDOR_RICAVISION, 0x0010) },
+	/* Itron ione Libra Q-11 */
+	{ USB_DEVICE(VENDOR_ITRON, 0x7002) },
+	/* FIC eHome Infrared Transceiver */
+	{ USB_DEVICE(VENDOR_FIC, 0x9242) },
+	/* LG eHome Infrared Transceiver */
+	{ USB_DEVICE(VENDOR_LG, 0x9803) },
+	/* Microsoft MCE Infrared Transceiver */
+	{ USB_DEVICE(VENDOR_MICROSOFT, 0x00a0) },
+	/* Formosa eHome Infrared Transceiver */
+	{ USB_DEVICE(VENDOR_FORMOSA, 0xe015) },
+	/* Formosa21 / eHome Infrared Receiver */
+	{ USB_DEVICE(VENDOR_FORMOSA, 0xe016) },
+	/* Formosa aim / Trust MCE Infrared Receiver */
+	{ USB_DEVICE(VENDOR_FORMOSA, 0xe017) },
+	/* Formosa Industrial Computing / Beanbag Emulation Device */
+	{ USB_DEVICE(VENDOR_FORMOSA, 0xe018) },
+	/* Fintek eHome Infrared Transceiver */
+	{ USB_DEVICE(VENDOR_FINTEK, 0x0602) },
+	/* Pinnacle Remote Kit */
+	{ USB_DEVICE(VENDOR_PINNACLE, 0x0225) },
+	/* Terminating entry */
+	{ }
+};
+
+static struct usb_device_id pinnacle_list[] = {
+	{ USB_DEVICE(VENDOR_PINNACLE, 0x0225) },
+	{}
+};
+
+static struct usb_device_id xmit_inverted[] = {
+	{ USB_DEVICE(VENDOR_SMK, 0x031d) },
+	{ USB_DEVICE(VENDOR_SMK, 0x0322) },
+	{ USB_DEVICE(VENDOR_SMK, 0x0334) },
+	{ USB_DEVICE(VENDOR_TOPSEED, 0x0001) },
+	{ USB_DEVICE(VENDOR_TOPSEED, 0x0007) },
+	{ USB_DEVICE(VENDOR_TOPSEED, 0x0008) },
+	{ USB_DEVICE(VENDOR_PINNACLE, 0x0225) },
+	{}
+};
+
+/* data structure for each usb remote */
+struct irctl {
+
+	/* usb */
+	struct usb_device *usbdev;
+	struct urb *urb_in;
+	struct usb_endpoint_descriptor *usb_ep_in;
+	struct usb_endpoint_descriptor *usb_ep_out;
+
+	/* buffers and dma */
+	unsigned char *buf_in;
+	unsigned int len_in;
+	dma_addr_t dma_in;
+	dma_addr_t dma_out;
+
+	struct {
+		u32 connected:1;
+		u32 pinnacle:1;
+		u32 transmitter_mask_inverted:1;
+		u32 reserved:29;
+	} flags;
+
+	/* handle sending (init strings) */
+	int send_flags;
+	int carrier;
+	char name[128];
+	char phys[128];
+
+	struct {
+		unsigned int command, partial, delta, bit;
+	} last;
+	struct input_dev *input;
+};
+
+/* init strings */
+static char init1[] = {0x00, 0xff, 0xaa, 0xff, 0x0b};
+static char init2[] = {0xff, 0x18};
+
+static char pin_init1[] = { 0x9f, 0x07};
+static char pin_init2[] = { 0x9f, 0x13};
+static char pin_init3[] = { 0x9f, 0x0d};
+
+static void usb_send_callback(struct urb *urb, struct pt_regs *regs)
+{
+	struct irctl *ir = urb->context;
+	int len= urb->actual_length;
+
+	dev_dbg(&ir->usbdev->dev, "usb_send_callback (status=%d len=%d)\n", urb->status, len);
+#ifdef DEBUG
+	print_hex_dump_bytes("MCEUSB2 data: ", DUMP_PREFIX_NONE, urb->transfer_buffer, len);
+#endif
+}
+
+
+static void usb_receive_callback(struct urb *urb, struct pt_regs *regs)
+{
+	struct irctl *ir = urb->context;
+	int len= urb->actual_length;
+
+	dev_dbg(&ir->usbdev->dev, "usb_receive_callback (status=%d len=%d)\n", urb->status, len);
+#ifdef DEBUG
+	print_hex_dump_bytes("MCEUSB2 data: ", DUMP_PREFIX_NONE, urb->transfer_buffer, len);
+#endif
+}
+
+
+/* request incoming or send outgoing usb packet - used to initialize remote */
+static int request_packet_async(struct irctl *ir, struct usb_endpoint_descriptor *ep,
+				 unsigned char *data, int size, int urb_type)
+{
+	int res;
+	struct urb *async_urb;
+	unsigned char *async_buf;
+
+	switch (urb_type) {
+	case PHILUSB_SEND:
+	case PHILUSB_RECEIVE:
+		async_urb = usb_alloc_urb(0, GFP_KERNEL);
+		if (!async_urb) {
+			dev_dbg(&ir->usbdev->dev, "Failed to allocate URB\n");
+			return -ENOMEM;
+		}
+		/* alloc buffer */
+		async_buf = kmalloc(size, GFP_KERNEL);
+		if (!async_buf) {
+			usb_free_urb(async_urb);
+			dev_dbg(&ir->usbdev->dev, "Failed to allocate async_buf\n");
+			return -ENOMEM;
+		}
+
+		if (urb_type == PHILUSB_SEND) {
+			/* outbound data */
+			usb_fill_int_urb(async_urb, ir->usbdev,
+				usb_sndintpipe(ir->usbdev, ep->bEndpointAddress),
+				async_buf, size, (usb_complete_t) usb_send_callback,
+				ir, ep->bInterval);
+
+			memcpy(async_buf, data, size);
+			dev_dbg(&ir->usbdev->dev, "request_packet_async called (size=%#x, send)\n", size);
+		} else {
+			/* inbound data */
+			usb_fill_int_urb(async_urb, ir->usbdev,
+				usb_rcvintpipe(ir->usbdev, ep->bEndpointAddress),
+				async_buf, size, (usb_complete_t) usb_receive_callback,
+				ir, ep->bInterval);
+			dev_dbg(&ir->usbdev->dev, "request_packet_async called (size=%#x, receive)\n", size);
+		}
+		break;
+	default:
+	case 0:
+		/* standard request */
+		async_urb = ir->urb_in;
+		ir->send_flags = RECV_FLAG_IN_PROGRESS;
+		dev_dbg(&ir->usbdev->dev, "request_packet_async called (size=%#x, standard)\n", size);
+		break;
+	}
+
+	async_urb->transfer_buffer_length = size;
+	async_urb->dev = ir->usbdev;
+
+	res = usb_submit_urb(async_urb, GFP_ATOMIC);
+	if (res)
+		dev_dbg(&ir->usbdev->dev, "request_packet_async (res=%d)\n", res);
+	return res;
+}
+
+static void usb_remote_recv(struct urb *urb, struct pt_regs *regs)
+{
+	struct irctl *ir;
+	int buf_len;
+	int i, delta, bit;
+
+	if (!urb)
+		return;
+
+	ir = urb->context;
+	if (!ir) {
+		usb_unlink_urb(urb);
+		return;
+	}
+	buf_len = urb->actual_length;
+
+#ifdef DEBUG
+	print_hex_dump_bytes("MCEUSB2 data: ", DUMP_PREFIX_NONE, urb->transfer_buffer, buf_len);
+#endif
+
+	if (ir->send_flags == RECV_FLAG_IN_PROGRESS) {
+		ir->send_flags = SEND_FLAG_COMPLETE;
+		dev_dbg(&ir->usbdev->dev, "setup answer received %d bytes\n", buf_len);
+	}
+	switch (urb->status) {
+	/* success */
+	case 0:
+		for (i = 0; i < buf_len;) {
+			if (ir->last.partial == 0) {
+				/* decode mce packets of the form (84),AA,BB,CC,DD */
+				/* IR data packets can span USB messages - partial */
+				ir->last.partial = (ir->buf_in[i] & MCE_PACKET_LENGTH_MASK);
+				ir->last.command =  ir->buf_in[i] & ~MCE_PACKET_LENGTH_MASK;
+				i++;
+			}
+			for (; (ir->last.partial > 0) && (i < buf_len); i++) {
+				ir->last.partial--;
+
+				if (ir->last.command == 0x80) {
+					bit = ((ir->buf_in[i] & MCE_PULSE_BIT) != 0);
+					delta = (ir->buf_in[i] & MCE_PULSE_MASK) * MCE_TIME_BASE;
+
+					if ((ir->buf_in[i] & MCE_PULSE_MASK) == 0x7f) {
+						if (ir->last.bit == bit)
+							ir->last.delta += delta;
+						else {
+							ir->last.delta = delta;
+							ir->last.bit = bit;
+						}
+						continue;
+					}
+					delta += ir->last.delta;
+					ir->last.delta = 0;
+					ir->last.bit = bit;
+
+					dev_dbg(&ir->usbdev->dev, "bit %d delta %d\n", bit, delta);
+					if (bit)
+						delta = -delta;
+
+					input_ir_queue(ir->input, delta);
+				}
+			}
+		}
+		break;
+
+		/* unlink */
+	case -ECONNRESET:
+	case -ENOENT:
+	case -ESHUTDOWN:
+		usb_unlink_urb(urb);
+		return;
+
+	case -EPIPE:
+	default:
+		break;
+	}
+
+	/* resubmit urb */
+	usb_submit_urb(urb, GFP_ATOMIC);
+}
+
+
+/* Sets the send carrier frequency */
+static int set_carrier(struct irctl *ir, int carrier)
+{
+	int clk = 10000000;
+	int prescaler = 0, divisor = 0;
+	unsigned char cmdbuf[] = { 0x9F, 0x06, 0x01, 0x80 };
+
+	/* Carrier is changed */
+	if (ir->carrier != carrier) {
+
+		if (carrier <= 0) {
+			ir->carrier = carrier;
+			dev_dbg(&ir->usbdev->dev, "SET_CARRIER disabling carrier modulation\n");
+			request_packet_async(ir, ir->usb_ep_out,
+					     cmdbuf, sizeof(cmdbuf), PHILUSB_SEND);
+			return carrier;
+		}
+
+		for (prescaler = 0; prescaler < 4; ++prescaler) {
+			divisor = (clk >> (2 * prescaler)) / carrier;
+			if (divisor <= 0xFF) {
+				ir->carrier = carrier;
+				cmdbuf[2] = prescaler;
+				cmdbuf[3] = divisor;
+				dev_dbg(&ir->usbdev->dev, "SET_CARRIER requesting %d Hz\n", carrier);
+
+				/* Transmit the new carrier to the mce
+				   device */
+				request_packet_async(ir, ir->usb_ep_out,
+						     cmdbuf, sizeof(cmdbuf), PHILUSB_SEND);
+				return carrier;
+			}
+		}
+		return -EINVAL;
+	}
+	return carrier;
+}
+
+static int send(void *private, unsigned int *buffer, unsigned int count,
+		unsigned int frequency, unsigned int xmitters)
+{
+	struct irctl *ir = (struct irctl *)private;
+
+	int i, cmdcount = 0;
+	unsigned char cmdbuf[MCE_CMDBUF_SIZE]; /* MCE command buffer */
+	unsigned long signal_duration = 0; /* Signal length in us */
+
+	if (!ir && !ir->usb_ep_out)
+		return -EFAULT;
+
+	set_carrier(ir, frequency);
+
+	/* MCE tx init header */
+	cmdbuf[cmdcount++] = MCE_CONTROL_HEADER;
+	cmdbuf[cmdcount++] = 0x08;
+	cmdbuf[cmdcount++] = (ir->flags.transmitter_mask_inverted ? ~xmitters : xmitters) << 1;
+
+	/* Generate mce packet data */
+	for (i = 0; (i < count) && (cmdcount < MCE_CMDBUF_SIZE); i++) {
+		signal_duration += buffer[i];
+		buffer[i] = buffer[i] / MCE_TIME_BASE;
+
+		do { /* loop to support long pulses/spaces > 127*50us=6.35ms */
+
+			/* Insert mce packet header every 4th entry */
+			if ((cmdcount < MCE_CMDBUF_SIZE) && (cmdcount - MCE_TX_HEADER_LENGTH) % MCE_CODE_LENGTH == 0)
+				cmdbuf[cmdcount++] = MCE_PACKET_HEADER;
+
+			/* Insert mce packet data */
+			if (cmdcount < MCE_CMDBUF_SIZE)
+				cmdbuf[cmdcount++] = (buffer[i] < MCE_PULSE_BIT ? buffer[i] :
+					MCE_MAX_PULSE_LENGTH) | (i & 1 ? 0x00 : MCE_PULSE_BIT);
+			else
+				return -EINVAL;
+		} while ((buffer[i] > MCE_MAX_PULSE_LENGTH) && (buffer[i] -= MCE_MAX_PULSE_LENGTH));
+	}
+
+	/* Fix packet length in last header */
+	cmdbuf[cmdcount - (cmdcount - MCE_TX_HEADER_LENGTH) % MCE_CODE_LENGTH] =
+		0x80 + (cmdcount - MCE_TX_HEADER_LENGTH) % MCE_CODE_LENGTH - 1;
+
+	/* Check if we have room for the empty packet at the end */
+	if (cmdcount >= MCE_CMDBUF_SIZE)
+		return -EINVAL;
+
+	/* All mce commands end with an empty packet (0x80) */
+	cmdbuf[cmdcount++] = 0x80;
+
+	/* Transmit the command to the mce device */
+	request_packet_async(ir, ir->usb_ep_out, cmdbuf, cmdcount, PHILUSB_SEND);
+
+	return 0;
+}
+
+static int usb_remote_probe(struct usb_interface *intf,
+				const struct usb_device_id *id)
+{
+	struct usb_device *dev = interface_to_usbdev(intf);
+	struct usb_host_interface *idesc;
+	struct usb_endpoint_descriptor *ep = NULL;
+	struct usb_endpoint_descriptor *ep_in = NULL;
+	struct usb_endpoint_descriptor *ep_out = NULL;
+	struct usb_host_config *config;
+	struct irctl *ir = NULL;
+	int i, devnum, pipe, maxp, ret, is_pinnacle;
+
+	dev_dbg(&dev->dev, "usb probe called\n");
+
+	usb_reset_device(dev);
+
+	config = dev->actconfig;
+
+	idesc = intf->cur_altsetting;
+
+	is_pinnacle = usb_match_id(intf, pinnacle_list) ? 1 : 0;
+
+	/* step through the endpoints to find first bulk in and out endpoint */
+	for (i = 0; i < idesc->desc.bNumEndpoints; ++i) {
+		ep = &idesc->endpoint[i].desc;
+
+		if ((ep_in == NULL)
+				&& ((ep->bEndpointAddress & USB_ENDPOINT_DIR_MASK) == USB_DIR_IN)
+				&& (((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) == USB_ENDPOINT_XFER_BULK)
+					|| ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) == USB_ENDPOINT_XFER_INT))) {
+
+			dev_dbg(&dev->dev, "acceptable inbound endpoint found\n");
+			ep_in = ep;
+			ep_in->bmAttributes = USB_ENDPOINT_XFER_INT;
+
+			/*
+			 * setting seems to 1 seem to cause issues with
+			 * Pinnacle timing out on transfer.
+			 */
+			if (is_pinnacle)
+				ep_in->bInterval = ep->bInterval;
+			else
+				ep_in->bInterval = 1;
+		}
+		if ((ep_out == NULL)
+			&& ((ep->bEndpointAddress & USB_ENDPOINT_DIR_MASK) == USB_DIR_OUT)
+			&& (((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) == USB_ENDPOINT_XFER_BULK)
+				|| ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) == USB_ENDPOINT_XFER_INT))) {
+
+			dev_dbg(&dev->dev, "acceptable outbound endpoint found\n");
+			ep_out = ep;
+			ep_out->bmAttributes = USB_ENDPOINT_XFER_INT;
+
+			/*
+			 * setting seems to 1 seem to cause issues with
+			 * Pinnacle timing out on transfer.
+			 */
+			if (is_pinnacle)
+				ep_out->bInterval = ep->bInterval;
+			else
+				ep_out->bInterval = 1;
+		}
+	}
+	if (ep_in == NULL) {
+		dev_dbg(&dev->dev, "inbound and/or endpoint not found\n");
+		return -ENODEV;
+	}
+	devnum = dev->devnum;
+	pipe = usb_rcvintpipe(dev, ep_in->bEndpointAddress);
+	maxp = usb_maxpacket(dev, pipe, usb_pipeout(pipe));
+
+	/* allocate kernel memory */
+	ir = kzalloc(sizeof(struct irctl), GFP_KERNEL);
+	if (!ir)
+		return -ENOMEM;
+
+	ir->buf_in = usb_buffer_alloc(dev, maxp, GFP_ATOMIC, &ir->dma_in);
+	if (!ir->buf_in) {
+		ret = -ENOMEM;
+		goto free_mem;
+	}
+	ir->urb_in = usb_alloc_urb(0, GFP_KERNEL);
+	if (!ir->urb_in) {
+		ret = -ENOMEM;
+		goto free_buffer;
+	}
+
+	ir->usbdev = dev;
+	ir->len_in = maxp;
+	ir->flags.connected = 0;
+	ir->flags.pinnacle = is_pinnacle;
+	ir->flags.transmitter_mask_inverted =
+		usb_match_id(intf, xmit_inverted) ? 0 : 1;
+
+	/* Saving usb interface data for use by the transmitter routine */
+	ir->usb_ep_in = ep_in;
+	ir->usb_ep_out = ep_out;
+
+	/* inbound data */
+	usb_fill_int_urb(ir->urb_in, dev, pipe, ir->buf_in,
+		maxp, (usb_complete_t) usb_remote_recv, ir, ep_in->bInterval);
+
+	/* initialize device */
+	if (ir->flags.pinnacle) {
+		int usbret;
+
+		/*
+		 * I have no idea why but this reset seems to be crucial to
+		 * getting the device to do outbound IO correctly - without
+		 * this the device seems to hang, ignoring all input - although
+		 * IR signals are correctly sent from the device, no input is
+		 * interpreted by the device and the host never does the
+		 * completion routine
+		 */
+
+		usbret = usb_reset_configuration(dev);
+		dev_info(&dev->dev, "usb reset config ret %x\n", usbret);
+
+		/*
+		 * its possible we really should wait for a return
+		 * for each of these...
+		 */
+		request_packet_async(ir, ep_in, NULL, maxp, PHILUSB_RECEIVE);
+		request_packet_async(ir, ep_out, pin_init1, sizeof(pin_init1), PHILUSB_SEND);
+		request_packet_async(ir, ep_in, NULL, maxp, PHILUSB_RECEIVE);
+		request_packet_async(ir, ep_out, pin_init2, sizeof(pin_init2), PHILUSB_SEND);
+		request_packet_async(ir, ep_in, NULL, maxp, PHILUSB_RECEIVE);
+		request_packet_async(ir, ep_out, pin_init3, sizeof(pin_init3), PHILUSB_SEND);
+		/* if we dont issue the correct number of receives
+		 * (PHILUSB_RECEIVE) for each outbound, then the first few ir
+		 * pulses will be interpreted by the usb_async_callback routine
+		 * - we should ensure we have the right amount OR less - as the
+		 * usb_remote_recv routine will handle the control packets OK -
+		 * they start with 0x9f - but the async callback doesnt handle
+		 * ir pulse packets
+		 */
+		request_packet_async(ir, ep_in, NULL, maxp, 0);
+	} else {
+		request_packet_async(ir, ep_in, NULL, maxp, PHILUSB_RECEIVE);
+		request_packet_async(ir, ep_out, init1, sizeof(init1), PHILUSB_SEND);
+		request_packet_async(ir, ep_in, NULL, maxp, PHILUSB_RECEIVE);
+		request_packet_async(ir, ep_out, init2, sizeof(init2), PHILUSB_SEND);
+		request_packet_async(ir, ep_in, NULL, maxp, 0);
+	}
+	usb_set_intfdata(intf, ir);
+
+	ir->input = input_allocate_device();
+	if (!ir->input) {
+		ret = -ENOMEM;
+		goto free_urb;
+	}
+	ret = input_ir_create(ir->input, ir, send);
+	if (ret)
+		goto free_input;
+
+	ir->name[0] = '\0';
+	if (dev->descriptor.iManufacturer)
+		usb_string(dev, dev->descriptor.iManufacturer, ir->name, sizeof(ir->name));
+	i = strlen(ir->name);
+	ir->name[i++] = ' ';
+	if (dev->descriptor.iProduct)
+		usb_string(dev, dev->descriptor.iProduct, &ir->name[i], sizeof(ir->name) - i);
+	dev_info(&dev->dev, "%s\n", ir->name);
+
+	ir->input->id.bustype = BUS_USB;
+	ir->input->id.vendor = le16_to_cpu(dev->descriptor.idVendor);
+	ir->input->id.product = le16_to_cpu(dev->descriptor.idProduct);
+	ir->input->name = ir->name;
+	usb_make_path(dev, ir->phys, sizeof(ir->phys));
+	strlcat(ir->phys, "/input0", sizeof(ir->phys));
+	ir->input->phys = ir->phys;
+
+	ir->input->irbit[0] |= BIT_MASK(IR_CAP_RECEIVE_BASEBAND);
+	ir->input->irbit[0] |= BIT_MASK(IR_CAP_RECEIVE_36K);
+	ir->input->irbit[0] |= BIT_MASK(IR_CAP_RECEIVE_38K);
+	ir->input->irbit[0] |= BIT_MASK(IR_CAP_RECEIVE_40K);
+	ir->input->irbit[0] |= BIT_MASK(IR_CAP_RECEIVE_56K);
+	ir->input->irbit[0] |= BIT_MASK(IR_CAP_SEND_BASEBAND);
+	ir->input->irbit[0] |= BIT_MASK(IR_CAP_SEND_36K);
+	ir->input->irbit[0] |= BIT_MASK(IR_CAP_SEND_38K);
+	ir->input->irbit[0] |= BIT_MASK(IR_CAP_SEND_40K);
+	ir->input->irbit[0] |= BIT_MASK(IR_CAP_SEND_56K);
+	ir->input->irbit[0] |= BIT_MASK(IR_CAP_XMITTER_1);
+	ir->input->irbit[0] |= BIT_MASK(IR_CAP_XMITTER_2);
+	ir->input->irbit[0] |= BIT_MASK(IR_CAP_RECEIVE_RAW);
+	ir->input->irbit[0] |= BIT_MASK(IR_CAP_SEND_RAW);
+
+	ret = input_register_device(ir->input);
+	if (ret)
+		goto free_input;
+	ret = input_ir_register(ir->input);
+	if (ret)
+		goto free_input;
+
+	return 0;
+
+free_input:
+	input_free_device(ir->input);
+free_urb:
+	usb_free_urb(ir->urb_in);
+free_buffer:
+	usb_buffer_free(dev, maxp, ir->buf_in, ir->dma_in);
+free_mem:
+	kfree(ir);
+	dev_err(&dev->dev, "failed to load (code=%d)\n", ret);
+	return ret;
+}
+
+
+static void usb_remote_disconnect(struct usb_interface *intf)
+{
+	struct usb_device *dev = interface_to_usbdev(intf);
+	struct irctl *ir = usb_get_intfdata(intf);
+
+	usb_set_intfdata(intf, NULL);
+
+	if (!ir)
+		return;
+
+	ir->usbdev = NULL;
+	input_unregister_device(ir->input);
+
+	usb_kill_urb(ir->urb_in);
+	usb_free_urb(ir->urb_in);
+	usb_buffer_free(dev, ir->len_in, ir->buf_in, ir->dma_in);
+}
+
+static int usb_remote_suspend(struct usb_interface *intf, pm_message_t message)
+{
+	struct irctl *ir = usb_get_intfdata(intf);
+	dev_dbg(&ir->usbdev->dev, "suspend\n");
+	usb_kill_urb(ir->urb_in);
+	return 0;
+}
+
+static int usb_remote_resume(struct usb_interface *intf)
+{
+	struct irctl *ir = usb_get_intfdata(intf);
+	dev_dbg(&ir->usbdev->dev, "resume\n");
+	if (usb_submit_urb(ir->urb_in, GFP_ATOMIC))
+		return -EIO;
+	return 0;
+}
+
+static struct usb_driver usb_remote_driver = {
+	.name =		DRIVER_NAME,
+	.probe =	usb_remote_probe,
+	.disconnect =	usb_remote_disconnect,
+	.suspend =	usb_remote_suspend,
+	.resume =	usb_remote_resume,
+	.id_table =	usb_remote_table
+};
+
+static int __init usb_remote_init(void)
+{
+	int ret;
+
+	ret = usb_register(&usb_remote_driver);
+	if (ret < 0) {
+		printk(DRIVER_NAME ": usb register failed, result = %d\n", ret);
+		return ret;
+	}
+	return 0;
+}
+
+static void __exit usb_remote_exit(void)
+{
+	usb_deregister(&usb_remote_driver);
+}
+
+module_init(usb_remote_init);
+module_exit(usb_remote_exit);
+
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(usb, usb_remote_table);

