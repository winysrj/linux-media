Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.60.111]:37311 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752028AbdINLdr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Sep 2017 07:33:47 -0400
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: linux-media@vger.kernel.org
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH] [media] cec: GIVE_PHYSICAL_ADDR should respond to unregistered device
Date: Thu, 14 Sep 2017 12:33:31 +0100
Message-Id: <73019b13e5e8d727c37ec1b99f2e746aad0a7153.1505388690.git.joabreu@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Running CEC 1.4 compliance test we get the following error on test
11.1.6.2: "ERROR: The DUT did not broadcast a
<Report Physical Address> message to the unregistered device."

Fix this by letting GIVE_PHYSICAL_ADDR message respond to unregistered
device.

With this fix we pass CEC 1.4 official compliance.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Joao Pinto <jpinto@synopsys.com>
---
 drivers/media/cec/cec-adap.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index dd769e4..48482aa 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1797,9 +1797,12 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 	case CEC_MSG_GIVE_DEVICE_VENDOR_ID:
 	case CEC_MSG_ABORT:
 	case CEC_MSG_GIVE_DEVICE_POWER_STATUS:
-	case CEC_MSG_GIVE_PHYSICAL_ADDR:
 	case CEC_MSG_GIVE_OSD_NAME:
 	case CEC_MSG_GIVE_FEATURES:
+		if (from_unregistered)
+			return 0;
+		/* Fall through */
+	case CEC_MSG_GIVE_PHYSICAL_ADDR:
 		/*
 		 * Skip processing these messages if the passthrough mode
 		 * is on.
@@ -1807,7 +1810,7 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 		if (adap->passthrough)
 			goto skip_processing;
 		/* Ignore if addressing is wrong */
-		if (is_broadcast || from_unregistered)
+		if (is_broadcast)
 			return 0;
 		break;
 
-- 
1.9.1
