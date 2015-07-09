Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57781 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbbGIEGz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jul 2015 00:06:55 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 04/12] a8293: improve LNB register programming logic
Date: Thu,  9 Jul 2015 07:06:24 +0300
Message-Id: <1436414792-9716-4-git-send-email-crope@iki.fi>
In-Reply-To: <1436414792-9716-1-git-send-email-crope@iki.fi>
References: <1436414792-9716-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On power-on LNB power supply voltage is disabled, due to that no
need to disable it during probe. Tone is supply is hard-coded as
external tone coming from the demodulator. Program both voltage
and tone on set_voltage(). Use register cache to prevent unneeded
programming.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/a8293.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/media/dvb-frontends/a8293.c b/drivers/media/dvb-frontends/a8293.c
index d99ea4d..ef2b47c 100644
--- a/drivers/media/dvb-frontends/a8293.c
+++ b/drivers/media/dvb-frontends/a8293.c
@@ -31,30 +31,42 @@ static int a8293_set_voltage(struct dvb_frontend *fe,
 	struct a8293_dev *dev = fe->sec_priv;
 	struct i2c_client *client = dev->client;
 	int ret;
+	u8 reg0, reg1;
 
 	dev_dbg(&client->dev, "fe_sec_voltage=%d\n", fe_sec_voltage);
 
 	switch (fe_sec_voltage) {
 	case SEC_VOLTAGE_OFF:
 		/* ENB=0 */
-		dev->reg[0] = 0x10;
+		reg0 = 0x10;
 		break;
 	case SEC_VOLTAGE_13:
 		/* VSEL0=1, VSEL1=0, VSEL2=0, VSEL3=0, ENB=1*/
-		dev->reg[0] = 0x31;
+		reg0 = 0x31;
 		break;
 	case SEC_VOLTAGE_18:
 		/* VSEL0=0, VSEL1=0, VSEL2=0, VSEL3=1, ENB=1*/
-		dev->reg[0] = 0x38;
+		reg0 = 0x38;
 		break;
 	default:
 		ret = -EINVAL;
 		goto err;
 	}
+	if (reg0 != dev->reg[0]) {
+		ret = i2c_master_send(client, &reg0, 1);
+		if (ret < 0)
+			goto err;
+		dev->reg[0] = reg0;
+	}
 
-	ret = i2c_master_send(client, &dev->reg[0], 1);
-	if (ret < 0)
-		goto err;
+	/* TMODE=0, TGATE=1 */
+	reg1 = 0x82;
+	if (reg1 != dev->reg[1]) {
+		ret = i2c_master_send(client, &reg1, 1);
+		if (ret < 0)
+			goto err;
+		dev->reg[1] = reg1;
+	}
 
 	usleep_range(1500, 50000);
 	return 0;
@@ -85,18 +97,6 @@ static int a8293_probe(struct i2c_client *client,
 	if (ret < 0)
 		goto err_kfree;
 
-	/* ENB=0 */
-	dev->reg[0] = 0x10;
-	ret = i2c_master_send(client, &dev->reg[0], 1);
-	if (ret < 0)
-		goto err_kfree;
-
-	/* TMODE=0, TGATE=1 */
-	dev->reg[1] = 0x82;
-	ret = i2c_master_send(client, &dev->reg[1], 1);
-	if (ret < 0)
-		goto err_kfree;
-
 	/* override frontend ops */
 	fe->ops.set_voltage = a8293_set_voltage;
 	fe->sec_priv = dev;
-- 
http://palosaari.fi/

