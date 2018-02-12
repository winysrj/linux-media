Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:47764 "EHLO
        homiemail-a116.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753916AbeBLUUN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 15:20:13 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2 4/7] si2168: Add ts bus control, turn off bus on sleep
Date: Mon, 12 Feb 2018 14:19:04 -0600
Message-Id: <1518466744-18675-1-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1515773982-6411-5-git-send-email-brad@nextdimension.cc>
References: <1515773982-6411-5-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Includes a function to set TS MODE property os si2168. The function
either disables the TS output bus, or sets mode to config option.

After setting up the frontend the TS bus is enabled. When going
to sleep the TS bus is tri-stated, this makes the driver
compatible with multiple frontend usage.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
Changes since v1:
- fix spelling error in subject line
- ts bus control function moved higher
- enable ts bus after configuring frontend
- remove ts_bus_ctrl callback
- added error checking
- re-add a comment

 drivers/media/dvb-frontends/si2168.c | 42 ++++++++++++++++++++++++++++++------
 drivers/media/dvb-frontends/si2168.h |  1 +
 2 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 25984d3..66ecab3 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -82,6 +82,30 @@ static int si2168_cmd_execute(struct i2c_client *client, struct si2168_cmd *cmd)
 	return ret;
 }
 
+static int si2168_ts_bus_ctrl(struct dvb_frontend *fe, int acquire)
+{
+	struct i2c_client *client = fe->demodulator_priv;
+	struct si2168_dev *dev = i2c_get_clientdata(client);
+	struct si2168_cmd cmd;
+	int ret = 0;
+
+	dev_dbg(&client->dev, "%s acquire: %d\n", __func__, acquire);
+
+	/* set TS_MODE property */
+	memcpy(cmd.args, "\x14\x00\x01\x10\x10\x00", 6);
+	if (acquire)
+		cmd.args[4] |= dev->ts_mode;
+	else
+		cmd.args[4] |= SI2168_TS_TRISTATE;
+	if (dev->ts_clock_gapped)
+		cmd.args[4] |= 0x40;
+	cmd.wlen = 6;
+	cmd.rlen = 4;
+	ret = si2168_cmd_execute(client, &cmd);
+
+	return ret;
+}
+
 static int si2168_read_status(struct dvb_frontend *fe, enum fe_status *status)
 {
 	struct i2c_client *client = fe->demodulator_priv;
@@ -405,6 +429,11 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 
 	dev->delivery_system = c->delivery_system;
 
+	/* enable ts bus */
+	ret = si2168_ts_bus_ctrl(fe, 1);
+	if (ret)
+		goto err;
+
 	return 0;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
@@ -543,13 +572,7 @@ static int si2168_init(struct dvb_frontend *fe)
 		 dev->version >> 8 & 0xff, dev->version >> 0 & 0xff);
 
 	/* set ts mode */
-	memcpy(cmd.args, "\x14\x00\x01\x10\x10\x00", 6);
-	cmd.args[4] |= dev->ts_mode;
-	if (dev->ts_clock_gapped)
-		cmd.args[4] |= 0x40;
-	cmd.wlen = 6;
-	cmd.rlen = 4;
-	ret = si2168_cmd_execute(client, &cmd);
+	ret = si2168_ts_bus_ctrl(fe, 1);
 	if (ret)
 		goto err;
 
@@ -586,6 +609,11 @@ static int si2168_sleep(struct dvb_frontend *fe)
 
 	dev->active = false;
 
+	/* tri-state data bus */
+	ret = si2168_ts_bus_ctrl(fe, 0);
+	if (ret)
+		goto err;
+
 	/* Firmware B 4.0-11 or later loses warm state during sleep */
 	if (dev->version > ('B' << 24 | 4 << 16 | 0 << 8 | 11 << 0))
 		dev->warm = false;
diff --git a/drivers/media/dvb-frontends/si2168.h b/drivers/media/dvb-frontends/si2168.h
index 5104d9f..d519edd 100644
--- a/drivers/media/dvb-frontends/si2168.h
+++ b/drivers/media/dvb-frontends/si2168.h
@@ -38,6 +38,7 @@ struct si2168_config {
 	/* TS mode */
 #define SI2168_TS_PARALLEL	0x06
 #define SI2168_TS_SERIAL	0x03
+#define SI2168_TS_TRISTATE	0x00
 	u8 ts_mode;
 
 	/* TS clock inverted */
-- 
2.7.4
