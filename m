Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:54519 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbaBINDD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Feb 2014 08:03:03 -0500
Received: by mail-we0-f169.google.com with SMTP id t61so3542526wes.14
        for <linux-media@vger.kernel.org>; Sun, 09 Feb 2014 05:03:01 -0800 (PST)
Message-ID: <1391950969.13992.14.camel@canaries32-MCP7A>
Subject: [PATCH 1/2] af9035: add default 0x9135 slave I2C address
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Date: Sun, 09 Feb 2014 13:02:49 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On some devices the vendor has not set EEPROM_2ND_DEMOD_ADDR.

Checks tmp is not zero after call to get EEPROM_2ND_DEMOD_ADDR and sets the
default slave address of 0x3a on 0x9135 devices.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
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
1.9.rc1

