Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52826 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752179AbdBMQQc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 11:16:32 -0500
Received: from lanttu.localdomain (lanttu-e.localdomain [192.168.1.64])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id F1538600AF
        for <linux-media@vger.kernel.org>; Mon, 13 Feb 2017 18:16:27 +0200 (EET)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/4] smiapp: Make clock control optional
Date: Mon, 13 Feb 2017 18:16:26 +0200
Message-Id: <1487002586-1480-5-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1487002586-1480-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1487002586-1480-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The clock control is not explicitly controlled by the driver in two cases:
ACPI based systems and when the clock is part of the power sequence of the
camera module.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index caf376c..9ed1b86 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2883,7 +2883,10 @@ static int smiapp_probe(struct i2c_client *client,
 	}
 
 	sensor->ext_clk = devm_clk_get(&client->dev, NULL);
-	if (IS_ERR(sensor->ext_clk)) {
+	if (PTR_ERR(sensor->ext_clk) == -ENOENT) {
+		dev_info(&client->dev, "no clock defined, continuing...\n");
+		sensor->ext_clk = NULL;
+	} else if (IS_ERR(sensor->ext_clk)) {
 		dev_err(&client->dev, "could not get clock (%ld)\n",
 			PTR_ERR(sensor->ext_clk));
 		return -EPROBE_DEFER;
-- 
2.1.4
