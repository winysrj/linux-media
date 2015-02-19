Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:50377 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbbBSKLh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 05:11:37 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NK000CYCKBB0T70@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 19 Feb 2015 19:11:35 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, k.debski@samsung.com, hverkuil@xs4all.nl
Subject: [PATCH v3 3/4] coda: set allow_zero_bytesused flag for vb2_queue_init
Date: Thu, 19 Feb 2015 11:11:19 +0100
Message-id: <1424340680-13817-3-git-send-email-k.debski@samsung.com>
In-reply-to: <1424340680-13817-1-git-send-email-k.debski@samsung.com>
References: <1424340680-13817-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The coda driver interprets a buffer with bytesused equal to 0 as a special
case indicating end-of-stream. After vb2: fix bytesused == 0 handling
(8a75ffb) patch videobuf2 modified the value of bytesused if it was 0.
The allow_zero_bytesused flag was added to videobuf2 to keep
backward compatibility.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/platform/coda/coda-common.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 6f32e6d..2d23f9a 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1541,6 +1541,13 @@ static int coda_queue_init(struct coda_ctx *ctx, struct vb2_queue *vq)
 	vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	vq->lock = &ctx->dev->dev_mutex;
+	/* One of means to indicate end-of-stream for coda is to set the
+	 * bytesused == 0. However by default videobuf2 handles videobuf
+	 * equal to 0 as a special case and changes its value to the size
+	 * of the buffer. Set the allow_zero_bytesused flag, so
+	 * that videobuf2 will keep the value of bytesused intact.
+	 */
+	vq->allow_zero_bytesused = 1;
 
 	return vb2_queue_init(vq);
 }
-- 
1.7.9.5

