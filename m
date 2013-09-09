Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:52012 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab3IIFxl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Sep 2013 01:53:41 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSU00EAPGD9D040@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 09 Sep 2013 14:53:40 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: 'Mauro Carvalho Chehab' <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>
References: <005e01cead20$c1c5d690$455183b0$%han@samsung.com>
In-reply-to: <005e01cead20$c1c5d690$455183b0$%han@samsung.com>
Subject: [PATCH 2/5] [media] m2m-deinterlace: Remove casting the return value
 which is a void pointer
Date: Mon, 09 Sep 2013 14:53:39 +0900
Message-id: <005f01cead20$eedfb4c0$cc9f1e40$%han@samsung.com>
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
 drivers/media/platform/m2m-deinterlace.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 540516c..36513e8 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -1084,8 +1084,7 @@ free_dev:
 
 static int deinterlace_remove(struct platform_device *pdev)
 {
-	struct deinterlace_dev *pcdev =
-		(struct deinterlace_dev *)platform_get_drvdata(pdev);
+	struct deinterlace_dev *pcdev = platform_get_drvdata(pdev);
 
 	v4l2_info(&pcdev->v4l2_dev, "Removing " MEM2MEM_TEST_MODULE_NAME);
 	v4l2_m2m_release(pcdev->m2m_dev);
-- 
1.7.10.4


