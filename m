Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:57773 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751745AbcGRJXo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 05:23:44 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id C13E218010E
	for <linux-media@vger.kernel.org>; Mon, 18 Jul 2016 11:23:39 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: always check all_device_types and features
Message-ID: <565ad7af-8077-9198-3fd6-03c336f2bc9c@xs4all.nl>
Date: Mon, 18 Jul 2016 11:23:39 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From e553f06a95a48ac541e20086e9c6b2f50cc663cd Mon Sep 17 00:00:00 2001
From: Hans Verkuil <hans.verkuil@cisco.com>
Date: Mon, 18 Jul 2016 08:44:10 +0200
Subject: [PATCH] cec: always check all_device_types and features

Even when the adapter is configured for CEC 1.4, we still check and
use the CEC 2.0 parts of struct cec_log_addrs. Although these aren't
used in CEC messages, the information contained in them is still of
use in the CEC framework itself, so keep this information.

Also zero the unused trailing features[] data and unused logical address
data so the contents isn't random data.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/cec/cec-adap.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index 3298f1b..a58165c 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -1210,13 +1210,8 @@ int __cec_s_log_addrs(struct cec_adapter *adap,
 				return -EINVAL;
 			}

-	if (log_addrs->cec_version < CEC_OP_CEC_VERSION_2_0) {
-		memset(log_addrs->all_device_types, 0,
-		       sizeof(log_addrs->all_device_types));
-		memset(log_addrs->features, 0, sizeof(log_addrs->features));
-	}
-
 	for (i = 0; i < log_addrs->num_log_addrs; i++) {
+		const u8 feature_sz = ARRAY_SIZE(log_addrs->features[0]);
 		u8 *features = log_addrs->features[i];
 		bool op_is_dev_features = false;

@@ -1245,21 +1240,19 @@ int __cec_s_log_addrs(struct cec_adapter *adap,
 			dprintk(1, "unknown logical address type\n");
 			return -EINVAL;
 		}
-		if (log_addrs->cec_version < CEC_OP_CEC_VERSION_2_0)
-			continue;
-
-		for (i = 0; i < ARRAY_SIZE(log_addrs->features[0]); i++) {
+		for (i = 0; i < feature_sz; i++) {
 			if ((features[i] & 0x80) == 0) {
 				if (op_is_dev_features)
 					break;
 				op_is_dev_features = true;
 			}
 		}
-		if (!op_is_dev_features ||
-		    i == ARRAY_SIZE(log_addrs->features[0])) {
+		if (!op_is_dev_features || i == feature_sz) {
 			dprintk(1, "malformed features\n");
 			return -EINVAL;
 		}
+		/* Zero unused part of the feature array */
+		memset(features + i, 0, feature_sz - i);
 	}

 	if (log_addrs->cec_version >= CEC_OP_CEC_VERSION_2_0) {
@@ -1281,6 +1274,15 @@ int __cec_s_log_addrs(struct cec_adapter *adap,
 		}
 	}

+	/* Zero unused LAs */
+	for (i = log_addrs->num_log_addrs; i < CEC_MAX_LOG_ADDRS; i++) {
+		log_addrs->primary_device_type[i] = 0;
+		log_addrs->log_addr_type[i] = 0;
+		log_addrs->all_device_types[i] = 0;
+		memset(log_addrs->features[i], 0,
+		       sizeof(log_addrs->features[i]));
+	}
+
 	log_addrs->log_addr_mask = adap->log_addrs.log_addr_mask;
 	adap->log_addrs = *log_addrs;
 	if (adap->phys_addr != CEC_PHYS_ADDR_INVALID)
-- 
2.8.1

