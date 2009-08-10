Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:21263 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932338AbZHJRh4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2009 13:37:56 -0400
From: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] V4L: videobuf-core.c VIDIOC_QBUF should return video buffer flags
Date: Mon, 10 Aug 2009 20:37:40 +0300
Cc: sailus@maxwell.research.nokia.com,
	"Zutshi Vimarsh (Nokia-D/Helsinki)" <vimarsh.zutshi@nokia.com>,
	Lasse.Laukkanen@digia.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908102037.40140.tuukka.o.toivonen@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When user space queues a buffer using VIDIOC_QBUF, the kernel
should set flags to V4L2_BUF_FLAG_QUEUED in struct v4l2_buffer.
videobuf_qbuf() was missing a call to videobuf_status() which does
that. This patch adds the proper function call.

Signed-off-by: Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
---
 drivers/media/video/videobuf-core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index b7b0584..d212710 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -565,6 +565,8 @@ int videobuf_qbuf(struct videobuf_queue *q,
 		spin_unlock_irqrestore(q->irqlock, flags);
 	}
 	dprintk(1, "qbuf: succeded\n");
+	memset(b, 0, sizeof(*b));
+	videobuf_status(q, b, buf, q->type);
 	retval = 0;
 	wake_up_interruptible_sync(&q->wait);
 
-- 
1.5.4.3

