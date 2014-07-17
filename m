Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:58346 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882AbaGQU4u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 16:56:50 -0400
Received: by mail-we0-f172.google.com with SMTP id x48so3606603wes.17
        for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 13:56:49 -0700 (PDT)
From: Luis Alves <ljalvs@gmail.com>
To: linux-media@vger.kernel.org
Cc: crope@iki.fi, Luis Alves <ljalvs@gmail.com>
Subject: [PATCH 1/1] si2168: Remove testing for demod presence on probe. If the demod is in sleep mode it will fail.
Date: Thu, 17 Jul 2014 21:56:44 +0100
Message-Id: <1405630604-19534-1-git-send-email-ljalvs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Luis Alves <ljalvs@gmail.com>
---
 drivers/media/dvb-frontends/si2168.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 3fed522..7e45eeab 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -595,7 +595,6 @@ static int si2168_probe(struct i2c_client *client,
 	struct si2168_config *config = client->dev.platform_data;
 	struct si2168 *s;
 	int ret;
-	struct si2168_cmd cmd;
 
 	dev_dbg(&client->dev, "%s:\n", __func__);
 
@@ -609,13 +608,6 @@ static int si2168_probe(struct i2c_client *client,
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
1.9.1

