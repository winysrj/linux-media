Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46462 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751267AbdGMPXw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 11:23:52 -0400
Received: from lanttu.localdomain (unknown [IPv6:2001:1bc8:1a6:d3d5::e1:1001])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 99530600C7
        for <linux-media@vger.kernel.org>; Thu, 13 Jul 2017 18:23:48 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 1/6] omap3isp: Don't rely on devm for memory resource management
Date: Thu, 13 Jul 2017 18:23:44 +0300
Message-Id: <20170713152349.14480-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20170713152349.14480-1-sakari.ailus@linux.intel.com>
References: <20170713152349.14480-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm functions are fine for managing resources that are directly related
to the device at hand and that have no other dependencies. However, a
process holding a file handle to a device created by a driver for a device
may result in the file handle left behind after the device is long gone.
This will result in accessing released (and potentially reallocated)
memory.

Instead, manage the memory resources in the driver. Releasing the
resources can be later on bound to e.g. by releasing a reference.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isp.c         | 18 ++++++++++++------
 drivers/media/platform/omap3isp/isph3a_aewb.c | 24 +++++++++++++++++-------
 drivers/media/platform/omap3isp/isph3a_af.c   | 24 +++++++++++++++++-------
 drivers/media/platform/omap3isp/isphist.c     | 11 +++++++----
 drivers/media/platform/omap3isp/ispstat.c     |  2 ++
 5 files changed, 55 insertions(+), 24 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 9df64c189883..a03f8b9f8763 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1999,6 +1999,8 @@ static int isp_remove(struct platform_device *pdev)
 
 	media_entity_enum_cleanup(&isp->crashed);
 
+	kfree(isp);
+
 	return 0;
 }
 
@@ -2189,7 +2191,7 @@ static int isp_probe(struct platform_device *pdev)
 	int ret;
 	int i, m;
 
-	isp = devm_kzalloc(&pdev->dev, sizeof(*isp), GFP_KERNEL);
+	isp = kzalloc(sizeof(*isp), GFP_KERNEL);
 	if (!isp) {
 		dev_err(&pdev->dev, "could not allocate memory\n");
 		return -ENOMEM;
@@ -2198,21 +2200,23 @@ static int isp_probe(struct platform_device *pdev)
 	ret = fwnode_property_read_u32(of_fwnode_handle(pdev->dev.of_node),
 				       "ti,phy-type", &isp->phy_type);
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
 
 	ret = of_property_read_u32_index(pdev->dev.of_node,
 					 "syscon", 1, &isp->syscon_offset);
 	if (ret)
-		return ret;
+		goto error_release_isp;
 
 	ret = isp_fwnodes_parse(&pdev->dev, &isp->notifier);
 	if (ret < 0)
-		return ret;
+		goto error_release_isp;
 
 	isp->autoidle = autoidle;
 
@@ -2362,6 +2366,8 @@ static int isp_probe(struct platform_device *pdev)
 	__omap3isp_put(isp, false);
 error:
 	mutex_destroy(&isp->isp_mutex);
+error_release_isp:
+	kfree(isp);
 
 	return ret;
 }
diff --git a/drivers/media/platform/omap3isp/isph3a_aewb.c b/drivers/media/platform/omap3isp/isph3a_aewb.c
index d44626f20ac6..efddafdb999d 100644
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
 		dev_err(aewb->isp->dev,
 			"AEWB: cannot allocate memory for recover configuration.\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err;
 	}
 
 	aewb_recover_cfg->saturation_limit = OMAP3ISP_AEWB_MAX_SATURATION_LIM;
@@ -323,13 +324,22 @@ int omap3isp_h3a_aewb_init(struct isp_device *isp)
 	if (h3a_aewb_validate_params(aewb, aewb_recover_cfg)) {
 		dev_err(aewb->isp->dev,
 			"AEWB: recover configuration is invalid.\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
 	aewb_recover_cfg->buf_size = h3a_aewb_get_buf_size(aewb_recover_cfg);
 	aewb->recover_priv = aewb_recover_cfg;
 
-	return omap3isp_stat_init(aewb, "AEWB", &h3a_aewb_subdev_ops);
+	ret = omap3isp_stat_init(aewb, "AEWB", &h3a_aewb_subdev_ops);
+
+err:
+	if (ret) {
+		kfree(aewb_cfg);
+		kfree(aewb_recover_cfg);
+	}
+
+	return ret;
 }
 
 /*
diff --git a/drivers/media/platform/omap3isp/isph3a_af.c b/drivers/media/platform/omap3isp/isph3a_af.c
index 99bd6cc21d86..fee3d19f94f8 100644
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
 		dev_err(af->isp->dev,
 			"AF: cannot allocate memory for recover configuration.\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err;
 	}
 
 	af_recover_cfg->paxel.h_start = OMAP3ISP_AF_PAXEL_HZSTART_MIN;
@@ -381,13 +382,22 @@ int omap3isp_h3a_af_init(struct isp_device *isp)
 	if (h3a_af_validate_params(af, af_recover_cfg)) {
 		dev_err(af->isp->dev,
 			"AF: recover configuration is invalid.\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
 	af_recover_cfg->buf_size = h3a_af_get_buf_size(af_recover_cfg);
 	af->recover_priv = af_recover_cfg;
 
-	return omap3isp_stat_init(af, "AF", &h3a_af_subdev_ops);
+	ret = omap3isp_stat_init(af, "AF", &h3a_af_subdev_ops);
+
+err:
+	if (ret) {
+		kfree(af_cfg);
+		kfree(af_recover_cfg);
+	}
+
+	return ret;
 }
 
 void omap3isp_h3a_af_cleanup(struct isp_device *isp)
diff --git a/drivers/media/platform/omap3isp/isphist.c b/drivers/media/platform/omap3isp/isphist.c
index a4ed5d140d48..9df15ad75f71 100644
--- a/drivers/media/platform/omap3isp/isphist.c
+++ b/drivers/media/platform/omap3isp/isphist.c
@@ -476,9 +476,9 @@ int omap3isp_hist_init(struct isp_device *isp)
 {
 	struct ispstat *hist = &isp->isp_hist;
 	struct omap3isp_hist_config *hist_cfg;
-	int ret = -1;
+	int ret;
 
-	hist_cfg = devm_kzalloc(isp->dev, sizeof(*hist_cfg), GFP_KERNEL);
+	hist_cfg = kzalloc(sizeof(*hist_cfg), GFP_KERNEL);
 	if (hist_cfg == NULL)
 		return -ENOMEM;
 
@@ -500,7 +500,7 @@ int omap3isp_hist_init(struct isp_device *isp)
 		if (IS_ERR(hist->dma_ch)) {
 			ret = PTR_ERR(hist->dma_ch);
 			if (ret == -EPROBE_DEFER)
-				return ret;
+				goto err;
 
 			hist->dma_ch = NULL;
 			dev_warn(isp->dev,
@@ -516,9 +516,12 @@ int omap3isp_hist_init(struct isp_device *isp)
 	hist->event_type = V4L2_EVENT_OMAP3ISP_HIST;
 
 	ret = omap3isp_stat_init(hist, "histogram", &hist_subdev_ops);
+
+err:
 	if (ret) {
-		if (hist->dma_ch)
+		if (!IS_ERR_OR_NULL(hist->dma_ch))
 			dma_release_channel(hist->dma_ch);
+		kfree(hist_cfg);
 	}
 
 	return ret;
diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index 47cbc7e3d825..aad0bc30762c 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -1067,4 +1067,6 @@ void omap3isp_stat_cleanup(struct ispstat *stat)
 	mutex_destroy(&stat->ioctl_lock);
 	isp_stat_bufs_free(stat);
 	kfree(stat->buf);
+	kfree(stat->priv);
+	kfree(stat->recover_priv);
 }
-- 
2.11.0
