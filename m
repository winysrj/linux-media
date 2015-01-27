Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34284 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756078AbbA0Kbo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2015 05:31:44 -0500
Received: from lanttu.localdomain (unknown [192.168.15.166])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 757D660093
	for <linux-media@vger.kernel.org>; Tue, 27 Jan 2015 12:31:41 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] smiapp: Don't compile of_read_number() if CONFIG_OF isn't defined
Date: Tue, 27 Jan 2015 12:31:15 +0200
Message-Id: <1422354675-1184-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

of_read_number() is defined in of.h but does not return an error code, so
that non-of implementation could simply return an error.

Temporarily work around this until of_read_number() can be replaced by
of_property_read_u64_array().

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp/smiapp-core.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index b3c8125..d47eff5 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2980,7 +2980,9 @@ static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
 	struct property *prop;
 	__be32 *val;
 	uint32_t asize;
+#ifdef CONFIG_OF
 	unsigned int i;
+#endif
 	int rval;
 
 	if (!dev->of_node)
@@ -3057,8 +3059,10 @@ static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
 	if (IS_ERR(val))
 		goto out_err;
 
+#ifdef CONFIG_OF
 	for (i = 0; i < asize; i++)
 		pdata->op_sys_clock[i] = of_read_number(val + i * 2, 2);
+#endif
 
 	for (; asize > 0; asize--)
 		dev_dbg(dev, "freq %d: %lld\n", asize - 1,
-- 
1.7.10.4

