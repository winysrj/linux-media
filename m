Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1530 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab3BPKSo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 05:18:44 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Anatolij Gustschin <agust@denx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 3/5] fsl-viu: fill in colorspace, zero priv, always set field to interlaced.
Date: Sat, 16 Feb 2013 11:18:25 +0100
Message-Id: <ffd01d9a6ca2b91e5eb1c691409713963e96eba5.1361009701.git.hans.verkuil@cisco.com>
In-Reply-To: <1361009907-30990-1-git-send-email-hverkuil@xs4all.nl>
References: <1361009907-30990-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <77816a8ba6f0fe685a83a012371cf07b1ab505da.1361009701.git.hans.verkuil@cisco.com>
References: <77816a8ba6f0fe685a83a012371cf07b1ab505da.1361009701.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- fill in the missing colorspace value.
- the priv field of v4l2_pix_format must be zeroed.
- don't reject incorrect field values, always replace with a valid value.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/fsl-viu.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index 1567878..961fc72 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -595,6 +595,8 @@ static int vidioc_g_fmt_cap(struct file *file, void *priv,
 	f->fmt.pix.bytesperline =
 			(f->fmt.pix.width * fh->fmt->depth) >> 3;
 	f->fmt.pix.sizeimage	= fh->sizeimage;
+	f->fmt.pix.colorspace	= V4L2_COLORSPACE_SMPTE170M;
+	f->fmt.pix.priv		= 0;
 	return 0;
 }
 
@@ -602,7 +604,6 @@ static int vidioc_try_fmt_cap(struct file *file, void *priv,
 					struct v4l2_format *f)
 {
 	struct viu_fmt *fmt;
-	enum v4l2_field field;
 	unsigned int maxw, maxh;
 
 	fmt = format_by_fourcc(f->fmt.pix.pixelformat);
@@ -612,19 +613,10 @@ static int vidioc_try_fmt_cap(struct file *file, void *priv,
 		return -EINVAL;
 	}
 
-	field = f->fmt.pix.field;
-
-	if (field == V4L2_FIELD_ANY) {
-		field = V4L2_FIELD_INTERLACED;
-	} else if (field != V4L2_FIELD_INTERLACED) {
-		dprintk(1, "Field type invalid.\n");
-		return -EINVAL;
-	}
-
 	maxw  = norm_maxw();
 	maxh  = norm_maxh();
 
-	f->fmt.pix.field = field;
+	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
 	if (f->fmt.pix.height < 32)
 		f->fmt.pix.height = 32;
 	if (f->fmt.pix.height > maxh)
@@ -636,6 +628,8 @@ static int vidioc_try_fmt_cap(struct file *file, void *priv,
 	f->fmt.pix.width &= ~0x03;
 	f->fmt.pix.bytesperline =
 		(f->fmt.pix.width * fmt->depth) >> 3;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
+	f->fmt.pix.priv = 0;
 
 	return 0;
 }
-- 
1.7.10.4

