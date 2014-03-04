Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1881 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756848AbaCDKn1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Mar 2014 05:43:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv4 PATCH 15/18] vb2: fix streamoff handling if streamon wasn't called.
Date: Tue,  4 Mar 2014 11:42:23 +0100
Message-Id: <1393929746-39437-16-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393929746-39437-1-git-send-email-hverkuil@xs4all.nl>
References: <1393929746-39437-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

If you request buffers, then queue buffers and then call STREAMOFF
those buffers are not returned to their dequeued state because streamoff
will just return if q->streaming was 0.

This means that afterwards you can never QBUF that same buffer again unless
you do STREAMON, REQBUFS or close the filehandle first.

It is clear that if you do STREAMOFF even if no STREAMON was called before,
you still want to have all buffers returned to their proper dequeued state.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index e750769..3c00e22 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2069,14 +2069,14 @@ static int vb2_internal_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 		return -EINVAL;
 	}
 
-	if (!q->streaming) {
-		dprintk(3, "streamoff successful: not streaming\n");
-		return 0;
-	}
-
 	/*
 	 * Cancel will pause streaming and remove all buffers from the driver
 	 * and videobuf, effectively returning control over them to userspace.
+	 *
+	 * Note that we do this even if q->streaming == 0: if you prepare or
+	 * queue buffers, and then call streamoff without ever having called
+	 * streamon, you would still expect those buffers to be returned to
+	 * their normal dequeued state.
 	 */
 	__vb2_queue_cancel(q);
 
-- 
1.9.0

