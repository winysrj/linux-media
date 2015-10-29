Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:58801 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751679AbbJ2FCP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2015 01:02:15 -0400
To: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vb2: fix a regression in poll() behavior for output,streams
Message-ID: <5631A84E.7040101@xs4all.nl>
Date: Thu, 29 Oct 2015 14:02:06 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the 3.17 kernel the poll() behavior changed for output streams:
as long as not all buffers were queued up poll() would return that
userspace can write. This is fine for the write() call, but when
using stream I/O this changed the behavior since the expectation
was that it would wait for buffers to become available for dequeuing.

This patch only enables the check whether you can queue buffers
for file I/O only, and skips it for stream I/O.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Note: This patch should be applied to stable for 3.17 and up.

 drivers/media/v4l2-core/videobuf2-v4l2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index dda525b..3ca8a2e 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -860,10 +860,10 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 		return res | POLLERR;
 
 	/*
-	 * For output streams you can write as long as there are fewer buffers
-	 * queued than there are buffers available.
+	 * For output streams you can call write() as long as there are fewer
+	 * buffers queued than there are buffers available.
 	 */
-	if (q->is_output && q->queued_count < q->num_buffers)
+	if (q->is_output && q->fileio && q->queued_count < q->num_buffers)
 		return res | POLLOUT | POLLWRNORM;
 
 	if (list_empty(&q->done_list)) {
-- 
2.6.1

