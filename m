Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:58385 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbZDYILr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Apr 2009 04:11:47 -0400
Message-ID: <49F2C59A.9010703@freemail.hu>
Date: Sat, 25 Apr 2009 10:11:06 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] v4l2: fill the unused fields with zeros in case of VIDIOC_S_FMT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VIDIOC_S_FMT is a write-read ioctl: it sets the format and returns
the current format in case of success. The parameter of VIDIOC_S_FMT
ioctl is a pointer to struct v4l2_format. [1] This structure contains some
fields which are not used depending on the .type value. These unused
fields are filled with zeros with this patch.

The patch was tested with v4l-test 0.12 [2] with vivi and with
gspca_sunplus driver together with Trust 610 LCD POWERC@M ZOOM.

References:
[1] V4L2 API specification, revision 0.24
    http://v4l2spec.bytesex.org/spec/r10944.htm

[2] v4l-test: Test environment for Video For Linux Two API
    http://v4l-test.sourceforge.net/

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux-2.6.30-rc3/drivers/media/video/v4l2-ioctl.c.orig	2009-04-22 05:07:00.000000000 +0200
+++ linux-2.6.30-rc3/drivers/media/video/v4l2-ioctl.c	2009-04-25 09:05:42.000000000 +0200
@@ -777,44 +777,61 @@
 	{
 		struct v4l2_format *f = (struct v4l2_format *)arg;

+#define CLEAR_UNUSED_FIELDS(data, last_member) \
+	memset(((u8 *)f)+ \
+		offsetof(struct v4l2_format, fmt)+ \
+		sizeof(struct v4l2_ ## last_member), \
+		0, \
+		sizeof(*f)- \
+		offsetof(struct v4l2_format, fmt)+ \
+		sizeof(struct v4l2_ ## last_member))
+
 		/* FIXME: Should be one dump per type */
 		dbgarg(cmd, "type=%s\n", prt_names(f->type, v4l2_type_names));

 		switch (f->type) {
 		case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+			CLEAR_UNUSED_FIELDS(f, pix_format);
 			v4l_print_pix_fmt(vfd, &f->fmt.pix);
 			if (ops->vidioc_s_fmt_vid_cap)
 				ret = ops->vidioc_s_fmt_vid_cap(file, fh, f);
 			break;
 		case V4L2_BUF_TYPE_VIDEO_OVERLAY:
+			CLEAR_UNUSED_FIELDS(f, window);
 			if (ops->vidioc_s_fmt_vid_overlay)
 				ret = ops->vidioc_s_fmt_vid_overlay(file,
 								    fh, f);
 			break;
 		case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+			CLEAR_UNUSED_FIELDS(f, pix_format);
 			v4l_print_pix_fmt(vfd, &f->fmt.pix);
 			if (ops->vidioc_s_fmt_vid_out)
 				ret = ops->vidioc_s_fmt_vid_out(file, fh, f);
 			break;
 		case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
+			CLEAR_UNUSED_FIELDS(f, window);
 			if (ops->vidioc_s_fmt_vid_out_overlay)
 				ret = ops->vidioc_s_fmt_vid_out_overlay(file,
 					fh, f);
 			break;
 		case V4L2_BUF_TYPE_VBI_CAPTURE:
+			CLEAR_UNUSED_FIELDS(f, vbi_format);
 			if (ops->vidioc_s_fmt_vbi_cap)
 				ret = ops->vidioc_s_fmt_vbi_cap(file, fh, f);
 			break;
 		case V4L2_BUF_TYPE_VBI_OUTPUT:
+			CLEAR_UNUSED_FIELDS(f, vbi_format);
 			if (ops->vidioc_s_fmt_vbi_out)
 				ret = ops->vidioc_s_fmt_vbi_out(file, fh, f);
 			break;
 		case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
+			CLEAR_UNUSED_FIELDS(f, sliced_vbi_format);
 			if (ops->vidioc_s_fmt_sliced_vbi_cap)
 				ret = ops->vidioc_s_fmt_sliced_vbi_cap(file,
 									fh, f);
 			break;
 		case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
+			CLEAR_UNUSED_FIELDS(f, sliced_vbi_format);
 			if (ops->vidioc_s_fmt_sliced_vbi_out)
 				ret = ops->vidioc_s_fmt_sliced_vbi_out(file,
 									fh, f);
