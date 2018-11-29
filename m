Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41655 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbeK3Jg4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 04:36:56 -0500
Received: by mail-wr1-f68.google.com with SMTP id x10so3450416wrs.8
        for <linux-media@vger.kernel.org>; Thu, 29 Nov 2018 14:29:54 -0800 (PST)
Received: from [192.168.43.227] (92.40.249.58.threembb.co.uk. [92.40.249.58])
        by smtp.gmail.com with ESMTPSA id s202sm4277694wme.40.2018.11.29.14.29.52
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Nov 2018 14:29:52 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/4] media: lmedm04: Move usb buffer to lme2510_state.
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <1f6430e7-4b41-1516-a3f7-01be30fdcd3f@gmail.com>
Date: Thu, 29 Nov 2018 22:29:51 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

lme2510_state exists for the entire duration of driver.

Move usb_buffer to lme2510_state removing the need for
lme2510_exit_int for removing the buffer.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/lmedm04.c | 35 +++-----------------------
 1 file changed, 3 insertions(+), 32 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index 8b405e131439..8fb53b83c914 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -136,7 +136,7 @@ struct lme2510_state {
 	u8 pid_off;
 	void *buffer;
 	struct urb *lme_urb;
-	void *usb_buffer;
+	u8 usb_buffer[64];
 	/* Frontend original calls */
 	int (*fe_read_status)(struct dvb_frontend *, enum fe_status *);
 	int (*fe_read_signal_strength)(struct dvb_frontend *, u16 *);
@@ -169,18 +169,9 @@ static int lme2510_usb_talk(struct dvb_usb_device *d,
 		u8 *wbuf, int wlen, u8 *rbuf, int rlen)
 {
 	struct lme2510_state *st = d->priv;
-	u8 *buff;
+	u8 *buff = st->usb_buffer;
 	int ret = 0;
 
-	if (st->usb_buffer == NULL) {
-		st->usb_buffer = kmalloc(64, GFP_KERNEL);
-		if (st->usb_buffer == NULL) {
-			info("MEM Error no memory");
-			return -ENOMEM;
-		}
-	}
-	buff = st->usb_buffer;
-
 	ret = mutex_lock_interruptible(&d->usb_mutex);
 
 	if (ret < 0)
@@ -1245,23 +1236,15 @@ static int lme2510_get_rc_config(struct dvb_usb_device *d,
 	return 0;
 }
 
-static void *lme2510_exit_int(struct dvb_usb_device *d)
+static void lme2510_exit(struct dvb_usb_device *d)
 {
 	struct lme2510_state *st = d->priv;
 	struct dvb_usb_adapter *adap = &d->adapter[0];
-	void *buffer = NULL;
 
 	if (adap != NULL) {
 		lme2510_kill_urb(&adap->stream);
 	}
 
-	if (st->usb_buffer != NULL) {
-		st->i2c_talk_onoff = 1;
-		st->signal_level = 0;
-		st->signal_sn = 0;
-		buffer = st->usb_buffer;
-	}
-
 	if (st->lme_urb != NULL) {
 		usb_kill_urb(st->lme_urb);
 		usb_free_urb(st->lme_urb);
@@ -1269,18 +1252,6 @@ static void *lme2510_exit_int(struct dvb_usb_device *d)
 				  st->lme_urb->transfer_dma);
 		info("Interrupt Service Stopped");
 	}
-
-	return buffer;
-}
-
-static void lme2510_exit(struct dvb_usb_device *d)
-{
-	void *usb_buffer;
-
-	if (d != NULL) {
-		usb_buffer = lme2510_exit_int(d);
-		kfree(usb_buffer);
-	}
 }
 
 static struct dvb_usb_device_properties lme2510_props = {
-- 
2.19.1
