Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:32947 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753358AbdGKLUZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 07:20:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Eric Anholt <eric@anholt.net>, dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/4] cec: be smarter about detecting the number of attempts made
Date: Tue, 11 Jul 2017 13:20:18 +0200
Message-Id: <20170711112021.38525-2-hverkuil@xs4all.nl>
In-Reply-To: <20170711112021.38525-1-hverkuil@xs4all.nl>
References: <20170711112021.38525-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Some hardware does more than one attempt. So when it calls
cec_transmit_done when an error occurred it will e.g. use an error count
of 2 instead of 1.

The framework always assumed a single attempt, but now it is smarter
and will sum the counters to detect how many attempts were made.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-adap.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index bf45977b2823..e9284dbdc880 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -472,9 +472,14 @@ void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
 {
 	struct cec_data *data;
 	struct cec_msg *msg;
+	unsigned int attempts_made = arb_lost_cnt + nack_cnt +
+				     low_drive_cnt + error_cnt;
 	u64 ts = ktime_get_ns();
 
 	dprintk(2, "%s: status %02x\n", __func__, status);
+	if (attempts_made < 1)
+		attempts_made = 1;
+
 	mutex_lock(&adap->lock);
 	data = adap->transmitting;
 	if (!data) {
@@ -507,10 +512,10 @@ void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
 	 * the hardware didn't signal that it retried itself (by setting
 	 * CEC_TX_STATUS_MAX_RETRIES), then we will retry ourselves.
 	 */
-	if (data->attempts > 1 &&
+	if (data->attempts > attempts_made &&
 	    !(status & (CEC_TX_STATUS_MAX_RETRIES | CEC_TX_STATUS_OK))) {
 		/* Retry this message */
-		data->attempts--;
+		data->attempts -= attempts_made;
 		if (msg->timeout)
 			dprintk(2, "retransmit: %*ph (attempts: %d, wait for 0x%02x)\n",
 				msg->len, msg->msg, data->attempts, msg->reply);
-- 
2.11.0
