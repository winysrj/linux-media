Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54266 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935Ab3LPWIY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Dec 2013 17:08:24 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC v3 5/7] v4l: enable some IOCTLs for SDR receiver
Date: Tue, 17 Dec 2013 00:08:06 +0200
Message-Id: <1387231688-8647-6-git-send-email-crope@iki.fi>
In-Reply-To: <1387231688-8647-1-git-send-email-crope@iki.fi>
References: <1387231688-8647-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable stream format (FMT) IOCTLs for SDR use. These are used for negotiate
used data stream format.

Enable input IOCTLs, VIDIOC_ENUMINPUT, VIDIOC_G_INPUT, VIDIOC_S_INPUT.
These are used to select possible antenna connector.

Reorganise some some IOCTL selection logic.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/v4l2-core/v4l2-dev.c   | 27 ++++++++++++++++++++++++---
 drivers/media/v4l2-core/v4l2-ioctl.c | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 6a1e6a8..5795e8d 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -562,7 +562,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	const struct v4l2_ioctl_ops *ops = vdev->ioctl_ops;
 	bool is_vid = vdev->vfl_type == VFL_TYPE_GRABBER;
 	bool is_vbi = vdev->vfl_type == VFL_TYPE_VBI;
-	bool is_radio = vdev->vfl_type == VFL_TYPE_RADIO;
+	bool is_sdr = vdev->vfl_type == VFL_TYPE_SDR;
 	bool is_rx = vdev->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vdev->vfl_dir != VFL_DIR_RX;
 
@@ -671,9 +671,26 @@ static void determine_valid_ioctls(struct video_device *vdev)
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
+
+		if (is_rx) {
+			SET_VALID_IOCTL(ops, VIDIOC_ENUMINPUT, vidioc_enum_input);
+			SET_VALID_IOCTL(ops, VIDIOC_G_INPUT, vidioc_g_input);
+			SET_VALID_IOCTL(ops, VIDIOC_S_INPUT, vidioc_s_input);
+		}
 	}
-	if (!is_radio) {
-		/* ioctls valid for video or vbi */
+
+	if (is_vid || is_vbi || is_sdr) {
+		/* ioctls valid for video, vbi or sdr */
 		SET_VALID_IOCTL(ops, VIDIOC_REQBUFS, vidioc_reqbufs);
 		SET_VALID_IOCTL(ops, VIDIOC_QUERYBUF, vidioc_querybuf);
 		SET_VALID_IOCTL(ops, VIDIOC_QBUF, vidioc_qbuf);
@@ -681,6 +698,10 @@ static void determine_valid_ioctls(struct video_device *vdev)
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
index da197e1..d0777bd 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -243,6 +243,7 @@ static void v4l_print_format(const void *arg, bool write_only)
 	const struct v4l2_vbi_format *vbi;
 	const struct v4l2_sliced_vbi_format *sliced;
 	const struct v4l2_window *win;
+	const struct v4l2_format_sdr *sdr;
 	unsigned i;
 
 	pr_cont("type=%s", prt_names(p->type, v4l2_type_names));
@@ -316,6 +317,14 @@ static void v4l_print_format(const void *arg, bool write_only)
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
 
@@ -879,6 +888,7 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
 	const struct v4l2_ioctl_ops *ops = vfd->ioctl_ops;
 	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
 	bool is_vbi = vfd->vfl_type == VFL_TYPE_VBI;
+	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 
@@ -928,6 +938,10 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
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
@@ -1047,6 +1061,10 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
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
@@ -1057,6 +1075,7 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_format *p = arg;
 	struct video_device *vfd = video_devdata(file);
 	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
+	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 
@@ -1101,6 +1120,10 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
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
@@ -1111,6 +1134,7 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_format *p = arg;
 	struct video_device *vfd = video_devdata(file);
 	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
+	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 
@@ -1165,6 +1189,11 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
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
@@ -1175,6 +1204,7 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_format *p = arg;
 	struct video_device *vfd = video_devdata(file);
 	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
+	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 
@@ -1229,6 +1259,11 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
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

