Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35770 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbcBVOQc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 09:16:32 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Patrick Boettcher <patrick.boettcher@posteo.de>
Subject: [PATCH 5/5] [media] dib0090: do the right thing if rf_ramp is NULL
Date: Mon, 22 Feb 2016 11:16:23 -0300
Message-Id: <b1721c47e0e53a765606a6f46ce8bf080d1bb7a3.1456150537.git.mchehab@osg.samsung.com>
In-Reply-To: <72ef5fcae1ee23265c796b0cacd64ee41b9b9301.1456150537.git.mchehab@osg.samsung.com>
References: <72ef5fcae1ee23265c796b0cacd64ee41b9b9301.1456150537.git.mchehab@osg.samsung.com>
In-Reply-To: <72ef5fcae1ee23265c796b0cacd64ee41b9b9301.1456150537.git.mchehab@osg.samsung.com>
References: <72ef5fcae1ee23265c796b0cacd64ee41b9b9301.1456150537.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by smatch:
	drivers/media/dvb-frontends/dib0090.c:1118 dib0090_pwm_gain_reset() error: we previously assumed 'state->rf_ramp' could be null (see line 1086)

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-frontends/dib0090.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib0090.c b/drivers/media/dvb-frontends/dib0090.c
index 976ee034a430..7ee784f1b771 100644
--- a/drivers/media/dvb-frontends/dib0090.c
+++ b/drivers/media/dvb-frontends/dib0090.c
@@ -1115,9 +1115,15 @@ void dib0090_pwm_gain_reset(struct dvb_frontend *fe)
 		dib0090_set_bbramp_pwm(state, bb_ramp);
 
 		/* activate the ramp generator using PWM control */
-		dprintk("ramp RF gain = %d BAND = %s version = %d", state->rf_ramp[0], (state->current_band == BAND_CBAND) ? "CBAND" : "NOT CBAND", state->identity.version & 0x1f);
+		if (rf_ramp)
+			dprintk("ramp RF gain = %d BAND = %s version = %d",
+				state->rf_ramp[0],
+				(state->current_band == BAND_CBAND) ? "CBAND" : "NOT CBAND",
+				state->identity.version & 0x1f);
 
-		if ((state->rf_ramp[0] == 0) || (state->current_band == BAND_CBAND && (state->identity.version & 0x1f) <= P1D_E_F)) {
+		if (rf_ramp && ((state->rf_ramp[0] == 0) ||
+		    (state->current_band == BAND_CBAND &&
+		    (state->identity.version & 0x1f) <= P1D_E_F))) {
 			dprintk("DE-Engage mux for direct gain reg control");
 			en_pwm_rf_mux = 0;
 		} else
-- 
2.5.0

