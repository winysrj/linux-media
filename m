Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:8170 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934148AbcHaM6w (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 08:58:52 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, sre@kernel.org
Subject: [PATCH v1.1 3/5] smiapp: Return -EPROBE_DEFER if the clock cannot be obtained
Date: Wed, 31 Aug 2016 15:57:57 +0300
Message-Id: <1472648277-25888-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1472629325-30875-4-git-send-email-sakari.ailus@linux.intel.com>
References: <1472629325-30875-4-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The clock may be provided by a driver which is yet to probe. Print the
actual error code as well.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
since v1:
- Add printing of the original error code

 drivers/media/i2c/smiapp/smiapp-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 92a6859..103e335 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2557,8 +2557,9 @@ static int smiapp_init(struct smiapp_sensor *sensor)
 	if (!sensor->hwcfg->set_xclk) {
 		sensor->ext_clk = devm_clk_get(&client->dev, NULL);
 		if (IS_ERR(sensor->ext_clk)) {
-			dev_err(&client->dev, "could not get clock\n");
-			return PTR_ERR(sensor->ext_clk);
+			dev_err(&client->dev, "could not get clock (%ld)\n",
+				PTR_ERR(sensor->ext_clk));
+			return -EPROBE_DEFER;
 		}
 
 		rval = clk_set_rate(sensor->ext_clk,
-- 
2.7.4

