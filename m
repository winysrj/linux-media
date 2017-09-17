Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:62852 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750793AbdIQIVH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Sep 2017 04:21:07 -0400
Subject: [PATCH 2/2] [media] tda18212: Improve three size determinations
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <eb35c033-46b3-4fd6-8398-f1e3869a67a8@users.sourceforge.net>
Message-ID: <e3688a0e-1970-c7ff-fdf8-d943bf4bb8e2@users.sourceforge.net>
Date: Sun, 17 Sep 2017 10:20:55 +0200
MIME-Version: 1.0
In-Reply-To: <eb35c033-46b3-4fd6-8398-f1e3869a67a8@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 17 Sep 2017 09:42:17 +0200

Replace the specification of data structures by variable references
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/tuners/tda18212.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/tuners/tda18212.c b/drivers/media/tuners/tda18212.c
index 8f89d52cd39c..16a90d75f7d4 100644
--- a/drivers/media/tuners/tda18212.c
+++ b/drivers/media/tuners/tda18212.c
@@ -207,6 +207,6 @@ static int tda18212_probe(struct i2c_client *client,
 	}
 
-	memcpy(&dev->cfg, cfg, sizeof(struct tda18212_config));
+	memcpy(&dev->cfg, cfg, sizeof(*cfg));
 	dev->client = client;
 	dev->regmap = devm_regmap_init_i2c(client, &regmap_config);
 	if (IS_ERR(dev->regmap)) {
@@ -244,7 +244,7 @@ static int tda18212_probe(struct i2c_client *client,
 
 	fe->tuner_priv = dev;
 	memcpy(&fe->ops.tuner_ops, &tda18212_tuner_ops,
-			sizeof(struct dvb_tuner_ops));
+	       sizeof(fe->ops.tuner_ops));
 	i2c_set_clientdata(client, dev);
 
 	return 0;
@@ -261,8 +261,7 @@ static int tda18212_remove(struct i2c_client *client)
 	struct dvb_frontend *fe = dev->cfg.fe;
 
 	dev_dbg(&client->dev, "\n");
-
-	memset(&fe->ops.tuner_ops, 0, sizeof(struct dvb_tuner_ops));
+	memset(&fe->ops.tuner_ops, 0, sizeof(fe->ops.tuner_ops));
 	fe->tuner_priv = NULL;
 	kfree(dev);
 
-- 
2.14.1
