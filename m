Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57527 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562Ab2HQCF4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 22:05:56 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/4] dvb_frontend: add routine for DTMB parameter validation
Date: Fri, 17 Aug 2012 05:03:42 +0300
Message-Id: <1345169022-10221-5-git-send-email-crope@iki.fi>
In-Reply-To: <1345169022-10221-1-git-send-email-crope@iki.fi>
References: <1345169022-10221-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Common routine for use of dvb-core, demodulator and tuner for check
given DTMB parameters correctness.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-core/dvb_frontend.c | 97 +++++++++++++++++++++++++++++++++++
 drivers/media/dvb-core/dvb_frontend.h |  1 +
 2 files changed, 98 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 6a19c87..7c3ba26 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2813,6 +2813,103 @@ int dvb_validate_params_dvbc_annex_a(struct dvb_frontend *fe)
 }
 EXPORT_SYMBOL(dvb_validate_params_dvbc_annex_a);
 
+int dvb_validate_params_dtmb(struct dvb_frontend *fe)
+{
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+
+	dev_dbg(fe->dvb->device, "%s:\n", __func__);
+
+	switch (c->delivery_system) {
+	case SYS_DTMB:
+		break;
+	default:
+		dev_dbg(fe->dvb->device, "%s: delivery_system=%d\n", __func__,
+				c->delivery_system);
+		return -EINVAL;
+	}
+
+	if (c->frequency >= 470000000 && c->frequency <= 862000000) {
+		;
+	} else {
+		dev_dbg(fe->dvb->device, "%s: frequency=%d\n", __func__,
+				c->frequency);
+		return -EINVAL;
+	}
+
+	switch (c->bandwidth_hz) {
+	case 8000000:
+		break;
+	default:
+		dev_dbg(fe->dvb->device, "%s: bandwidth_hz=%d\n", __func__,
+				c->bandwidth_hz);
+		return -EINVAL;
+	}
+
+	switch (c->modulation) {
+	case QAM_AUTO:
+	case QPSK: /* QAM4 */
+	case QAM_16:
+	case QAM_32:
+	case QAM_64:
+	case QAM_4_NR:
+		break;
+	default:
+		dev_dbg(fe->dvb->device, "%s: modulation=%d\n", __func__,
+				c->modulation);
+		return -EINVAL;
+	}
+
+	switch (c->transmission_mode) {
+	case TRANSMISSION_MODE_AUTO:
+	case TRANSMISSION_MODE_C1:
+	case TRANSMISSION_MODE_C3780:
+		break;
+	default:
+		dev_dbg(fe->dvb->device, "%s: transmission_mode=%d\n", __func__,
+				c->transmission_mode);
+		return -EINVAL;
+	}
+
+	switch (c->guard_interval) {
+	case GUARD_INTERVAL_AUTO:
+	case GUARD_INTERVAL_PN420:
+	case GUARD_INTERVAL_PN595:
+	case GUARD_INTERVAL_PN945:
+		break;
+	default:
+		dev_dbg(fe->dvb->device, "%s: guard_interval=%d\n", __func__,
+				c->guard_interval);
+		return -EINVAL;
+	}
+
+	/* inner coding LDPC */
+	switch (c->fec_inner) {
+	case FEC_AUTO:
+	case FEC_2_5: /* 0.4 */
+	case FEC_3_5: /* 0.6 */
+	case FEC_4_5: /* 0.8 */
+		break;
+	default:
+		dev_dbg(fe->dvb->device, "%s: fec_inner=%d\n", __func__,
+				c->fec_inner);
+		return -EINVAL;
+	}
+
+	switch (c->interleaving) {
+	case INTERLEAVING_AUTO:
+	case INTERLEAVING_240:
+	case INTERLEAVING_720:
+		break;
+	default:
+		dev_dbg(fe->dvb->device, "%s: interleaving=%d\n", __func__,
+				c->interleaving);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(dvb_validate_params_dtmb);
+
 int dvb_register_frontend(struct dvb_adapter* dvb,
 			  struct dvb_frontend* fe)
 {
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index e6e6fe1..9499039 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -428,5 +428,6 @@ extern s32 timeval_usec_diff(struct timeval lasttime, struct timeval curtime);
 extern int dvb_validate_params_dvbt(struct dvb_frontend *fe);
 extern int dvb_validate_params_dvbt2(struct dvb_frontend *fe);
 extern int dvb_validate_params_dvbc_annex_a(struct dvb_frontend *fe);
+extern int dvb_validate_params_dtmb(struct dvb_frontend *fe);
 
 #endif
-- 
1.7.11.2

