Return-path: <mchehab@localhost>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3972 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965209Ab1GMJjV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 05:39:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 3/6] videobuf2: only start streaming in poll() if so requested by the poll mask.
Date: Wed, 13 Jul 2011 11:39:01 +0200
Message-Id: <7fc8ed81f08a0ac8092c5b6a8badc3427df9bc1e.1310549521.git.hans.verkuil@cisco.com>
In-Reply-To: <1310549944-23756-1-git-send-email-hverkuil@xs4all.nl>
References: <1310549944-23756-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <bec0b6db54a6b435d219e5ad2d9f010848dd8c2b.1310549521.git.hans.verkuil@cisco.com>
References: <bec0b6db54a6b435d219e5ad2d9f010848dd8c2b.1310549521.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/videobuf2-core.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 3015e60..1892bb8 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -1365,6 +1365,7 @@ static int __vb2_cleanup_fileio(struct vb2_queue *q);
  */
 unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 {
+	unsigned long req_events = poll_requested_events(wait);
 	unsigned long flags;
 	unsigned int ret;
 	struct vb2_buffer *vb = NULL;
@@ -1373,12 +1374,14 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	 * Start file I/O emulator only if streaming API has not been used yet.
 	 */
 	if (q->num_buffers == 0 && q->fileio == NULL) {
-		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ)) {
+		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ) &&
+				(req_events & (POLLIN | POLLRDNORM))) {
 			ret = __vb2_init_fileio(q, 1);
 			if (ret)
 				return POLLERR;
 		}
-		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE)) {
+		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE) &&
+				(req_events & (POLLOUT | POLLWRNORM))) {
 			ret = __vb2_init_fileio(q, 0);
 			if (ret)
 				return POLLERR;
-- 
1.7.1

