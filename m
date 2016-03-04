Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36319 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759679AbcCDUUt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Mar 2016 15:20:49 -0500
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
Subject: [PATCH 2/2] [media] exynos4-is: FIMC port parse should fail if there's no endpoint
Date: Fri,  4 Mar 2016 17:20:13 -0300
Message-Id: <1457122813-12791-3-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1457122813-12791-1-git-send-email-javier@osg.samsung.com>
References: <1457122813-12791-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The fimc_md_parse_port_node() function return 0 if an endpoint node is
not found but according to Documentation/devicetree/bindings/graph.txt,
a port must always have at least one enpoint.

So return an -EINVAL errno code to the caller instead, so it knows that
the port node parse failed due an invalid Device Tree description.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/platform/exynos4-is/media-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index feb521f28e14..06f3d75c9a0e 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -394,7 +394,7 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 	/* Assume here a port node can have only one endpoint node. */
 	ep = of_get_next_child(port, NULL);
 	if (!ep)
-		return 0;
+		return -EINVAL;
 
 	ret = v4l2_of_parse_endpoint(ep, &endpoint);
 	if (ret) {
-- 
2.5.0

