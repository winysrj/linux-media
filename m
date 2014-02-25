Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1383 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaBYKQR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:16:17 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 02/13] v4l2-ioctl: clips, clipcount and bitmap should not be zeroed.
Date: Tue, 25 Feb 2014 11:15:52 +0100
Message-Id: <1393323363-30058-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393323363-30058-1-git-send-email-hverkuil@xs4all.nl>
References: <1393323363-30058-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Otherwise you cannot get the current clip and bitmap information from
an overlay.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 69a1948..82bf164 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1062,6 +1062,30 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 
+	/*
+	 * fmt can't be cleared for these overlay types due to the 'clips'
+	 * 'clipcount' and 'bitmap' pointers in struct v4l2_window.
+	 * Those are provided by the user. So handle these two overlay types
+	 * first, and then just do a simple memset for the other types.
+	 */
+	switch (p->type) {
+	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY: {
+		struct v4l2_clip *clips = p->fmt.win.clips;
+		u32 clipcount = p->fmt.win.clipcount;
+		void *bitmap = p->fmt.win.bitmap;
+
+		memset(&p->fmt, 0, sizeof(p->fmt));
+		p->fmt.win.clips = clips;
+		p->fmt.win.clipcount = clipcount;
+		p->fmt.win.bitmap = bitmap;
+		break;
+	}
+	default:
+		memset(&p->fmt, 0, sizeof(p->fmt));
+		break;
+	}
+
 	switch (p->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 		if (unlikely(!is_rx || !is_vid || !ops->vidioc_g_fmt_vid_cap))
@@ -2029,7 +2053,7 @@ struct v4l2_ioctl_info {
 static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_QUERYCAP, v4l_querycap, v4l_print_querycap, 0),
 	IOCTL_INFO_FNC(VIDIOC_ENUM_FMT, v4l_enum_fmt, v4l_print_fmtdesc, INFO_FL_CLEAR(v4l2_fmtdesc, type)),
-	IOCTL_INFO_FNC(VIDIOC_G_FMT, v4l_g_fmt, v4l_print_format, INFO_FL_CLEAR(v4l2_format, type)),
+	IOCTL_INFO_FNC(VIDIOC_G_FMT, v4l_g_fmt, v4l_print_format, 0),
 	IOCTL_INFO_FNC(VIDIOC_S_FMT, v4l_s_fmt, v4l_print_format, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_REQBUFS, v4l_reqbufs, v4l_print_requestbuffers, INFO_FL_PRIO | INFO_FL_QUEUE),
 	IOCTL_INFO_FNC(VIDIOC_QUERYBUF, v4l_querybuf, v4l_print_buffer, INFO_FL_QUEUE | INFO_FL_CLEAR(v4l2_buffer, length)),
-- 
1.9.0

