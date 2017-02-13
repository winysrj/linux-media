Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:34507 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753605AbdBMPlI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 10:41:08 -0500
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id 7A38620295
        for <linux-media@vger.kernel.org>; Mon, 13 Feb 2017 17:40:55 +0200 (EET)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] smiapp: Make VANA regulator optional
Date: Mon, 13 Feb 2017 17:39:29 +0200
Message-Id: <1487000369-2188-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On ACPI based systems ACPI will control the camera module's power
resources. In that case the sensor driver does not explicitly need to
control them, thus make them optional.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index f4e92bd..1a56763 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2878,7 +2878,7 @@ static int smiapp_probe(struct i2c_client *client,
 	v4l2_i2c_subdev_init(&sensor->src->sd, client, &smiapp_ops);
 	sensor->src->sd.internal_ops = &smiapp_internal_src_ops;
 
-	sensor->vana = devm_regulator_get(&client->dev, "vana");
+	sensor->vana = devm_regulator_get_optional(&client->dev, "vana");
 	if (IS_ERR(sensor->vana)) {
 		dev_err(&client->dev, "could not get regulator for vana\n");
 		return PTR_ERR(sensor->vana);
-- 
2.7.4
