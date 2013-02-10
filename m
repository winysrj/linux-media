Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1985 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab3BJMuZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 07:50:25 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 18/19] bttv: fix try_fmt_vid_overlay and setup initial overlay size.
Date: Sun, 10 Feb 2013 13:50:13 +0100
Message-Id: <9f4d9c08fa2ef4dcb0e6c47ddfe97d467f48cf02.1360500224.git.hans.verkuil@cisco.com>
In-Reply-To: <1360500614-15122-1-git-send-email-hverkuil@xs4all.nl>
References: <1360500614-15122-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <7737b9a5554e0487bf83dd3d51cae2d8f76603ab.1360500224.git.hans.verkuil@cisco.com>
References: <7737b9a5554e0487bf83dd3d51cae2d8f76603ab.1360500224.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

try_fmt_vid_overlay should map incorrect sizes and fields to valid values.

It also expects that an initial overlay size is defined so g_fmt_vid_overlay
returns valid information.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c |   44 +++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 0492fff..6518a61 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -2111,22 +2111,33 @@ limit_scaled_size_lock       (struct bttv_fh *               fh,
    may also adjust the current cropping parameters to get closer
    to the desired window size. */
 static int
-verify_window_lock		(struct bttv_fh *               fh,
-			 struct v4l2_window *           win,
-			 int                            adjust_size,
-			 int                            adjust_crop)
+verify_window_lock(struct bttv_fh *fh, struct v4l2_window *win,
+			 int adjust_size, int adjust_crop)
 {
 	enum v4l2_field field;
 	unsigned int width_mask;
 	int rc;
 
-	if (win->w.width  < 48 || win->w.height < 32)
-		return -EINVAL;
+	if (win->w.width < 48)
+		win->w.width = 48;
+	if (win->w.height < 32)
+		win->w.height = 32;
 	if (win->clipcount > 2048)
-		return -EINVAL;
+		win->clipcount = 2048;
 
+	win->chromakey = 0;
+	win->global_alpha = 0;
 	field = win->field;
 
+	switch (field) {
+	case V4L2_FIELD_TOP:
+	case V4L2_FIELD_BOTTOM:
+	case V4L2_FIELD_INTERLACED:
+		break;
+	default:
+		field = V4L2_FIELD_ANY;
+		break;
+	}
 	if (V4L2_FIELD_ANY == field) {
 		__s32 height2;
 
@@ -2135,18 +2146,11 @@ verify_window_lock		(struct bttv_fh *               fh,
 			? V4L2_FIELD_INTERLACED
 			: V4L2_FIELD_TOP;
 	}
-	switch (field) {
-	case V4L2_FIELD_TOP:
-	case V4L2_FIELD_BOTTOM:
-	case V4L2_FIELD_INTERLACED:
-		break;
-	default:
-		return -EINVAL;
-	}
+	win->field = field;
 
-	/* 4-byte alignment. */
 	if (NULL == fh->ovfmt)
 		return -EINVAL;
+	/* 4-byte alignment. */
 	width_mask = ~0;
 	switch (fh->ovfmt->depth) {
 	case 8:
@@ -2171,8 +2175,6 @@ verify_window_lock		(struct bttv_fh *               fh,
 			       adjust_size, adjust_crop);
 	if (0 != rc)
 		return rc;
-
-	win->field = field;
 	return 0;
 }
 
@@ -2407,9 +2409,10 @@ static int bttv_try_fmt_vid_overlay(struct file *file, void *priv,
 {
 	struct bttv_fh *fh = priv;
 
-	return verify_window_lock(fh, &f->fmt.win,
+	verify_window_lock(fh, &f->fmt.win,
 			/* adjust_size */ 1,
 			/* adjust_crop */ 0);
+	return 0;
 }
 
 static int bttv_s_fmt_vid_cap(struct file *file, void *priv,
@@ -4127,6 +4130,9 @@ static int bttv_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
 	btv->init.fmt         = format_by_fourcc(V4L2_PIX_FMT_BGR24);
 	btv->init.width       = 320;
 	btv->init.height      = 240;
+	btv->init.ov.w.width  = 320;
+	btv->init.ov.w.height = 240;
+	btv->init.ov.field    = V4L2_FIELD_INTERLACED;
 	btv->input = 0;
 
 	v4l2_ctrl_new_std(hdl, &bttv_ctrl_ops,
-- 
1.7.10.4

