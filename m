Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:47957 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753487AbeCFPMG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Mar 2018 10:12:06 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH] media: rc: oops in ir_timer_keyup after device unplug
Date: Tue,  6 Mar 2018 15:12:04 +0000
Message-Id: <20180306151204.851-2-sean@mess.org>
In-Reply-To: <20180306151204.851-1-sean@mess.org>
References: <20180306151204.851-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If there is IR in the raw kfifo when ir_raw_event_unregister() is called,
then kthread_stop() causes ir_raw_event_thread to be scheduled, decode
some scancodes and re-arm timer_keyup. The timer_keyup then fires when
the rc device is long gone.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 4a952108ba1e..8621761a680f 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1932,12 +1932,12 @@ void rc_unregister_device(struct rc_dev *dev)
 	if (!dev)
 		return;
 
-	del_timer_sync(&dev->timer_keyup);
-	del_timer_sync(&dev->timer_repeat);
-
 	if (dev->driver_type == RC_DRIVER_IR_RAW)
 		ir_raw_event_unregister(dev);
 
+	del_timer_sync(&dev->timer_keyup);
+	del_timer_sync(&dev->timer_repeat);
+
 	rc_free_rx_device(dev);
 
 	mutex_lock(&dev->lock);
-- 
2.14.3
