Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab2J0Ul7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:41:59 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKfwXg006274
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:41:59 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 06/68] [media] stv0367: get rid of warning: no previous prototype
Date: Sat, 27 Oct 2012 18:40:24 -0200
Message-Id: <1351370486-29040-7-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/stv0367.c:1267:25: warning: no previous prototype for 'stv0367ter_lock_algo' [-Wmissing-prototypes]
drivers/media/dvb-frontends/stv0367.c:1531:5: warning: no previous prototype for 'stv0367ter_init' [-Wmissing-prototypes]
drivers/media/dvb-frontends/stv0367.c:2381:21: warning: no previous prototype for 'stv0367cab_SetQamSize' [-Wmissing-prototypes]
drivers/media/dvb-frontends/stv0367.c:2765:5: warning: no previous prototype for 'stv0367cab_init' [-Wmissing-prototypes]
drivers/media/dvb-frontends/stv0367.c:882:4: warning: no previous prototype for 'stv0367_getbits' [-Wmissing-prototypes]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/stv0367.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index 2a8aaeb..0c8e459 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -879,7 +879,8 @@ static u8 stv0367_readbits(struct stv0367_state *state, u32 label)
 	return val;
 }
 
-u8 stv0367_getbits(u8 reg, u32 label)
+#if 0 /* Currently, unused */
+static u8 stv0367_getbits(u8 reg, u32 label)
 {
 	u8 mask, pos;
 
@@ -887,7 +888,7 @@ u8 stv0367_getbits(u8 reg, u32 label)
 
 	return (reg & mask) >> pos;
 }
-
+#endif
 static int stv0367ter_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	struct stv0367_state *state = fe->demodulator_priv;
@@ -1263,8 +1264,8 @@ stv0367_ter_signal_type stv0367ter_check_cpamp(struct stv0367_state *state,
 	return CPAMPStatus;
 }
 
-enum
-stv0367_ter_signal_type stv0367ter_lock_algo(struct stv0367_state *state)
+static enum stv0367_ter_signal_type
+stv0367ter_lock_algo(struct stv0367_state *state)
 {
 	enum stv0367_ter_signal_type ret_flag;
 	short int wd, tempo;
@@ -1528,7 +1529,7 @@ static int stv0367ter_sleep(struct dvb_frontend *fe)
 	return stv0367ter_standby(fe, 1);
 }
 
-int stv0367ter_init(struct dvb_frontend *fe)
+static int stv0367ter_init(struct dvb_frontend *fe)
 {
 	struct stv0367_state *state = fe->demodulator_priv;
 	struct stv0367ter_state *ter_state = state->ter_state;
@@ -2378,9 +2379,9 @@ static u32 stv0367cab_get_adc_freq(struct dvb_frontend *fe, u32 ExtClk_Hz)
 	return ADCClk_Hz;
 }
 
-enum stv0367cab_mod stv0367cab_SetQamSize(struct stv0367_state *state,
-					u32 SymbolRate,
-					enum stv0367cab_mod QAMSize)
+static enum stv0367cab_mod stv0367cab_SetQamSize(struct stv0367_state *state,
+						 u32 SymbolRate,
+						 enum stv0367cab_mod QAMSize)
 {
 	/* Set QAM size */
 	stv0367_writebits(state, F367CAB_QAM_MODE, QAMSize);
@@ -2762,7 +2763,7 @@ static int stv0367cab_sleep(struct dvb_frontend *fe)
 	return stv0367cab_standby(fe, 1);
 }
 
-int stv0367cab_init(struct dvb_frontend *fe)
+static int stv0367cab_init(struct dvb_frontend *fe)
 {
 	struct stv0367_state *state = fe->demodulator_priv;
 	struct stv0367cab_state *cab_state = state->cab_state;
-- 
1.7.11.7

