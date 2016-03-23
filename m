Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:56633 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755639AbcCWQPx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2016 12:15:53 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [RFT PATCH] [media] exynos4-is: Fix fimc_is_parse_sensor_config() nodes handling
Date: Wed, 23 Mar 2016 13:15:36 -0300
Message-Id: <1458749736-30690-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The same struct device_node * is used for looking up the I2C sensor, OF
graph endpoint and port. So the reference count is incremented but not
decremented for the endpoint and port nodes.

Fix this by having separate pointers for each node looked up.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---
Hello,

This patch was only build tested because I don't have an Exynos4
board to test. So testing on real HW will be highly appreciated.

Best regards,
Javier

 drivers/media/platform/exynos4-is/fimc-is.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 979c388ebf60..0b04a5d25187 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -165,6 +165,7 @@ static int fimc_is_parse_sensor_config(struct fimc_is *is, unsigned int index,
 						struct device_node *node)
 {
 	struct fimc_is_sensor *sensor = &is->sensor[index];
+	struct device_node *ep, *port;
 	u32 tmp = 0;
 	int ret;
 
@@ -175,16 +176,18 @@ static int fimc_is_parse_sensor_config(struct fimc_is *is, unsigned int index,
 		return -EINVAL;
 	}
 
-	node = of_graph_get_next_endpoint(node, NULL);
-	if (!node)
+	ep = of_graph_get_next_endpoint(node, NULL);
+	if (!ep)
 		return -ENXIO;
 
-	node = of_graph_get_remote_port(node);
-	if (!node)
+	port = of_graph_get_remote_port(ep);
+	of_node_put(ep);
+	if (!port)
 		return -ENXIO;
 
 	/* Use MIPI-CSIS channel id to determine the ISP I2C bus index. */
-	ret = of_property_read_u32(node, "reg", &tmp);
+	ret = of_property_read_u32(port, "reg", &tmp);
+	of_node_put(port);
 	if (ret < 0) {
 		dev_err(&is->pdev->dev, "reg property not found at: %s\n",
 							 node->full_name);
-- 
2.5.0

