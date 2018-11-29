Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37410 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbeK3JhU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 04:37:20 -0500
Received: by mail-wr1-f67.google.com with SMTP id j10so3465479wru.4
        for <linux-media@vger.kernel.org>; Thu, 29 Nov 2018 14:30:17 -0800 (PST)
Received: from [192.168.43.227] (92.40.249.58.threembb.co.uk. [92.40.249.58])
        by smtp.gmail.com with ESMTPSA id h131sm5525852wmd.17.2018.11.29.14.30.16
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Nov 2018 14:30:16 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/4] media: lmedm04: Move interrupt buffer to priv buffer.
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <a54f1631-4279-f580-9a61-75472b2b90e2@gmail.com>
Date: Thu, 29 Nov 2018 22:30:15 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Interrupt is always present throught life time of
there is no dma element move this buffer to private
area of driver.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/lmedm04.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index 8fb53b83c914..7b1aaed259db 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -134,7 +134,7 @@ struct lme2510_state {
 	u8 stream_on;
 	u8 pid_size;
 	u8 pid_off;
-	void *buffer;
+	u8 int_buffer[128];
 	struct urb *lme_urb;
 	u8 usb_buffer[64];
 	/* Frontend original calls */
@@ -408,20 +408,14 @@ static int lme2510_int_read(struct dvb_usb_adapter *adap)
 	if (lme_int->lme_urb == NULL)
 			return -ENOMEM;
 
-	lme_int->buffer = usb_alloc_coherent(d->udev, 128, GFP_ATOMIC,
-					&lme_int->lme_urb->transfer_dma);
-
-	if (lme_int->buffer == NULL)
-			return -ENOMEM;
-
 	usb_fill_int_urb(lme_int->lme_urb,
-				d->udev,
-				usb_rcvintpipe(d->udev, 0xa),
-				lme_int->buffer,
-				128,
-				lme2510_int_response,
-				adap,
-				8);
+			 d->udev,
+			 usb_rcvintpipe(d->udev, 0xa),
+			 lme_int->int_buffer,
+			 sizeof(lme_int->int_buffer),
+			 lme2510_int_response,
+			 adap,
+			 8);
 
 	/* Quirk of pipe reporting PIPE_BULK but behaves as interrupt */
 	ep = usb_pipe_endpoint(d->udev, lme_int->lme_urb->pipe);
@@ -1245,11 +1239,9 @@ static void lme2510_exit(struct dvb_usb_device *d)
 		lme2510_kill_urb(&adap->stream);
 	}
 
-	if (st->lme_urb != NULL) {
+	if (st->lme_urb) {
 		usb_kill_urb(st->lme_urb);
 		usb_free_urb(st->lme_urb);
-		usb_free_coherent(d->udev, 128, st->buffer,
-				  st->lme_urb->transfer_dma);
 		info("Interrupt Service Stopped");
 	}
 }
-- 
2.19.1
