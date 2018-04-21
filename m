Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:58588 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750855AbeDUJXv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 21 Apr 2018 05:23:51 -0400
From: YueHaibing <yuehaibing@huawei.com>
To: <mchehab@kernel.org>, <sakari.ailus@linux.intel.com>
CC: <linux-media@vger.kernel.org>, <hans.verkuil@cisco.com>
Subject: [PATCH] media: staging: atomisp: Using module_pci_driver.
Date: Sat, 21 Apr 2018 17:23:43 +0800
Message-ID: <20180421092343.18848-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove boilerplate code by using macro module_pci_driver.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
index 548e00e..f95a5d0 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
@@ -1555,18 +1555,7 @@ static struct pci_driver atomisp_pci_driver = {
 	.remove = atomisp_pci_remove,
 };
 
-static int __init atomisp_init(void)
-{
-	return pci_register_driver(&atomisp_pci_driver);
-}
-
-static void __exit atomisp_exit(void)
-{
-	pci_unregister_driver(&atomisp_pci_driver);
-}
-
-module_init(atomisp_init);
-module_exit(atomisp_exit);
+module_pci_driver(atomisp_pci_driver);
 
 MODULE_AUTHOR("Wen Wang <wen.w.wang@intel.com>");
 MODULE_AUTHOR("Xiaolin Zhang <xiaolin.zhang@intel.com>");
-- 
2.7.0
