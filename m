Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:51785 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3IIFw0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Sep 2013 01:52:26 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSU00E89G9YD040@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 09 Sep 2013 14:52:25 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: 'Mauro Carvalho Chehab' <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, 'Kamil Debski' <k.debski@samsung.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Jingoo Han' <jg1.han@samsung.com>
Subject: [PATCH 1/5] [media] s5p-g2d: Remove casting the return value which is
 a void pointer
Date: Mon, 09 Sep 2013 14:52:24 +0900
Message-id: <005e01cead20$c1c5d690$455183b0$%han@samsung.com>
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


