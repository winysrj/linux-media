Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:37961 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713Ab2EXPQC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 May 2012 11:16:02 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M4J005R892DTU@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 May 2012 16:15:50 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4J001RE92NW1@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 May 2012 16:16:00 +0100 (BST)
Date: Thu, 24 May 2012 17:15:56 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 7/7] s5p-fimc: Shorten pixel formats description
In-reply-to: <1337872556-26406-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1337872556-26406-8-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1337872556-26406-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Shorten pixel format descriptions that exceed 32 characters
so they're not being truncated when queried from user space.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 330a067..077385d 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -153,7 +153,7 @@ static struct fimc_fmt fimc_formats[] = {
 		.colplanes	= 2,
 		.flags		= FMT_FLAGS_M2M,
 	}, {
-		.name		= "YUV 4:2:0 non-contiguous 2-planar, Y/CbCr",
+		.name		= "YUV 4:2:0 non-contig. 2p, Y/CbCr",
 		.fourcc		= V4L2_PIX_FMT_NV12M,
 		.color		= FIMC_FMT_YCBCR420,
 		.depth		= { 8, 4 },
@@ -161,7 +161,7 @@ static struct fimc_fmt fimc_formats[] = {
 		.colplanes	= 2,
 		.flags		= FMT_FLAGS_M2M,
 	}, {
-		.name		= "YUV 4:2:0 non-contiguous 3-planar, Y/Cb/Cr",
+		.name		= "YUV 4:2:0 non-contig. 3p, Y/Cb/Cr",
 		.fourcc		= V4L2_PIX_FMT_YUV420M,
 		.color		= FIMC_FMT_YCBCR420,
 		.depth		= { 8, 2, 2 },
@@ -169,7 +169,7 @@ static struct fimc_fmt fimc_formats[] = {
 		.colplanes	= 3,
 		.flags		= FMT_FLAGS_M2M,
 	}, {
-		.name		= "YUV 4:2:0 non-contiguous 2-planar, Y/CbCr, tiled",
+		.name		= "YUV 4:2:0 non-contig. 2p, tiled",
 		.fourcc		= V4L2_PIX_FMT_NV12MT,
 		.color		= FIMC_FMT_YCBCR420,
 		.depth		= { 8, 4 },
-- 
1.7.10

