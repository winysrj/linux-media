Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:63377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756833Ab1FPT05 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 15:26:57 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH] [media] rc: fix ghost keypresses with certain hw
Date: Thu, 16 Jun 2011 15:26:52 -0400
Message-Id: <1308252412-13595-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

With hardware that has to use ir_raw_event_store_edge to collect IR
sample durations, we were not doing an event reset unless
IR_MAX_DURATION had passed. That's around 4 seconds. So if someone
presses up, then down, with less than 4 seconds in between, they'd get
the initial up, then up and down upon pressing down.

To fix this, I've lowered the "send a reset event" logic's threshold to
the input device's REP_DELAY (defaults to 500ms), and with an
saa7134-based GPIO-driven IR receiver in a Hauppauge HVR-1150, I get
*much* better behavior out of the remote now. Special thanks to Devin
for providing the hardware to investigate this issue.

CC: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/ir-raw.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index f4efd2f..27808bb 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -114,18 +114,20 @@ int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type)
 	s64			delta; /* ns */
 	DEFINE_IR_RAW_EVENT(ev);
 	int			rc = 0;
+	int			delay;
 
 	if (!dev->raw)
 		return -EINVAL;
 
 	now = ktime_get();
 	delta = ktime_to_ns(ktime_sub(now, dev->raw->last_event));
+	delay = MS_TO_NS(dev->input_dev->rep[REP_DELAY]);
 
 	/* Check for a long duration since last event or if we're
 	 * being called for the first time, note that delta can't
 	 * possibly be negative.
 	 */
-	if (delta > IR_MAX_DURATION || !dev->raw->last_type)
+	if (delta > delay || !dev->raw->last_type)
 		type |= IR_START_EVENT;
 	else
 		ev.duration = delta;
-- 
1.7.1

