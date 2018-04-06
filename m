Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:55000 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754402AbeDFOX3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 10:23:29 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 03/21] media: davinci_vpfe: fix vpfe_ipipe_init() error handling
Date: Fri,  6 Apr 2018 10:23:04 -0400
Message-Id: <5963491651fe2385fa50cf9371cb826f640e91e8.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned:
	drivers/staging/media/davinci_vpfe/dm365_ipipe.c:1834 vpfe_ipipe_init() error: we previously assumed 'res' could be null (see line 1797)

There's something wrong at vpfe_ipipe_init():

1) it caches the resourse_size() from from the first region
   and reuses to the second region;

2) the "res" var is overriden 3 times;

3) at free logic, it assumes that "res->start" is not
   overriden by platform_get_resource(pdev, IORESOURCE_MEM, 6),
   but that's not true, as it can even be NULL there.

This patch fixes the above issues by:

a) store the resources used by release_mem_region() on
   a separate var;

b) stop caching resource_size(), using the function where
   needed.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index dd0cfc79f50c..b3a193ddd778 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -1778,25 +1778,25 @@ vpfe_ipipe_init(struct vpfe_ipipe_device *ipipe, struct platform_device *pdev)
 	struct media_pad *pads = &ipipe->pads[0];
 	struct v4l2_subdev *sd = &ipipe->subdev;
 	struct media_entity *me = &sd->entity;
-	static resource_size_t  res_len;
-	struct resource *res;
+	struct resource *res, *memres;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 4);
 	if (!res)
 		return -ENOENT;
 
-	res_len = resource_size(res);
-	res = request_mem_region(res->start, res_len, res->name);
-	if (!res)
+	memres = request_mem_region(res->start, resource_size(res), res->name);
+	if (!memres)
 		return -EBUSY;
-	ipipe->base_addr = ioremap_nocache(res->start, res_len);
+	ipipe->base_addr = ioremap_nocache(memres->start,
+					   resource_size(memres));
 	if (!ipipe->base_addr)
 		goto error_release;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 6);
 	if (!res)
 		goto error_unmap;
-	ipipe->isp5_base_addr = ioremap_nocache(res->start, res_len);
+	ipipe->isp5_base_addr = ioremap_nocache(res->start,
+						resource_size(res));
 	if (!ipipe->isp5_base_addr)
 		goto error_unmap;
 
@@ -1831,7 +1831,7 @@ vpfe_ipipe_init(struct vpfe_ipipe_device *ipipe, struct platform_device *pdev)
 error_unmap:
 	iounmap(ipipe->base_addr);
 error_release:
-	release_mem_region(res->start, res_len);
+	release_mem_region(memres->start, resource_size(memres));
 	return -ENOMEM;
 }
 
-- 
2.14.3
