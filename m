Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46798 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938971AbcJGRYr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2016 13:24:47 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Johannes Stezenbach <js@linuxtv.org>,
        Jiri Kosina <jikos@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?q?J=C3=B6rg=20Otte?= <jrg.otte@gmail.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 22/26] technisat-usb2: use DMA buffers for I2C transfers
Date: Fri,  7 Oct 2016 14:24:32 -0300
Message-Id: <2792fc0fbd2bb0366c6967c60184c93fecc828c3.1475860773.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1475860773.git.mchehab@s-opensource.com>
References: <cover.1475860773.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1475860773.git.mchehab@s-opensource.com>
References: <cover.1475860773.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The USB control messages require DMA to work. We cannot pass
a stack-allocated buffer, as it is not warranted that the
stack would be into a DMA enabled area.

On this driver, most of the transfers are OK, but the I2C
one was using stack.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb/technisat-usb2.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/technisat-usb2.c b/drivers/media/usb/dvb-usb/technisat-usb2.c
index d9f3262bf071..4706628a3ed5 100644
--- a/drivers/media/usb/dvb-usb/technisat-usb2.c
+++ b/drivers/media/usb/dvb-usb/technisat-usb2.c
@@ -89,9 +89,13 @@ struct technisat_usb2_state {
 static int technisat_usb2_i2c_access(struct usb_device *udev,
 		u8 device_addr, u8 *tx, u8 txlen, u8 *rx, u8 rxlen)
 {
-	u8 b[64];
+	u8 *b;
 	int ret, actual_length;
 
+	b = kmalloc(64, GFP_KERNEL);
+	if (!b)
+		return -ENOMEM;
+
 	deb_i2c("i2c-access: %02x, tx: ", device_addr);
 	debug_dump(tx, txlen, deb_i2c);
 	deb_i2c(" ");
@@ -123,7 +127,7 @@ static int technisat_usb2_i2c_access(struct usb_device *udev,
 
 	if (ret < 0) {
 		err("i2c-error: out failed %02x = %d", device_addr, ret);
-		return -ENODEV;
+		goto err;
 	}
 
 	ret = usb_bulk_msg(udev,
@@ -131,7 +135,7 @@ static int technisat_usb2_i2c_access(struct usb_device *udev,
 			b, 64, &actual_length, 1000);
 	if (ret < 0) {
 		err("i2c-error: in failed %02x = %d", device_addr, ret);
-		return -ENODEV;
+		goto err;
 	}
 
 	if (b[0] != I2C_STATUS_OK) {
@@ -140,7 +144,7 @@ static int technisat_usb2_i2c_access(struct usb_device *udev,
 		if (!(b[0] == I2C_STATUS_NAK &&
 				device_addr == 0x60
 				/* && device_is_technisat_usb2 */))
-			return -ENODEV;
+			goto err;
 	}
 
 	deb_i2c("status: %d, ", b[0]);
@@ -154,7 +158,9 @@ static int technisat_usb2_i2c_access(struct usb_device *udev,
 
 	deb_i2c("\n");
 
-	return 0;
+err:
+	kfree(b);
+	return ret;
 }
 
 static int technisat_usb2_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msg,
-- 
2.7.4


