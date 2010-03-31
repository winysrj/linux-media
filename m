Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30210 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056Ab0CaJcq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Mar 2010 05:32:46 -0400
Received: from eu_spt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L0500DZR3UJE4@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 31 Mar 2010 10:32:43 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L0500K0U3UJ13@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 31 Mar 2010 10:32:43 +0100 (BST)
Date: Wed, 31 Mar 2010 11:32:26 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH v2 2/3] v4l: videobuf: Add support for V4L2_BUF_FLAG_ERROR
In-reply-to: <1270027947-28327-1-git-send-email-p.osciak@samsung.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Message-id: <1270027947-28327-3-git-send-email-p.osciak@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1270027947-28327-1-git-send-email-p.osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For recoverable stream errors dqbuf() now returns 0 and the error flag
is set instead of returning EIO.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf-core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index 63d7043..a9cfab6 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -665,6 +665,7 @@ int videobuf_dqbuf(struct videobuf_queue *q,
 {
 	struct videobuf_buffer *buf = NULL;
 	int retval;
+	int err_flag = 0;
 
 	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
 
@@ -679,7 +680,7 @@ int videobuf_dqbuf(struct videobuf_queue *q,
 	switch (buf->state) {
 	case VIDEOBUF_ERROR:
 		dprintk(1, "dqbuf: state is error\n");
-		retval = -EIO;
+		err_flag = V4L2_BUF_FLAG_ERROR;
 		CALL(q, sync, q, buf);
 		buf->state = VIDEOBUF_IDLE;
 		break;
@@ -696,6 +697,7 @@ int videobuf_dqbuf(struct videobuf_queue *q,
 	list_del(&buf->stream);
 	memset(b, 0, sizeof(*b));
 	videobuf_status(q, b, buf, q->type);
+	b->flags |= err_flag;
 done:
 	mutex_unlock(&q->vb_lock);
 	return retval;
-- 
1.7.0.31.g1df487

