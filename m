Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:56351 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753126AbcKDJvr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Nov 2016 05:51:47 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: sanitize msg.flags
Message-ID: <d47ea262-0bf4-9a3d-75e3-d852ebe9d6da@xs4all.nl>
Date: Fri, 4 Nov 2016 10:51:43 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CEC_MSG_FL_REPLY_TO_FOLLOWERS message flag only makes sense for 
transmitted
messages where you want to wait for the reply.

Clear the flag in all other cases.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 054cd06..bcd19d4 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -595,6 +595,10 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, 
struct cec_msg *msg,
  		/* Make sure the timeout isn't 0. */
  		msg->timeout = 1000;
  	}
+	if (msg->timeout)
+		msg->flags &= CEC_MSG_FL_REPLY_TO_FOLLOWERS;
+	else
+		msg->flags = 0;

  	/* Sanity checks */
  	if (msg->len == 0 || msg->len > CEC_MAX_MSG_SIZE) {
diff --git a/drivers/media/cec/cec-api.c b/drivers/media/cec/cec-api.c
index d4bc4ee..597fbb6 100644
--- a/drivers/media/cec/cec-api.c
+++ b/drivers/media/cec/cec-api.c
@@ -197,7 +197,6 @@ static long cec_transmit(struct cec_adapter *adap, 
struct cec_fh *fh,
  	    (msg.len == 1 || msg.msg[1] != CEC_MSG_CDC_MESSAGE))
  		return -EINVAL;

-	msg.flags &= CEC_MSG_FL_REPLY_TO_FOLLOWERS;
  	mutex_lock(&adap->lock);
  	if (!adap->is_configured)
  		err = -ENONET;
@@ -282,6 +281,7 @@ static long cec_receive(struct cec_adapter *adap, 
struct cec_fh *fh,
  	err = cec_receive_msg(fh, &msg, block);
  	if (err)
  		return err;
+	msg.flags = 0;
  	if (copy_to_user(parg, &msg, sizeof(msg)))
  		return -EFAULT;
  	return 0;
