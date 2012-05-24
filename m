Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:64539 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530Ab2EXPQC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 May 2012 11:16:02 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M4J0065T9199O80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 May 2012 16:15:09 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4J007OS92LIF@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 May 2012 16:15:58 +0100 (BST)
Date: Thu, 24 May 2012 17:15:53 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 4/7] s5p-fimc: Remove superfluous checks for buffer type
In-reply-to: <1337872556-26406-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1337872556-26406-5-git-send-email-s.nawrocki@samsung.com>
References: <1337872556-26406-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The checks are already done at the v4l2 framework.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 13df723..0fd12df 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -819,9 +819,6 @@ static int fimc_cap_g_fmt_mplane(struct file *file, void *fh,
 	struct fimc_dev *fimc = video_drvdata(file);
 	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
 
-	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
-		return -EINVAL;
-
 	return fimc_fill_format(&ctx->d_frame, f);
 }
 
@@ -834,9 +831,6 @@ static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
 	struct v4l2_mbus_framefmt mf;
 	struct fimc_fmt *ffmt = NULL;
 
-	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
-		return -EINVAL;
-
 	if (pix->pixelformat == V4L2_PIX_FMT_JPEG) {
 		fimc_capture_try_format(ctx, &pix->width, &pix->height,
 					NULL, &pix->pixelformat,
@@ -888,8 +882,6 @@ static int fimc_capture_set_format(struct fimc_dev *fimc, struct v4l2_format *f)
 	struct fimc_fmt *s_fmt = NULL;
 	int ret, i;
 
-	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
-		return -EINVAL;
 	if (vb2_is_busy(&fimc->vid_cap.vbq))
 		return -EBUSY;
 
-- 
1.7.10

