Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:50115 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752863AbbCIVYJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 17:24:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 12/18] marvell-ccic: fix streaming issues
Date: Mon,  9 Mar 2015 22:22:17 +0100
Message-Id: <1425936143-5658-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
References: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- fill in timestamp
- fill in field
- start the sequence counter at 0, not 1

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index a1312a5..6b7b38b 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -239,6 +239,8 @@ static void mcam_buffer_done(struct mcam_camera *cam, int frame,
 {
 	vbuf->v4l2_buf.bytesused = cam->pix_format.sizeimage;
 	vbuf->v4l2_buf.sequence = cam->buf_seq[frame];
+	vbuf->v4l2_buf.field = V4L2_FIELD_NONE;
+	v4l2_get_timestamp(&vbuf->v4l2_buf.timestamp);
 	vb2_set_plane_payload(vbuf, 0, cam->pix_format.sizeimage);
 	vb2_buffer_done(vbuf, VB2_BUF_STATE_DONE);
 }
@@ -1671,7 +1673,7 @@ static void mcam_frame_complete(struct mcam_camera *cam, int frame)
 	set_bit(frame, &cam->flags);
 	clear_bit(CF_DMA_ACTIVE, &cam->flags);
 	cam->next_buf = frame;
-	cam->buf_seq[frame] = ++(cam->sequence);
+	cam->buf_seq[frame] = cam->sequence++;
 	cam->frame_state.frames++;
 	/*
 	 * "This should never happen"
-- 
2.1.4

