Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:52116 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753343AbcKBMqj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Nov 2016 08:46:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 04/11] cec: add CEC_MSG_FL_REPLY_TO_FOLLOWERS
Date: Wed,  2 Nov 2016 13:46:28 +0100
Message-Id: <20161102124635.11989-5-hverkuil@xs4all.nl>
In-Reply-To: <20161102124635.11989-1-hverkuil@xs4all.nl>
References: <20161102124635.11989-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Give the caller more control over how replies to a transmit are
handled. By default the reply will only go to the filehandle that
called CEC_TRANSMIT. If this new flag is set, then the reply will
also go to all followers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/cec/cec-ioc-receive.rst | 22 +++++++++++++++++++++-
 drivers/staging/media/cec/TODO                   |  4 ----
 drivers/staging/media/cec/cec-adap.c             |  6 +++---
 drivers/staging/media/cec/cec-api.c              |  1 +
 include/linux/cec.h                              |  5 ++++-
 5 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index 21a88df..b4dffd2 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -119,7 +119,7 @@ result.
 	transmit.
     * - __u32
       - ``flags``
-      - Flags. No flags are defined yet, so set this to 0.
+      - Flags. See :ref:`cec-msg-flags` for a list of available flags.
     * - __u8
       - ``tx_status``
       - The status bits of the transmitted message. See
@@ -180,6 +180,26 @@ result.
 	valid if the :ref:`CEC_TX_STATUS_ERROR <CEC-TX-STATUS-ERROR>` status bit is set.
 
 
+.. _cec-msg-flags:
+
+.. flat-table:: Flags for struct cec_msg
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       3 1 4
+
+    * .. _`CEC-MSG-FL-REPLY-TO-FOLLOWERS`:
+
+      - ``CEC_MSG_FL_REPLY_TO_FOLLOWERS``
+      - 1
+      - If a CEC transmit expects a reply, then by default that reply is only sent to
+	the filehandle that called :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>`. If this
+	flag is set, then the reply is also sent to all followers, if any. If the
+	filehandle that called :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>` is also a
+	follower, then that filehandle will receive the reply twice: once as the
+	result of the :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>`, and once via
+	:ref:`ioctl CEC_RECEIVE <CEC_RECEIVE>`.
+
+
 .. tabularcolumns:: |p{5.6cm}|p{0.9cm}|p{11.0cm}|
 
 .. _cec-tx-status:
diff --git a/drivers/staging/media/cec/TODO b/drivers/staging/media/cec/TODO
index 0841206..ce69001 100644
--- a/drivers/staging/media/cec/TODO
+++ b/drivers/staging/media/cec/TODO
@@ -13,10 +13,6 @@ Hopefully this will happen later in 2016.
 Other TODOs:
 
 - There are two possible replies to CEC_MSG_INITIATE_ARC. How to handle that?
-- If the reply field of cec_msg is set then when the reply arrives it
-  is only sent to the filehandle that transmitted the original message
-  and not to any followers. Should this behavior change or perhaps
-  controlled through a cec_msg flag?
 - Should CEC_LOG_ADDR_TYPE_SPECIFIC be replaced by TYPE_2ND_TV and TYPE_PROCESSOR?
   And also TYPE_SWITCH and TYPE_CDC_ONLY in addition to the TYPE_UNREGISTERED?
   This should give the framework more information about the device type
diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index 589e457..6aceb1d 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -587,7 +587,6 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 	msg->tx_nack_cnt = 0;
 	msg->tx_low_drive_cnt = 0;
 	msg->tx_error_cnt = 0;
-	msg->flags = 0;
 	msg->sequence = ++adap->sequence;
 	if (!msg->sequence)
 		msg->sequence = ++adap->sequence;
@@ -823,6 +822,7 @@ void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg)
 			dst->rx_status = msg->rx_status;
 			if (abort)
 				dst->rx_status |= CEC_RX_STATUS_FEATURE_ABORT;
+			msg->flags = dst->flags;
 			/* Remove it from the wait_queue */
 			list_del_init(&data->list);
 
@@ -1575,8 +1575,8 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 	}
 
 skip_processing:
-	/* If this was a reply, then we're done */
-	if (is_reply)
+	/* If this was a reply, then we're done, unless otherwise specified */
+	if (is_reply && !(msg->flags & CEC_MSG_FL_REPLY_TO_FOLLOWERS))
 		return 0;
 
 	/*
diff --git a/drivers/staging/media/cec/cec-api.c b/drivers/staging/media/cec/cec-api.c
index 040ca7d..54148a6 100644
--- a/drivers/staging/media/cec/cec-api.c
+++ b/drivers/staging/media/cec/cec-api.c
@@ -190,6 +190,7 @@ static long cec_transmit(struct cec_adapter *adap, struct cec_fh *fh,
 		return -ENOTTY;
 	if (copy_from_user(&msg, parg, sizeof(msg)))
 		return -EFAULT;
+	msg.flags &= CEC_MSG_FL_REPLY_TO_FOLLOWERS;
 	mutex_lock(&adap->lock);
 	if (!adap->is_configured)
 		err = -ENONET;
diff --git a/include/linux/cec.h b/include/linux/cec.h
index 825455f..3f2f076 100644
--- a/include/linux/cec.h
+++ b/include/linux/cec.h
@@ -175,7 +175,10 @@ static inline void cec_msg_set_reply_to(struct cec_msg *msg,
 	msg->reply = msg->timeout = 0;
 }
 
-/* cec status field */
+/* cec_msg flags field */
+#define CEC_MSG_FL_REPLY_TO_FOLLOWERS	(1 << 0)
+
+/* cec_msg tx/rx_status field */
 #define CEC_TX_STATUS_OK		(1 << 0)
 #define CEC_TX_STATUS_ARB_LOST		(1 << 1)
 #define CEC_TX_STATUS_NACK		(1 << 2)
-- 
2.10.1

