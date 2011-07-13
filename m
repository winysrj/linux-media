Return-path: <mchehab@localhost>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1727 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965211Ab1GMJjW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 05:39:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 4/6] videobuf: only start streaming in poll() if so requested by the poll mask.
Date: Wed, 13 Jul 2011 11:39:02 +0200
Message-Id: <ba332614a31008c2261fd39c5b93e34143f8c73a.1310549521.git.hans.verkuil@cisco.com>
In-Reply-To: <1310549944-23756-1-git-send-email-hverkuil@xs4all.nl>
References: <1310549944-23756-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <bec0b6db54a6b435d219e5ad2d9f010848dd8c2b.1310549521.git.hans.verkuil@cisco.com>
References: <bec0b6db54a6b435d219e5ad2d9f010848dd8c2b.1310549521.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/videobuf-core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index de4fa4e..ffdf59c 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -1129,6 +1129,7 @@ unsigned int videobuf_poll_stream(struct file *file,
 				  struct videobuf_queue *q,
 				  poll_table *wait)
 {
+	unsigned long req_events = poll_requested_events(wait);
 	struct videobuf_buffer *buf = NULL;
 	unsigned int rc = 0;
 
@@ -1137,7 +1138,7 @@ unsigned int videobuf_poll_stream(struct file *file,
 		if (!list_empty(&q->stream))
 			buf = list_entry(q->stream.next,
 					 struct videobuf_buffer, stream);
-	} else {
+	} else if (req_events & (POLLIN | POLLRDNORM)) {
 		if (!q->reading)
 			__videobuf_read_start(q);
 		if (!q->reading) {
-- 
1.7.1

