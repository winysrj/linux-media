Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:39487 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752882AbeEVLdR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 07:33:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] cec: fix wrong tx/rx_status values when canceling a msg
Date: Tue, 22 May 2018 13:33:13 +0200
Message-Id: <20180522113314.14666-2-hverkuil@xs4all.nl>
In-Reply-To: <20180522113314.14666-1-hverkuil@xs4all.nl>
References: <20180522113314.14666-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

When a message was canceled it could return tx_status with
both OK and MAX_RETRIES set, which is illegal.

If a canceled message was waiting for a reply, then rx_status
wasn't updated, so set that as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-adap.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 002ed4c90371..b7fad0ec5710 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -339,12 +339,19 @@ static void cec_data_cancel(struct cec_data *data)
 			data->adap->transmit_queue_sz--;
 	}
 
-	/* Mark it as an error */
-	data->msg.tx_ts = ktime_get_ns();
-	data->msg.tx_status |= CEC_TX_STATUS_ERROR |
-			       CEC_TX_STATUS_MAX_RETRIES;
-	data->msg.tx_error_cnt++;
-	data->attempts = 0;
+	if (data->msg.tx_status & CEC_TX_STATUS_OK) {
+		/* Mark the canceled RX as a timeout */
+		data->msg.rx_ts = ktime_get_ns();
+		data->msg.rx_status = CEC_RX_STATUS_TIMEOUT;
+	} else {
+		/* Mark the canceled TX as an error */
+		data->msg.tx_ts = ktime_get_ns();
+		data->msg.tx_status |= CEC_TX_STATUS_ERROR |
+				       CEC_TX_STATUS_MAX_RETRIES;
+		data->msg.tx_error_cnt++;
+		data->attempts = 0;
+	}
+
 	/* Queue transmitted message for monitoring purposes */
 	cec_queue_msg_monitor(data->adap, &data->msg, 1);
 
-- 
2.17.0
