Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:35256 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbcFTF4K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 01:56:10 -0400
Date: Mon, 20 Jun 2016 11:25:52 +0530
From: Amitoj Kaur Chawla <amitoj1606@gmail.com>
To: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] ddbridge: Replace vmalloc with vzalloc
Message-ID: <20160620055552.GA3149@amitoj-Inspiron-3542>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vzalloc combines vmalloc and memset 0.

The Coccinelle semantic patch used to make this change is as follows:
@@
type T;
T *d;
expression e;
statement S;
@@

        d =
-            vmalloc
+            vzalloc
             (...);
        if (!d) S
-       memset(d, 0, sizeof(T));

Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 6e995ef..47def73 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1569,10 +1569,9 @@ static int ddb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (pci_enable_device(pdev) < 0)
 		return -ENODEV;
 
-	dev = vmalloc(sizeof(struct ddb));
+	dev = vzalloc(sizeof(struct ddb));
 	if (dev == NULL)
 		return -ENOMEM;
-	memset(dev, 0, sizeof(struct ddb));
 
 	dev->pdev = pdev;
 	pci_set_drvdata(pdev, dev);
-- 
1.9.1

