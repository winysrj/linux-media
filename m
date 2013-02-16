Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([46.65.169.142]:38064 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576Ab3BPVZt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 16:25:49 -0500
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@redhat.com>
Cc: =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Subject: [PATCH 1/3] [media] redrat3: limit periods to hardware limits
Date: Sat, 16 Feb 2013 21:25:43 +0000
Message-Id: <931ef7a1cb55bf99e035ffd9847a8cb0d38e71bc.1361020108.git.sean@mess.org>
In-Reply-To: <cover.1361020108.git.sean@mess.org>
References: <cover.1361020108.git.sean@mess.org>
In-Reply-To: <cover.1361020108.git.sean@mess.org>
References: <cover.1361020108.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The redrat hardware cannot handle periods of larger than 32767us,
limit appropriately. Also fix memory leak in redrat3_get_timeout.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/redrat3.c |   53 ++++++++++++++++++++------------------------
 1 files changed, 24 insertions(+), 29 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 1b37fe2..842bdcd 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -209,9 +209,6 @@ struct redrat3_dev {
 	u16 pktlen;
 	u16 pkttype;
 	u16 bytes_read;
-	/* indicate whether we are going to reprocess
-	 * the USB callback with a bigger buffer */
-	int buftoosmall;
 	char *datap;
 
 	u32 carrier;
@@ -396,7 +393,6 @@ static u32 redrat3_us_to_len(u32 microsec)
 
 	/* don't allow zero lengths to go back, breaks lirc */
 	return result ? result : 1;
-
 }
 
 /* timer callback to send reset event */
@@ -515,8 +511,6 @@ static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 
 	rr3_dbg(dev, "calling ir_raw_event_handle\n");
 	ir_raw_event_handle(rr3->rc);
-
-	return;
 }
 
 /* Util fn to send rr3 cmds */
@@ -613,7 +607,7 @@ static inline void redrat3_delete(struct redrat3_dev *rr3,
 
 static u32 redrat3_get_timeout(struct redrat3_dev *rr3)
 {
-	u32 *tmp;
+	__be32 *tmp;
 	u32 timeout = MS_TO_US(150); /* a sane default, if things go haywire */
 	int len, ret, pipe;
 
@@ -628,14 +622,16 @@ static u32 redrat3_get_timeout(struct redrat3_dev *rr3)
 	ret = usb_control_msg(rr3->udev, pipe, RR3_GET_IR_PARAM,
 			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
 			      RR3_IR_IO_SIG_TIMEOUT, 0, tmp, len, HZ * 5);
-	if (ret != len) {
+	if (ret != len)
 		dev_warn(rr3->dev, "Failed to read timeout from hardware\n");
-		return timeout;
+	else {
+		timeout = redrat3_len_to_us(be32_to_cpup(tmp));
+
+		rr3_dbg(rr3->dev, "Got timeout of %d ms\n", timeout / 1000);
 	}
 
-	timeout = redrat3_len_to_us(be32_to_cpu(*tmp));
+	kfree(tmp);
 
-	rr3_dbg(rr3->dev, "Got timeout of %d ms\n", timeout / 1000);
 	return timeout;
 }
 
@@ -755,7 +751,6 @@ static void redrat3_read_packet_start(struct redrat3_dev *rr3, int len)
 
 static void redrat3_read_packet_continue(struct redrat3_dev *rr3, int len)
 {
-
 	rr3_ftr(rr3->dev, "Entering %s\n", __func__);
 
 	memcpy(rr3->datap, (unsigned char *)rr3->bulk_in_buf, len);
@@ -815,7 +810,7 @@ out:
 }
 
 /* callback function from USB when async USB request has completed */
-static void redrat3_handle_async(struct urb *urb, struct pt_regs *regs)
+static void redrat3_handle_async(struct urb *urb)
 {
 	struct redrat3_dev *rr3;
 	int ret;
@@ -857,7 +852,7 @@ static void redrat3_handle_async(struct urb *urb, struct pt_regs *regs)
 	}
 }
 
-static void redrat3_write_bulk_callback(struct urb *urb, struct pt_regs *regs)
+static void redrat3_write_bulk_callback(struct urb *urb)
 {
 	struct redrat3_dev *rr3;
 	int len;
@@ -901,7 +896,7 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
 	struct redrat3_dev *rr3 = rcdev->priv;
 	struct device *dev = rr3->dev;
 	struct redrat3_signal_header header;
-	int i, j, ret, ret_len, offset;
+	int i, ret, ret_len, offset;
 	int lencheck, cur_sample_len, pipe;
 	char *buffer = NULL, *sigdata = NULL;
 	int *sample_lens = NULL;
@@ -931,8 +926,19 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
 		goto out;
 	}
 
+	sigdata = kzalloc((count + RR3_TX_TRAILER_LEN), GFP_KERNEL);
+	if (!sigdata) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	for (i = 0; i < count; i++) {
 		cur_sample_len = redrat3_us_to_len(txbuf[i]);
+		if (cur_sample_len > 0xffff) {
+			dev_warn(dev, "transmit period of %uus truncated to %uus\n",
+					txbuf[i], redrat3_len_to_us(0xffff));
+			cur_sample_len = 0xffff;
+		}
 		for (lencheck = 0; lencheck < curlencheck; lencheck++) {
 			if (sample_lens[lencheck] == cur_sample_len)
 				break;
@@ -950,22 +956,11 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
 				break;
 			}
 		}
-	}
-
-	sigdata = kzalloc((count + RR3_TX_TRAILER_LEN), GFP_KERNEL);
-	if (!sigdata) {
-		ret = -ENOMEM;
-		goto out;
+		sigdata[i] = lencheck;
 	}
 
 	sigdata[count] = RR3_END_OF_SIGNAL;
 	sigdata[count + 1] = RR3_END_OF_SIGNAL;
-	for (i = 0; i < count; i++) {
-		for (j = 0; j < curlencheck; j++) {
-			if (sample_lens[j] == redrat3_us_to_len(txbuf[i]))
-				sigdata[i] = j;
-		}
-	}
 
 	offset = RR3_TX_HEADER_OFFSET;
 	sendbuf_len = RR3_HEADER_LENGTH + (sizeof(u16) * RR3_DRIVER_MAXLENS)
@@ -1175,7 +1170,7 @@ static int redrat3_dev_probe(struct usb_interface *intf,
 	pipe = usb_rcvbulkpipe(udev, ep_in->bEndpointAddress);
 	usb_fill_bulk_urb(rr3->read_urb, udev, pipe,
 			  rr3->bulk_in_buf, ep_in->wMaxPacketSize,
-			  (usb_complete_t)redrat3_handle_async, rr3);
+			  redrat3_handle_async, rr3);
 
 	/* set up bulk-out endpoint*/
 	rr3->write_urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -1195,7 +1190,7 @@ static int redrat3_dev_probe(struct usb_interface *intf,
 	pipe = usb_sndbulkpipe(udev, ep_out->bEndpointAddress);
 	usb_fill_bulk_urb(rr3->write_urb, udev, pipe,
 			  rr3->bulk_out_buf, ep_out->wMaxPacketSize,
-			  (usb_complete_t)redrat3_write_bulk_callback, rr3);
+			  redrat3_write_bulk_callback, rr3);
 
 	rr3->udev = udev;
 
-- 
1.7.2.5

