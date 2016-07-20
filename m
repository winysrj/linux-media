Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:49861 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991AbcGTRDx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 13:03:53 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Chris Dodge <chris@redrat.co.uk>, linux-media@vger.kernel.org
Subject: [PATCH 2/2] [media] redrat3: hardware-specific parameters
Date: Wed, 20 Jul 2016 18:03:50 +0100
Message-Id: <1469034230-19978-2-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add these options as module parameters for now; should other drivers
need similar options we could add it to the LIRC api.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/redrat3.c | 50 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 4739bce..68df9d7 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -124,6 +124,41 @@
 #define USB_RR3USB_PRODUCT_ID	0x0001
 #define USB_RR3IIUSB_PRODUCT_ID	0x0005
 
+
+/*
+ * The redrat3 encodes an IR signal as set of different lengths and a set
+ * of indices into those lengths. This sets how much two lengths must
+ * differ before they are considered distinct, the value is specified
+ * in microseconds.
+ * Default 5, value 0 to 127.
+ */
+static int length_fuzz = 5;
+module_param(length_fuzz, uint, 0644);
+MODULE_PARM_DESC(length_fuzz, "Length Fuzz (0-127)");
+
+/*
+ * When receiving a continuous ir stream (for example when a user is
+ * holding a button down on a remote), this specifies the minimum size
+ * of a space when the redrat3 sends a irdata packet to the host. Specified
+ * in miliseconds. Default value 18ms.
+ * The value can be between 2 and 30 inclusive.
+ */
+static int minimum_pause = 18;
+module_param(minimum_pause, uint, 0644);
+MODULE_PARM_DESC(minimum_pause, "Minimum Pause in ms (2-30)");
+
+/*
+ * The carrier frequency is measured during the first pulse of the IR
+ * signal. The larger the number of periods used To measure, the more
+ * accurate the result is likely to be, however some signals have short
+ * initial pulses, so in some case it may be necessary to reduce this value.
+ * Default 8, value 1 to 255.
+ */
+static int periods_measure_carrier = 8;
+module_param(periods_measure_carrier, uint, 0644);
+MODULE_PARM_DESC(periods_measure_carrier, "Number of Periods to Measure Carrier (1-255)");
+
+
 struct redrat3_header {
 	__be16 length;
 	__be16 transfer_type;
@@ -525,12 +560,25 @@ static void redrat3_reset(struct redrat3_dev *rr3)
 			     RR3_CPUCS_REG_ADDR, 0, val, len, HZ * 25);
 	dev_dbg(dev, "reset returned 0x%02x\n", rc);
 
-	*val = 5;
+	*val = length_fuzz;
 	rc = usb_control_msg(udev, txpipe, RR3_SET_IR_PARAM,
 			     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
 			     RR3_IR_IO_LENGTH_FUZZ, 0, val, len, HZ * 25);
 	dev_dbg(dev, "set ir parm len fuzz %d rc 0x%02x\n", *val, rc);
 
+	*val = (65536 - (minimum_pause * 2000)) / 256;
+	rc = usb_control_msg(udev, txpipe, RR3_SET_IR_PARAM,
+			     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
+			     RR3_IR_IO_MIN_PAUSE, 0, val, len, HZ * 25);
+	dev_dbg(dev, "set ir parm min pause %d rc 0x%02x\n", *val, rc);
+
+	*val = periods_measure_carrier;
+	rc = usb_control_msg(udev, txpipe, RR3_SET_IR_PARAM,
+			     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
+			     RR3_IR_IO_PERIODS_MF, 0, val, len, HZ * 25);
+	dev_dbg(dev, "set ir parm periods measure carrier %d rc 0x%02x", *val,
+									rc);
+
 	*val = RR3_DRIVER_MAXLENS;
 	rc = usb_control_msg(udev, txpipe, RR3_SET_IR_PARAM,
 			     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
-- 
2.7.4

