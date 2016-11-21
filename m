Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:39320 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932311AbcKUPSq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Nov 2016 10:18:46 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: ignore messages that we initiated.
Message-ID: <b8d83b26-91f8-c8c8-4aa1-1c11bff5a71f@xs4all.nl>
Date: Mon, 21 Nov 2016 16:18:44 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some CEC adapters will receive messages that they initiated. Add a
check that will ignore such messages.

Most hardware behaves correctly in this respect, but I have seen
adapters that don't, so just filter this out in the framework.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
  drivers/media/cec/cec-adap.c | 15 +++++++++++++++
  1 file changed, 15 insertions(+)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index d9c6f2c..0ea4efb 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -869,6 +869,21 @@ void cec_received_msg(struct cec_adapter *adap, 
struct cec_msg *msg)
  	if (WARN_ON(!msg->len || msg->len > CEC_MAX_MSG_SIZE))
  		return;

+	/*
+	 * Some CEC adapters will receive the messages that they transmitted.
+	 * This test filters out those messages by checking if we are the
+	 * initiator, and just returning in that case.
+	 *
+	 * Note that this won't work if this is an Unregistered device.
+	 *
+	 * It is bad practice if the hardware receives the message that it
+	 * transmitted and luckily most CEC adapters behave correctly in this
+	 * respect.
+	 */
+	if (msg_init != CEC_LOG_ADDR_UNREGISTERED &&
+	    cec_has_log_addr(adap, msg_init))
+		return;
+
  	msg->rx_ts = ktime_get_ns();
  	msg->rx_status = CEC_RX_STATUS_OK;
  	msg->sequence = msg->reply = msg->timeout = 0;
-- 
2.10.2

