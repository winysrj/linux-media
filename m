Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:64955 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935191Ab3DJKXA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Apr 2013 06:23:00 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ML1009BUBIBEEQ0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 10 Apr 2013 19:22:59 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: arun.kk@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] s5p-mfc: Remove potential uninitialized variable usage
Date: Wed, 10 Apr 2013 12:21:42 +0200
Message-id: <1365589302-5312-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure mem_info[] array is not used uninitialized. This prevents
following compiler warning:

drivers/media/platform/s5p-mfc/s5p_mfc.c: In function s5p_mfc_probe:
drivers/media/platform/s5p-mfc/s5p_mfc.c:1032:33: warning: mem_info[0] may be used uninitialized in this function [-Wuninitialized]
drivers/media/platform/s5p-mfc/s5p_mfc.c:1021:15: note: mem_info[0] was declared here
drivers/media/platform/s5p-mfc/s5p_mfc.c:1032:33: warning: mem_info[1] may be used uninitialized in this function [-Wuninitialized]
drivers/media/platform/s5p-mfc/s5p_mfc.c:1021:15: note: mem_info[1] was declared here

Cc: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 7379dc6..5fb948c 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1018,7 +1018,7 @@ static void *mfc_get_drv_data(struct platform_device *pdev);
 
 static int s5p_mfc_alloc_memdevs(struct s5p_mfc_dev *dev)
 {
-	unsigned int mem_info[2];
+	unsigned int mem_info[2] = { };
 
 	dev->mem_dev_l = devm_kzalloc(&dev->plat_dev->dev,
 			sizeof(struct device), GFP_KERNEL);
-- 
1.7.9.5

