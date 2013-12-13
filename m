Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1164 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab3LMQOH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 11:14:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 6/9] vb2: don't set index, don't start streaming for write()
Date: Fri, 13 Dec 2013 17:13:43 +0100
Message-Id: <1386951226-27655-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1386951226-27655-1-git-send-email-hverkuil@xs4all.nl>
References: <1386951226-27655-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Two fixes:

- there is no need to set the index when calling dqbuf: dqbuf will
  overwrite it.
- __vb2_init_fileio already starts streaming for write(), so there is
  no need to do it again in __vb2_perform_fileio. It can never have
  worked anyway: either __vb2_init_fileio succeeds in starting streaming
  or it is never going to happen.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 28e64b1..8d61e6d 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2444,7 +2444,6 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		memset(&fileio->b, 0, sizeof(fileio->b));
 		fileio->b.type = q->type;
 		fileio->b.memory = q->memory;
-		fileio->b.index = index;
 		ret = vb2_internal_dqbuf(q, &fileio->b, nonblock);
 		dprintk(5, "file io: vb2_dqbuf result: %d\n", ret);
 		if (ret)
@@ -2526,15 +2525,6 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		 * Switch to the next buffer
 		 */
 		fileio->index = (index + 1) % q->num_buffers;
-
-		/*
-		 * Start streaming if required.
-		 */
-		if (!read && !q->streaming) {
-			ret = vb2_internal_streamon(q, q->type);
-			if (ret)
-				return ret;
-		}
 	}
 
 	/*
-- 
1.8.4.3

