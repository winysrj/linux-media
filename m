Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward1l.mail.yandex.net ([84.201.143.144]:33978 "EHLO
	forward1l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604AbaEEUzy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 May 2014 16:55:54 -0400
Received: from smtp17.mail.yandex.net (smtp17.mail.yandex.net [95.108.252.17])
	by forward1l.mail.yandex.net (Yandex) with ESMTP id 92BEF1520FAF
	for <linux-media@vger.kernel.org>; Tue,  6 May 2014 00:48:54 +0400 (MSK)
Received: from smtp17.mail.yandex.net (localhost [127.0.0.1])
	by smtp17.mail.yandex.net (Yandex) with ESMTP id 544EF19000E4
	for <linux-media@vger.kernel.org>; Tue,  6 May 2014 00:48:54 +0400 (MSK)
From: CrazyCat <crazycat69@narod.ru>
To: linux-media@vger.kernel.org
Subject: [PATCH] dw2102: Geniatech T220 init fixed
Date: Mon, 05 May 2014 23:48:50 +0300
Message-ID: <1709090.pAjQK6zJW5@ubuntu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Geniatech T220 init fixed.

Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>

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

