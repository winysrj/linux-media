Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16693 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab0CQO36 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 10:29:58 -0400
Received: from eu_spt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KZF00KFIK9VXA@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 17 Mar 2010 14:29:55 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KZF00HPKK9VAP@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 17 Mar 2010 14:29:55 +0000 (GMT)
Date: Wed, 17 Mar 2010 15:29:50 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH 2/2] v4l: videobuf: Add support for V4L2_BUF_FLAG_ERROR
In-reply-to: <1268836190-31051-1-git-send-email-p.osciak@samsung.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Message-id: <1268836190-31051-3-git-send-email-p.osciak@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1268836190-31051-1-git-send-email-p.osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On dqbuf videobuf will now return 0 and an error flag will be set, instead
of returning EIO in case of recoverable streaming errors.
---
 drivers/media/video/videobuf-core.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index e93672a..aa361d3 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -286,8 +286,10 @@ static void videobuf_status(struct videobuf_queue *q, struct v4l2_buffer *b,
 	case VIDEOBUF_ACTIVE:
 		b->flags |= V4L2_BUF_FLAG_QUEUED;
 		break;
-	case VIDEOBUF_DONE:
 	case VIDEOBUF_ERROR:
+		b->flags |= V4L2_BUF_FLAG_ERROR;
+		/* fall through */
+	case VIDEOBUF_DONE:
 		b->flags |= V4L2_BUF_FLAG_DONE;
 		break;
 	case VIDEOBUF_NEEDS_INIT:
@@ -679,7 +681,6 @@ int videobuf_dqbuf(struct videobuf_queue *q,
 	switch (buf->state) {
 	case VIDEOBUF_ERROR:
 		dprintk(1, "dqbuf: state is error\n");
-		retval = -EIO;
 		CALL(q, sync, q, buf);
 		buf->state = VIDEOBUF_IDLE;
 		break;
-- 
1.7.0.31.g1df487

