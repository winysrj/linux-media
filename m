Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-ch2-04v.sys.comcast.net ([69.252.207.36]:55510 "EHLO
        resqmta-ch2-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751524AbdCZSfd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Mar 2017 14:35:33 -0400
Subject: [PATCH 2/3] [media] mceusb: sporadic RX truncation corruption fix
To: Sean Young <sean@mess.org>
References: <58D6A1DD.2030405@comcast.net>
 <20170326102748.GA1672@gofer.mess.org>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
From: A Sun <as1033x@comcast.net>
Message-ID: <58D80963.9080207@comcast.net>
Date: Sun, 26 Mar 2017 14:33:07 -0400
MIME-Version: 1.0
In-Reply-To: <20170326102748.GA1672@gofer.mess.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

commit https://github.com/asunxx/linux/commit/d71c609e99cabc0a92a4d0b225486cbc09bbd8bd
Author: A Sun <as1033x@comcast.net>
Date:   Sun, 26 Mar 2017 14:11:49 -0400

Bug:

Intermittent RX truncation and loss of IR received data.
This resulted in receive stream synchronization errors where driver attempted to incorrectly parse IR data (eg 0x90 below) as command response.

Mar 22 12:01:40 raspberrypi kernel: [ 3969.139898] mceusb 1-1.2:1.0: processed IR data
Mar 22 12:01:40 raspberrypi kernel: [ 3969.151315] mceusb 1-1.2:1.0: rx data: 00 90 (length=2)
Mar 22 12:01:40 raspberrypi kernel: [ 3969.151321] mceusb 1-1.2:1.0: Unknown command 0x00 0x90
Mar 22 12:01:40 raspberrypi kernel: [ 3969.151336] mceusb 1-1.2:1.0: rx data: 98 0a 8d 0a 8e 0a 8e 0a 8e 0a 8e 0a 9a 0a 8e 0a 0b 3a 8e 00 80 41 59 00 00 (length=25)
Mar 22 12:01:40 raspberrypi kernel: [ 3969.151341] mceusb 1-1.2:1.0: Raw IR data, 24 pulse/space samples
Mar 22 12:01:40 raspberrypi kernel: [ 3969.151348] mceusb 1-1.2:1.0: Storing space with duration 500000

Bug trigger appears to be normal, but heavy, IR receiver use.

Fix:

Cause may be receiver with ep_in bulk endpoint incorrectly bound to usb_fill_int_urb() urb for interrupt endpoint.
This may also have been the root cause for "RX -EPIPE (urb status = -32)" lockups.
In mceusb_dev_probe(), test ep_in endpoint for int versus bulk and use usb_fill_bulk_urb() as appropriate.

Tested with:
Linux raspberrypi 4.4.50-v7+ #970 SMP Mon Feb 20 19:18:29 GMT 2017 armv7l GNU/Linux
mceusb 1-1.2:1.0: Registered Pinnacle Systems PCTV Remote USB with mce emulator interface version 1
mceusb 1-1.2:1.0: 2 tx ports (0x1 cabled) and 2 rx sensors (0x1 active)

Signed-off-by: A Sun <as1033x@comcast.net>
---
 drivers/media/rc/mceusb.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 7b6f9e5..720df6f 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1401,8 +1401,13 @@ static int mceusb_dev_probe(struct usb_interface *intf,
 	INIT_WORK(&ir->kevent, mceusb_deferred_kevent);
 
 	/* wire up inbound data handler */
-	usb_fill_int_urb(ir->urb_in, dev, pipe, ir->buf_in, maxp,
+	if (usb_endpoint_xfer_int(ep_in)) {
+		usb_fill_int_urb(ir->urb_in, dev, pipe, ir->buf_in, maxp,
 				mceusb_dev_recv, ir, ep_in->bInterval);
+	} else {
+		usb_fill_bulk_urb(ir->urb_in, dev, pipe, ir->buf_in, maxp,
+				mceusb_dev_recv, ir);
+	}
 	ir->urb_in->transfer_dma = ir->dma_in;
 	ir->urb_in->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
-- 
2.1.4
