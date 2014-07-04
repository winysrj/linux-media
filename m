Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39572 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbaGDRPz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jul 2014 13:15:55 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [[PATCH v2] 14/14] dib8000: improve the message that reports per-layer locks
Date: Fri,  4 Jul 2014 14:15:40 -0300
Message-Id: <1404494140-17777-15-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1404494140-17777-1-git-send-email-m.chehab@samsung.com>
References: <1404494140-17777-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The message is currently highly encoded:
	[70299.863521] DiB8000: Mpeg locks [ L0 : 0 | L1 : 1 | L2 : 0 ]

And doesn't properly reflect that some problems might have happened.
Instead, display it as:
	[75160.822321] DiB8000: Not all ISDB-T layers locked in 32 ms: Layer A NOT LOCKED, Layer B locked, Layer C not enabled

In order to properly reflect what's happening.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 8f0ac5c16e26..72a9227a6ba5 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -3263,7 +3263,10 @@ static int dib8000_tune(struct dvb_frontend *fe)
 	case CT_DEMOD_STEP_10: /* 40 */
 		locks = dib8000_read_lock(fe);
 		if (locks&(1<<(7-state->longest_intlv_layer))) { /* mpeg lock : check the longest one */
-			dprintk("Mpeg locks [ L0 : %d | L1 : %d | L2 : %d ]", (locks>>7)&0x1, (locks>>6)&0x1, (locks>>5)&0x1);
+			dprintk("ISDB-T layer locks: Layer A %s, Layer B %s, Layer C %s",
+				c->layer[0].segment_count ? (locks >> 7) & 0x1 ? "locked" : "NOT LOCKED" : "not enabled",
+				c->layer[1].segment_count ? (locks >> 6) & 0x1 ? "locked" : "NOT LOCKED" : "not enabled",
+				c->layer[2].segment_count ? (locks >> 5) & 0x1 ? "locked" : "NOT LOCKED" : "not enabled");
 			if (c->isdbt_sb_mode
 			    && c->isdbt_sb_subchannel < 14
 			    && !state->differential_constellation)
@@ -3279,8 +3282,13 @@ static int dib8000_tune(struct dvb_frontend *fe)
 				state->subchannel += 3;
 				*tune_state = CT_DEMOD_STEP_11;
 			} else { /* we are done mpeg of the longest interleaver xas not locking but let's try if an other layer has locked in the same time */
-				if (locks & (0x7<<5)) {
-					dprintk("Mpeg locks [ L0 : %d | L1 : %d | L2 : %d ]", (locks>>7)&0x1, (locks>>6)&0x1, (locks>>5)&0x1);
+				if (locks & (0x7 << 5)) {
+					dprintk("Not all ISDB-T layers locked in %d ms: Layer A %s, Layer B %s, Layer C %s",
+						jiffies_to_msecs(now - *timeout),
+						c->layer[0].segment_count ? (locks >> 7) & 0x1 ? "locked" : "NOT LOCKED" : "not enabled",
+						c->layer[1].segment_count ? (locks >> 6) & 0x1 ? "locked" : "NOT LOCKED" : "not enabled",
+						c->layer[2].segment_count ? (locks >> 5) & 0x1 ? "locked" : "NOT LOCKED" : "not enabled");
+
 					state->status = FE_STATUS_DATA_LOCKED;
 				} else
 					state->status = FE_STATUS_TUNE_FAILED;
-- 
1.9.3

