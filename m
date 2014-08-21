Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38423 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbaHUPRK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 11:17:10 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] msi2500: remove unneeded local pointer on msi2500_isoc_init()
Date: Thu, 21 Aug 2014 18:16:56 +0300
Message-Id: <1408634216-2631-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to keep local copy of usb_device pointer as we
have same pointer stored and available easily from device state.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/msi2500/msi2500.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index 26b1334..71e0960 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -501,14 +501,12 @@ static void msi2500_isoc_cleanup(struct msi2500_state *s)
 /* Both v4l2_lock and vb_queue_lock should be locked when calling this */
 static int msi2500_isoc_init(struct msi2500_state *s)
 {
-	struct usb_device *udev;
 	struct urb *urb;
 	int i, j, ret;
 
 	dev_dbg(&s->udev->dev, "%s:\n", __func__);
 
 	s->isoc_errors = 0;
-	udev = s->udev;
 
 	ret = usb_set_interface(s->udev, 0, 1);
 	if (ret)
@@ -527,10 +525,11 @@ static int msi2500_isoc_init(struct msi2500_state *s)
 		dev_dbg(&s->udev->dev, "Allocated URB at 0x%p\n", urb);
 
 		urb->interval = 1;
-		urb->dev = udev;
-		urb->pipe = usb_rcvisocpipe(udev, 0x81);
+		urb->dev = s->udev;
+		urb->pipe = usb_rcvisocpipe(s->udev, 0x81);
 		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
-		urb->transfer_buffer = usb_alloc_coherent(udev, ISO_BUFFER_SIZE,
+		urb->transfer_buffer = usb_alloc_coherent(s->udev,
+				ISO_BUFFER_SIZE,
 				GFP_KERNEL, &urb->transfer_dma);
 		if (urb->transfer_buffer == NULL) {
 			dev_err(&s->udev->dev,
-- 
http://palosaari.fi/

