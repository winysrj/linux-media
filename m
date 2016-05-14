Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52838 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbcENFO5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 May 2016 01:14:57 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/3] rtl28xxu: increase failed I2C msg repeat count to 2
Date: Sat, 14 May 2016 08:14:34 +0300
Message-Id: <1463202876-18381-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

1 wasn't enough for mn88472 chip on Astrometa device, so increase
it by one.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index fa72642..6965d8e 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -624,7 +624,7 @@ static int rtl28xxu_identify_state(struct dvb_usb_device *d, const char **name)
 	dev_dbg(&d->intf->dev, "chip_id=%u\n", dev->chip_id);
 
 	/* Retry failed I2C messages */
-	d->i2c_adap.retries = 1;
+	d->i2c_adap.retries = 2;
 	d->i2c_adap.timeout = msecs_to_jiffies(10);
 
 	return WARM;
-- 
http://palosaari.fi/

