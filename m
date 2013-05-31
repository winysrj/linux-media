Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2576 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3EaLPQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 07:15:16 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166])
	(authenticated bits=0)
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id r4VBF0IE059134
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Fri, 31 May 2013 13:15:06 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id C0C7B35E0403
	for <linux-media@vger.kernel.org>; Fri, 31 May 2013 13:14:59 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH for v3.10] v4l2-ioctl: don't print the clips list.
Date: Fri, 31 May 2013 13:14:59 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201305311314.59873.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The clips pointer is a userspace pointer, not a kernelspace pointer.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c |   25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index f81bda1..913f787 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -243,7 +243,6 @@ static void v4l_print_format(const void *arg, bool write_only)
 	const struct v4l2_vbi_format *vbi;
 	const struct v4l2_sliced_vbi_format *sliced;
 	const struct v4l2_window *win;
-	const struct v4l2_clip *clip;
 	unsigned i;
 
 	pr_cont("type=%s", prt_names(p->type, v4l2_type_names));
@@ -284,20 +283,14 @@ static void v4l_print_format(const void *arg, bool write_only)
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
 		win = &p->fmt.win;
-		pr_cont(", wxh=%dx%d, x,y=%d,%d, field=%s, "
-			"chromakey=0x%08x, bitmap=%p, "
-			"global_alpha=0x%02x\n",
-			win->w.width, win->w.height,
-			win->w.left, win->w.top,
+		/* Note: we can't print the clip list here since the clips
+		 * pointer is a userspace pointer, not a kernelspace
+		 * pointer. */
+		pr_cont(", wxh=%dx%d, x,y=%d,%d, field=%s, chromakey=0x%08x, clipcount=%u, clips=%p, bitmap=%p, global_alpha=0x%02x\n",
+			win->w.width, win->w.height, win->w.left, win->w.top,
 			prt_names(win->field, v4l2_field_names),
-			win->chromakey, win->bitmap, win->global_alpha);
-		clip = win->clips;
-		for (i = 0; i < win->clipcount; i++) {
-			printk(KERN_DEBUG "clip %u: wxh=%dx%d, x,y=%d,%d\n",
-					i, clip->c.width, clip->c.height,
-					clip->c.left, clip->c.top);
-			clip = clip->next;
-		}
+			win->chromakey, win->clipcount, win->clips,
+			win->bitmap, win->global_alpha);
 		break;
 	case V4L2_BUF_TYPE_VBI_CAPTURE:
 	case V4L2_BUF_TYPE_VBI_OUTPUT:
@@ -332,7 +325,7 @@ static void v4l_print_framebuffer(const void *arg, bool write_only)
 
 	pr_cont("capability=0x%x, flags=0x%x, base=0x%p, width=%u, "
 		"height=%u, pixelformat=%c%c%c%c, "
-		"bytesperline=%u sizeimage=%u, colorspace=%d\n",
+		"bytesperline=%u, sizeimage=%u, colorspace=%d\n",
 			p->capability, p->flags, p->base,
 			p->fmt.width, p->fmt.height,
 			(p->fmt.pixelformat & 0xff),
@@ -445,7 +438,7 @@ static void v4l_print_buffer(const void *arg, bool write_only)
 		for (i = 0; i < p->length; ++i) {
 			plane = &p->m.planes[i];
 			printk(KERN_DEBUG
-				"plane %d: bytesused=%d, data_offset=0x%08x "
+				"plane %d: bytesused=%d, data_offset=0x%08x, "
 				"offset/userptr=0x%lx, length=%d\n",
 				i, plane->bytesused, plane->data_offset,
 				plane->m.userptr, plane->length);
-- 
1.7.10.4

