Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out1.inet.fi ([62.71.2.194]:56405 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbaHKT60 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Aug 2014 15:58:26 -0400
From: Olli Salonen <olli.salonen@iki.fi>
To: olli@cabbala.net
Cc: Olli Salonen <olli.salonen@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/6] si2168: add ts_mode setting and move to si2168_init
Date: Mon, 11 Aug 2014 22:58:10 +0300
Message-Id: <1407787095-2167-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Luis Alves submitted a TS mode patch to si2168 earlier, but the patch was rejected due to a small issue. Here is a working version. Also, setting of TS mode is moved from si2168_set_frontend to si2168_init.

This patch adds the TS mode as a config option for the si2168 demod:
- ts_mode added to config struct.
- Possible (interesting) values are
   * Parallel mode = 0x06
   * Serial mode = 0x03

Currently the modules using this demod only use parallel mode. Patches for these modules later in this patch series.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c      | 17 ++++++++++-------
 drivers/media/dvb-frontends/si2168.h      |  6 ++++++
 drivers/media/dvb-frontends/si2168_priv.h |  1 +
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 8f81d97..0eb0e4e 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -297,13 +297,6 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	memcpy(cmd.args, "\x14\x00\x01\x10\x16\x00", 6);
-	cmd.wlen = 6;
-	cmd.rlen = 4;
-	ret = si2168_cmd_execute(s, &cmd);
-	if (ret)
-		goto err;
-
 	memcpy(cmd.args, "\x14\x00\x09\x10\xe3\x18", 6);
 	cmd.wlen = 6;
 	cmd.rlen = 4;
@@ -465,6 +458,15 @@ static int si2168_init(struct dvb_frontend *fe)
 	dev_info(&s->client->dev, "%s: found a '%s' in warm state\n",
 			KBUILD_MODNAME, si2168_ops.info.name);
 
+	/* set ts mode */
+	memcpy(cmd.args, "\x14\x00\x01\x10\x10\x00", 6);
+	cmd.args[4] |= s->ts_mode;
+	cmd.wlen = 6;
+	cmd.rlen = 4;
+	ret = si2168_cmd_execute(s, &cmd);
+	if (ret)
+		goto err;
+
 	s->active = true;
 
 	return 0;
@@ -633,6 +635,7 @@ static int si2168_probe(struct i2c_client *client,
 
 	*config->i2c_adapter = s->adapter;
 	*config->fe = &s->fe;
+	s->ts_mode = config->ts_mode;
 
 	i2c_set_clientdata(client, s);
 
diff --git a/drivers/media/dvb-frontends/si2168.h b/drivers/media/dvb-frontends/si2168.h
index 3c5b5ab..e086d67 100644
--- a/drivers/media/dvb-frontends/si2168.h
+++ b/drivers/media/dvb-frontends/si2168.h
@@ -34,6 +34,12 @@ struct si2168_config {
 	 * returned by driver
 	 */
 	struct i2c_adapter **i2c_adapter;
+
+	/* TS mode */
+	u8 ts_mode;
 };
 
+#define SI2168_TS_PARALLEL	0x06
+#define SI2168_TS_SERIAL	0x03
+
 #endif
diff --git a/drivers/media/dvb-frontends/si2168_priv.h b/drivers/media/dvb-frontends/si2168_priv.h
index ebbf502..0f83284 100644
--- a/drivers/media/dvb-frontends/si2168_priv.h
+++ b/drivers/media/dvb-frontends/si2168_priv.h
@@ -36,6 +36,7 @@ struct si2168 {
 	fe_delivery_system_t delivery_system;
 	fe_status_t fe_status;
 	bool active;
+	u8 ts_mode;
 };
 
 /* firmare command struct */
-- 
1.9.1

