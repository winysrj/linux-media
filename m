Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:24386 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab2INK54 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 06:57:56 -0400
Received: from cobaltpc1.cisco.com (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id q8EAvqBc013688
	for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 10:57:54 GMT
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv3 API PATCH 07/31] v4l2-core: deprecate V4L2_BUF_TYPE_PRIVATE
Date: Fri, 14 Sep 2012 12:57:22 +0200
Message-Id: <2e2343f7b58a5cd273657d257e99aa05cc3d5ac7.1347619766.git.hans.verkuil@cisco.com>
In-Reply-To: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
References: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
index e843705..83ffb64 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -195,10 +195,6 @@ static int __get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
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
@@ -241,10 +237,6 @@ static int __put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
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
index 932d9bf..449ca9c 100644
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
index 2b99f55..b66057b 100644
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

