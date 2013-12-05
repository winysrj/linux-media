Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1881 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284Ab3LEIWe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Dec 2013 03:22:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	laurent.pinchart@ideasonboard.com, awalls@md.metrocast.net,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 05/10] vb2: don't set index, don't start streaming for write()
Date: Thu,  5 Dec 2013 09:21:44 +0100
Message-Id: <1386231709-14262-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1386231709-14262-1-git-send-email-hverkuil@xs4all.nl>
References: <1386231709-14262-1-git-send-email-hverkuil@xs4all.nl>
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
index 1e7da46..f415fd7 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2402,7 +2402,6 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		memset(&fileio->b, 0, sizeof(fileio->b));
 		fileio->b.type = q->type;
 		fileio->b.memory = q->memory;
-		fileio->b.index = index;
 		ret = vb2_internal_dqbuf(q, &fileio->b, nonblock);
 		dprintk(5, "file io: vb2_dqbuf result: %d\n", ret);
 		if (ret)
@@ -2484,15 +2483,6 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
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

