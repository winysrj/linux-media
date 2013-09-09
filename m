Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:46766 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab3IIF4K (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Sep 2013 01:56:10 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSU00IWOGHKTOP0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 09 Sep 2013 14:56:09 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: 'Mauro Carvalho Chehab' <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>
References: <005e01cead20$c1c5d690$455183b0$%han@samsung.com>
In-reply-to: <005e01cead20$c1c5d690$455183b0$%han@samsung.com>
Subject: [PATCH 5/5] [media] ddbridge: Remove casting the return value which is
 a void pointer
Date: Mon, 09 Sep 2013 14:56:07 +0900
Message-id: <006201cead21$47222870$d5667950$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Casting the return value which is a void pointer is redundant.
The conversion from void pointer to any other pointer type is
guaranteed by the C programming language.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/media/pci/ddbridge/ddbridge-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 36e3452..9375f30 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1544,7 +1544,7 @@ static void ddb_unmap(struct ddb *dev)
 
 static void ddb_remove(struct pci_dev *pdev)
 {
-	struct ddb *dev = (struct ddb *) pci_get_drvdata(pdev);
+	struct ddb *dev = pci_get_drvdata(pdev);
 
 	ddb_ports_detach(dev);
 	ddb_i2c_release(dev);
-- 
1.7.10.4


