Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2604 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbaBJQM3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 11:12:29 -0500
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr9.xs4all.nl (8.13.8/8.13.8) with ESMTP id s1AGCPb7071331
	for <linux-media@vger.kernel.org>; Mon, 10 Feb 2014 17:12:27 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 3DBF42A00A8
	for <linux-media@vger.kernel.org>; Mon, 10 Feb 2014 17:12:00 +0100 (CET)
Message-ID: <52F8FA50.6080805@xs4all.nl>
Date: Mon, 10 Feb 2014 17:12:00 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH for v3.14] vb2: fix PREPARE_BUF regression.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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
index 5a5fb7f..d7a4f60 100644
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
1.8.4.rc3

