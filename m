Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4068 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbaBYJsr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 04:48:47 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv1 PATCH 03/14] vb2: fix PREPARE_BUF regression
Date: Tue, 25 Feb 2014 10:48:16 +0100
Message-Id: <1393321707-9749-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393321707-9749-1-git-send-email-hverkuil@xs4all.nl>
References: <1393321707-9749-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix an incorrect test in vb2_internal_qbuf() where only DEQUEUED buffers
are allowed. But PREPARED buffers are also OK.

Introduced by commit 4138111a27859dcc56a5592c804dd16bb12a23d1
("vb2: simplify qbuf/prepare_buf by removing callback").

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index f1a2857c..909f367 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1420,11 +1420,6 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 		return ret;
 
 	vb = q->bufs[b->index];
-	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
-		dprintk(1, "%s(): invalid buffer state %d\n", __func__,
-			vb->state);
-		return -EINVAL;
-	}
 
 	switch (vb->state) {
 	case VB2_BUF_STATE_DEQUEUED:
@@ -1438,7 +1433,8 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 		dprintk(1, "qbuf: buffer still being prepared\n");
 		return -EINVAL;
 	default:
-		dprintk(1, "qbuf: buffer already in use\n");
+		dprintk(1, "%s(): invalid buffer state %d\n", __func__,
+			vb->state);
 		return -EINVAL;
 	}
 
-- 
1.9.0

