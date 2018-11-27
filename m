Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48984 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbeK1JH3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Nov 2018 04:07:29 -0500
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Tomasz Figa <tfiga@chromium.org>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v2] v4l2-ioctl: Zero v4l2_plane_pix_format reserved fields
Date: Tue, 27 Nov 2018 19:07:56 -0300
Message-Id: <20181127220756.26913-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the core set the reserved fields to zero in
vv4l2_pix_format_mplane.4l2_plane_pix_format,
for _MPLANE queue types.

Moving this to the core avoids having to do so in each
and every driver.

Suggested-by: Tomasz Figa <tfiga@chromium.org>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
--
v2:
  * Drop unneeded clear in g_fmt.
    The sturct was already being cleared here.
  * Only zero plane_fmt reserved fields.
  * Use CLEAR_FIELD_MACRO.

 drivers/media/v4l2-core/v4l2-ioctl.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index e384142d2826..2506b602481f 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1512,6 +1512,7 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_format *p = arg;
 	struct video_device *vfd = video_devdata(file);
 	int ret = check_fmt(file, p->type);
+	int i;
 
 	if (ret)
 		return ret;
@@ -1536,6 +1537,8 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!ops->vidioc_s_fmt_vid_cap_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
+		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
+			CLEAR_AFTER_FIELD(p, fmt.pix_mp.plane_fmt[i].bytesperline);
 		return ops->vidioc_s_fmt_vid_cap_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 		if (unlikely(!ops->vidioc_s_fmt_vid_overlay))
@@ -1564,6 +1567,8 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!ops->vidioc_s_fmt_vid_out_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
+		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
+			CLEAR_AFTER_FIELD(p, fmt.pix_mp.plane_fmt[i].bytesperline);
 		return ops->vidioc_s_fmt_vid_out_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
 		if (unlikely(!ops->vidioc_s_fmt_vid_out_overlay))
@@ -1604,6 +1609,7 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 {
 	struct v4l2_format *p = arg;
 	int ret = check_fmt(file, p->type);
+	int i;
 
 	if (ret)
 		return ret;
@@ -1623,6 +1629,8 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!ops->vidioc_try_fmt_vid_cap_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
+		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
+			CLEAR_AFTER_FIELD(p, fmt.pix_mp.plane_fmt[i].bytesperline);
 		return ops->vidioc_try_fmt_vid_cap_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 		if (unlikely(!ops->vidioc_try_fmt_vid_overlay))
@@ -1651,6 +1659,8 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!ops->vidioc_try_fmt_vid_out_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
+		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
+			CLEAR_AFTER_FIELD(p, fmt.pix_mp.plane_fmt[i].bytesperline);
 		return ops->vidioc_try_fmt_vid_out_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
 		if (unlikely(!ops->vidioc_try_fmt_vid_out_overlay))
-- 
2.19.1
