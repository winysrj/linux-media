Return-path: <linux-media-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34966 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab2GZGOg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 02:14:36 -0400
From: Ravi Kumar V <kumarrav@codeaurora.org>
To: mchehab@infradead.org
Cc: paul.gortmaker@windriver.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	davidb@codequrora.org, bryanh@codeaurora.org, tsoni@codeaurora.org,
	Ravi Kumar V <kumarrav@codeaurora.org>
Subject: [PATCH] media: rc: Add support to decode Remotes using NECx IR protocol
Date: Thu, 26 Jul 2012 11:44:24 +0530
Message-Id: <1343283264-25367-1-git-send-email-kumarrav@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some remotes use NECx IR protocol to send remote control key
events. Present nec decoder in rc framework is assuming to have 2
stop bits (pulse width of 560us & space width 5600us) in NECx, but in
reality NECx sends only pulse of 560us and space untill next frame.So
here we can ignore the space width in stop bit as it is variable.

Signed-off-by: Ravi Kumar V <kumarrav@codeaurora.org>
---
 drivers/media/rc/ir-nec-decoder.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 3c9431a..a3fe1c8 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -149,6 +149,10 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			break;
 
 		data->state = STATE_TRAILER_SPACE;
+
+		if (data->is_nec_x)
+			goto rc_data;
+
 		return 0;
 
 	case STATE_TRAILER_SPACE:
@@ -157,7 +161,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 
 		if (!geq_margin(ev.duration, NEC_TRAILER_SPACE, NEC_UNIT / 2))
 			break;
-
+rc_data:
 		address     = bitrev8((data->bits >> 24) & 0xff);
 		not_address = bitrev8((data->bits >> 16) & 0xff);
 		command	    = bitrev8((data->bits >>  8) & 0xff);
-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

