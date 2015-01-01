Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52511 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751436AbbAAO2W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Jan 2015 09:28:22 -0500
Received: from lanttu.localdomain (lanttu.localdomain [192.168.5.64])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 5E67560093
	for <linux-media@vger.kernel.org>; Thu,  1 Jan 2015 16:28:18 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH 1/1] smiapp: Use of_property_read_u64_array() to read a 64-bit number array
Date: Thu,  1 Jan 2015 16:28:02 +0200
Message-Id: <1420122483-6955-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

of_property_read_u64_array() wasn't yet part of the kernel tree when the
functionality was needed. Do use it now.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp/smiapp-core.c |   24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index b3c8125..b1f566b 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2977,10 +2977,7 @@ static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
 	struct smiapp_platform_data *pdata;
 	struct v4l2_of_endpoint bus_cfg;
 	struct device_node *ep;
-	struct property *prop;
-	__be32 *val;
 	uint32_t asize;
-	unsigned int i;
 	int rval;
 
 	if (!dev->of_node)
@@ -3042,23 +3039,12 @@ static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
 	}
 
 	asize /= sizeof(*pdata->op_sys_clock);
-	/*
-	 * Read a 64-bit array --- this will be replaced with a
-	 * of_property_read_u64_array() once it's merged.
-	 */
-	prop = of_find_property(dev->of_node, "link-frequencies", NULL);
-	if (!prop)
-		goto out_err;
-	if (!prop->value)
-		goto out_err;
-	if (asize * sizeof(*pdata->op_sys_clock) > prop->length)
-		goto out_err;
-	val = prop->value;
-	if (IS_ERR(val))
+	rval = of_property_read_u64_array(
+		dev->of_node, "link-frequencies", pdata->op_sys_clock, asize);
+	if (rval) {
+		dev_warn(dev, "can't get link-frequencies\n");
 		goto out_err;
-
-	for (i = 0; i < asize; i++)
-		pdata->op_sys_clock[i] = of_read_number(val + i * 2, 2);
+	}
 
 	for (; asize > 0; asize--)
 		dev_dbg(dev, "freq %d: %lld\n", asize - 1,
-- 
1.7.10.4

