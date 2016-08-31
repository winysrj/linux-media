Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:31187 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932635AbcHaHnI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 03:43:08 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id ECEF1204A3
        for <linux-media@vger.kernel.org>; Wed, 31 Aug 2016 10:43:00 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/5] smiapp: Return -EPROBE_DEFER if the clock cannot be obtained
Date: Wed, 31 Aug 2016 10:42:03 +0300
Message-Id: <1472629325-30875-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1472629325-30875-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1472629325-30875-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The clock may be provided by a driver which is yet to probe.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 92a6859..aaf5299 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2558,7 +2558,7 @@ static int smiapp_init(struct smiapp_sensor *sensor)
 		sensor->ext_clk = devm_clk_get(&client->dev, NULL);
 		if (IS_ERR(sensor->ext_clk)) {
 			dev_err(&client->dev, "could not get clock\n");
-			return PTR_ERR(sensor->ext_clk);
+			return -EPROBE_DEFER;
 		}
 
 		rval = clk_set_rate(sensor->ext_clk,
-- 
2.7.4

