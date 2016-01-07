Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:45299 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbcAGS27 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jan 2016 13:28:59 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH 7/8] [media] exynos4-is: Check v4l2_of_parse_endpoint() return value
Date: Thu,  7 Jan 2016 15:27:21 -0300
Message-Id: <1452191248-15847-8-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1452191248-15847-1-git-send-email-javier@osg.samsung.com>
References: <1452191248-15847-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_of_parse_endpoint() function can fail so check the return value.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/platform/exynos4-is/media-dev.c |  8 +++++++-
 drivers/media/platform/exynos4-is/mipi-csis.c | 10 +++++++---
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index f3b2dd30ec77..662d4a5c584e 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -332,13 +332,19 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 	struct fimc_source_info *pd = &fmd->sensor[index].pdata;
 	struct device_node *rem, *ep, *np;
 	struct v4l2_of_endpoint endpoint;
+	int ret;
 
 	/* Assume here a port node can have only one endpoint node. */
 	ep = of_get_next_child(port, NULL);
 	if (!ep)
 		return 0;
 
-	v4l2_of_parse_endpoint(ep, &endpoint);
+	ret = v4l2_of_parse_endpoint(ep, &endpoint);
+	if (ret) {
+		of_node_put(ep);
+		return ret;
+	}
+
 	if (WARN_ON(endpoint.base.port == 0) || index >= FIMC_MAX_SENSORS)
 		return -EINVAL;
 
diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index ac5e50e595be..bd5c46c3d4b7 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -736,6 +736,7 @@ static int s5pcsis_parse_dt(struct platform_device *pdev,
 {
 	struct device_node *node = pdev->dev.of_node;
 	struct v4l2_of_endpoint endpoint;
+	int ret;
 
 	if (of_property_read_u32(node, "clock-frequency",
 				 &state->clk_frequency))
@@ -751,7 +752,9 @@ static int s5pcsis_parse_dt(struct platform_device *pdev,
 		return -EINVAL;
 	}
 	/* Get port node and validate MIPI-CSI channel id. */
-	v4l2_of_parse_endpoint(node, &endpoint);
+	ret = v4l2_of_parse_endpoint(node, &endpoint);
+	if (ret)
+		goto err;
 
 	state->index = endpoint.base.port - FIMC_INPUT_MIPI_CSI2_0;
 	if (state->index >= CSIS_MAX_ENTITIES)
@@ -764,9 +767,10 @@ static int s5pcsis_parse_dt(struct platform_device *pdev,
 					"samsung,csis-wclk");
 
 	state->num_lanes = endpoint.bus.mipi_csi2.num_data_lanes;
-	of_node_put(node);
 
-	return 0;
+err:
+	of_node_put(node);
+	return ret;
 }
 
 static int s5pcsis_pm_resume(struct device *dev, bool runtime);
-- 
2.4.3

