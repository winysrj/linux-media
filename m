Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35224 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbcBHLvl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2016 06:51:41 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Russel Winder <russel@winder.org.uk>,
	Rune Petersen <rune@megahurts.dk>,
	Olli Salonen <olli.salonen@iki.fi>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH] si2157: detect if firmware is running
Date: Mon,  8 Feb 2016 13:51:16 +0200
Message-Id: <1454932276-15780-2-git-send-email-crope@iki.fi>
In-Reply-To: <1454932276-15780-1-git-send-email-crope@iki.fi>
References: <1454932276-15780-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Detect if firmware is running run-time and download / start it only
when needed. Detection is done by reading IF frequency value.
Garbage value is returned by firmware when it is not running,
otherwise correct value is returned.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/si2157.c      | 19 +++++++++++++------
 drivers/media/tuners/si2157_priv.h |  1 -
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 3450dfb..8cd2bb3 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -84,11 +84,22 @@ static int si2157_init(struct dvb_frontend *fe)
 	struct si2157_cmd cmd;
 	const struct firmware *fw;
 	const char *fw_name;
-	unsigned int chip_id;
+	unsigned int uitmp, chip_id;
 
 	dev_dbg(&client->dev, "\n");
 
-	if (dev->fw_loaded)
+	/* Returned IF frequency is garbage when firmware is not running */
+	memcpy(cmd.args, "\x15\x00\x06\x07", 4);
+	cmd.wlen = 4;
+	cmd.rlen = 4;
+	ret = si2157_cmd_execute(client, &cmd);
+	if (ret)
+		goto err;
+
+	uitmp = cmd.args[2] << 0 | cmd.args[3] << 8;
+	dev_dbg(&client->dev, "if_frequency kHz=%u\n", uitmp);
+
+	if (uitmp == dev->if_frequency / 1000)
 		goto warm;
 
 	/* power up */
@@ -203,9 +214,6 @@ skip_fw_download:
 
 	dev_info(&client->dev, "firmware version: %c.%c.%d\n",
 			cmd.args[6], cmd.args[7], cmd.args[8]);
-
-	dev->fw_loaded = true;
-
 warm:
 	/* init statistics in order signal app which are supported */
 	c->strength.len = 1;
@@ -422,7 +430,6 @@ static int si2157_probe(struct i2c_client *client,
 	dev->fe = cfg->fe;
 	dev->inversion = cfg->inversion;
 	dev->if_port = cfg->if_port;
-	dev->fw_loaded = false;
 	dev->chiptype = (u8)id->driver_data;
 	dev->if_frequency = 5000000; /* default value of property 0x0706 */
 	mutex_init(&dev->i2c_mutex);
diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
index ecc463d..e801acc 100644
--- a/drivers/media/tuners/si2157_priv.h
+++ b/drivers/media/tuners/si2157_priv.h
@@ -25,7 +25,6 @@ struct si2157_dev {
 	struct mutex i2c_mutex;
 	struct dvb_frontend *fe;
 	bool active;
-	bool fw_loaded;
 	bool inversion;
 	u8 chiptype;
 	u8 if_port;
-- 
http://palosaari.fi/

