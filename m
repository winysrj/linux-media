Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33412 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab1IKXaV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Sep 2011 19:30:21 -0400
Received: by wwf22 with SMTP id 22so643879wwf.1
        for <linux-media@vger.kernel.org>; Sun, 11 Sep 2011 16:30:20 -0700 (PDT)
Subject: [PATCH 2/2] [ver 1.90] DM04/QQBOX Reduce USB buffer size.
From: tvboxspy <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Mon, 12 Sep 2011 00:30:10 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <4e6d448b.d0c8e30a.4606.ffff8ac9@mx.google.com>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reduced unused buffer size to 64.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/lmedm04.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index 5fdeed1..b922824 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -162,7 +162,7 @@ static int lme2510_usb_talk(struct dvb_usb_device *d,
 	int ret = 0;
 
 	if (st->usb_buffer == NULL) {
-		st->usb_buffer = kmalloc(512, GFP_KERNEL);
+		st->usb_buffer = kmalloc(64, GFP_KERNEL);
 		if (st->usb_buffer == NULL) {
 			info("MEM Error no memory");
 			return -ENOMEM;
@@ -175,8 +175,8 @@ static int lme2510_usb_talk(struct dvb_usb_device *d,
 	if (ret < 0)
 		return -EAGAIN;
 
-	/* the read/write capped at 512 */
-	memcpy(buff, wbuf, (wlen > 512) ? 512 : wlen);
+	/* the read/write capped at 64 */
+	memcpy(buff, wbuf, (wlen < 64) ? wlen : 64);
 
 	ret |= usb_clear_halt(d->udev, usb_sndbulkpipe(d->udev, 0x01));
 
@@ -186,8 +186,8 @@ static int lme2510_usb_talk(struct dvb_usb_device *d,
 
 	ret |= usb_clear_halt(d->udev, usb_rcvbulkpipe(d->udev, 0x01));
 
-	ret |= lme2510_bulk_read(d->udev, buff, (rlen > 512) ?
-			512 : rlen , 0x01);
+	ret |= lme2510_bulk_read(d->udev, buff, (rlen < 64) ?
+			rlen : 64 , 0x01);
 
 	if (rlen > 0)
 		memcpy(rbuf, buff, rlen);
@@ -580,7 +580,7 @@ static int lme2510_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
 	struct lme2510_state *st = d->priv;
-	static u8 obuf[64], ibuf[512];
+	static u8 obuf[64], ibuf[64];
 	int i, read, read_o;
 	u16 len;
 	u8 gate = st->i2c_gate;
@@ -621,7 +621,7 @@ static int lme2510_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			len = msg[i].len+3;
 		}
 
-		if (lme2510_msg(d, obuf, len, ibuf, 512) < 0) {
+		if (lme2510_msg(d, obuf, len, ibuf, 64) < 0) {
 			deb_info(1, "i2c transfer failed.");
 			return -EAGAIN;
 		}
@@ -1312,5 +1312,5 @@ module_exit(lme2510_module_exit);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("LME2510(C) DVB-S USB2.0");
-MODULE_VERSION("1.89");
+MODULE_VERSION("1.90");
 MODULE_LICENSE("GPL");
-- 
1.7.5.4



