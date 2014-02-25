Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2828 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbaBYKE5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:04:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 20/20] vb2: simplify a confusing condition.
Date: Tue, 25 Feb 2014 11:04:25 +0100
Message-Id: <1393322665-29889-21-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
References: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

q->start_streaming_called is always true, so the WARN_ON check against
it being false can be dropped.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 8ea78d6..0e40c8d 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1081,9 +1081,8 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
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
1.9.0

