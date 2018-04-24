Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55640 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752968AbeDXLKc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 07:10:32 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: maxime.ripard@bootlin.com, slongerbeam@gmail.com
Subject: [RESEND PATCH 1/1] ov5640: Use dev_fwnode() to obtain device's fwnode
Date: Tue, 24 Apr 2018 14:10:29 +0300
Message-Id: <20180424111029.18751-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use dev_fwnode() on the device instead of getting an fwnode handle of the
device's OF node. The result is the same on OF-based systems and looks
better, too.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Fixed Maxime's e-mail.

 drivers/media/i2c/ov5640.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 852026baa2e7..7acd3b44d194 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2536,8 +2536,8 @@ static int ov5640_probe(struct i2c_client *client,
 
 	sensor->ae_target = 52;
 
-	endpoint = fwnode_graph_get_next_endpoint(
-		of_fwnode_handle(client->dev.of_node), NULL);
+	endpoint = fwnode_graph_get_next_endpoint(dev_fwnode(&client->dev),
+						  NULL);
 	if (!endpoint) {
 		dev_err(dev, "endpoint node not found\n");
 		return -EINVAL;
-- 
2.11.0
