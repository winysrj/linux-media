Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2709 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757330Ab3BFP4w (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 10:56:52 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 11/17] bttv: fix field handling inside TRY_FMT.
Date: Wed,  6 Feb 2013 16:56:29 +0100
Message-Id: <e0e83c8d11f101b0700aeae3d644eb86083499ee.1360165855.git.hans.verkuil@cisco.com>
In-Reply-To: <1360166195-18010-1-git-send-email-hverkuil@xs4all.nl>
References: <1360166195-18010-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <c5d83e654c3cfd166ee832f83458c19904851980.1360165855.git.hans.verkuil@cisco.com>
References: <c5d83e654c3cfd166ee832f83458c19904851980.1360165855.git.hans.verkuil@cisco.com>
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

