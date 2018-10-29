Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54096 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730358AbeJ3HvV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 03:51:21 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 1/4] tw9910: Unregister async subdev at device unbind
Date: Tue, 30 Oct 2018 01:00:26 +0200
Message-Id: <20181029230029.14630-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20181029230029.14630-1-sakari.ailus@linux.intel.com>
References: <20181029230029.14630-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The async sub-device was added to the async list in probe but it was not
removed in the driver's remove function. Fix this. Also unregister the
async subdev before powering down the device.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/tw9910.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tw9910.c b/drivers/media/i2c/tw9910.c
index a54548cc4285..7087ce946af1 100644
--- a/drivers/media/i2c/tw9910.c
+++ b/drivers/media/i2c/tw9910.c
@@ -997,10 +997,11 @@ static int tw9910_remove(struct i2c_client *client)
 {
 	struct tw9910_priv *priv = to_tw9910(client);
 
+	v4l2_async_unregister_subdev(&priv->subdev);
+
 	if (priv->pdn_gpio)
 		gpiod_put(priv->pdn_gpio);
 	clk_put(priv->clk);
-	v4l2_device_unregister_subdev(&priv->subdev);
 
 	return 0;
 }
-- 
2.11.0
