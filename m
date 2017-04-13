Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-ch2-02v.sys.comcast.net ([69.252.207.34]:58056 "EHLO
        resqmta-ch2-02v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750746AbdDMIHR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 04:07:17 -0400
Subject: [PATCH v2] [media] mceusb: TX -EPIPE (urb status = -32) lockup fix
To: linux-media@vger.kernel.org
References: <58EEC1CB.7030806@comcast.net>
Cc: Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
From: A Sun <as1033x@comcast.net>
Message-ID: <58EF3197.9060707@comcast.net>
Date: Thu, 13 Apr 2017 04:06:47 -0400
MIME-Version: 1.0
In-Reply-To: <58EEC1CB.7030806@comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


fix previous v1 patch error; incorrect location of "ir->pipe_in = pipe;"
caused null pointer dereference

Bug:

Once IR blasting or mceusb device commands fail with mce_async_callback() TX -EPIPE error, all subsequent TX to device then fail with the same error.
...
[  249.986174] mceusb 1-1.2:1.0: requesting 38000 HZ carrier
[  249.986210] mceusb 1-1.2:1.0: send request called (size=0x4)
[  249.986256] mceusb 1-1.2:1.0: send request complete (res=0)
[  249.986403] mceusb 1-1.2:1.0: Error: request urb status = -32 (TX HALT)
[  249.999885] mceusb 1-1.2:1.0: send request called (size=0x3)
[  249.999929] mceusb 1-1.2:1.0: send request complete (res=0)
[  250.000013] mceusb 1-1.2:1.0: Error: request urb status = -32 (TX HALT)
[  250.019830] mceusb 1-1.2:1.0: send request called (size=0x21)
[  250.019868] mceusb 1-1.2:1.0: send request complete (res=0)
[  250.020007] mceusb 1-1.2:1.0: Error: request urb status = -32 (TX HALT)
...

Fix:

Message pertains to TX usb halt (stall) condition requiring usb_clear_halt() call in non-interrupt context to recover.
Add USB TX halt error handling similar to the RX halt handling case from an earlier patch proposal.
Reorder some mceusb code to accommodate TX halt error handling.

This patch depends on the earlier proposed patch set:
  [PATCH 1/3] [media] mceusb: RX -EPIPE (urb status = -32) lockup failure fix
  [PATCH 2/3] [media] mceusb: sporadic RX truncation corruption fix
  [PATCH 3/3] [media] mceusb: fix inaccurate debug buffer dumps and misleading

Tested with:

Linux raspberrypi 4.4.50-v7+ #970 SMP Mon Feb 20 19:18:29 GMT 2017 armv7l GNU/Linux
mceusb 1-1.2:1.0: Registered SMK eHome Infrared Transceiver with mce emulator interface version 1
mceusb 1-1.2:1.0: 2 tx ports (0x1 cabled) and 2 rx sensors (0x1 active)

Fault simulation/injection is by executing the following USB operation in a mceusb instrumented driver, prior to TX I/O.
    retval = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
	USB_REQ_SET_FEATURE, USB_RECIP_ENDPOINT,
	USB_ENDPOINT_HALT, usb_pipeendpoint(ir->pipe_out),
	NULL, 0, USB_CTRL_SET_TIMEOUT);
    dev_dbg(ir->dev, "set halt retval, %d", retval);

After setting halt state for the TX endpoint, perform an lirc "irsend" to generate TX traffic to device.
After the TX HALT, the patch restores subsequent TX to working state.
...
[  508.009638] mceusb 1-1.2:1.0: send request called (size=0x3)
[  508.009697] mceusb 1-1.2:1.0: send request complete (res=0)
[  508.009847] mce_async_callback()
[  508.009864] mceusb 1-1.2:1.0: Error: request urb status = -32 (TX HALT)
[  508.009890] mceusb 1-1.2:1.0: kevent 0 scheduled
[  508.021552] mceusb 1-1.2:1.0: send request called (size=0x21)
[  508.021598] mceusb 1-1.2:1.0: send request complete (res=0)
[  508.021963] mce_async_callback()
[  508.021981] mceusb 1-1.2:1.0: tx data: 84 b0 0c 8c 0c 84 8c 0c 8c 0c 84 8c 0c 8c 0c 84 98 0c 98 0c 84 98 0c 8c 0c 84 8c 0c 8c 0c 81 8c 80 (length=33)
[  508.021997] mceusb 1-1.2:1.0: Raw IR data, 0 pulse/space samples
[  508.066627] mceusb 1-1.2:1.0: send request called (size=0x3)
[  508.066669] mceusb 1-1.2:1.0: send request complete (res=0)
[  508.066841] mce_async_callback()
[  508.066858] mceusb 1-1.2:1.0: tx data: 9f 08 03 (length=3)
...

Open issue(s):

Testing with Pinnacle mceusb device reveals device specific (non USB 2.0 standard) misbehavior with respect to USB TX halt.

Linux raspberrypi 4.4.50-v7+ #970 SMP Mon Feb 20 19:18:29 GMT 2017 armv7l GNU/Linux
mceusb 1-1.2:1.0: Registered Pinnacle Systems PCTV Remote USB with mce emulator interface version 1
mceusb 1-1.2:1.0: 2 tx ports (0x1 cabled) and 2 rx sensors (0x1 active)

The Pinnacle device failed Linux usbtest module (modded to bind to the Pinnacle) test 13 with bogus halt status and -110 (-ETIMEDOUT) errors.

[ 4558.114664] usbcore: deregistering interface driver mceusb
[14956.572207] usbtest 1-1.2:1.0: mce ir device
[14956.572234] usbtest 1-1.2:1.0: full-speed {control bulk-out} tests
[14956.572363] usbcore: registered new interface driver usbtest
[15241.341143] usbtest 1-1.2:1.0: TEST 1:  write 512 bytes 1000 times
[15456.690845] usbtest 1-1.2:1.0: TEST 13:  set/clear 1000 halts
[15456.691362] usbtest 1-1.2:1.0: ep 02 bogus status: 0001 != 0
[15456.691381] usbtest 1-1.2:1.0: halts failed, iterations left 999

[37432.646344] usbcore: deregistering interface driver mceusb
[37468.447929] usbtest 1-1.2:1.0: mce ir device
[37468.447956] usbtest 1-1.2:1.0: full-speed {control bulk-out} tests
[37468.448079] usbcore: registered new interface driver usbtest
[37519.150810] usbtest 1-1.2:1.0: TEST 1:  write 512 bytes 1000 times
[37537.853493] usbtest 1-1.2:1.0: TEST 13:  set/clear 1000 halts
[37547.866871] usb 1-1.2: verify_not_halted failed, iterations left 0, status -110 (not 0)
[37547.866901] usbtest 1-1.2:1.0: halts failed, iterations left 999

With mceusb, upon executing usb_clear_halt() on this Pinnacle mceusb USB TX end-point, regardless of its halt/stall state, TX functionality silently ceases.
mce_async_callback() invocations cease, and there are no other error indications from usb_submit_urb() or anywhere else.
An escalating USB reset was necessary to restore this device to working state.
Certain mceusb devices may require device specific recovery procedure for TX halt conditions, which this patch does not address.

Signed-off-by: A Sun <as1033x@comcast.net>
---
 drivers/media/rc/mceusb.c | 89 +++++++++++++++++++++++++++++------------------
 1 file changed, 56 insertions(+), 33 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index a9a9a85..af46860 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -419,6 +419,7 @@ struct mceusb_dev {
 	struct urb *urb_in;
 	unsigned int pipe_in;
 	struct usb_endpoint_descriptor *usb_ep_out;
+	unsigned int pipe_out;
 
 	/* buffers and dma */
 	unsigned char *buf_in;
@@ -456,7 +457,8 @@ struct mceusb_dev {
 	u8 txports_cabled;	/* bitmask of transmitters with cable */
 	u8 rxports_active;	/* bitmask of active receive sensors */
 
-	/* kevent support */
+	/* async error handler mceusb_deferred_kevent() support
+	 * via workqueue kworker (previously keventd) threads */
 	struct work_struct kevent;
 	unsigned long kevent_flags;
 #		define EVENT_TX_HALT	0
@@ -694,6 +696,22 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 #endif
 }
 
+/*
+ * Schedule work that can't be done in interrupt handlers
+ * (mceusb_dev_recv() and mce_async_callback()) nor tasklets.
+ * Invokes mceusb_deferred_kevent() for recovering from
+ * error events specified by the kevent bit field.
+ */
+static void mceusb_defer_kevent(struct mceusb_dev *ir, int kevent)
+{
+	set_bit(kevent, &ir->kevent_flags);
+	if (!schedule_work(&ir->kevent)) {
+		dev_err(ir->dev, "kevent %d may have been dropped", kevent);
+	} else {
+		dev_dbg(ir->dev, "kevent %d scheduled", kevent);
+	}
+}
+
 static void mce_async_callback(struct urb *urb)
 {
 	struct mceusb_dev *ir;
@@ -720,6 +738,11 @@ static void mce_async_callback(struct urb *urb)
 		break;
 
 	case -EPIPE:
+		dev_err(ir->dev, "Error: request urb status = %d (TX HALT)",
+			urb->status);
+		mceusb_defer_kevent(ir, EVENT_TX_HALT);
+		break;
+
 	default:
 		dev_err(ir->dev, "Error: request urb status = %d", urb->status);
 		break;
@@ -734,7 +757,7 @@ static void mce_async_callback(struct urb *urb)
 static void mce_request_packet(struct mceusb_dev *ir, unsigned char *data,
 								int size)
 {
-	int res, pipe;
+	int res;
 	struct urb *async_urb;
 	struct device *dev = ir->dev;
 	unsigned char *async_buf;
@@ -753,17 +776,12 @@ static void mce_request_packet(struct mceusb_dev *ir, unsigned char *data,
 
 	/* outbound data */
 	if (usb_endpoint_xfer_int(ir->usb_ep_out)) {
-		pipe = usb_sndintpipe(ir->usbdev,
-				 ir->usb_ep_out->bEndpointAddress);
-		usb_fill_int_urb(async_urb, ir->usbdev, pipe, async_buf,
-				 size, mce_async_callback, ir,
+		usb_fill_int_urb(async_urb, ir->usbdev, ir->pipe_out,
+				 async_buf, size, mce_async_callback, ir,
 				 ir->usb_ep_out->bInterval);
 	} else {
-		pipe = usb_sndbulkpipe(ir->usbdev,
-				 ir->usb_ep_out->bEndpointAddress);
-		usb_fill_bulk_urb(async_urb, ir->usbdev, pipe,
-				 async_buf, size, mce_async_callback,
-				 ir);
+		usb_fill_bulk_urb(async_urb, ir->usbdev, ir->pipe_out,
+				 async_buf, size, mce_async_callback, ir);
 	}
 	memcpy(async_buf, data, size);
 
@@ -1034,23 +1052,6 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 	}
 }
 
-/*
- * Workqueue task dispatcher
- * for work that can't be done in interrupt handlers
- * (mceusb_dev_recv() and mce_async_callback()) nor tasklets.
- * Invokes mceusb_deferred_kevent() for recovering from
- * error events specified by the kevent bit field.
- */
-static void mceusb_defer_kevent(struct mceusb_dev *ir, int kevent)
-{
-	set_bit(kevent, &ir->kevent_flags);
-	if (!schedule_work(&ir->kevent)) {
-		dev_err(ir->dev, "kevent %d may have been dropped", kevent);
-	} else {
-		dev_dbg(ir->dev, "kevent %d scheduled", kevent);
-	}
-}
-
 static void mceusb_dev_recv(struct urb *urb)
 {
 	struct mceusb_dev *ir;
@@ -1220,16 +1221,28 @@ static void mceusb_deferred_kevent(struct work_struct *work)
 		if (status < 0) {
 			dev_err(ir->dev, "rx clear halt error %d",
 				status);
-			return;
+			goto done_rx_halt;
 		}
 		clear_bit(EVENT_RX_HALT, &ir->kevent_flags);
 		status = usb_submit_urb(ir->urb_in, GFP_KERNEL);
 		if (status < 0) {
 			dev_err(ir->dev, "rx unhalt submit urb error %d",
 				status);
-			return;
+			goto done_rx_halt;
 		}
 	}
+done_rx_halt:
+	if (test_bit(EVENT_TX_HALT, &ir->kevent_flags)) {
+		status = usb_clear_halt(ir->usbdev, ir->pipe_out);
+		if (status < 0) {
+			dev_err(ir->dev, "tx clear halt error %d",
+				  status);
+			goto done_tx_halt;
+		}
+		clear_bit(EVENT_TX_HALT, &ir->kevent_flags);
+	}
+done_tx_halt:
+	return;
 }
 
 static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
@@ -1373,6 +1386,7 @@ static int mceusb_dev_probe(struct usb_interface *intf,
 	if (!ir->urb_in)
 		goto urb_in_alloc_fail;
 
+	ir->pipe_in = pipe;
 	ir->usbdev = usb_get_dev(dev);
 	ir->dev = &intf->dev;
 	ir->len_in = maxp;
@@ -1383,6 +1397,13 @@ static int mceusb_dev_probe(struct usb_interface *intf,
 
 	/* Saving usb interface data for use by the transmitter routine */
 	ir->usb_ep_out = ep_out;
+	if (usb_endpoint_xfer_int(ir->usb_ep_out)) {
+		ir->pipe_out = usb_sndintpipe(ir->usbdev,
+					ir->usb_ep_out->bEndpointAddress);
+	} else {
+		ir->pipe_out = usb_sndbulkpipe(ir->usbdev,
+					ir->usb_ep_out->bEndpointAddress);
+	}
 
 	if (dev->descriptor.iManufacturer
 	    && usb_string(dev, dev->descriptor.iManufacturer,
@@ -1394,13 +1415,14 @@ static int mceusb_dev_probe(struct usb_interface *intf,
 		snprintf(name + strlen(name), sizeof(name) - strlen(name),
 			 " %s", buf);
 
+	/* initialize async USB error handler before registering
+	 * or activating any mceusb RX and TX functions */
+	INIT_WORK(&ir->kevent, mceusb_deferred_kevent);
+
 	ir->rc = mceusb_init_rc_dev(ir);
 	if (!ir->rc)
 		goto rc_dev_fail;
 
-	ir->pipe_in = pipe;
-	INIT_WORK(&ir->kevent, mceusb_deferred_kevent);
-
 	/* wire up inbound data handler */
 	if (usb_endpoint_xfer_int(ep_in)) {
 		usb_fill_int_urb(ir->urb_in, dev, pipe, ir->buf_in, maxp,
@@ -1450,6 +1472,7 @@ static int mceusb_dev_probe(struct usb_interface *intf,
 
 	/* Error-handling path */
 rc_dev_fail:
+	cancel_work_sync(&ir->kevent);
 	usb_put_dev(ir->usbdev);
 	usb_kill_urb(ir->urb_in);
 	usb_free_urb(ir->urb_in);
-- 
2.1.4
