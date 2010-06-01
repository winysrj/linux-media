Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412Ab0FAUcK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jun 2010 16:32:10 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o51KWA5Q015910
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 1 Jun 2010 16:32:10 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [10.16.43.238])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o51KW9X3021572
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 1 Jun 2010 16:32:09 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [127.0.0.1])
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.3) with ESMTP id o51KW89V028178
	for <linux-media@vger.kernel.org>; Tue, 1 Jun 2010 16:32:08 -0400
Received: (from jarod@localhost)
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.4/Submit) id o51KW8kj028176
	for linux-media@vger.kernel.org; Tue, 1 Jun 2010 16:32:08 -0400
Date: Tue, 1 Jun 2010 16:32:08 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2 v2] IR: add mceusb IR receiver driver
Message-ID: <20100601203208.GA28165@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100528200519.GB7397@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a new driver for the Windows Media Center Edition/eHome
Infrared Remote transceiver devices. Its a port of the current
lirc_mceusb driver to ir-core, and currently lacks transmit support,
but will grow it back soon enough... This driver also differs from
lirc_mceusb in that it borrows heavily from a simplified IR buffer
decode routine found in Jon Smirl's earlier ir-mceusb port.

This driver has been tested on the original first-generation MCE IR
device with the MS vendor ID, as well as a current-generation device
with a Topseed vendor ID. Every receiver supported by lirc_mceusb
should work equally well. Testing was done primarily with RC6 MCE
remotes, but also briefly with a Hauppauge RC5 remote, and all works
as expected.

v2: fix call to ir_raw_event_handle so repeats work as they should.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/Kconfig  |   12 +
 drivers/media/IR/Makefile |    1 +
 drivers/media/IR/mceusb.c | 1085 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1098 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/IR/mceusb.c

diff --git a/drivers/media/IR/Kconfig b/drivers/media/IR/Kconfig
index 195c6cf..7ffa86f 100644
--- a/drivers/media/IR/Kconfig
+++ b/drivers/media/IR/Kconfig
@@ -66,3 +66,15 @@ config IR_IMON
 
 	   To compile this driver as a module, choose M here: the
 	   module will be called imon.
+
+config IR_MCEUSB
+	tristate "Windows Media Center Ed. eHome Infrared Transceiver"
+	depends on USB_ARCH_HAS_HCD
+	depends on IR_CORE
+	select USB
+	---help---
+	   Say Y here if you want to use a Windows Media Center Edition
+	   eHome Infrared Transceiver.
+
+	   To compile this driver as a module, choose M here: the
+	   module will be called mceusb.
diff --git a/drivers/media/IR/Makefile b/drivers/media/IR/Makefile
index b998fcc..b43fe36 100644
--- a/drivers/media/IR/Makefile
+++ b/drivers/media/IR/Makefile
@@ -13,3 +13,4 @@ obj-$(CONFIG_IR_SONY_DECODER) += ir-sony-decoder.o
 
 # stand-alone IR receivers/transmitters
 obj-$(CONFIG_IR_IMON) += imon.o
+obj-$(CONFIG_IR_MCEUSB) += mceusb.o
diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
new file mode 100644
index 0000000..fe15091
--- /dev/null
+++ b/drivers/media/IR/mceusb.c
@@ -0,0 +1,1085 @@
+/*
+ * Driver for USB Windows Media Center Ed. eHome Infrared Transceivers
+ *
+ * Copyright (c) 2010 by Jarod Wilson <jarod@redhat.com>
+ *
+ * Based on the original lirc_mceusb and lirc_mceusb2 drivers, by Dan
+ * Conti, Martin Blatter and Daniel Melander, the latter of which was
+ * in turn also based on the lirc_atiusb driver by Paul Miller. The
+ * two mce drivers were merged into one by Jarod Wilson, with transmit
+ * support for the 1st-gen device added primarily by Patrick Calhoun,
+ * with a bit of tweaks by Jarod. Debugging improvements and proper
+ * support for what appears to be 3rd-gen hardware added by Jarod.
+ * Initial port from lirc driver to ir-core drivery by Jarod, based
+ * partially on a port to an earlier proposed IR infrastructure by
+ * Jon Smirl, which included enhancements and simplifications to the
+ * incoming IR buffer parsing routines.
+ *
+ * TODO:
+ * - add rc-core transmit support, once available
+ * - enable support for forthcoming ir-lirc-codec interface
+ *
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
+#include <linux/slab.h>
+#include <linux/usb.h>
+#include <linux/input.h>
+#include <media/ir-core.h>
+#include <media/ir-common.h>
+
+#define DRIVER_VERSION	"1.91"
+#define DRIVER_AUTHOR	"Jarod Wilson <jarod@wilsonet.com>"
+#define DRIVER_DESC	"Windows Media Center Ed. eHome Infrared Transceiver " \
+			"device driver"
+#define DRIVER_NAME	"mceusb"
+
+#define USB_BUFLEN	32	/* USB reception buffer length */
+#define IRBUF_SIZE	256	/* IR work buffer length */
+
+/* MCE constants */
+#define MCE_CMDBUF_SIZE	384 /* MCE Command buffer length */
+#define MCE_TIME_UNIT	50 /* Approx 50us resolution */
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
+#define MCE_PACKET_LENGTH_MASK  0xF /* Packet length mask */
+
+
+/* module parameters */
+#ifdef CONFIG_USB_DEBUG
+static int debug = 1;
+#else
+static int debug;
+#endif
+
+/* general constants */
+#define SEND_FLAG_IN_PROGRESS	1
+#define SEND_FLAG_COMPLETE	2
+#define RECV_FLAG_IN_PROGRESS	3
+#define RECV_FLAG_COMPLETE	4
+
+#define MCEUSB_RX		1
+#define MCEUSB_TX		2
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
+#define VENDOR_ECS		0x1019
+#define VENDOR_WISTRON		0x0fb8
+#define VENDOR_COMPRO		0x185b
+#define VENDOR_NORTHSTAR	0x04eb
+#define VENDOR_REALTEK		0x0bda
+#define VENDOR_TIVO		0x105a
+
+static struct usb_device_id mceusb_dev_table[] = {
+	/* Original Microsoft MCE IR Transceiver (often HP-branded) */
+	{ USB_DEVICE(VENDOR_MICROSOFT, 0x006d) },
+	/* Philips Infrared Transceiver - Sahara branded */
+	{ USB_DEVICE(VENDOR_PHILIPS, 0x0608) },
+	/* Philips Infrared Transceiver - HP branded */
+	{ USB_DEVICE(VENDOR_PHILIPS, 0x060c) },
+	/* Philips SRM5100 */
+	{ USB_DEVICE(VENDOR_PHILIPS, 0x060d) },
+	/* Philips Infrared Transceiver - Omaura */
+	{ USB_DEVICE(VENDOR_PHILIPS, 0x060f) },
+	/* Philips Infrared Transceiver - Spinel plus */
+	{ USB_DEVICE(VENDOR_PHILIPS, 0x0613) },
+	/* Philips eHome Infrared Transceiver */
+	{ USB_DEVICE(VENDOR_PHILIPS, 0x0815) },
+	/* Realtek MCE IR Receiver */
+	{ USB_DEVICE(VENDOR_REALTEK, 0x0161) },
+	/* SMK/Toshiba G83C0004D410 */
+	{ USB_DEVICE(VENDOR_SMK, 0x031d) },
+	/* SMK eHome Infrared Transceiver (Sony VAIO) */
+	{ USB_DEVICE(VENDOR_SMK, 0x0322) },
+	/* bundled with Hauppauge PVR-150 */
+	{ USB_DEVICE(VENDOR_SMK, 0x0334) },
+	/* SMK eHome Infrared Transceiver */
+	{ USB_DEVICE(VENDOR_SMK, 0x0338) },
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
+	/* Topseed eHome Infrared Transceiver */
+	{ USB_DEVICE(VENDOR_TOPSEED, 0x000a) },
+	/* Topseed eHome Infrared Transceiver */
+	{ USB_DEVICE(VENDOR_TOPSEED, 0x0011) },
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
+	/* Formosa21 / eHome Infrared Receiver */
+	{ USB_DEVICE(VENDOR_FORMOSA, 0xe03a) },
+	/* Formosa Industrial Computing AIM IR605/A */
+	{ USB_DEVICE(VENDOR_FORMOSA, 0xe03c) },
+	/* Formosa Industrial Computing */
+	{ USB_DEVICE(VENDOR_FORMOSA, 0xe03e) },
+	/* Fintek eHome Infrared Transceiver */
+	{ USB_DEVICE(VENDOR_FINTEK, 0x0602) },
+	/* Fintek eHome Infrared Transceiver (in the AOpen MP45) */
+	{ USB_DEVICE(VENDOR_FINTEK, 0x0702) },
+	/* Pinnacle Remote Kit */
+	{ USB_DEVICE(VENDOR_PINNACLE, 0x0225) },
+	/* Elitegroup Computer Systems IR */
+	{ USB_DEVICE(VENDOR_ECS, 0x0f38) },
+	/* Wistron Corp. eHome Infrared Receiver */
+	{ USB_DEVICE(VENDOR_WISTRON, 0x0002) },
+	/* Compro K100 */
+	{ USB_DEVICE(VENDOR_COMPRO, 0x3020) },
+	/* Compro K100 v2 */
+	{ USB_DEVICE(VENDOR_COMPRO, 0x3082) },
+	/* Northstar Systems, Inc. eHome Infrared Transceiver */
+	{ USB_DEVICE(VENDOR_NORTHSTAR, 0xe004) },
+	/* TiVo PC IR Receiver */
+	{ USB_DEVICE(VENDOR_TIVO, 0x2000) },
+	/* Terminating entry */
+	{ }
+};
+
+static struct usb_device_id gen3_list[] = {
+	{ USB_DEVICE(VENDOR_PINNACLE, 0x0225) },
+	{ USB_DEVICE(VENDOR_TOPSEED, 0x0008) },
+	{}
+};
+
+static struct usb_device_id pinnacle_list[] = {
+	{ USB_DEVICE(VENDOR_PINNACLE, 0x0225) },
+	{}
+};
+
+static struct usb_device_id microsoft_gen1_list[] = {
+	{ USB_DEVICE(VENDOR_MICROSOFT, 0x006d) },
+	{}
+};
+
+/* data structure for each usb transceiver */
+struct mceusb_dev {
+	/* ir-core bits */
+	struct ir_input_dev *irdev;
+	struct ir_dev_props *props;
+	struct ir_input_state *state;
+	struct ir_raw_event rawir;
+
+	/* core device bits */
+	struct device *dev;
+	struct input_dev *idev;
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
+	u8 cmd;		/* MCE command type */
+	u8 rem;		/* Remaining IR data bytes in packet */
+	dma_addr_t dma_in;
+	dma_addr_t dma_out;
+
+	struct {
+		u32 connected:1;
+		u32 def_xmit_mask_set:1;
+		u32 microsoft_gen1:1;
+		u32 gen3:1;
+		u32 reserved:28;
+	} flags;
+
+	/* handle sending (init strings) */
+	int send_flags;
+	int carrier;
+
+	char name[128];
+	char phys[64];
+
+	unsigned char def_xmit_mask;
+	unsigned char cur_xmit_mask;
+};
+
+/*
+ * MCE Device Command Strings
+ * Device command responses vary from device to device...
+ * - DEVICE_RESET resets the hardware to its default state
+ * - GET_REVISION fetches the hardware/software revision, common
+ *   replies are ff 0b 45 ff 1b 08 and ff 0b 50 ff 1b 42
+ * - GET_CARRIER_FREQ gets the carrier mode and frequency of the
+ *   device, with replies in the form of 9f 06 MM FF, where MM is 0-3,
+ *   meaning clk of 10000000, 2500000, 625000 or 156250, and FF is
+ *   ((clk / frequency) - 1)
+ * - GET_RX_TIMEOUT fetches the receiver timeout in units of 50us,
+ *   response in the form of 9f 0c msb lsb
+ * - GET_TX_BITMASK fetches the transmitter bitmask, replies in
+ *   the form of 9f 08 bm, where bm is the bitmask
+ * - GET_RX_SENSOR fetches the RX sensor setting -- long-range
+ *   general use one or short-range learning one, in the form of
+ *   9f 14 ss, where ss is either 01 for long-range or 02 for short
+ * - SET_CARRIER_FREQ sets a new carrier mode and frequency
+ * - SET_TX_BITMASK sets the transmitter bitmask
+ * - SET_RX_TIMEOUT sets the receiver timeout
+ * - SET_RX_SENSOR sets which receiver sensor to use
+ */
+static char DEVICE_RESET[]	= {0x00, 0xff, 0xaa};
+static char GET_REVISION[]	= {0xff, 0x0b};
+static char GET_UNKNOWN[]	= {0xff, 0x18};
+static char GET_CARRIER_FREQ[]	= {0x9f, 0x07};
+static char GET_RX_TIMEOUT[]	= {0x9f, 0x0d};
+static char GET_TX_BITMASK[]	= {0x9f, 0x13};
+static char GET_RX_SENSOR[]	= {0x9f, 0x15};
+/* sub in desired values in lower byte or bytes for full command */
+/* FIXME: make use of these for transmit.
+static char SET_CARRIER_FREQ[]	= {0x9f, 0x06, 0x00, 0x00};
+static char SET_TX_BITMASK[]	= {0x9f, 0x08, 0x00};
+static char SET_RX_TIMEOUT[]	= {0x9f, 0x0c, 0x00, 0x00};
+static char SET_RX_SENSOR[]	= {0x9f, 0x14, 0x00};
+*/
+
+static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
+				 int len, bool out)
+{
+	char codes[USB_BUFLEN * 3 + 1];
+	char inout[9];
+	int i;
+	u8 cmd, subcmd, data1, data2;
+	struct device *dev = ir->dev;
+
+	if (len <= 0)
+		return;
+
+	if (ir->flags.microsoft_gen1 && len <= 2)
+		return;
+
+	for (i = 0; i < len && i < USB_BUFLEN; i++)
+		snprintf(codes + i * 3, 4, "%02x ", buf[i] & 0xFF);
+
+	dev_info(dev, "%sx data: %s (length=%d)\n",
+		 (out ? "t" : "r"), codes, len);
+
+	if (out)
+		strcpy(inout, "Request\0");
+	else
+		strcpy(inout, "Got\0");
+
+	cmd    = buf[0] & 0xff;
+	subcmd = buf[1] & 0xff;
+	data1  = buf[2] & 0xff;
+	data2  = buf[3] & 0xff;
+
+	switch (cmd) {
+	case 0x00:
+		if (subcmd == 0xff && data1 == 0xaa)
+			dev_info(dev, "Device reset requested\n");
+		else
+			dev_info(dev, "Unknown command 0x%02x 0x%02x\n",
+				 cmd, subcmd);
+		break;
+	case 0xff:
+		switch (subcmd) {
+		case 0x0b:
+			if (len == 2)
+				dev_info(dev, "Get hw/sw rev?\n");
+			else
+				dev_info(dev, "hw/sw rev 0x%02x 0x%02x "
+					 "0x%02x 0x%02x\n", data1, data2,
+					 buf[4], buf[5]);
+			break;
+		case 0xaa:
+			dev_info(dev, "Device reset requested\n");
+			break;
+		case 0xfe:
+			dev_info(dev, "Previous command not supported\n");
+			break;
+		case 0x18:
+		case 0x1b:
+		default:
+			dev_info(dev, "Unknown command 0x%02x 0x%02x\n",
+				 cmd, subcmd);
+			break;
+		}
+		break;
+	case 0x9f:
+		switch (subcmd) {
+		case 0x03:
+			dev_info(dev, "Ping\n");
+			break;
+		case 0x04:
+			dev_info(dev, "Resp to 9f 05 of 0x%02x 0x%02x\n",
+				 data1, data2);
+			break;
+		case 0x06:
+			dev_info(dev, "%s carrier mode and freq of "
+				 "0x%02x 0x%02x\n", inout, data1, data2);
+			break;
+		case 0x07:
+			dev_info(dev, "Get carrier mode and freq\n");
+			break;
+		case 0x08:
+			dev_info(dev, "%s transmit blaster mask of 0x%02x\n",
+				 inout, data1);
+			break;
+		case 0x0c:
+			/* value is in units of 50us, so x*50/100 or x/2 ms */
+			dev_info(dev, "%s receive timeout of %d ms\n",
+				 inout, ((data1 << 8) | data2) / 2);
+			break;
+		case 0x0d:
+			dev_info(dev, "Get receive timeout\n");
+			break;
+		case 0x13:
+			dev_info(dev, "Get transmit blaster mask\n");
+			break;
+		case 0x14:
+			dev_info(dev, "%s %s-range receive sensor in use\n",
+				 inout, data1 == 0x02 ? "short" : "long");
+			break;
+		case 0x15:
+			if (len == 2)
+				dev_info(dev, "Get receive sensor\n");
+			else
+				dev_info(dev, "Received pulse count is %d\n",
+					 ((data1 << 8) | data2));
+			break;
+		case 0xfe:
+			dev_info(dev, "Error! Hardware is likely wedged...\n");
+			break;
+		case 0x05:
+		case 0x09:
+		case 0x0f:
+		default:
+			dev_info(dev, "Unknown command 0x%02x 0x%02x\n",
+				 cmd, subcmd);
+			break;
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+static void usb_async_callback(struct urb *urb, struct pt_regs *regs)
+{
+	struct mceusb_dev *ir;
+	int len;
+
+	if (!urb)
+		return;
+
+	ir = urb->context;
+	if (ir) {
+		len = urb->actual_length;
+
+		dev_dbg(ir->dev, "callback called (status=%d len=%d)\n",
+			urb->status, len);
+
+		if (debug)
+			mceusb_dev_printdata(ir, urb->transfer_buffer,
+					     len, true);
+	}
+
+}
+
+/* request incoming or send outgoing usb packet - used to initialize remote */
+static void mce_request_packet(struct mceusb_dev *ir,
+			       struct usb_endpoint_descriptor *ep,
+			       unsigned char *data, int size, int urb_type)
+{
+	int res;
+	struct urb *async_urb;
+	struct device *dev = ir->dev;
+	unsigned char *async_buf;
+
+	if (urb_type == MCEUSB_TX) {
+		async_urb = usb_alloc_urb(0, GFP_KERNEL);
+		if (unlikely(!async_urb)) {
+			dev_err(dev, "Error, couldn't allocate urb!\n");
+			return;
+		}
+
+		async_buf = kzalloc(size, GFP_KERNEL);
+		if (!async_buf) {
+			dev_err(dev, "Error, couldn't allocate buf!\n");
+			usb_free_urb(async_urb);
+			return;
+		}
+
+		/* outbound data */
+		usb_fill_int_urb(async_urb, ir->usbdev,
+			usb_sndintpipe(ir->usbdev, ep->bEndpointAddress),
+			async_buf, size, (usb_complete_t) usb_async_callback,
+			ir, ep->bInterval);
+		memcpy(async_buf, data, size);
+
+	} else if (urb_type == MCEUSB_RX) {
+		/* standard request */
+		async_urb = ir->urb_in;
+		ir->send_flags = RECV_FLAG_IN_PROGRESS;
+
+	} else {
+		dev_err(dev, "Error! Unknown urb type %d\n", urb_type);
+		return;
+	}
+
+	dev_dbg(dev, "receive request called (size=%#x)\n", size);
+
+	async_urb->transfer_buffer_length = size;
+	async_urb->dev = ir->usbdev;
+
+	res = usb_submit_urb(async_urb, GFP_ATOMIC);
+	if (res) {
+		dev_dbg(dev, "receive request FAILED! (res=%d)\n", res);
+		return;
+	}
+	dev_dbg(dev, "receive request complete (res=%d)\n", res);
+}
+
+static void mce_async_out(struct mceusb_dev *ir, unsigned char *data, int size)
+{
+	mce_request_packet(ir, ir->usb_ep_out, data, size, MCEUSB_TX);
+}
+
+static void mce_sync_in(struct mceusb_dev *ir, unsigned char *data, int size)
+{
+	mce_request_packet(ir, ir->usb_ep_in, data, size, MCEUSB_RX);
+}
+
+static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
+{
+	struct ir_raw_event rawir = { .pulse = false, .duration = 0 };
+	int i, start_index = 0;
+
+	/* skip meaningless 0xb1 0x60 header bytes on orig receiver */
+	if (ir->flags.microsoft_gen1)
+		start_index = 2;
+
+	for (i = start_index; i < buf_len;) {
+		if (ir->rem == 0) {
+			/* decode mce packets of the form (84),AA,BB,CC,DD */
+			/* IR data packets can span USB messages - rem */
+			ir->rem = (ir->buf_in[i] & MCE_PACKET_LENGTH_MASK);
+			ir->cmd = (ir->buf_in[i] & ~MCE_PACKET_LENGTH_MASK);
+			dev_dbg(ir->dev, "New data. rem: 0x%02x, cmd: 0x%02x\n",
+				ir->rem, ir->cmd);
+			i++;
+		}
+
+		/* Only cmd 0x8<bytes> is IR data, don't process MCE commands */
+		if (ir->cmd != 0x80) {
+			ir->rem = 0;
+			return;
+		}
+
+		for (; (ir->rem > 0) && (i < buf_len); i++) {
+			ir->rem--;
+
+			rawir.pulse = ((ir->buf_in[i] & MCE_PULSE_BIT) != 0);
+			rawir.duration = (ir->buf_in[i] & MCE_PULSE_MASK)
+					 * MCE_TIME_UNIT * 1000;
+
+			if ((ir->buf_in[i] & MCE_PULSE_MASK) == 0x7f) {
+				if (ir->rawir.pulse == rawir.pulse)
+					ir->rawir.duration += rawir.duration;
+				else {
+					ir->rawir.duration = rawir.duration;
+					ir->rawir.pulse = rawir.pulse;
+				}
+				continue;
+			}
+			rawir.duration += ir->rawir.duration;
+			ir->rawir.duration = 0;
+			ir->rawir.pulse = rawir.pulse;
+
+			dev_dbg(ir->dev, "Storing %s with duration %d\n",
+				rawir.pulse ? "pulse" : "space",
+				rawir.duration);
+
+			ir_raw_event_store(ir->idev, &rawir);
+		}
+
+		if (ir->buf_in[i] == 0x80 || ir->buf_in[i] == 0x9f)
+			ir->rem = 0;
+
+		dev_dbg(ir->dev, "calling ir_raw_event_handle\n");
+		ir_raw_event_handle(ir->idev);
+	}
+}
+
+static void mceusb_set_default_xmit_mask(struct urb *urb)
+{
+	struct mceusb_dev *ir = urb->context;
+	char *buffer = urb->transfer_buffer;
+	u8 cmd, subcmd, def_xmit_mask;
+
+	cmd    = buffer[0] & 0xff;
+	subcmd = buffer[1] & 0xff;
+
+	if (cmd == 0x9f && subcmd == 0x08) {
+		def_xmit_mask = buffer[2] & 0xff;
+		dev_dbg(ir->dev, "%s: setting xmit mask to 0x%02x\n",
+			__func__, def_xmit_mask);
+		ir->def_xmit_mask = def_xmit_mask;
+		ir->flags.def_xmit_mask_set = 1;
+	}
+}
+
+static void mceusb_dev_recv(struct urb *urb, struct pt_regs *regs)
+{
+	struct mceusb_dev *ir;
+	int buf_len;
+
+	if (!urb)
+		return;
+
+	ir = urb->context;
+	if (!ir) {
+		usb_unlink_urb(urb);
+		return;
+	}
+
+	buf_len = urb->actual_length;
+
+	if (!ir->flags.def_xmit_mask_set)
+		mceusb_set_default_xmit_mask(urb);
+
+	if (debug)
+		mceusb_dev_printdata(ir, urb->transfer_buffer, buf_len, false);
+
+	if (ir->send_flags == RECV_FLAG_IN_PROGRESS) {
+		ir->send_flags = SEND_FLAG_COMPLETE;
+		dev_dbg(&ir->irdev->dev, "setup answer received %d bytes\n",
+			buf_len);
+	}
+
+	switch (urb->status) {
+	/* success */
+	case 0:
+		mceusb_process_ir_data(ir, buf_len);
+		break;
+
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
+	usb_submit_urb(urb, GFP_ATOMIC);
+}
+
+static void mceusb_gen1_init(struct mceusb_dev *ir)
+{
+	int i, ret;
+	char junk[64], data[8];
+	int partial = 0;
+	struct device *dev = ir->dev;
+
+	/*
+	 * Clear off the first few messages. These look like calibration
+	 * or test data, I can't really tell. This also flushes in case
+	 * we have random ir data queued up.
+	 */
+	for (i = 0; i < 40; i++)
+		usb_bulk_msg(ir->usbdev,
+			usb_rcvbulkpipe(ir->usbdev,
+				ir->usb_ep_in->bEndpointAddress),
+			junk, 64, &partial, HZ * 10);
+
+	memset(data, 0, 8);
+
+	/* Get Status */
+	ret = usb_control_msg(ir->usbdev, usb_rcvctrlpipe(ir->usbdev, 0),
+			      USB_REQ_GET_STATUS, USB_DIR_IN,
+			      0, 0, data, 2, HZ * 3);
+
+	/*    ret = usb_get_status( ir->usbdev, 0, 0, data ); */
+	dev_dbg(dev, "%s - ret = %d status = 0x%x 0x%x\n", __func__,
+		ret, data[0], data[1]);
+
+	/*
+	 * This is a strange one. They issue a set address to the device
+	 * on the receive control pipe and expect a certain value pair back
+	 */
+	memset(data, 0, 8);
+
+	ret = usb_control_msg(ir->usbdev, usb_rcvctrlpipe(ir->usbdev, 0),
+			      USB_REQ_SET_ADDRESS, USB_TYPE_VENDOR, 0, 0,
+			      data, 2, HZ * 3);
+	dev_dbg(dev, "%s - ret = %d\n", __func__, ret);
+	dev_dbg(dev, "%s - data[0] = %d, data[1] = %d\n",
+		__func__, data[0], data[1]);
+
+	/* set feature: bit rate 38400 bps */
+	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
+			      USB_REQ_SET_FEATURE, USB_TYPE_VENDOR,
+			      0xc04e, 0x0000, NULL, 0, HZ * 3);
+
+	dev_dbg(dev, "%s - ret = %d\n", __func__, ret);
+
+	/* bRequest 4: set char length to 8 bits */
+	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
+			      4, USB_TYPE_VENDOR,
+			      0x0808, 0x0000, NULL, 0, HZ * 3);
+	dev_dbg(dev, "%s - retB = %d\n", __func__, ret);
+
+	/* bRequest 2: set handshaking to use DTR/DSR */
+	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
+			      2, USB_TYPE_VENDOR,
+			      0x0000, 0x0100, NULL, 0, HZ * 3);
+	dev_dbg(dev, "%s - retC = %d\n", __func__, ret);
+};
+
+static void mceusb_gen2_init(struct mceusb_dev *ir)
+{
+	int maxp = ir->len_in;
+
+	mce_sync_in(ir, NULL, maxp);
+	mce_sync_in(ir, NULL, maxp);
+
+	/* device reset */
+	mce_async_out(ir, DEVICE_RESET, sizeof(DEVICE_RESET));
+	mce_sync_in(ir, NULL, maxp);
+
+	/* get hw/sw revision? */
+	mce_async_out(ir, GET_REVISION, sizeof(GET_REVISION));
+	mce_sync_in(ir, NULL, maxp);
+
+	/* unknown what this actually returns... */
+	mce_async_out(ir, GET_UNKNOWN, sizeof(GET_UNKNOWN));
+	mce_sync_in(ir, NULL, maxp);
+}
+
+static void mceusb_gen3_init(struct mceusb_dev *ir)
+{
+	int maxp = ir->len_in;
+
+	mce_sync_in(ir, NULL, maxp);
+
+	/* device reset */
+	mce_async_out(ir, DEVICE_RESET, sizeof(DEVICE_RESET));
+	mce_sync_in(ir, NULL, maxp);
+
+	/* get the carrier and frequency */
+	mce_async_out(ir, GET_CARRIER_FREQ, sizeof(GET_CARRIER_FREQ));
+	mce_sync_in(ir, NULL, maxp);
+
+	/* get the transmitter bitmask */
+	mce_async_out(ir, GET_TX_BITMASK, sizeof(GET_TX_BITMASK));
+	mce_sync_in(ir, NULL, maxp);
+
+	/* get receiver timeout value */
+	mce_async_out(ir, GET_RX_TIMEOUT, sizeof(GET_RX_TIMEOUT));
+	mce_sync_in(ir, NULL, maxp);
+
+	/* get receiver sensor setting */
+	mce_async_out(ir, GET_RX_SENSOR, sizeof(GET_RX_SENSOR));
+	mce_sync_in(ir, NULL, maxp);
+}
+
+static struct input_dev *mceusb_init_input_dev(struct mceusb_dev *ir)
+{
+	struct input_dev *idev;
+	struct ir_dev_props *props;
+	struct ir_input_dev *irdev;
+	struct ir_input_state *state;
+	struct device *dev = ir->dev;
+	int ret = -ENODEV;
+
+	idev = input_allocate_device();
+	if (!idev) {
+		dev_err(dev, "remote input dev allocation failed\n");
+		goto idev_alloc_failed;
+	}
+
+	ret = -ENOMEM;
+	props = kzalloc(sizeof(struct ir_dev_props), GFP_KERNEL);
+	if (!props) {
+		dev_err(dev, "remote ir dev props allocation failed\n");
+		goto props_alloc_failed;
+	}
+
+	irdev = kzalloc(sizeof(struct ir_input_dev), GFP_KERNEL);
+	if (!irdev) {
+		dev_err(dev, "remote ir input dev allocation failed\n");
+		goto ir_dev_alloc_failed;
+	}
+
+	state = kzalloc(sizeof(struct ir_input_state), GFP_KERNEL);
+	if (!state) {
+		dev_err(dev, "remote ir state allocation failed\n");
+		goto ir_state_alloc_failed;
+	}
+
+	snprintf(ir->name, sizeof(ir->name), "Media Center Edition eHome "
+		 "Infrared Remote Transceiver (%04x:%04x)",
+		 le16_to_cpu(ir->usbdev->descriptor.idVendor),
+		 le16_to_cpu(ir->usbdev->descriptor.idProduct));
+
+	ret = ir_input_init(idev, state, IR_TYPE_RC6);
+	if (ret < 0)
+		goto irdev_failed;
+
+	idev->name = ir->name;
+
+	usb_make_path(ir->usbdev, ir->phys, sizeof(ir->phys));
+	strlcat(ir->phys, "/input0", sizeof(ir->phys));
+	idev->phys = ir->phys;
+
+	/* FIXME: no EV_REP (yet), we may need our own auto-repeat handling */
+	idev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
+
+	idev->keybit[BIT_WORD(BTN_MOUSE)] =
+		BIT_MASK(BTN_LEFT) | BIT_MASK(BTN_RIGHT);
+	idev->relbit[0] = BIT_MASK(REL_X) | BIT_MASK(REL_Y) |
+		BIT_MASK(REL_WHEEL);
+
+	props->priv = ir;
+	props->driver_type = RC_DRIVER_IR_RAW;
+	props->allowed_protos = IR_TYPE_ALL;
+
+	ir->props = props;
+	ir->irdev = irdev;
+	ir->state = state;
+
+	input_set_drvdata(idev, irdev);
+
+	ret = ir_input_register(idev, RC_MAP_RC6_MCE, props, DRIVER_NAME);
+	if (ret < 0) {
+		dev_err(dev, "remote input device register failed\n");
+		goto irdev_failed;
+	}
+
+	return idev;
+
+irdev_failed:
+	kfree(state);
+ir_state_alloc_failed:
+	kfree(irdev);
+ir_dev_alloc_failed:
+	kfree(props);
+props_alloc_failed:
+	input_free_device(idev);
+idev_alloc_failed:
+	return NULL;
+}
+
+static int __devinit mceusb_dev_probe(struct usb_interface *intf,
+				      const struct usb_device_id *id)
+{
+	struct usb_device *dev = interface_to_usbdev(intf);
+	struct usb_host_interface *idesc;
+	struct usb_endpoint_descriptor *ep = NULL;
+	struct usb_endpoint_descriptor *ep_in = NULL;
+	struct usb_endpoint_descriptor *ep_out = NULL;
+	struct usb_host_config *config;
+	struct mceusb_dev *ir = NULL;
+	int pipe, maxp;
+	int i, ret;
+	char buf[63], name[128] = "";
+	bool is_gen3;
+	bool is_microsoft_gen1;
+	bool is_pinnacle;
+
+	dev_dbg(&intf->dev, ": %s called\n", __func__);
+
+	usb_reset_device(dev);
+
+	config = dev->actconfig;
+	idesc  = intf->cur_altsetting;
+
+	is_gen3 = usb_match_id(intf, gen3_list) ? 1 : 0;
+	is_microsoft_gen1 = usb_match_id(intf, microsoft_gen1_list) ? 1 : 0;
+	is_pinnacle = usb_match_id(intf, pinnacle_list) ? 1 : 0;
+
+	/* step through the endpoints to find first bulk in and out endpoint */
+	for (i = 0; i < idesc->desc.bNumEndpoints; ++i) {
+		ep = &idesc->endpoint[i].desc;
+
+		if ((ep_in == NULL)
+			&& ((ep->bEndpointAddress & USB_ENDPOINT_DIR_MASK)
+			    == USB_DIR_IN)
+			&& (((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
+			    == USB_ENDPOINT_XFER_BULK)
+			|| ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
+			    == USB_ENDPOINT_XFER_INT))) {
+
+			dev_dbg(&intf->dev, ": acceptable inbound endpoint "
+				"found\n");
+			ep_in = ep;
+			ep_in->bmAttributes = USB_ENDPOINT_XFER_INT;
+			if (!is_pinnacle)
+				/*
+				 * Ideally, we'd use what the device offers up,
+				 * but that leads to non-functioning first and
+				 * second-gen devices, and many devices have an
+				 * invalid bInterval of 0. Pinnacle devices
+				 * don't work witha  bInterval of 1 though.
+				 */
+				ep_in->bInterval = 1;
+		}
+
+		if ((ep_out == NULL)
+			&& ((ep->bEndpointAddress & USB_ENDPOINT_DIR_MASK)
+			    == USB_DIR_OUT)
+			&& (((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
+			    == USB_ENDPOINT_XFER_BULK)
+			|| ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
+			    == USB_ENDPOINT_XFER_INT))) {
+
+			dev_dbg(&intf->dev, ": acceptable outbound endpoint "
+				"found\n");
+			ep_out = ep;
+			ep_out->bmAttributes = USB_ENDPOINT_XFER_INT;
+			if (!is_pinnacle)
+				/*
+				 * Ideally, we'd use what the device offers up,
+				 * but that leads to non-functioning first and
+				 * second-gen devices, and many devices have an
+				 * invalid bInterval of 0. Pinnacle devices
+				 * don't work witha  bInterval of 1 though.
+				 */
+				ep_out->bInterval = 1;
+		}
+	}
+	if (ep_in == NULL) {
+		dev_dbg(&intf->dev, ": inbound and/or endpoint not found\n");
+		return -ENODEV;
+	}
+
+	pipe = usb_rcvintpipe(dev, ep_in->bEndpointAddress);
+	maxp = usb_maxpacket(dev, pipe, usb_pipeout(pipe));
+
+	ir = kzalloc(sizeof(struct mceusb_dev), GFP_KERNEL);
+	if (!ir)
+		goto mem_alloc_fail;
+
+	ir->buf_in = usb_alloc_coherent(dev, maxp, GFP_ATOMIC, &ir->dma_in);
+	if (!ir->buf_in)
+		goto buf_in_alloc_fail;
+
+	ir->urb_in = usb_alloc_urb(0, GFP_KERNEL);
+	if (!ir->urb_in)
+		goto urb_in_alloc_fail;
+
+	ir->usbdev = dev;
+	ir->dev = &intf->dev;
+	ir->len_in = maxp;
+	ir->flags.gen3 = is_gen3;
+	ir->flags.microsoft_gen1 = is_microsoft_gen1;
+
+	/* Saving usb interface data for use by the transmitter routine */
+	ir->usb_ep_in = ep_in;
+	ir->usb_ep_out = ep_out;
+
+	if (dev->descriptor.iManufacturer
+	    && usb_string(dev, dev->descriptor.iManufacturer,
+			  buf, sizeof(buf)) > 0)
+		strlcpy(name, buf, sizeof(name));
+	if (dev->descriptor.iProduct
+	    && usb_string(dev, dev->descriptor.iProduct,
+			  buf, sizeof(buf)) > 0)
+		snprintf(name + strlen(name), sizeof(name) - strlen(name),
+			 " %s", buf);
+
+	ir->idev = mceusb_init_input_dev(ir);
+	if (!ir->idev)
+		goto input_dev_fail;
+
+	/* inbound data */
+	usb_fill_int_urb(ir->urb_in, dev, pipe, ir->buf_in,
+		maxp, (usb_complete_t) mceusb_dev_recv, ir, ep_in->bInterval);
+	ir->urb_in->transfer_dma = ir->dma_in;
+	ir->urb_in->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+
+	if (is_pinnacle) {
+		/*
+		 * I have no idea why but this reset seems to be crucial to
+		 * getting the device to do outbound IO correctly - without
+		 * this the device seems to hang, ignoring all input - although
+		 * IR signals are correctly sent from the device, no input is
+		 * interpreted by the device and the host never does the
+		 * completion routine
+		 */
+		ret = usb_reset_configuration(dev);
+		dev_info(&intf->dev, "usb reset config ret %x\n", ret);
+	}
+
+	/* initialize device */
+	if (ir->flags.gen3)
+		mceusb_gen3_init(ir);
+
+	else if (ir->flags.microsoft_gen1)
+		mceusb_gen1_init(ir);
+
+	else
+		mceusb_gen2_init(ir);
+
+	mce_sync_in(ir, NULL, maxp);
+
+	/* We've already done this on gen3 devices */
+	if (!ir->flags.def_xmit_mask_set) {
+		mce_async_out(ir, GET_TX_BITMASK, sizeof(GET_TX_BITMASK));
+		mce_sync_in(ir, NULL, maxp);
+	}
+
+	usb_set_intfdata(intf, ir);
+
+	dev_info(&intf->dev, "Registered %s on usb%d:%d\n", name,
+		 dev->bus->busnum, dev->devnum);
+
+	return 0;
+
+	/* Error-handling path */
+input_dev_fail:
+	usb_free_urb(ir->urb_in);
+urb_in_alloc_fail:
+	usb_free_coherent(dev, maxp, ir->buf_in, ir->dma_in);
+buf_in_alloc_fail:
+	kfree(ir);
+mem_alloc_fail:
+	dev_err(&intf->dev, "%s: device setup failed!\n", __func__);
+
+	return -ENOMEM;
+}
+
+
+static void __devexit mceusb_dev_disconnect(struct usb_interface *intf)
+{
+	struct usb_device *dev = interface_to_usbdev(intf);
+	struct mceusb_dev *ir = usb_get_intfdata(intf);
+
+	usb_set_intfdata(intf, NULL);
+
+	if (!ir)
+		return;
+
+	ir->usbdev = NULL;
+	input_unregister_device(ir->idev);
+	usb_kill_urb(ir->urb_in);
+	usb_free_urb(ir->urb_in);
+	usb_free_coherent(dev, ir->len_in, ir->buf_in, ir->dma_in);
+
+	kfree(ir);
+}
+
+static int mceusb_dev_suspend(struct usb_interface *intf, pm_message_t message)
+{
+	struct mceusb_dev *ir = usb_get_intfdata(intf);
+	dev_info(ir->dev, "suspend\n");
+	usb_kill_urb(ir->urb_in);
+	return 0;
+}
+
+static int mceusb_dev_resume(struct usb_interface *intf)
+{
+	struct mceusb_dev *ir = usb_get_intfdata(intf);
+	dev_info(ir->dev, "resume\n");
+	if (usb_submit_urb(ir->urb_in, GFP_ATOMIC))
+		return -EIO;
+	return 0;
+}
+
+static struct usb_driver mceusb_dev_driver = {
+	.name =		DRIVER_NAME,
+	.probe =	mceusb_dev_probe,
+	.disconnect =	mceusb_dev_disconnect,
+	.suspend =	mceusb_dev_suspend,
+	.resume =	mceusb_dev_resume,
+	.reset_resume =	mceusb_dev_resume,
+	.id_table =	mceusb_dev_table
+};
+
+static int __init mceusb_dev_init(void)
+{
+	int ret;
+
+	ret = usb_register(&mceusb_dev_driver);
+	if (ret < 0)
+		printk(KERN_ERR DRIVER_NAME
+		       ": usb register failed, result = %d\n", ret);
+
+	return ret;
+}
+
+static void __exit mceusb_dev_exit(void)
+{
+	usb_deregister(&mceusb_dev_driver);
+}
+
+module_init(mceusb_dev_init);
+module_exit(mceusb_dev_exit);
+
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(usb, mceusb_dev_table);
+
+module_param(debug, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(debug, "Debug enabled or not");
-- 
1.6.5.2


-- 
Jarod Wilson
jarod@redhat.com

