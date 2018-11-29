Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39132 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbeK3Jhb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 04:37:31 -0500
Received: by mail-wr1-f68.google.com with SMTP id t27so3470629wra.6
        for <linux-media@vger.kernel.org>; Thu, 29 Nov 2018 14:30:28 -0800 (PST)
Received: from [192.168.43.227] (92.40.249.58.threembb.co.uk. [92.40.249.58])
        by smtp.gmail.com with ESMTPSA id c7sm5121907wre.64.2018.11.29.14.30.26
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Nov 2018 14:30:26 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/4] media: lmedm04: use dvb_usbv2_generic_rw_locked
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <c5920c3c-fa85-eff5-9c3d-d79238287c2e@gmail.com>
Date: Thu, 29 Nov 2018 22:30:25 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use dvb-usb-v2 generic usb function for bulk transfers and simplify logic.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/lmedm04.c | 42 ++++++++------------------
 1 file changed, 12 insertions(+), 30 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index 7b1aaed259db..8ca0cc67541f 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -147,50 +147,30 @@ struct lme2510_state {
 	u8 dvb_usb_lme2510_firmware;
 };
 
-static int lme2510_bulk_write(struct usb_device *dev,
-				u8 *snd, int len, u8 pipe)
-{
-	int actual_l;
-
-	return usb_bulk_msg(dev, usb_sndbulkpipe(dev, pipe),
-			    snd, len, &actual_l, 100);
-}
-
-static int lme2510_bulk_read(struct usb_device *dev,
-				u8 *rev, int len, u8 pipe)
-{
-	int actual_l;
-
-	return usb_bulk_msg(dev, usb_rcvbulkpipe(dev, pipe),
-			    rev, len, &actual_l, 200);
-}
-
 static int lme2510_usb_talk(struct dvb_usb_device *d,
-		u8 *wbuf, int wlen, u8 *rbuf, int rlen)
+			    u8 *wbuf, int wlen, u8 *rbuf, int rlen)
 {
 	struct lme2510_state *st = d->priv;
-	u8 *buff = st->usb_buffer;
 	int ret = 0;
 
-	ret = mutex_lock_interruptible(&d->usb_mutex);
+	if (max(wlen, rlen) > sizeof(st->usb_buffer))
+		return -EINVAL;
 
+	ret = mutex_lock_interruptible(&d->usb_mutex);
 	if (ret < 0)
 		return -EAGAIN;
 
-	/* the read/write capped at 64 */
-	memcpy(buff, wbuf, (wlen < 64) ? wlen : 64);
+	memcpy(st->usb_buffer, wbuf, wlen);
 
-	ret |= lme2510_bulk_write(d->udev, buff, wlen , 0x01);
+	ret = dvb_usbv2_generic_rw_locked(d, st->usb_buffer, wlen,
+					  st->usb_buffer, rlen);
 
-	ret |= lme2510_bulk_read(d->udev, buff, (rlen < 64) ?
-			rlen : 64 , 0x01);
-
-	if (rlen > 0)
-		memcpy(rbuf, buff, rlen);
+	if (rlen)
+		memcpy(rbuf, st->usb_buffer, rlen);
 
 	mutex_unlock(&d->usb_mutex);
 
-	return (ret < 0) ? -ENODEV : 0;
+	return ret;
 }
 
 static int lme2510_stream_restart(struct dvb_usb_device *d)
@@ -1252,6 +1232,8 @@ static struct dvb_usb_device_properties lme2510_props = {
 	.bInterfaceNumber = 0,
 	.adapter_nr = adapter_nr,
 	.size_of_priv = sizeof(struct lme2510_state),
+	.generic_bulk_ctrl_endpoint = 0x01,
+	.generic_bulk_ctrl_endpoint_response = 0x01,
 
 	.download_firmware = lme2510_download_firmware,
 
-- 
2.19.1
