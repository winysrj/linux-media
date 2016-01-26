Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay-b32.telenor.se ([213.150.131.21]:55751 "EHLO
	smtprelay-b32.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135AbcAZHm0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 02:42:26 -0500
Received: from ipb2.telenor.se (ipb2.telenor.se [195.54.127.165])
	by smtprelay-b32.telenor.se (Postfix) with ESMTP id 0564485D22
	for <linux-media@vger.kernel.org>; Tue, 26 Jan 2016 08:11:48 +0100 (CET)
From: Alec Leamas <leamas.alec@gmail.com>
To: mchehab@osg.samsung.com
Cc: david@hardeman.nu, austin.lund@gmail.com,
	linux-media@vger.kernel.org, Alec Leamas <leamas.alec@gmail.com>
Subject: [PATCH] Revert "[media] media/rc: Send sync space information on lirc device"
Date: Tue, 26 Jan 2016 08:11:06 +0100
Message-Id: <1453792266-1542-1-git-send-email-leamas.alec@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit a8f29e89f2b54fbf2c52be341f149bc195b63a8b. This
commit handled drivers failing to issue a spac which causes sequences
of mark-mark-space instead of the expected space-mark-space-mark...

The fix added an extra space for each and every timeout which fixes
the problem for the failing drivers. However, for existing working
drivers it  the added space causes mark-space-space sequences in the
output which break userspace rightfully expecting
space-mark-space-mark...

Thus, the fix is broken and reverted. The fix is discussed in
https://bugzilla.redhat.com/show_bug.cgi?id=1260862. In particular,
the original committer Austin Lund agrees.

Signed-off-by: Alec Leamas <leamas.alec@gmail.com>
---
 drivers/media/rc/ir-lirc-codec.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 5effc65..8984b33 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -39,17 +39,11 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		return -EINVAL;
 
 	/* Packet start */
-	if (ev.reset) {
-		/* Userspace expects a long space event before the start of
-		 * the signal to use as a sync.  This may be done with repeat
-		 * packets and normal samples.  But if a reset has been sent
-		 * then we assume that a long time has passed, so we send a
-		 * space with the maximum time value. */
-		sample = LIRC_SPACE(LIRC_VALUE_MASK);
-		IR_dprintk(2, "delivering reset sync space to lirc_dev\n");
+	if (ev.reset)
+		return 0;
 
 	/* Carrier reports */
-	} else if (ev.carrier_report) {
+	if (ev.carrier_report) {
 		sample = LIRC_FREQUENCY(ev.carrier);
 		IR_dprintk(2, "carrier report (freq: %d)\n", sample);
 
-- 
2.4.3

