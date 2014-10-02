Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50522 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751355AbaJBIql (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Oct 2014 04:46:41 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 01/18] smiapp: Take mutex during PLL update in sensor initialisation
Date: Thu,  2 Oct 2014 11:45:51 +0300
Message-Id: <1412239568-8524-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
References: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

The mutex does not serialise anything in this case but avoids a lockdep
warning from the control framework.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 932ed9b..6174a59 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2677,7 +2677,9 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 		pll->flags |= SMIAPP_PLL_FLAG_NO_OP_CLOCKS;
 	pll->scale_n = sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN];
 
+	mutex_lock(&sensor->mutex);
 	rval = smiapp_update_mode(sensor);
+	mutex_unlock(&sensor->mutex);
 	if (rval) {
 		dev_err(&client->dev, "update mode failed\n");
 		goto out_nvm_release;
-- 
1.7.10.4

