Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52968 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932226Ab2HQCFA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 22:05:00 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/4] dvb_frontend: add routine for DVB-T parameter validation
Date: Fri, 17 Aug 2012 05:03:39 +0300
Message-Id: <1345169022-10221-2-git-send-email-crope@iki.fi>
In-Reply-To: <1345169022-10221-1-git-send-email-crope@iki.fi>
References: <1345169022-10221-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Common routine for use of dvb-core, demodulator and tuner for check
given DVB-T parameters correctness.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-core/dvb_frontend.c | 136 ++++++++++++++++++++++++++++++++++
 drivers/media/dvb-core/dvb_frontend.h |   2 +
 2 files changed, 138 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index d29d41a..4abb648 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2505,6 +2505,142 @@ int dvb_frontend_resume(struct dvb_frontend *fe)
 }
 EXPORT_SYMBOL(dvb_frontend_resume);
 
+int dvb_validate_params_dvbt(struct dvb_frontend *fe)
+{
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+
+	dev_dbg(fe->dvb->device, "%s:\n", __func__);
+
+	switch (c->delivery_system) {
+	case SYS_DVBT:
+		break;
+	default:
+		dev_dbg(fe->dvb->device, "%s: delivery_system=%d\n", __func__,
+				c->delivery_system);
+		return -EINVAL;
+	}
+
+	if (c->frequency >= 174000000 && c->frequency <= 230000000) {
+		;
+	} else if (c->frequency >= 470000000 && c->frequency <= 862000000) {
+		;
+	} else {
+		dev_dbg(fe->dvb->device, "%s: frequency=%d\n", __func__,
+				c->frequency);
+		return -EINVAL;
+	}
+
+	switch (c->bandwidth_hz) {
+	case 6000000:
+	case 7000000:
+	case 8000000:
+		break;
+	default:
+		dev_dbg(fe->dvb->device, "%s: bandwidth_hz=%d\n", __func__,
+				c->bandwidth_hz);
+		return -EINVAL;
+	}
+
+	switch (c->transmission_mode) {
+	case TRANSMISSION_MODE_AUTO:
+	case TRANSMISSION_MODE_2K:
+	case TRANSMISSION_MODE_8K:
+		break;
+	default:
+		dev_dbg(fe->dvb->device, "%s: transmission_mode=%d\n", __func__,
+				c->transmission_mode);
+		return -EINVAL;
+	}
+
+	switch (c->modulation) {
+	case QAM_AUTO:
+	case QPSK:
+	case QAM_16:
+	case QAM_64:
+		break;
+	default:
+		dev_dbg(fe->dvb->device, "%s: modulation=%d\n", __func__,
+				c->modulation);
+		return -EINVAL;
+	}
+
+	switch (c->guard_interval) {
+	case GUARD_INTERVAL_AUTO:
+	case GUARD_INTERVAL_1_32:
+	case GUARD_INTERVAL_1_16:
+	case GUARD_INTERVAL_1_8:
+	case GUARD_INTERVAL_1_4:
+		break;
+	default:
+		dev_dbg(fe->dvb->device, "%s: guard_interval=%d\n", __func__,
+				c->guard_interval);
+		return -EINVAL;
+	}
+
+	switch (c->hierarchy) {
+	case HIERARCHY_NONE:
+	case HIERARCHY_AUTO:
+	case HIERARCHY_1:
+	case HIERARCHY_2:
+	case HIERARCHY_4:
+		break;
+	default:
+		dev_dbg(fe->dvb->device, "%s: hierarchy=%d\n", __func__,
+				c->hierarchy);
+		return -EINVAL;
+	}
+
+	switch (c->code_rate_HP) {
+	case FEC_AUTO:
+	case FEC_1_2:
+	case FEC_2_3:
+	case FEC_3_4:
+	case FEC_5_6:
+	case FEC_7_8:
+		break;
+	default:
+		dev_dbg(fe->dvb->device, "%s: code_rate_HP=%d\n", __func__,
+				c->code_rate_HP);
+		return -EINVAL;
+	}
+
+	/*
+	 * code_rate_LP is used only with hierarchical coding
+	 */
+	if (c->hierarchy == HIERARCHY_NONE) {
+		switch (c->code_rate_LP) {
+		case FEC_NONE:
+		/*
+		 * TODO: FEC_AUTO here is wrong, but for some reason
+		 * dtv_set_frontend() forces it.
+		 */
+		case FEC_AUTO:
+			break;
+		default:
+			dev_dbg(fe->dvb->device, "%s: code_rate_LP=%d\n",
+					__func__, c->code_rate_LP);
+			return -EINVAL;
+		}
+	} else {
+		switch (c->code_rate_LP) {
+		case FEC_AUTO:
+		case FEC_1_2:
+		case FEC_2_3:
+		case FEC_3_4:
+		case FEC_5_6:
+		case FEC_7_8:
+			break;
+		default:
+			dev_dbg(fe->dvb->device, "%s: code_rate_LP=%d\n",
+					__func__, c->code_rate_LP);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(dvb_validate_params_dvbt);
+
 int dvb_register_frontend(struct dvb_adapter* dvb,
 			  struct dvb_frontend* fe)
 {
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 74ba563..6df0c44 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -425,4 +425,6 @@ extern int dvb_frontend_resume(struct dvb_frontend *fe);
 extern void dvb_frontend_sleep_until(struct timeval *waketime, u32 add_usec);
 extern s32 timeval_usec_diff(struct timeval lasttime, struct timeval curtime);
 
+extern int dvb_validate_params_dvbt(struct dvb_frontend *fe);
+
 #endif
-- 
1.7.11.2

