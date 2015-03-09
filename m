Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:53894 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752293AbbCIPpH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:45:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 01/29] vivid: the overlay API wasn't disabled completely for multiplanar
Date: Mon,  9 Mar 2015 16:44:23 +0100
Message-Id: <1425915891-1017-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

If the vivid driver is loaded in multiplanar mode, then the capture overlay
functionality should be disabled. This wasn't fully done, which led to
v4l2-compliance errors.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-vid-cap.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 867a29a..550945a 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -1012,8 +1012,12 @@ int vivid_vid_cap_cropcap(struct file *file, void *priv,
 int vidioc_enum_fmt_vid_overlay(struct file *file, void  *priv,
 					struct v4l2_fmtdesc *f)
 {
+	struct vivid_dev *dev = video_drvdata(file);
 	const struct vivid_fmt *fmt;
 
+	if (dev->multiplanar)
+		return -ENOTTY;
+
 	if (f->index >= ARRAY_SIZE(formats_ovl))
 		return -EINVAL;
 
@@ -1032,6 +1036,9 @@ int vidioc_g_fmt_vid_overlay(struct file *file, void *priv,
 	struct v4l2_window *win = &f->fmt.win;
 	unsigned clipcount = win->clipcount;
 
+	if (dev->multiplanar)
+		return -ENOTTY;
+
 	win->w.top = dev->overlay_cap_top;
 	win->w.left = dev->overlay_cap_left;
 	win->w.width = compose->width;
@@ -1063,6 +1070,9 @@ int vidioc_try_fmt_vid_overlay(struct file *file, void *priv,
 	struct v4l2_window *win = &f->fmt.win;
 	int i, j;
 
+	if (dev->multiplanar)
+		return -ENOTTY;
+
 	win->w.left = clamp_t(int, win->w.left,
 			      -dev->fb_cap.fmt.width, dev->fb_cap.fmt.width);
 	win->w.top = clamp_t(int, win->w.top,
@@ -1150,6 +1160,9 @@ int vivid_vid_cap_overlay(struct file *file, void *fh, unsigned i)
 {
 	struct vivid_dev *dev = video_drvdata(file);
 
+	if (dev->multiplanar)
+		return -ENOTTY;
+
 	if (i && dev->fb_vbase_cap == NULL)
 		return -EINVAL;
 
@@ -1169,6 +1182,9 @@ int vivid_vid_cap_g_fbuf(struct file *file, void *fh,
 {
 	struct vivid_dev *dev = video_drvdata(file);
 
+	if (dev->multiplanar)
+		return -ENOTTY;
+
 	*a = dev->fb_cap;
 	a->capability = V4L2_FBUF_CAP_BITMAP_CLIPPING |
 			V4L2_FBUF_CAP_LIST_CLIPPING;
@@ -1185,6 +1201,9 @@ int vivid_vid_cap_s_fbuf(struct file *file, void *fh,
 	struct vivid_dev *dev = video_drvdata(file);
 	const struct vivid_fmt *fmt;
 
+	if (dev->multiplanar)
+		return -ENOTTY;
+
 	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
 		return -EPERM;
 
-- 
2.1.4

