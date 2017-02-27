Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:33919 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751435AbdB0OYy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 09:24:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 7/9] cec: use __func__ in log messages.
Date: Mon, 27 Feb 2017 15:20:40 +0100
Message-Id: <20170227142042.37085-8-hverkuil@xs4all.nl>
In-Reply-To: <20170227142042.37085-1-hverkuil@xs4all.nl>
References: <20170227142042.37085-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The hardcoded function name is actually wrong. Use __func__ instead.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-adap.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 78a85c44d96e..4f1e571d10b7 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -606,17 +606,17 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 
 	/* Sanity checks */
 	if (msg->len == 0 || msg->len > CEC_MAX_MSG_SIZE) {
-		dprintk(1, "cec_transmit_msg: invalid length %d\n", msg->len);
+		dprintk(1, "%s: invalid length %d\n", __func__, msg->len);
 		return -EINVAL;
 	}
 	if (msg->timeout && msg->len == 1) {
-		dprintk(1, "cec_transmit_msg: can't reply for poll msg\n");
+		dprintk(1, "%s: can't reply for poll msg\n", __func__);
 		return -EINVAL;
 	}
 	memset(msg->msg + msg->len, 0, sizeof(msg->msg) - msg->len);
 	if (msg->len == 1) {
 		if (cec_msg_destination(msg) == 0xf) {
-			dprintk(1, "cec_transmit_msg: invalid poll message\n");
+			dprintk(1, "%s: invalid poll message\n", __func__);
 			return -EINVAL;
 		}
 		if (cec_has_log_addr(adap, cec_msg_destination(msg))) {
@@ -637,13 +637,13 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 	}
 	if (msg->len > 1 && !cec_msg_is_broadcast(msg) &&
 	    cec_has_log_addr(adap, cec_msg_destination(msg))) {
-		dprintk(1, "cec_transmit_msg: destination is the adapter itself\n");
+		dprintk(1, "%s: destination is the adapter itself\n", __func__);
 		return -EINVAL;
 	}
 	if (msg->len > 1 && adap->is_configured &&
 	    !cec_has_log_addr(adap, cec_msg_initiator(msg))) {
-		dprintk(1, "cec_transmit_msg: initiator has unknown logical address %d\n",
-			cec_msg_initiator(msg));
+		dprintk(1, "%s: initiator has unknown logical address %d\n",
+			__func__, cec_msg_initiator(msg));
 		return -EINVAL;
 	}
 	if (!adap->is_configured && !adap->is_configuring &&
@@ -663,11 +663,11 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 	}
 
 	if (msg->timeout)
-		dprintk(2, "cec_transmit_msg: %*ph (wait for 0x%02x%s)\n",
-			msg->len, msg->msg, msg->reply, !block ? ", nb" : "");
+		dprintk(2, "%s: %*ph (wait for 0x%02x%s)\n",
+			__func__, msg->len, msg->msg, msg->reply, !block ? ", nb" : "");
 	else
-		dprintk(2, "cec_transmit_msg: %*ph%s\n",
-			msg->len, msg->msg, !block ? " (nb)" : "");
+		dprintk(2, "%s: %*ph%s\n",
+			__func__, msg->len, msg->msg, !block ? " (nb)" : "");
 
 	data->msg = *msg;
 	data->fh = fh;
-- 
2.11.0
