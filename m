Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:40544 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbdINPXv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Sep 2017 11:23:51 -0400
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: linux-media@vger.kernel.org
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH v2] [media] cec: Respond to unregisterd initiators, when applicable
Date: Thu, 14 Sep 2017 16:23:38 +0100
Message-Id: <db05c77c50d32358847dc724fc8627809580d677.1505402443.git.joabreu@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Running CEC 1.4 compliance test we get the following error on test
11.1.6.2: "ERROR: The DUT did not broadcast a
<Report Physical Address> message to the unregistered device."

Fix this by letting GIVE_PHYSICAL_ADDR message respond to unregistered
device. Also, GIVE_DEVICE_VENDOR_ID and GIVE_FEATURES fall in the
same category so, respond also to these messages.

With this fix we pass CEC 1.4 official compliance.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Joao Pinto <jpinto@synopsys.com>
---
Changes from v1:
	- Also respond to GIVE_DEVICE_VENDOR_ID and GIVE_FEATURES (Hans)
	- Change commit message
---
 drivers/media/cec/cec-adap.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index dd769e4..84d1b67 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1794,12 +1794,19 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 	 */
 	switch (msg->msg[1]) {
 	case CEC_MSG_GET_CEC_VERSION:
-	case CEC_MSG_GIVE_DEVICE_VENDOR_ID:
 	case CEC_MSG_ABORT:
 	case CEC_MSG_GIVE_DEVICE_POWER_STATUS:
-	case CEC_MSG_GIVE_PHYSICAL_ADDR:
 	case CEC_MSG_GIVE_OSD_NAME:
+		/*
+		 * These messages reply with a directed message, so ignore if
+		 * the initiator is Unregistered.
+		 */
+		if (!adap->passthrough && from_unregistered)
+			return 0;
+		/* Fall through */
+	case CEC_MSG_GIVE_DEVICE_VENDOR_ID:
 	case CEC_MSG_GIVE_FEATURES:
+	case CEC_MSG_GIVE_PHYSICAL_ADDR:
 		/*
 		 * Skip processing these messages if the passthrough mode
 		 * is on.
@@ -1807,7 +1814,7 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 		if (adap->passthrough)
 			goto skip_processing;
 		/* Ignore if addressing is wrong */
-		if (is_broadcast || from_unregistered)
+		if (is_broadcast)
 			return 0;
 		break;
 
-- 
1.9.1
