Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:41943 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751737AbdB1N0f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 08:26:35 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: don't Feature Abort msgs from Unregistered
Message-ID: <9dd3b7bf-804d-fbf8-236e-146b9be1db15@xs4all.nl>
Date: Tue, 28 Feb 2017 14:24:00 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Feature Abort shouldn't be sent in reply to messages from Unregistered,
since that would make it a broadcast message.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
  drivers/media/cec/cec-adap.c | 3 +++
  1 file changed, 3 insertions(+)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 46b7da6df9b5..25d0a835921f 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1615,6 +1615,9 @@ static int cec_feature_abort_reason(struct cec_adapter *adap,
  	 */
  	if (msg->msg[1] == CEC_MSG_FEATURE_ABORT)
  		return 0;
+	/* Don't Feature Abort messages from 'Unregistered' */
+	if (cec_msg_initiator(msg) == CEC_LOG_ADDR_UNREGISTERED)
+		return 0;
  	cec_msg_set_reply_to(&tx_msg, msg);
  	cec_msg_feature_abort(&tx_msg, msg->msg[1], reason);
  	return cec_transmit_msg(adap, &tx_msg, false);
-- 
2.11.0
