Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab1GaMnr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jul 2011 08:43:47 -0400
Message-ID: <4E354E00.5060102@redhat.com>
Date: Sun, 31 Jul 2011 09:43:44 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFCv1 PATCH for v3.1] v4l2-ioctl: fix ENOTTY handling.
References: <201107291410.53552.hverkuil@xs4all.nl>
In-Reply-To: <201107291410.53552.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 29-07-2011 09:10, Hans Verkuil escreveu:
> Hi all,
> 
> While converting v4l2-compliance to correctly handle ENOTTY errors I found
> several regressions in v4l2-ioctl.c:
> 
> 1) VIDIOC_ENUM/G/S/TRY_FMT would return -ENOTTY if the op for the particular
>    format type was not set, even though the op for other types might have been
>    present. In such a case -EINVAL should have been returned.
> 2) The priority check could cause -EBUSY or -EINVAL to be returned instead of
>    -ENOTTY if the corresponding ioctl was unsupported.
> 3) Certain ioctls that have an internal implementation (ENUMSTD, G_STD, S_STD,
>    G_PARM and the extended control ioctls) could return -EINVAL when -ENOTTY
>    should have been returned or vice versa.
> 
> I first tried to fix this by adding extra code for each affected ioctl, but
> that made the code rather ugly.
> 
> So I ended up with this code that first checks whether a certain ioctl is
> supported or not and returns -ENOTTY if not.
> 
> Comments?

This patch adds an extra cost of double-parsing the ioctl just because the
errors. The proper way is to check at the error path.

See the enclosed patch.


From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Sun, 31 Jul 2011 09:37:56 -0300
[PATCH] v4l2-ioctl: properly return -EINVAL when parameters are wrong

When an ioctl is implemented, but the parameters are invalid,
the error code should be -EINVAL. However, if the ioctl is
not defined, it should return -ENOTTY instead.

While here, adds a gcc hint that having the ioctl enabled is more
likely, as userspace should know what the driver supports due to QUERYCAP
call.

Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 002ce13..9f80e9d 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -55,6 +55,14 @@
 	memset((u8 *)(p) + offsetof(typeof(*(p)), field) + sizeof((p)->field), \
 	0, sizeof(*(p)) - offsetof(typeof(*(p)), field) - sizeof((p)->field))
 
+#define no_ioctl_err(foo) ( (						\
+	ops->vidioc_##foo##_fmt_vid_cap ||				\
+	ops->vidioc_##foo##_fmt_vid_out ||				\
+	ops->vidioc_##foo##_fmt_vid_cap_mplane ||			\
+	ops->vidioc_##foo##_fmt_vid_out_mplane ||			\
+	ops->vidioc_##foo##_fmt_vid_overlay ||				\
+	ops->vidioc_##foo##_fmt_type_private) ? -EINVAL : -ENOTTY)
+
 struct std_descr {
 	v4l2_std_id std;
 	const char *descr;
@@ -591,7 +599,7 @@ static long __video_do_ioctl(struct file *file,
 			ret = v4l2_prio_check(vfd->prio, vfh->prio);
 			if (ret)
 				goto exit_prio;
-			ret = -EINVAL;
+			ret = -ENOTTY;
 			break;
 		}
 	}
@@ -638,7 +646,7 @@ static long __video_do_ioctl(struct file *file,
 		enum v4l2_priority *p = arg;
 
 		if (!ops->vidioc_s_priority && !use_fh_prio)
-				break;
+			break;
 		dbgarg(cmd, "setting priority to %d\n", *p);
 		if (ops->vidioc_s_priority)
 			ret = ops->vidioc_s_priority(file, fh, *p);
@@ -654,37 +662,37 @@ static long __video_do_ioctl(struct file *file,
 
 		switch (f->type) {
 		case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-			if (ops->vidioc_enum_fmt_vid_cap)
+			if (likely(ops->vidioc_enum_fmt_vid_cap))
 				ret = ops->vidioc_enum_fmt_vid_cap(file, fh, f);
 			break;
 		case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
-			if (ops->vidioc_enum_fmt_vid_cap_mplane)
+			if (likely(ops->vidioc_enum_fmt_vid_cap_mplane))
 				ret = ops->vidioc_enum_fmt_vid_cap_mplane(file,
 									fh, f);
 			break;
 		case V4L2_BUF_TYPE_VIDEO_OVERLAY:
-			if (ops->vidioc_enum_fmt_vid_overlay)
+			if (likely(ops->vidioc_enum_fmt_vid_overlay))
 				ret = ops->vidioc_enum_fmt_vid_overlay(file,
 					fh, f);
 			break;
 		case V4L2_BUF_TYPE_VIDEO_OUTPUT:
-			if (ops->vidioc_enum_fmt_vid_out)
+			if (likely(ops->vidioc_enum_fmt_vid_out))
 				ret = ops->vidioc_enum_fmt_vid_out(file, fh, f);
 			break;
 		case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
-			if (ops->vidioc_enum_fmt_vid_out_mplane)
+			if (likely(ops->vidioc_enum_fmt_vid_out_mplane))
 				ret = ops->vidioc_enum_fmt_vid_out_mplane(file,
 									fh, f);
 			break;
 		case V4L2_BUF_TYPE_PRIVATE:
-			if (ops->vidioc_enum_fmt_type_private)
+			if (likely(ops->vidioc_enum_fmt_type_private))
 				ret = ops->vidioc_enum_fmt_type_private(file,
 								fh, f);
 			break;
 		default:
 			break;
 		}
-		if (!ret)
+		if (likely (!ret))
 			dbgarg(cmd, "index=%d, type=%d, flags=%d, "
 				"pixelformat=%c%c%c%c, description='%s'\n",
 				f->index, f->type, f->flags,
@@ -693,6 +701,8 @@ static long __video_do_ioctl(struct file *file,
 				(f->pixelformat >> 16) & 0xff,
 				(f->pixelformat >> 24) & 0xff,
 				f->description);
+		else if (ret == -ENOTTY)
+			ret = no_ioctl_err(enum);
 		break;
 	}
 	case VIDIOC_G_FMT:
@@ -744,7 +754,7 @@ static long __video_do_ioctl(struct file *file,
 				v4l_print_pix_fmt_mplane(vfd, &f->fmt.pix_mp);
 			break;
 		case V4L2_BUF_TYPE_VIDEO_OVERLAY:
-			if (ops->vidioc_g_fmt_vid_overlay)
+			if (likely(ops->vidioc_g_fmt_vid_overlay))
 				ret = ops->vidioc_g_fmt_vid_overlay(file,
 								    fh, f);
 			break;
@@ -789,34 +799,36 @@ static long __video_do_ioctl(struct file *file,
 				v4l_print_pix_fmt_mplane(vfd, &f->fmt.pix_mp);
 			break;
 		case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
-			if (ops->vidioc_g_fmt_vid_out_overlay)
+			if (likely(ops->vidioc_g_fmt_vid_out_overlay))
 				ret = ops->vidioc_g_fmt_vid_out_overlay(file,
 				       fh, f);
 			break;
 		case V4L2_BUF_TYPE_VBI_CAPTURE:
-			if (ops->vidioc_g_fmt_vbi_cap)
+			if (likely(ops->vidioc_g_fmt_vbi_cap))
 				ret = ops->vidioc_g_fmt_vbi_cap(file, fh, f);
 			break;
 		case V4L2_BUF_TYPE_VBI_OUTPUT:
-			if (ops->vidioc_g_fmt_vbi_out)
+			if (likely(ops->vidioc_g_fmt_vbi_out))
 				ret = ops->vidioc_g_fmt_vbi_out(file, fh, f);
 			break;
 		case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
-			if (ops->vidioc_g_fmt_sliced_vbi_cap)
+			if (likely(ops->vidioc_g_fmt_sliced_vbi_cap))
 				ret = ops->vidioc_g_fmt_sliced_vbi_cap(file,
 									fh, f);
 			break;
 		case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
-			if (ops->vidioc_g_fmt_sliced_vbi_out)
+			if (likely(ops->vidioc_g_fmt_sliced_vbi_out))
 				ret = ops->vidioc_g_fmt_sliced_vbi_out(file,
 									fh, f);
 			break;
 		case V4L2_BUF_TYPE_PRIVATE:
-			if (ops->vidioc_g_fmt_type_private)
+			if (likely(ops->vidioc_g_fmt_type_private))
 				ret = ops->vidioc_g_fmt_type_private(file,
 								fh, f);
 			break;
 		}
+		if (unlikely(ret == -ENOTTY))
+			ret = no_ioctl_err(g);
 
 		break;
 	}
@@ -926,33 +938,36 @@ static long __video_do_ioctl(struct file *file,
 			break;
 		case V4L2_BUF_TYPE_VBI_CAPTURE:
 			CLEAR_AFTER_FIELD(f, fmt.vbi);
-			if (ops->vidioc_s_fmt_vbi_cap)
+			if (likely(ops->vidioc_s_fmt_vbi_cap))
 				ret = ops->vidioc_s_fmt_vbi_cap(file, fh, f);
 			break;
 		case V4L2_BUF_TYPE_VBI_OUTPUT:
 			CLEAR_AFTER_FIELD(f, fmt.vbi);
-			if (ops->vidioc_s_fmt_vbi_out)
+			if (likely(ops->vidioc_s_fmt_vbi_out))
 				ret = ops->vidioc_s_fmt_vbi_out(file, fh, f);
 			break;
 		case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
 			CLEAR_AFTER_FIELD(f, fmt.sliced);
-			if (ops->vidioc_s_fmt_sliced_vbi_cap)
+			if (likely(ops->vidioc_s_fmt_sliced_vbi_cap))
 				ret = ops->vidioc_s_fmt_sliced_vbi_cap(file,
 									fh, f);
 			break;
 		case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
 			CLEAR_AFTER_FIELD(f, fmt.sliced);
-			if (ops->vidioc_s_fmt_sliced_vbi_out)
+			if (likely(ops->vidioc_s_fmt_sliced_vbi_out))
 				ret = ops->vidioc_s_fmt_sliced_vbi_out(file,
 									fh, f);
+
 			break;
 		case V4L2_BUF_TYPE_PRIVATE:
 			/* CLEAR_AFTER_FIELD(f, fmt.raw_data); <- does nothing */
-			if (ops->vidioc_s_fmt_type_private)
+			if (likely(ops->vidioc_s_fmt_type_private))
 				ret = ops->vidioc_s_fmt_type_private(file,
 								fh, f);
 			break;
 		}
+		if (unlikely(ret == -ENOTTY))
+			ret = no_ioctl_err(g);
 		break;
 	}
 	case VIDIOC_TRY_FMT:
@@ -1008,7 +1023,7 @@ static long __video_do_ioctl(struct file *file,
 			break;
 		case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 			CLEAR_AFTER_FIELD(f, fmt.win);
-			if (ops->vidioc_try_fmt_vid_overlay)
+			if (likely(ops->vidioc_try_fmt_vid_overlay))
 				ret = ops->vidioc_try_fmt_vid_overlay(file,
 					fh, f);
 			break;
@@ -1057,40 +1072,43 @@ static long __video_do_ioctl(struct file *file,
 			break;
 		case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
 			CLEAR_AFTER_FIELD(f, fmt.win);
-			if (ops->vidioc_try_fmt_vid_out_overlay)
+			if (likely(ops->vidioc_try_fmt_vid_out_overlay))
 				ret = ops->vidioc_try_fmt_vid_out_overlay(file,
 				       fh, f);
 			break;
 		case V4L2_BUF_TYPE_VBI_CAPTURE:
 			CLEAR_AFTER_FIELD(f, fmt.vbi);
-			if (ops->vidioc_try_fmt_vbi_cap)
+			if (likely(ops->vidioc_try_fmt_vbi_cap))
 				ret = ops->vidioc_try_fmt_vbi_cap(file, fh, f);
 			break;
 		case V4L2_BUF_TYPE_VBI_OUTPUT:
 			CLEAR_AFTER_FIELD(f, fmt.vbi);
-			if (ops->vidioc_try_fmt_vbi_out)
+			if (likely(ops->vidioc_try_fmt_vbi_out))
 				ret = ops->vidioc_try_fmt_vbi_out(file, fh, f);
 			break;
 		case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
 			CLEAR_AFTER_FIELD(f, fmt.sliced);
-			if (ops->vidioc_try_fmt_sliced_vbi_cap)
+			if (likely(ops->vidioc_try_fmt_sliced_vbi_cap))
 				ret = ops->vidioc_try_fmt_sliced_vbi_cap(file,
 								fh, f);
 			break;
 		case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
 			CLEAR_AFTER_FIELD(f, fmt.sliced);
-			if (ops->vidioc_try_fmt_sliced_vbi_out)
+			if (likely(ops->vidioc_try_fmt_sliced_vbi_out))
 				ret = ops->vidioc_try_fmt_sliced_vbi_out(file,
 								fh, f);
+			else
+				ret = no_ioctl_err(try);
 			break;
 		case V4L2_BUF_TYPE_PRIVATE:
 			/* CLEAR_AFTER_FIELD(f, fmt.raw_data); <- does nothing */
-			if (ops->vidioc_try_fmt_type_private)
+			if (likely(ops->vidioc_try_fmt_type_private))
 				ret = ops->vidioc_try_fmt_type_private(file,
 								fh, f);
 			break;
 		}
-
+		if (unlikely(ret == -ENOTTY))
+			ret = no_ioctl_err(g);
 		break;
 	}
 	/* FIXME: Those buf reqs could be handled here,
@@ -1262,16 +1280,15 @@ static long __video_do_ioctl(struct file *file,
 	{
 		v4l2_std_id *id = arg;
 
-		ret = 0;
 		/* Calls the specific handler */
 		if (ops->vidioc_g_std)
 			ret = ops->vidioc_g_std(file, fh, id);
-		else if (vfd->current_norm)
+		else if (vfd->current_norm) {
+			ret = 0;
 			*id = vfd->current_norm;
-		else
-			ret = -EINVAL;
+		}
 
-		if (!ret)
+		if (likely(!ret))
 			dbgarg(cmd, "std=0x%08Lx\n", (long long unsigned)*id);
 		break;
 	}
@@ -1288,8 +1305,6 @@ static long __video_do_ioctl(struct file *file,
 		/* Calls the specific handler */
 		if (ops->vidioc_s_std)
 			ret = ops->vidioc_s_std(file, fh, &norm);
-		else
-			ret = -EINVAL;
 
 		/* Updates standard information */
 		if (ret >= 0)
@@ -1812,7 +1827,7 @@ static long __video_do_ioctl(struct file *file,
 			if (ops->vidioc_g_std)
 				ret = ops->vidioc_g_std(file, fh, &std);
 			else if (std == 0)
-				ret = -EINVAL;
+				ret = -ENOTTY;
 			if (ret == 0)
 				v4l2_video_std_frame_period(std,
 						    &p->parm.capture.timeperframe);
