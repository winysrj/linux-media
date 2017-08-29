Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51942 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751469AbdH2Ml2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 08:41:28 -0400
Received: from lanttu.localdomain (unknown [IPv6:2001:1bc8:1a6:d3d5::e1:1002])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id EC923600FA
        for <linux-media@vger.kernel.org>; Tue, 29 Aug 2017 15:41:26 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/4] smiapp: Make clock control optional
Date: Tue, 29 Aug 2017 15:41:25 +0300
Message-Id: <20170829124125.30879-5-sakari.ailus@linux.intel.com>
In-Reply-To: <20170829124125.30879-1-sakari.ailus@linux.intel.com>
References: <20170829124125.30879-1-sakari.ailus@linux.intel.com>
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
index 009b5e26204b..fbd851be51d2 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2892,7 +2892,10 @@ static int smiapp_probe(struct i2c_client *client,
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
2.11.0
