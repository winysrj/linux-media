Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:60332 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751274AbdIPUKV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Sep 2017 16:10:21 -0400
Subject: [PATCH 2/2] [media] m88rs6000t: Improve three size determinations
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <278b14e0-f717-7471-6dc3-45dc98d64443@users.sourceforge.net>
Message-ID: <5bec5eaa-faca-ec11-87f4-4383181525d1@users.sourceforge.net>
Date: Sat, 16 Sep 2017 22:10:16 +0200
MIME-Version: 1.0
In-Reply-To: <278b14e0-f717-7471-6dc3-45dc98d64443@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 16 Sep 2017 21:38:03 +0200

Replace the specification of data structures by variable references
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/tuners/m88rs6000t.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/tuners/m88rs6000t.c b/drivers/media/tuners/m88rs6000t.c
index d89793a05862..1e55c679b25e 100644
--- a/drivers/media/tuners/m88rs6000t.c
+++ b/drivers/media/tuners/m88rs6000t.c
@@ -629,6 +629,6 @@ static int m88rs6000t_probe(struct i2c_client *client,
 	}
 
-	memcpy(&dev->cfg, cfg, sizeof(struct m88rs6000t_config));
+	memcpy(&dev->cfg, cfg, sizeof(*cfg));
 	dev->client = client;
 	dev->regmap = devm_regmap_init_i2c(client, &regmap_config);
 	if (IS_ERR(dev->regmap)) {
@@ -696,7 +696,7 @@ static int m88rs6000t_probe(struct i2c_client *client,
 
 	fe->tuner_priv = dev;
 	memcpy(&fe->ops.tuner_ops, &m88rs6000t_tuner_ops,
-			sizeof(struct dvb_tuner_ops));
+	       sizeof(fe->ops.tuner_ops));
 	i2c_set_clientdata(client, dev);
 	return 0;
 err:
@@ -712,8 +712,7 @@ static int m88rs6000t_remove(struct i2c_client *client)
 	struct dvb_frontend *fe = dev->cfg.fe;
 
 	dev_dbg(&client->dev, "\n");
-
-	memset(&fe->ops.tuner_ops, 0, sizeof(struct dvb_tuner_ops));
+	memset(&fe->ops.tuner_ops, 0, sizeof(fe->ops.tuner_ops));
 	fe->tuner_priv = NULL;
 	kfree(dev);
 
-- 
2.14.1
