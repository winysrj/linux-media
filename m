Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:59429 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbaGXKkp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jul 2014 06:40:45 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so2504331wgg.0
        for <linux-media@vger.kernel.org>; Thu, 24 Jul 2014 03:40:44 -0700 (PDT)
From: Austin Lund <austin.lund@gmail.com>
To: m.chehab@samsung.com
Cc: Austin Lund <austin.lund@gmail.com>, linux-media@vger.kernel.org
Subject: [PATCH] media/rc: Send sync space information on the lirc device.
Date: Thu, 24 Jul 2014 11:40:20 +0100
Message-Id: <1406198420-22475-1-git-send-email-austin.lund@gmail.com>
In-Reply-To: <20140723195718.14648780.m.chehab@samsung.com>
References: <20140723195718.14648780.m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Userspace expects to see a long space before the first pulse is sent on
the lirc device.  Currently, if a long time has passed and a new packet
is started, the lirc codec just returns and doesn't send anything.  This
makes lircd ignore many perfectly valid signals unless they are sent in
quick sucession.  When a reset event is delivered, we cannot know
anything about the duration of the space.  But it should be safe to
assume it has been a long time and we just set the duration to maximum.

Signed-off-by: Austin Lund <austin.lund@gmail.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/rc/ir-lirc-codec.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index d731da6..2af2326 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -42,11 +42,17 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		return -EINVAL;
 
 	/* Packet start */
-	if (ev.reset)
-		return 0;
+	if (ev.reset) {
+		/* Userspace expects a long space event before the start of
+		 * the signal to use as a sync.  This may be done with repeat
+		 * packets and normal samples.  But if a reset has been sent
+		 * then we assume that a long time has passed, so we send a
+		 * space with the maximum time value. */
+		sample = LIRC_SPACE(LIRC_VALUE_MASK);
+		IR_dprintk(2, "delivering reset sync space to lirc_dev\n");
 
 	/* Carrier reports */
-	if (ev.carrier_report) {
+	} else if (ev.carrier_report) {
 		sample = LIRC_FREQUENCY(ev.carrier);
 		IR_dprintk(2, "carrier report (freq: %d)\n", sample);
 
-- 
2.0.2

