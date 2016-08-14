Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:53786 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752821AbcHNKHA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2016 06:07:00 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for v4.8] cec: ignore messages when log_addr_mask == 0
Message-ID: <7771a407-4982-7a70-0a36-24bcb75252ac@xs4all.nl>
Date: Sun, 14 Aug 2016 12:06:55 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most CEC adapters will still receive broadcast messages, even if no logical
addresses are claimed. But those messages should only be passed on for
monitoring purposes, but not for processing by either kernel or userspace
if userspace didn't call CEC_ADAP_S_LOG_ADDRS first.

So if adap->log_addrs.log_addr_mask is 0, then just return before passing
the received message on to the processing code.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/cec/cec-adap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index ae0d1ee..43caddf 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -851,6 +851,9 @@ void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg)
 	if (!valid_la || msg->len <= 1)
 		return;

+	if (adap->log_addrs.log_addr_mask == 0)
+		return;
+
 	/*
 	 * Process the message on the protocol level. If is_reply is true,
 	 * then cec_receive_notify() won't pass on the reply to the listener(s)
-- 
2.8.1

