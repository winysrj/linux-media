Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:33458 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752828AbeFDLrG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Jun 2018 07:47:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv15 26/35] videobuf2-v4l2: refuse qbuf if queue uses requests
Date: Mon,  4 Jun 2018 13:46:39 +0200
Message-Id: <20180604114648.26159-27-hverkuil@xs4all.nl>
In-Reply-To: <20180604114648.26159-1-hverkuil@xs4all.nl>
References: <20180604114648.26159-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Check if the vb2 queue uses requests, and if so refuse to
add buffers that are not part of a request.

We might relax this in the future, but for now just return
-EBUSY in that case.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/videobuf2/videobuf2-v4l2.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 499b2ab3d1fa..05004b26a705 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -378,8 +378,13 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct media_device *md
 			return ret;
 	}
 
-	if (!(b->flags & V4L2_BUF_FLAG_REQUEST_FD))
+	if (!(b->flags & V4L2_BUF_FLAG_REQUEST_FD)) {
+		if (q->uses_requests) {
+			dprintk(1, "%s: queue uses requests\n", opname);
+			return -EBUSY;
+		}
 		return 0;
+	}
 
 	/*
 	 * For proper locking when queueing a request you need to be able
-- 
2.17.0
