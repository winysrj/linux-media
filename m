Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37237 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbcENFdk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 May 2016 01:33:40 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] mn88473: fix error path on probe()
Date: Sat, 14 May 2016 08:33:19 +0300
Message-Id: <1463203999-4919-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Latest, 3rd, regmap instance should be freed on error case.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/mn88473.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/mn88473.c b/drivers/media/dvb-frontends/mn88473.c
index 6c5d5921..e6933d4 100644
--- a/drivers/media/dvb-frontends/mn88473.c
+++ b/drivers/media/dvb-frontends/mn88473.c
@@ -536,7 +536,7 @@ static int mn88473_probe(struct i2c_client *client,
 	/* Sleep because chip is active by default */
 	ret = regmap_write(dev->regmap[2], 0x05, 0x3e);
 	if (ret)
-		goto err_client_2_i2c_unregister_device;
+		goto err_regmap_2_regmap_exit;
 
 	/* Create dvb frontend */
 	memcpy(&dev->frontend.ops, &mn88473_ops, sizeof(dev->frontend.ops));
@@ -547,7 +547,8 @@ static int mn88473_probe(struct i2c_client *client,
 	dev_info(&client->dev, "Panasonic MN88473 successfully identified\n");
 
 	return 0;
-
+err_regmap_2_regmap_exit:
+	regmap_exit(dev->regmap[2]);
 err_client_2_i2c_unregister_device:
 	i2c_unregister_device(dev->client[2]);
 err_regmap_1_regmap_exit:
-- 
http://palosaari.fi/

