Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59353 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753Ab1KDOUJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 10:20:09 -0400
Date: Fri, 04 Nov 2011 15:20:02 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 8/8] s5p-fimc: Use correct fourcc for RGB565 colour format
In-reply-to: <1320416402-22883-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: samsung-soc@vger.kernel.org, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, stable@kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1320416402-22883-9-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1320416402-22883-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With 16-bit RGB565 colour format pixels are stored by the device in memory
in the following order:

    | b3  | b2  | b1  | b0  |
   ~+-----+-----+-----+-----+
    | R5 G6 B5  | R5 G6 B5  |

This corresponds to V4L2_PIX_FMT_RGB565 fourcc, not V4L2_PIX_FMT_RGB565X.
This change is required to avoid trouble when setting up video pipeline
with the s5p-tv devices, so the colour formats at both devices can be
properly matched.

Cc: <stable@kernel.org>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 7c22d78..07c6254 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -37,7 +37,7 @@ static char *fimc_clocks[MAX_FIMC_CLOCKS] = {
 static struct fimc_fmt fimc_formats[] = {
 	{
 		.name		= "RGB565",
-		.fourcc		= V4L2_PIX_FMT_RGB565X,
+		.fourcc		= V4L2_PIX_FMT_RGB565,
 		.depth		= { 16 },
 		.color		= S5P_FIMC_RGB565,
 		.memplanes	= 1,
-- 
1.7.7.1

