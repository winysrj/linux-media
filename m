Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:59647 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932494AbeAHM53 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Jan 2018 07:57:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Cao Bing Bu <bingbu.cao@intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: intel-ipu3: cio2: mark more PM functions as __maybe_unused
Date: Mon,  8 Jan 2018 13:57:00 +0100
Message-Id: <20180108125715.4146742-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

My earlier patch missed two functions, these must be __maybe_unused
as well:

drivers/media/pci/intel/ipu3/ipu3-cio2.c:1867:12: error: 'cio2_runtime_resume' defined but not used [-Werror=unused-function]
drivers/media/pci/intel/ipu3/ipu3-cio2.c:1849:12: error: 'cio2_runtime_suspend' defined but not used [-Werror=unused-function]

Fixes: 2086dd35705f ("media: intel-ipu3: cio2: mark PM functions as __maybe_unused")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
If my previous patch is not in a stable branch yet, folding the new
fixup into that would be ideal.
---
 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 9db752a7f363..724cd8d9d573 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1850,7 +1850,7 @@ static void cio2_pci_remove(struct pci_dev *pci_dev)
 	mutex_destroy(&cio2->lock);
 }
 
-static int cio2_runtime_suspend(struct device *dev)
+static int __maybe_unused cio2_runtime_suspend(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct cio2_device *cio2 = pci_get_drvdata(pci_dev);
@@ -1868,7 +1868,7 @@ static int cio2_runtime_suspend(struct device *dev)
 	return 0;
 }
 
-static int cio2_runtime_resume(struct device *dev)
+static int __maybe_unused cio2_runtime_resume(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct cio2_device *cio2 = pci_get_drvdata(pci_dev);
-- 
2.9.0
