Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:46856 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751001AbbIQJqu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2015 05:46:50 -0400
Message-ID: <55FA8BDC.6020305@xs4all.nl>
Date: Thu, 17 Sep 2015 11:46:04 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] v4l2-compat-ioctl32: add missing SDR support
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the missing support for v4l2_sdr_format (V4L2_BUF_TYPE_SDR_CAPTURE).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index af63543..0f1d632 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -147,6 +147,20 @@ static inline int put_v4l2_sliced_vbi_format(struct v4l2_sliced_vbi_format *kp,
 	return 0;
 }

+static inline int get_v4l2_sdr_format(struct v4l2_sdr_format *kp, struct v4l2_sdr_format __user *up)
+{
+	if (copy_from_user(kp, up, sizeof(struct v4l2_sdr_format)))
+		return -EFAULT;
+	return 0;
+}
+
+static inline int put_v4l2_sdr_format(struct v4l2_sdr_format *kp, struct v4l2_sdr_format __user *up)
+{
+	if (copy_to_user(up, kp, sizeof(struct v4l2_sdr_format)))
+		return -EFAULT;
+	return 0;
+}
+
 struct v4l2_format32 {
 	__u32	type;	/* enum v4l2_buf_type */
 	union {
@@ -155,6 +169,7 @@ struct v4l2_format32 {
 		struct v4l2_window32	win;
 		struct v4l2_vbi_format	vbi;
 		struct v4l2_sliced_vbi_format	sliced;
+		struct v4l2_sdr_format	sdr;
 		__u8	raw_data[200];        /* user-defined */
 	} fmt;
 };
@@ -198,8 +213,10 @@ static int __get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
 	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
 	case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
 		return get_v4l2_sliced_vbi_format(&kp->fmt.sliced, &up->fmt.sliced);
+	case V4L2_BUF_TYPE_SDR_CAPTURE:
+		return get_v4l2_sdr_format(&kp->fmt.sdr, &up->fmt.sdr);
 	default:
-		printk(KERN_INFO "compat_ioctl32: unexpected VIDIOC_FMT type %d\n",
+		pr_info("compat_ioctl32: unexpected VIDIOC_FMT type %d\n",
 								kp->type);
 		return -EINVAL;
 	}
@@ -242,8 +259,10 @@ static int __put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
 	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
 	case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
 		return put_v4l2_sliced_vbi_format(&kp->fmt.sliced, &up->fmt.sliced);
+	case V4L2_BUF_TYPE_SDR_CAPTURE:
+		return put_v4l2_sdr_format(&kp->fmt.sdr, &up->fmt.sdr);
 	default:
-		printk(KERN_INFO "compat_ioctl32: unexpected VIDIOC_FMT type %d\n",
+		pr_info("compat_ioctl32: unexpected VIDIOC_FMT type %d\n",
 								kp->type);
 		return -EINVAL;
 	}
