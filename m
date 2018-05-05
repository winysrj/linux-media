Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:57071 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751193AbeEENYd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 5 May 2018 09:24:33 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Akihiro Tsukada <tskd08@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH] media: pt1: use #ifdef CONFIG_PM_SLEEP instead of #if
Date: Sat,  5 May 2018 09:24:28 -0400
Message-Id: <078ce0be8945b9e2530f2e0ce84c8dcbb154edb6.1525526664.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As pointed by ktest:

>> drivers/media//pci/pt1/pt1.c:1433:5: warning: "CONFIG_PM_SLEEP" is not defined, evaluates to 0 [-Wundef]
    #if CONFIG_PM_SLEEP
        ^~~~~~~~~~~~~~~

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/pci/pt1/pt1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/pt1/pt1.c b/drivers/media/pci/pt1/pt1.c
index 3b7e08a4639a..55a89ea13f2a 100644
--- a/drivers/media/pci/pt1/pt1.c
+++ b/drivers/media/pci/pt1/pt1.c
@@ -1443,7 +1443,7 @@ static struct pci_driver pt1_driver = {
 	.probe		= pt1_probe,
 	.remove		= pt1_remove,
 	.id_table	= pt1_id_table,
-#if CONFIG_PM_SLEEP
+#ifdef CONFIG_PM_SLEEP
 	.driver.pm	= &pt1_pm_ops,
 #endif
 };
-- 
2.17.0
