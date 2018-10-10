Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35020 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726822AbeJJPxh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Oct 2018 11:53:37 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: rajmohan.mani@intel.com, yong.zhi@intel.com, bingbu.cao@intel.com,
        tian.shu.qiu@intel.com, jian.xu.zheng@intel.com
Subject: [PATCH 1/2] ipu3-cio2: Unregister device nodes first, then release resources
Date: Wed, 10 Oct 2018 11:32:30 +0300
Message-Id: <20181010083231.27492-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20181010083231.27492-1-sakari.ailus@linux.intel.com>
References: <20181010083231.27492-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While there are issues related to object lifetime management, unregister
the media device first, followed immediately by other device nodes when
the driver is being unbound. Only then the resources needed by the driver
may be released. This is slightly safer.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 452eb9b42140..723022ef3662 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1846,12 +1846,12 @@ static void cio2_pci_remove(struct pci_dev *pci_dev)
 	struct cio2_device *cio2 = pci_get_drvdata(pci_dev);
 	unsigned int i;
 
+	media_device_unregister(&cio2->media_dev);
 	cio2_notifier_exit(cio2);
-	cio2_fbpt_exit_dummy(cio2);
 	for (i = 0; i < CIO2_QUEUES; i++)
 		cio2_queue_exit(cio2, &cio2->queue[i]);
+	cio2_fbpt_exit_dummy(cio2);
 	v4l2_device_unregister(&cio2->v4l2_dev);
-	media_device_unregister(&cio2->media_dev);
 	media_device_cleanup(&cio2->media_dev);
 	mutex_destroy(&cio2->lock);
 }
-- 
2.11.0
