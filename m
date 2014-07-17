Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3105 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbaGQVpv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 17:45:51 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209])
	(authenticated bits=0)
	by smtp-vbr9.xs4all.nl (8.13.8/8.13.8) with ESMTP id s6HLjlke006365
	for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 23:45:49 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id EA32F2A1FD1
	for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 23:45:45 +0200 (CEST)
Message-ID: <53C84409.8010307@xs4all.nl>
Date: Thu, 17 Jul 2014 23:45:45 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH REBASED] v4l2-ioctl: clips, clipcount and bitmap should not
 be zeroed.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Otherwise you cannot get the current clip and bitmap information from
an overlay.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 46f45f0..e620387 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1145,6 +1145,30 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 
 	p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
 
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
@@ -2140,7 +2164,7 @@ struct v4l2_ioctl_info {
 static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_QUERYCAP, v4l_querycap, v4l_print_querycap, 0),
 	IOCTL_INFO_FNC(VIDIOC_ENUM_FMT, v4l_enum_fmt, v4l_print_fmtdesc, INFO_FL_CLEAR(v4l2_fmtdesc, type)),
-	IOCTL_INFO_FNC(VIDIOC_G_FMT, v4l_g_fmt, v4l_print_format, INFO_FL_CLEAR(v4l2_format, type)),
+	IOCTL_INFO_FNC(VIDIOC_G_FMT, v4l_g_fmt, v4l_print_format, 0),
 	IOCTL_INFO_FNC(VIDIOC_S_FMT, v4l_s_fmt, v4l_print_format, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_REQBUFS, v4l_reqbufs, v4l_print_requestbuffers, INFO_FL_PRIO | INFO_FL_QUEUE),
 	IOCTL_INFO_FNC(VIDIOC_QUERYBUF, v4l_querybuf, v4l_print_buffer, INFO_FL_QUEUE | INFO_FL_CLEAR(v4l2_buffer, length)),
-- 
2.0.1

