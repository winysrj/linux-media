Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:60237 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751656AbaGHQsh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Jul 2014 12:48:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/8] v4l2-ioctl: clips, clipcount and bitmap should not be zeroed.
Date: Tue,  8 Jul 2014 18:31:12 +0200
Message-Id: <1404837078-15608-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1404837078-15608-1-git-send-email-hverkuil@xs4all.nl>
References: <1404837078-15608-1-git-send-email-hverkuil@xs4all.nl>
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
index f81b9aa..0e90349 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1090,6 +1090,30 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
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
@@ -2046,7 +2070,7 @@ struct v4l2_ioctl_info {
 static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_QUERYCAP, v4l_querycap, v4l_print_querycap, 0),
 	IOCTL_INFO_FNC(VIDIOC_ENUM_FMT, v4l_enum_fmt, v4l_print_fmtdesc, INFO_FL_CLEAR(v4l2_fmtdesc, type)),
-	IOCTL_INFO_FNC(VIDIOC_G_FMT, v4l_g_fmt, v4l_print_format, INFO_FL_CLEAR(v4l2_format, type)),
+	IOCTL_INFO_FNC(VIDIOC_G_FMT, v4l_g_fmt, v4l_print_format, 0),
 	IOCTL_INFO_FNC(VIDIOC_S_FMT, v4l_s_fmt, v4l_print_format, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_REQBUFS, v4l_reqbufs, v4l_print_requestbuffers, INFO_FL_PRIO | INFO_FL_QUEUE),
 	IOCTL_INFO_FNC(VIDIOC_QUERYBUF, v4l_querybuf, v4l_print_buffer, INFO_FL_QUEUE | INFO_FL_CLEAR(v4l2_buffer, length)),
-- 
2.0.0

