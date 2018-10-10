Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:56100 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726468AbeJJSeA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Oct 2018 14:34:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: check for non-OK/NACK conditions while claiming a LA
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <25796610-4a89-2274-e3c3-985f3e87d359@xs4all.nl>
Date: Wed, 10 Oct 2018 13:12:15 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

During the configuration phase of a CEC adapter it is trying to claim a
free logical address by polling.

However, the code doesn't check if there were errors other than OK or NACK,
those are just treated as if the poll was NACKed.

Instead check for such errors and retry the poll. And if the problem persists
then don't claim this LA since there is something weird going on.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 0c0d9107383e..7b7139991445 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1178,6 +1178,8 @@ static int cec_config_log_addr(struct cec_adapter *adap,
 {
 	struct cec_log_addrs *las = &adap->log_addrs;
 	struct cec_msg msg = { };
+	const unsigned int max_retries = 2;
+	unsigned int i;
 	int err;

 	if (cec_has_log_addr(adap, log_addr))
@@ -1186,19 +1188,44 @@ static int cec_config_log_addr(struct cec_adapter *adap,
 	/* Send poll message */
 	msg.len = 1;
 	msg.msg[0] = (log_addr << 4) | log_addr;
-	err = cec_transmit_msg_fh(adap, &msg, NULL, true);

-	/*
-	 * While trying to poll the physical address was reset
-	 * and the adapter was unconfigured, so bail out.
-	 */
-	if (!adap->is_configuring)
-		return -EINTR;
+	for (i = 0; i < max_retries; i++) {
+		err = cec_transmit_msg_fh(adap, &msg, NULL, true);

-	if (err)
-		return err;
+		/*
+		 * While trying to poll the physical address was reset
+		 * and the adapter was unconfigured, so bail out.
+		 */
+		if (!adap->is_configuring)
+			return -EINTR;
+
+		if (err)
+			return err;

-	if (msg.tx_status & CEC_TX_STATUS_OK)
+		/*
+		 * The message was aborted due to a disconnect or
+		 * unconfigure, just bail out.
+		 */
+		if (msg.tx_status & CEC_TX_STATUS_ABORTED)
+			return -EINTR;
+		if (msg.tx_status & CEC_TX_STATUS_OK)
+			return 0;
+		if (msg.tx_status & CEC_TX_STATUS_NACK)
+			break;
+		/*
+		 * Retry up to max_retries times if the message was neither
+		 * OKed or NACKed. This can happen due to e.g. a Lost
+		 * Arbitration condition.
+		 */
+	}
+
+	/*
+	 * If we are unable to get an OK or a NACK after max_retries attempts
+	 * (and note that each attempt already consists of four polls), then
+	 * then we assume that something is really weird and that it is not a
+	 * good idea to try and claim this logical address.
+	 */
+	if (i == max_retries)
 		return 0;

 	/*
