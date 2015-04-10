Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51101 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932277AbbDJWQ5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2015 18:16:57 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org, prabhakar.csengg@gmail.com
Cc: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com
Subject: [PATCH v4.1 4/4] smiapp: Use v4l2_of_alloc_parse_endpoint()
Date: Sat, 11 Apr 2015 01:16:06 +0300
Message-Id: <1428704166-921-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <CA+V-a8uUTTzwP=hOiPAacT33K0cXDoy_gGNB5JAHSsY_LeHL_Q@mail.gmail.com>
References: <CA+V-a8uUTTzwP=hOiPAacT33K0cXDoy_gGNB5JAHSsY_LeHL_Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of parsing the link-frequencies property in the driver, let
v4l2_of_alloc_parse_endpoint() do it.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Reviewed-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
since v4:

- Remove useless assignment to rval.

 drivers/media/i2c/smiapp/smiapp-core.c |   38 +++++++++++++++-----------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 557f25d..636ebd6 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2975,9 +2975,9 @@ static int smiapp_resume(struct device *dev)
 static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
 {
 	struct smiapp_platform_data *pdata;
-	struct v4l2_of_endpoint bus_cfg;
+	struct v4l2_of_endpoint *bus_cfg;
 	struct device_node *ep;
-	uint32_t asize;
+	int i;
 	int rval;
 
 	if (!dev->of_node)
@@ -2987,13 +2987,15 @@ static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
 	if (!ep)
 		return NULL;
 
+	bus_cfg = v4l2_of_alloc_parse_endpoint(ep);
+	if (IS_ERR(bus_cfg))
+		goto out_err;
+
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		goto out_err;
 
-	v4l2_of_parse_endpoint(ep, &bus_cfg);
-
-	switch (bus_cfg.bus_type) {
+	switch (bus_cfg->bus_type) {
 	case V4L2_MBUS_CSI2:
 		pdata->csi_signalling_mode = SMIAPP_CSI_SIGNALLING_MODE_CSI2;
 		break;
@@ -3002,7 +3004,7 @@ static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
 		goto out_err;
 	}
 
-	pdata->lanes = bus_cfg.bus.mipi_csi2.num_data_lanes;
+	pdata->lanes = bus_cfg->bus.mipi_csi2.num_data_lanes;
 	dev_dbg(dev, "lanes %u\n", pdata->lanes);
 
 	/* xshutdown GPIO is optional */
@@ -3022,34 +3024,30 @@ static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
 	dev_dbg(dev, "reset %d, nvm %d, clk %d, csi %d\n", pdata->xshutdown,
 		pdata->nvm_size, pdata->ext_clk, pdata->csi_signalling_mode);
 
-	rval = of_get_property(ep, "link-frequencies", &asize) ? 0 : -ENOENT;
-	if (rval) {
-		dev_warn(dev, "can't get link-frequencies array size\n");
+	if (!bus_cfg->nr_of_link_frequencies) {
+		dev_warn(dev, "no link frequencies defined\n");
 		goto out_err;
 	}
 
-	pdata->op_sys_clock = devm_kzalloc(dev, asize, GFP_KERNEL);
+	pdata->op_sys_clock = devm_kcalloc(
+		dev, bus_cfg->nr_of_link_frequencies + 1 /* guardian */,
+		sizeof(*pdata->op_sys_clock), GFP_KERNEL);
 	if (!pdata->op_sys_clock) {
 		rval = -ENOMEM;
 		goto out_err;
 	}
 
-	asize /= sizeof(*pdata->op_sys_clock);
-	rval = of_property_read_u64_array(
-		ep, "link-frequencies", pdata->op_sys_clock, asize);
-	if (rval) {
-		dev_warn(dev, "can't get link-frequencies\n");
-		goto out_err;
+	for (i = 0; i < bus_cfg->nr_of_link_frequencies; i++) {
+		pdata->op_sys_clock[i] = bus_cfg->link_frequencies[i];
+		dev_dbg(dev, "freq %d: %lld\n", i, pdata->op_sys_clock[i]);
 	}
 
-	for (; asize > 0; asize--)
-		dev_dbg(dev, "freq %d: %lld\n", asize - 1,
-			pdata->op_sys_clock[asize - 1]);
-
+	v4l2_of_free_endpoint(bus_cfg);
 	of_node_put(ep);
 	return pdata;
 
 out_err:
+	v4l2_of_free_endpoint(bus_cfg);
 	of_node_put(ep);
 	return NULL;
 }
-- 
1.7.10.4

