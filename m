Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55926 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750799AbeBBKJC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Feb 2018 05:09:02 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: hverkuil@xs4all.nl
Subject: [PATCH 1/1] vb2: core: Finish buffers at the end of the stream
Date: Fri,  2 Feb 2018 12:08:59 +0200
Message-Id: <20180202100859.4004-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If buffers were prepared or queued and the buffers were released without
starting the queue, the finish mem op (corresponding to the prepare mem
op) was never called to the buffers.

Before commit a136f59c0a1f there was no need to do this as in such a case
the prepare mem op had not been called yet. Address the problem by
explicitly calling finish mem op when the queue is stopped if the buffer
is in either prepared or queued state.

Fixes: a136f59c0a1f ("[media] vb2: Move buffer cache synchronisation to prepare from queue")
Cc: stable@vger.kernel.org # for v4.13 and up
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Hi Devin,

Could you check whether this will resolve the problem you've found?

Thanks.

 drivers/media/common/videobuf2/videobuf2-core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index f7109f827f6e..52a7c1d0a79a 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -1696,6 +1696,15 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	for (i = 0; i < q->num_buffers; ++i) {
 		struct vb2_buffer *vb = q->bufs[i];
 
+		if (vb->state == VB2_BUF_STATE_PREPARED ||
+		    vb->state == VB2_BUF_STATE_QUEUED) {
+			unsigned int plane;
+
+			for (plane = 0; plane < vb->num_planes; ++plane)
+				call_void_memop(vb, finish,
+						vb->planes[plane].mem_priv);
+		}
+
 		if (vb->state != VB2_BUF_STATE_DEQUEUED) {
 			vb->state = VB2_BUF_STATE_PREPARED;
 			call_void_vb_qop(vb, buf_finish, vb);
-- 
2.11.0
