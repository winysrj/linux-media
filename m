Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4077 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776Ab3BJMuX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 07:50:23 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 10/19] bttv: fix field handling inside TRY_FMT.
Date: Sun, 10 Feb 2013 13:50:05 +0100
Message-Id: <a51e71991c5356cc9a5562b7c520b81d621f6344.1360500224.git.hans.verkuil@cisco.com>
In-Reply-To: <1360500614-15122-1-git-send-email-hverkuil@xs4all.nl>
References: <1360500614-15122-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <7737b9a5554e0487bf83dd3d51cae2d8f76603ab.1360500224.git.hans.verkuil@cisco.com>
References: <7737b9a5554e0487bf83dd3d51cae2d8f76603ab.1360500224.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- don't return -EINVAL for invalid field types, handle those as if it
  was FIELD_ANY.
- the handling of FIELD_SEQ_BT/TB was wrong as well: if such field formats
  aren't supported, then fall back to FIELD_ANY instead of returning an error.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 81886e1..21b38ee 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -2530,6 +2530,7 @@ static int bttv_try_fmt_vid_cap(struct file *file, void *priv,
 	struct bttv *btv = fh->btv;
 	enum v4l2_field field;
 	__s32 width, height;
+	__s32 height2;
 	int rc;
 
 	fmt = format_by_fourcc(f->fmt.pix.pixelformat);
@@ -2538,30 +2539,25 @@ static int bttv_try_fmt_vid_cap(struct file *file, void *priv,
 
 	field = f->fmt.pix.field;
 
-	if (V4L2_FIELD_ANY == field) {
-		__s32 height2;
-
-		height2 = btv->crop[!!fh->do_crop].rect.height >> 1;
-		field = (f->fmt.pix.height > height2)
-			? V4L2_FIELD_INTERLACED
-			: V4L2_FIELD_BOTTOM;
-	}
-
-	if (V4L2_FIELD_SEQ_BT == field)
-		field = V4L2_FIELD_SEQ_TB;
-
 	switch (field) {
 	case V4L2_FIELD_TOP:
 	case V4L2_FIELD_BOTTOM:
 	case V4L2_FIELD_ALTERNATE:
 	case V4L2_FIELD_INTERLACED:
 		break;
+	case V4L2_FIELD_SEQ_BT:
 	case V4L2_FIELD_SEQ_TB:
-		if (fmt->flags & FORMAT_FLAGS_PLANAR)
-			return -EINVAL;
+		if (!(fmt->flags & FORMAT_FLAGS_PLANAR)) {
+			field = V4L2_FIELD_SEQ_TB;
+			break;
+		}
+		/* fall through */
+	default: /* FIELD_ANY case */
+		height2 = btv->crop[!!fh->do_crop].rect.height >> 1;
+		field = (f->fmt.pix.height > height2)
+			? V4L2_FIELD_INTERLACED
+			: V4L2_FIELD_BOTTOM;
 		break;
-	default:
-		return -EINVAL;
 	}
 
 	width = f->fmt.pix.width;
-- 
1.7.10.4

