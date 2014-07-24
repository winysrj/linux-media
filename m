Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4002 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903AbaGXMUI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jul 2014 08:20:08 -0400
Message-ID: <53D0F9D9.7080003@xs4all.nl>
Date: Thu, 24 Jul 2014 14:19:37 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
Subject: [PATCH] vb2: fix vb2_poll for output streams
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vb2_poll should always return POLLOUT | POLLWRNORM as long as there
are fewer buffers queued than there are buffers available. Poll for
an output stream should only wait if all buffers are queued and nobody
is dequeuing them.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index f33508f..c359006 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2596,6 +2596,13 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	if ((list_empty(&q->queued_list) && !vb2_is_streaming(q)) || q->error)
 		return res | POLLERR;
 
+	/*
+	 * For output streams you can write as long as there are fewer buffers
+	 * queued than there are buffers available.
+	 */
+	if (V4L2_TYPE_IS_OUTPUT(q->type) && q->queued_count < q->num_buffers)
+		return res | POLLOUT | POLLWRNORM;
+
 	if (list_empty(&q->done_list))
 		poll_wait(file, &q->done_wq, wait);
 
-- 
2.0.0.rc0

