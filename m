Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53182 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676Ab3LLQ5p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Dec 2013 11:57:45 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 2/2] v4l2: enable FMT IOCTLs for SDR
Date: Thu, 12 Dec 2013 18:57:27 +0200
Message-Id: <1386867447-1018-3-git-send-email-crope@iki.fi>
In-Reply-To: <1386867447-1018-1-git-send-email-crope@iki.fi>
References: <1386867447-1018-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable format IOCTLs for SDR use. There are used for negotiate used
data stream format.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/v4l2-core/v4l2-dev.c   | 12 ++++++++++++
 drivers/media/v4l2-core/v4l2-ioctl.c | 26 ++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index c9cf54c..d67286ba 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -563,6 +563,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	bool is_vid = vdev->vfl_type == VFL_TYPE_GRABBER;
 	bool is_vbi = vdev->vfl_type == VFL_TYPE_VBI;
 	bool is_radio = vdev->vfl_type == VFL_TYPE_RADIO;
+	bool is_sdr = vdev->vfl_type == VFL_TYPE_SDR;
 	bool is_rx = vdev->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vdev->vfl_dir != VFL_DIR_RX;
 
@@ -612,6 +613,17 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	if (ops->vidioc_enum_freq_bands || ops->vidioc_g_tuner || ops->vidioc_g_modulator)
 		set_bit(_IOC_NR(VIDIOC_ENUM_FREQ_BANDS), valid_ioctls);
 
+	if (is_sdr && is_rx) {
+		/* SDR specific ioctls */
+		if (ops->vidioc_enum_fmt_vid_cap)
+			set_bit(_IOC_NR(VIDIOC_ENUM_FMT), valid_ioctls);
+		if (ops->vidioc_g_fmt_vid_cap)
+			set_bit(_IOC_NR(VIDIOC_G_FMT), valid_ioctls);
+		if (ops->vidioc_s_fmt_vid_cap)
+			set_bit(_IOC_NR(VIDIOC_S_FMT), valid_ioctls);
+		if (ops->vidioc_try_fmt_vid_cap)
+			set_bit(_IOC_NR(VIDIOC_TRY_FMT), valid_ioctls);
+	}
 	if (is_vid) {
 		/* video specific ioctls */
 		if ((is_rx && (ops->vidioc_enum_fmt_vid_cap ||
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 5b6e0e8..2471179 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -879,6 +879,7 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
 	const struct v4l2_ioctl_ops *ops = vfd->ioctl_ops;
 	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
 	bool is_vbi = vfd->vfl_type == VFL_TYPE_VBI;
+	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 
@@ -928,6 +929,10 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
 		if (is_vbi && is_tx && ops->vidioc_g_fmt_sliced_vbi_out)
 			return 0;
 		break;
+	case V4L2_BUF_TYPE_SDR_RX:
+		if (is_sdr && is_rx && ops->vidioc_g_fmt_vid_cap)
+			return 0;
+		break;
 	default:
 		break;
 	}
@@ -1047,6 +1052,10 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!is_tx || !ops->vidioc_enum_fmt_vid_out_mplane))
 			break;
 		return ops->vidioc_enum_fmt_vid_out_mplane(file, fh, arg);
+	case V4L2_BUF_TYPE_SDR_RX:
+		if (unlikely(!is_rx || !ops->vidioc_enum_fmt_vid_cap))
+			break;
+		return ops->vidioc_enum_fmt_vid_cap(file, fh, arg);
 	}
 	return -EINVAL;
 }
@@ -1057,6 +1066,7 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_format *p = arg;
 	struct video_device *vfd = video_devdata(file);
 	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
+	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 
@@ -1101,6 +1111,10 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!is_tx || is_vid || !ops->vidioc_g_fmt_sliced_vbi_out))
 			break;
 		return ops->vidioc_g_fmt_sliced_vbi_out(file, fh, arg);
+	case V4L2_BUF_TYPE_SDR_RX:
+		if (unlikely(!is_rx || !is_sdr || !ops->vidioc_g_fmt_vid_cap))
+			break;
+		return ops->vidioc_g_fmt_vid_cap(file, fh, arg);
 	}
 	return -EINVAL;
 }
@@ -1111,6 +1125,7 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_format *p = arg;
 	struct video_device *vfd = video_devdata(file);
 	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
+	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 
@@ -1165,6 +1180,11 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.sliced);
 		return ops->vidioc_s_fmt_sliced_vbi_out(file, fh, arg);
+	case V4L2_BUF_TYPE_SDR_RX:
+		if (unlikely(!is_rx || !is_sdr || !ops->vidioc_s_fmt_vid_cap))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.sdr);
+		return ops->vidioc_s_fmt_vid_cap(file, fh, arg);
 	}
 	return -EINVAL;
 }
@@ -1175,6 +1195,7 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_format *p = arg;
 	struct video_device *vfd = video_devdata(file);
 	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
+	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 
@@ -1229,6 +1250,11 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.sliced);
 		return ops->vidioc_try_fmt_sliced_vbi_out(file, fh, arg);
+	case V4L2_BUF_TYPE_SDR_RX:
+		if (unlikely(!is_rx || !is_sdr || !ops->vidioc_try_fmt_vid_cap))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.sdr);
+		return ops->vidioc_try_fmt_vid_cap(file, fh, arg);
 	}
 	return -EINVAL;
 }
-- 
1.8.4.2

