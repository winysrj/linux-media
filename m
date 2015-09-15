Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:53068 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751948AbbIOGvC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2015 02:51:02 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 6A5102A008D
	for <linux-media@vger.kernel.org>; Tue, 15 Sep 2015 08:49:44 +0200 (CEST)
Message-ID: <55F7BF88.1080409@xs4all.nl>
Date: Tue, 15 Sep 2015 08:49:44 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: vim2m: small cleanup: use assignment instead of memcpy
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use a type-safe assignment instead of memcpy. And it is easier to read as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 295fde5..d47cfba 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -233,12 +233,9 @@ static int device_process(struct vim2m_ctx *ctx,
 
 	out_vb->v4l2_buf.sequence = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE)->sequence++;
 	in_vb->v4l2_buf.sequence = q_data->sequence++;
-	memcpy(&out_vb->v4l2_buf.timestamp,
-			&in_vb->v4l2_buf.timestamp,
-			sizeof(struct timeval));
+	out_vb->v4l2_buf.timestamp = in_vb->v4l2_buf.timestamp;
 	if (in_vb->v4l2_buf.flags & V4L2_BUF_FLAG_TIMECODE)
-		memcpy(&out_vb->v4l2_buf.timecode, &in_vb->v4l2_buf.timecode,
-			sizeof(struct v4l2_timecode));
+		out_vb->v4l2_buf.timecode = in_vb->v4l2_buf.timecode;
 	out_vb->v4l2_buf.field = in_vb->v4l2_buf.field;
 	out_vb->v4l2_buf.flags = in_vb->v4l2_buf.flags &
 		(V4L2_BUF_FLAG_TIMECODE |
