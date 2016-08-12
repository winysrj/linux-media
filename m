Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:40451 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751752AbcHLJuI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2016 05:50:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH for 4.8 2/2] pulse8-cec: fix error handling
Date: Fri, 12 Aug 2016 11:49:57 +0200
Message-Id: <1470995397-47335-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1470995397-47335-1-git-send-email-hverkuil@xs4all.nl>
References: <1470995397-47335-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Support more error codes and fix a bug where MSGCODE_TRANSMIT_FAILED_LINE
was mapped to CEC_TX_STATUS_ARB_LOST, which is wrong.

Thanks to Pulse-Eight for providing me with the information needed
to handle this correctly (I hope).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/pulse8-cec/pulse8-cec.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/pulse8-cec/pulse8-cec.c b/drivers/staging/media/pulse8-cec/pulse8-cec.c
index 28f853c..ed8bd95 100644
--- a/drivers/staging/media/pulse8-cec/pulse8-cec.c
+++ b/drivers/staging/media/pulse8-cec/pulse8-cec.c
@@ -114,14 +114,11 @@ static void pulse8_irq_work_handler(struct work_struct *work)
 		cec_transmit_done(pulse8->adap, CEC_TX_STATUS_OK,
 				  0, 0, 0, 0);
 		break;
-	case MSGCODE_TRANSMIT_FAILED_LINE:
-		cec_transmit_done(pulse8->adap, CEC_TX_STATUS_ARB_LOST,
-				  1, 0, 0, 0);
-		break;
 	case MSGCODE_TRANSMIT_FAILED_ACK:
 		cec_transmit_done(pulse8->adap, CEC_TX_STATUS_NACK,
 				  0, 1, 0, 0);
 		break;
+	case MSGCODE_TRANSMIT_FAILED_LINE:
 	case MSGCODE_TRANSMIT_FAILED_TIMEOUT_DATA:
 	case MSGCODE_TRANSMIT_FAILED_TIMEOUT_LINE:
 		cec_transmit_done(pulse8->adap, CEC_TX_STATUS_ERROR,
@@ -170,6 +167,9 @@ static irqreturn_t pulse8_interrupt(struct serio *serio, unsigned char data,
 		case MSGCODE_TRANSMIT_FAILED_TIMEOUT_LINE:
 			schedule_work(&pulse8->work);
 			break;
+		case MSGCODE_HIGH_ERROR:
+		case MSGCODE_LOW_ERROR:
+		case MSGCODE_RECEIVE_FAILED:
 		case MSGCODE_TIMEOUT_ERROR:
 			break;
 		case MSGCODE_COMMAND_ACCEPTED:
-- 
2.8.1

