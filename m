Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:35197 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751593AbcLJJoR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Dec 2016 04:44:17 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH for v4.10 4/6] cec: replace cec_report_features by cec_fill_msg_report_features
Date: Sat, 10 Dec 2016 10:44:11 +0100
Message-Id: <20161210094413.8832-5-hverkuil@xs4all.nl>
In-Reply-To: <20161210094413.8832-1-hverkuil@xs4all.nl>
References: <20161210094413.8832-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

The fill function just fills in the cec_msg struct, it doesn't transmit
the message. This is now done explicitly.

This makes it possible to switch to transmitting this message with adap->lock
held.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/media/cec/cec-adap.c | 48 ++++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index f3fef48..2b66851 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -30,8 +30,10 @@
 
 #include "cec-priv.h"
 
-static int cec_report_features(struct cec_adapter *adap, unsigned int la_idx);
 static int cec_report_phys_addr(struct cec_adapter *adap, unsigned int la_idx);
+static void cec_fill_msg_report_features(struct cec_adapter *adap,
+					 struct cec_msg *msg,
+					 unsigned int la_idx);
 
 /*
  * 400 ms is the time it takes for one 16 byte message to be
@@ -1258,16 +1260,21 @@ static int cec_config_thread_func(void *arg)
 	mutex_unlock(&adap->lock);
 
 	for (i = 0; i < las->num_log_addrs; i++) {
+		struct cec_msg msg = {};
+
 		if (las->log_addr[i] == CEC_LOG_ADDR_INVALID ||
 		    (las->flags & CEC_LOG_ADDRS_FL_CDC_ONLY))
 			continue;
 
-		/*
-		 * Report Features must come first according
-		 * to CEC 2.0
-		 */
-		if (las->log_addr[i] != CEC_LOG_ADDR_UNREGISTERED)
-			cec_report_features(adap, i);
+		msg.msg[0] = (las->log_addr[i] << 4) | 0x0f;
+
+		/* Report Features must come first according to CEC 2.0 */
+		if (las->log_addr[i] != CEC_LOG_ADDR_UNREGISTERED &&
+		    adap->log_addrs.cec_version >= CEC_OP_CEC_VERSION_2_0) {
+			cec_fill_msg_report_features(adap, &msg, i);
+			cec_transmit_msg(adap, &msg, false);
+		}
+
 		cec_report_phys_addr(adap, i);
 	}
 	mutex_lock(&adap->lock);
@@ -1526,36 +1533,32 @@ EXPORT_SYMBOL_GPL(cec_s_log_addrs);
 
 /* High-level core CEC message handling */
 
-/* Transmit the Report Features message */
-static int cec_report_features(struct cec_adapter *adap, unsigned int la_idx)
+/* Fill in the Report Features message */
+static void cec_fill_msg_report_features(struct cec_adapter *adap,
+					 struct cec_msg *msg,
+					 unsigned int la_idx)
 {
-	struct cec_msg msg = { };
 	const struct cec_log_addrs *las = &adap->log_addrs;
 	const u8 *features = las->features[la_idx];
 	bool op_is_dev_features = false;
 	unsigned int idx;
 
-	/* This is 2.0 and up only */
-	if (adap->log_addrs.cec_version < CEC_OP_CEC_VERSION_2_0)
-		return 0;
-
 	/* Report Features */
-	msg.msg[0] = (las->log_addr[la_idx] << 4) | 0x0f;
-	msg.len = 4;
-	msg.msg[1] = CEC_MSG_REPORT_FEATURES;
-	msg.msg[2] = adap->log_addrs.cec_version;
-	msg.msg[3] = las->all_device_types[la_idx];
+	msg->msg[0] = (las->log_addr[la_idx] << 4) | 0x0f;
+	msg->len = 4;
+	msg->msg[1] = CEC_MSG_REPORT_FEATURES;
+	msg->msg[2] = adap->log_addrs.cec_version;
+	msg->msg[3] = las->all_device_types[la_idx];
 
 	/* Write RC Profiles first, then Device Features */
 	for (idx = 0; idx < ARRAY_SIZE(las->features[0]); idx++) {
-		msg.msg[msg.len++] = features[idx];
+		msg->msg[msg->len++] = features[idx];
 		if ((features[idx] & CEC_OP_FEAT_EXT) == 0) {
 			if (op_is_dev_features)
 				break;
 			op_is_dev_features = true;
 		}
 	}
-	return cec_transmit_msg(adap, &msg, false);
 }
 
 /* Transmit the Report Physical Address message */
@@ -1779,7 +1782,8 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 	case CEC_MSG_GIVE_FEATURES:
 		if (adap->log_addrs.cec_version < CEC_OP_CEC_VERSION_2_0)
 			return cec_feature_abort(adap, msg);
-		return cec_report_features(adap, la_idx);
+		cec_fill_msg_report_features(adap, &tx_cec_msg, la_idx);
+		return cec_transmit_msg(adap, &tx_cec_msg, false);
 
 	default:
 		/*
-- 
2.10.2

