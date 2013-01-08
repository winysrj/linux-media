Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:60969 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab3AHG4k (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 01:56:40 -0500
Received: by mail-da0-f46.google.com with SMTP id p5so46278dak.5
        for <linux-media@vger.kernel.org>; Mon, 07 Jan 2013 22:56:39 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] [media] s5k6aa: Use devm_regulator_bulk_get API
Date: Tue,  8 Jan 2013 12:18:24 +0530
Message-Id: <1357627704-14269-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_regulator_bulk_get is device managed and saves some cleanup
and exit code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/i2c/s5k6aa.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/s5k6aa.c b/drivers/media/i2c/s5k6aa.c
index 57cd4fa..bdf5e3d 100644
--- a/drivers/media/i2c/s5k6aa.c
+++ b/drivers/media/i2c/s5k6aa.c
@@ -1598,7 +1598,7 @@ static int s5k6aa_probe(struct i2c_client *client,
 	for (i = 0; i < S5K6AA_NUM_SUPPLIES; i++)
 		s5k6aa->supplies[i].supply = s5k6aa_supply_names[i];
 
-	ret = regulator_bulk_get(&client->dev, S5K6AA_NUM_SUPPLIES,
+	ret = devm_regulator_bulk_get(&client->dev, S5K6AA_NUM_SUPPLIES,
 				 s5k6aa->supplies);
 	if (ret) {
 		dev_err(&client->dev, "Failed to get regulators\n");
@@ -1607,7 +1607,7 @@ static int s5k6aa_probe(struct i2c_client *client,
 
 	ret = s5k6aa_initialize_ctrls(s5k6aa);
 	if (ret)
-		goto out_err4;
+		goto out_err3;
 
 	s5k6aa_presets_data_init(s5k6aa);
 
@@ -1618,8 +1618,6 @@ static int s5k6aa_probe(struct i2c_client *client,
 
 	return 0;
 
-out_err4:
-	regulator_bulk_free(S5K6AA_NUM_SUPPLIES, s5k6aa->supplies);
 out_err3:
 	s5k6aa_free_gpios(s5k6aa);
 out_err2:
@@ -1635,7 +1633,6 @@ static int s5k6aa_remove(struct i2c_client *client)
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 	media_entity_cleanup(&sd->entity);
-	regulator_bulk_free(S5K6AA_NUM_SUPPLIES, s5k6aa->supplies);
 	s5k6aa_free_gpios(s5k6aa);
 
 	return 0;
-- 
1.7.4.1

