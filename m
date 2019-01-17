Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE481C43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 05:39:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB2E920855
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 05:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729445AbfAQFji (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 00:39:38 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:3105 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727092AbfAQFji (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 00:39:38 -0500
X-UUID: 17628394146f44d18300814e5f48df33-20190117
X-UUID: 17628394146f44d18300814e5f48df33-20190117
Received: from mtkmrs01.mediatek.inc [(172.21.131.159)] by mailgw01.mediatek.com
        (envelope-from <yunfei.dong@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 204710703; Thu, 17 Jan 2019 13:39:29 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 17 Jan 2019 13:39:27 +0800
Received: from localhost.localdomain (10.17.3.153) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 17 Jan 2019 13:39:26 +0800
From:   Yunfei Dong <yunfei.dong@mediatek.com>
To:     Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>
CC:     Yunfei Dong <yunfei.dong@mediatek.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Qianqian Yan <qianqian.yan@mediatek.com>
Subject: [PATCH v3,3/3] media: mtk-vcodec: Using common interface to manage vdec/venc clock
Date:   Thu, 17 Jan 2019 13:39:20 +0800
Message-ID: <1547703560-16195-3-git-send-email-yunfei.dong@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1547703560-16195-1-git-send-email-yunfei.dong@mediatek.com>
References: <1547703560-16195-1-git-send-email-yunfei.dong@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 6AFFFEC376B568CD0E6BA01E01755D6CAA95744F3EAE6E9F370E8DF0A9A1F9522000:8
X-MTK:  N
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Vdec: Using standard CCF interface to set parent clock and
clock rate in dtsi and using common interface to open/close
video decoder clock.
Venc: Using standard CCF interface to set parent clock in dtsi
and using common interface to open/close video encoder clock.

Signed-off-by: Yunfei Dong <yunfei.dong@mediatek.com>
Signed-off-by: Qianqian Yan <qianqian.yan@mediatek.com>
---
 .../platform/mtk-vcodec/mtk_vcodec_dec_pm.c   | 163 ++++++------------
 .../platform/mtk-vcodec/mtk_vcodec_drv.h      |  31 ++--
 .../platform/mtk-vcodec/mtk_vcodec_enc_pm.c   | 104 ++++++-----
 3 files changed, 132 insertions(+), 166 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c
index 79ca03ac449c..7884465afcd2 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c
@@ -27,11 +27,14 @@ int mtk_vcodec_init_dec_pm(struct mtk_vcodec_dev *mtkdev)
 	struct device_node *node;
 	struct platform_device *pdev;
 	struct mtk_vcodec_pm *pm;
-	int ret = 0;
+	struct mtk_vcodec_clk *dec_clk;
+	struct mtk_vcodec_clk_info *clk_info;
+	int i = 0, ret = 0;
 
 	pdev = mtkdev->plat_dev;
 	pm = &mtkdev->pm;
 	pm->mtkdev = mtkdev;
+	dec_clk = &pm->vdec_clk;
 	node = of_parse_phandle(pdev->dev.of_node, "mediatek,larb", 0);
 	if (!node) {
 		mtk_v4l2_err("of_parse_phandle mediatek,larb fail!");
@@ -47,52 +50,34 @@ int mtk_vcodec_init_dec_pm(struct mtk_vcodec_dev *mtkdev)
 	pdev = mtkdev->plat_dev;
 	pm->dev = &pdev->dev;
 
-	pm->vcodecpll = devm_clk_get(&pdev->dev, "vcodecpll");
-	if (IS_ERR(pm->vcodecpll)) {
-		mtk_v4l2_err("devm_clk_get vcodecpll fail");
-		ret = PTR_ERR(pm->vcodecpll);
+	dec_clk->clk_num =
+		of_property_count_strings(pdev->dev.of_node, "clock-names");
+	if (dec_clk->clk_num > 0) {
+		dec_clk->clk_info = devm_kcalloc(&pdev->dev,
+			dec_clk->clk_num, sizeof(*clk_info),
+			GFP_KERNEL);
+		if (!dec_clk->clk_info)
+			return -ENOMEM;
+	} else {
+		mtk_v4l2_err("Failed to get vdec clock count");
+		return -EINVAL;
 	}
 
-	pm->univpll_d2 = devm_clk_get(&pdev->dev, "univpll_d2");
-	if (IS_ERR(pm->univpll_d2)) {
-		mtk_v4l2_err("devm_clk_get univpll_d2 fail");
-		ret = PTR_ERR(pm->univpll_d2);
-	}
-
-	pm->clk_cci400_sel = devm_clk_get(&pdev->dev, "clk_cci400_sel");
-	if (IS_ERR(pm->clk_cci400_sel)) {
-		mtk_v4l2_err("devm_clk_get clk_cci400_sel fail");
-		ret = PTR_ERR(pm->clk_cci400_sel);
-	}
-
-	pm->vdec_sel = devm_clk_get(&pdev->dev, "vdec_sel");
-	if (IS_ERR(pm->vdec_sel)) {
-		mtk_v4l2_err("devm_clk_get vdec_sel fail");
-		ret = PTR_ERR(pm->vdec_sel);
-	}
-
-	pm->vdecpll = devm_clk_get(&pdev->dev, "vdecpll");
-	if (IS_ERR(pm->vdecpll)) {
-		mtk_v4l2_err("devm_clk_get vdecpll fail");
-		ret = PTR_ERR(pm->vdecpll);
-	}
-
-	pm->vencpll = devm_clk_get(&pdev->dev, "vencpll");
-	if (IS_ERR(pm->vencpll)) {
-		mtk_v4l2_err("devm_clk_get vencpll fail");
-		ret = PTR_ERR(pm->vencpll);
-	}
-
-	pm->venc_lt_sel = devm_clk_get(&pdev->dev, "venc_lt_sel");
-	if (IS_ERR(pm->venc_lt_sel)) {
-		mtk_v4l2_err("devm_clk_get venc_lt_sel fail");
-		ret = PTR_ERR(pm->venc_lt_sel);
-	}
-
-	pm->vdec_bus_clk_src = devm_clk_get(&pdev->dev, "vdec_bus_clk_src");
-	if (IS_ERR(pm->vdec_bus_clk_src)) {
-		mtk_v4l2_err("devm_clk_get vdec_bus_clk_src");
-		ret = PTR_ERR(pm->vdec_bus_clk_src);
+	for (i = 0; i < dec_clk->clk_num; i++) {
+		clk_info = &dec_clk->clk_info[i];
+		ret = of_property_read_string_index(pdev->dev.of_node,
+			"clock-names", i, &clk_info->clk_name);
+		if (ret) {
+			mtk_v4l2_err("Failed to get clock name id = %d", i);
+			return ret;
+		}
+		clk_info->vcodec_clk = devm_clk_get(&pdev->dev,
+			clk_info->clk_name);
+		if (IS_ERR(clk_info->vcodec_clk)) {
+			mtk_v4l2_err("devm_clk_get (%d)%s fail", i,
+				clk_info->clk_name);
+			return PTR_ERR(clk_info->vcodec_clk);
+		}
 	}
 
 	pm_runtime_enable(&pdev->dev);
@@ -125,78 +110,36 @@ void mtk_vcodec_dec_pw_off(struct mtk_vcodec_pm *pm)
 
 void mtk_vcodec_dec_clock_on(struct mtk_vcodec_pm *pm)
 {
-	int ret;
-
-	ret = clk_set_rate(pm->vcodecpll, 1482 * 1000000);
-	if (ret)
-		mtk_v4l2_err("clk_set_rate vcodecpll fail %d", ret);
-
-	ret = clk_set_rate(pm->vencpll, 800 * 1000000);
-	if (ret)
-		mtk_v4l2_err("clk_set_rate vencpll fail %d", ret);
-
-	ret = clk_prepare_enable(pm->vcodecpll);
-	if (ret)
-		mtk_v4l2_err("clk_prepare_enable vcodecpll fail %d", ret);
-
-	ret = clk_prepare_enable(pm->vencpll);
-	if (ret)
-		mtk_v4l2_err("clk_prepare_enable vencpll fail %d", ret);
-
-	ret = clk_prepare_enable(pm->vdec_bus_clk_src);
-	if (ret)
-		mtk_v4l2_err("clk_prepare_enable vdec_bus_clk_src fail %d",
-				ret);
-
-	ret = clk_prepare_enable(pm->venc_lt_sel);
-	if (ret)
-		mtk_v4l2_err("clk_prepare_enable venc_lt_sel fail %d", ret);
-
-	ret = clk_set_parent(pm->venc_lt_sel, pm->vdec_bus_clk_src);
-	if (ret)
-		mtk_v4l2_err("clk_set_parent venc_lt_sel vdec_bus_clk_src fail %d",
-				ret);
-
-	ret = clk_prepare_enable(pm->univpll_d2);
-	if (ret)
-		mtk_v4l2_err("clk_prepare_enable univpll_d2 fail %d", ret);
-
-	ret = clk_prepare_enable(pm->clk_cci400_sel);
-	if (ret)
-		mtk_v4l2_err("clk_prepare_enable clk_cci400_sel fail %d", ret);
-
-	ret = clk_set_parent(pm->clk_cci400_sel, pm->univpll_d2);
-	if (ret)
-		mtk_v4l2_err("clk_set_parent clk_cci400_sel univpll_d2 fail %d",
-				ret);
-
-	ret = clk_prepare_enable(pm->vdecpll);
-	if (ret)
-		mtk_v4l2_err("clk_prepare_enable vdecpll fail %d", ret);
-
-	ret = clk_prepare_enable(pm->vdec_sel);
-	if (ret)
-		mtk_v4l2_err("clk_prepare_enable vdec_sel fail %d", ret);
-
-	ret = clk_set_parent(pm->vdec_sel, pm->vdecpll);
-	if (ret)
-		mtk_v4l2_err("clk_set_parent vdec_sel vdecpll fail %d", ret);
+	struct mtk_vcodec_clk *dec_clk = &pm->vdec_clk;
+	int ret, i = 0;
+
+	for (i = 0; i < dec_clk->clk_num; i++) {
+		ret = clk_prepare_enable(dec_clk->clk_info[i].vcodec_clk);
+		if (ret) {
+			mtk_v4l2_err("clk_prepare_enable %d %s fail %d", i,
+				dec_clk->clk_info[i].clk_name, ret);
+			goto error;
+		}
+	}
 
 	ret = mtk_smi_larb_get(pm->larbvdec);
-	if (ret)
+	if (ret) {
 		mtk_v4l2_err("mtk_smi_larb_get larbvdec fail %d", ret);
+		goto error;
+	}
+	return;
 
+error:
+	for (i -= 1; i >= 0; i--)
+		clk_disable_unprepare(dec_clk->clk_info[i].vcodec_clk);
 }
 
 void mtk_vcodec_dec_clock_off(struct mtk_vcodec_pm *pm)
 {
+	struct mtk_vcodec_clk *dec_clk = &pm->vdec_clk;
+	int i = 0;
+
 	mtk_smi_larb_put(pm->larbvdec);
-	clk_disable_unprepare(pm->vdec_sel);
-	clk_disable_unprepare(pm->vdecpll);
-	clk_disable_unprepare(pm->univpll_d2);
-	clk_disable_unprepare(pm->clk_cci400_sel);
-	clk_disable_unprepare(pm->venc_lt_sel);
-	clk_disable_unprepare(pm->vdec_bus_clk_src);
-	clk_disable_unprepare(pm->vencpll);
-	clk_disable_unprepare(pm->vcodecpll);
+	for (i = dec_clk->clk_num - 1; i >= 0; i--)
+		clk_disable_unprepare(dec_clk->clk_info[i].vcodec_clk);
 }
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
index 3cffb381ac8e..8aba69555b12 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
@@ -175,23 +175,30 @@ struct mtk_enc_params {
 	unsigned int	force_intra;
 };
 
+/**
+ * struct mtk_vcodec_clk_info - Structure used to store clock name
+ */
+struct mtk_vcodec_clk_info {
+	const char	*clk_name;
+	struct clk	*vcodec_clk;
+};
+
+/**
+ * struct mtk_vcodec_clk - Structure used to store vcodec clock information
+ */
+struct mtk_vcodec_clk {
+	struct mtk_vcodec_clk_info	*clk_info;
+	int	clk_num;
+};
+
 /**
  * struct mtk_vcodec_pm - Power management data structure
  */
 struct mtk_vcodec_pm {
-	struct clk	*vdec_bus_clk_src;
-	struct clk	*vencpll;
-
-	struct clk	*vcodecpll;
-	struct clk	*univpll_d2;
-	struct clk	*clk_cci400_sel;
-	struct clk	*vdecpll;
-	struct clk	*vdec_sel;
-	struct clk	*vencpll_d2;
-	struct clk	*venc_sel;
-	struct clk	*univpll1_d2;
-	struct clk	*venc_lt_sel;
+	struct mtk_vcodec_clk	vdec_clk;
 	struct device	*larbvdec;
+
+	struct mtk_vcodec_clk	venc_clk;
 	struct device	*larbvenc;
 	struct device	*larbvenclt;
 	struct device	*dev;
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c
index 7c025045ea90..39375b8ea27c 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c
@@ -27,9 +27,11 @@ int mtk_vcodec_init_enc_pm(struct mtk_vcodec_dev *mtkdev)
 {
 	struct device_node *node;
 	struct platform_device *pdev;
-	struct device *dev;
 	struct mtk_vcodec_pm *pm;
-	int ret = 0;
+	struct mtk_vcodec_clk *enc_clk;
+	struct mtk_vcodec_clk_info *clk_info;
+	int ret = 0, i = 0;
+	struct device *dev;
 
 	pdev = mtkdev->plat_dev;
 	pm = &mtkdev->pm;
@@ -37,6 +39,7 @@ int mtk_vcodec_init_enc_pm(struct mtk_vcodec_dev *mtkdev)
 	pm->mtkdev = mtkdev;
 	pm->dev = &pdev->dev;
 	dev = &pdev->dev;
+	enc_clk = &pm->venc_clk;
 
 	node = of_parse_phandle(dev->of_node, "mediatek,larb", 0);
 	if (!node) {
@@ -68,28 +71,34 @@ int mtk_vcodec_init_enc_pm(struct mtk_vcodec_dev *mtkdev)
 	pdev = mtkdev->plat_dev;
 	pm->dev = &pdev->dev;
 
-	pm->vencpll_d2 = devm_clk_get(&pdev->dev, "venc_sel_src");
-	if (IS_ERR(pm->vencpll_d2)) {
-		mtk_v4l2_err("devm_clk_get vencpll_d2 fail");
-		ret = PTR_ERR(pm->vencpll_d2);
-	}
-
-	pm->venc_sel = devm_clk_get(&pdev->dev, "venc_sel");
-	if (IS_ERR(pm->venc_sel)) {
-		mtk_v4l2_err("devm_clk_get venc_sel fail");
-		ret = PTR_ERR(pm->venc_sel);
+	enc_clk->clk_num = of_property_count_strings(pdev->dev.of_node,
+		"clock-names");
+	if (enc_clk->clk_num > 0) {
+		enc_clk->clk_info = devm_kcalloc(&pdev->dev,
+			enc_clk->clk_num, sizeof(*clk_info),
+			GFP_KERNEL);
+		if (!enc_clk->clk_info)
+			return -ENOMEM;
+	} else {
+		mtk_v4l2_err("Failed to get venc clock count");
+		return -EINVAL;
 	}
 
-	pm->univpll1_d2 = devm_clk_get(&pdev->dev, "venc_lt_sel_src");
-	if (IS_ERR(pm->univpll1_d2)) {
-		mtk_v4l2_err("devm_clk_get univpll1_d2 fail");
-		ret = PTR_ERR(pm->univpll1_d2);
-	}
-
-	pm->venc_lt_sel = devm_clk_get(&pdev->dev, "venc_lt_sel");
-	if (IS_ERR(pm->venc_lt_sel)) {
-		mtk_v4l2_err("devm_clk_get venc_lt_sel fail");
-		ret = PTR_ERR(pm->venc_lt_sel);
+	for (i = 0; i < enc_clk->clk_num; i++) {
+		clk_info = &enc_clk->clk_info[i];
+		ret = of_property_read_string_index(pdev->dev.of_node,
+			"clock-names", i, &clk_info->clk_name);
+		if (ret) {
+			mtk_v4l2_err("venc failed to get clk name %d", i);
+			return ret;
+		}
+		clk_info->vcodec_clk = devm_clk_get(&pdev->dev,
+			clk_info->clk_name);
+		if (IS_ERR(clk_info->vcodec_clk)) {
+			mtk_v4l2_err("venc devm_clk_get (%d)%s fail", i,
+				clk_info->clk_name);
+			return PTR_ERR(clk_info->vcodec_clk);
+		}
 	}
 
 	return ret;
@@ -102,38 +111,45 @@ void mtk_vcodec_release_enc_pm(struct mtk_vcodec_dev *mtkdev)
 
 void mtk_vcodec_enc_clock_on(struct mtk_vcodec_pm *pm)
 {
-	int ret;
-
-	ret = clk_prepare_enable(pm->venc_sel);
-	if (ret)
-		mtk_v4l2_err("clk_prepare_enable fail %d", ret);
-
-	ret = clk_set_parent(pm->venc_sel, pm->vencpll_d2);
-	if (ret)
-		mtk_v4l2_err("clk_set_parent fail %d", ret);
-
-	ret = clk_prepare_enable(pm->venc_lt_sel);
-	if (ret)
-		mtk_v4l2_err("clk_prepare_enable fail %d", ret);
-
-	ret = clk_set_parent(pm->venc_lt_sel, pm->univpll1_d2);
-	if (ret)
-		mtk_v4l2_err("clk_set_parent fail %d", ret);
+	struct mtk_vcodec_clk *enc_clk = &pm->venc_clk;
+	int ret, i = 0;
+
+	for (i = 0; i < enc_clk->clk_num; i++) {
+		ret = clk_prepare_enable(enc_clk->clk_info[i].vcodec_clk);
+		if (ret) {
+			mtk_v4l2_err("venc clk_prepare_enable %d %s fail %d", i,
+				enc_clk->clk_info[i].clk_name, ret);
+			goto clkerr;
+		}
+	}
 
 	ret = mtk_smi_larb_get(pm->larbvenc);
-	if (ret)
+	if (ret) {
 		mtk_v4l2_err("mtk_smi_larb_get larb3 fail %d", ret);
-
+		goto larbvencerr;
+	}
 	ret = mtk_smi_larb_get(pm->larbvenclt);
-	if (ret)
+	if (ret) {
 		mtk_v4l2_err("mtk_smi_larb_get larb4 fail %d", ret);
+		goto larbvenclterr;
+	}
+	return;
 
+larbvenclterr:
+	mtk_smi_larb_put(pm->larbvenc);
+larbvencerr:
+clkerr:
+	for (i -= 1; i >= 0; i--)
+		clk_disable_unprepare(enc_clk->clk_info[i].vcodec_clk);
 }
 
 void mtk_vcodec_enc_clock_off(struct mtk_vcodec_pm *pm)
 {
+	struct mtk_vcodec_clk *enc_clk = &pm->venc_clk;
+	int i = 0;
+
 	mtk_smi_larb_put(pm->larbvenc);
 	mtk_smi_larb_put(pm->larbvenclt);
-	clk_disable_unprepare(pm->venc_lt_sel);
-	clk_disable_unprepare(pm->venc_sel);
+	for (i = enc_clk->clk_num - 1; i >= 0; i--)
+		clk_disable_unprepare(enc_clk->clk_info[i].vcodec_clk);
 }
-- 
2.20.1

