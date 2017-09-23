Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:54384
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751833AbdIWTnl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Sep 2017 15:43:41 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/2] media: cec-pin.h: convert comments for cec_pin_state into kernel-doc
Date: Sat, 23 Sep 2017 16:43:33 -0300
Message-Id: <b9e7680dfaec02a007ccfc883be1d95712051d1f.1506195810.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This enum is already documented, but it is not using a kernel-doc
format. Convert its format, in order to produce documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/cec-pin.h | 81 +++++++++++++++++++++++++++++++------------------
 1 file changed, 52 insertions(+), 29 deletions(-)

diff --git a/include/media/cec-pin.h b/include/media/cec-pin.h
index f09cc9579d53..3ac0e12ab237 100644
--- a/include/media/cec-pin.h
+++ b/include/media/cec-pin.h
@@ -24,65 +24,88 @@
 #include <linux/atomic.h>
 #include <media/cec.h>
 
+/**
+ * enum cec_pin_state - state of CEC pins
+ * @CEC_ST_OFF:
+ *	CEC is off
+ * @CEC_ST_IDLE:
+ *	CEC is idle, waiting for Rx or Tx
+ * @CEC_ST_TX_WAIT:
+ *	Pending Tx, waiting for Signal Free Time to expire
+ * @CEC_ST_TX_WAIT_FOR_HIGH:
+ *	Low-drive was detected, wait for bus to go high
+ * @CEC_ST_TX_START_BIT_LOW:
+ *	Drive CEC low for the start bit
+ * @CEC_ST_TX_START_BIT_HIGH:
+ *	Drive CEC high for the start bit
+ * @CEC_ST_TX_DATA_BIT_0_LOW:
+ *	Drive CEC low for the 0 bit
+ * @CEC_ST_TX_DATA_BIT_0_HIGH:
+ *	Drive CEC high for the 0 bit
+ * @CEC_ST_TX_DATA_BIT_1_LOW:
+ *	Drive CEC low for the 1 bit
+ * @CEC_ST_TX_DATA_BIT_1_HIGH:
+ *	Drive CEC high for the 1 bit
+ * @CEC_ST_TX_DATA_BIT_1_HIGH_PRE_SAMPLE:
+ *	Wait for start of sample time to check for Ack bit or first
+ *	four initiator bits to check for Arbitration Lost.
+ * @CEC_ST_TX_DATA_BIT_1_HIGH_POST_SAMPLE:
+ *	Wait for end of bit period after sampling
+ * @CEC_ST_RX_START_BIT_LOW:
+ *	Start bit low detected
+ * @CEC_ST_RX_START_BIT_HIGH:
+ *	Start bit high detected
+ * @CEC_ST_RX_DATA_SAMPLE:
+ *	Wait for bit sample time
+ * @CEC_ST_RX_DATA_POST_SAMPLE:
+ *	Wait for earliest end of bit period after sampling
+ * @CEC_ST_RX_DATA_HIGH:
+ *	Wait for CEC to go high (i.e. end of bit period
+ * @CEC_ST_RX_ACK_LOW:
+ *	Drive CEC low to send 0 Ack bit
+ * @CEC_ST_RX_ACK_LOW_POST:
+ *	End of 0 Ack * @time:	 wait for earliest end of bit period
+ * @CEC_ST_RX_ACK_HIGH_POST:
+ *	Wait for CEC to go high (i.e. end of bit period
+ * @CEC_ST_RX_ACK_FINISH:
+ *	Wait for earliest end of bit period and end of message
+ * @CEC_ST_LOW_DRIVE:
+ *	Start low drive
+ * @CEC_ST_RX_IRQ:
+ *	Monitor pin using interrupts
+ * @CEC_PIN_STATES:
+ *	Total number of pin states
+ */
 enum cec_pin_state {
-	/* CEC is off */
 	CEC_ST_OFF,
-	/* CEC is idle, waiting for Rx or Tx */
 	CEC_ST_IDLE,
 
 	/* Tx states */
-
-	/* Pending Tx, waiting for Signal Free Time to expire */
 	CEC_ST_TX_WAIT,
-	/* Low-drive was detected, wait for bus to go high */
 	CEC_ST_TX_WAIT_FOR_HIGH,
-	/* Drive CEC low for the start bit */
 	CEC_ST_TX_START_BIT_LOW,
-	/* Drive CEC high for the start bit */
 	CEC_ST_TX_START_BIT_HIGH,
-	/* Drive CEC low for the 0 bit */
 	CEC_ST_TX_DATA_BIT_0_LOW,
-	/* Drive CEC high for the 0 bit */
 	CEC_ST_TX_DATA_BIT_0_HIGH,
-	/* Drive CEC low for the 1 bit */
 	CEC_ST_TX_DATA_BIT_1_LOW,
-	/* Drive CEC high for the 1 bit */
 	CEC_ST_TX_DATA_BIT_1_HIGH,
-	/*
-	 * Wait for start of sample time to check for Ack bit or first
-	 * four initiator bits to check for Arbitration Lost.
-	 */
 	CEC_ST_TX_DATA_BIT_1_HIGH_PRE_SAMPLE,
-	/* Wait for end of bit period after sampling */
 	CEC_ST_TX_DATA_BIT_1_HIGH_POST_SAMPLE,
 
 	/* Rx states */
-
-	/* Start bit low detected */
 	CEC_ST_RX_START_BIT_LOW,
-	/* Start bit high detected */
 	CEC_ST_RX_START_BIT_HIGH,
-	/* Wait for bit sample time */
 	CEC_ST_RX_DATA_SAMPLE,
-	/* Wait for earliest end of bit period after sampling */
 	CEC_ST_RX_DATA_POST_SAMPLE,
-	/* Wait for CEC to go high (i.e. end of bit period */
 	CEC_ST_RX_DATA_HIGH,
-	/* Drive CEC low to send 0 Ack bit */
 	CEC_ST_RX_ACK_LOW,
-	/* End of 0 Ack time, wait for earliest end of bit period */
 	CEC_ST_RX_ACK_LOW_POST,
-	/* Wait for CEC to go high (i.e. end of bit period */
 	CEC_ST_RX_ACK_HIGH_POST,
-	/* Wait for earliest end of bit period and end of message */
 	CEC_ST_RX_ACK_FINISH,
 
-	/* Start low drive */
 	CEC_ST_LOW_DRIVE,
-	/* Monitor pin using interrupts */
 	CEC_ST_RX_IRQ,
 
-	/* Total number of pin states */
 	CEC_PIN_STATES
 };
 
-- 
2.13.5
