Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out1.inet.fi ([62.71.2.228]:36031 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933037AbaHYSHS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 14:07:18 -0400
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 2/3] si2157: avoid firmware loading if it has been loaded previously
Date: Mon, 25 Aug 2014 21:07:03 +0300
Message-Id: <1408990024-1642-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1408990024-1642-1-git-send-email-olli.salonen@iki.fi>
References: <1408990024-1642-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a variable into state to keep track if firmware has been loaded or not. 
Skip firmware loading in case it is already loaded (resume from sleep).

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/tuners/si2157.c      | 11 +++++++++--
 drivers/media/tuners/si2157_priv.h |  1 +
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index c84f7b8..5901484 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -89,7 +89,10 @@ static int si2157_init(struct dvb_frontend *fe)
 
 	dev_dbg(&s->client->dev, "\n");
 
-	/* configure? */
+	if (s->fw_loaded)
+		goto warm;
+
+	/* power up */
 	memcpy(cmd.args, "\xc0\x00\x0c\x00\x00\x01\x01\x01\x01\x01\x01\x02\x00\x00\x01", 15);
 	cmd.wlen = 15;
 	cmd.rlen = 1;
@@ -176,9 +179,12 @@ skip_fw_download:
 	if (ret)
 		goto err;
 
-	s->active = true;
+	s->fw_loaded = true;
 
+warm:
+	s->active = true;
 	return 0;
+
 err:
 	if (fw)
 		release_firmware(fw);
@@ -320,6 +326,7 @@ static int si2157_probe(struct i2c_client *client,
 	s->client = client;
 	s->fe = cfg->fe;
 	s->inversion = cfg->inversion;
+	s->fw_loaded = false;
 	mutex_init(&s->i2c_mutex);
 
 	/* check if the tuner is there */
diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
index 3ddab5e..4080a57 100644
--- a/drivers/media/tuners/si2157_priv.h
+++ b/drivers/media/tuners/si2157_priv.h
@@ -26,6 +26,7 @@ struct si2157 {
 	struct i2c_client *client;
 	struct dvb_frontend *fe;
 	bool active;
+	bool fw_loaded;
 	bool inversion;
 };
 
-- 
1.9.1

