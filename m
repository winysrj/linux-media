Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153Ab1LITAV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Dec 2011 14:00:21 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pB9J0LuU002768
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 9 Dec 2011 14:00:21 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCHv2] [media] drxk: Switch the delivery system on FE_SET_PROPERTY
Date: Fri,  9 Dec 2011 17:00:12 -0200
Message-Id: <1323457212-13507-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <4EE252E5.2050204@iki.fi>
References: <4EE252E5.2050204@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DRX-K doesn't change the delivery system at set_properties,
but do it at frontend init. This causes problems on programs like
w_scan that, by default, opens both frontends.

Use adap->mfe_shared in order to prevent this, and be sure that Annex A
or C are properly selected.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---

v2: Use mfe_shared

 drivers/media/dvb/frontends/drxk_hard.c |   16 ++++++++++------
 drivers/media/dvb/frontends/drxk_hard.h |    2 ++
 drivers/media/video/em28xx/em28xx-dvb.c |    4 ++++
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 95cbc98..388b815 100644
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
 
@@ -6219,13 +6225,11 @@ static int drxk_set_parameters(struct dvb_frontend *fe,
 		return -EINVAL;
 	}
 
-	if (state->m_OperationMode == OM_QAM_ITU_A ||
-	    state->m_OperationMode == OM_QAM_ITU_C) {
+	if (fe->ops.info.type == FE_QAM) {
 		if (fe->dtv_property_cache.rolloff == ROLLOFF_13)
-			state->m_OperationMode = OM_QAM_ITU_C;
+			state->m_itut_annex_c = true;
 		else
-			state->m_OperationMode = OM_QAM_ITU_A;
-	}
+			state->m_itut_annex_c = false;
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
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
diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index 7f0592c..3868c1e 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -899,6 +899,8 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		       &dvb->fe[0]->ops.tuner_ops,
 		       sizeof(dvb->fe[0]->ops.tuner_ops));
 
+		mfe_shared = 1;
+
 		break;
 	}
 	case EM2884_BOARD_TERRATEC_H5:
@@ -935,6 +937,8 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		       &dvb->fe[0]->ops.tuner_ops,
 		       sizeof(dvb->fe[0]->ops.tuner_ops));
 
+		mfe_shared = 1;
+
 		break;
 	case EM28174_BOARD_PCTV_460E:
 		/* attach demod */
-- 
1.7.8

