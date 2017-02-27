Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:42751 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751414AbdB0OYy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 09:24:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 8/9] cec: improve cec_transmit_msg_fh logging
Date: Mon, 27 Feb 2017 15:20:41 +0100
Message-Id: <20170227142042.37085-9-hverkuil@xs4all.nl>
In-Reply-To: <20170227142042.37085-1-hverkuil@xs4all.nl>
References: <20170227142042.37085-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Several error paths didn't log why an error was returned. Add this.

Also handle the corner case of "adapter is unconfigured AND the message
is from Unregistered to TV AND reply is non-zero" separately and return
EINVAL in that case, since it really is an invalid value and not an
unconfigured CEC device.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-adap.c | 17 +++++++++++++----
 drivers/media/cec/cec-api.c  |  2 +-
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 4f1e571d10b7..9e25ba20f4d1 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -646,12 +646,21 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 			__func__, cec_msg_initiator(msg));
 		return -EINVAL;
 	}
-	if (!adap->is_configured && !adap->is_configuring &&
-	    (msg->msg[0] != 0xf0 || msg->reply))
-		return -ENONET;
+	if (!adap->is_configured && !adap->is_configuring) {
+		if (msg->msg[0] != 0xf0) {
+			dprintk(1, "%s: adapter is unconfigured\n", __func__);
+			return -ENONET;
+		}
+		if (msg->reply) {
+			dprintk(1, "%s: invalid msg->reply\n", __func__);
+			return -EINVAL;
+		}
+	}
 
-	if (adap->transmit_queue_sz >= CEC_MAX_MSG_TX_QUEUE_SZ)
+	if (adap->transmit_queue_sz >= CEC_MAX_MSG_TX_QUEUE_SZ) {
+		dprintk(1, "%s: transmit queue full\n", __func__);
 		return -EBUSY;
+	}
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
diff --git a/drivers/media/cec/cec-api.c b/drivers/media/cec/cec-api.c
index cea350ea2a52..0860fb458757 100644
--- a/drivers/media/cec/cec-api.c
+++ b/drivers/media/cec/cec-api.c
@@ -202,7 +202,7 @@ static long cec_transmit(struct cec_adapter *adap, struct cec_fh *fh,
 		err = -EPERM;
 	else if (adap->is_configuring)
 		err = -ENONET;
-	else if (!adap->is_configured && (msg.msg[0] != 0xf0 || msg.reply))
+	else if (!adap->is_configured && msg.msg[0] != 0xf0)
 		err = -ENONET;
 	else if (cec_is_busy(adap, fh))
 		err = -EBUSY;
-- 
2.11.0
