Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44285 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932403Ab2HQCFA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 22:05:00 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/4] dvb_frontend: add routine for DVB-C annex A parameter validation
Date: Fri, 17 Aug 2012 05:03:41 +0300
Message-Id: <1345169022-10221-4-git-send-email-crope@iki.fi>
In-Reply-To: <1345169022-10221-1-git-send-email-crope@iki.fi>
References: <1345169022-10221-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Common routine for use of dvb-core, demodulator and tuner for check
given DVB-C annex A parameters correctness.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-core/dvb_frontend.c | 54 +++++++++++++++++++++++++++++++++++
 drivers/media/dvb-core/dvb_frontend.h |  1 +
 2 files changed, 55 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 6413c74..6a19c87 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2759,6 +2759,60 @@ int dvb_validate_params_dvbt2(struct dvb_frontend *fe)
 }
 EXPORT_SYMBOL(dvb_validate_params_dvbt2);
 
+int dvb_validate_params_dvbc_annex_a(struct dvb_frontend *fe)
+{
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+
+	dev_dbg(fe->dvb->device, "%s:\n", __func__);
+
+	switch (c->delivery_system) {
+	case SYS_DVBC_ANNEX_A:
+		break;
+	default:
+		dev_dbg(fe->dvb->device, "%s: delivery_system=%d\n", __func__,
+				c->delivery_system);
+		return -EINVAL;
+	}
+
+	/*
+	 * TODO: NorDig Unified 2.2 specifies input frequency range
+	 * 110 - 862 MHz. Do not limit it now as w_scan seems to start from
+	 * 73 MHz until reason is clear.
+	 */
+	if (c->frequency >= 0 && c->frequency <= 862000000) {
+		;
+	} else {
+		dev_dbg(fe->dvb->device, "%s: frequency=%d\n", __func__,
+				c->frequency);
+		return -EINVAL;
+	}
+
+	if (c->symbol_rate >= 1000000 && c->symbol_rate <= 7000000) {
+		;
+	} else {
+		dev_dbg(fe->dvb->device, "%s: symbol_rate=%d\n", __func__,
+				c->symbol_rate);
+		return -EINVAL;
+	}
+
+	switch (c->modulation) {
+	case QAM_AUTO:
+	case QAM_16:
+	case QAM_32:
+	case QAM_64:
+	case QAM_128:
+	case QAM_256:
+		break;
+	default:
+		dev_dbg(fe->dvb->device, "%s: modulation=%d\n", __func__,
+				c->modulation);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(dvb_validate_params_dvbc_annex_a);
+
 int dvb_register_frontend(struct dvb_adapter* dvb,
 			  struct dvb_frontend* fe)
 {
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index bcd572d..e6e6fe1 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -427,5 +427,6 @@ extern s32 timeval_usec_diff(struct timeval lasttime, struct timeval curtime);
 
 extern int dvb_validate_params_dvbt(struct dvb_frontend *fe);
 extern int dvb_validate_params_dvbt2(struct dvb_frontend *fe);
+extern int dvb_validate_params_dvbc_annex_a(struct dvb_frontend *fe);
 
 #endif
-- 
1.7.11.2

