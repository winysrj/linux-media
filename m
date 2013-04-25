Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759382Ab3DYSgA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 14:36:00 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Patrick Boettcher <pboettcher@kernellabs.com>,
	Olivier Grenie <olivier.grenie@parrot.com>,
	Patrick Boettcher <patrick.boettcher@parrot.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/5] [media] dib8000: Fix sub-channel range
Date: Thu, 25 Apr 2013 15:35:47 -0300
Message-Id: <1366914949-32587-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366914949-32587-1-git-send-email-mchehab@redhat.com>
References: <1366914949-32587-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

isdbt_sb_subchannel is unsigned with 8 bits. So, it will
never be -1. Instead, any value bigger than 13 is invalid.

As is, the current code generates the following warnings:

drivers/media/dvb-frontends/dib8000.c: In function 'dib8000_set_isdbt_common_channel':
drivers/media/dvb-frontends/dib8000.c:2358:3: warning: comparison is always true due to limited range of data type [-Wtype-limits]
drivers/media/dvb-frontends/dib8000.c: In function 'dib8000_tune':
drivers/media/dvb-frontends/dib8000.c:3107:8: warning: comparison is always false due to limited range of data type [-Wtype-limits]
drivers/media/dvb-frontends/dib8000.c:3153:9: warning: comparison is always false due to limited range of data type [-Wtype-limits]
drivers/media/dvb-frontends/dib8000.c:3160:5: warning: comparison is always false

It should also be noticed that ARIB STD-B31, item
"3.15.6.8 Number of segments" at TMCC table defines the
value 15 for unused segment, and 14 as reserved.

So, better to change the check to consider any value
bigger than 13 to mean that sub-channels should be
disabled, fixing the warning and doing the right thing
even if an invalid value is filled by userspace.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/dib8000.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 77dac46..57863d3 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -2355,7 +2355,7 @@ static void dib8000_set_isdbt_common_channel(struct dib8000_state *state, u8 seq
 	/* TSB or ISDBT ? apply it now */
 	if (c->isdbt_sb_mode) {
 		dib8000_set_sb_channel(state);
-		if (c->isdbt_sb_subchannel != -1)
+		if (c->isdbt_sb_subchannel < 14)
 			init_prbs = dib8000_get_init_prbs(state, c->isdbt_sb_subchannel);
 		else
 			init_prbs = 0;
@@ -3102,7 +3102,9 @@ static int dib8000_tune(struct dvb_frontend *fe)
 			dib8000_set_isdbt_loop_params(state, LOOP_TUNE_2);
 
 			/* mpeg will never lock on this condition because init_prbs is not set : search for it !*/
-			if (c->isdbt_sb_mode && c->isdbt_sb_subchannel == -1 && !state->differential_constellation) {
+			if (c->isdbt_sb_mode
+			    && c->isdbt_sb_subchannel < 14
+			    && !state->differential_constellation) {
 				state->subchannel = 0;
 				*tune_state = CT_DEMOD_STEP_11;
 			} else {
@@ -3146,14 +3148,18 @@ static int dib8000_tune(struct dvb_frontend *fe)
 			locks = dib8000_read_lock(fe);
 			if (locks&(1<<(7-state->longest_intlv_layer))) { /* mpeg lock : check the longest one */
 				dprintk("Mpeg locks [ L0 : %d | L1 : %d | L2 : %d ]", (locks>>7)&0x1, (locks>>6)&0x1, (locks>>5)&0x1);
-				if (c->isdbt_sb_mode && c->isdbt_sb_subchannel == -1 && !state->differential_constellation)
+				if (c->isdbt_sb_mode
+				    && c->isdbt_sb_subchannel < 14
+				    && !state->differential_constellation)
 					/* signal to the upper layer, that there was a channel found and the parameters can be read */
 					state->status = FE_STATUS_DEMOD_SUCCESS;
 				else
 					state->status = FE_STATUS_DATA_LOCKED;
 				*tune_state = CT_DEMOD_STOP;
 			} else if (now > *timeout) {
-				if (c->isdbt_sb_mode && c->isdbt_sb_subchannel == -1 && !state->differential_constellation) { /* continue to try init prbs autosearch */
+				if (c->isdbt_sb_mode
+				    && c->isdbt_sb_subchannel < 14
+				    && !state->differential_constellation) { /* continue to try init prbs autosearch */
 					state->subchannel += 3;
 					*tune_state = CT_DEMOD_STEP_11;
 				} else { /* we are done mpeg of the longest interleaver xas not locking but let's try if an other layer has locked in the same time */
-- 
1.8.1.4

