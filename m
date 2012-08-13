Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:47004 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276Ab2HMM7z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 08:59:55 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Stefan Macher <st_maker-lirc@yahoo.de>,
	linux-media@vger.kernel.org
Subject: [PATCH 07/13] [media] iguanair: fix receiver overflow
Date: Mon, 13 Aug 2012 13:59:45 +0100
Message-Id: <1344862791-30352-7-git-send-email-sean@mess.org>
In-Reply-To: <1344862791-30352-1-git-send-email-sean@mess.org>
References: <1344862791-30352-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Pioneer CU-700 remote causes receiver overflows if you hold down any
button. The remote does not send NEC IR repeats, it repeats the entire
NEC code after 20ms.

The iguanair hardware advertises an interval of 10 which just not enough;
with 100 URBs per second and at most 7 edges per URB, we handle at most
700 edges per second. The remote generates about 900.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/iguanair.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 9810008..6a09c2e 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -484,9 +484,8 @@ static int __devinit iguanair_probe(struct usb_interface *intf,
 	init_completion(&ir->completion);
 
 	pipein = usb_rcvintpipe(udev, idesc->endpoint[0].desc.bEndpointAddress);
-	usb_fill_int_urb(ir->urb_in, udev, pipein, ir->buf_in,
-		MAX_PACKET_SIZE, iguanair_rx, ir,
-		idesc->endpoint[0].desc.bInterval);
+	usb_fill_int_urb(ir->urb_in, udev, pipein, ir->buf_in, MAX_PACKET_SIZE,
+							 iguanair_rx, ir, 1);
 	ir->urb_in->transfer_dma = ir->dma_in;
 	ir->urb_in->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
-- 
1.7.11.2

