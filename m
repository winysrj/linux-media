Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44532 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab1IKX2f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Sep 2011 19:28:35 -0400
Received: by wyh22 with SMTP id 22so2958110wyh.19
        for <linux-media@vger.kernel.org>; Sun, 11 Sep 2011 16:28:34 -0700 (PDT)
Subject: [PATCH 1/2] [ver 1.89] DM04/QQBOX Interupt Urb and Timing changes
From: tvboxspy <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Mon, 12 Sep 2011 00:26:50 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <4e6d43c1.89cde30a.3f31.ffff8707@mx.google.com>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reduce buffer size of Interupt urb to 128 bytes and polling
interval to 8.

The devices buffer appears to only handle a maxium of 40 bytes.
If the buffer is full a slowing effect is noticed causing occasionnal
dropped streaming packets.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/lmedm04.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index 55b25be..5fdeed1 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -333,7 +333,7 @@ static int lme2510_int_read(struct dvb_usb_adapter *adap)
 	if (lme_int->lme_urb == NULL)
 			return -ENOMEM;
 
-	lme_int->buffer = usb_alloc_coherent(adap->dev->udev, 5000, GFP_ATOMIC,
+	lme_int->buffer = usb_alloc_coherent(adap->dev->udev, 128, GFP_ATOMIC,
 					&lme_int->lme_urb->transfer_dma);
 
 	if (lme_int->buffer == NULL)
@@ -343,10 +343,10 @@ static int lme2510_int_read(struct dvb_usb_adapter *adap)
 				adap->dev->udev,
 				usb_rcvintpipe(adap->dev->udev, 0xa),
 				lme_int->buffer,
-				4096,
+				128,
 				lme2510_int_response,
 				adap,
-				11);
+				8);
 
 	lme_int->lme_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
@@ -1261,7 +1261,7 @@ static void *lme2510_exit_int(struct dvb_usb_device *d)
 
 	if (st->lme_urb != NULL) {
 		usb_kill_urb(st->lme_urb);
-		usb_free_coherent(d->udev, 5000, st->buffer,
+		usb_free_coherent(d->udev, 128, st->buffer,
 				  st->lme_urb->transfer_dma);
 		info("Interrupt Service Stopped");
 	}
@@ -1312,5 +1312,5 @@ module_exit(lme2510_module_exit);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("LME2510(C) DVB-S USB2.0");
-MODULE_VERSION("1.88");
+MODULE_VERSION("1.89");
 MODULE_LICENSE("GPL");
-- 
1.7.5.4



