Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:32023 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab2JPDgw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 23:36:52 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBY003W2VCZNEA0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 16 Oct 2012 12:36:51 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBY00CDYVCWIJ00@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 16 Oct 2012 12:36:51 +0900 (KST)
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, shaik.samsung@gmail.com
Subject: [PATCH] [media] s5p-fimc: fix variable type in fimc_device_run()
Date: Tue, 16 Oct 2012 19:09:08 +0530
Message-id: <1350394748-30064-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In fimc_device_run(), variable "ret" is accepting signed integer
values. But currently it is defined as u32. This patch will modify
the type of "ret" variable to "int".

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-m2m.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-m2m.c b/drivers/media/platform/s5p-fimc/fimc-m2m.c
index 4500e44..4c4e901 100644
--- a/drivers/media/platform/s5p-fimc/fimc-m2m.c
+++ b/drivers/media/platform/s5p-fimc/fimc-m2m.c
@@ -105,7 +105,7 @@ static void fimc_device_run(void *priv)
 	struct fimc_frame *sf, *df;
 	struct fimc_dev *fimc;
 	unsigned long flags;
-	u32 ret;
+	int ret;
 
 	if (WARN(!ctx, "Null context\n"))
 		return;
-- 
1.7.0.4

