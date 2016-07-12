Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:60200 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbcGLOKu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 10:10:50 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] cec: add sanity check for msg->len
Date: Tue, 12 Jul 2016 16:10:41 +0200
Message-Id: <1468332642-24915-2-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <1468332642-24915-1-git-send-email-hans.verkuil@cisco.com>
References: <1468332642-24915-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check (and warn) if the msg->len is too long or if it is 0.

Should never happen, but just in case...

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/cec/cec-adap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index 2cd656b..936df93 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -759,6 +759,9 @@ void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg)
 	bool is_reply = false;
 	bool valid_la = true;
 
+	if (WARN_ON(!msg->len || msg->len > CEC_MAX_MSG_SIZE))
+		return;
+
 	mutex_lock(&adap->lock);
 	msg->ts = ktime_get_ns();
 	msg->rx_status = CEC_RX_STATUS_OK;
-- 
2.7.0

