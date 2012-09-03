Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1603 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab2ICNsy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2012 09:48:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 06/10] v4l2-core: deprecate V4L2_BUF_TYPE_PRIVATE
Date: Mon,  3 Sep 2012 15:48:40 +0200
Message-Id: <0051dd586003ba3879e9e6667b597e9c83204cdf.1346679785.git.hans.verkuil@cisco.com>
In-Reply-To: <1346680124-15169-1-git-send-email-hverkuil@xs4all.nl>
References: <1346680124-15169-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <c31da93f2bf615b90086d749e3f3eae6d6c3fc41.1346679785.git.hans.verkuil@cisco.com>
References: <c31da93f2bf615b90086d749e3f3eae6d6c3fc41.1346679785.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This buffer type isn't used at all, and since it is effectively undefined
what it should do it is deprecated. The define still exists, but any
internal support for such buffers is removed.

The decisions to deprecate this was taken during the 2012 Media Workshop.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |    8 --------
 drivers/media/v4l2-core/v4l2-dev.c            |   12 ++++--------
 drivers/media/v4l2-core/v4l2-ioctl.c          |   26 +------------------------
 include/linux/videodev2.h                     |    1 +
 include/media/v4l2-ioctl.h                    |    8 --------
 5 files changed, 6 insertions(+), 49 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 9ebd5c5..5d97fd1 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -194,10 +194,6 @@ static int __get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
 	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
 	case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
 		return get_v4l2_sliced_vbi_format(&kp->fmt.sliced, &up->fmt.sliced);
-	case V4L2_BUF_TYPE_PRIVATE:
-		if (copy_from_user(kp, up, sizeof(kp->fmt.raw_data)))
-			return -EFAULT;
-		return 0;
 	default:
 		printk(KERN_INFO "compat_ioctl32: unexpected VIDIOC_FMT type %d\n",
 								kp->type);
@@ -240,10 +236,6 @@ static int __put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
 	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
 	case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
 		return put_v4l2_sliced_vbi_format(&kp->fmt.sliced, &up->fmt.sliced);
-	case V4L2_BUF_TYPE_PRIVATE:
-		if (copy_to_user(up, kp, sizeof(up->fmt.raw_data)))
-			return -EFAULT;
-		return 0;
 	default:
 		printk(KERN_INFO "compat_ioctl32: unexpected VIDIOC_FMT type %d\n",
 								kp->type);
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 71237f5..95f92ea 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -565,8 +565,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	    ops->vidioc_enum_fmt_vid_out ||
 	    ops->vidioc_enum_fmt_vid_cap_mplane ||
 	    ops->vidioc_enum_fmt_vid_out_mplane ||
-	    ops->vidioc_enum_fmt_vid_overlay ||
-	    ops->vidioc_enum_fmt_type_private)
+	    ops->vidioc_enum_fmt_vid_overlay)
 		set_bit(_IOC_NR(VIDIOC_ENUM_FMT), valid_ioctls);
 	if (ops->vidioc_g_fmt_vid_cap ||
 	    ops->vidioc_g_fmt_vid_out ||
@@ -577,8 +576,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	    ops->vidioc_g_fmt_vid_out_overlay ||
 	    ops->vidioc_g_fmt_vbi_out ||
 	    ops->vidioc_g_fmt_sliced_vbi_cap ||
-	    ops->vidioc_g_fmt_sliced_vbi_out ||
-	    ops->vidioc_g_fmt_type_private)
+	    ops->vidioc_g_fmt_sliced_vbi_out)
 		set_bit(_IOC_NR(VIDIOC_G_FMT), valid_ioctls);
 	if (ops->vidioc_s_fmt_vid_cap ||
 	    ops->vidioc_s_fmt_vid_out ||
@@ -589,8 +587,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	    ops->vidioc_s_fmt_vid_out_overlay ||
 	    ops->vidioc_s_fmt_vbi_out ||
 	    ops->vidioc_s_fmt_sliced_vbi_cap ||
-	    ops->vidioc_s_fmt_sliced_vbi_out ||
-	    ops->vidioc_s_fmt_type_private)
+	    ops->vidioc_s_fmt_sliced_vbi_out)
 		set_bit(_IOC_NR(VIDIOC_S_FMT), valid_ioctls);
 	if (ops->vidioc_try_fmt_vid_cap ||
 	    ops->vidioc_try_fmt_vid_out ||
@@ -601,8 +598,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	    ops->vidioc_try_fmt_vid_out_overlay ||
 	    ops->vidioc_try_fmt_vbi_out ||
 	    ops->vidioc_try_fmt_sliced_vbi_cap ||
-	    ops->vidioc_try_fmt_sliced_vbi_out ||
-	    ops->vidioc_try_fmt_type_private)
+	    ops->vidioc_try_fmt_sliced_vbi_out)
 		set_bit(_IOC_NR(VIDIOC_TRY_FMT), valid_ioctls);
 	SET_VALID_IOCTL(ops, VIDIOC_REQBUFS, vidioc_reqbufs);
 	SET_VALID_IOCTL(ops, VIDIOC_QUERYBUF, vidioc_querybuf);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 6bc47fc..473ebea 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -316,9 +316,6 @@ static void v4l_print_format(const void *arg, bool write_only)
 				sliced->service_lines[0][i],
 				sliced->service_lines[1][i]);
 		break;
-	case V4L2_BUF_TYPE_PRIVATE:
-		pr_cont("\n");
-		break;
 	}
 }
 
@@ -927,10 +924,6 @@ static int check_fmt(const struct v4l2_ioctl_ops *ops, enum v4l2_buf_type type)
 		if (ops->vidioc_g_fmt_sliced_vbi_out)
 			return 0;
 		break;
-	case V4L2_BUF_TYPE_PRIVATE:
-		if (ops->vidioc_g_fmt_type_private)
-			return 0;
-		break;
 	}
 	return -EINVAL;
 }
@@ -1051,10 +1044,6 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!ops->vidioc_enum_fmt_vid_out_mplane))
 			break;
 		return ops->vidioc_enum_fmt_vid_out_mplane(file, fh, arg);
-	case V4L2_BUF_TYPE_PRIVATE:
-		if (unlikely(!ops->vidioc_enum_fmt_type_private))
-			break;
-		return ops->vidioc_enum_fmt_type_private(file, fh, arg);
 	}
 	return -EINVAL;
 }
@@ -1105,10 +1094,6 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!ops->vidioc_g_fmt_sliced_vbi_out))
 			break;
 		return ops->vidioc_g_fmt_sliced_vbi_out(file, fh, arg);
-	case V4L2_BUF_TYPE_PRIVATE:
-		if (unlikely(!ops->vidioc_g_fmt_type_private))
-			break;
-		return ops->vidioc_g_fmt_type_private(file, fh, arg);
 	}
 	return -EINVAL;
 }
@@ -1169,10 +1154,6 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.sliced);
 		return ops->vidioc_s_fmt_sliced_vbi_out(file, fh, arg);
-	case V4L2_BUF_TYPE_PRIVATE:
-		if (unlikely(!ops->vidioc_s_fmt_type_private))
-			break;
-		return ops->vidioc_s_fmt_type_private(file, fh, arg);
 	}
 	return -EINVAL;
 }
@@ -1233,10 +1214,6 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.sliced);
 		return ops->vidioc_try_fmt_sliced_vbi_out(file, fh, arg);
-	case V4L2_BUF_TYPE_PRIVATE:
-		if (unlikely(!ops->vidioc_try_fmt_type_private))
-			break;
-		return ops->vidioc_try_fmt_type_private(file, fh, arg);
 	}
 	return -EINVAL;
 }
@@ -1425,8 +1402,7 @@ static int v4l_reqbufs(const struct v4l2_ioctl_ops *ops,
 	if (ret)
 		return ret;
 
-	if (p->type < V4L2_BUF_TYPE_PRIVATE)
-		CLEAR_AFTER_FIELD(p, memory);
+	CLEAR_AFTER_FIELD(p, memory);
 
 	return ops->vidioc_reqbufs(file, fh, p);
 }
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index c72b9f3..b06342b 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -162,6 +162,7 @@ enum v4l2_buf_type {
 #endif
 	V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE = 9,
 	V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE  = 10,
+	/* Deprecated, do not use */
 	V4L2_BUF_TYPE_PRIVATE              = 0x80,
 };
 
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index e614c9c..0bc1444 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -40,8 +40,6 @@ struct v4l2_ioctl_ops {
 					      struct v4l2_fmtdesc *f);
 	int (*vidioc_enum_fmt_vid_out_mplane)(struct file *file, void *fh,
 					      struct v4l2_fmtdesc *f);
-	int (*vidioc_enum_fmt_type_private)(struct file *file, void *fh,
-					    struct v4l2_fmtdesc *f);
 
 	/* VIDIOC_G_FMT handlers */
 	int (*vidioc_g_fmt_vid_cap)    (struct file *file, void *fh,
@@ -64,8 +62,6 @@ struct v4l2_ioctl_ops {
 					   struct v4l2_format *f);
 	int (*vidioc_g_fmt_vid_out_mplane)(struct file *file, void *fh,
 					   struct v4l2_format *f);
-	int (*vidioc_g_fmt_type_private)(struct file *file, void *fh,
-					struct v4l2_format *f);
 
 	/* VIDIOC_S_FMT handlers */
 	int (*vidioc_s_fmt_vid_cap)    (struct file *file, void *fh,
@@ -88,8 +84,6 @@ struct v4l2_ioctl_ops {
 					   struct v4l2_format *f);
 	int (*vidioc_s_fmt_vid_out_mplane)(struct file *file, void *fh,
 					   struct v4l2_format *f);
-	int (*vidioc_s_fmt_type_private)(struct file *file, void *fh,
-					struct v4l2_format *f);
 
 	/* VIDIOC_TRY_FMT handlers */
 	int (*vidioc_try_fmt_vid_cap)    (struct file *file, void *fh,
@@ -112,8 +106,6 @@ struct v4l2_ioctl_ops {
 					     struct v4l2_format *f);
 	int (*vidioc_try_fmt_vid_out_mplane)(struct file *file, void *fh,
 					     struct v4l2_format *f);
-	int (*vidioc_try_fmt_type_private)(struct file *file, void *fh,
-					  struct v4l2_format *f);
 
 	/* Buffer handlers */
 	int (*vidioc_reqbufs) (struct file *file, void *fh, struct v4l2_requestbuffers *b);
-- 
1.7.10.4

