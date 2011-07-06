Return-path: <mchehab@localhost>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:19387 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab1GFJX2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2011 05:23:28 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LNW00EWONF2R3@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Jul 2011 10:23:26 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNW001K5NF1BE@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Jul 2011 10:23:25 +0100 (BST)
Date: Wed, 06 Jul 2011 11:23:13 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH] v4l: remove single to multiplane conversion
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, mchehab@redhat.com, pawel@osciak.com
Message-id: <1309944193-11275-1-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

This patch removes an implicit conversion between multi and single plane
formats from V4L2 framework. The conversion is to be performed by libv4l2.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/v4l2-ioctl.c |  250 ++------------------------------------
 1 files changed, 12 insertions(+), 238 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 213ba7d..07f2abd 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -476,63 +476,6 @@ static int check_fmt(const struct v4l2_ioctl_ops *ops, enum v4l2_buf_type type)
 	return -EINVAL;
 }
 
-/**
- * fmt_sp_to_mp() - Convert a single-plane format to its multi-planar 1-plane
- * equivalent
- */
-static int fmt_sp_to_mp(const struct v4l2_format *f_sp,
-			struct v4l2_format *f_mp)
-{
-	struct v4l2_pix_format_mplane *pix_mp = &f_mp->fmt.pix_mp;
-	const struct v4l2_pix_format *pix = &f_sp->fmt.pix;
-
-	if (f_sp->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		f_mp->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
-	else if (f_sp->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
-		f_mp->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
-	else
-		return -EINVAL;
-
-	pix_mp->width = pix->width;
-	pix_mp->height = pix->height;
-	pix_mp->pixelformat = pix->pixelformat;
-	pix_mp->field = pix->field;
-	pix_mp->colorspace = pix->colorspace;
-	pix_mp->num_planes = 1;
-	pix_mp->plane_fmt[0].sizeimage = pix->sizeimage;
-	pix_mp->plane_fmt[0].bytesperline = pix->bytesperline;
-
-	return 0;
-}
-
-/**
- * fmt_mp_to_sp() - Convert a multi-planar 1-plane format to its single-planar
- * equivalent
- */
-static int fmt_mp_to_sp(const struct v4l2_format *f_mp,
-			struct v4l2_format *f_sp)
-{
-	const struct v4l2_pix_format_mplane *pix_mp = &f_mp->fmt.pix_mp;
-	struct v4l2_pix_format *pix = &f_sp->fmt.pix;
-
-	if (f_mp->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
-		f_sp->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	else if (f_mp->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
-		f_sp->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
-	else
-		return -EINVAL;
-
-	pix->width = pix_mp->width;
-	pix->height = pix_mp->height;
-	pix->pixelformat = pix_mp->pixelformat;
-	pix->field = pix_mp->field;
-	pix->colorspace = pix_mp->colorspace;
-	pix->sizeimage = pix_mp->plane_fmt[0].sizeimage;
-	pix->bytesperline = pix_mp->plane_fmt[0].bytesperline;
-
-	return 0;
-}
-
 static long __video_do_ioctl(struct file *file,
 		unsigned int cmd, void *arg)
 {
@@ -540,7 +483,6 @@ static long __video_do_ioctl(struct file *file,
 	const struct v4l2_ioctl_ops *ops = vfd->ioctl_ops;
 	void *fh = file->private_data;
 	struct v4l2_fh *vfh = NULL;
-	struct v4l2_format f_copy;
 	int use_fh_prio = 0;
 	long ret = -EINVAL;
 
@@ -702,42 +644,15 @@ static long __video_do_ioctl(struct file *file,
 
 		switch (f->type) {
 		case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-			if (ops->vidioc_g_fmt_vid_cap) {
+			if (ops->vidioc_g_fmt_vid_cap)
 				ret = ops->vidioc_g_fmt_vid_cap(file, fh, f);
-			} else if (ops->vidioc_g_fmt_vid_cap_mplane) {
-				if (fmt_sp_to_mp(f, &f_copy))
-					break;
-				ret = ops->vidioc_g_fmt_vid_cap_mplane(file, fh,
-								       &f_copy);
-				if (ret)
-					break;
-
-				/* Driver is currently in multi-planar format,
-				 * we can't return it in single-planar API*/
-				if (f_copy.fmt.pix_mp.num_planes > 1) {
-					ret = -EBUSY;
-					break;
-				}
-
-				ret = fmt_mp_to_sp(&f_copy, f);
-			}
 			if (!ret)
 				v4l_print_pix_fmt(vfd, &f->fmt.pix);
 			break;
 		case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
-			if (ops->vidioc_g_fmt_vid_cap_mplane) {
+			if (ops->vidioc_g_fmt_vid_cap_mplane)
 				ret = ops->vidioc_g_fmt_vid_cap_mplane(file,
 									fh, f);
-			} else if (ops->vidioc_g_fmt_vid_cap) {
-				if (fmt_mp_to_sp(f, &f_copy))
-					break;
-				ret = ops->vidioc_g_fmt_vid_cap(file,
-								fh, &f_copy);
-				if (ret)
-					break;
-
-				ret = fmt_sp_to_mp(&f_copy, f);
-			}
 			if (!ret)
 				v4l_print_pix_fmt_mplane(vfd, &f->fmt.pix_mp);
 			break;
@@ -747,42 +662,15 @@ static long __video_do_ioctl(struct file *file,
 								    fh, f);
 			break;
 		case V4L2_BUF_TYPE_VIDEO_OUTPUT:
-			if (ops->vidioc_g_fmt_vid_out) {
+			if (ops->vidioc_g_fmt_vid_out)
 				ret = ops->vidioc_g_fmt_vid_out(file, fh, f);
-			} else if (ops->vidioc_g_fmt_vid_out_mplane) {
-				if (fmt_sp_to_mp(f, &f_copy))
-					break;
-				ret = ops->vidioc_g_fmt_vid_out_mplane(file, fh,
-									&f_copy);
-				if (ret)
-					break;
-
-				/* Driver is currently in multi-planar format,
-				 * we can't return it in single-planar API*/
-				if (f_copy.fmt.pix_mp.num_planes > 1) {
-					ret = -EBUSY;
-					break;
-				}
-
-				ret = fmt_mp_to_sp(&f_copy, f);
-			}
 			if (!ret)
 				v4l_print_pix_fmt(vfd, &f->fmt.pix);
 			break;
 		case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
-			if (ops->vidioc_g_fmt_vid_out_mplane) {
+			if (ops->vidioc_g_fmt_vid_out_mplane)
 				ret = ops->vidioc_g_fmt_vid_out_mplane(file,
 									fh, f);
-			} else if (ops->vidioc_g_fmt_vid_out) {
-				if (fmt_mp_to_sp(f, &f_copy))
-					break;
-				ret = ops->vidioc_g_fmt_vid_out(file,
-								fh, &f_copy);
-				if (ret)
-					break;
-
-				ret = fmt_sp_to_mp(&f_copy, f);
-			}
 			if (!ret)
 				v4l_print_pix_fmt_mplane(vfd, &f->fmt.pix_mp);
 			break;
@@ -829,44 +717,15 @@ static long __video_do_ioctl(struct file *file,
 		case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 			CLEAR_AFTER_FIELD(f, fmt.pix);
 			v4l_print_pix_fmt(vfd, &f->fmt.pix);
-			if (ops->vidioc_s_fmt_vid_cap) {
+			if (ops->vidioc_s_fmt_vid_cap)
 				ret = ops->vidioc_s_fmt_vid_cap(file, fh, f);
-			} else if (ops->vidioc_s_fmt_vid_cap_mplane) {
-				if (fmt_sp_to_mp(f, &f_copy))
-					break;
-				ret = ops->vidioc_s_fmt_vid_cap_mplane(file, fh,
-									&f_copy);
-				if (ret)
-					break;
-
-				if (f_copy.fmt.pix_mp.num_planes > 1) {
-					/* Drivers shouldn't adjust from 1-plane
-					 * to more than 1-plane formats */
-					ret = -EBUSY;
-					WARN_ON(1);
-					break;
-				}
-
-				ret = fmt_mp_to_sp(&f_copy, f);
-			}
 			break;
 		case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 			CLEAR_AFTER_FIELD(f, fmt.pix_mp);
 			v4l_print_pix_fmt_mplane(vfd, &f->fmt.pix_mp);
-			if (ops->vidioc_s_fmt_vid_cap_mplane) {
+			if (ops->vidioc_s_fmt_vid_cap_mplane)
 				ret = ops->vidioc_s_fmt_vid_cap_mplane(file,
 									fh, f);
-			} else if (ops->vidioc_s_fmt_vid_cap &&
-					f->fmt.pix_mp.num_planes == 1) {
-				if (fmt_mp_to_sp(f, &f_copy))
-					break;
-				ret = ops->vidioc_s_fmt_vid_cap(file,
-								fh, &f_copy);
-				if (ret)
-					break;
-
-				ret = fmt_sp_to_mp(&f_copy, f);
-			}
 			break;
 		case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 			CLEAR_AFTER_FIELD(f, fmt.win);
@@ -877,44 +736,15 @@ static long __video_do_ioctl(struct file *file,
 		case V4L2_BUF_TYPE_VIDEO_OUTPUT:
 			CLEAR_AFTER_FIELD(f, fmt.pix);
 			v4l_print_pix_fmt(vfd, &f->fmt.pix);
-			if (ops->vidioc_s_fmt_vid_out) {
+			if (ops->vidioc_s_fmt_vid_out)
 				ret = ops->vidioc_s_fmt_vid_out(file, fh, f);
-			} else if (ops->vidioc_s_fmt_vid_out_mplane) {
-				if (fmt_sp_to_mp(f, &f_copy))
-					break;
-				ret = ops->vidioc_s_fmt_vid_out_mplane(file, fh,
-									&f_copy);
-				if (ret)
-					break;
-
-				if (f_copy.fmt.pix_mp.num_planes > 1) {
-					/* Drivers shouldn't adjust from 1-plane
-					 * to more than 1-plane formats */
-					ret = -EBUSY;
-					WARN_ON(1);
-					break;
-				}
-
-				ret = fmt_mp_to_sp(&f_copy, f);
-			}
 			break;
 		case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
 			CLEAR_AFTER_FIELD(f, fmt.pix_mp);
 			v4l_print_pix_fmt_mplane(vfd, &f->fmt.pix_mp);
-			if (ops->vidioc_s_fmt_vid_out_mplane) {
+			if (ops->vidioc_s_fmt_vid_out_mplane)
 				ret = ops->vidioc_s_fmt_vid_out_mplane(file,
 									fh, f);
-			} else if (ops->vidioc_s_fmt_vid_out &&
-					f->fmt.pix_mp.num_planes == 1) {
-				if (fmt_mp_to_sp(f, &f_copy))
-					break;
-				ret = ops->vidioc_s_fmt_vid_out(file,
-								fh, &f_copy);
-				if (ret)
-					break;
-
-				ret = fmt_mp_to_sp(&f_copy, f);
-			}
 			break;
 		case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
 			CLEAR_AFTER_FIELD(f, fmt.win);
@@ -963,44 +793,16 @@ static long __video_do_ioctl(struct file *file,
 		switch (f->type) {
 		case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 			CLEAR_AFTER_FIELD(f, fmt.pix);
-			if (ops->vidioc_try_fmt_vid_cap) {
+			if (ops->vidioc_try_fmt_vid_cap)
 				ret = ops->vidioc_try_fmt_vid_cap(file, fh, f);
-			} else if (ops->vidioc_try_fmt_vid_cap_mplane) {
-				if (fmt_sp_to_mp(f, &f_copy))
-					break;
-				ret = ops->vidioc_try_fmt_vid_cap_mplane(file,
-								fh, &f_copy);
-				if (ret)
-					break;
-
-				if (f_copy.fmt.pix_mp.num_planes > 1) {
-					/* Drivers shouldn't adjust from 1-plane
-					 * to more than 1-plane formats */
-					ret = -EBUSY;
-					WARN_ON(1);
-					break;
-				}
-				ret = fmt_mp_to_sp(&f_copy, f);
-			}
 			if (!ret)
 				v4l_print_pix_fmt(vfd, &f->fmt.pix);
 			break;
 		case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 			CLEAR_AFTER_FIELD(f, fmt.pix_mp);
-			if (ops->vidioc_try_fmt_vid_cap_mplane) {
+			if (ops->vidioc_try_fmt_vid_cap_mplane)
 				ret = ops->vidioc_try_fmt_vid_cap_mplane(file,
 									 fh, f);
-			} else if (ops->vidioc_try_fmt_vid_cap &&
-					f->fmt.pix_mp.num_planes == 1) {
-				if (fmt_mp_to_sp(f, &f_copy))
-					break;
-				ret = ops->vidioc_try_fmt_vid_cap(file,
-								  fh, &f_copy);
-				if (ret)
-					break;
-
-				ret = fmt_sp_to_mp(&f_copy, f);
-			}
 			if (!ret)
 				v4l_print_pix_fmt_mplane(vfd, &f->fmt.pix_mp);
 			break;
@@ -1012,44 +814,16 @@ static long __video_do_ioctl(struct file *file,
 			break;
 		case V4L2_BUF_TYPE_VIDEO_OUTPUT:
 			CLEAR_AFTER_FIELD(f, fmt.pix);
-			if (ops->vidioc_try_fmt_vid_out) {
+			if (ops->vidioc_try_fmt_vid_out)
 				ret = ops->vidioc_try_fmt_vid_out(file, fh, f);
-			} else if (ops->vidioc_try_fmt_vid_out_mplane) {
-				if (fmt_sp_to_mp(f, &f_copy))
-					break;
-				ret = ops->vidioc_try_fmt_vid_out_mplane(file,
-								fh, &f_copy);
-				if (ret)
-					break;
-
-				if (f_copy.fmt.pix_mp.num_planes > 1) {
-					/* Drivers shouldn't adjust from 1-plane
-					 * to more than 1-plane formats */
-					ret = -EBUSY;
-					WARN_ON(1);
-					break;
-				}
-				ret = fmt_mp_to_sp(&f_copy, f);
-			}
 			if (!ret)
 				v4l_print_pix_fmt(vfd, &f->fmt.pix);
 			break;
 		case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
 			CLEAR_AFTER_FIELD(f, fmt.pix_mp);
-			if (ops->vidioc_try_fmt_vid_out_mplane) {
+			if (ops->vidioc_try_fmt_vid_out_mplane)
 				ret = ops->vidioc_try_fmt_vid_out_mplane(file,
 									 fh, f);
-			} else if (ops->vidioc_try_fmt_vid_out &&
-					f->fmt.pix_mp.num_planes == 1) {
-				if (fmt_mp_to_sp(f, &f_copy))
-					break;
-				ret = ops->vidioc_try_fmt_vid_out(file,
-								  fh, &f_copy);
-				if (ret)
-					break;
-
-				ret = fmt_sp_to_mp(&f_copy, f);
-			}
 			if (!ret)
 				v4l_print_pix_fmt_mplane(vfd, &f->fmt.pix_mp);
 			break;
-- 
1.7.5.4

