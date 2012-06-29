Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217Ab2F2VwB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jun 2012 17:52:01 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5TLq1Oi024169
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 29 Jun 2012 17:52:01 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/4] [media] drxk: prevent doing something wrong when init is not ok
Date: Fri, 29 Jun 2012 18:51:57 -0300
Message-Id: <1341006717-32373-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1341006717-32373-1-git-send-email-mchehab@redhat.com>
References: <20120629124719.2cf23f6b@endymion.delvare>
 <1341006717-32373-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If firmware is not loaded for some reason, or if it is not ready
yet, it makes no sense to honour to any DVB callbacks.

So, return -EAGAIN, as the error condition may be temporary.
If the device doesn't initialize, either because it requires a
firmware or because there's an error during init_drxk, returns
-ENODEV, to indicate such error, on all DVB callbacks.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/drxk_hard.c |   58 ++++++++++++++++++++++++++++++-
 drivers/media/dvb/frontends/drxk_hard.h |   10 +++++-
 2 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 87cb3f0..8fa28bb 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -2851,7 +2851,7 @@ static int ConfigureI2CBridge(struct drxk_state *state, bool bEnableBridge)
 	dprintk(1, "\n");
 
 	if (state->m_DrxkState == DRXK_UNINITIALIZED)
-		goto error;
+		return 0;
 	if (state->m_DrxkState == DRXK_POWERED_DOWN)
 		goto error;
 
@@ -6197,6 +6197,7 @@ static int init_drxk(struct drxk_state *state)
 	}
 error:
 	if (status < 0) {
+		state->m_DrxkState = DRXK_NO_DEV;
 		drxk_i2c_unlock(state);
 		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	}
@@ -6209,6 +6210,7 @@ static void load_firmware_cb(const struct firmware *fw,
 {
 	struct drxk_state *state = context;
 
+	dprintk(1, ": %s\n", fw ? "firmware loaded" : "firmware not loaded");
 	if (!fw) {
 		printk(KERN_ERR
 		       "drxk: Could not load firmware file %s.\n",
@@ -6250,6 +6252,12 @@ static int drxk_sleep(struct dvb_frontend *fe)
 	struct drxk_state *state = fe->demodulator_priv;
 
 	dprintk(1, "\n");
+
+	if (state->m_DrxkState == DRXK_NO_DEV)
+		return -ENODEV;
+	if (state->m_DrxkState == DRXK_UNINITIALIZED)
+		return 0;
+
 	ShutDown(state);
 	return 0;
 }
@@ -6259,6 +6267,10 @@ static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
 	struct drxk_state *state = fe->demodulator_priv;
 
 	dprintk(1, "%s\n", enable ? "enable" : "disable");
+
+	if (state->m_DrxkState == DRXK_NO_DEV)
+		return -ENODEV;
+
 	return ConfigureI2CBridge(state, enable ? true : false);
 }
 
@@ -6271,6 +6283,12 @@ static int drxk_set_parameters(struct dvb_frontend *fe)
 
 	dprintk(1, "\n");
 
+	if (state->m_DrxkState == DRXK_NO_DEV)
+		return -ENODEV;
+
+	if (state->m_DrxkState == DRXK_UNINITIALIZED)
+		return -EAGAIN;
+
 	if (!fe->ops.tuner_ops.get_if_frequency) {
 		printk(KERN_ERR
 		       "drxk: Error: get_if_frequency() not defined at tuner. Can't work without it!\n");
@@ -6324,6 +6342,12 @@ static int drxk_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	u32 stat;
 
 	dprintk(1, "\n");
+
+	if (state->m_DrxkState == DRXK_NO_DEV)
+		return -ENODEV;
+	if (state->m_DrxkState == DRXK_UNINITIALIZED)
+		return -EAGAIN;
+
 	*status = 0;
 	GetLockStatus(state, &stat, 0);
 	if (stat == MPEG_LOCK)
@@ -6337,8 +6361,15 @@ static int drxk_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 static int drxk_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
+	struct drxk_state *state = fe->demodulator_priv;
+
 	dprintk(1, "\n");
 
+	if (state->m_DrxkState == DRXK_NO_DEV)
+		return -ENODEV;
+	if (state->m_DrxkState == DRXK_UNINITIALIZED)
+		return -EAGAIN;
+
 	*ber = 0;
 	return 0;
 }
@@ -6350,6 +6381,12 @@ static int drxk_read_signal_strength(struct dvb_frontend *fe,
 	u32 val = 0;
 
 	dprintk(1, "\n");
+
+	if (state->m_DrxkState == DRXK_NO_DEV)
+		return -ENODEV;
+	if (state->m_DrxkState == DRXK_UNINITIALIZED)
+		return -EAGAIN;
+
 	ReadIFAgc(state, &val);
 	*strength = val & 0xffff;
 	return 0;
@@ -6361,6 +6398,12 @@ static int drxk_read_snr(struct dvb_frontend *fe, u16 *snr)
 	s32 snr2;
 
 	dprintk(1, "\n");
+
+	if (state->m_DrxkState == DRXK_NO_DEV)
+		return -ENODEV;
+	if (state->m_DrxkState == DRXK_UNINITIALIZED)
+		return -EAGAIN;
+
 	GetSignalToNoise(state, &snr2);
 	*snr = snr2 & 0xffff;
 	return 0;
@@ -6372,6 +6415,12 @@ static int drxk_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 	u16 err;
 
 	dprintk(1, "\n");
+
+	if (state->m_DrxkState == DRXK_NO_DEV)
+		return -ENODEV;
+	if (state->m_DrxkState == DRXK_UNINITIALIZED)
+		return -EAGAIN;
+
 	DVBTQAMGetAccPktErr(state, &err);
 	*ucblocks = (u32) err;
 	return 0;
@@ -6380,9 +6429,16 @@ static int drxk_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 static int drxk_get_tune_settings(struct dvb_frontend *fe, struct dvb_frontend_tune_settings
 				    *sets)
 {
+	struct drxk_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 
 	dprintk(1, "\n");
+
+	if (state->m_DrxkState == DRXK_NO_DEV)
+		return -ENODEV;
+	if (state->m_DrxkState == DRXK_UNINITIALIZED)
+		return -EAGAIN;
+
 	switch (p->delivery_system) {
 	case SYS_DVBC_ANNEX_A:
 	case SYS_DVBC_ANNEX_C:
diff --git a/drivers/media/dvb/frontends/drxk_hard.h b/drivers/media/dvb/frontends/drxk_hard.h
index c35ab2b..f417797 100644
--- a/drivers/media/dvb/frontends/drxk_hard.h
+++ b/drivers/media/dvb/frontends/drxk_hard.h
@@ -94,7 +94,15 @@ enum DRXPowerMode {
 
 
 enum AGC_CTRL_MODE { DRXK_AGC_CTRL_AUTO = 0, DRXK_AGC_CTRL_USER, DRXK_AGC_CTRL_OFF };
-enum EDrxkState { DRXK_UNINITIALIZED = 0, DRXK_STOPPED, DRXK_DTV_STARTED, DRXK_ATV_STARTED, DRXK_POWERED_DOWN };
+enum EDrxkState {
+	DRXK_UNINITIALIZED = 0,
+	DRXK_STOPPED,
+	DRXK_DTV_STARTED,
+	DRXK_ATV_STARTED,
+	DRXK_POWERED_DOWN,
+	DRXK_NO_DEV			/* If drxk init failed */
+};
+
 enum EDrxkCoefArrayIndex {
 	DRXK_COEF_IDX_MN = 0,
 	DRXK_COEF_IDX_FM    ,
-- 
1.7.10.2

