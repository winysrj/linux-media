Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,T_MIXED_ES,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B623C65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:51:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D6F720645
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:51:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D6F720645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbeLMJvQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 04:51:16 -0500
Received: from mga07.intel.com ([134.134.136.100]:51733 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727969AbeLMJvQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 04:51:16 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2018 01:51:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,348,1539673200"; 
   d="scan'208";a="303483695"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga005.fm.intel.com with ESMTP; 13 Dec 2018 01:51:11 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 262B5204CC;
        Thu, 13 Dec 2018 11:51:11 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gXNe8-0003tI-NM; Thu, 13 Dec 2018 11:51:08 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     yong.zhi@intel.com, laurent.pinchart@ideasonboard.com,
        rajmohan.mani@intel.com
Subject: [PATCH v9 01/22] v4l: Add support for V4L2_BUF_TYPE_META_OUTPUT
Date:   Thu, 13 Dec 2018 11:50:46 +0200
Message-Id: <20181213095107.14894-2-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181213095107.14894-1-sakari.ailus@linux.intel.com>
References: <20181213095107.14894-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The V4L2_BUF_TYPE_META_OUTPUT mirrors the V4L2_BUF_TYPE_META_CAPTURE with
the exception that it is an OUTPUT type. The use case for this is to pass
buffers to the device that are not image data but metadata. The formats,
just as the metadata capture formats, are typically device specific and
highly structured.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
Tested-by: Tian Shu Qiu <tian.shu.qiu@intel.com>
---
 drivers/media/common/videobuf2/videobuf2-v4l2.c |  1 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c   |  2 ++
 drivers/media/v4l2-core/v4l2-dev.c              | 12 ++++++++----
 drivers/media/v4l2-core/v4l2-ioctl.c            | 23 +++++++++++++++++++++++
 include/media/v4l2-ioctl.h                      | 17 +++++++++++++++++
 include/uapi/linux/videodev2.h                  |  2 ++
 6 files changed, 53 insertions(+), 4 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 1244c246d0c40..8e7ab0283f06b 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -704,6 +704,7 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 		requested_sizes[0] = f->fmt.sdr.buffersize;
 		break;
 	case V4L2_BUF_TYPE_META_CAPTURE:
+	case V4L2_BUF_TYPE_META_OUTPUT:
 		requested_sizes[0] = f->fmt.meta.buffersize;
 		break;
 	default:
diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index f4325329fbd6f..fe4577a46869d 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -323,6 +323,7 @@ static int __get_v4l2_format32(struct v4l2_format __user *p64,
 		return copy_in_user(&p64->fmt.sdr, &p32->fmt.sdr,
 				    sizeof(p64->fmt.sdr)) ? -EFAULT : 0;
 	case V4L2_BUF_TYPE_META_CAPTURE:
+	case V4L2_BUF_TYPE_META_OUTPUT:
 		return copy_in_user(&p64->fmt.meta, &p32->fmt.meta,
 				    sizeof(p64->fmt.meta)) ? -EFAULT : 0;
 	default:
@@ -392,6 +393,7 @@ static int __put_v4l2_format32(struct v4l2_format __user *p64,
 		return copy_in_user(&p32->fmt.sdr, &p64->fmt.sdr,
 				    sizeof(p64->fmt.sdr)) ? -EFAULT : 0;
 	case V4L2_BUF_TYPE_META_CAPTURE:
+	case V4L2_BUF_TYPE_META_OUTPUT:
 		return copy_in_user(&p32->fmt.meta, &p64->fmt.meta,
 				    sizeof(p64->fmt.meta)) ? -EFAULT : 0;
 	default:
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 2130e3a0f4dac..d7528f82a66aa 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -597,7 +597,8 @@ static void determine_valid_ioctls(struct video_device *vdev)
 			       ops->vidioc_enum_fmt_vid_overlay ||
 			       ops->vidioc_enum_fmt_meta_cap)) ||
 		    (is_tx && (ops->vidioc_enum_fmt_vid_out ||
-			       ops->vidioc_enum_fmt_vid_out_mplane)))
+			       ops->vidioc_enum_fmt_vid_out_mplane ||
+			       ops->vidioc_enum_fmt_meta_out)))
 			set_bit(_IOC_NR(VIDIOC_ENUM_FMT), valid_ioctls);
 		if ((is_rx && (ops->vidioc_g_fmt_vid_cap ||
 			       ops->vidioc_g_fmt_vid_cap_mplane ||
@@ -605,7 +606,8 @@ static void determine_valid_ioctls(struct video_device *vdev)
 			       ops->vidioc_g_fmt_meta_cap)) ||
 		    (is_tx && (ops->vidioc_g_fmt_vid_out ||
 			       ops->vidioc_g_fmt_vid_out_mplane ||
-			       ops->vidioc_g_fmt_vid_out_overlay)))
+			       ops->vidioc_g_fmt_vid_out_overlay ||
+			       ops->vidioc_g_fmt_meta_out)))
 			 set_bit(_IOC_NR(VIDIOC_G_FMT), valid_ioctls);
 		if ((is_rx && (ops->vidioc_s_fmt_vid_cap ||
 			       ops->vidioc_s_fmt_vid_cap_mplane ||
@@ -613,7 +615,8 @@ static void determine_valid_ioctls(struct video_device *vdev)
 			       ops->vidioc_s_fmt_meta_cap)) ||
 		    (is_tx && (ops->vidioc_s_fmt_vid_out ||
 			       ops->vidioc_s_fmt_vid_out_mplane ||
-			       ops->vidioc_s_fmt_vid_out_overlay)))
+			       ops->vidioc_s_fmt_vid_out_overlay ||
+			       ops->vidioc_s_fmt_meta_out)))
 			 set_bit(_IOC_NR(VIDIOC_S_FMT), valid_ioctls);
 		if ((is_rx && (ops->vidioc_try_fmt_vid_cap ||
 			       ops->vidioc_try_fmt_vid_cap_mplane ||
@@ -621,7 +624,8 @@ static void determine_valid_ioctls(struct video_device *vdev)
 			       ops->vidioc_try_fmt_meta_cap)) ||
 		    (is_tx && (ops->vidioc_try_fmt_vid_out ||
 			       ops->vidioc_try_fmt_vid_out_mplane ||
-			       ops->vidioc_try_fmt_vid_out_overlay)))
+			       ops->vidioc_try_fmt_vid_out_overlay ||
+			       ops->vidioc_try_fmt_meta_out)))
 			 set_bit(_IOC_NR(VIDIOC_TRY_FMT), valid_ioctls);
 		SET_VALID_IOCTL(ops, VIDIOC_OVERLAY, vidioc_overlay);
 		SET_VALID_IOCTL(ops, VIDIOC_G_FBUF, vidioc_g_fbuf);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index ef58bc31bfde8..1441a73ce64cf 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -194,6 +194,7 @@ const char *v4l2_type_names[] = {
 	[V4L2_BUF_TYPE_SDR_CAPTURE]        = "sdr-cap",
 	[V4L2_BUF_TYPE_SDR_OUTPUT]         = "sdr-out",
 	[V4L2_BUF_TYPE_META_CAPTURE]       = "meta-cap",
+	[V4L2_BUF_TYPE_META_OUTPUT]	   = "meta-out",
 };
 EXPORT_SYMBOL(v4l2_type_names);
 
@@ -366,6 +367,7 @@ static void v4l_print_format(const void *arg, bool write_only)
 			(sdr->pixelformat >> 24) & 0xff);
 		break;
 	case V4L2_BUF_TYPE_META_CAPTURE:
+	case V4L2_BUF_TYPE_META_OUTPUT:
 		meta = &p->fmt.meta;
 		pr_cont(", dataformat=%c%c%c%c, buffersize=%u\n",
 			(meta->dataformat >>  0) & 0xff,
@@ -999,6 +1001,10 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
 		if (is_vid && is_rx && ops->vidioc_g_fmt_meta_cap)
 			return 0;
 		break;
+	case V4L2_BUF_TYPE_META_OUTPUT:
+		if (is_vid && is_tx && ops->vidioc_g_fmt_meta_out)
+			return 0;
+		break;
 	default:
 		break;
 	}
@@ -1410,6 +1416,11 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
 			break;
 		ret = ops->vidioc_enum_fmt_meta_cap(file, fh, arg);
 		break;
+	case V4L2_BUF_TYPE_META_OUTPUT:
+		if (unlikely(!ops->vidioc_enum_fmt_meta_out))
+			break;
+		ret = ops->vidioc_enum_fmt_meta_out(file, fh, arg);
+		break;
 	}
 	if (ret == 0)
 		v4l_fill_fmtdesc(p);
@@ -1488,6 +1499,8 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 		return ops->vidioc_g_fmt_sdr_out(file, fh, arg);
 	case V4L2_BUF_TYPE_META_CAPTURE:
 		return ops->vidioc_g_fmt_meta_cap(file, fh, arg);
+	case V4L2_BUF_TYPE_META_OUTPUT:
+		return ops->vidioc_g_fmt_meta_out(file, fh, arg);
 	}
 	return -EINVAL;
 }
@@ -1601,6 +1614,11 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.meta);
 		return ops->vidioc_s_fmt_meta_cap(file, fh, arg);
+	case V4L2_BUF_TYPE_META_OUTPUT:
+		if (unlikely(!ops->vidioc_s_fmt_meta_out))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.meta);
+		return ops->vidioc_s_fmt_meta_out(file, fh, arg);
 	}
 	return -EINVAL;
 }
@@ -1693,6 +1711,11 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.meta);
 		return ops->vidioc_try_fmt_meta_cap(file, fh, arg);
+	case V4L2_BUF_TYPE_META_OUTPUT:
+		if (unlikely(!ops->vidioc_try_fmt_meta_out))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.meta);
+		return ops->vidioc_try_fmt_meta_out(file, fh, arg);
 	}
 	return -EINVAL;
 }
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index aa4511aa5ffcf..8533ece5026e4 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -48,6 +48,9 @@ struct v4l2_fh;
  * @vidioc_enum_fmt_meta_cap: pointer to the function that implements
  *	:ref:`VIDIOC_ENUM_FMT <vidioc_enum_fmt>` ioctl logic
  *	for metadata capture
+ * @vidioc_enum_fmt_meta_out: pointer to the function that implements
+ *	:ref:`VIDIOC_ENUM_FMT <vidioc_enum_fmt>` ioctl logic
+ *	for metadata output
  * @vidioc_g_fmt_vid_cap: pointer to the function that implements
  *	:ref:`VIDIOC_G_FMT <vidioc_g_fmt>` ioctl logic for video capture
  *	in single plane mode
@@ -80,6 +83,8 @@ struct v4l2_fh;
  *	Radio output
  * @vidioc_g_fmt_meta_cap: pointer to the function that implements
  *	:ref:`VIDIOC_G_FMT <vidioc_g_fmt>` ioctl logic for metadata capture
+ * @vidioc_g_fmt_meta_out: pointer to the function that implements
+ *	:ref:`VIDIOC_G_FMT <vidioc_g_fmt>` ioctl logic for metadata output
  * @vidioc_s_fmt_vid_cap: pointer to the function that implements
  *	:ref:`VIDIOC_S_FMT <vidioc_g_fmt>` ioctl logic for video capture
  *	in single plane mode
@@ -112,6 +117,8 @@ struct v4l2_fh;
  *	Radio output
  * @vidioc_s_fmt_meta_cap: pointer to the function that implements
  *	:ref:`VIDIOC_S_FMT <vidioc_g_fmt>` ioctl logic for metadata capture
+ * @vidioc_s_fmt_meta_out: pointer to the function that implements
+ *	:ref:`VIDIOC_S_FMT <vidioc_g_fmt>` ioctl logic for metadata output
  * @vidioc_try_fmt_vid_cap: pointer to the function that implements
  *	:ref:`VIDIOC_TRY_FMT <vidioc_g_fmt>` ioctl logic for video capture
  *	in single plane mode
@@ -146,6 +153,8 @@ struct v4l2_fh;
  *	Radio output
  * @vidioc_try_fmt_meta_cap: pointer to the function that implements
  *	:ref:`VIDIOC_TRY_FMT <vidioc_g_fmt>` ioctl logic for metadata capture
+ * @vidioc_try_fmt_meta_out: pointer to the function that implements
+ *	:ref:`VIDIOC_TRY_FMT <vidioc_g_fmt>` ioctl logic for metadata output
  * @vidioc_reqbufs: pointer to the function that implements
  *	:ref:`VIDIOC_REQBUFS <vidioc_reqbufs>` ioctl
  * @vidioc_querybuf: pointer to the function that implements
@@ -314,6 +323,8 @@ struct v4l2_ioctl_ops {
 				       struct v4l2_fmtdesc *f);
 	int (*vidioc_enum_fmt_meta_cap)(struct file *file, void *fh,
 					struct v4l2_fmtdesc *f);
+	int (*vidioc_enum_fmt_meta_out)(struct file *file, void *fh,
+					struct v4l2_fmtdesc *f);
 
 	/* VIDIOC_G_FMT handlers */
 	int (*vidioc_g_fmt_vid_cap)(struct file *file, void *fh,
@@ -342,6 +353,8 @@ struct v4l2_ioctl_ops {
 				    struct v4l2_format *f);
 	int (*vidioc_g_fmt_meta_cap)(struct file *file, void *fh,
 				     struct v4l2_format *f);
+	int (*vidioc_g_fmt_meta_out)(struct file *file, void *fh,
+				     struct v4l2_format *f);
 
 	/* VIDIOC_S_FMT handlers */
 	int (*vidioc_s_fmt_vid_cap)(struct file *file, void *fh,
@@ -370,6 +383,8 @@ struct v4l2_ioctl_ops {
 				    struct v4l2_format *f);
 	int (*vidioc_s_fmt_meta_cap)(struct file *file, void *fh,
 				     struct v4l2_format *f);
+	int (*vidioc_s_fmt_meta_out)(struct file *file, void *fh,
+				     struct v4l2_format *f);
 
 	/* VIDIOC_TRY_FMT handlers */
 	int (*vidioc_try_fmt_vid_cap)(struct file *file, void *fh,
@@ -398,6 +413,8 @@ struct v4l2_ioctl_ops {
 				      struct v4l2_format *f);
 	int (*vidioc_try_fmt_meta_cap)(struct file *file, void *fh,
 				       struct v4l2_format *f);
+	int (*vidioc_try_fmt_meta_out)(struct file *file, void *fh,
+				       struct v4l2_format *f);
 
 	/* Buffer handlers */
 	int (*vidioc_reqbufs)(struct file *file, void *fh,
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 2db1635de9561..a9d47b1b94375 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -145,6 +145,7 @@ enum v4l2_buf_type {
 	V4L2_BUF_TYPE_SDR_CAPTURE          = 11,
 	V4L2_BUF_TYPE_SDR_OUTPUT           = 12,
 	V4L2_BUF_TYPE_META_CAPTURE         = 13,
+	V4L2_BUF_TYPE_META_OUTPUT	   = 14,
 	/* Deprecated, do not use */
 	V4L2_BUF_TYPE_PRIVATE              = 0x80,
 };
@@ -469,6 +470,7 @@ struct v4l2_capability {
 #define V4L2_CAP_READWRITE              0x01000000  /* read/write systemcalls */
 #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
 #define V4L2_CAP_STREAMING              0x04000000  /* streaming I/O ioctls */
+#define V4L2_CAP_META_OUTPUT		0x08000000  /* Is a metadata output device */
 
 #define V4L2_CAP_TOUCH                  0x10000000  /* Is a touch device */
 
-- 
2.11.0

