Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qe0-f49.google.com ([209.85.128.49]:49865 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684Ab3CQHoC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Mar 2013 03:44:02 -0400
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
To: linux-media@vger.kernel.org
Cc: gregkh@linuxfoundation.org, prabhakar.lad@ti.com,
	sakari.ailus@iki.fi, laurent.pinchart@ideasonboard.com,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Subject: [PATCH] drivers: staging: davinci_vpfe: use resource_size()
Date: Sun, 17 Mar 2013 09:43:52 +0200
Message-Id: <1363506232-11517-1-git-send-email-silviupopescu1990@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This uses the resource_size() function instead of explicit computation.

Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |    3 ++-
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |    6 ++++--
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |    4 +++-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index 9285353..de3f202 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -27,6 +27,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/ioport.h>
 
 #include "dm365_ipipe.h"
 #include "dm365_ipipe_hw.h"
@@ -1859,5 +1860,5 @@ void vpfe_ipipe_cleanup(struct vpfe_ipipe_device *ipipe,
 	iounmap(ipipe->isp5_base_addr);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 4);
 	if (res)
-		release_mem_region(res->start, res->end - res->start + 1);
+		release_mem_region(res->start, resource_size(res));
 }
diff --git a/drivers/staging/media/davinci_vpfe/dm365_isif.c b/drivers/staging/media/davinci_vpfe/dm365_isif.c
index ebeea72..cd263d5 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_isif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_isif.c
@@ -19,6 +19,8 @@
  *      Prabhakar Lad <prabhakar.lad@ti.com>
  */
 
+#include <linux/ioport.h>
+
 #include "dm365_isif.h"
 #include "vpfe_mc_capture.h"
 
@@ -1953,7 +1955,7 @@ static void isif_remove(struct vpfe_isif_device *isif,
 		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
 		if (res)
 			release_mem_region(res->start,
-					   res->end - res->start + 1);
+					   resource_size(res));
 		i++;
 	}
 }
@@ -2003,7 +2005,7 @@ int vpfe_isif_init(struct vpfe_isif_device *isif, struct platform_device *pdev)
 			status = -ENOENT;
 			goto fail_nobase_res;
 		}
-		res_len = res->end - res->start + 1;
+		res_len = resource_size(res);
 		res = request_mem_region(res->start, res_len, res->name);
 		if (!res) {
 			status = -EBUSY;
diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index 9cb0262..c351ea1 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -24,6 +24,8 @@
  * same input image, but can have different output resolution.
  */
 
+#include <linux/ioport.h>
+
 #include "dm365_ipipe_hw.h"
 #include "dm365_resizer.h"
 
@@ -1995,5 +1997,5 @@ vpfe_resizer_cleanup(struct vpfe_resizer_device *vpfe_rsz,
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 5);
 	if (res)
 		release_mem_region(res->start,
-					res->end - res->start + 1);
+				   resource_size(res));
 }
-- 
1.7.9.5

