Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57066 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934006AbcKPJFl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 04:05:41 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Inki Dae <inki.dae@samsung.com>
Subject: [PATCH 9/9] s5p-mfc: Add support for MFC v8 available in Exynos 5433
 SoCs
Date: Wed, 16 Nov 2016 10:04:58 +0100
Message-id: <1479287098-30493-10-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1479287098-30493-1-git-send-email-m.szyprowski@samsung.com>
References: <1479287098-30493-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20161116090523eucas1p12a4b95363e9d2b0a823141a2f1c226e1@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Exynos5433 SoC has MFC v8 hardware module, but it has more complex clock
hierarchy, so a new compatible has been added.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 Documentation/devicetree/bindings/media/s5p-mfc.txt |  1 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c            | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/s5p-mfc.txt b/Documentation/devicetree/bindings/media/s5p-mfc.txt
index 92c94f5ecbf1..2c901286d818 100644
--- a/Documentation/devicetree/bindings/media/s5p-mfc.txt
+++ b/Documentation/devicetree/bindings/media/s5p-mfc.txt
@@ -12,6 +12,7 @@ Required properties:
 	(b) "samsung,mfc-v6" for MFC v6 present in Exynos5 SoCs
 	(c) "samsung,mfc-v7" for MFC v7 present in Exynos5420 SoC
 	(d) "samsung,mfc-v8" for MFC v8 present in Exynos5800 SoC
+	(e) "samsung,exynos5433-mfc" for MFC v8 present in Exynos5433 SoC
 
   - reg : Physical base address of the IP registers and length of memory
 	  mapped region.
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index fa674e8e09a8..d11a2405b3d2 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1530,6 +1530,17 @@ static int s5p_mfc_resume(struct device *dev)
 	.num_clocks	= 1,
 };
 
+static struct s5p_mfc_variant mfc_drvdata_v8_5433 = {
+	.version	= MFC_VERSION_V8,
+	.version_bit	= MFC_V8_BIT,
+	.port_num	= MFC_NUM_PORTS_V8,
+	.buf_size	= &buf_size_v8,
+	.buf_align	= &mfc_buf_align_v8,
+	.fw_name[0]     = "s5p-mfc-v8.fw",
+	.clk_names	= {"pclk", "aclk", "aclk_xiu"},
+	.num_clocks	= 3,
+};
+
 static const struct of_device_id exynos_mfc_match[] = {
 	{
 		.compatible = "samsung,mfc-v5",
@@ -1543,6 +1554,9 @@ static int s5p_mfc_resume(struct device *dev)
 	}, {
 		.compatible = "samsung,mfc-v8",
 		.data = &mfc_drvdata_v8,
+	}, {
+		.compatible = "samsung,exynos5433-mfc",
+		.data = &mfc_drvdata_v8_5433,
 	},
 	{},
 };
-- 
1.9.1

