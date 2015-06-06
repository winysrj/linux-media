Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60487 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbbFFLUC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2015 07:20:02 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] tda10071: add missing error status when probe() fails
Date: Sat,  6 Jun 2015 14:19:38 +0300
Message-Id: <1433589579-20611-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We must return -ENODEV error on case probe() fails to detect chip.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/tda10071.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index 3132854..1470a5d 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -1348,18 +1348,30 @@ static int tda10071_probe(struct i2c_client *client,
 
 	/* chip ID */
 	ret = tda10071_rd_reg(dev, 0xff, &u8tmp);
-	if (ret || u8tmp != 0x0f)
+	if (ret)
+		goto err_kfree;
+	if (u8tmp != 0x0f) {
+		ret = -ENODEV;
 		goto err_kfree;
+	}
 
 	/* chip type */
 	ret = tda10071_rd_reg(dev, 0xdd, &u8tmp);
-	if (ret || u8tmp != 0x00)
+	if (ret)
+		goto err_kfree;
+	if (u8tmp != 0x00) {
+		ret = -ENODEV;
 		goto err_kfree;
+	}
 
 	/* chip version */
 	ret = tda10071_rd_reg(dev, 0xfe, &u8tmp);
-	if (ret || u8tmp != 0x01)
+	if (ret)
 		goto err_kfree;
+	if (u8tmp != 0x01) {
+		ret = -ENODEV;
+		goto err_kfree;
+	}
 
 	/* create dvb_frontend */
 	memcpy(&dev->fe.ops, &tda10071_ops, sizeof(struct dvb_frontend_ops));
-- 
http://palosaari.fi/

