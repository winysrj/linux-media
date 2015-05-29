Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56874 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756828AbbE2VFc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 May 2015 17:05:32 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Adam Baker <linux@baker-net.org.uk>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] si2157: implement signal strength stats
Date: Sat, 30 May 2015 00:05:10 +0300
Message-Id: <1432933510-19028-2-git-send-email-crope@iki.fi>
In-Reply-To: <1432933510-19028-1-git-send-email-crope@iki.fi>
References: <1432933510-19028-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement DVBv5 signal strength stats. Returns dBm.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/si2157.c      | 39 +++++++++++++++++++++++++++++++++++++-
 drivers/media/tuners/si2157_priv.h |  1 +
 2 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index cdaf687..fad2ec9 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -79,6 +79,7 @@ static int si2157_init(struct dvb_frontend *fe)
 {
 	struct i2c_client *client = fe->tuner_priv;
 	struct si2157_dev *dev = i2c_get_clientdata(client);
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, len, remaining;
 	struct si2157_cmd cmd;
 	const struct firmware *fw;
@@ -201,9 +202,14 @@ skip_fw_download:
 	dev->fw_loaded = true;
 
 warm:
+	/* init statistics in order signal app which are supported */
+	c->strength.len = 1;
+	c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	/* start statistics polling */
+	schedule_delayed_work(&dev->stat_work, msecs_to_jiffies(1000));
+
 	dev->active = true;
 	return 0;
-
 err_release_firmware:
 	release_firmware(fw);
 err:
@@ -222,6 +228,9 @@ static int si2157_sleep(struct dvb_frontend *fe)
 
 	dev->active = false;
 
+	/* stop statistics polling */
+	cancel_delayed_work_sync(&dev->stat_work);
+
 	/* standby */
 	memcpy(cmd.args, "\x16\x00", 2);
 	cmd.wlen = 2;
@@ -360,6 +369,33 @@ static const struct dvb_tuner_ops si2157_ops = {
 	.get_if_frequency = si2157_get_if_frequency,
 };
 
+static void si2157_stat_work(struct work_struct *work)
+{
+	struct si2157_dev *dev = container_of(work, struct si2157_dev, stat_work.work);
+	struct dvb_frontend *fe = dev->fe;
+	struct i2c_client *client = fe->tuner_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	struct si2157_cmd cmd;
+	int ret;
+
+	dev_dbg(&client->dev, "\n");
+
+	memcpy(cmd.args, "\x42\x00", 2);
+	cmd.wlen = 2;
+	cmd.rlen = 12;
+	ret = si2157_cmd_execute(client, &cmd);
+	if (ret)
+		goto err;
+
+	c->strength.stat[0].scale = FE_SCALE_DECIBEL;
+	c->strength.stat[0].svalue = (s8) cmd.args[3] * 1000;
+
+	schedule_delayed_work(&dev->stat_work, msecs_to_jiffies(2000));
+	return;
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+}
+
 static int si2157_probe(struct i2c_client *client,
 		const struct i2c_device_id *id)
 {
@@ -384,6 +420,7 @@ static int si2157_probe(struct i2c_client *client,
 	dev->chiptype = (u8)id->driver_data;
 	dev->if_frequency = 5000000; /* default value of property 0x0706 */
 	mutex_init(&dev->i2c_mutex);
+	INIT_DELAYED_WORK(&dev->stat_work, si2157_stat_work);
 
 	/* check if the tuner is there */
 	cmd.wlen = 0;
diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
index 71a5f8c..ecc463d 100644
--- a/drivers/media/tuners/si2157_priv.h
+++ b/drivers/media/tuners/si2157_priv.h
@@ -30,6 +30,7 @@ struct si2157_dev {
 	u8 chiptype;
 	u8 if_port;
 	u32 if_frequency;
+	struct delayed_work stat_work;
 };
 
 #define SI2157_CHIPTYPE_SI2157 0
-- 
http://palosaari.fi/

