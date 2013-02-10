Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm4.telefonica.net ([213.4.138.20]:63715 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752096Ab3BJTng (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 14:43:36 -0500
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: Antti Palosaari <crope@iki.fi>
Cc: Gianluca Gennari <gennarone@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Subject: [PATCH] block i2c tuner reads for Avermedia Twinstar in the af9035 driver
Date: Sun, 10 Feb 2013 20:43:33 +0100
Message-ID: <4261811.IXtDYhFBCx@jar7.dominio>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch block the i2c tuner reads for Avermedia Twinstar. If it's
needed other pids can be added.

Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>

diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.c linux.new/drivers/media/usb/dvb-usb-v2/af9035.c
--- linux/drivers/media/usb/dvb-usb-v2/af9035.c	2013-01-07 05:45:57.000000000 +0100
+++ linux.new/drivers/media/usb/dvb-usb-v2/af9035.c	2013-02-08 22:55:08.304089054 +0100
@@ -232,7 +232,11 @@ static int af9035_i2c_master_xfer(struct
 			buf[3] = 0x00; /* reg addr MSB */
 			buf[4] = 0x00; /* reg addr LSB */
 			memcpy(&buf[5], msg[0].buf, msg[0].len);
-			ret = af9035_ctrl_msg(d, &req);
+			if (state->block_read) {
+				msg[1].buf[0] = 0x3f;
+				ret = 0;
+			} else
+				ret = af9035_ctrl_msg(d, &req);
 		}
 	} else if (num == 1 && !(msg[0].flags & I2C_M_RD)) {
 		if (msg[0].len > 40) {
@@ -638,6 +642,17 @@ static int af9035_read_config(struct dvb
 	for (i = 0; i < ARRAY_SIZE(state->af9033_config); i++)
 		state->af9033_config[i].clock = clock_lut[tmp];
 
+	state->block_read = false;
+
+	if (le16_to_cpu(d->udev->descriptor.idVendor) == USB_VID_AVERMEDIA &&
+		le16_to_cpu(d->udev->descriptor.idProduct) ==
+			USB_PID_AVERMEDIA_TWINSTAR) {
+		dev_dbg(&d->udev->dev,
+				"%s: AverMedia Twinstar: block i2c read from tuner\n",
+				__func__);
+		state->block_read = true;
+	}
+
 	return 0;
 
 err:
diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.h linux.new/drivers/media/usb/dvb-usb-v2/af9035.h
--- linux/drivers/media/usb/dvb-usb-v2/af9035.h	2013-01-07 05:45:57.000000000 +0100
+++ linux.new/drivers/media/usb/dvb-usb-v2/af9035.h	2013-02-08 22:52:42.293842710 +0100
@@ -54,6 +54,7 @@ struct usb_req {
 struct state {
 	u8 seq; /* packet sequence number */
 	bool dual_mode;
+	bool block_read;
 	struct af9033_config af9033_config[2];
 };
 


