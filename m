Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50098 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbaLFVfN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 16:35:13 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 06/22] si2168: rename few things
Date: Sat,  6 Dec 2014 23:34:40 +0200
Message-Id: <1417901696-5517-6-git-send-email-crope@iki.fi>
In-Reply-To: <1417901696-5517-1-git-send-email-crope@iki.fi>
References: <1417901696-5517-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename some goto labels and more. No functionality changes.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 38 ++++++++++++------------------------
 drivers/media/dvb-frontends/si2168.h |  6 ++----
 2 files changed, 14 insertions(+), 30 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 2df3a27..a9486ef 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -115,17 +115,6 @@ static int si2168_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	if (ret)
 		goto err;
 
-	/*
-	 * Possible values seen, in order from strong signal to weak:
-	 * 16 0001 0110 full lock
-	 * 1e 0001 1110 partial lock
-	 * 1a 0001 1010 partial lock
-	 * 18 0001 1000 no lock
-	 *
-	 * [b3:b1] lock bits
-	 * [b4] statistics ready? Set in a few secs after lock is gained.
-	 */
-
 	switch ((cmd.args[2] >> 1) & 0x03) {
 	case 0x01:
 		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER;
@@ -291,7 +280,7 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	/* set DVB-C symbol rate */
 	if (c->delivery_system == SYS_DVBC_ANNEX_A) {
 		memcpy(cmd.args, "\x14\x00\x02\x11", 4);
-		cmd.args[4] = (c->symbol_rate / 1000) & 0xff;
+		cmd.args[4] = ((c->symbol_rate / 1000) >> 0) & 0xff;
 		cmd.args[5] = ((c->symbol_rate / 1000) >> 8) & 0xff;
 		cmd.wlen = 6;
 		cmd.rlen = 4;
@@ -455,7 +444,7 @@ static int si2168_init(struct dvb_frontend *fe)
 			dev_err(&client->dev,
 					"firmware file '%s' not found\n",
 					fw_file);
-			goto error_fw_release;
+			goto err_release_firmware;
 		}
 	}
 
@@ -474,7 +463,7 @@ static int si2168_init(struct dvb_frontend *fe)
 				dev_err(&client->dev,
 						"firmware download failed=%d\n",
 						ret);
-				goto error_fw_release;
+				goto err_release_firmware;
 			}
 		}
 	} else {
@@ -492,7 +481,7 @@ static int si2168_init(struct dvb_frontend *fe)
 				dev_err(&client->dev,
 						"firmware download failed=%d\n",
 						ret);
-				goto error_fw_release;
+				goto err_release_firmware;
 			}
 		}
 	}
@@ -535,8 +524,7 @@ warm:
 	dev->active = true;
 
 	return 0;
-
-error_fw_release:
+err_release_firmware:
 	release_firmware(fw);
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
@@ -684,7 +672,7 @@ static int si2168_probe(struct i2c_client *client,
 	if (!dev) {
 		ret = -ENOMEM;
 		dev_err(&client->dev, "kzalloc() failed\n");
-		goto err;
+		goto err_kfree;
 	}
 
 	mutex_init(&dev->i2c_mutex);
@@ -694,13 +682,12 @@ static int si2168_probe(struct i2c_client *client,
 			client, 0, 0, 0, si2168_select, si2168_deselect);
 	if (dev->adapter == NULL) {
 		ret = -ENODEV;
-		goto err;
+		goto err_kfree;
 	}
 
 	/* create dvb_frontend */
 	memcpy(&dev->fe.ops, &si2168_ops, sizeof(struct dvb_frontend_ops));
 	dev->fe.demodulator_priv = client;
-
 	*config->i2c_adapter = dev->adapter;
 	*config->fe = &dev->fe;
 	dev->ts_mode = config->ts_mode;
@@ -709,10 +696,9 @@ static int si2168_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, dev);
 
-	dev_info(&client->dev,
-			"Silicon Labs Si2168 successfully attached\n");
+	dev_info(&client->dev, "Silicon Labs Si2168 successfully attached\n");
 	return 0;
-err:
+err_kfree:
 	kfree(dev);
 	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
@@ -734,11 +720,11 @@ static int si2168_remove(struct i2c_client *client)
 	return 0;
 }
 
-static const struct i2c_device_id si2168_id[] = {
+static const struct i2c_device_id si2168_id_table[] = {
 	{"si2168", 0},
 	{}
 };
-MODULE_DEVICE_TABLE(i2c, si2168_id);
+MODULE_DEVICE_TABLE(i2c, si2168_id_table);
 
 static struct i2c_driver si2168_driver = {
 	.driver = {
@@ -747,7 +733,7 @@ static struct i2c_driver si2168_driver = {
 	},
 	.probe		= si2168_probe,
 	.remove		= si2168_remove,
-	.id_table	= si2168_id,
+	.id_table	= si2168_id_table,
 };
 
 module_i2c_driver(si2168_driver);
diff --git a/drivers/media/dvb-frontends/si2168.h b/drivers/media/dvb-frontends/si2168.h
index 87bc121..70d702a 100644
--- a/drivers/media/dvb-frontends/si2168.h
+++ b/drivers/media/dvb-frontends/si2168.h
@@ -36,14 +36,12 @@ struct si2168_config {
 	struct i2c_adapter **i2c_adapter;
 
 	/* TS mode */
+#define SI2168_TS_PARALLEL	0x06
+#define SI2168_TS_SERIAL	0x03
 	u8 ts_mode;
 
 	/* TS clock inverted */
 	bool ts_clock_inv;
-
 };
 
-#define SI2168_TS_PARALLEL	0x06
-#define SI2168_TS_SERIAL	0x03
-
 #endif
-- 
http://palosaari.fi/

