Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59154 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757042AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Olli Salonen <olli.salonen@iki.fi>, Sean Young <sean@mess.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Max Kellermann <max@duempel.org>,
        Kamil Debski <kamil@wypas.org>, Ole Ernst <olebowle@gmx.com>,
        Colin Ian King <colin.king@canonical.com>,
        Tina Ruchandani <ruchandani.tina@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 56/57] [media] rc: don't break long lines
Date: Fri, 14 Oct 2016 17:20:44 -0300
Message-Id: <bb897f8abfe048164f9e58f6489b7881f3591dff.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/rc/ati_remote.c  |  3 +--
 drivers/media/rc/ene_ir.c      |  3 +--
 drivers/media/rc/imon.c        | 43 ++++++++++++++----------------------------
 drivers/media/rc/ite-cir.c     |  9 +++------
 drivers/media/rc/mceusb.c      |  4 +---
 drivers/media/rc/rc-main.c     |  3 +--
 drivers/media/rc/redrat3.c     | 18 ++++++------------
 drivers/media/rc/streamzap.c   |  9 +++------
 drivers/media/rc/winbond-cir.c |  9 +++------
 9 files changed, 33 insertions(+), 68 deletions(-)

diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index 9f5b59706741..0884b7dc0e71 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -527,8 +527,7 @@ static void ati_remote_input_report(struct urb *urb)
 	remote_num = (data[3] >> 4) & 0x0f;
 	if (channel_mask & (1 << (remote_num + 1))) {
 		dbginfo(&ati_remote->interface->dev,
-			"Masked input from channel 0x%02x: data %02x, "
-			"mask= 0x%02lx\n",
+			"Masked input from channel 0x%02x: data %02x, mask= 0x%02lx\n",
 			remote_num, data[2], channel_mask);
 		return;
 	}
diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index d1c61cd035f6..bd5512e64aea 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1210,8 +1210,7 @@ MODULE_PARM_DESC(txsim,
 
 MODULE_DEVICE_TABLE(pnp, ene_ids);
 MODULE_DESCRIPTION
-	("Infrared input driver for KB3926B/C/D/E/F "
-	"(aka ENE0100/ENE0200/ENE0201/ENE0202) CIR port");
+	("Infrared input driver for KB3926B/C/D/E/F (aka ENE0100/ENE0200/ENE0201/ENE0202) CIR port");
 
 MODULE_AUTHOR("Maxim Levitsky");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index d62b1f38292c..bff834f5e018 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -441,13 +441,11 @@ MODULE_PARM_DESC(debug, "Debug messages: 0=no, 1=yes (default: no)");
 /* lcd, vfd, vga or none? should be auto-detected, but can be overridden... */
 static int display_type;
 module_param(display_type, int, S_IRUGO);
-MODULE_PARM_DESC(display_type, "Type of attached display. 0=autodetect, "
-		 "1=vfd, 2=lcd, 3=vga, 4=none (default: autodetect)");
+MODULE_PARM_DESC(display_type, "Type of attached display. 0=autodetect, 1=vfd, 2=lcd, 3=vga, 4=none (default: autodetect)");
 
 static int pad_stabilize = 1;
 module_param(pad_stabilize, int, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(pad_stabilize, "Apply stabilization algorithm to iMON PAD "
-		 "presses in arrow key mode. 0=disable, 1=enable (default).");
+MODULE_PARM_DESC(pad_stabilize, "Apply stabilization algorithm to iMON PAD presses in arrow key mode. 0=disable, 1=enable (default).");
 
 /*
  * In certain use cases, mouse mode isn't really helpful, and could actually
@@ -455,14 +453,12 @@ MODULE_PARM_DESC(pad_stabilize, "Apply stabilization algorithm to iMON PAD "
  */
 static bool nomouse;
 module_param(nomouse, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(nomouse, "Disable mouse input device mode when IR device is "
-		 "open. 0=don't disable, 1=disable. (default: don't disable)");
+MODULE_PARM_DESC(nomouse, "Disable mouse input device mode when IR device is open. 0=don't disable, 1=disable. (default: don't disable)");
 
 /* threshold at which a pad push registers as an arrow key in kbd mode */
 static int pad_thresh;
 module_param(pad_thresh, int, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(pad_thresh, "Threshold at which a pad push registers as an "
-		 "arrow key in kbd mode (default: 28)");
+MODULE_PARM_DESC(pad_thresh, "Threshold at which a pad push registers as an arrow key in kbd mode (default: 28)");
 
 
 static void free_imon_context(struct imon_context *ictx)
@@ -785,9 +781,7 @@ static ssize_t show_associate_remote(struct device *d,
 	else
 		strcpy(buf, "closed\n");
 
-	dev_info(d, "Visit http://www.lirc.org/html/imon-24g.html for "
-		 "instructions on how to associate your iMON 2.4G DT/LT "
-		 "remote\n");
+	dev_info(d, "Visit http://www.lirc.org/html/imon-24g.html for instructions on how to associate your iMON 2.4G DT/LT remote\n");
 	mutex_unlock(&ictx->lock);
 	return strlen(buf);
 }
@@ -1115,8 +1109,7 @@ static int imon_ir_change_protocol(struct rc_dev *rc, u64 *rc_type)
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x86 };
 
 	if (*rc_type && !(*rc_type & rc->allowed_protocols))
-		dev_warn(dev, "Looks like you're trying to use an IR protocol "
-			 "this device does not support\n");
+		dev_warn(dev, "Looks like you're trying to use an IR protocol this device does not support\n");
 
 	if (*rc_type & RC_BIT_RC6_MCE) {
 		dev_dbg(dev, "Configuring IR receiver for MCE protocol\n");
@@ -1129,8 +1122,7 @@ static int imon_ir_change_protocol(struct rc_dev *rc, u64 *rc_type)
 		/* ir_proto_packet[0] = 0x00; // already the default */
 		*rc_type = RC_BIT_OTHER;
 	} else {
-		dev_warn(dev, "Unsupported IR protocol specified, overriding "
-			 "to iMON IR protocol\n");
+		dev_warn(dev, "Unsupported IR protocol specified, overriding to iMON IR protocol\n");
 		if (!pad_stabilize)
 			dev_dbg(dev, "PAD stabilize functionality disabled\n");
 		/* ir_proto_packet[0] = 0x00; // already the default */
@@ -1719,8 +1711,7 @@ static void imon_incoming_packet(struct imon_context *ictx,
 
 not_input_data:
 	if (len != 8) {
-		dev_warn(dev, "imon %s: invalid incoming packet "
-			 "size (len = %d, intf%d)\n", __func__, len, intf);
+		dev_warn(dev, "imon %s: invalid incoming packet size (len = %d, intf%d)\n", __func__, len, intf);
 		return;
 	}
 
@@ -1876,8 +1867,7 @@ static void imon_get_ffdc_type(struct imon_context *ictx)
 		allowed_protos = RC_BIT_RC6_MCE;
 		break;
 	default:
-		dev_info(ictx->dev, "Unknown 0xffdc device, "
-			 "defaulting to VFD and iMON IR");
+		dev_info(ictx->dev, "Unknown 0xffdc device, defaulting to VFD and iMON IR");
 		detected_display_type = IMON_DISPLAY_TYPE_VFD;
 		/* We don't know which one it is, allow user to set the
 		 * RC6 one from userspace if OTHER wasn't correct. */
@@ -1934,8 +1924,7 @@ static void imon_set_display_type(struct imon_context *ictx)
 			ictx->display_supported = false;
 		else
 			ictx->display_supported = true;
-		dev_info(ictx->dev, "%s: overriding display type to %d via "
-			 "modparam\n", __func__, display_type);
+		dev_info(ictx->dev, "%s: overriding display type to %d via modparam\n", __func__, display_type);
 	}
 
 	ictx->display_type = configured_display_type;
@@ -2156,8 +2145,7 @@ static bool imon_find_endpoints(struct imon_context *ictx,
 	if (!display_ep_found) {
 		tx_control = true;
 		display_ep_found = true;
-		dev_dbg(ictx->dev, "%s: device uses control endpoint, not "
-			"interface OUT endpoint\n", __func__);
+		dev_dbg(ictx->dev, "%s: device uses control endpoint, not interface OUT endpoint\n", __func__);
 	}
 
 	/*
@@ -2366,8 +2354,7 @@ static void imon_init_display(struct imon_context *ictx,
 	/* set up sysfs entry for built-in clock */
 	ret = sysfs_create_group(&intf->dev.kobj, &imon_display_attr_group);
 	if (ret)
-		dev_err(ictx->dev, "Could not create display sysfs "
-			"entries(%d)", ret);
+		dev_err(ictx->dev, "Could not create display sysfs entries(%d)", ret);
 
 	if (ictx->display_type == IMON_DISPLAY_TYPE_LCD)
 		ret = usb_register_dev(intf, &imon_lcd_class);
@@ -2375,8 +2362,7 @@ static void imon_init_display(struct imon_context *ictx,
 		ret = usb_register_dev(intf, &imon_vfd_class);
 	if (ret)
 		/* Not a fatal error, so ignore */
-		dev_info(ictx->dev, "could not get a minor number for "
-			 "display\n");
+		dev_info(ictx->dev, "could not get a minor number for display\n");
 
 }
 
@@ -2456,8 +2442,7 @@ static int imon_probe(struct usb_interface *interface,
 		mutex_unlock(&ictx->lock);
 	}
 
-	dev_info(dev, "iMON device (%04x:%04x, intf%d) on "
-		 "usb<%d:%d> initialized\n", vendor, product, ifnum,
+	dev_info(dev, "iMON device (%04x:%04x, intf%d) on usb<%d:%d> initialized\n", vendor, product, ifnum,
 		 usbdev->bus->busnum, usbdev->devnum);
 
 	mutex_unlock(&driver_lock);
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 0f301903aa6f..c5e8e3885766 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -55,14 +55,12 @@ MODULE_PARM_DESC(debug, "Enable debugging output");
 /* low limit for RX carrier freq, Hz, 0 for no RX demodulation */
 static int rx_low_carrier_freq;
 module_param(rx_low_carrier_freq, int, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(rx_low_carrier_freq, "Override low RX carrier frequency, Hz, "
-		 "0 for no RX demodulation");
+MODULE_PARM_DESC(rx_low_carrier_freq, "Override low RX carrier frequency, Hz, 0 for no RX demodulation");
 
 /* high limit for RX carrier freq, Hz, 0 for no RX demodulation */
 static int rx_high_carrier_freq;
 module_param(rx_high_carrier_freq, int, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(rx_high_carrier_freq, "Override high RX carrier frequency, "
-		 "Hz, 0 for no RX demodulation");
+MODULE_PARM_DESC(rx_high_carrier_freq, "Override high RX carrier frequency, Hz, 0 for no RX demodulation");
 
 /* override tx carrier frequency */
 static int tx_carrier_freq;
@@ -1484,8 +1482,7 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 
 	if (model_number >= 0 && model_number < ARRAY_SIZE(ite_dev_descs)) {
 		model_no = model_number;
-		ite_pr(KERN_NOTICE, "The model has been fixed by a module "
-			"parameter.");
+		ite_pr(KERN_NOTICE, "The model has been fixed by a module parameter.");
 	}
 
 	ite_pr(KERN_NOTICE, "Using model: %s\n", ite_dev_descs[model_no].model);
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 4f8c7effdcee..f813b77c595d 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -604,9 +604,7 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 			break;
 		case MCE_RSP_EQWAKEVERSION:
 			if (!out)
-				dev_dbg(dev, "Wake version, proto: 0x%02x, "
-					 "payload: 0x%02x, address: 0x%02x, "
-					 "version: 0x%02x",
+				dev_dbg(dev, "Wake version, proto: 0x%02x, payload: 0x%02x, address: 0x%02x, version: 0x%02x",
 					 data1, data2, data3, data4);
 			break;
 		case MCE_RSP_GETPORTSTATUS:
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index d9c1f2ff7119..b241e5f569ef 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -660,8 +660,7 @@ static void ir_do_keydown(struct rc_dev *dev, enum rc_type protocol,
 		dev->last_toggle = toggle;
 		dev->last_keycode = keycode;
 
-		IR_dprintk(1, "%s: key down event, "
-			   "key 0x%04x, protocol 0x%04x, scancode 0x%08x\n",
+		IR_dprintk(1, "%s: key down event, key 0x%04x, protocol 0x%04x, scancode 0x%08x\n",
 			   dev->input_name, keycode, protocol, scancode);
 		input_report_key(dev->input_dev, keycode, 1);
 
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 05ba47bc0b61..3b0ed1c3f2d8 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -265,8 +265,7 @@ static void redrat3_dump_fw_error(struct redrat3_dev *rr3, int code)
 
 	/* Codes 0x20 through 0x2f are IR Firmware Errors */
 	case 0x20:
-		pr_cont("Initial signal pulse not long enough "
-			"to measure carrier frequency\n");
+		pr_cont("Initial signal pulse not long enough to measure carrier frequency\n");
 		break;
 	case 0x21:
 		pr_cont("Not enough length values allocated for signal\n");
@@ -278,18 +277,15 @@ static void redrat3_dump_fw_error(struct redrat3_dev *rr3, int code)
 		pr_cont("Too many signal repeats\n");
 		break;
 	case 0x28:
-		pr_cont("Insufficient memory available for IR signal "
-			"data memory allocation\n");
+		pr_cont("Insufficient memory available for IR signal data memory allocation\n");
 		break;
 	case 0x29:
-		pr_cont("Insufficient memory available "
-			"for IrDa signal data memory allocation\n");
+		pr_cont("Insufficient memory available for IrDa signal data memory allocation\n");
 		break;
 
 	/* Codes 0x30 through 0x3f are USB Firmware Errors */
 	case 0x30:
-		pr_cont("Insufficient memory available for bulk "
-			"transfer structure\n");
+		pr_cont("Insufficient memory available for bulk transfer structure\n");
 		break;
 
 	/*
@@ -301,8 +297,7 @@ static void redrat3_dump_fw_error(struct redrat3_dev *rr3, int code)
 			pr_cont("Signal capture has been terminated\n");
 		break;
 	case 0x41:
-		pr_cont("Attempt to set/get and unknown signal I/O "
-			"algorithm parameter\n");
+		pr_cont("Attempt to set/get and unknown signal I/O algorithm parameter\n");
 		break;
 	case 0x42:
 		pr_cont("Signal capture already started\n");
@@ -917,8 +912,7 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
 		goto out;
 	}
 
-	snprintf(rr3->name, sizeof(rr3->name), "RedRat3%s "
-		 "Infrared Remote Transceiver (%04x:%04x)",
+	snprintf(rr3->name, sizeof(rr3->name), "RedRat3%s Infrared Remote Transceiver (%04x:%04x)",
 		 prod == USB_RR3IIUSB_PRODUCT_ID ? "-II" : "",
 		 le16_to_cpu(rr3->udev->descriptor.idVendor), prod);
 
diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index 4004260a7c69..d61a620b6fd5 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -297,8 +297,7 @@ static struct rc_dev *streamzap_init_rc_dev(struct streamzap_ir *sz)
 		goto out;
 	}
 
-	snprintf(sz->name, sizeof(sz->name), "Streamzap PC Remote Infrared "
-		 "Receiver (%04x:%04x)",
+	snprintf(sz->name, sizeof(sz->name), "Streamzap PC Remote Infrared Receiver (%04x:%04x)",
 		 le16_to_cpu(sz->usbdev->descriptor.idVendor),
 		 le16_to_cpu(sz->usbdev->descriptor.idProduct));
 	usb_make_path(sz->usbdev, sz->phys, sizeof(sz->phys));
@@ -364,15 +363,13 @@ static int streamzap_probe(struct usb_interface *intf,
 
 	sz->endpoint = &(iface_host->endpoint[0].desc);
 	if (!usb_endpoint_dir_in(sz->endpoint)) {
-		dev_err(&intf->dev, "%s: endpoint doesn't match input device "
-			"02%02x\n", __func__, sz->endpoint->bEndpointAddress);
+		dev_err(&intf->dev, "%s: endpoint doesn't match input device 02%02x\n", __func__, sz->endpoint->bEndpointAddress);
 		retval = -ENODEV;
 		goto free_sz;
 	}
 
 	if (!usb_endpoint_xfer_int(sz->endpoint)) {
-		dev_err(&intf->dev, "%s: endpoint attributes don't match xfer "
-			"02%02x\n", __func__, sz->endpoint->bmAttributes);
+		dev_err(&intf->dev, "%s: endpoint attributes don't match xfer 02%02x\n", __func__, sz->endpoint->bmAttributes);
 		retval = -ENODEV;
 		goto free_sz;
 	}
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 95ae60e659a1..cdcd6e38b295 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -227,8 +227,7 @@ struct wbcir_data {
 
 static enum wbcir_protocol protocol = IR_PROTOCOL_RC6;
 module_param(protocol, uint, 0444);
-MODULE_PARM_DESC(protocol, "IR protocol to use for the power-on command "
-		 "(0 = RC5, 1 = NEC, 2 = RC6A, default)");
+MODULE_PARM_DESC(protocol, "IR protocol to use for the power-on command (0 = RC5, 1 = NEC, 2 = RC6A, default)");
 
 static bool invert; /* default = 0 */
 module_param(invert, bool, 0444);
@@ -244,8 +243,7 @@ MODULE_PARM_DESC(wake_sc, "Scancode of the power-on IR command");
 
 static unsigned int wake_rc6mode = 6;
 module_param(wake_rc6mode, uint, 0644);
-MODULE_PARM_DESC(wake_rc6mode, "RC6 mode for the power-on command "
-		 "(0 = 0, 6 = 6A, default)");
+MODULE_PARM_DESC(wake_rc6mode, "RC6 mode for the power-on command (0 = 0, 6 = 6A, default)");
 
 
 
@@ -1050,8 +1048,7 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 		goto exit_free_data;
 	}
 
-	dev_dbg(&device->dev, "Found device "
-		"(w: 0x%lX, e: 0x%lX, s: 0x%lX, i: %u)\n",
+	dev_dbg(&device->dev, "Found device (w: 0x%lX, e: 0x%lX, s: 0x%lX, i: %u)\n",
 		data->wbase, data->ebase, data->sbase, data->irq);
 
 	data->led.name = "cir::activity";
-- 
2.7.4


