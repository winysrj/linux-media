Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:41967 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751093AbcGQPCq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 11:02:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/7] cec: zero unused msg part after msg->len
Date: Sun, 17 Jul 2016 17:02:31 +0200
Message-Id: <1468767754-48542-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1468767754-48542-1-git-send-email-hverkuil@xs4all.nl>
References: <1468767754-48542-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Ensure that the unused part of the msg array is zeroed. This is
required by CEC 2.0 when receiving shorter messages than expected.
In that case the remaining bytes are assumed to be 0.

There are no such CEC messages yet, but it is required to be future proof.

And since we're doing it for received messages, do it for transmitted
messages as well. It's unambiguous this way.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/cec/cec-adap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index 2b34c0f..cd39a9a 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -601,6 +601,7 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 		dprintk(1, "cec_transmit_msg: can't reply for poll msg\n");
 		return -EINVAL;
 	}
+	memset(msg->msg + msg->len, 0, sizeof(msg->msg) - msg->len);
 	if (msg->len == 1) {
 		if (cec_msg_initiator(msg) != 0xf ||
 		    cec_msg_destination(msg) == 0xf) {
@@ -771,6 +772,7 @@ void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg)
 	msg->tx_status = 0;
 	msg->tx_ts = 0;
 	msg->flags = 0;
+	memset(msg->msg + msg->len, 0, sizeof(msg->msg) - msg->len);
 
 	mutex_lock(&adap->lock);
 	dprintk(2, "cec_received_msg: %*ph\n", msg->len, msg->msg);
-- 
2.8.1

