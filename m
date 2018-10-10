Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35022 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726827AbeJJPxh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Oct 2018 11:53:37 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: rajmohan.mani@intel.com, yong.zhi@intel.com, bingbu.cao@intel.com,
        tian.shu.qiu@intel.com, jian.xu.zheng@intel.com
Subject: [PATCH 2/2] ipu3-cio2: Use cio2_queues_exit
Date: Wed, 10 Oct 2018 11:32:31 +0300
Message-Id: <20181010083231.27492-3-sakari.ailus@linux.intel.com>
In-Reply-To: <20181010083231.27492-1-sakari.ailus@linux.intel.com>
References: <20181010083231.27492-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ipu3-cio2 driver has a function to tear down video devices as well as
the associated video buffer queues. Use it.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 723022ef3662..447baaebca44 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1844,12 +1844,10 @@ static int cio2_pci_probe(struct pci_dev *pci_dev,
 static void cio2_pci_remove(struct pci_dev *pci_dev)
 {
 	struct cio2_device *cio2 = pci_get_drvdata(pci_dev);
-	unsigned int i;
 
 	media_device_unregister(&cio2->media_dev);
 	cio2_notifier_exit(cio2);
-	for (i = 0; i < CIO2_QUEUES; i++)
-		cio2_queue_exit(cio2, &cio2->queue[i]);
+	cio2_queues_exit(cio2);
 	cio2_fbpt_exit_dummy(cio2);
 	v4l2_device_unregister(&cio2->v4l2_dev);
 	media_device_cleanup(&cio2->media_dev);
-- 
2.11.0
