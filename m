Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:57525 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753508AbcHXImh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Aug 2016 04:42:37 -0400
Received: from [10.47.79.81] ([10.47.79.81])
        (authenticated bits=0)
        by aer-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id u7O8arYb029238
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
        for <linux-media@vger.kernel.org>; Wed, 24 Aug 2016 08:36:54 GMT
To: linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH for v4.8] cec: don't Feature Abort broadcast msgs when
 unregistered
Message-ID: <57BD5CA5.9040102@cisco.com>
Date: Wed, 24 Aug 2016 10:36:53 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the adapter is configured as 'Unregistered', then cec_receive_notify incorrectly
thinks that broadcast messages are directed messages. The destination for broadcast
messages is 0xf, and the logical address assigned to Unregistered devices is also
0xf and the logic didn't handle that correctly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index b2393bb..51bb581 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -1398,7 +1398,6 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 	u8 init_laddr = cec_msg_initiator(msg);
 	u8 devtype = cec_log_addr2dev(adap, dest_laddr);
 	int la_idx = cec_log_addr2idx(adap, dest_laddr);
-	bool is_directed = la_idx >= 0;
 	bool from_unregistered = init_laddr == 0xf;
 	struct cec_msg tx_cec_msg = { };

@@ -1560,7 +1559,7 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 		 * Unprocessed messages are aborted if userspace isn't doing
 		 * any processing either.
 		 */
-		if (is_directed && !is_reply && !adap->follower_cnt &&
+		if (!is_broadcast && !is_reply && !adap->follower_cnt &&
 		    !adap->cec_follower && msg->msg[1] != CEC_MSG_FEATURE_ABORT)
 			return cec_feature_abort(adap, msg);
 		break;
