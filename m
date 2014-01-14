Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55304 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbaANBU6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 20:20:58 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC v7 06/12] v4l: enable some IOCTLs for SDR receiver
Date: Tue, 14 Jan 2014 03:20:24 +0200
Message-Id: <1389662430-32699-7-git-send-email-crope@iki.fi>
In-Reply-To: <1389662430-32699-1-git-send-email-crope@iki.fi>
References: <1389662430-32699-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable stream format (FMT) IOCTLs for SDR use. These are used for negotiate
used data stream format.

Reorganise some some IOCTL selection logic.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/v4l2-core/v4l2-dev.c   | 21 ++++++++++++++++++---
 drivers/media/v4l2-core/v4l2-ioctl.c | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 2ccacf2..6308a19 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -553,7 +553,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	const struct v4l2_ioctl_ops *ops = vdev->ioctl_ops;
 	bool is_vid = vdev->vfl_type == VFL_TYPE_GRABBER;
 	bool is_vbi = vdev->vfl_type == VFL_TYPE_VBI;
-	bool is_radio = vdev->vfl_type == VFL_TYPE_RADIO;
+	bool is_sdr = vdev->vfl_type == VFL_TYPE_SDR;
 	bool is_rx = vdev->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vdev->vfl_dir != VFL_DIR_RX;
 
@@ -662,9 +662,20 @@ static void determine_valid_ioctls(struct video_device *vdev)
 			       ops->vidioc_try_fmt_sliced_vbi_out)))
 			set_bit(_IOC_NR(VIDIOC_TRY_FMT), valid_ioctls);
 		SET_VALID_IOCTL(ops, VIDIOC_G_SLICED_VBI_CAP, vidioc_g_sliced_vbi_cap);
+	} else if (is_sdr) {
+		/* SDR specific ioctls */
+		if (ops->vidioc_enum_fmt_sdr_cap)
+			set_bit(_IOC_NR(VIDIOC_ENUM_FMT), valid_ioctls);
+		if (ops->vidioc_g_fmt_sdr_cap)
+			set_bit(_IOC_NR(VIDIOC_G_FMT), valid_ioctls);
+		if (ops->vidioc_s_fmt_sdr_cap)
+			set_bit(_IOC_NR(VIDIOC_S_FMT), valid_ioctls);
+		if (ops->vidioc_try_fmt_sdr_cap)
+			set_bit(_IOC_NR(VIDIOC_TRY_FMT), valid_ioctls);
 	}
-	if (!is_radio) {
-		/* ioctls valid for video or vbi */
+
+	if (is_vid || is_vbi || is_sdr) {
+		/* ioctls valid for video, vbi or sdr */
 		SET_VALID_IOCTL(ops, VIDIOC_REQBUFS, vidioc_reqbufs);
 		SET_VALID_IOCTL(ops, VIDIOC_QUERYBUF, vidioc_querybuf);
 		SET_VALID_IOCTL(ops, VIDIOC_QBUF, vidioc_qbuf);
@@ -672,6 +683,10 @@ static void determine_valid_ioctls(struct video_device *vdev)
 		SET_VALID_IOCTL(ops, VIDIOC_DQBUF, vidioc_dqbuf);
 		SET_VALID_IOCTL(ops, VIDIOC_CREATE_BUFS, vidioc_create_bufs);
 		SET_VALID_IOCTL(ops, VIDIOC_PREPARE_BUF, vidioc_prepare_buf);
+	}
+
+	if (is_vid || is_vbi) {
+		/* ioctls valid for video or vbi */
 		if (ops->vidioc_s_std)
 			set_bit(_IOC_NR(VIDIOC_ENUMSTD), valid_ioctls);
 		SET_VALID_IOCTL(ops, VIDIOC_S_STD, vidioc_s_std);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 9a2acaf..95dd4f1 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -246,6 +246,7 @@ static void v4l_print_format(const void *arg, bool write_only)
 	const struct v4l2_vbi_format *vbi;
 	const struct v4l2_sliced_vbi_format *sliced;
 	const struct v4l2_window *win;
+	const struct v4l2_format_sdr *sdr;
 	unsigned i;
 
 	pr_cont("type=%s", prt_names(p->type, v4l2_type_names));
@@ -319,6 +320,14 @@ static void v4l_print_format(const void *arg, bool write_only)
 				sliced->service_lines[0][i],
 				sliced->service_lines[1][i]);
 		break;
+	case V4L2_BUF_TYPE_SDR_CAPTURE:
+		sdr = &p->fmt.sdr;
+		pr_cont(", pixelformat=%c%c%c%c\n",
+			(sdr->pixelformat >>  0) & 0xff,
+			(sdr->pixelformat >>  8) & 0xff,
+			(sdr->pixelformat >> 16) & 0xff,
+			(sdr->pixelformat >> 24) & 0xff);
+		break;
 	}
 }
 
@@ -882,6 +891,7 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
 	const struct v4l2_ioctl_ops *ops = vfd->ioctl_ops;
 	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
 	bool is_vbi = vfd->vfl_type == VFL_TYPE_VBI;
+	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 
@@ -931,6 +941,10 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
 		if (is_vbi && is_tx && ops->vidioc_g_fmt_sliced_vbi_out)
 			return 0;
 		break;
+	case V4L2_BUF_TYPE_SDR_CAPTURE:
+		if (is_sdr && is_rx && ops->vidioc_g_fmt_sdr_cap)
+			return 0;
+		break;
 	default:
 		break;
 	}
@@ -1050,6 +1064,10 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!is_tx || !ops->vidioc_enum_fmt_vid_out_mplane))
 			break;
 		return ops->vidioc_enum_fmt_vid_out_mplane(file, fh, arg);
+	case V4L2_BUF_TYPE_SDR_CAPTURE:
+		if (unlikely(!is_rx || !ops->vidioc_enum_fmt_sdr_cap))
+			break;
+		return ops->vidioc_enum_fmt_sdr_cap(file, fh, arg);
 	}
 	return -EINVAL;
 }
@@ -1060,6 +1078,7 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_format *p = arg;
 	struct video_device *vfd = video_devdata(file);
 	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
+	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 
@@ -1104,6 +1123,10 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!is_tx || is_vid || !ops->vidioc_g_fmt_sliced_vbi_out))
 			break;
 		return ops->vidioc_g_fmt_sliced_vbi_out(file, fh, arg);
+	case V4L2_BUF_TYPE_SDR_CAPTURE:
+		if (unlikely(!is_rx || !is_sdr || !ops->vidioc_g_fmt_sdr_cap))
+			break;
+		return ops->vidioc_g_fmt_sdr_cap(file, fh, arg);
 	}
 	return -EINVAL;
 }
@@ -1114,6 +1137,7 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_format *p = arg;
 	struct video_device *vfd = video_devdata(file);
 	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
+	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 
@@ -1168,6 +1192,11 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.sliced);
 		return ops->vidioc_s_fmt_sliced_vbi_out(file, fh, arg);
+	case V4L2_BUF_TYPE_SDR_CAPTURE:
+		if (unlikely(!is_rx || !is_sdr || !ops->vidioc_s_fmt_sdr_cap))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.sdr);
+		return ops->vidioc_s_fmt_sdr_cap(file, fh, arg);
 	}
 	return -EINVAL;
 }
@@ -1178,6 +1207,7 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_format *p = arg;
 	struct video_device *vfd = video_devdata(file);
 	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
+	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 
@@ -1232,6 +1262,11 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.sliced);
 		return ops->vidioc_try_fmt_sliced_vbi_out(file, fh, arg);
+	case V4L2_BUF_TYPE_SDR_CAPTURE:
+		if (unlikely(!is_rx || !is_sdr || !ops->vidioc_try_fmt_sdr_cap))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.sdr);
+		return ops->vidioc_try_fmt_sdr_cap(file, fh, arg);
 	}
 	return -EINVAL;
 }
-- 
1.8.4.2

