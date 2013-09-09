Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:52336 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab3IIFzb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Sep 2013 01:55:31 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSU00D4AGG1UP40@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 09 Sep 2013 14:55:18 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: 'Mauro Carvalho Chehab' <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>
References: <005e01cead20$c1c5d690$455183b0$%han@samsung.com>
In-reply-to: <005e01cead20$c1c5d690$455183b0$%han@samsung.com>
Subject: [PATCH 4/5] [media] ngene: Remove casting the return value which is a
 void pointer
Date: Mon, 09 Sep 2013 14:55:14 +0900
Message-id: <006101cead21$27432180$75c96480$%han@samsung.com>
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
 drivers/media/pci/ngene/ngene-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
index 37ebc42..21d18d4 100644
--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -1622,7 +1622,7 @@ static void ngene_unlink(struct ngene *dev)
 
 void ngene_shutdown(struct pci_dev *pdev)
 {
-	struct ngene *dev = (struct ngene *)pci_get_drvdata(pdev);
+	struct ngene *dev = pci_get_drvdata(pdev);
 
 	if (!dev || !shutdown_workaround)
 		return;
-- 
1.7.10.4


