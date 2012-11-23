Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:51681 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab2KWMMq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 07:12:46 -0500
Received: by mail-gh0-f174.google.com with SMTP id g15so1029991ghb.19
        for <linux-media@vger.kernel.org>; Fri, 23 Nov 2012 04:12:45 -0800 (PST)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-media@vger.kernel.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH] stk1160: Replace BUG_ON with WARN_ON
Date: Fri, 23 Nov 2012 09:12:35 -0300
Message-Id: <1353672755-4694-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This situation is not even an error condition so it's stupid to BUG_ON.
Learn the lesson:
http://permalink.gmane.org/gmane.linux.kernel/1347333

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/usb/stk1160/stk1160-video.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-video.c b/drivers/media/usb/stk1160/stk1160-video.c
index f8dcf6d..07186c7 100644
--- a/drivers/media/usb/stk1160/stk1160-video.c
+++ b/drivers/media/usb/stk1160/stk1160-video.c
@@ -78,7 +78,7 @@ struct stk1160_buffer *stk1160_next_buffer(struct stk1160 *dev)
 	unsigned long flags = 0;
 
 	/* Current buffer must be NULL when this functions gets called */
-	BUG_ON(dev->urb_ctl.buf);
+	WARN_ON(dev->urb_ctl.buf);
 
 	spin_lock_irqsave(&dev->buf_lock, flags);
 	if (!list_empty(&dev->avail_bufs)) {
-- 
1.7.8.6

