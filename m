Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37965 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489Ab1IAPal (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 11:30:41 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 01 Sep 2011 17:30:22 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 18/19 v4] s5p-fimc: Correct crop offset alignment on exynos4
In-reply-to: <1314891023-14227-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: mchehab@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1314891023-14227-19-git-send-email-s.nawrocki@samsung.com>
References: <1314891023-14227-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Horizontal crop offset must be multiple of 2 otherwise
color distortion occurs.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index a528a76..8978360 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -1898,7 +1898,7 @@ static struct samsung_fimc_variant fimc0_variant_exynos4 = {
 	.has_mainscaler_ext = 1,
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 16,
-	.hor_offs_align	 = 1,
+	.hor_offs_align	 = 2,
 	.out_buf_count	 = 32,
 	.pix_limit	 = &s5p_pix_limit[1],
 };
@@ -1910,7 +1910,7 @@ static struct samsung_fimc_variant fimc3_variant_exynos4 = {
 	.has_mainscaler_ext = 1,
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 16,
-	.hor_offs_align	 = 1,
+	.hor_offs_align	 = 2,
 	.out_buf_count	 = 32,
 	.pix_limit	 = &s5p_pix_limit[3],
 };
-- 
1.7.6

