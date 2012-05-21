Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:40688 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab2EUVtG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 May 2012 17:49:06 -0400
Received: by qabj40 with SMTP id j40so3003846qab.1
        for <linux-media@vger.kernel.org>; Mon, 21 May 2012 14:49:06 -0700 (PDT)
From: Michael Krufky <mkrufky@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH] DVB: improve handling of TS packets containing a raised TEI bit
Date: Mon, 21 May 2012 17:47:15 -0400
Message-Id: <1337636835-6580-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the TEI bit is raised, we should not trust any of the contents of
the packet in question, including but not limited to its PID number.

Considering that we don't trust the PID number of this packet, we should
not proceed to check the packet counter (if dvb_demux_tscheck is set).

We should expect to see at least one discontinuity after a bad packet is
received, so any time a TEI is detected, a following TS packet counter
mismatch is to be expected.

There is no real reason to ever allow bad packets to pass through the
kernel demux, other than for purposes of attempting error correction via
software or statistical information.

However, since we have always passed these bad packets though the demux,
we should not change this default behavior.

Without altering module options, this patch merely prevents the
TS packet counter check on packets containing a raised TEI.

If module option dvb_demux_feed_err_pkts is set to 0, the kernel demux
will drop these error packets entirely, preventing any possibility of
corruption caused by userspace programs that are expecting valid data.

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 drivers/media/dvb/dvb-core/dvb_demux.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_demux.c b/drivers/media/dvb/dvb-core/dvb_demux.c
index d82469f..17cb81f 100644
--- a/drivers/media/dvb/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb/dvb-core/dvb_demux.c
@@ -50,6 +50,11 @@ module_param(dvb_demux_speedcheck, int, 0644);
 MODULE_PARM_DESC(dvb_demux_speedcheck,
 		"enable transport stream speed check");
 
+static int dvb_demux_feed_err_pkts = 1;
+module_param(dvb_demux_feed_err_pkts, int, 0644);
+MODULE_PARM_DESC(dvb_demux_feed_err_pkts,
+		 "when set to 0, drop packets with the TEI bit set (1 by default)");
+
 #define dprintk_tscheck(x...) do {                              \
 		if (dvb_demux_tscheck && printk_ratelimit())    \
 			printk(x);                              \
@@ -426,14 +431,18 @@ static void dvb_dmx_swfilter_packet(struct dvb_demux *demux, const u8 *buf)
 		};
 	};
 
+	if (buf[1] & 0x80) {
+		dprintk_tscheck("TEI detected. "
+				"PID=0x%x data1=0x%x\n",
+				pid, buf[1]);
+		/* data in this packet cant be trusted - drop it unless
+		 * module option dvb_demux_feed_err_pkts is set */
+		if (!dvb_demux_feed_err_pkts)
+			return;
+	} else /* if TEI bit is set, pid may be wrong- skip pkt counter */
 	if (demux->cnt_storage && dvb_demux_tscheck) {
 		/* check pkt counter */
 		if (pid < MAX_PID) {
-			if (buf[1] & 0x80)
-				dprintk_tscheck("TEI detected. "
-						"PID=0x%x data1=0x%x\n",
-						pid, buf[1]);
-
 			if ((buf[3] & 0xf) != demux->cnt_storage[pid])
 				dprintk_tscheck("TS packet counter mismatch. "
 						"PID=0x%x expected 0x%x "
-- 
1.7.9.5

