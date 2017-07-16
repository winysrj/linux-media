Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:39923 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751229AbdGPKsH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Jul 2017 06:48:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, Eric Anholt <eric@anholt.net>,
        boris.brezillon@free-electrons.com,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 1/3] cec: be smarter about detecting the number of attempts made
Date: Sun, 16 Jul 2017 12:48:02 +0200
Message-Id: <20170716104804.48308-2-hverkuil@xs4all.nl>
In-Reply-To: <20170716104804.48308-1-hverkuil@xs4all.nl>
References: <20170716104804.48308-1-hverkuil@xs4all.nl>
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
2.13.2
