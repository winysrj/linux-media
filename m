Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3623 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338AbaDGNLn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Apr 2014 09:11:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 08/13] vb2: simplify a confusing condition.
Date: Mon,  7 Apr 2014 15:11:07 +0200
Message-Id: <1396876272-18222-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1396876272-18222-1-git-send-email-hverkuil@xs4all.nl>
References: <1396876272-18222-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

q->start_streaming_called is always true, so the WARN_ON check against
it being false can be dropped.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index c662ad9..89147d2 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1094,9 +1094,8 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	if (!q->start_streaming_called) {
 		if (WARN_ON(state != VB2_BUF_STATE_QUEUED))
 			state = VB2_BUF_STATE_QUEUED;
-	} else if (!WARN_ON(!q->start_streaming_called)) {
-		if (WARN_ON(state != VB2_BUF_STATE_DONE &&
-			    state != VB2_BUF_STATE_ERROR))
+	} else if (WARN_ON(state != VB2_BUF_STATE_DONE &&
+			   state != VB2_BUF_STATE_ERROR)) {
 			state = VB2_BUF_STATE_ERROR;
 	}
 
-- 
1.9.1

