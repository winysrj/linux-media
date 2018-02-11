Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:43389 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752286AbeBKRqL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Feb 2018 12:46:11 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] media: rc: unnecessary call to do_div
Date: Sun, 11 Feb 2018 17:46:10 +0000
Message-Id: <20180211174610.22612-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No need to call do_div() when the remainder is thrown away.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/lirc_dev.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 6ef5b24eb1d8..aca404d32de8 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -86,14 +86,12 @@ void ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
 							 dev->gap_start));
 
 			/* Convert to ms and cap by LIRC_VALUE_MASK */
-			do_div(dev->gap_duration, 1000);
-			dev->gap_duration = min_t(u64, dev->gap_duration,
-						  LIRC_VALUE_MASK);
+			sample = min_t(u64, dev->gap_duration / 1000,
+				       LIRC_VALUE_MASK);
 
 			spin_lock_irqsave(&dev->lirc_fh_lock, flags);
 			list_for_each_entry(fh, &dev->lirc_fh, list)
-				kfifo_put(&fh->rawir,
-					  LIRC_SPACE(dev->gap_duration));
+				kfifo_put(&fh->rawir, LIRC_SPACE(sample));
 			spin_unlock_irqrestore(&dev->lirc_fh_lock, flags);
 			dev->gap = false;
 		}
-- 
2.14.3
