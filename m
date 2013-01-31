Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33143 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756592Ab3AaEV6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 23:21:58 -0500
Received: by mail-pa0-f47.google.com with SMTP id bj3so342910pad.20
        for <linux-media@vger.kernel.org>; Wed, 30 Jan 2013 20:21:57 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org,
	patches@linaro.org, Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 1/1] [media] s5c73m3: Use devm_regulator_bulk_get API
Date: Thu, 31 Jan 2013 09:42:46 +0530
Message-Id: <1359605566-8196-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_regulator_bulk_get saves some cleanup and exit code.

Cc: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/i2c/s5c73m3/s5c73m3-core.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index b063b4d..c143c9e 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1627,7 +1627,7 @@ static int __devinit s5c73m3_probe(struct i2c_client *client,
 	for (i = 0; i < S5C73M3_MAX_SUPPLIES; i++)
 		state->supplies[i].supply = s5c73m3_supply_names[i];
 
-	ret = regulator_bulk_get(dev, S5C73M3_MAX_SUPPLIES,
+	ret = devm_regulator_bulk_get(dev, S5C73M3_MAX_SUPPLIES,
 			       state->supplies);
 	if (ret) {
 		dev_err(dev, "failed to get regulators\n");
@@ -1636,7 +1636,7 @@ static int __devinit s5c73m3_probe(struct i2c_client *client,
 
 	ret = s5c73m3_init_controls(state);
 	if (ret)
-		goto out_err3;
+		goto out_err2;
 
 	state->sensor_pix_size[RES_ISP] = &s5c73m3_isp_resolutions[1];
 	state->sensor_pix_size[RES_JPEG] = &s5c73m3_jpeg_resolutions[1];
@@ -1652,15 +1652,13 @@ static int __devinit s5c73m3_probe(struct i2c_client *client,
 
 	ret = s5c73m3_register_spi_driver(state);
 	if (ret < 0)
-		goto out_err3;
+		goto out_err2;
 
 	state->i2c_client = client;
 
 	v4l2_info(sd, "%s: completed succesfully\n", __func__);
 	return 0;
 
-out_err3:
-	regulator_bulk_free(S5C73M3_MAX_SUPPLIES, state->supplies);
 out_err2:
 	s5c73m3_free_gpios(state);
 out_err1:
@@ -1679,7 +1677,6 @@ static int __devexit s5c73m3_remove(struct i2c_client *client)
 	media_entity_cleanup(&sd->entity);
 
 	s5c73m3_unregister_spi_driver(state);
-	regulator_bulk_free(S5C73M3_MAX_SUPPLIES, state->supplies);
 	s5c73m3_free_gpios(state);
 
 	return 0;
-- 
1.7.4.1

