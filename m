Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59076 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933088AbcLIQPl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Dec 2016 11:15:41 -0500
Received: from lanttu.localdomain (unknown [192.168.15.166])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 1C8B260097
        for <linux-media@vger.kernel.org>; Fri,  9 Dec 2016 18:15:36 +0200 (EET)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] smiapp: Fix error handling in power on sequence
Date: Fri,  9 Dec 2016 18:15:37 +0200
Message-Id: <1481300137-25602-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The error handling code in smiapp_power_on() returned in case of a failed
I2C write instead of cleaning up the mess. Fix this.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index f4e92bd..e290601 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -1310,7 +1310,7 @@ static int smiapp_power_on(struct device *dev)
 	rval = smiapp_write(sensor, SMIAPP_REG_U8_DPHY_CTRL,
 			    SMIAPP_DPHY_CTRL_UI);
 	if (rval < 0)
-		return rval;
+		goto out_cci_addr_fail;
 
 	rval = smiapp_call_quirk(sensor, post_poweron);
 	if (rval) {
-- 
2.1.4

