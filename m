Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:54335 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727829AbeK1Tin (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Nov 2018 14:38:43 -0500
From: hverkuil-cisco@xs4all.nl
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH for v4.20 4/5] vb2: don't unbind/put the object when going to state QUEUED
Date: Wed, 28 Nov 2018 09:37:46 +0100
Message-Id: <20181128083747.18530-5-hverkuil-cisco@xs4all.nl>
In-Reply-To: <20181128083747.18530-1-hverkuil-cisco@xs4all.nl>
References: <20181128083747.18530-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

When a buffer is returned to state QUEUED (that happens when
start_streaming fails), then do not unbind and put the object
from the request. Nothing has changed yet, so just keep it as
is.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 86a12b335aac..70e8c3366f9c 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -948,7 +948,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	}
 	atomic_dec(&q->owned_by_drv_count);
 
-	if (vb->req_obj.req) {
+	if (state != VB2_BUF_STATE_QUEUED && vb->req_obj.req) {
 		/* This is not supported at the moment */
 		WARN_ON(state == VB2_BUF_STATE_REQUEUEING);
 		media_request_object_unbind(&vb->req_obj);
-- 
2.19.1
