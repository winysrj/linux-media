Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44796 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752072AbdFODbg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 23:31:36 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 13/15] af9015: move 2nd demod power-up wait different location
Date: Thu, 15 Jun 2017 06:31:03 +0300
Message-Id: <20170615033105.13517-13-crope@iki.fi>
In-Reply-To: <20170615033105.13517-1-crope@iki.fi>
References: <20170615033105.13517-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need to wait 2nd demod power-up before download firmware. Move
that wait to more correct location.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9015.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index ee0e354..53d478d 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -740,9 +740,6 @@ static int af9015_copy_firmware(struct dvb_usb_device *d)
 	fw_params[2] = state->firmware_checksum >> 8;
 	fw_params[3] = state->firmware_checksum & 0xff;
 
-	/* wait 2nd demodulator ready */
-	msleep(100);
-
 	ret = af9015_read_reg_i2c(d, state->af9013_config[1].i2c_addr,
 			0x98be, &val);
 	if (ret)
@@ -830,6 +827,9 @@ static int af9015_af9013_frontend_attach(struct dvb_usb_adapter *adap)
 
 		/* copy firmware to 2nd demodulator */
 		if (state->dual_mode) {
+			/* Wait 2nd demodulator ready */
+			msleep(100);
+
 			ret = af9015_copy_firmware(adap_to_d(adap));
 			if (ret) {
 				dev_err(&adap_to_d(adap)->udev->dev,
-- 
http://palosaari.fi/
