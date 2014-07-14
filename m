Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3183 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991AbaGNM7l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 08:59:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 12/12] v4l2-ioctl.c: check vfl_type in ENUM_FMT.
Date: Mon, 14 Jul 2014 14:59:12 +0200
Message-Id: <1405342752-46998-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1405342752-46998-1-git-send-email-hverkuil@xs4all.nl>
References: <1405342752-46998-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The other format ioctls (g/s/try_fmt) all check if the passed buffer type
makes sense for the device node's vfl_type. E.g. it makes no sense for a
VBI buffer type to be passed through a video node instead of a vbi node.

But this check was missing in ENUM_FMT which can cause a problem if you
have both video and sdr device nodes.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index afed070..54f46f3 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1048,32 +1048,34 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
 {
 	struct v4l2_fmtdesc *p = arg;
 	struct video_device *vfd = video_devdata(file);
+	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
+	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 
 	switch (p->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		if (unlikely(!is_rx || !ops->vidioc_enum_fmt_vid_cap))
+		if (unlikely(!is_rx || !is_vid || !ops->vidioc_enum_fmt_vid_cap))
 			break;
 		return ops->vidioc_enum_fmt_vid_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
-		if (unlikely(!is_rx || !ops->vidioc_enum_fmt_vid_cap_mplane))
+		if (unlikely(!is_rx || !is_vid || !ops->vidioc_enum_fmt_vid_cap_mplane))
 			break;
 		return ops->vidioc_enum_fmt_vid_cap_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
-		if (unlikely(!is_rx || !ops->vidioc_enum_fmt_vid_overlay))
+		if (unlikely(!is_rx || !is_vid || !ops->vidioc_enum_fmt_vid_overlay))
 			break;
 		return ops->vidioc_enum_fmt_vid_overlay(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
-		if (unlikely(!is_tx || !ops->vidioc_enum_fmt_vid_out))
+		if (unlikely(!is_tx || !is_vid || !ops->vidioc_enum_fmt_vid_out))
 			break;
 		return ops->vidioc_enum_fmt_vid_out(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
-		if (unlikely(!is_tx || !ops->vidioc_enum_fmt_vid_out_mplane))
+		if (unlikely(!is_tx || !is_vid || !ops->vidioc_enum_fmt_vid_out_mplane))
 			break;
 		return ops->vidioc_enum_fmt_vid_out_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_SDR_CAPTURE:
-		if (unlikely(!is_rx || !ops->vidioc_enum_fmt_sdr_cap))
+		if (unlikely(!is_rx || !is_sdr || !ops->vidioc_enum_fmt_sdr_cap))
 			break;
 		return ops->vidioc_enum_fmt_sdr_cap(file, fh, arg);
 	}
-- 
2.0.1

