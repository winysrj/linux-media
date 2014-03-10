Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2928 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531AbaCJVVe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 17:21:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, sakari.ailus@iki.fi,
	m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 08/11] vb2: simplify a confusing condition.
Date: Mon, 10 Mar 2014 22:20:55 +0100
Message-Id: <1394486458-9836-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1394486458-9836-1-git-send-email-hverkuil@xs4all.nl>
References: <1394486458-9836-1-git-send-email-hverkuil@xs4all.nl>
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
index 8984187..2ae316b 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1099,9 +1099,8 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
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

