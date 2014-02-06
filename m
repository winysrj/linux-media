Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2933 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007AbaBFLDM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Feb 2014 06:03:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 04/10] vb2: call buf_finish from __dqbuf
Date: Thu,  6 Feb 2014 12:02:28 +0100
Message-Id: <1391684554-37956-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1391684554-37956-1-git-send-email-hverkuil@xs4all.nl>
References: <1391684554-37956-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This ensures that it is also called from queue_cancel, which also calls
__dqbuf(). Without this change any time queue_cancel is called while
streaming the buf_finish op will not be called and any driver cleanup
will not happen.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 07b58bd..3756378 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1762,6 +1762,8 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
 	if (vb->state == VB2_BUF_STATE_DEQUEUED)
 		return;
 
+	call_vb_qop(vb, buf_finish, vb);
+
 	vb->state = VB2_BUF_STATE_DEQUEUED;
 
 	/* unmap DMABUF buffer */
@@ -1787,12 +1789,6 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
 	if (ret < 0)
 		return ret;
 
-	ret = call_vb_qop(vb, buf_finish, vb);
-	if (ret) {
-		dprintk(1, "dqbuf: buffer finish failed\n");
-		return ret;
-	}
-
 	switch (vb->state) {
 	case VB2_BUF_STATE_DONE:
 		dprintk(3, "dqbuf: Returning done buffer\n");
-- 
1.8.5.2

