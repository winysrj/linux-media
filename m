Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:57923 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751783AbcLJJoR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Dec 2016 04:44:17 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH for v4.10 5/6] cec: move cec_report_phys_addr into cec_config_thread_func
Date: Sat, 10 Dec 2016 10:44:12 +0100
Message-Id: <20161210094413.8832-6-hverkuil@xs4all.nl>
In-Reply-To: <20161210094413.8832-1-hverkuil@xs4all.nl>
References: <20161210094413.8832-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

It's only a small function and this makes it easier to switch to
transmitting the message with adap->lock held in the next patch.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/media/cec/cec-adap.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 2b66851..f3d4956 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -30,7 +30,6 @@
 
 #include "cec-priv.h"
 
-static int cec_report_phys_addr(struct cec_adapter *adap, unsigned int la_idx);
 static void cec_fill_msg_report_features(struct cec_adapter *adap,
 					 struct cec_msg *msg,
 					 unsigned int la_idx);
@@ -1275,7 +1274,13 @@ static int cec_config_thread_func(void *arg)
 			cec_transmit_msg(adap, &msg, false);
 		}
 
-		cec_report_phys_addr(adap, i);
+		/* Report Physical Address */
+		cec_msg_report_physical_addr(&msg, adap->phys_addr,
+					     las->primary_device_type[i]);
+		dprintk(2, "config: la %d pa %x.%x.%x.%x\n",
+			las->log_addr[i],
+			cec_phys_addr_exp(adap->phys_addr));
+		cec_transmit_msg(adap, &msg, false);
 	}
 	mutex_lock(&adap->lock);
 	adap->kthread_config = NULL;
@@ -1561,22 +1566,6 @@ static void cec_fill_msg_report_features(struct cec_adapter *adap,
 	}
 }
 
-/* Transmit the Report Physical Address message */
-static int cec_report_phys_addr(struct cec_adapter *adap, unsigned int la_idx)
-{
-	const struct cec_log_addrs *las = &adap->log_addrs;
-	struct cec_msg msg = { };
-
-	/* Report Physical Address */
-	msg.msg[0] = (las->log_addr[la_idx] << 4) | 0x0f;
-	cec_msg_report_physical_addr(&msg, adap->phys_addr,
-				     las->primary_device_type[la_idx]);
-	dprintk(2, "config: la %d pa %x.%x.%x.%x\n",
-		las->log_addr[la_idx],
-			cec_phys_addr_exp(adap->phys_addr));
-	return cec_transmit_msg(adap, &msg, false);
-}
-
 /* Transmit the Feature Abort message */
 static int cec_feature_abort_reason(struct cec_adapter *adap,
 				    struct cec_msg *msg, u8 reason)
-- 
2.10.2

