Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:40755 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbbCJOkA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2015 10:40:00 -0400
Received: by wivr20 with SMTP id r20so30769359wiv.5
        for <linux-media@vger.kernel.org>; Tue, 10 Mar 2015 07:39:59 -0700 (PDT)
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	stable@vger.kernel.org
Subject: [PATCH] stk1160: Make sure current buffer is released
Date: Tue, 10 Mar 2015 11:37:14 -0300
Message-Id: <1425998234-2692-1-git-send-email-ezequiel@vanguardiasur.com.ar>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The available (i.e. not used) buffers are returned by stk1160_clear_queue(),
on the stop_streaming() path. However, this is insufficient and the current
buffer must be released as well. Fix it.

Cc: stable@vger.kernel.org
Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
---
 drivers/media/usb/stk1160/stk1160-v4l.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 2330543..f6d0334 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -244,6 +244,11 @@ static int stk1160_stop_streaming(struct stk1160 *dev)
 	if (mutex_lock_interruptible(&dev->v4l_lock))
 		return -ERESTARTSYS;
 
+	/*
+	 * Once URBs are cancelled, the URB complete handler
+	 * won't be running. This is required to safely release the
+	 * current buffer (dev->isoc_ctl.buf).
+	 */
 	stk1160_cancel_isoc(dev);
 
 	/*
@@ -624,8 +629,16 @@ void stk1160_clear_queue(struct stk1160 *dev)
 		stk1160_info("buffer [%p/%d] aborted\n",
 				buf, buf->vb.v4l2_buf.index);
 	}
-	/* It's important to clear current buffer */
-	dev->isoc_ctl.buf = NULL;
+
+	/* It's important to release the current buffer */
+	if (dev->isoc_ctl.buf) {
+		buf = dev->isoc_ctl.buf;
+		dev->isoc_ctl.buf = NULL;
+
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		stk1160_info("buffer [%p/%d] aborted\n",
+				buf, buf->vb.v4l2_buf.index);
+	}
 	spin_unlock_irqrestore(&dev->buf_lock, flags);
 }
 
-- 
2.3.0

