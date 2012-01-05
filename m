Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932297Ab2AEBBI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:08 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q05118P3016366
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:08 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 25/47] [media] mt2063: Simplify mt2063_setTune logic
Date: Wed,  4 Jan 2012 23:00:36 -0200
Message-Id: <1325725258-27934-26-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |   37 ++-------------------------------
 1 files changed, 3 insertions(+), 34 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 3c0b3f1..53e3960 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -323,34 +323,6 @@ static u32 MT2063_ClearPowerMaskBits(struct mt2063_state *state, enum MT2063_Mas
 /*****************/
 /* From drivers/media/common/tuners/mt2063_cfg.h */
 
-unsigned int mt2063_setTune(struct dvb_frontend *fe, u32 f_in,
-			    u32 bw_in,
-			    enum MTTune_atv_standard tv_type)
-{
-	struct dvb_frontend_ops *frontend_ops = NULL;
-	struct dvb_tuner_ops *tuner_ops = NULL;
-	struct tuner_state t_state;
-	struct mt2063_state *state = fe->tuner_priv;
-	int err = 0;
-
-	t_state.frequency = f_in;
-	t_state.bandwidth = bw_in;
-	state->tv_type = tv_type;
-	if (&fe->ops)
-		frontend_ops = &fe->ops;
-	if (&frontend_ops->tuner_ops)
-		tuner_ops = &frontend_ops->tuner_ops;
-	if (tuner_ops->set_state) {
-		if ((err =
-		     tuner_ops->set_state(fe, DVBFE_TUNER_FREQUENCY,
-					  &t_state)) < 0) {
-			printk("%s: Invalid parameter\n", __func__);
-			return err;
-		}
-	}
-
-	return err;
-}
 
 unsigned int tuner_MT2063_SoftwareShutdown(struct dvb_frontend *fe)
 {
@@ -2862,19 +2834,16 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 	return status;
 }
 
-static u32 MT_Tune_atv(void *h, u32 f_in, u32 bw_in,
-		    enum MTTune_atv_standard tv_type)
+unsigned int mt2063_setTune(void *h, u32 f_in, u32 bw_in,
+			    enum MTTune_atv_standard tv_type)
 {
-
 	u32 status = 0;
-
 	s32 pict_car = 0;
 	s32 pict2chanb_vsb = 0;
 	s32 pict2chanb_snd = 0;
 	s32 pict2snd1 = 0;
 	s32 pict2snd2 = 0;
 	s32 ch_bw = 0;
-
 	s32 if_mid = 0;
 	s32 rcvr_mode = 0;
 	u32 mode_get = 0;
@@ -3290,7 +3259,7 @@ static int mt2063_set_state(struct dvb_frontend *fe,
 		//set frequency
 
 		status =
-		    MT_Tune_atv(state,
+		    mt2063_setTune(state,
 				tunstate->frequency, tunstate->bandwidth,
 				state->tv_type);
 
-- 
1.7.7.5

