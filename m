Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:39410 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbaLAIsU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Dec 2014 03:48:20 -0500
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, Steven Guitton <keltiek@gmail.com>
Subject: [PATCH] [media] redrat3: ensure dma is setup properly
Date: Mon,  1 Dec 2014 08:48:16 +0000
Message-Id: <1417423696-665-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes the driver on arm.

Reported-by: Steven Guitton <keltiek@gmail.com>
Tested-by: Steven Guitton <keltiek@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/redrat3.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 795b394..c4def66 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -966,7 +966,7 @@ static int redrat3_dev_probe(struct usb_interface *intf,
 
 	rr3->ep_in = ep_in;
 	rr3->bulk_in_buf = usb_alloc_coherent(udev,
-		le16_to_cpu(ep_in->wMaxPacketSize), GFP_ATOMIC, &rr3->dma_in);
+		le16_to_cpu(ep_in->wMaxPacketSize), GFP_KERNEL, &rr3->dma_in);
 	if (!rr3->bulk_in_buf) {
 		dev_err(dev, "Read buffer allocation failure\n");
 		goto error;
@@ -975,6 +975,8 @@ static int redrat3_dev_probe(struct usb_interface *intf,
 	pipe = usb_rcvbulkpipe(udev, ep_in->bEndpointAddress);
 	usb_fill_bulk_urb(rr3->read_urb, udev, pipe, rr3->bulk_in_buf,
 		le16_to_cpu(ep_in->wMaxPacketSize), redrat3_handle_async, rr3);
+	rr3->read_urb->transfer_dma = rr3->dma_in;
+	rr3->read_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
 	rr3->ep_out = ep_out;
 	rr3->udev = udev;
-- 
1.9.3

