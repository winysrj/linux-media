Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33556 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751125AbdCQGwD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 02:52:03 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: media: Unmap  and release region obtained by ioremap_nocache
Date: Fri, 17 Mar 2017 12:21:23 +0530
Message-Id: <1489733483-11186-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Free memory mapping, if vpfe_ipipe_init is not successful.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index ff47a8f3..6a3434c 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -1803,14 +1803,14 @@ void vpfe_ipipe_unregister_entities(struct vpfe_ipipe_device *vpfe_ipipe)
 		return -EBUSY;
 	ipipe->base_addr = ioremap_nocache(res->start, res_len);
 	if (!ipipe->base_addr)
-		return -EBUSY;
+		goto error_release;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 6);
 	if (!res)
-		return -ENOENT;
+		goto error_unmap;
 	ipipe->isp5_base_addr = ioremap_nocache(res->start, res_len);
 	if (!ipipe->isp5_base_addr)
-		return -EBUSY;
+		goto error_unmap;
 
 	v4l2_subdev_init(sd, &ipipe_v4l2_ops);
 	sd->internal_ops = &ipipe_v4l2_internal_ops;
@@ -1839,6 +1839,12 @@ void vpfe_ipipe_unregister_entities(struct vpfe_ipipe_device *vpfe_ipipe)
 	sd->ctrl_handler = &ipipe->ctrls;
 
 	return media_entity_pads_init(me, IPIPE_PADS_NUM, pads);
+
+error_unmap:
+	iounmap(ipipe->base_addr);
+error_release:
+	release_mem_region(res->start, res_len);
+	return -ENOMEM;
 }
 
 /*
-- 
1.9.1
