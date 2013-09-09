Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:63853 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab3IIFy2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Sep 2013 01:54:28 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSU00E0CGER92Q0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 09 Sep 2013 14:54:27 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: 'Mauro Carvalho Chehab' <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>
References: <005e01cead20$c1c5d690$455183b0$%han@samsung.com>
In-reply-to: <005e01cead20$c1c5d690$455183b0$%han@samsung.com>
Subject: [PATCH 3/5] [media] mem2mem_testdev: Remove casting the return value
 which is a void pointer
Date: Mon, 09 Sep 2013 14:54:27 +0900
Message-id: <006001cead21$0b193350$214b99f0$%han@samsung.com>
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
 drivers/media/platform/mem2mem_testdev.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
index 6a17676..8df5975 100644
--- a/drivers/media/platform/mem2mem_testdev.c
+++ b/drivers/media/platform/mem2mem_testdev.c
@@ -1090,8 +1090,7 @@ unreg_dev:
 
 static int m2mtest_remove(struct platform_device *pdev)
 {
-	struct m2mtest_dev *dev =
-		(struct m2mtest_dev *)platform_get_drvdata(pdev);
+	struct m2mtest_dev *dev = platform_get_drvdata(pdev);
 
 	v4l2_info(&dev->v4l2_dev, "Removing " MEM2MEM_TEST_MODULE_NAME);
 	v4l2_m2m_release(dev->m2m_dev);
-- 
1.7.10.4


