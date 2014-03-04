Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1886 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777AbaCDKnk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Mar 2014 05:43:40 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv4 PATCH 16/18] vb2: call buf_finish after the state check.
Date: Tue,  4 Mar 2014 11:42:24 +0100
Message-Id: <1393929746-39437-17-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393929746-39437-1-git-send-email-hverkuil@xs4all.nl>
References: <1393929746-39437-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Don't call buf_finish unless we know that the buffer is in a valid state.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 3c00e22..54cea42 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1878,8 +1878,6 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
 	if (ret < 0)
 		return ret;
 
-	call_vb_qop(vb, buf_finish, vb);
-
 	switch (vb->state) {
 	case VB2_BUF_STATE_DONE:
 		dprintk(3, "dqbuf: Returning done buffer\n");
@@ -1892,6 +1890,8 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
 		return -EINVAL;
 	}
 
+	call_vb_qop(vb, buf_finish, vb);
+
 	/* Fill buffer information for the userspace */
 	__fill_v4l2_buffer(vb, b);
 	/* Remove from videobuf queue */
-- 
1.9.0

