Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1513 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaC1Kre (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Mar 2014 06:47:34 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id s2SAlUCT005141
	for <linux-media@vger.kernel.org>; Fri, 28 Mar 2014 11:47:32 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 28BCC2A03F2
	for <linux-media@vger.kernel.org>; Fri, 28 Mar 2014 11:47:29 +0100 (CET)
Message-ID: <53355341.6060502@xs4all.nl>
Date: Fri, 28 Mar 2014 11:47:29 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH for v3.15] vb2: call __buf_finish_memory for prepared/queued
 buffers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2-compliance reports unbalanced prepare/finish memops in the case
where buffers are queued, streamon is never called and then reqbufs()
is called that has to cancel any queued buffers.

When canceling a queue __buf_finish_memory() should be called for all
buffers in the state 'PREPARED' or 'QUEUED' to ensure the prepare and
finish memops are balanced.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 0bd0fd4..8f0624b 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2135,6 +2135,9 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 		struct vb2_buffer *vb = q->bufs[i];
 
 		if (vb->state != VB2_BUF_STATE_DEQUEUED) {
+			if (vb->state == VB2_BUF_STATE_QUEUED ||
+			    vb->state == VB2_BUF_STATE_PREPARED)
+				__buf_finish_memory(vb);
 			vb->state = VB2_BUF_STATE_PREPARED;
 			call_vb_qop(vb, buf_finish, vb);
 		}
-- 
1.9.0

