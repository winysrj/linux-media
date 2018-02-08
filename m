Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:37651 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750847AbeBHQzx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Feb 2018 11:55:53 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: improve debugging
Message-ID: <7aa5cf07-d472-ff60-5c0e-3e4bb1f10695@xs4all.nl>
Date: Thu, 8 Feb 2018 17:55:48 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cec_transmit_msg_fh() first checked the message for errors, and only after
the message was found to be valid did it log the message contents.

However, that makes it hard to associate an error in the kernel log with the
message since the message contents was never logged in that case.

So swap the order: first log the message (once some very basic checks are done),
and only after that check for errors.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 2b1e540587d6..7286f8595a90 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -711,16 +711,31 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 	else
 		msg->flags = 0;

+	if (msg->len > 1 && msg->msg[1] == CEC_MSG_CDC_MESSAGE) {
+		msg->msg[2] = adap->phys_addr >> 8;
+		msg->msg[3] = adap->phys_addr & 0xff;
+	}
+
 	/* Sanity checks */
 	if (msg->len == 0 || msg->len > CEC_MAX_MSG_SIZE) {
 		dprintk(1, "%s: invalid length %d\n", __func__, msg->len);
 		return -EINVAL;
 	}
+
+	memset(msg->msg + msg->len, 0, sizeof(msg->msg) - msg->len);
+
+	if (msg->timeout)
+		dprintk(2, "%s: %*ph (wait for 0x%02x%s)\n",
+			__func__, msg->len, msg->msg, msg->reply,
+			!block ? ", nb" : "");
+	else
+		dprintk(2, "%s: %*ph%s\n",
+			__func__, msg->len, msg->msg, !block ? " (nb)" : "");
+
 	if (msg->timeout && msg->len == 1) {
-		dprintk(1, "%s: can't reply for poll msg\n", __func__);
+		dprintk(1, "%s: can't reply to poll msg\n", __func__);
 		return -EINVAL;
 	}
-	memset(msg->msg + msg->len, 0, sizeof(msg->msg) - msg->len);
 	if (msg->len == 1) {
 		if (cec_msg_destination(msg) == 0xf) {
 			dprintk(1, "%s: invalid poll message\n", __func__);
@@ -780,19 +795,6 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 	if (!msg->sequence)
 		msg->sequence = ++adap->sequence;

-	if (msg->len > 1 && msg->msg[1] == CEC_MSG_CDC_MESSAGE) {
-		msg->msg[2] = adap->phys_addr >> 8;
-		msg->msg[3] = adap->phys_addr & 0xff;
-	}
-
-	if (msg->timeout)
-		dprintk(2, "%s: %*ph (wait for 0x%02x%s)\n",
-			__func__, msg->len, msg->msg, msg->reply,
-			!block ? ", nb" : "");
-	else
-		dprintk(2, "%s: %*ph%s\n",
-			__func__, msg->len, msg->msg, !block ? " (nb)" : "");
-
 	data->msg = *msg;
 	data->fh = fh;
 	data->adap = adap;
