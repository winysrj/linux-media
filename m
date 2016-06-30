Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:8438 "EHLO
	aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbcF3Kg2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2016 06:36:28 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] cec-adap: prevent write to out-of-bounds array index
Date: Thu, 30 Jun 2016 12:19:33 +0200
Message-Id: <1467281973-6889-3-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <1467281973-6889-1-git-send-email-hans.verkuil@cisco.com>
References: <1467281973-6889-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CEC_MSG_REPORT_PHYSICAL_ADDR can theoretically be received from
an unregistered device, but in that case the code should not attempt
to write the received physical address to the phys_addrs array.

That would be pointless since there can be multiple unregistered
devices that report a physical address. We just ignore those.

While at it, improve the dprintk since it would attempt to read
from that array as well with the same out-of-bounds problem.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/staging/media/cec/cec-adap.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index 98bdcf9..307af43 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -1442,12 +1442,15 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 
 	switch (msg->msg[1]) {
 	/* The following messages are processed but still passed through */
-	case CEC_MSG_REPORT_PHYSICAL_ADDR:
-		adap->phys_addrs[init_laddr] =
-			(msg->msg[2] << 8) | msg->msg[3];
-		dprintk(1, "Reported physical address %04x for logical address %d\n",
-			adap->phys_addrs[init_laddr], init_laddr);
+	case CEC_MSG_REPORT_PHYSICAL_ADDR: {
+		u16 pa = (msg->msg[2] << 8) | msg->msg[3];
+
+		if (!from_unregistered)
+			adap->phys_addrs[init_laddr] = pa;
+		dprintk(1, "Reported physical address %x.%x.%x.%x for logical address %d\n",
+			cec_phys_addr_exp(pa), init_laddr);
 		break;
+	}
 
 	case CEC_MSG_USER_CONTROL_PRESSED:
 		if (!(adap->capabilities & CEC_CAP_RC))
-- 
2.7.0

