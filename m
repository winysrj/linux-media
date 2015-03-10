Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51046 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751426AbbCJBSr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 21:18:47 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: prabhakar.csengg@gmail.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH 2/3] smiapp: Read link-frequencies property from the endpoint node
Date: Tue, 10 Mar 2015 03:18:01 +0200
Message-Id: <1425950282-30548-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1425950282-30548-1-git-send-email-sakari.ailus@iki.fi>
References: <1425950282-30548-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The documentation stated that the link-frequencies property belongs to the
endpoint node, not to the device's of_node. Fix this.

There are no DT board descriptions using the driver yet, so a fix in the
driver is sufficient.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp/smiapp-core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 565a00c..ecae76b 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -3022,8 +3022,7 @@ static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
 	dev_dbg(dev, "reset %d, nvm %d, clk %d, csi %d\n", pdata->xshutdown,
 		pdata->nvm_size, pdata->ext_clk, pdata->csi_signalling_mode);
 
-	rval = of_get_property(
-		dev->of_node, "link-frequencies", &asize) ? 0 : -ENOENT;
+	rval = of_get_property(ep, "link-frequencies", &asize) ? 0 : -ENOENT;
 	if (rval) {
 		dev_warn(dev, "can't get link-frequencies array size\n");
 		goto out_err;
@@ -3037,7 +3036,7 @@ static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
 
 	asize /= sizeof(*pdata->op_sys_clock);
 	rval = of_property_read_u64_array(
-		dev->of_node, "link-frequencies", pdata->op_sys_clock, asize);
+		ep, "link-frequencies", pdata->op_sys_clock, asize);
 	if (rval) {
 		dev_warn(dev, "can't get link-frequencies\n");
 		goto out_err;
-- 
1.7.10.4

