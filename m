Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44799 "EHLO
        homiemail-a116.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755927AbeEHVU0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 May 2018 17:20:26 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mspieth@digivation.com.au
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 1/5] cx23885: Handle additional bufs on interrupt
Date: Tue,  8 May 2018 16:20:16 -0500
Message-Id: <1525814420-25243-2-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1525814420-25243-1-git-send-email-brad@nextdimension.cc>
References: <1525814420-25243-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Ryzen systems interrupts are occasionally missed:

cx23885: cx23885_wakeup: [ffff99b384b83c00/28] wakeup reg=5406 buf=5405
cx23885: cx23885_wakeup: [ffff99b40bf79400/31] wakeup reg=9537 buf=9536

This patch loops up to five times on wakeup, marking any buffers
found done.

Since the count register is u16, but the vb2 counter is u32, some modulo
arithmetic is used to accommodate wraparound and ensure current active
buffer is the buffer expected.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/pci/cx23885/cx23885-core.c | 37 +++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 019fac4..b279758 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -422,19 +422,30 @@ static void cx23885_wakeup(struct cx23885_tsport *port,
 			   struct cx23885_dmaqueue *q, u32 count)
 {
 	struct cx23885_buffer *buf;
-
-	if (list_empty(&q->active))
-		return;
-	buf = list_entry(q->active.next,
-			 struct cx23885_buffer, queue);
-
-	buf->vb.vb2_buf.timestamp = ktime_get_ns();
-	buf->vb.sequence = q->count++;
-	dprintk(1, "[%p/%d] wakeup reg=%d buf=%d\n", buf,
-		buf->vb.vb2_buf.index,
-		count, q->count);
-	list_del(&buf->queue);
-	vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
+	int count_delta;
+	int max_buf_done = 5; /* service maximum five buffers */
+
+	do {
+		if (list_empty(&q->active))
+			return;
+		buf = list_entry(q->active.next,
+				 struct cx23885_buffer, queue);
+
+		buf->vb.vb2_buf.timestamp = ktime_get_ns();
+		buf->vb.sequence = q->count++;
+		if (count != (q->count % 65536)) {
+			dprintk(1, "[%p/%d] wakeup reg=%d buf=%d\n", buf,
+				buf->vb.vb2_buf.index, count, q->count);
+		} else {
+			dprintk(7, "[%p/%d] wakeup reg=%d buf=%d\n", buf,
+				buf->vb.vb2_buf.index, count, q->count);
+		}
+		list_del(&buf->queue);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
+		max_buf_done--;
+		/* count register is 16 bits so apply modulo appropriately */
+		count_delta = ((int)count - (int)(q->count % 65536));
+	} while ((count_delta > 0) && (max_buf_done > 0));
 }
 
 int cx23885_sram_channel_setup(struct cx23885_dev *dev,
-- 
2.7.4
