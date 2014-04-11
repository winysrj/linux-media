Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2584 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaDKIMY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 04:12:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	s.nawrocki@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv3 PATCH 08/13] vb2: simplify a confusing condition.
Date: Fri, 11 Apr 2014 10:11:14 +0200
Message-Id: <1397203879-37443-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1397203879-37443-1-git-send-email-hverkuil@xs4all.nl>
References: <1397203879-37443-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

q->start_streaming_called is always true, so the WARN_ON check against
it being false can be dropped.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Pawel Osciak <pawel@osciak.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index f8c0247..3d2a003 100644
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

