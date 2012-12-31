Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41441 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab2LaQ2g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Dec 2012 11:28:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 2/2] omap3isp: Use devm_* managed functions
Date: Mon, 31 Dec 2012 17:29:55 +0100
Message-Id: <1356971395-3135-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1356971395-3135-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1356971395-3135-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace kzalloc, request_mem_region, ioremap, clk_get and regulator_get
with their devm_* managed replacement.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isp.c         |   74 ++++---------------------
 drivers/media/platform/omap3isp/ispccp2.c     |    8 +--
 drivers/media/platform/omap3isp/isph3a_aewb.c |   27 ++-------
 drivers/media/platform/omap3isp/isph3a_af.c   |   27 ++-------
 drivers/media/platform/omap3isp/isphist.c     |    4 +-
 5 files changed, 27 insertions(+), 113 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index a9f6de5..50cea08 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1408,28 +1408,15 @@ static const char *isp_clocks[] = {
 	"l3_ick",
 };
 
-static void isp_put_clocks(struct isp_device *isp)
-{
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(isp_clocks); ++i) {
-		if (isp->clock[i]) {
-			clk_put(isp->clock[i]);
-			isp->clock[i] = NULL;
-		}
-	}
-}
-
 static int isp_get_clocks(struct isp_device *isp)
 {
 	struct clk *clk;
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(isp_clocks); ++i) {
-		clk = clk_get(isp->dev, isp_clocks[i]);
+		clk = devm_clk_get(isp->dev, isp_clocks[i]);
 		if (IS_ERR(clk)) {
 			dev_err(isp->dev, "clk_get %s failed\n", isp_clocks[i]);
-			isp_put_clocks(isp);
 			return PTR_ERR(clk);
 		}
 
@@ -1995,7 +1982,6 @@ error_csiphy:
 static int __devexit isp_remove(struct platform_device *pdev)
 {
 	struct isp_device *isp = platform_get_drvdata(pdev);
-	int i;
 
 	isp_unregister_entities(isp);
 	isp_cleanup_modules(isp);
@@ -2006,26 +1992,6 @@ static int __devexit isp_remove(struct platform_device *pdev)
 	isp->domain = NULL;
 	omap3isp_put(isp);
 
-	free_irq(isp->irq_num, isp);
-	isp_put_clocks(isp);
-
-	for (i = 0; i < OMAP3_ISP_IOMEM_LAST; i++) {
-		if (isp->mmio_base[i]) {
-			iounmap(isp->mmio_base[i]);
-			isp->mmio_base[i] = NULL;
-		}
-
-		if (isp->mmio_base_phys[i]) {
-			release_mem_region(isp->mmio_base_phys[i],
-					   isp->mmio_size[i]);
-			isp->mmio_base_phys[i] = 0;
-		}
-	}
-
-	regulator_put(isp->isp_csiphy1.vdd);
-	regulator_put(isp->isp_csiphy2.vdd);
-	kfree(isp);
-
 	return 0;
 }
 
@@ -2043,7 +2009,8 @@ static int isp_map_mem_resource(struct platform_device *pdev,
 		return -ENODEV;
 	}
 
-	if (!request_mem_region(mem->start, resource_size(mem), pdev->name)) {
+	if (!devm_request_mem_region(isp->dev, mem->start, resource_size(mem),
+				     pdev->name)) {
 		dev_err(isp->dev,
 			"cannot reserve camera register I/O region\n");
 		return -ENODEV;
@@ -2052,8 +2019,9 @@ static int isp_map_mem_resource(struct platform_device *pdev,
 	isp->mmio_size[res] = resource_size(mem);
 
 	/* map the region */
-	isp->mmio_base[res] = ioremap_nocache(isp->mmio_base_phys[res],
-					      isp->mmio_size[res]);
+	isp->mmio_base[res] = devm_ioremap_nocache(isp->dev,
+						   isp->mmio_base_phys[res],
+						   isp->mmio_size[res]);
 	if (!isp->mmio_base[res]) {
 		dev_err(isp->dev, "cannot map camera register I/O region\n");
 		return -ENODEV;
@@ -2083,7 +2051,7 @@ static int __devinit isp_probe(struct platform_device *pdev)
 	if (pdata == NULL)
 		return -EINVAL;
 
-	isp = kzalloc(sizeof(*isp), GFP_KERNEL);
+	isp = devm_kzalloc(&pdev->dev, sizeof(*isp), GFP_KERNEL);
 	if (!isp) {
 		dev_err(&pdev->dev, "could not allocate memory\n");
 		return -ENOMEM;
@@ -2106,8 +2074,8 @@ static int __devinit isp_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, isp);
 
 	/* Regulators */
-	isp->isp_csiphy1.vdd = regulator_get(&pdev->dev, "VDD_CSIPHY1");
-	isp->isp_csiphy2.vdd = regulator_get(&pdev->dev, "VDD_CSIPHY2");
+	isp->isp_csiphy1.vdd = devm_regulator_get(&pdev->dev, "VDD_CSIPHY1");
+	isp->isp_csiphy2.vdd = devm_regulator_get(&pdev->dev, "VDD_CSIPHY2");
 
 	/* Clocks
 	 *
@@ -2182,7 +2150,8 @@ static int __devinit isp_probe(struct platform_device *pdev)
 		goto detach_dev;
 	}
 
-	if (request_irq(isp->irq_num, isp_isr, IRQF_SHARED, "OMAP3 ISP", isp)) {
+	if (devm_request_irq(isp->dev, isp->irq_num, isp_isr, IRQF_SHARED,
+			     "OMAP3 ISP", isp)) {
 		dev_err(isp->dev, "Unable to request IRQ\n");
 		ret = -EINVAL;
 		goto detach_dev;
@@ -2191,7 +2160,7 @@ static int __devinit isp_probe(struct platform_device *pdev)
 	/* Entities */
 	ret = isp_initialize_modules(isp);
 	if (ret < 0)
-		goto error_irq;
+		goto detach_dev;
 
 	ret = isp_register_entities(isp);
 	if (ret < 0)
@@ -2204,8 +2173,6 @@ static int __devinit isp_probe(struct platform_device *pdev)
 
 error_modules:
 	isp_cleanup_modules(isp);
-error_irq:
-	free_irq(isp->irq_num, isp);
 detach_dev:
 	iommu_detach_device(isp->domain, &pdev->dev);
 free_domain:
@@ -2213,26 +2180,9 @@ free_domain:
 error_isp:
 	omap3isp_put(isp);
 error:
-	isp_put_clocks(isp);
-
-	for (i = 0; i < OMAP3_ISP_IOMEM_LAST; i++) {
-		if (isp->mmio_base[i]) {
-			iounmap(isp->mmio_base[i]);
-			isp->mmio_base[i] = NULL;
-		}
-
-		if (isp->mmio_base_phys[i]) {
-			release_mem_region(isp->mmio_base_phys[i],
-					   isp->mmio_size[i]);
-			isp->mmio_base_phys[i] = 0;
-		}
-	}
-	regulator_put(isp->isp_csiphy2.vdd);
-	regulator_put(isp->isp_csiphy1.vdd);
 	platform_set_drvdata(pdev, NULL);
 
 	mutex_destroy(&isp->isp_mutex);
-	kfree(isp);
 
 	return ret;
 }
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index 85f0de8..c5d84c9 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -1136,7 +1136,7 @@ int omap3isp_ccp2_init(struct isp_device *isp)
 	 * TODO: Don't hardcode the usage of PHY1 (shared with CSI2c).
 	 */
 	if (isp->revision == ISP_REVISION_2_0) {
-		ccp2->vdds_csib = regulator_get(isp->dev, "vdds_csib");
+		ccp2->vdds_csib = devm_regulator_get(isp->dev, "vdds_csib");
 		if (IS_ERR(ccp2->vdds_csib)) {
 			dev_dbg(isp->dev,
 				"Could not get regulator vdds_csib\n");
@@ -1147,10 +1147,8 @@ int omap3isp_ccp2_init(struct isp_device *isp)
 	}
 
 	ret = ccp2_init_entities(ccp2);
-	if (ret < 0) {
-		regulator_put(ccp2->vdds_csib);
+	if (ret < 0)
 		return ret;
-	}
 
 	ccp2_reset(ccp2);
 	return 0;
@@ -1166,6 +1164,4 @@ void omap3isp_ccp2_cleanup(struct isp_device *isp)
 
 	omap3isp_video_cleanup(&ccp2->video_in);
 	media_entity_cleanup(&ccp2->subdev.entity);
-
-	regulator_put(ccp2->vdds_csib);
 }
diff --git a/drivers/media/platform/omap3isp/isph3a_aewb.c b/drivers/media/platform/omap3isp/isph3a_aewb.c
index 1b908fd..75fd82b 100644
--- a/drivers/media/platform/omap3isp/isph3a_aewb.c
+++ b/drivers/media/platform/omap3isp/isph3a_aewb.c
@@ -300,9 +300,8 @@ int omap3isp_h3a_aewb_init(struct isp_device *isp)
 	struct ispstat *aewb = &isp->isp_aewb;
 	struct omap3isp_h3a_aewb_config *aewb_cfg;
 	struct omap3isp_h3a_aewb_config *aewb_recover_cfg;
-	int ret;
 
-	aewb_cfg = kzalloc(sizeof(*aewb_cfg), GFP_KERNEL);
+	aewb_cfg = devm_kzalloc(isp->dev, sizeof(*aewb_cfg), GFP_KERNEL);
 	if (!aewb_cfg)
 		return -ENOMEM;
 
@@ -313,12 +312,12 @@ int omap3isp_h3a_aewb_init(struct isp_device *isp)
 	aewb->isp = isp;
 
 	/* Set recover state configuration */
-	aewb_recover_cfg = kzalloc(sizeof(*aewb_recover_cfg), GFP_KERNEL);
+	aewb_recover_cfg = devm_kzalloc(isp->dev, sizeof(*aewb_recover_cfg),
+					GFP_KERNEL);
 	if (!aewb_recover_cfg) {
 		dev_err(aewb->isp->dev, "AEWB: cannot allocate memory for "
 					"recover configuration.\n");
-		ret = -ENOMEM;
-		goto err_recover_alloc;
+		return -ENOMEM;
 	}
 
 	aewb_recover_cfg->saturation_limit = OMAP3ISP_AEWB_MAX_SATURATION_LIM;
@@ -335,25 +334,13 @@ int omap3isp_h3a_aewb_init(struct isp_device *isp)
 	if (h3a_aewb_validate_params(aewb, aewb_recover_cfg)) {
 		dev_err(aewb->isp->dev, "AEWB: recover configuration is "
 					"invalid.\n");
-		ret = -EINVAL;
-		goto err_conf;
+		return -EINVAL;
 	}
 
 	aewb_recover_cfg->buf_size = h3a_aewb_get_buf_size(aewb_recover_cfg);
 	aewb->recover_priv = aewb_recover_cfg;
 
-	ret = omap3isp_stat_init(aewb, "AEWB", &h3a_aewb_subdev_ops);
-	if (ret)
-		goto err_conf;
-
-	return 0;
-
-err_conf:
-	kfree(aewb_recover_cfg);
-err_recover_alloc:
-	kfree(aewb_cfg);
-
-	return ret;
+	return omap3isp_stat_init(aewb, "AEWB", &h3a_aewb_subdev_ops);
 }
 
 /*
@@ -361,7 +348,5 @@ err_recover_alloc:
  */
 void omap3isp_h3a_aewb_cleanup(struct isp_device *isp)
 {
-	kfree(isp->isp_aewb.priv);
-	kfree(isp->isp_aewb.recover_priv);
 	omap3isp_stat_cleanup(&isp->isp_aewb);
 }
diff --git a/drivers/media/platform/omap3isp/isph3a_af.c b/drivers/media/platform/omap3isp/isph3a_af.c
index d645b41..a0bf5af 100644
--- a/drivers/media/platform/omap3isp/isph3a_af.c
+++ b/drivers/media/platform/omap3isp/isph3a_af.c
@@ -363,9 +363,8 @@ int omap3isp_h3a_af_init(struct isp_device *isp)
 	struct ispstat *af = &isp->isp_af;
 	struct omap3isp_h3a_af_config *af_cfg;
 	struct omap3isp_h3a_af_config *af_recover_cfg;
-	int ret;
 
-	af_cfg = kzalloc(sizeof(*af_cfg), GFP_KERNEL);
+	af_cfg = devm_kzalloc(isp->dev, sizeof(*af_cfg), GFP_KERNEL);
 	if (af_cfg == NULL)
 		return -ENOMEM;
 
@@ -376,12 +375,12 @@ int omap3isp_h3a_af_init(struct isp_device *isp)
 	af->isp = isp;
 
 	/* Set recover state configuration */
-	af_recover_cfg = kzalloc(sizeof(*af_recover_cfg), GFP_KERNEL);
+	af_recover_cfg = devm_kzalloc(isp->dev, sizeof(*af_recover_cfg),
+				      GFP_KERNEL);
 	if (!af_recover_cfg) {
 		dev_err(af->isp->dev, "AF: cannot allocate memory for recover "
 				      "configuration.\n");
-		ret = -ENOMEM;
-		goto err_recover_alloc;
+		return -ENOMEM;
 	}
 
 	af_recover_cfg->paxel.h_start = OMAP3ISP_AF_PAXEL_HZSTART_MIN;
@@ -393,30 +392,16 @@ int omap3isp_h3a_af_init(struct isp_device *isp)
 	if (h3a_af_validate_params(af, af_recover_cfg)) {
 		dev_err(af->isp->dev, "AF: recover configuration is "
 				      "invalid.\n");
-		ret = -EINVAL;
-		goto err_conf;
+		return -EINVAL;
 	}
 
 	af_recover_cfg->buf_size = h3a_af_get_buf_size(af_recover_cfg);
 	af->recover_priv = af_recover_cfg;
 
-	ret = omap3isp_stat_init(af, "AF", &h3a_af_subdev_ops);
-	if (ret)
-		goto err_conf;
-
-	return 0;
-
-err_conf:
-	kfree(af_recover_cfg);
-err_recover_alloc:
-	kfree(af_cfg);
-
-	return ret;
+	return omap3isp_stat_init(af, "AF", &h3a_af_subdev_ops);
 }
 
 void omap3isp_h3a_af_cleanup(struct isp_device *isp)
 {
-	kfree(isp->isp_af.priv);
-	kfree(isp->isp_af.recover_priv);
 	omap3isp_stat_cleanup(&isp->isp_af);
 }
diff --git a/drivers/media/platform/omap3isp/isphist.c b/drivers/media/platform/omap3isp/isphist.c
index da2fa98..2ccc4e5 100644
--- a/drivers/media/platform/omap3isp/isphist.c
+++ b/drivers/media/platform/omap3isp/isphist.c
@@ -477,7 +477,7 @@ int omap3isp_hist_init(struct isp_device *isp)
 	struct omap3isp_hist_config *hist_cfg;
 	int ret = -1;
 
-	hist_cfg = kzalloc(sizeof(*hist_cfg), GFP_KERNEL);
+	hist_cfg = devm_kzalloc(isp->dev, sizeof(*hist_cfg), GFP_KERNEL);
 	if (hist_cfg == NULL)
 		return -ENOMEM;
 
@@ -503,7 +503,6 @@ int omap3isp_hist_init(struct isp_device *isp)
 
 	ret = omap3isp_stat_init(hist, "histogram", &hist_subdev_ops);
 	if (ret) {
-		kfree(hist_cfg);
 		if (HIST_USING_DMA(hist))
 			omap_free_dma(hist->dma_ch);
 	}
@@ -518,6 +517,5 @@ void omap3isp_hist_cleanup(struct isp_device *isp)
 {
 	if (HIST_USING_DMA(&isp->isp_hist))
 		omap_free_dma(isp->isp_hist.dma_ch);
-	kfree(isp->isp_hist.priv);
 	omap3isp_stat_cleanup(&isp->isp_hist);
 }
-- 
1.7.8.6

