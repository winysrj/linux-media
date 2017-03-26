Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-ch2-01v.sys.comcast.net ([69.252.207.33]:45140 "EHLO
        resqmta-ch2-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751378AbdCZTHS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Mar 2017 15:07:18 -0400
Subject: [PATCH 3/3] [media] mceusb: fix inaccurate debug buffer dumps,and
 misleading debug messages
To: Sean Young <sean@mess.org>
References: <58D6A1DD.2030405@comcast.net>
 <20170326102748.GA1672@gofer.mess.org>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
From: A Sun <as1033x@comcast.net>
Message-ID: <58D810D3.6000109@comcast.net>
Date: Sun, 26 Mar 2017 15:04:51 -0400
MIME-Version: 1.0
In-Reply-To: <20170326102748.GA1672@gofer.mess.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

commit https://github.com/asunxx/linux/commit/14cae79824739ae03caa3b1c4f66cbdf73654bde
Author: A Sun <as1033x@comcast.net>
Date:   Sun, 26 Mar 2017 14:55:31 -0400

Bug:

Some dev_dbg messages are misleading.
Some dev_dbg messages have inconsistent formatting.
mceusb_dev_printdata() prints incorrect range of bytes (0 to len) in buffer which the driver will actually process next.

Fix:

Add size of received data argument to mceusb_dev_printdata().
Revise buffer print range to (offset to offset+len).
Remove static USB_BUFLEN = 32, which is variable depending on device
(buffer size is 64 for Pinnacle IR transceiver).
Revise bound test to prevent reporting data beyond end of read or end of buffer.
Drop "\n" use from dev_dbg().
References to "receive request" should read "send request".

Tested with:

Linux raspberrypi 4.4.50-v7+ #970 SMP Mon Feb 20 19:18:29 GMT 2017 armv7l GNU/Linux
mceusb 1-1.2:1.0: Registered Pinnacle Systems PCTV Remote USB with mce emulator interface version 1
mceusb 1-1.2:1.0: 2 tx ports (0x1 cabled) and 2 rx sensors (0x1 active)

Signed-off-by: A Sun <as1033x@comcast.net>
---
 drivers/media/rc/mceusb.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 720df6f..a9a9a85 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -48,7 +48,6 @@
 			"device driver"
 #define DRIVER_NAME	"mceusb"
 
-#define USB_BUFLEN		32 /* USB reception buffer length */
 #define USB_CTRL_MSG_SZ		2  /* Size of usb ctrl msg on gen1 hw */
 #define MCE_G1_INIT_MSGS	40 /* Init messages on gen1 hw to throw out */
 
@@ -535,7 +534,7 @@ static int mceusb_cmd_datasize(u8 cmd, u8 subcmd)
 }
 
 static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
-				 int offset, int len, bool out)
+				 int buf_len, int offset, int len, bool out)
 {
 #if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)
 	char *inout;
@@ -552,7 +551,8 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 		return;
 
 	dev_dbg(dev, "%cx data: %*ph (length=%d)",
-		(out ? 't' : 'r'), min(len, USB_BUFLEN), buf, len);
+		(out ? 't' : 'r'),
+		min(len, buf_len - offset), buf + offset, len);
 
 	inout = out ? "Request" : "Got";
 
@@ -709,7 +709,8 @@ static void mce_async_callback(struct urb *urb)
 	case 0:
 		len = urb->actual_length;
 
-		mceusb_dev_printdata(ir, urb->transfer_buffer, 0, len, true);
+		mceusb_dev_printdata(ir, urb->transfer_buffer, len,
+				     0, len, true);
 		break;
 
 	case -ECONNRESET:
@@ -729,7 +730,7 @@ static void mce_async_callback(struct urb *urb)
 	usb_free_urb(urb);
 }
 
-/* request incoming or send outgoing usb packet - used to initialize remote */
+/* request outgoing (send) usb packet - used to initialize remote */
 static void mce_request_packet(struct mceusb_dev *ir, unsigned char *data,
 								int size)
 {
@@ -740,7 +741,7 @@ static void mce_request_packet(struct mceusb_dev *ir, unsigned char *data,
 
 	async_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (unlikely(!async_urb)) {
-		dev_err(dev, "Error, couldn't allocate urb!\n");
+		dev_err(dev, "Error, couldn't allocate urb!");
 		return;
 	}
 
@@ -766,17 +767,17 @@ static void mce_request_packet(struct mceusb_dev *ir, unsigned char *data,
 	}
 	memcpy(async_buf, data, size);
 
-	dev_dbg(dev, "receive request called (size=%#x)", size);
+	dev_dbg(dev, "send request called (size=%#x)", size);
 
 	async_urb->transfer_buffer_length = size;
 	async_urb->dev = ir->usbdev;
 
 	res = usb_submit_urb(async_urb, GFP_ATOMIC);
 	if (res) {
-		dev_err(dev, "receive request FAILED! (res=%d)", res);
+		dev_err(dev, "send request FAILED! (res=%d)", res);
 		return;
 	}
-	dev_dbg(dev, "receive request complete (res=%d)", res);
+	dev_dbg(dev, "send request complete (res=%d)", res);
 }
 
 static void mce_async_out(struct mceusb_dev *ir, unsigned char *data, int size)
@@ -982,7 +983,7 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 		switch (ir->parser_state) {
 		case SUBCMD:
 			ir->rem = mceusb_cmd_datasize(ir->cmd, ir->buf_in[i]);
-			mceusb_dev_printdata(ir, ir->buf_in, i - 1,
+			mceusb_dev_printdata(ir, ir->buf_in, buf_len, i - 1,
 					     ir->rem + 2, false);
 			mceusb_handle_command(ir, i);
 			ir->parser_state = CMD_DATA;
@@ -994,7 +995,7 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 			rawir.duration = (ir->buf_in[i] & MCE_PULSE_MASK)
 					 * US_TO_NS(MCE_TIME_UNIT);
 
-			dev_dbg(ir->dev, "Storing %s with duration %d",
+			dev_dbg(ir->dev, "Storing %s with duration %u",
 				rawir.pulse ? "pulse" : "space",
 				rawir.duration);
 
@@ -1015,7 +1016,7 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 				continue;
 			}
 			ir->rem = (ir->cmd & MCE_PACKET_LENGTH_MASK);
-			mceusb_dev_printdata(ir, ir->buf_in,
+			mceusb_dev_printdata(ir, ir->buf_in, buf_len,
 					     i, ir->rem + 1, false);
 			if (ir->rem)
 				ir->parser_state = PARSE_IRDATA;
@@ -1412,10 +1413,10 @@ static int mceusb_dev_probe(struct usb_interface *intf,
 	ir->urb_in->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
 	/* flush buffers on the device */
-	dev_dbg(&intf->dev, "Flushing receive buffers\n");
+	dev_dbg(&intf->dev, "Flushing receive buffers");
 	res = usb_submit_urb(ir->urb_in, GFP_KERNEL);
 	if (res)
-		dev_err(&intf->dev, "failed to flush buffers: %d\n", res);
+		dev_err(&intf->dev, "failed to flush buffers: %d", res);
 
 	/* figure out which firmware/emulator version this hardware has */
 	mceusb_get_emulator_version(ir);
-- 
2.1.4
