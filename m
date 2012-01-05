Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755889Ab2AEPiA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jan 2012 10:38:00 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q05Fc0IA004105
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 5 Jan 2012 10:38:00 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/5] [media] drxk_hard: fix locking issues when changing the delsys
Date: Thu,  5 Jan 2012 13:37:50 -0200
Message-Id: <1325777872-14696-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325777872-14696-1-git-send-email-mchehab@redhat.com>
References: <1325777872-14696-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/drxk_hard.c |   45 ++++++++++++++++--------------
 drivers/media/dvb/frontends/drxk_hard.h |    1 -
 2 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index a95fb44..97670db 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -6188,7 +6188,6 @@ static int drxk_sleep(struct dvb_frontend *fe)
 
 	dprintk(1, "\n");
 	ShutDown(state);
-	mutex_unlock(&state->ctlock);
 	return 0;
 }
 
@@ -6203,7 +6202,7 @@ static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
 static int drxk_set_parameters(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
-	u32 delsys  = p->delivery_system;
+	u32 delsys  = p->delivery_system, old_delsys;
 	struct drxk_state *state = fe->demodulator_priv;
 	u32 IF;
 
@@ -6221,28 +6220,33 @@ static int drxk_set_parameters(struct dvb_frontend *fe)
 		fe->ops.tuner_ops.set_params(fe);
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	old_delsys = state->props.delivery_system;
 	state->props = *p;
 
-	switch (delsys) {
-	case SYS_DVBC_ANNEX_A:
-	case SYS_DVBC_ANNEX_C:
-		if (!state->m_hasDVBC)
-			return -EINVAL;
-		state->m_itut_annex_c = (delsys == SYS_DVBC_ANNEX_C) ? true : false;
-		if (state->m_itut_annex_c)
-			SetOperationMode(state, OM_QAM_ITU_C);
-		else
-			SetOperationMode(state, OM_QAM_ITU_A);
+	if (old_delsys != delsys) {
+		ShutDown(state);
+		switch (delsys) {
+		case SYS_DVBC_ANNEX_A:
+		case SYS_DVBC_ANNEX_C:
+			if (!state->m_hasDVBC)
+				return -EINVAL;
+			state->m_itut_annex_c = (delsys == SYS_DVBC_ANNEX_C) ? true : false;
+			if (state->m_itut_annex_c)
+				SetOperationMode(state, OM_QAM_ITU_C);
+			else
+				SetOperationMode(state, OM_QAM_ITU_A);
+				break;
+			state->m_itut_annex_c = true;
 			break;
-		state->m_itut_annex_c = true;
-		break;
-	case SYS_DVBT:
-		if (!state->m_hasDVBT)
+		case SYS_DVBT:
+			if (!state->m_hasDVBT)
+				return -EINVAL;
+			SetOperationMode(state, OM_DVBT);
+			break;
+		default:
 			return -EINVAL;
-		SetOperationMode(state, OM_DVBT);
-		break;
-	default:
-		return -EINVAL;
+		}
 	}
 
 	fe->ops.tuner_ops.get_if_frequency(fe, &IF);
@@ -6405,7 +6409,6 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 		state->m_GPIO &= ~state->antenna_gpio;
 
 	mutex_init(&state->mutex);
-	mutex_init(&state->ctlock);
 
 	memcpy(&state->frontend.ops, &drxk_ops, sizeof(drxk_ops));
 	state->frontend.demodulator_priv = state;
diff --git a/drivers/media/dvb/frontends/drxk_hard.h b/drivers/media/dvb/frontends/drxk_hard.h
index 7e3e4cf..3a58b73 100644
--- a/drivers/media/dvb/frontends/drxk_hard.h
+++ b/drivers/media/dvb/frontends/drxk_hard.h
@@ -204,7 +204,6 @@ struct drxk_state {
 	void  *priv;
 
 	struct mutex mutex;
-	struct mutex ctlock;
 
 	u32    m_Instance;           /**< Channel 1,2,3 or 4 */
 
-- 
1.7.7.5

