Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51936 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751243AbdH2Ml2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 08:41:28 -0400
Received: from lanttu.localdomain (unknown [IPv6:2001:1bc8:1a6:d3d5::e1:1002])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 567EE600DF
        for <linux-media@vger.kernel.org>; Tue, 29 Aug 2017 15:41:26 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/4] smiapp: Fix error handling in power on sequence
Date: Tue, 29 Aug 2017 15:41:22 +0300
Message-Id: <20170829124125.30879-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20170829124125.30879-1-sakari.ailus@linux.intel.com>
References: <20170829124125.30879-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The error handling code in smiapp_power_on() returned in case of a failed
I2C write instead of cleaning up the mess. Fix this.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 700f433261d0..d581625d7826 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -1313,7 +1313,7 @@ static int smiapp_power_on(struct device *dev)
 	rval = smiapp_write(sensor, SMIAPP_REG_U8_DPHY_CTRL,
 			    SMIAPP_DPHY_CTRL_UI);
 	if (rval < 0)
-		return rval;
+		goto out_cci_addr_fail;
 
 	rval = smiapp_call_quirk(sensor, post_poweron);
 	if (rval) {
-- 
2.11.0
