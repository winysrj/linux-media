Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33475 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab0IGPvF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Sep 2010 11:51:05 -0400
Received: by wyf22 with SMTP id 22so4384130wyf.19
        for <linux-media@vger.kernel.org>; Tue, 07 Sep 2010 08:51:03 -0700 (PDT)
From: pboettcher@kernellabs.com
To: linux-media@vger.kernel.org
Cc: Olivier Grenie <olivier.grenie@dibcom.fr>,
	Patrick Boettcher <patrick.boettcher@dibcom.fr>
Subject: [PATCH 2/2] V4L/DVB: dib7000p: add disable sample and hold, and diversity delay parameter
Date: Tue,  7 Sep 2010 17:50:46 +0200
Message-Id: <1283874646-20770-2-git-send-email-Patrick.Boettcher@dibcom.fr>
In-Reply-To: <1283874646-20770-1-git-send-email-Patrick.Boettcher@dibcom.fr>
References: <1283874646-20770-1-git-send-email-Patrick.Boettcher@dibcom.fr>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

From: Olivier Grenie <olivier.grenie@dibcom.fr>

This patch improves the overall driver performance in
diversity-reception scenarios.

Signed-off-by: Olivier Grenie <olivier.grenie@dibcom.fr>
Signed-off-by: Patrick Boettcher <patrick.boettcher@dibcom.fr>
---
 drivers/media/dvb/dvb-usb/dib0700_devices.c |    1 +
 drivers/media/dvb/frontends/dib7000p.c      |    6 +++++-
 drivers/media/dvb/frontends/dib7000p.h      |    2 ++
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index f9766c7..6015cfd 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -956,6 +956,7 @@ static struct dib7000p_config dib7770p_dib7000p_config = {
 
 	.hostbus_diversity = 1,
 	.enable_current_mirror = 1,
+	.disable_sample_and_hold = 0,
 };
 
 static int stk7770p_frontend_attach(struct dvb_usb_adapter *adap)
diff --git a/drivers/media/dvb/frontends/dib7000p.c b/drivers/media/dvb/frontends/dib7000p.c
index 73f59ab..3aed0d4 100644
--- a/drivers/media/dvb/frontends/dib7000p.c
+++ b/drivers/media/dvb/frontends/dib7000p.c
@@ -260,6 +260,7 @@ static void dib7000p_set_adc_state(struct dib7000p_state *state, enum dibx000_ad
 
 //	dprintk( "908: %x, 909: %x\n", reg_908, reg_909);
 
+	reg_909 |= (state->cfg.disable_sample_and_hold & 1) << 4;
 	reg_908 |= (state->cfg.enable_current_mirror & 1) << 7;
 
 	dib7000p_write_word(state, 908, reg_908);
@@ -780,7 +781,10 @@ static void dib7000p_set_channel(struct dib7000p_state *state, struct dvb_fronte
 		default:
 		case GUARD_INTERVAL_1_32: value *= 1; break;
 	}
-	state->div_sync_wait = (value * 3) / 2 + 32; // add 50% SFN margin + compensate for one DVSY-fifo TODO
+	if (state->cfg.diversity_delay == 0)
+		state->div_sync_wait = (value * 3) / 2 + 48; // add 50% SFN margin + compensate for one DVSY-fifo
+	else
+		state->div_sync_wait = (value * 3) / 2 + state->cfg.diversity_delay; // add 50% SFN margin + compensate for one DVSY-fifo
 
 	/* deactive the possibility of diversity reception if extended interleaver */
 	state->div_force_off = !1 && ch->u.ofdm.transmission_mode != TRANSMISSION_MODE_8K;
diff --git a/drivers/media/dvb/frontends/dib7000p.h b/drivers/media/dvb/frontends/dib7000p.h
index 04a7449..da17345 100644
--- a/drivers/media/dvb/frontends/dib7000p.h
+++ b/drivers/media/dvb/frontends/dib7000p.h
@@ -33,8 +33,10 @@ struct dib7000p_config {
 	int (*agc_control) (struct dvb_frontend *, u8 before);
 
 	u8 output_mode;
+	u8 disable_sample_and_hold : 1;
 
 	u8 enable_current_mirror : 1;
+	u8 diversity_delay;
 
 };
 
-- 
1.7.0.4

