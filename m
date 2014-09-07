Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49442 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193AbaIGOat (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Sep 2014 10:30:49 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] si2157: implement strength stats
Date: Sun,  7 Sep 2014 17:30:32 +0300
Message-Id: <1410100232-26325-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement DVBv5 signal strength stats. Returns dBm.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/si2157.c      | 34 ++++++++++++++++++++++++++++++++++
 drivers/media/tuners/si2157_priv.h |  1 +
 2 files changed, 35 insertions(+)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index efb5cce..1626401 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -86,6 +86,7 @@ static int si2157_init(struct dvb_frontend *fe)
 	const struct firmware *fw = NULL;
 	u8 *fw_file;
 	unsigned int chip_id;
+	struct dtv_frontend_properties *c = &s->fe->dtv_property_cache;
 
 	dev_dbg(&s->client->dev, "\n");
 
@@ -176,6 +177,11 @@ skip_fw_download:
 	if (ret)
 		goto err;
 
+	/* init statistics in order signal app which are supported */
+	c->strength.len = 1;
+	c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	/* start statistics polling */
+	schedule_delayed_work(&s->stat_work, msecs_to_jiffies(1000));
 	s->active = true;
 
 	return 0;
@@ -196,6 +202,8 @@ static int si2157_sleep(struct dvb_frontend *fe)
 	dev_dbg(&s->client->dev, "\n");
 
 	s->active = false;
+	/* stop statistics polling */
+	cancel_delayed_work_sync(&s->stat_work);
 
 	memcpy(cmd.args, "\x13", 1);
 	cmd.wlen = 1;
@@ -287,6 +295,31 @@ static int si2157_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
+static void si2157_stat_work(struct work_struct *work)
+{
+	struct si2157 *s = container_of(work, struct si2157, stat_work.work);
+	struct dtv_frontend_properties *c = &s->fe->dtv_property_cache;
+	struct si2157_cmd cmd;
+	int ret;
+
+	dev_dbg(&s->client->dev, "\n");
+
+	memcpy(cmd.args, "\x42\x00", 2);
+	cmd.wlen = 2;
+	cmd.rlen = 12;
+	ret = si2157_cmd_execute(s, &cmd);
+	if (ret)
+		goto err;
+
+	c->strength.stat[0].scale = FE_SCALE_DECIBEL;
+	c->strength.stat[0].svalue = (char) cmd.args[3] * 1000;
+
+	schedule_delayed_work(&s->stat_work, msecs_to_jiffies(2000));
+	return;
+err:
+	dev_dbg(&s->client->dev, "failed=%d\n", ret);
+}
+
 static const struct dvb_tuner_ops si2157_ops = {
 	.info = {
 		.name           = "Silicon Labs Si2157/Si2158",
@@ -320,6 +353,7 @@ static int si2157_probe(struct i2c_client *client,
 	s->fe = cfg->fe;
 	s->inversion = cfg->inversion;
 	mutex_init(&s->i2c_mutex);
+	INIT_DELAYED_WORK(&s->stat_work, si2157_stat_work);
 
 	/* check if the tuner is there */
 	cmd.wlen = 0;
diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
index 3ddab5e..83fc7e3 100644
--- a/drivers/media/tuners/si2157_priv.h
+++ b/drivers/media/tuners/si2157_priv.h
@@ -27,6 +27,7 @@ struct si2157 {
 	struct dvb_frontend *fe;
 	bool active;
 	bool inversion;
+	struct delayed_work stat_work;
 };
 
 /* firmare command struct */
-- 
http://palosaari.fi/

