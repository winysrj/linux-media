Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:16734 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753296AbcJEHXT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Oct 2016 03:23:19 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id 0CDB720D33
        for <linux-media@vger.kernel.org>; Wed,  5 Oct 2016 10:23:17 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [RFC 4/5] smiapp: Support ACPI power control
Date: Wed,  5 Oct 2016 10:21:48 +0300
Message-Id: <1475652109-22164-5-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1475652109-22164-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1475652109-22164-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On ACPI systems the ACPI will control at least regulators to the sensor. On
such systems the sensor driver does not explicitly need to control them,
thus make them optional.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 59872b3..e0d7586 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2887,7 +2887,7 @@ static int smiapp_probe(struct i2c_client *client,
 	v4l2_i2c_subdev_init(&sensor->src->sd, client, &smiapp_ops);
 	sensor->src->sd.internal_ops = &smiapp_internal_src_ops;
 
-	sensor->vana = devm_regulator_get(&client->dev, "vana");
+	sensor->vana = devm_regulator_get_optional(&client->dev, "vana");
 	if (IS_ERR(sensor->vana)) {
 		dev_err(&client->dev, "could not get regulator for vana\n");
 		return PTR_ERR(sensor->vana);
-- 
2.7.4

