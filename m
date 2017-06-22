Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:52767 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752743AbdFVTYD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Jun 2017 15:24:03 -0400
Subject: [PATCH 2/2] rc-main: remove input events for repeat messages
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Thu, 22 Jun 2017 21:24:00 +0200
Message-ID: <149815944000.22167.2535987828056972392.stgit@zeus.hardeman.nu>
In-Reply-To: <149815927618.22167.7035029052539207589.stgit@zeus.hardeman.nu>
References: <149815927618.22167.7035029052539207589.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Protocols like NEC generate around 10 repeat events per second.

The input events are not very useful for userspace but still waste power
by waking up every listener. So let's remove them (MSC_SCAN events
are still generated for the initial keypress).

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-main.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 7387bd4d75b0..9f490aa11bc4 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -616,16 +616,11 @@ void rc_repeat(struct rc_dev *dev)
 
 	spin_lock_irqsave(&dev->keylock, flags);
 
-	if (!dev->keypressed)
-		goto out;
-
-	input_event(dev->input_dev, EV_MSC, MSC_SCAN, dev->last_scancode);
-	input_sync(dev->input_dev);
-
-	dev->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
-	mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
+	if (dev->keypressed) {
+		dev->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
+		mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
+	}
 
-out:
 	spin_unlock_irqrestore(&dev->keylock, flags);
 }
 EXPORT_SYMBOL_GPL(rc_repeat);
