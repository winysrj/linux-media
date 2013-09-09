Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:63188 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3IIFvF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Sep 2013 01:51:05 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSU00ESUG9492P0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 09 Sep 2013 14:51:04 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: 'Mauro Carvalho Chehab' <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, 'Kamil Debski' <k.debski@samsung.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>
Subject: [PATCH 1/5] [media] s5p-g2d: Remove casting the return value which is
 a void pointer
Date: Mon, 09 Sep 2013 14:51:04 +0900
Message-id: <005d01cead20$92209290$b661b7b0$%han@samsung.com>
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
 drivers/media/platform/s5p-g2d/g2d.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index fd6289d..0b29483 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -840,7 +840,7 @@ put_clk:
 
 static int g2d_remove(struct platform_device *pdev)
 {
-	struct g2d_dev *dev = (struct g2d_dev *)platform_get_drvdata(pdev);
+	struct g2d_dev *dev = platform_get_drvdata(pdev);
 
 	v4l2_info(&dev->v4l2_dev, "Removing " G2D_NAME);
 	v4l2_m2m_release(dev->m2m_dev);
-- 
1.7.10.4


