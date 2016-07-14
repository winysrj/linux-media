Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40473 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752243AbcGNWf1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2016 18:35:27 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [RFC 16/16] omap3isp: Don't rely on devm for memory resource management
Date: Fri, 15 Jul 2016 01:35:11 +0300
Message-Id: <1468535711-13836-17-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1468535711-13836-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1468535711-13836-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm functions are fine for managing resources that are directly related
to the device at hand and that have no other dependencies. However, a
process holding a file handle to a device created by a driver for a device
may result in the file handle left behind after the device is long gone.
This will result in accessing released (and potentially reallocated)
memory.

Instead, rely on the media device which will stick around until all users
are gone.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/omap3isp/isp.c         | 38 ++++++++++++++++++++-------
 drivers/media/platform/omap3isp/ispccp2.c     |  3 ++-
 drivers/media/platform/omap3isp/isph3a_aewb.c | 20 +++++++++-----
 drivers/media/platform/omap3isp/isph3a_af.c   | 20 +++++++++-----
 drivers/media/platform/omap3isp/isphist.c     |  5 ++--
 drivers/media/platform/omap3isp/ispstat.c     |  2 ++
 6 files changed, 63 insertions(+), 25 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index a0dff24..b11818f 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1370,7 +1370,7 @@ static int isp_get_clocks(struct isp_device *isp)
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(isp_clocks); ++i) {
-		clk = devm_clk_get(isp->dev, isp_clocks[i]);
+		clk = clk_get(isp->dev, isp_clocks[i]);
 		if (IS_ERR(clk)) {
 			dev_err(isp->dev, "clk_get %s failed\n", isp_clocks[i]);
 			return PTR_ERR(clk);
@@ -1382,6 +1382,14 @@ static int isp_get_clocks(struct isp_device *isp)
 	return 0;
 }
 
+static void isp_put_clocks(struct isp_device *isp)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(isp_clocks); ++i)
+		clk_put(isp->clock[i]);
+}
+
 /*
  * omap3isp_get - Acquire the ISP resource.
  *
@@ -1596,7 +1604,6 @@ static void isp_unregister_entities(struct isp_device *isp)
 	omap3isp_stat_unregister_entities(&isp->isp_af);
 	omap3isp_stat_unregister_entities(&isp->isp_hist);
 
-	v4l2_device_unregister(&isp->v4l2_dev);
 	media_device_unregister(isp->media_dev);
 }
 
@@ -1950,6 +1957,8 @@ static void isp_release(struct media_device *mdev)
 {
 	struct isp_device *isp = media_device_priv(mdev);
 
+	v4l2_device_unregister(&isp->v4l2_dev);
+
 	isp_cleanup_modules(isp);
 	isp_xclk_cleanup(isp);
 
@@ -1958,6 +1967,10 @@ static void isp_release(struct media_device *mdev)
 	__omap3isp_put(isp, false);
 
 	media_entity_enum_cleanup(&isp->crashed);
+
+	isp_put_clocks(isp);
+
+	kfree(isp);
 }
 
 static int isp_attach_iommu(struct isp_device *isp)
@@ -2210,7 +2223,7 @@ static int isp_probe(struct platform_device *pdev)
 	int ret;
 	int i, m;
 
-	isp = devm_kzalloc(&pdev->dev, sizeof(*isp), GFP_KERNEL);
+	isp = kzalloc(sizeof(*isp), GFP_KERNEL);
 	if (!isp) {
 		dev_err(&pdev->dev, "could not allocate memory\n");
 		return -ENOMEM;
@@ -2219,21 +2232,23 @@ static int isp_probe(struct platform_device *pdev)
 	ret = of_property_read_u32(pdev->dev.of_node, "ti,phy-type",
 				   &isp->phy_type);
 	if (ret)
-		return ret;
+		goto error_release_isp;
 
 	isp->syscon = syscon_regmap_lookup_by_phandle(pdev->dev.of_node,
 						      "syscon");
-	if (IS_ERR(isp->syscon))
-		return PTR_ERR(isp->syscon);
+	if (IS_ERR(isp->syscon)) {
+		ret = PTR_ERR(isp->syscon);
+		goto error_release_isp;
+	}
 
 	ret = of_property_read_u32_index(pdev->dev.of_node, "syscon", 1,
 					 &isp->syscon_offset);
 	if (ret)
-		return ret;
+		goto error_release_isp;
 
 	ret = isp_of_parse_nodes(&pdev->dev, &isp->notifier);
 	if (ret < 0)
-		return ret;
+		goto error_release_isp;
 
 	isp->autoidle = autoidle;
 
@@ -2250,8 +2265,8 @@ static int isp_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, isp);
 
 	/* Regulators */
-	isp->isp_csiphy1.vdd = devm_regulator_get(&pdev->dev, "vdd-csiphy1");
-	isp->isp_csiphy2.vdd = devm_regulator_get(&pdev->dev, "vdd-csiphy2");
+	isp->isp_csiphy1.vdd = regulator_get(&pdev->dev, "vdd-csiphy1");
+	isp->isp_csiphy2.vdd = regulator_get(&pdev->dev, "vdd-csiphy2");
 
 	/* Clocks
 	 *
@@ -2383,6 +2398,9 @@ error_isp:
 	__omap3isp_put(isp, false);
 error:
 	mutex_destroy(&isp->isp_mutex);
+	isp_put_clocks(isp);
+error_release_isp:
+	kfree(isp);
 
 	return ret;
 }
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index ca09523..d49ce8a 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -1135,7 +1135,7 @@ int omap3isp_ccp2_init(struct isp_device *isp)
 	 * TODO: Don't hardcode the usage of PHY1 (shared with CSI2c).
 	 */
 	if (isp->revision == ISP_REVISION_2_0) {
-		ccp2->vdds_csib = devm_regulator_get(isp->dev, "vdds_csib");
+		ccp2->vdds_csib = regulator_get(isp->dev, "vdds_csib");
 		if (IS_ERR(ccp2->vdds_csib)) {
 			dev_dbg(isp->dev,
 				"Could not get regulator vdds_csib\n");
@@ -1163,4 +1163,5 @@ void omap3isp_ccp2_cleanup(struct isp_device *isp)
 
 	omap3isp_video_cleanup(&ccp2->video_in);
 	media_entity_cleanup(&ccp2->subdev.entity);
+	regulator_put(ccp2->vdds_csib);
 }
diff --git a/drivers/media/platform/omap3isp/isph3a_aewb.c b/drivers/media/platform/omap3isp/isph3a_aewb.c
index ccaf92f..130df8b 100644
--- a/drivers/media/platform/omap3isp/isph3a_aewb.c
+++ b/drivers/media/platform/omap3isp/isph3a_aewb.c
@@ -289,9 +289,10 @@ int omap3isp_h3a_aewb_init(struct isp_device *isp)
 {
 	struct ispstat *aewb = &isp->isp_aewb;
 	struct omap3isp_h3a_aewb_config *aewb_cfg;
-	struct omap3isp_h3a_aewb_config *aewb_recover_cfg;
+	struct omap3isp_h3a_aewb_config *aewb_recover_cfg = NULL;
+	int ret;
 
-	aewb_cfg = devm_kzalloc(isp->dev, sizeof(*aewb_cfg), GFP_KERNEL);
+	aewb_cfg = kzalloc(sizeof(*aewb_cfg), GFP_KERNEL);
 	if (!aewb_cfg)
 		return -ENOMEM;
 
@@ -301,12 +302,12 @@ int omap3isp_h3a_aewb_init(struct isp_device *isp)
 	aewb->isp = isp;
 
 	/* Set recover state configuration */
-	aewb_recover_cfg = devm_kzalloc(isp->dev, sizeof(*aewb_recover_cfg),
-					GFP_KERNEL);
+	aewb_recover_cfg = kzalloc(sizeof(*aewb_recover_cfg), GFP_KERNEL);
 	if (!aewb_recover_cfg) {
 		dev_err(aewb->isp->dev, "AEWB: cannot allocate memory for "
 					"recover configuration.\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err;
 	}
 
 	aewb_recover_cfg->saturation_limit = OMAP3ISP_AEWB_MAX_SATURATION_LIM;
@@ -323,13 +324,20 @@ int omap3isp_h3a_aewb_init(struct isp_device *isp)
 	if (h3a_aewb_validate_params(aewb, aewb_recover_cfg)) {
 		dev_err(aewb->isp->dev, "AEWB: recover configuration is "
 					"invalid.\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
 	aewb_recover_cfg->buf_size = h3a_aewb_get_buf_size(aewb_recover_cfg);
 	aewb->recover_priv = aewb_recover_cfg;
 
 	return omap3isp_stat_init(aewb, "AEWB", &h3a_aewb_subdev_ops);
+
+err:
+	kfree(aewb_cfg);
+	kfree(aewb_recover_cfg);
+
+	return ret;
 }
 
 /*
diff --git a/drivers/media/platform/omap3isp/isph3a_af.c b/drivers/media/platform/omap3isp/isph3a_af.c
index 92937f7..7eecf97 100644
--- a/drivers/media/platform/omap3isp/isph3a_af.c
+++ b/drivers/media/platform/omap3isp/isph3a_af.c
@@ -352,9 +352,10 @@ int omap3isp_h3a_af_init(struct isp_device *isp)
 {
 	struct ispstat *af = &isp->isp_af;
 	struct omap3isp_h3a_af_config *af_cfg;
-	struct omap3isp_h3a_af_config *af_recover_cfg;
+	struct omap3isp_h3a_af_config *af_recover_cfg = NULL;
+	int ret;
 
-	af_cfg = devm_kzalloc(isp->dev, sizeof(*af_cfg), GFP_KERNEL);
+	af_cfg = kzalloc(sizeof(*af_cfg), GFP_KERNEL);
 	if (af_cfg == NULL)
 		return -ENOMEM;
 
@@ -364,12 +365,12 @@ int omap3isp_h3a_af_init(struct isp_device *isp)
 	af->isp = isp;
 
 	/* Set recover state configuration */
-	af_recover_cfg = devm_kzalloc(isp->dev, sizeof(*af_recover_cfg),
-				      GFP_KERNEL);
+	af_recover_cfg = kzalloc(sizeof(*af_recover_cfg), GFP_KERNEL);
 	if (!af_recover_cfg) {
 		dev_err(af->isp->dev, "AF: cannot allocate memory for recover "
 				      "configuration.\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err;
 	}
 
 	af_recover_cfg->paxel.h_start = OMAP3ISP_AF_PAXEL_HZSTART_MIN;
@@ -381,13 +382,20 @@ int omap3isp_h3a_af_init(struct isp_device *isp)
 	if (h3a_af_validate_params(af, af_recover_cfg)) {
 		dev_err(af->isp->dev, "AF: recover configuration is "
 				      "invalid.\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
 	af_recover_cfg->buf_size = h3a_af_get_buf_size(af_recover_cfg);
 	af->recover_priv = af_recover_cfg;
 
 	return omap3isp_stat_init(af, "AF", &h3a_af_subdev_ops);
+
+err:
+	kfree(af_cfg);
+	kfree(af_recover_cfg);
+
+	return ret;
 }
 
 void omap3isp_h3a_af_cleanup(struct isp_device *isp)
diff --git a/drivers/media/platform/omap3isp/isphist.c b/drivers/media/platform/omap3isp/isphist.c
index 7138b04..976cab0 100644
--- a/drivers/media/platform/omap3isp/isphist.c
+++ b/drivers/media/platform/omap3isp/isphist.c
@@ -477,9 +477,9 @@ int omap3isp_hist_init(struct isp_device *isp)
 {
 	struct ispstat *hist = &isp->isp_hist;
 	struct omap3isp_hist_config *hist_cfg;
-	int ret = -1;
+	int ret;
 
-	hist_cfg = devm_kzalloc(isp->dev, sizeof(*hist_cfg), GFP_KERNEL);
+	hist_cfg = kzalloc(sizeof(*hist_cfg), GFP_KERNEL);
 	if (hist_cfg == NULL)
 		return -ENOMEM;
 
@@ -517,6 +517,7 @@ int omap3isp_hist_init(struct isp_device *isp)
 	if (ret) {
 		if (hist->dma_ch)
 			dma_release_channel(hist->dma_ch);
+		kfree(hist_cfg);
 	}
 
 	return ret;
diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index 1b9217d..1c1365f 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -1059,4 +1059,6 @@ void omap3isp_stat_cleanup(struct ispstat *stat)
 	mutex_destroy(&stat->ioctl_lock);
 	isp_stat_bufs_free(stat);
 	kfree(stat->buf);
+	kfree(stat->priv);
+	kfree(stat->recover_priv);
 }
-- 
2.1.4

