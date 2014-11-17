Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:52195 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753062AbaKQORS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 09:17:18 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 3/8] v4l2-ioctl.c: log the new ycbcr_enc and quantization fields
Date: Mon, 17 Nov 2014 15:16:49 +0100
Message-Id: <1416233814-40579-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1416233814-40579-1-git-send-email-hverkuil@xs4all.nl>
References: <1416233814-40579-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Log the new ycbcr_enc and quantization fields. Note that it now
also logs the flags field for the multiplanar buffer type. This was
forgotten when the flags field was added.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 9ccb19a..aced84d 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -257,7 +257,7 @@ static void v4l_print_format(const void *arg, bool write_only)
 		pr_cont(", width=%u, height=%u, "
 			"pixelformat=%c%c%c%c, field=%s, "
 			"bytesperline=%u, sizeimage=%u, colorspace=%d, "
-			"flags %u\n",
+			"flags %x, ycbcr_enc=%u, quantization=%u\n",
 			pix->width, pix->height,
 			(pix->pixelformat & 0xff),
 			(pix->pixelformat >>  8) & 0xff,
@@ -265,21 +265,24 @@ static void v4l_print_format(const void *arg, bool write_only)
 			(pix->pixelformat >> 24) & 0xff,
 			prt_names(pix->field, v4l2_field_names),
 			pix->bytesperline, pix->sizeimage,
-			pix->colorspace, pix->flags);
+			pix->colorspace, pix->flags, pix->ycbcr_enc,
+			pix->quantization);
 		break;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
 		mp = &p->fmt.pix_mp;
 		pr_cont(", width=%u, height=%u, "
 			"format=%c%c%c%c, field=%s, "
-			"colorspace=%d, num_planes=%u\n",
+			"colorspace=%d, num_planes=%u, flags=%x, "
+			"ycbcr_enc=%u, quantization=%u\n",
 			mp->width, mp->height,
 			(mp->pixelformat & 0xff),
 			(mp->pixelformat >>  8) & 0xff,
 			(mp->pixelformat >> 16) & 0xff,
 			(mp->pixelformat >> 24) & 0xff,
 			prt_names(mp->field, v4l2_field_names),
-			mp->colorspace, mp->num_planes);
+			mp->colorspace, mp->num_planes, mp->flags,
+			mp->ycbcr_enc, mp->quantization);
 		for (i = 0; i < mp->num_planes; i++)
 			printk(KERN_DEBUG "plane %u: bytesperline=%u sizeimage=%u\n", i,
 					mp->plane_fmt[i].bytesperline,
-- 
2.1.1

