Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:41780 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754048AbeGEQDp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Jul 2018 12:03:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv16 27/34] videobuf2-v4l2: refuse qbuf if queue uses requests or vv.
Date: Thu,  5 Jul 2018 18:03:30 +0200
Message-Id: <20180705160337.54379-28-hverkuil@xs4all.nl>
In-Reply-To: <20180705160337.54379-1-hverkuil@xs4all.nl>
References: <20180705160337.54379-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Check if the vb2 queue uses requests, and if so refuse to
add buffers that are not part of a request. Also check for
the reverse: a vb2 queue did not use requests, and an attempt
was made to queue a buffer to a request.

We might relax this in the future, but for now just return
-EPERM in that case.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/videobuf2/videobuf2-v4l2.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 0b07c349eb20..ee537831f756 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -378,8 +378,16 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct media_device *md
 			return ret;
 	}
 
-	if (!(b->flags & V4L2_BUF_FLAG_REQUEST_FD))
+	if (!(b->flags & V4L2_BUF_FLAG_REQUEST_FD)) {
+		if (q->uses_requests) {
+			dprintk(1, "%s: queue uses requests\n", opname);
+			return -EPERM;
+		}
 		return 0;
+	} else if (q->uses_qbuf) {
+		dprintk(1, "%s: queue does not use requests\n", opname);
+		return -EPERM;
+	}
 
 	/*
 	 * For proper locking when queueing a request you need to be able
-- 
2.18.0
