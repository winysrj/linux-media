Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:28374 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752698AbeEUIzV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 04:55:21 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH v14 25/36] videobuf2-core: Make request state an enum
Date: Mon, 21 May 2018 11:54:50 +0300
Message-Id: <20180521085501.16861-26-sakari.ailus@linux.intel.com>
In-Reply-To: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
References: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Grab the request spinlock to access media request state

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 4064fa15bc409..4eebbed67c657 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -1784,6 +1784,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	 */
 	for (i = 0; i < q->num_buffers; ++i) {
 		struct vb2_buffer *vb = q->bufs[i];
+		struct media_request *req = vb->req_obj.req;
 
 		/*
 		 * If a request is associated with this buffer, then
@@ -1791,10 +1792,17 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 		 * related request objects. Otherwise those objects would
 		 * never complete.
 		 */
-		if (vb->req_obj.req &&
-		    atomic_read(&vb->req_obj.req->state) ==
-						MEDIA_REQUEST_STATE_QUEUED)
-			call_void_vb_qop(vb, buf_request_complete, vb);
+		if (req) {
+			enum media_request_state state;
+			unsigned long flags;
+
+			spin_lock_irqsave(&req->lock, flags);
+			state = req->state;
+			spin_unlock_irqrestore(&req->lock, flags);
+
+			if (state == MEDIA_REQUEST_STATE_QUEUED)
+				call_void_vb_qop(vb, buf_request_complete, vb);
+		}
 
 		if (vb->state == VB2_BUF_STATE_PREPARED ||
 		    vb->state == VB2_BUF_STATE_QUEUED) {
-- 
2.11.0
