Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58840 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756456AbcB0Kva (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2016 05:51:30 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Patrick Boettcher <patrick.boettcher@posteo.de>
Subject: [PATCH 3/7] [media] dib0090: Do the right check for state->rf_ramp
Date: Sat, 27 Feb 2016 07:51:09 -0300
Message-Id: <a3c1c835c0ff8c287adee3325b1ea833328ac4fe.1456570258.git.mchehab@osg.samsung.com>
In-Reply-To: <d7bc635a625d7ab19ed5a81135044e086d330d1b.1456570258.git.mchehab@osg.samsung.com>
References: <d7bc635a625d7ab19ed5a81135044e086d330d1b.1456570258.git.mchehab@osg.samsung.com>
In-Reply-To: <d7bc635a625d7ab19ed5a81135044e086d330d1b.1456570258.git.mchehab@osg.samsung.com>
References: <d7bc635a625d7ab19ed5a81135044e086d330d1b.1456570258.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Smatch with -pkernel --no-data keeps complaining about rf_ramp:
	drivers/media/dvb-frontends/dib0090.c:1119 dib0090_pwm_gain_reset() error: we previously assumed 'state->rf_ramp' could be null (see line 1086)

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-frontends/dib0090.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/dib0090.c b/drivers/media/dvb-frontends/dib0090.c
index 7ee784f1b771..dc2d41e144fd 100644
--- a/drivers/media/dvb-frontends/dib0090.c
+++ b/drivers/media/dvb-frontends/dib0090.c
@@ -1115,7 +1115,7 @@ void dib0090_pwm_gain_reset(struct dvb_frontend *fe)
 		dib0090_set_bbramp_pwm(state, bb_ramp);
 
 		/* activate the ramp generator using PWM control */
-		if (rf_ramp)
+		if (state->rf_ramp)
 			dprintk("ramp RF gain = %d BAND = %s version = %d",
 				state->rf_ramp[0],
 				(state->current_band == BAND_CBAND) ? "CBAND" : "NOT CBAND",
-- 
2.5.0

