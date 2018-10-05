Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52722 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725896AbeJFE1a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 6 Oct 2018 00:27:30 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: rajmohan.mani@intel.com
Subject: [PATCH 1/2] dw9714: Remove useless error message
Date: Sat,  6 Oct 2018 00:26:53 +0300
Message-Id: <20181005212654.14664-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20181005212654.14664-1-sakari.ailus@linux.intel.com>
References: <20181005212654.14664-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If probe fails, the kernel will print the error code. There's no need to
driver to do that.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/dw9714.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/dw9714.c b/drivers/media/i2c/dw9714.c
index 3dc2100470a1..26d83693a681 100644
--- a/drivers/media/i2c/dw9714.c
+++ b/drivers/media/i2c/dw9714.c
@@ -171,7 +171,7 @@ static int dw9714_probe(struct i2c_client *client)
 err_cleanup:
 	v4l2_ctrl_handler_free(&dw9714_dev->ctrls_vcm);
 	media_entity_cleanup(&dw9714_dev->sd.entity);
-	dev_err(&client->dev, "Probe failed: %d\n", rval);
+
 	return rval;
 }
 
-- 
2.11.0
