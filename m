Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:43034 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaH2Dtp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Aug 2014 23:49:45 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0NB100G1JUMVJ040@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 29 Aug 2014 12:49:43 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: 'Mauro Carvalho Chehab' <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, 'Archit Taneja' <archit@ti.com>,
	'Jingoo Han' <jg1.han@samsung.com>
Subject: [PATCH] [media] v4l: ti-vpe: Remove casting the return value which is
 a void pointer
Date: Fri, 29 Aug 2014 12:49:43 +0900
Message-id: <004f01cfc33c$44c1f650$ce45e2f0$%han@samsung.com>
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
 drivers/media/platform/ti-vpe/vpe.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 972f43f69206..aa7f96852a8c 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -2343,8 +2343,7 @@ v4l2_dev_unreg:
 
 static int vpe_remove(struct platform_device *pdev)
 {
-	struct vpe_dev *dev =
-		(struct vpe_dev *) platform_get_drvdata(pdev);
+	struct vpe_dev *dev = platform_get_drvdata(pdev);
 
 	v4l2_info(&dev->v4l2_dev, "Removing " VPE_MODULE_NAME);
 
-- 
2.0.0


