Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:42148 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756807Ab2EXPQD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 May 2012 11:16:03 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M4J00F68931GT80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 May 2012 16:16:13 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4J002JE92NNH@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 May 2012 16:15:59 +0100 (BST)
Date: Thu, 24 May 2012 17:15:52 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 3/7] s5p-fimc: Honour sizeimage in VIDIOC_S_FMT
In-reply-to: <1337872556-26406-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1337872556-26406-4-git-send-email-s.nawrocki@samsung.com>
References: <1337872556-26406-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow memory buffer size to be increased by means of
struct v4l2_pix_plane_format::sizeimage at VIDIOC_S_FMT ioctl.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    7 ++++---
 drivers/media/video/s5p-fimc/fimc-core.c    |    9 +++++----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 7083107..13df723 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -350,7 +350,8 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
 		if (pixm)
 			sizes[i] = max(size, pixm->plane_fmt[i].sizeimage);
 		else
-			sizes[i] = size;
+			sizes[i] = max_t(u32, size, frame->payload[i]);
+
 		allocators[i] = ctx->fimc_dev->alloc_ctx;
 	}
 
@@ -924,10 +925,10 @@ static int fimc_capture_set_format(struct fimc_dev *fimc, struct v4l2_format *f)
 		pix->width  = mf->width;
 		pix->height = mf->height;
 	}
+
 	fimc_adjust_mplane_format(ff->fmt, pix->width, pix->height, pix);
 	for (i = 0; i < ff->fmt->colplanes; i++)
-		ff->payload[i] =
-			(pix->width * pix->height * ff->fmt->depth[i]) / 8;
+		ff->payload[i] = pix->plane_fmt[i].sizeimage;
 
 	set_frame_bounds(ff, pix->width, pix->height);
 	/* Reset the composition rectangle if not yet configured */
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index fedcd56..330a067 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -741,8 +741,8 @@ void fimc_adjust_mplane_format(struct fimc_fmt *fmt, u32 width, u32 height,
 	pix->width = width;
 
 	for (i = 0; i < pix->num_planes; ++i) {
-		u32 bpl = pix->plane_fmt[i].bytesperline;
-		u32 *sizeimage = &pix->plane_fmt[i].sizeimage;
+		struct v4l2_plane_pix_format *plane_fmt = &pix->plane_fmt[i];
+		u32 bpl = plane_fmt->bytesperline;
 
 		if (fmt->colplanes > 1 && (bpl == 0 || bpl < pix->width))
 			bpl = pix->width; /* Planar */
@@ -754,8 +754,9 @@ void fimc_adjust_mplane_format(struct fimc_fmt *fmt, u32 width, u32 height,
 		if (i == 0) /* Same bytesperline for each plane. */
 			bytesperline = bpl;
 
-		pix->plane_fmt[i].bytesperline = bytesperline;
-		*sizeimage = (pix->width * pix->height * fmt->depth[i]) / 8;
+		plane_fmt->bytesperline = bytesperline;
+		plane_fmt->sizeimage = max((pix->width * pix->height *
+				   fmt->depth[i]) / 8, plane_fmt->sizeimage);
 	}
 }
 
-- 
1.7.10

