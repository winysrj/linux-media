Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:55706 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbcDNUmx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Apr 2016 16:42:53 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 1/2] [media] mceusb: remove useless debug message
Date: Thu, 14 Apr 2016 21:42:49 +0100
Message-Id: <1460666570-26776-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/mceusb.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 35155ae..85823e8 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -153,12 +153,6 @@
 #define MCE_COMMAND_IRDATA	0x80
 #define MCE_PACKET_LENGTH_MASK	0x1f /* Packet length mask */
 
-/* general constants */
-#define SEND_FLAG_IN_PROGRESS	1
-#define SEND_FLAG_COMPLETE	2
-#define RECV_FLAG_IN_PROGRESS	3
-#define RECV_FLAG_COMPLETE	4
-
 #define MCEUSB_RX		1
 #define MCEUSB_TX		2
 
@@ -416,7 +410,6 @@ struct mceusb_dev {
 	struct rc_dev *rc;
 
 	/* optional features we can enable */
-	bool carrier_report_enabled;
 	bool learning_enabled;
 
 	/* core device bits */
@@ -449,7 +442,6 @@ struct mceusb_dev {
 	} flags;
 
 	/* transmit support */
-	int send_flags;
 	u32 carrier;
 	unsigned char tx_mask;
 
@@ -774,8 +766,6 @@ static void mce_request_packet(struct mceusb_dev *ir, unsigned char *data,
 	} else if (urb_type == MCEUSB_RX) {
 		/* standard request */
 		async_urb = ir->urb_in;
-		ir->send_flags = RECV_FLAG_IN_PROGRESS;
-
 	} else {
 		dev_err(dev, "Error! Unknown urb type %d\n", urb_type);
 		return;
@@ -1050,7 +1040,6 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 static void mceusb_dev_recv(struct urb *urb)
 {
 	struct mceusb_dev *ir;
-	int buf_len;
 
 	if (!urb)
 		return;
@@ -1061,18 +1050,10 @@ static void mceusb_dev_recv(struct urb *urb)
 		return;
 	}
 
-	buf_len = urb->actual_length;
-
-	if (ir->send_flags == RECV_FLAG_IN_PROGRESS) {
-		ir->send_flags = SEND_FLAG_COMPLETE;
-		dev_dbg(ir->dev, "setup answer received %d bytes\n",
-			buf_len);
-	}
-
 	switch (urb->status) {
 	/* success */
 	case 0:
-		mceusb_process_ir_data(ir, buf_len);
+		mceusb_process_ir_data(ir, urb->actual_length);
 		break;
 
 	case -ECONNRESET:
-- 
2.5.5

