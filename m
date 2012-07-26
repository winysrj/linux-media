Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33538 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab2GZGY1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 02:24:27 -0400
Received: by pbbrp8 with SMTP id rp8so2709455pbb.19
        for <linux-media@vger.kernel.org>; Wed, 25 Jul 2012 23:24:27 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/2] [media] s5k6aa: Use devm_kzalloc function
Date: Thu, 26 Jul 2012 11:53:32 +0530
Message-Id: <1343283813-24326-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_kzalloc() eliminates the need to free explicitly thereby
making the code a bit simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5k6aa.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/s5k6aa.c b/drivers/media/video/s5k6aa.c
index 6625e46..0c3bc58 100644
--- a/drivers/media/video/s5k6aa.c
+++ b/drivers/media/video/s5k6aa.c
@@ -1568,7 +1568,7 @@ static int s5k6aa_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	s5k6aa = kzalloc(sizeof(*s5k6aa), GFP_KERNEL);
+	s5k6aa = devm_kzalloc(&client->dev, sizeof(*s5k6aa), GFP_KERNEL);
 	if (!s5k6aa)
 		return -ENOMEM;
 
@@ -1592,7 +1592,7 @@ static int s5k6aa_probe(struct i2c_client *client,
 	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
 	ret = media_entity_init(&sd->entity, 1, &s5k6aa->pad, 0);
 	if (ret)
-		goto out_err1;
+		return ret;
 
 	ret = s5k6aa_configure_gpios(s5k6aa, pdata);
 	if (ret)
@@ -1627,8 +1627,6 @@ out_err3:
 	s5k6aa_free_gpios(s5k6aa);
 out_err2:
 	media_entity_cleanup(&s5k6aa->sd.entity);
-out_err1:
-	kfree(s5k6aa);
 	return ret;
 }
 
@@ -1642,7 +1640,6 @@ static int s5k6aa_remove(struct i2c_client *client)
 	media_entity_cleanup(&sd->entity);
 	regulator_bulk_free(S5K6AA_NUM_SUPPLIES, s5k6aa->supplies);
 	s5k6aa_free_gpios(s5k6aa);
-	kfree(s5k6aa);
 
 	return 0;
 }
-- 
1.7.4.1

