Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:45514 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751563AbcLJJoQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Dec 2016 04:44:16 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH for v4.10 3/6] cec: update log_addr[] before finishing configuration
Date: Sat, 10 Dec 2016 10:44:10 +0100
Message-Id: <20161210094413.8832-4-hverkuil@xs4all.nl>
In-Reply-To: <20161210094413.8832-1-hverkuil@xs4all.nl>
References: <20161210094413.8832-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

The loop that sets the unused logical addresses to INVALID should be
done before 'configured' is set to true. This ensures that cec_log_addrs
is consistent before it will be used.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/media/cec/cec-adap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index c05956f..f3fef48 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1250,6 +1250,8 @@ static int cec_config_thread_func(void *arg)
 		for (i = 1; i < las->num_log_addrs; i++)
 			las->log_addr[i] = CEC_LOG_ADDR_INVALID;
 	}
+	for (i = las->num_log_addrs; i < CEC_MAX_LOG_ADDRS; i++)
+		las->log_addr[i] = CEC_LOG_ADDR_INVALID;
 	adap->is_configured = true;
 	adap->is_configuring = false;
 	cec_post_state_event(adap);
@@ -1268,8 +1270,6 @@ static int cec_config_thread_func(void *arg)
 			cec_report_features(adap, i);
 		cec_report_phys_addr(adap, i);
 	}
-	for (i = las->num_log_addrs; i < CEC_MAX_LOG_ADDRS; i++)
-		las->log_addr[i] = CEC_LOG_ADDR_INVALID;
 	mutex_lock(&adap->lock);
 	adap->kthread_config = NULL;
 	mutex_unlock(&adap->lock);
-- 
2.10.2

