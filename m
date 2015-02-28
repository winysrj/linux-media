Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:39259 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbbB1PZl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Feb 2015 10:25:41 -0500
Received: by lbvn10 with SMTP id n10so22491556lbv.6
        for <linux-media@vger.kernel.org>; Sat, 28 Feb 2015 07:25:40 -0800 (PST)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 1/2] si2157: IF frequency for ATSC and QAM
Date: Sat, 28 Feb 2015 17:25:23 +0200
Message-Id: <1425137124-17324-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For supporting ATSC and QAM modes the driver should use a smaller IF frequency than 5 MHz.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/tuners/si2157.c      | 23 ++++++++++++++++++++++-
 drivers/media/tuners/si2157_priv.h |  1 +
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index fcf139d..d8309b9 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -244,6 +244,7 @@ static int si2157_set_params(struct dvb_frontend *fe)
 	int ret;
 	struct si2157_cmd cmd;
 	u8 bandwidth, delivery_system;
+	u32 if_frequency = 5000000;
 
 	dev_dbg(&client->dev,
 			"delivery_system=%d frequency=%u bandwidth_hz=%u\n",
@@ -266,9 +267,11 @@ static int si2157_set_params(struct dvb_frontend *fe)
 	switch (c->delivery_system) {
 	case SYS_ATSC:
 			delivery_system = 0x00;
+			if_frequency = 3250000;
 			break;
 	case SYS_DVBC_ANNEX_B:
 			delivery_system = 0x10;
+			if_frequency = 4000000;
 			break;
 	case SYS_DVBT:
 	case SYS_DVBT2: /* it seems DVB-T and DVB-T2 both are 0x20 here */
@@ -302,6 +305,20 @@ static int si2157_set_params(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
+	/* set if frequency if needed */
+	if (if_frequency != dev->if_frequency) {
+		memcpy(cmd.args, "\x14\x00\x06\x07", 4);
+		cmd.args[4] = (if_frequency / 1000) & 0xff;
+		cmd.args[5] = ((if_frequency / 1000) >> 8) & 0xff;
+		cmd.wlen = 6;
+		cmd.rlen = 4;
+		ret = si2157_cmd_execute(client, &cmd);
+		if (ret)
+			goto err;
+
+		dev->if_frequency = if_frequency;
+	}
+
 	/* set frequency */
 	memcpy(cmd.args, "\x41\x00\x00\x00\x00\x00\x00\x00", 8);
 	cmd.args[4] = (c->frequency >>  0) & 0xff;
@@ -322,7 +339,10 @@ err:
 
 static int si2157_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
-	*frequency = 5000000; /* default value of property 0x0706 */
+	struct i2c_client *client = fe->tuner_priv;
+	struct si2157_dev *dev = i2c_get_clientdata(client);
+
+	*frequency = dev->if_frequency;
 	return 0;
 }
 
@@ -360,6 +380,7 @@ static int si2157_probe(struct i2c_client *client,
 	dev->inversion = cfg->inversion;
 	dev->fw_loaded = false;
 	dev->chiptype = (u8)id->driver_data;
+	dev->if_frequency = 5000000; /* default value of property 0x0706 */
 	mutex_init(&dev->i2c_mutex);
 
 	/* check if the tuner is there */
diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
index 7aa53bc..cd8fa5b 100644
--- a/drivers/media/tuners/si2157_priv.h
+++ b/drivers/media/tuners/si2157_priv.h
@@ -28,6 +28,7 @@ struct si2157_dev {
 	bool fw_loaded;
 	bool inversion;
 	u8 chiptype;
+	u32 if_frequency;
 };
 
 #define SI2157_CHIPTYPE_SI2157 0
-- 
1.9.1

