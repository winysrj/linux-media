Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm5.telefonica.net ([213.4.138.21]:38741 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751119Ab2IHRIj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Sep 2012 13:08:39 -0400
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: linux-media@vger.kernel.org
Subject: [PATCH] Add toggle to the tt3650_rc_query function  of the ttusb2 driver
Date: Sat, 08 Sep 2012 19:08:22 +0200
Message-ID: <2504977.yNAtCnX8Pk@jar7.dominio>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1379341.aTdRPviVF2"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart1379341.aTdRPviVF2
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

This patch add the toggle bit to the tt3650_rc_query function of the ttusb2
driver.

Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>

Jose Alberto
--nextPart1379341.aTdRPviVF2
Content-Disposition: attachment; filename="ttusb2.diff"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="ttusb2.diff"

diff -upr linux/drivers/media/usb/dvb-usb/ttusb2.c linux.new/drivers/media/usb/dvb-usb/ttusb2.c
--- linux/drivers/media/usb/dvb-usb/ttusb2.c	2012-08-14 05:45:22.000000000 +0200
+++ linux.new/drivers/media/usb/dvb-usb/ttusb2.c	2012-08-23 18:33:33.459191850 +0200
@@ -440,7 +440,7 @@ static int tt3650_rc_query(struct dvb_us
 		/* got a "press" event */
 		st->last_rc_key = (rx[3] << 8) | rx[2];
 		deb_info("%s: cmd=0x%02x sys=0x%02x\n", __func__, rx[2], rx[3]);
-		rc_keydown(d->rc_dev, st->last_rc_key, 0);
+		rc_keydown(d->rc_dev, st->last_rc_key, rx[1]);
 	} else if (st->last_rc_key) {
 		rc_keyup(d->rc_dev);
 		st->last_rc_key = 0;

--nextPart1379341.aTdRPviVF2--

