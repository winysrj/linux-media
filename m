Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35320 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753384AbcISWDP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 18:03:15 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: sre@kernel.org
Subject: [PATCH v3 18/18] smiapp-pll: Don't complain aloud about failing PLL calculation
Date: Tue, 20 Sep 2016 01:02:51 +0300
Message-Id: <1474322571-20290-19-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Don't complain about a failure to compute the pre_pll divisor. The
function is used to determine whether a particular combination of bits per
sample value and a link frequency can be used, in which case there are
lots of unnecessary driver messages. During normal operation the failure
generally does not happen. Use dev_dbg() instead.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp-pll.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index e3348db..771db56 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -479,7 +479,8 @@ int smiapp_pll_calculate(struct device *dev,
 		return 0;
 	}
 
-	dev_info(dev, "unable to compute pre_pll divisor\n");
+	dev_dbg(dev, "unable to compute pre_pll divisor\n");
+
 	return rval;
 }
 EXPORT_SYMBOL_GPL(smiapp_pll_calculate);
-- 
2.1.4

