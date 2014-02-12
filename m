Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34926 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbaBLTqc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Feb 2014 14:46:32 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 2/4] af9035: add default 0x9135 slave I2C address
Date: Wed, 12 Feb 2014 21:46:16 +0200
Message-Id: <1392234378-20959-2-git-send-email-crope@iki.fi>
In-Reply-To: <1392234378-20959-1-git-send-email-crope@iki.fi>
References: <1392234378-20959-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Malcolm Priestley <tvboxspy@gmail.com>

On some devices the vendor has not set EEPROM_2ND_DEMOD_ADDR.

Checks tmp is not zero after call to get EEPROM_2ND_DEMOD_ADDR and sets the
default slave address of 0x3a on 0x9135 devices.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 3825c2f..4f682ad 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -576,6 +576,10 @@ static int af9035_download_firmware(struct dvb_usb_device *d,
 			goto err;
 
 		if (state->chip_type == 0x9135) {
+			if (!tmp)
+				/* default 0x9135 slave I2C address */
+				tmp = 0x3a;
+
 			ret = af9035_wr_reg(d, 0x004bfb, tmp);
 			if (ret < 0)
 				goto err;
@@ -684,6 +688,10 @@ static int af9035_read_config(struct dvb_usb_device *d)
 		if (ret < 0)
 			goto err;
 
+		if (!tmp && state->chip_type == 0x9135)
+			/* default 0x9135 slave I2C address */
+			tmp = 0x3a;
+
 		state->af9033_config[1].i2c_addr = tmp;
 		dev_dbg(&d->udev->dev, "%s: 2nd demod I2C addr=%02x\n",
 				__func__, tmp);
-- 
1.8.5.3

