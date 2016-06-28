Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:47981 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbcF1PTt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 11:19:49 -0400
Received: from [10.47.79.81] ([10.47.79.81])
	(authenticated bits=0)
	by aer-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id u5SFJTb8027817
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 28 Jun 2016 15:19:31 GMT
To: linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH] cec-adap: on reply, restore the tx_status value from
 the,transmit
Message-ID: <57729581.1030709@cisco.com>
Date: Tue, 28 Jun 2016 17:19:29 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When a reply to an earlier transmit is received, the tx_status of that
transmit needs to be restored. Otherwise the status that the transmit
was successful would be lost.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Note: this patch sits on top of the cec topic branch.
---
 drivers/staging/media/cec/cec-adap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index 5ffa839..98bdcf9 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -801,6 +801,7 @@ void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg)

 			/* We got a reply */
 			msg->sequence = dst->sequence;
+			msg->tx_status = dst->tx_status;
 			dst_reply = dst->reply;
 			*dst = *msg;
 			dst->reply = dst_reply;
-- 
2.7.0

