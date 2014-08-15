Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:42751 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaHOQWk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Aug 2014 12:22:40 -0400
Date: Fri, 15 Aug 2014 21:52:35 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] rc-core: use USB API functions rather than constants
Message-ID: <20140815162235.GA7134@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch introduces the use of !usb_endpoint_dir_in(epd) and
!usb_endpoint_xfer_int(epd).

The Coccinelle semantic patch that makes these changes is as follows:

- ((epd->bEndpointAddress & \(USB_ENDPOINT_DIR_MASK\|0x80\)) !=
-  \(USB_DIR_IN\|0x80\))
+ !usb_endpoint_dir_in(epd)

@@ struct usb_endpoint_descriptor *epd; @@

- ((epd->bmAttributes & \(USB_ENDPOINT_XFERTYPE_MASK\|3\)) !=
- \(USB_ENDPOINT_XFER_INT\|3\))
+ !usb_endpoint_xfer_int(epd)

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/media/rc/streamzap.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index 80c4fee..bf4a442 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -362,16 +362,14 @@ static int streamzap_probe(struct usb_interface *intf,
 	}
 
 	sz->endpoint = &(iface_host->endpoint[0].desc);
-	if ((sz->endpoint->bEndpointAddress & USB_ENDPOINT_DIR_MASK)
-	    != USB_DIR_IN) {
+	if (!usb_endpoint_dir_in(sz->endpoint)) {
 		dev_err(&intf->dev, "%s: endpoint doesn't match input device "
 			"02%02x\n", __func__, sz->endpoint->bEndpointAddress);
 		retval = -ENODEV;
 		goto free_sz;
 	}
 
-	if ((sz->endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
-	    != USB_ENDPOINT_XFER_INT) {
+	if (!usb_endpoint_xfer_int(sz->endpoint)) {
 		dev_err(&intf->dev, "%s: endpoint attributes don't match xfer "
 			"02%02x\n", __func__, sz->endpoint->bmAttributes);
 		retval = -ENODEV;
-- 
1.9.1

