Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36449
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754999AbdFXUlN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Jun 2017 16:41:13 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Subject: [PATCH 1/4] media: cx25821: get rid of CX25821_VERSION_CODE
Date: Sat, 24 Jun 2017 17:40:24 -0300
Message-Id: <73980406b3bb4a6829a1d1bca69a555477234beb.1498336792.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is used just for printing a version number. As this is
never incremented, it makes no sense to keep it :-)

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/cx25821/cx25821-core.c | 5 +----
 drivers/media/pci/cx25821/cx25821.h      | 2 --
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index fbc0229183bd..04aa4a68a0ae 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -1390,10 +1390,7 @@ static struct pci_driver cx25821_pci_driver = {
 
 static int __init cx25821_init(void)
 {
-	pr_info("driver version %d.%d.%d loaded\n",
-		(CX25821_VERSION_CODE >> 16) & 0xff,
-		(CX25821_VERSION_CODE >> 8) & 0xff,
-		CX25821_VERSION_CODE & 0xff);
+	pr_info("driver loaded\n");
 	return pci_register_driver(&cx25821_pci_driver);
 }
 
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index 0f20e89b0cde..b3eb2dabb30b 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -41,8 +41,6 @@
 #include <linux/version.h>
 #include <linux/mutex.h>
 
-#define CX25821_VERSION_CODE KERNEL_VERSION(0, 0, 106)
-
 #define UNSET (-1U)
 #define NO_SYNC_LINE (-1U)
 
-- 
2.9.4
