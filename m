Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:23209 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaLSKgt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 05:36:49 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NGT00BW5S5B8410@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 19 Dec 2014 19:36:47 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, k.debski@samsung.com, hverkuil@xs4all.nl,
	nicolas.dufresne@collabora.com, p.zabel@pengutronix.de
Subject: [PATCH] coda: use VB2_FILEIO_ALLOW_ZERO_BYTESUSED flag
Date: Fri, 19 Dec 2014 11:36:27 +0100
Message-id: <1418985387-16580-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The coda driver interprets a buffer with bytesused equal to 0 as a special
case indicating end-of-stream. After vb2: fix bytesused == 0 handling
(8a75ffb) patch videobuf2 modified the value of bytesused if it was 0.
The VB2_FILEIO_ALLOW_ZERO_BYTESUSED flag was added to videobuf2 to keep
backward compatibility.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/platform/coda/coda-common.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 42b4630..6c67e6d 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1491,6 +1491,13 @@ static int coda_queue_init(struct coda_ctx *ctx, struct vb2_queue *vq)
 	vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	vq->lock = &ctx->dev->dev_mutex;
+	/* One of means to indicate end-of-stream for coda is to set the
+	 * bytesused == 0. However by default videobuf2 handles videobuf
+	 * equal to 0 as a special case and changes its value to the size
+	 * of the buffer. Set the VB2_FILEIO_ALLOW_ZERO_BYTESUSED flag, so
+	 * that videobuf2 will keep the value of bytesused intact.
+	 */
+	vq->io_flags = VB2_FILEIO_ALLOW_ZERO_BYTESUSED;
 
 	return vb2_queue_init(vq);
 }
-- 
1.7.9.5

