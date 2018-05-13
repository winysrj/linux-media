Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:41003 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751263AbeEMMQF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 May 2018 08:16:05 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] media: rc: default to idle on at startup or after reset
Date: Sun, 13 May 2018 13:16:04 +0100
Message-Id: <20180513121604.7411-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Any spaces events received after a reset or startup should be discarded,
so ensure the rc device is in idle mode.

This also makes it much easier to detect incorrect raw events, as we will
do in a following commit.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-ir-raw.c | 1 +
 include/media/rc-core.h      | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 2ab8a2b7092a..2e50104ae138 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -611,6 +611,7 @@ int ir_raw_event_prepare(struct rc_dev *dev)
 
 	dev->raw->dev = dev;
 	dev->change_protocol = change_protocol;
+	dev->idle = true;
 	spin_lock_init(&dev->raw->edge_spinlock);
 	timer_setup(&dev->raw->edge_handle, ir_raw_edge_handle, 0);
 	INIT_KFIFO(dev->raw->kfifo);
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 6742fd86ff65..61571773a98d 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -347,6 +347,7 @@ static inline void ir_raw_event_reset(struct rc_dev *dev)
 	struct ir_raw_event ev = { .reset = true };
 
 	ir_raw_event_store(dev, &ev);
+	dev->idle = true;
 	ir_raw_event_handle(dev);
 }
 
-- 
2.17.0
