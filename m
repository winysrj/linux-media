Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60835 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab2D1N5Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Apr 2012 09:57:25 -0400
Received: by ghrr11 with SMTP id r11so923311ghr.19
        for <linux-media@vger.kernel.org>; Sat, 28 Apr 2012 06:57:25 -0700 (PDT)
From: elezegarcia@gmail.com
To: mchehab@infradead.org
Cc: crope@iki.fi, gennarone@gmail.com, linux-media@vger.kernel.org,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH] em28xx: Remove unused list_head struct for queued buffers
Date: Sat, 28 Apr 2012 10:57:02 -0300
Message-Id: <4f9bf744.a54dec0a.47ed.ffff85cc@mx.google.com>
In-Reply-To: <1335621422-4083-1-git-send-email-y>
References: <1335621422-4083-1-git-send-email-y>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ezequiel Garcia <elezegarcia@gmail.com>

The list_head struct usage was fully removed by commit
d7aa80207babe694b316a48200b096cf0336ecb3.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/em28xx/em28xx-cards.c |    2 --
 drivers/media/video/em28xx/em28xx.h       |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 5c0fd9f..eea90b0 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -3142,9 +3142,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 
 	/* init video dma queues */
 	INIT_LIST_HEAD(&dev->vidq.active);
-	INIT_LIST_HEAD(&dev->vidq.queued);
 	INIT_LIST_HEAD(&dev->vbiq.active);
-	INIT_LIST_HEAD(&dev->vbiq.queued);
 
 	if (dev->board.has_msp34xx) {
 		/* Send a reset to other chips via gpio */
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index 100d1e8..87766f1 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -269,7 +269,6 @@ struct em28xx_buffer {
 
 struct em28xx_dmaqueue {
 	struct list_head       active;
-	struct list_head       queued;
 
 	wait_queue_head_t          wq;
 
-- 
1.7.3.4

