Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward6l.mail.yandex.net ([84.201.143.139]:47989 "EHLO
	forward6l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932762AbaFCRWz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jun 2014 13:22:55 -0400
Received: from smtp3o.mail.yandex.net (smtp3o.mail.yandex.net [37.140.190.28])
	by forward6l.mail.yandex.net (Yandex) with ESMTP id D7D0914E1103
	for <linux-media@vger.kernel.org>; Tue,  3 Jun 2014 21:22:53 +0400 (MSK)
Received: from smtp3o.mail.yandex.net (localhost [127.0.0.1])
	by smtp3o.mail.yandex.net (Yandex) with ESMTP id 8D50D1E1A65
	for <linux-media@vger.kernel.org>; Tue,  3 Jun 2014 21:22:53 +0400 (MSK)
From: CrazyCat <crazycat69@narod.ru>
To: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH] dw2102: Geniatech T220 init fixed
Date: Tue, 03 Jun 2014 20:22:44 +0300
Message-ID: <3646158.R7eJSyhLvT@computer>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Geniatech T220 init fixed - reset cmd from windows driver and fixed TS bus config for cxd2820r.

Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
---
 drivers/media/usb/dvb-usb/dw2102.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index ae0f56a..7135a3e 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -1109,6 +1109,7 @@ static struct ds3000_config su3000_ds3000_config = {
 static struct cxd2820r_config cxd2820r_config = {
 	.i2c_address = 0x6c, /* (0xd8 >> 1) */
 	.ts_mode = 0x38,
+	.ts_clock_inv = 1,
 };
 
 static struct tda18271_config tda18271_config = {
@@ -1387,20 +1388,27 @@ static int su3000_frontend_attach(struct dvb_usb_adapter *d)
 
 static int t220_frontend_attach(struct dvb_usb_adapter *d)
 {
-	u8 obuf[3] = { 0xe, 0x80, 0 };
+	u8 obuf[3] = { 0xe, 0x87, 0 };
 	u8 ibuf[] = { 0 };
 
 	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
 		err("command 0x0e transfer failed.");
 
 	obuf[0] = 0xe;
-	obuf[1] = 0x83;
+	obuf[1] = 0x86;
+	obuf[2] = 1;
+
+	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
+		err("command 0x0e transfer failed.");
+
+	obuf[0] = 0xe;
+	obuf[1] = 0x80;
 	obuf[2] = 0;
 
 	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
 		err("command 0x0e transfer failed.");
 
-	msleep(100);
+	msleep(50);
 
 	obuf[0] = 0xe;
 	obuf[1] = 0x80;
-- 
1.9.1


