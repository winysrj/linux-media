Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:38605 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbZD3QUB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2009 12:20:01 -0400
Date: Thu, 30 Apr 2009 09:20:00 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] v4l2: fill the reserved fields of VIDIOC_REQBUFS ioctl
In-Reply-To: <Pine.LNX.4.58.0904300803410.7837@shell2.speakeasy.net>
Message-ID: <Pine.LNX.4.58.0904300916250.7837@shell2.speakeasy.net>
References: <49F8A325.7060303@freemail.hu> <Pine.LNX.4.58.0904300803410.7837@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 30 Apr 2009, Trent Piepho wrote:
> On Wed, 29 Apr 2009, [UTF-8] Németh Márton wrote:
> > The parameter of VIDIOC_REQBUFS is a pointer to struct v4l2_requestbuffers.
> > This structure has reserved fields which has to be filled with zeros
> > according to the V4L2 API specification, revision 0.24 [1].
>
> As I read the spec, the reserved fields can be used for input from user
> space if the buffer is of type V4L2_BUF_TYPE_PRIVATE or higher.

Here is a patch that fixes this problem, along with the S_FMT problem you
patched earlier.  TRY_FMT had the same problem as S_FMT, so I fixed that
one as well too.

v4l2-ioctl: Clear buffer type specific trailing fields/padding

From: Trent Piepho <xyzzy@speakeasy.org>

Some ioctls have structs that are a different size depending on what type
of buffer is being used.  If the buffer type leaves a field unused or has
padding space at the end, this space should be zeroed out.

The problems with S_FMT and REQBUFS were original identified and patched by
Márton Németh <nm127@freemail.hu>.

Priority: normal

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>

diff -r 7b786cb576e5 -r 82ef5d6e29e3 linux/drivers/media/video/v4l2-ioctl.c
--- a/linux/drivers/media/video/v4l2-ioctl.c	Thu Apr 30 09:14:13 2009 -0700
+++ b/linux/drivers/media/video/v4l2-ioctl.c	Thu Apr 30 09:15:56 2009 -0700
@@ -42,6 +42,12 @@
 		    if (vfd->debug & V4L2_DEBUG_IOCTL_ARG)		\
 			printk(KERN_DEBUG "%s: " fmt, vfd->name, ## arg);\
 		} while (0)
+
+/* Zero out the end of the struct pointed to by p.  Everthing after, but
+ * not including, the specified field is cleared. */
+#define CLEAR_AFTER_FIELD(p, field) \
+	memset((u8 *)(p) + offsetof(typeof(*(p)), field) + sizeof((p)->field), \
+	0, sizeof(*(p)) - offsetof(typeof(*(p)), field) - sizeof((p)->field))

 struct std_descr {
 	v4l2_std_id std;
@@ -783,44 +789,53 @@ static long __video_do_ioctl(struct file

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
@@ -837,46 +852,55 @@ static long __video_do_ioctl(struct file
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
@@ -898,6 +922,9 @@ static long __video_do_ioctl(struct file
 		ret = check_fmt(ops, p->type);
 		if (ret)
 			break;
+
+		if (p->type < V4L2_BUF_TYPE_PRIVATE)
+			CLEAR_AFTER_FIELD(p, memory);

 		ret = ops->vidioc_reqbufs(file, fh, p);
 		dbgarg(cmd, "count=%d, type=%s, memory=%s\n",
