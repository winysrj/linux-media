Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:31961 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab2JPDgR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 23:36:17 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBY003VRVCFNEA0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 16 Oct 2012 12:36:16 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBY009V0VBXI640@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 16 Oct 2012 12:36:15 +0900 (KST)
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, shaik.samsung@gmail.com
Subject: [PATCH] [media] exynos-gsc: fix variable type in gsc_m2m_device_run()
Date: Tue, 16 Oct 2012 19:08:34 +0530
Message-id: <1350394714-29826-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In gsc_m2m_device_run(), variable "ret" is accepting signed integer
values. But currently it is defined as u32. This patch will modify
the type of "ret" variable to "int".

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-m2m.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index 3c7f005..047f0f0 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -122,7 +122,7 @@ static void gsc_m2m_device_run(void *priv)
 	struct gsc_ctx *ctx = priv;
 	struct gsc_dev *gsc;
 	unsigned long flags;
-	u32 ret;
+	int ret;
 	bool is_set = false;
 
 	if (WARN(!ctx, "null hardware context\n"))
-- 
1.7.0.4

