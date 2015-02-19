Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:54949 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbbBSKLi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 05:11:38 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NK0002K1KBD3U50@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 19 Feb 2015 19:11:37 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, k.debski@samsung.com, hverkuil@xs4all.nl
Subject: [PATCH v3 4/4] s5p-mfc: set allow_zero_bytesused flag for
 vb2_queue_init
Date: Thu, 19 Feb 2015 11:11:20 +0100
Message-id: <1424340680-13817-4-git-send-email-k.debski@samsung.com>
In-reply-to: <1424340680-13817-1-git-send-email-k.debski@samsung.com>
References: <1424340680-13817-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The s5p-mfc driver interprets a buffer with bytesused equal to 0 as a
special case indicating end-of-stream. After vb2: fix bytesused == 0
handling (8a75ffb) patch videobuf2 modified the value of bytesused if it
was 0. The allow_zero_bytesused flag was added to videobuf2 to keep
backward compatibility.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 8e44a59..6b08488 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -843,6 +843,13 @@ static int s5p_mfc_open(struct file *file)
 		ret = -ENOENT;
 		goto err_queue_init;
 	}
+	/* One of means to indicate end-of-stream for MFC is to set the
+	 * bytesused == 0. However by default videobuf2 handles videobuf
+	 * equal to 0 as a special case and changes its value to the size
+	 * of the buffer. Set the allow_zero_bytesused flag so that videobuf2
+	 * will keep the value of bytesused intact.
+	 */
+	q->allow_zero_bytesused = 1;
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	ret = vb2_queue_init(q);
-- 
1.7.9.5

