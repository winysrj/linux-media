Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45602 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751363AbdA0UzI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jan 2017 15:55:08 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH v3 7/7] mt2060: implement sleep
Date: Fri, 27 Jan 2017 22:54:44 +0200
Message-Id: <20170127205444.3242-7-crope@iki.fi>
In-Reply-To: <20170127205444.3242-1-crope@iki.fi>
References: <20170127205444.3242-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I saw from ZyDAS ZD1301 sniffs it sets chip sleeping by using
REG_MISC_CTRL. That has very huge effect for power management, around
0.9W. Sleep is still disabled for all the old hardware just to avoid
possible regression as meaning of register bits are unknown.

I tested it also with some other devices and it seems to be working,
but I still consider it to be too risky to change it default.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/mt2060.c      | 25 +++++++++++++++++++++++--
 drivers/media/tuners/mt2060_priv.h |  8 ++++++++
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/mt2060.c b/drivers/media/tuners/mt2060.c
index 9775ded..6d404d5 100644
--- a/drivers/media/tuners/mt2060.c
+++ b/drivers/media/tuners/mt2060.c
@@ -317,9 +317,16 @@ static int mt2060_init(struct dvb_frontend *fe)
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1); /* open i2c_gate */
 
+	if (priv->sleep) {
+		ret = mt2060_writereg(priv, REG_MISC_CTRL, 0x20);
+		if (ret)
+			goto err_i2c_gate_ctrl;
+	}
+
 	ret = mt2060_writereg(priv, REG_VGAG,
 			      (priv->cfg->clock_out << 6) | 0x33);
 
+err_i2c_gate_ctrl:
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0); /* close i2c_gate */
 
@@ -336,7 +343,13 @@ static int mt2060_sleep(struct dvb_frontend *fe)
 
 	ret = mt2060_writereg(priv, REG_VGAG,
 			      (priv->cfg->clock_out << 6) | 0x30);
+	if (ret)
+		goto err_i2c_gate_ctrl;
+
+	if (priv->sleep)
+		ret = mt2060_writereg(priv, REG_MISC_CTRL, 0xe8);
 
+err_i2c_gate_ctrl:
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0); /* close i2c_gate */
 
@@ -439,6 +452,7 @@ static int mt2060_probe(struct i2c_client *client,
 	dev->if1_freq = pdata->if1 ? pdata->if1 : 1220;
 	dev->client = client;
 	dev->i2c_max_regs = pdata->i2c_write_max ? pdata->i2c_write_max - 1 : ~0;
+	dev->sleep = true;
 
 	ret = mt2060_readreg(dev, REG_PART_REV, &chip_id);
 	if (ret) {
@@ -453,14 +467,21 @@ static int mt2060_probe(struct i2c_client *client,
 		goto err;
 	}
 
+	/* Power on, calibrate, sleep */
+	ret = mt2060_writereg(dev, REG_MISC_CTRL, 0x20);
+	if (ret)
+		goto err;
+	mt2060_calibrate(dev);
+	ret = mt2060_writereg(dev, REG_MISC_CTRL, 0xe8);
+	if (ret)
+		goto err;
+
 	dev_info(&client->dev, "Microtune MT2060 successfully identified\n");
 	memcpy(&fe->ops.tuner_ops, &mt2060_tuner_ops, sizeof(fe->ops.tuner_ops));
 	fe->ops.tuner_ops.release = NULL;
 	fe->tuner_priv = dev;
 	i2c_set_clientdata(client, dev);
 
-	mt2060_calibrate(dev);
-
 	return 0;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
diff --git a/drivers/media/tuners/mt2060_priv.h b/drivers/media/tuners/mt2060_priv.h
index f0fdb83..c0dac80 100644
--- a/drivers/media/tuners/mt2060_priv.h
+++ b/drivers/media/tuners/mt2060_priv.h
@@ -102,6 +102,14 @@ struct mt2060_priv {
 	u32 frequency;
 	u16 if1_freq;
 	u8  fmfreq;
+
+	/*
+	 * Use REG_MISC_CTRL register for sleep. That drops sleep power usage
+	 * about 0.9W (huge!). Register bit meanings are unknown, so let it be
+	 * disabled by default to avoid possible regression. Convert driver to
+	 * i2c model in order to enable it.
+	 */
+	bool sleep;
 };
 
 #endif
-- 
http://palosaari.fi/

