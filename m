Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:41957 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab3GOLvZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jul 2013 07:51:25 -0400
Received: by mail-pa0-f49.google.com with SMTP id ld11so11049450pab.36
        for <linux-media@vger.kernel.org>; Mon, 15 Jul 2013 04:51:24 -0700 (PDT)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, arunkk.samsung@gmail.com
Subject: [PATCH] [media] exynos4-is: Fix fimc-lite bayer formats
Date: Mon, 15 Jul 2013 17:21:23 +0530
Message-Id: <1373889083-13675-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The 10bit and 12bit bayer output formats supported
by fimc-lite actually uses 16bits where the extra
bits are padded with zeros. The patch corrects this
by modifying depth field of these two formats.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-lite.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 08fbfed..e85dc4f 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -90,7 +90,7 @@ static const struct fimc_fmt fimc_lite_formats[] = {
 		.name		= "RAW10 (GRBG)",
 		.fourcc		= V4L2_PIX_FMT_SGRBG10,
 		.colorspace	= V4L2_COLORSPACE_SRGB,
-		.depth		= { 10 },
+		.depth		= { 16 },
 		.color		= FIMC_FMT_RAW10,
 		.memplanes	= 1,
 		.mbus_code	= V4L2_MBUS_FMT_SGRBG10_1X10,
@@ -99,7 +99,7 @@ static const struct fimc_fmt fimc_lite_formats[] = {
 		.name		= "RAW12 (GRBG)",
 		.fourcc		= V4L2_PIX_FMT_SGRBG12,
 		.colorspace	= V4L2_COLORSPACE_SRGB,
-		.depth		= { 12 },
+		.depth		= { 16 },
 		.color		= FIMC_FMT_RAW12,
 		.memplanes	= 1,
 		.mbus_code	= V4L2_MBUS_FMT_SGRBG12_1X12,
-- 
1.7.9.5

