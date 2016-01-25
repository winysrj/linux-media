Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:32964 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932674AbcAYPVm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 10:21:42 -0500
Date: Mon, 25 Jan 2016 20:51:37 +0530
From: Amitoj Kaur Chawla <amitoj1606@gmail.com>
To: kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	mchehab@osg.samsung.com, kgene@kernel.org, k.kozlowski@samsung.com,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] media: platform: exynos4-is: media-dev: Add missing
 of_node_put
Message-ID: <20160125152136.GA19484@amitoj-Inspiron-3542>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

for_each_available_child_of_node and for_each_child_of_node perform an
of_node_get on each iteration, so to break out of the loop an of_node_put is
required.

Found using Coccinelle. The simplified version of the semantic patch
that is used for this is as follows:

// <smpl>
@@
local idexpression n;
expression e,r;
@@

 for_each_available_child_of_node(r,n) {
   ...
(
   of_node_put(n);
|
   e = n
|
+  of_node_put(n);
?  break;
)
   ...
 }
... when != n
// </smpl>

Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>
---
 drivers/media/platform/exynos4-is/media-dev.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 4f5586a..09f6e54 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -430,8 +430,10 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
 			continue;
 
 		ret = fimc_md_parse_port_node(fmd, port, index);
-		if (ret < 0)
+		if (ret < 0) {
+			of_node_put(node);
 			goto rpm_put;
+		}
 		index++;
 	}
 
@@ -442,8 +444,10 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
 
 	for_each_child_of_node(ports, node) {
 		ret = fimc_md_parse_port_node(fmd, node, index);
-		if (ret < 0)
+		if (ret < 0) {
+			of_node_put(node);
 			break;
+		}
 		index++;
 	}
 rpm_put:
@@ -651,8 +655,10 @@ static int fimc_md_register_platform_entities(struct fimc_md *fmd,
 			ret = fimc_md_register_platform_entity(fmd, pdev,
 							plat_entity);
 		put_device(&pdev->dev);
-		if (ret < 0)
+		if (ret < 0) {
+			of_node_put(node);
 			break;
+		}
 	}
 
 	return ret;
-- 
1.9.1

