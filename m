Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbeK2RAT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Nov 2018 12:00:19 -0500
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/68] media: cec: check for non-OK/NACK conditions while claiming a LA
Date: Thu, 29 Nov 2018 00:54:53 -0500
Message-Id: <20181129055559.159228-2-sashal@kernel.org>
In-Reply-To: <20181129055559.159228-1-sashal@kernel.org>
References: <20181129055559.159228-1-sashal@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hverkuil@xs4all.nl>

[ Upstream commit 55623b4169056d7bb493d1c6f715991f8db67302 ]

During the configuration phase of a CEC adapter it is trying to claim a
free logical address by polling.

However, the code doesn't check if there were errors other than OK or NACK,
those are just treated as if the poll was NACKed.

Instead check for such errors and retry the poll. And if the problem persists
then don't claim this LA since there is something weird going on.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/cec-adap.c | 47 ++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index dd8bad74a1f0..a537e518384b 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1167,6 +1167,8 @@ static int cec_config_log_addr(struct cec_adapter *adap,
 {
 	struct cec_log_addrs *las = &adap->log_addrs;
 	struct cec_msg msg = { };
+	const unsigned int max_retries = 2;
+	unsigned int i;
 	int err;
 
 	if (cec_has_log_addr(adap, log_addr))
@@ -1175,19 +1177,44 @@ static int cec_config_log_addr(struct cec_adapter *adap,
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
-- 
2.17.1
