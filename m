Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:57615 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936121AbdKPVyy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 16:54:54 -0500
Date: Thu, 16 Nov 2017 21:54:51 +0000
From: Sean Young <sean@mess.org>
To: Matthias Reichl <hias@horus.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: rc: double keypresses due to timeout expiring to early
Message-ID: <20171116215451.min7sqdo7itiyyif@gofer.mess.org>
References: <20171116152700.filid3ask3gowegl@camel2.lan>
 <20171116163920.ouxinvde5ai4fle3@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171116163920.ouxinvde5ai4fle3@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit d57ea877af38 ("media: rc: per-protocol repeat period"),
double keypresses are reported on the ite-cir driver. This is due
two factors: that commit reduced the timeout used for some protocols
(it became protocol dependant) and the high default IR timeout used
by the ite-cir driver.

Some of the IR decoders wait for a trailing space, as that is
the only way to know if the bit stream has ended (e.g. rc-6 can be
16, 20 or 32 bits). The longer the IR timeout, the longer it will take
to receive the trailing space, delaying decoding and pushing it past the
keyup timeout.

So, add the IR timeout to the keyup timeout.

Cc: <stable@vger.kernel.org> # 4.14
Reported-by: Matthias Reichl <hias@horus.com>
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 17950e29d4e3..fae721534517 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -672,7 +672,8 @@ void rc_repeat(struct rc_dev *dev)
 	input_event(dev->input_dev, EV_MSC, MSC_SCAN, dev->last_scancode);
 	input_sync(dev->input_dev);
 
-	dev->keyup_jiffies = jiffies + msecs_to_jiffies(timeout);
+	dev->keyup_jiffies = jiffies + msecs_to_jiffies(timeout) +
+					nsecs_to_jiffies(dev->timeout);
 	mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
 
 out:
@@ -744,7 +745,8 @@ void rc_keydown(struct rc_dev *dev, enum rc_proto protocol, u32 scancode,
 
 	if (dev->keypressed) {
 		dev->keyup_jiffies = jiffies +
-			msecs_to_jiffies(protocols[protocol].repeat_period);
+			msecs_to_jiffies(protocols[protocol].repeat_period) +
+			nsecs_to_jiffies(dev->timeout);
 		mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
 	}
 	spin_unlock_irqrestore(&dev->keylock, flags);
-- 
2.14.3
