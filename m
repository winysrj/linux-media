Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:36788 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753118AbdHTQtH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 12:49:07 -0400
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        arvind.yadav.cs@gmail.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] Staging: media: Release the correct resource in an error handling path
Date: Sun, 20 Aug 2017 18:49:01 +0200
Message-Id: <20170820164901.9810-1-christophe.jaillet@wanadoo.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

'res' is reassigned several times in the function and if we 'goto
error_unmap', its value is not the returned value of 'request_mem_region()'
anymore.

Introduce a new 'struct resource *' variable (i.e. res2) to keep a pointer
to the right resource, if needed in the error handling path.

Fixes: 4b4eda001704 ("Staging: media: Unmap and release region obtained by ioremap_nocache")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index 6a3434cebd79..8d2d3f8edc07 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -1791,7 +1791,7 @@ vpfe_ipipe_init(struct vpfe_ipipe_device *ipipe, struct platform_device *pdev)
 	struct v4l2_subdev *sd = &ipipe->subdev;
 	struct media_entity *me = &sd->entity;
 	static resource_size_t  res_len;
-	struct resource *res;
+	struct resource *res, *res2;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 4);
 	if (!res)
@@ -1805,10 +1805,10 @@ vpfe_ipipe_init(struct vpfe_ipipe_device *ipipe, struct platform_device *pdev)
 	if (!ipipe->base_addr)
 		goto error_release;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 6);
-	if (!res)
+	res2 = platform_get_resource(pdev, IORESOURCE_MEM, 6);
+	if (!res2)
 		goto error_unmap;
-	ipipe->isp5_base_addr = ioremap_nocache(res->start, res_len);
+	ipipe->isp5_base_addr = ioremap_nocache(res2->start, res_len);
 	if (!ipipe->isp5_base_addr)
 		goto error_unmap;
 
-- 
2.11.0
