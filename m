Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:46151 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934258AbcHNLdA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2016 07:33:00 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 3C889180AA9
	for <linux-media@vger.kernel.org>; Sun, 14 Aug 2016 13:32:55 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for v4.8] cec: set unclaimed addresses to CEC_LOG_ADDR_INVALID
Message-ID: <864a0d33-7e3f-0ca6-30d6-45fe5abbac61@xs4all.nl>
Date: Sun, 14 Aug 2016 13:32:55 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Up to 4 logical addresses can be claimed. Make sure that any
unclaimed logical addresses are set to CEC_LOG_ADDR_INVALID as
per the documentation.

Take special care in the unregistered case: when falling back to
unregistered num_log_addrs may be > 1, so mark those as invalid.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/cec/cec-adap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index f1297af..e980ac9 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -1059,6 +1059,8 @@ configured:
 		/* Fall back to unregistered */
 		las->log_addr[0] = CEC_LOG_ADDR_UNREGISTERED;
 		las->log_addr_mask = 1 << las->log_addr[0];
+		for (i = 1; i < las->num_log_addrs; i++)
+			las->log_addr[i] = CEC_LOG_ADDR_INVALID;
 	}
 	adap->is_configured = true;
 	adap->is_configuring = false;
@@ -1077,6 +1079,8 @@ configured:
 			cec_report_features(adap, i);
 		cec_report_phys_addr(adap, i);
 	}
+	for (i = las->num_log_addrs; i < CEC_MAX_LOG_ADDRS; i++)
+		las->log_addr[i] = CEC_LOG_ADDR_INVALID;
 	mutex_lock(&adap->lock);
 	adap->kthread_config = NULL;
 	mutex_unlock(&adap->lock);
-- 
2.8.1

