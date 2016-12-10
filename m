Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:51205 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751359AbcLJJoQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Dec 2016 04:44:16 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH for v4.10 1/6] cec: when canceling a message, don't overwrite old status info
Date: Sat, 10 Dec 2016 10:44:08 +0100
Message-Id: <20161210094413.8832-2-hverkuil@xs4all.nl>
In-Reply-To: <20161210094413.8832-1-hverkuil@xs4all.nl>
References: <20161210094413.8832-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

When a pending message was canceled (e.g. due to a timeout), then the
old tx_status info was overwritten instead of ORed. The same happened
with the tx_error_cnt field. So just modify them instead of overwriting
them.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-adap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index f15f6ff..3191c0c 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -288,10 +288,10 @@ static void cec_data_cancel(struct cec_data *data)
 
 	/* Mark it as an error */
 	data->msg.tx_ts = ktime_get_ns();
-	data->msg.tx_status = CEC_TX_STATUS_ERROR |
-			      CEC_TX_STATUS_MAX_RETRIES;
+	data->msg.tx_status |= CEC_TX_STATUS_ERROR |
+			       CEC_TX_STATUS_MAX_RETRIES;
+	data->msg.tx_error_cnt++;
 	data->attempts = 0;
-	data->msg.tx_error_cnt = 1;
 	/* Queue transmitted message for monitoring purposes */
 	cec_queue_msg_monitor(data->adap, &data->msg, 1);
 
-- 
2.10.2

