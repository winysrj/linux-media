Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:42416 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab2K0M0d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 07:26:33 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ME500C2UBW2GCH0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 27 Nov 2012 21:26:31 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0ME500HRCBUTOGA0@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 27 Nov 2012 21:26:31 +0900 (KST)
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com
Subject: [PATCH] [media] exynos-gsc: modify number of output/capture buffers
Date: Tue, 27 Nov 2012 18:18:58 +0530
Message-id: <1354020538-8373-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

G-Scaler src buffer count as well as destination buffer
count is increased to 32. This is required for G-Scaler to
interface with MFC, as MFC demands 32 capture buffers for
some H264 streams.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index cc7b218..4856dd7 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -935,8 +935,8 @@ static struct gsc_variant gsc_v_100_variant = {
 	.pix_max		= &gsc_v_100_max,
 	.pix_min		= &gsc_v_100_min,
 	.pix_align		= &gsc_v_100_align,
-	.in_buf_cnt		= 8,
-	.out_buf_cnt		= 16,
+	.in_buf_cnt		= 32,
+	.out_buf_cnt		= 32,
 	.sc_up_max		= 8,
 	.sc_down_max		= 16,
 	.poly_sc_down_max	= 4,
-- 
1.7.0.4

