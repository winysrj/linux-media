Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:34575 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbaLPLgx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Dec 2014 06:36:53 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NGO00HEIAXGGH40@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 16 Dec 2014 20:36:52 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, k.debski@samsung.com, hverkuil@xs4all.nl,
	nicolas.dufresne@collabora.com
Subject: [PATCH 2/2] s5p-mfc: use VB2_FILEIO_ALLOW_ZERO_BYTESUSED flag
Date: Tue, 16 Dec 2014 12:36:18 +0100
Message-id: <1418729778-14480-2-git-send-email-k.debski@samsung.com>
In-reply-to: <1418729778-14480-1-git-send-email-k.debski@samsung.com>
References: <1418729778-14480-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The MFC driver interprets a buffer with bytesused equal to 0 as a special
case indicating end-of-stream. After vb2: fix bytesused == 0 handling
(8a75ffb) patch videobuf2 modified the value of bytesused if it was 0.
The VB2_FILEIO_ALLOW_ZERO_BYTESUSED flag was added to videobuf2 to keep
backward compatibility.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 03204fd..89c148b 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -820,6 +820,13 @@ static int s5p_mfc_open(struct file *file)
 		ret = -ENOENT;
 		goto err_queue_init;
 	}
+	/* One of means to indicate end-of-stream for MFC is to set the
+	 * bytesused == 0. However by default videobuf2 handles videobuf
+	 * equal to 0 as a special case and changes its value to the size
+	 * of the buffer. Set the VB2_FILEIO_ALLOW_ZERO_BYTESUSED flag so
+	 * that videobuf2 will keep the value of bytesused intact.
+	 */
+	q->io_flags = VB2_FILEIO_ALLOW_ZERO_BYTESUSED;
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	ret = vb2_queue_init(q);
@@ -842,6 +849,10 @@ static int s5p_mfc_open(struct file *file)
 		ret = -ENOENT;
 		goto err_queue_init;
 	}
+	/* Set the VB2_FILEIO_ALLOW_ZERO_BYTESUSED flag, for more information
+	 * please see the comment above.
+	 */
+	q->io_flags = VB2_FILEIO_ALLOW_ZERO_BYTESUSED;
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	ret = vb2_queue_init(q);
-- 
1.7.9.5

