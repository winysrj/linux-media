Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52724 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726037AbeJFE1a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 6 Oct 2018 00:27:30 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: rajmohan.mani@intel.com
Subject: [PATCH 2/2] dw9807-vcm: Fix probe error handling
Date: Sat,  6 Oct 2018 00:26:54 +0300
Message-Id: <20181005212654.14664-3-sakari.ailus@linux.intel.com>
In-Reply-To: <20181005212654.14664-1-sakari.ailus@linux.intel.com>
References: <20181005212654.14664-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_async_unregister_subdev() may not be called without
v4l2_async_register_subdev() being called first. Fix this.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/dw9807-vcm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/dw9807-vcm.c b/drivers/media/i2c/dw9807-vcm.c
index a532c57dc636..73b0e10dc591 100644
--- a/drivers/media/i2c/dw9807-vcm.c
+++ b/drivers/media/i2c/dw9807-vcm.c
@@ -218,7 +218,8 @@ static int dw9807_probe(struct i2c_client *client)
 	return 0;
 
 err_cleanup:
-	dw9807_subdev_cleanup(dw9807_dev);
+	v4l2_ctrl_handler_free(&dw9807_dev->ctrls_vcm);
+	media_entity_cleanup(&dw9807_dev->sd.entity);
 
 	return rval;
 }
-- 
2.11.0
