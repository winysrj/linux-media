Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:56287 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753376AbcKBMqj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Nov 2016 08:46:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 06/11] cec: accept two replies for CEC_MSG_INITIATE_ARC.
Date: Wed,  2 Nov 2016 13:46:30 +0100
Message-Id: <20161102124635.11989-7-hverkuil@xs4all.nl>
In-Reply-To: <20161102124635.11989-1-hverkuil@xs4all.nl>
References: <20161102124635.11989-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The CEC_MSG_INITIATE_ARC message is special since it is the ONLY
CEC message that accepts two possible valid replies:

CEC_MSG_REPORT_ARC_INITIATED and CEC_MSG_REPORT_ARC_TERMINATED.

So if the transmitted message is CEC_MSG_INITIATE_ARC and the remote
side replied with CEC_MSG_REPORT_ARC_INITIATED or CEC_MSG_REPORT_ARC_TERMINATED,
then a msg->reply value of CEC_MSG_REPORT_ARC_INITIATED or
CEC_MSG_REPORT_ARC_TERMINATED will match either reply.

I thought about either adding a second reply2 field, but that's ugly
for all other messages that have only one reply, and what if in the
future a new message is added that can have three replies?

Another option would be to add a cec_msg flag, but really, the combination
of CEC_MSG_REPORT_ARC_INITIATED and a reply value of one of the two
possible replies already functions as a flag.

Another advantage of this approach is that it is safe to re-use a
cec_msg struct. No need to zero a flags field or a reply2 field.

So since this really is an exception in the CEC specification, I
decided to implement it as an exception as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/cec/cec-ioc-receive.rst |  8 ++++++++
 drivers/staging/media/cec/TODO                   | 15 +--------------
 drivers/staging/media/cec/cec-adap.c             | 12 ++++++++++++
 3 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index b4dffd2..bdf015b 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -142,6 +142,14 @@ result.
 	Feature Abort reply. In this case ``rx_status`` will either be set
 	to :ref:`CEC_RX_STATUS_TIMEOUT <CEC-RX-STATUS-TIMEOUT>` or
 	:ref:`CEC_RX_STATUS_FEATURE_ABORT <CEC-RX-STATUS-FEATURE-ABORT>`.
+
+	If the transmitter message is ``CEC_MSG_INITIATE_ARC`` then the ``reply``
+	values ``CEC_MSG_REPORT_ARC_INITIATED`` and ``CEC_MSG_REPORT_ARC_TERMINATED``
+	are processed differently: either value will match both possible replies.
+	The reason is that the ``CEC_MSG_INITIATE_ARC`` message is the only CEC
+	message that has two possible replies other than Feature Abort. The
+	``reply`` field will be updated with the actual reply so that it is
+	synchronized with the contents of the received message.
     * - __u8
       - ``rx_status``
       - The status bits of the received message. See
diff --git a/drivers/staging/media/cec/TODO b/drivers/staging/media/cec/TODO
index ce69001..5a4cfdf8 100644
--- a/drivers/staging/media/cec/TODO
+++ b/drivers/staging/media/cec/TODO
@@ -1,18 +1,5 @@
-The reason why cec.c is still in staging is that I would like
-to have a bit more confidence in the uABI. The kABI is fine,
-no problem there, but I would like to let the public API mature
-a bit.
+TODOs:
 
-Once I'm confident that I didn't miss anything then the cec.c source
-can move to drivers/media and the linux/cec.h and linux/cec-funcs.h
-headers can move to uapi/linux and added to uapi/linux/Kbuild to make
-them public.
-
-Hopefully this will happen later in 2016.
-
-Other TODOs:
-
-- There are two possible replies to CEC_MSG_INITIATE_ARC. How to handle that?
 - Should CEC_LOG_ADDR_TYPE_SPECIFIC be replaced by TYPE_2ND_TV and TYPE_PROCESSOR?
   And also TYPE_SWITCH and TYPE_CDC_ONLY in addition to the TYPE_UNREGISTERED?
   This should give the framework more information about the device type
diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index 93b53e6..a65d866 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -958,6 +958,18 @@ void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg)
 		list_for_each_entry(data, &adap->wait_queue, list) {
 			struct cec_msg *dst = &data->msg;
 
+			/*
+			 * The *only* CEC message that has two possible replies
+			 * is CEC_MSG_INITIATE_ARC.
+			 * In this case allow either of the two replies.
+			 */
+			if (!abort && dst->msg[1] == CEC_MSG_INITIATE_ARC &&
+			    (cmd == CEC_MSG_REPORT_ARC_INITIATED ||
+			     cmd == CEC_MSG_REPORT_ARC_TERMINATED) &&
+			    (dst->reply == CEC_MSG_REPORT_ARC_INITIATED ||
+			     dst->reply == CEC_MSG_REPORT_ARC_TERMINATED))
+				dst->reply = cmd;
+
 			/* Does the command match? */
 			if ((abort && cmd != dst->msg[1]) ||
 			    (!abort && cmd != dst->reply))
-- 
2.10.1

