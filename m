Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238Ab1LISVE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Dec 2011 13:21:04 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pB9IL462024797
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 9 Dec 2011 13:21:04 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] [media] drxk: Switch the delivery system on FE_SET_PROPERTY
Date: Fri,  9 Dec 2011 16:20:52 -0200
Message-Id: <1323454852-7426-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DRX-K doesn't change the delivery system at set_properties,
but do it at frontend init. This causes problems on programs like
w_scan that, by default, opens both frontends.

Instead, explicitly set the format when set_parameters callback is
called.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/drxk_hard.c |   32 ++++++++++++++++++++++--------
 drivers/media/dvb/frontends/drxk_hard.h |    2 +
 2 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 95cbc98..c8e0921 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -1847,6 +1847,7 @@ static int SetOperationMode(struct drxk_state *state,
 		*/
 	switch (oMode) {
 	case OM_DVBT:
+		dprintk(1, ": DVB-T\n");
 		state->m_OperationMode = oMode;
 		status = SetDVBTStandard(state, oMode);
 		if (status < 0)
@@ -1854,6 +1855,8 @@ static int SetOperationMode(struct drxk_state *state,
 		break;
 	case OM_QAM_ITU_A:	/* fallthrough */
 	case OM_QAM_ITU_C:
+		dprintk(1, ": DVB-C Annex %c\n",
+			(state->m_OperationMode == OM_QAM_ITU_A) ? 'A' : 'C');
 		state->m_OperationMode = oMode;
 		status = SetQAMStandard(state, oMode);
 		if (status < 0)
@@ -6183,7 +6186,10 @@ static int drxk_c_init(struct dvb_frontend *fe)
 	dprintk(1, "\n");
 	if (mutex_trylock(&state->ctlock) == 0)
 		return -EBUSY;
-	SetOperationMode(state, OM_QAM_ITU_A);
+	if (state->m_itut_annex_c)
+		SetOperationMode(state, OM_QAM_ITU_C);
+	else
+		SetOperationMode(state, OM_QAM_ITU_A);
 	return 0;
 }
 
@@ -6219,14 +6225,6 @@ static int drxk_set_parameters(struct dvb_frontend *fe,
 		return -EINVAL;
 	}
 
-	if (state->m_OperationMode == OM_QAM_ITU_A ||
-	    state->m_OperationMode == OM_QAM_ITU_C) {
-		if (fe->dtv_property_cache.rolloff == ROLLOFF_13)
-			state->m_OperationMode = OM_QAM_ITU_C;
-		else
-			state->m_OperationMode = OM_QAM_ITU_A;
-	}
-
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 	if (fe->ops.tuner_ops.set_params)
@@ -6235,6 +6233,22 @@ static int drxk_set_parameters(struct dvb_frontend *fe,
 		fe->ops.i2c_gate_ctrl(fe, 0);
 	state->param = *p;
 	fe->ops.tuner_ops.get_if_frequency(fe, &IF);
+
+	/*
+	 * Make sure that the frontend is on the right state
+	 */
+
+	if (fe->ops.info.type == FE_QAM) {
+		if (fe->dtv_property_cache.rolloff == ROLLOFF_13) {
+			state->m_itut_annex_c = true;
+			SetOperationMode(state, OM_QAM_ITU_C);
+		} else {
+			state->m_itut_annex_c = false;
+			SetOperationMode(state, OM_QAM_ITU_A);
+		}
+	} else
+		SetOperationMode(state, OM_DVBT);
+
 	Start(state, 0, IF);
 
 	/* printk(KERN_DEBUG "drxk: %s IF=%d done\n", __func__, IF); */
diff --git a/drivers/media/dvb/frontends/drxk_hard.h b/drivers/media/dvb/frontends/drxk_hard.h
index a05c32e..85a423f 100644
--- a/drivers/media/dvb/frontends/drxk_hard.h
+++ b/drivers/media/dvb/frontends/drxk_hard.h
@@ -263,6 +263,8 @@ struct drxk_state {
 	u8     m_TSDataStrength;
 	u8     m_TSClockkStrength;
 
+	bool   m_itut_annex_c;      /* If true, uses ITU-T DVB-C Annex C, instead of Annex A */
+
 	enum DRXMPEGStrWidth_t  m_widthSTR;    /**< MPEG start width */
 	u32    m_mpegTsStaticBitrate;          /**< Maximum bitrate in b/s in case
 						    static clockrate is selected */
-- 
1.7.8

