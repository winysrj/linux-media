Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42972 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760125AbaGSCis (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 22:38:48 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Luis Alves <ljalvs@gmail.com>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 04/10] si2168: Remove testing for demod presence on probe.
Date: Sat, 19 Jul 2014 05:38:20 +0300
Message-Id: <1405737506-13186-4-git-send-email-crope@iki.fi>
In-Reply-To: <1405737506-13186-1-git-send-email-crope@iki.fi>
References: <1405737506-13186-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Luis Alves <ljalvs@gmail.com>

Testing demod presence on probe fails if the demod was sleep mode.

Signed-off-by: Luis Alves <ljalvs@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 7659764..9925a12 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -602,7 +602,6 @@ static int si2168_probe(struct i2c_client *client,
 	struct si2168_config *config = client->dev.platform_data;
 	struct si2168 *s;
 	int ret;
-	struct si2168_cmd cmd;
 
 	dev_dbg(&client->dev, "%s:\n", __func__);
 
@@ -616,13 +615,6 @@ static int si2168_probe(struct i2c_client *client,
 	s->client = client;
 	mutex_init(&s->i2c_mutex);
 
-	/* check if the demod is there */
-	cmd.wlen = 0;
-	cmd.rlen = 1;
-	ret = si2168_cmd_execute(s, &cmd);
-	if (ret)
-		goto err;
-
 	/* create mux i2c adapter for tuner */
 	s->adapter = i2c_add_mux_adapter(client->adapter, &client->dev, s,
 			0, 0, 0, si2168_select, si2168_deselect);
-- 
1.9.3

