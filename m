Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:39934 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916Ab2JBI5e (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 04:57:34 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Anatolij Gustschin <agust@denx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC PATCH 2/3] s5p-fimc: fix compiler warning
Date: Tue,  2 Oct 2012 10:57:19 +0200
Message-Id: <6311a7c997a9020117d78855d80384468e585601.1349168132.git.hans.verkuil@cisco.com>
In-Reply-To: <1349168240-29269-1-git-send-email-hans.verkuil@cisco.com>
References: <1349168240-29269-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <760bdb23b40b9ce3a8044a3379510889db4bfcf7.1349168132.git.hans.verkuil@cisco.com>
References: <760bdb23b40b9ce3a8044a3379510889db4bfcf7.1349168132.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/s5p-fimc/fimc-m2m.c:561:2: warning: passing argument 2 of 'fimc_m2m_try_crop' discards 'const' qualifier from pointer target type [enabled by default]
drivers/media/platform/s5p-fimc/fimc-m2m.c:502:12: note: expected 'struct v4l2_crop *' but argument is of type 'const struct v4l2_crop *'

This is fall-out from this commit:

commit 4f996594ceaf6c3f9bc42b40c40b0f7f87b79c86
Author: Hans Verkuil <hans.verkuil@cisco.com>
Date:   Wed Sep 5 05:10:48 2012 -0300

    [media] v4l2: make vidioc_s_crop const

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/s5p-fimc/fimc-m2m.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-m2m.c b/drivers/media/platform/s5p-fimc/fimc-m2m.c
index 51fc04c..03def3d 100644
--- a/drivers/media/platform/s5p-fimc/fimc-m2m.c
+++ b/drivers/media/platform/s5p-fimc/fimc-m2m.c
@@ -551,30 +551,31 @@ static int fimc_m2m_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr)
 	return 0;
 }
 
-static int fimc_m2m_s_crop(struct file *file, void *fh, const struct v4l2_crop *cr)
+static int fimc_m2m_s_crop(struct file *file, void *fh, const struct v4l2_crop *crop)
 {
 	struct fimc_ctx *ctx = fh_to_ctx(fh);
 	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct v4l2_crop cr = *crop;
 	struct fimc_frame *f;
 	int ret;
 
-	ret = fimc_m2m_try_crop(ctx, cr);
+	ret = fimc_m2m_try_crop(ctx, &cr);
 	if (ret)
 		return ret;
 
-	f = (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) ?
+	f = (cr.type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) ?
 		&ctx->s_frame : &ctx->d_frame;
 
 	/* Check to see if scaling ratio is within supported range */
 	if (fimc_ctx_state_is_set(FIMC_DST_FMT | FIMC_SRC_FMT, ctx)) {
-		if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-			ret = fimc_check_scaler_ratio(ctx, cr->c.width,
-					cr->c.height, ctx->d_frame.width,
+		if (cr.type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+			ret = fimc_check_scaler_ratio(ctx, cr.c.width,
+					cr.c.height, ctx->d_frame.width,
 					ctx->d_frame.height, ctx->rotation);
 		} else {
 			ret = fimc_check_scaler_ratio(ctx, ctx->s_frame.width,
-					ctx->s_frame.height, cr->c.width,
-					cr->c.height, ctx->rotation);
+					ctx->s_frame.height, cr.c.width,
+					cr.c.height, ctx->rotation);
 		}
 		if (ret) {
 			v4l2_err(&fimc->m2m.vfd, "Out of scaler range\n");
@@ -582,10 +583,10 @@ static int fimc_m2m_s_crop(struct file *file, void *fh, const struct v4l2_crop *
 		}
 	}
 
-	f->offs_h = cr->c.left;
-	f->offs_v = cr->c.top;
-	f->width  = cr->c.width;
-	f->height = cr->c.height;
+	f->offs_h = cr.c.left;
+	f->offs_v = cr.c.top;
+	f->width  = cr.c.width;
+	f->height = cr.c.height;
 
 	fimc_ctx_state_set(FIMC_PARAMS, ctx);
 
-- 
1.7.10.4

