Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33273 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751976AbdFODbf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 23:31:35 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 10/15] af9015: enable 2nd TS flow control when dual mode
Date: Thu, 15 Jun 2017 06:31:00 +0300
Message-Id: <20170615033105.13517-10-crope@iki.fi>
In-Reply-To: <20170615033105.13517-1-crope@iki.fi>
References: <20170615033105.13517-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It needs to be enabled in order to get stream from slave af9013 demod.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9015.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index 54c1d47..ee0e354 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -1131,10 +1131,21 @@ static int af9015_init_endpoint(struct dvb_usb_device *d)
 	}
 
 	/* enable / disable mp2if2 */
-	if (state->dual_mode)
+	if (state->dual_mode) {
 		ret = af9015_set_reg_bit(d, 0xd50b, 0);
-	else
+		if (ret)
+			goto error;
+		ret = af9015_set_reg_bit(d, 0xd520, 4);
+		if (ret)
+			goto error;
+	} else {
 		ret = af9015_clear_reg_bit(d, 0xd50b, 0);
+		if (ret)
+			goto error;
+		ret = af9015_clear_reg_bit(d, 0xd520, 4);
+		if (ret)
+			goto error;
+	}
 
 error:
 	if (ret)
-- 
http://palosaari.fi/
