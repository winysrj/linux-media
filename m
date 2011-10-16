Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm4.telefonica.net ([213.4.138.20]:35343 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751078Ab1JPLhJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Oct 2011 07:37:09 -0400
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: linux-media@vger.kernel.org
Subject: [PATCH] TT CT-3650 i2c fix
Date: Sun, 16 Oct 2011 13:36:57 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_bHsmO8iBKJXz8zT"
Message-Id: <201110161336.59406.jareguero@telefonica.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_bHsmO8iBKJXz8zT
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch fix a bug in the i2c code of ttusb2 driver.

Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>

Jose Alberto

--Boundary-00=_bHsmO8iBKJXz8zT
Content-Type: text/x-patch;
  charset="UTF-8";
  name="ttusb2-i2c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ttusb2-i2c.diff"

diff -ur linux/drivers/media/dvb/dvb-usb/ttusb2.c linux.new/drivers/media/dvb/dvb-usb/ttusb2.c
--- linux/drivers/media/dvb/dvb-usb/ttusb2.c	2011-09-24 05:45:14.000000000 +0200
+++ linux.new/drivers/media/dvb/dvb-usb/ttusb2.c	2011-10-01 19:42:46.715723308 +0200
@@ -384,7 +384,7 @@
 
 		memcpy(&obuf[3], msg[i].buf, msg[i].len);
 
-		if (ttusb2_msg(d, CMD_I2C_XFER, obuf, msg[i].len+3, ibuf, obuf[2] + 3) < 0) {
+		if (ttusb2_msg(d, CMD_I2C_XFER, obuf, obuf[1]+3, ibuf, obuf[2] + 3) < 0) {
 			err("i2c transfer failed.");
 			break;
 		}

--Boundary-00=_bHsmO8iBKJXz8zT--
