Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:61623 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbZEBF6G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 May 2009 01:58:06 -0400
Message-ID: <49FBDF1F.1030508@freemail.hu>
Date: Sat, 02 May 2009 07:50:23 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Trent Piepho <xyzzy@speakeasy.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] v4l2: fill the reserved fields of VIDIOC_REQBUFS ioctl
References: <49F8A325.7060303@freemail.hu> <Pine.LNX.4.58.0904300803410.7837@shell2.speakeasy.net> <Pine.LNX.4.58.0904300916250.7837@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0904300916250.7837@shell2.speakeasy.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Trent Piepho <xyzzy@speakeasy.org>

Some ioctls have structs that are a different size depending on what type
of buffer is being used.  If the buffer type leaves a field unused or has
padding space at the end, this space should be zeroed out. This patch modifies
the VIDIOC_S_FMT, VIDIOC_TRY_FMT and VIDIOC_REQBUFS ioctls [1].

The problems with S_FMT and REQBUFS were original identified and patched by
Márton Németh.

The patch was tested with v4l-test 0.13 [2] with vivi driver.

References:
[1] V4L2 API specification, revision 0.24
    http://v4l2spec.bytesex.org/spec/r10944.htm
    http://v4l2spec.bytesex.org/spec/r13696.htm

[2] v4l-test: Test environment for Video For Linux Two API
    http://v4l-test.sourceforge.net/

Priority: normal

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>
Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux-2.6.30-rc4/drivers/media/video/v4l2-ioctl.c.orig	2009-05-01 23:31:22.000000000 +0200
+++ linux-2.6.30-rc4/drivers/media/video/v4l2-ioctl.c	2009-05-02 07:14:11.000000000 +0200
@@ -42,6 +42,12 @@
 			printk(KERN_DEBUG "%s: " fmt, vfd->name, ## arg);\
 		} while (0)

+/* Zero out the end of the struct pointed to by p.  Everthing after, but
+ * not including, the specified field is cleared. */
+#define CLEAR_AFTER_FIELD(p, field) \
+	memset((u8 *)(p) + offsetof(typeof(*(p)), field) + sizeof((p)->field), \
+	0, sizeof(*(p)) - offsetof(typeof(*(p)), field) - sizeof((p)->field))
+
 struct std_descr {
 	v4l2_std_id std;
 	const char *descr;
@@ -782,44 +788,53 @@

 		switch (f->type) {
 		case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+			CLEAR_AFTER_FIELD(f, fmt.pix);
 			v4l_print_pix_fmt(vfd, &f->fmt.pix);
 			if (ops->vidioc_s_fmt_vid_cap)
 				ret = ops->vidioc_s_fmt_vid_cap(file, fh, f);
 			break;
 		case V4L2_BUF_TYPE_VIDEO_OVERLAY:
+			CLEAR_AFTER_FIELD(f, fmt.win);
 			if (ops->vidioc_s_fmt_vid_overlay)
 				ret = ops->vidioc_s_fmt_vid_overlay(file,
 								    fh, f);
 			break;
 		case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+			CLEAR_AFTER_FIELD(f, fmt.pix);
 			v4l_print_pix_fmt(vfd, &f->fmt.pix);
 			if (ops->vidioc_s_fmt_vid_out)
 				ret = ops->vidioc_s_fmt_vid_out(file, fh, f);
 			break;
 		case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
+			CLEAR_AFTER_FIELD(f, fmt.win);
 			if (ops->vidioc_s_fmt_vid_out_overlay)
 				ret = ops->vidioc_s_fmt_vid_out_overlay(file,
 					fh, f);
 			break;
 		case V4L2_BUF_TYPE_VBI_CAPTURE:
+			CLEAR_AFTER_FIELD(f, fmt.vbi);
 			if (ops->vidioc_s_fmt_vbi_cap)
 				ret = ops->vidioc_s_fmt_vbi_cap(file, fh, f);
 			break;
 		case V4L2_BUF_TYPE_VBI_OUTPUT:
+			CLEAR_AFTER_FIELD(f, fmt.vbi);
 			if (ops->vidioc_s_fmt_vbi_out)
 				ret = ops->vidioc_s_fmt_vbi_out(file, fh, f);
 			break;
 		case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
+			CLEAR_AFTER_FIELD(f, fmt.sliced);
 			if (ops->vidioc_s_fmt_sliced_vbi_cap)
 				ret = ops->vidioc_s_fmt_sliced_vbi_cap(file,
 									fh, f);
 			break;
 		case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
+			CLEAR_AFTER_FIELD(f, fmt.sliced);
 			if (ops->vidioc_s_fmt_sliced_vbi_out)
 				ret = ops->vidioc_s_fmt_sliced_vbi_out(file,
 									fh, f);
 			break;
 		case V4L2_BUF_TYPE_PRIVATE:
+			/* CLEAR_AFTER_FIELD(f, fmt.raw_data); <- does nothing */
 			if (ops->vidioc_s_fmt_type_private)
 				ret = ops->vidioc_s_fmt_type_private(file,
 								fh, f);
@@ -836,46 +851,55 @@
 						v4l2_type_names));
 		switch (f->type) {
 		case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+			CLEAR_AFTER_FIELD(f, fmt.pix);
 			if (ops->vidioc_try_fmt_vid_cap)
 				ret = ops->vidioc_try_fmt_vid_cap(file, fh, f);
 			if (!ret)
 				v4l_print_pix_fmt(vfd, &f->fmt.pix);
 			break;
 		case V4L2_BUF_TYPE_VIDEO_OVERLAY:
+			CLEAR_AFTER_FIELD(f, fmt.win);
 			if (ops->vidioc_try_fmt_vid_overlay)
 				ret = ops->vidioc_try_fmt_vid_overlay(file,
 					fh, f);
 			break;
 		case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+			CLEAR_AFTER_FIELD(f, fmt.pix);
 			if (ops->vidioc_try_fmt_vid_out)
 				ret = ops->vidioc_try_fmt_vid_out(file, fh, f);
 			if (!ret)
 				v4l_print_pix_fmt(vfd, &f->fmt.pix);
 			break;
 		case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
+			CLEAR_AFTER_FIELD(f, fmt.win);
 			if (ops->vidioc_try_fmt_vid_out_overlay)
 				ret = ops->vidioc_try_fmt_vid_out_overlay(file,
 				       fh, f);
 			break;
 		case V4L2_BUF_TYPE_VBI_CAPTURE:
+			CLEAR_AFTER_FIELD(f, fmt.vbi);
 			if (ops->vidioc_try_fmt_vbi_cap)
 				ret = ops->vidioc_try_fmt_vbi_cap(file, fh, f);
 			break;
 		case V4L2_BUF_TYPE_VBI_OUTPUT:
+			CLEAR_AFTER_FIELD(f, fmt.vbi);
 			if (ops->vidioc_try_fmt_vbi_out)
 				ret = ops->vidioc_try_fmt_vbi_out(file, fh, f);
 			break;
 		case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
+			CLEAR_AFTER_FIELD(f, fmt.sliced);
 			if (ops->vidioc_try_fmt_sliced_vbi_cap)
 				ret = ops->vidioc_try_fmt_sliced_vbi_cap(file,
 								fh, f);
 			break;
 		case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
+			CLEAR_AFTER_FIELD(f, fmt.sliced);
 			if (ops->vidioc_try_fmt_sliced_vbi_out)
 				ret = ops->vidioc_try_fmt_sliced_vbi_out(file,
 								fh, f);
 			break;
 		case V4L2_BUF_TYPE_PRIVATE:
+			/* CLEAR_AFTER_FIELD(f, fmt.raw_data); <- does nothing */
 			if (ops->vidioc_try_fmt_type_private)
 				ret = ops->vidioc_try_fmt_type_private(file,
 								fh, f);
@@ -898,6 +922,9 @@
 		if (ret)
 			break;

+		if (p->type < V4L2_BUF_TYPE_PRIVATE)
+			CLEAR_AFTER_FIELD(p, memory);
+
 		ret = ops->vidioc_reqbufs(file, fh, p);
 		dbgarg(cmd, "count=%d, type=%s, memory=%s\n",
 				p->count,

