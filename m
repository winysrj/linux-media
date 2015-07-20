Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:58848 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753031AbbGTNKs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 09:10:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Anatolij Gustschin <agust@denx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/6] fsl-viu: fill in colorspace, always set field to interlaced.
Date: Mon, 20 Jul 2015 15:09:30 +0200
Message-Id: <1437397773-5752-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1437397773-5752-1-git-send-email-hverkuil@xs4all.nl>
References: <1437397773-5752-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- fill in the missing colorspace value.
- don't reject incorrect field values, always replace with a valid value.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/fsl-viu.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index ab8012c..7d0e360 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -597,6 +597,7 @@ static int vidioc_g_fmt_cap(struct file *file, void *priv,
 	f->fmt.pix.bytesperline =
 			(f->fmt.pix.width * fh->fmt->depth) >> 3;
 	f->fmt.pix.sizeimage	= fh->sizeimage;
+	f->fmt.pix.colorspace	= V4L2_COLORSPACE_SMPTE170M;
 	return 0;
 }
 
@@ -604,7 +605,6 @@ static int vidioc_try_fmt_cap(struct file *file, void *priv,
 					struct v4l2_format *f)
 {
 	struct viu_fmt *fmt;
-	enum v4l2_field field;
 	unsigned int maxw, maxh;
 
 	fmt = format_by_fourcc(f->fmt.pix.pixelformat);
@@ -614,19 +614,10 @@ static int vidioc_try_fmt_cap(struct file *file, void *priv,
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
@@ -638,6 +629,7 @@ static int vidioc_try_fmt_cap(struct file *file, void *priv,
 	f->fmt.pix.width &= ~0x03;
 	f->fmt.pix.bytesperline =
 		(f->fmt.pix.width * fmt->depth) >> 3;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 
 	return 0;
 }
-- 
2.1.4

