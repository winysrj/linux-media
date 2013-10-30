Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:47808 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab3J3DJr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Oct 2013 23:09:47 -0400
Received: by mail-bk0-f49.google.com with SMTP id w14so290157bkz.8
        for <linux-media@vger.kernel.org>; Tue, 29 Oct 2013 20:09:44 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 30 Oct 2013 11:09:44 +0800
Message-ID: <CAPgLHd8N8H+Otga8Ay_DyTdK258v2K09xkn-78RBpjsDh31ieg@mail.gmail.com>
Subject: [PATCH -next] [media] v4l: ti-vpe: use module_platform_driver to
 simplify the code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: m.chehab@samsung.com, grant.likely@linaro.org,
	rob.herring@calxeda.com, archit@ti.com, hans.verkuil@cisco.com,
	k.debski@samsung.com
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

module_platform_driver() makes the code simpler by eliminating
boilerplate code.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/platform/ti-vpe/vpe.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 4e58069..89658a3 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -2081,18 +2081,7 @@ static struct platform_driver vpe_pdrv = {
 	},
 };
 
-static void __exit vpe_exit(void)
-{
-	platform_driver_unregister(&vpe_pdrv);
-}
-
-static int __init vpe_init(void)
-{
-	return platform_driver_register(&vpe_pdrv);
-}
-
-module_init(vpe_init);
-module_exit(vpe_exit);
+module_platform_driver(vpe_pdrv);
 
 MODULE_DESCRIPTION("TI VPE driver");
 MODULE_AUTHOR("Dale Farnsworth, <dale@farnsworth.org>");

