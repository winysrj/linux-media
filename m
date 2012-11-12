Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64011 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab2KLIHQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Nov 2012 03:07:16 -0500
Received: by mail-pb0-f46.google.com with SMTP id rr4so4187093pbb.19
        for <linux-media@vger.kernel.org>; Mon, 12 Nov 2012 00:07:16 -0800 (PST)
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Cc: mchehab@redhat.com, patches@linaro.org
Subject: [PATCH] [media] videobuf2-core: print current state of buffer in vb2_buffer_done
Date: Mon, 12 Nov 2012 13:31:29 +0530
Message-Id: <1352707289-9349-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In vb2_buffer_done, it would be better the print the value of 'state'
(current state of buffer) than to print 'vb->state' which is always
VB2_BUF_STATE_ACTIVE.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/media/v4l2-core/videobuf2-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 432df11..91980d13 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -798,7 +798,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 		return;
 
 	dprintk(4, "Done processing on buffer %d, state: %d\n",
-			vb->v4l2_buf.index, vb->state);
+			vb->v4l2_buf.index, state);
 
 	/* Add the buffer to the done buffers list */
 	spin_lock_irqsave(&q->done_lock, flags);
-- 
1.7.4.1

