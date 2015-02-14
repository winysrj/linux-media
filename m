Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:63291 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393AbbBNXNo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Feb 2015 18:13:44 -0500
From: Christian Engelmayer <cengelma@gmx.at>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	sakari.ailus@linux.intel.com,
	Christian Engelmayer <cengelma@gmx.at>
Subject: [PATCH] [media] cx88: Fix possible leak in cx8802_probe()
Date: Sun, 15 Feb 2015 00:12:56 +0100
Message-Id: <1423955576-5652-1-git-send-email-cengelma@gmx.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In case allocation vb2_dma_sg_init_ctx() fails during cx8802_probe(), the
already allocated cx8802 device structure memory is not freed in the used
exit path. Thus adapt the cleanup handling accordingly. Detected by Coverity
CID 1260065.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
Compile tested only. Applies against linux-next.
---
 drivers/media/pci/cx88/cx88-mpeg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index a369b0840acf..98344540c51f 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -732,7 +732,7 @@ static int cx8802_probe(struct pci_dev *pci_dev,
 	dev->alloc_ctx = vb2_dma_sg_init_ctx(&pci_dev->dev);
 	if (IS_ERR(dev->alloc_ctx)) {
 		err = PTR_ERR(dev->alloc_ctx);
-		goto fail_core;
+		goto fail_dev;
 	}
 	dev->core = core;
 
@@ -754,6 +754,7 @@ static int cx8802_probe(struct pci_dev *pci_dev,
 
  fail_free:
 	vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
+ fail_dev:
 	kfree(dev);
  fail_core:
 	core->dvbdev = NULL;
-- 
1.9.1

