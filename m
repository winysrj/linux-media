Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:40218 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751776AbdHaQ4M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 12:56:12 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Sylwester Nawrocki <snawrocki@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] s5p-cec: add NACK detection support
Message-ID: <6ab242a3-ce49-ff45-4fb1-545911d4330f@xs4all.nl>
Date: Thu, 31 Aug 2017 18:56:10 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The s5p-cec driver returned CEC_TX_STATUS_ERROR for the NACK condition.

Some digging into the datasheet uncovered the S5P_CEC_TX_STAT1 register where
bit 0 indicates if the transmit was nacked or not.

Use this to return the correct CEC_TX_STATUS_NACK status to userspace.

This was the only driver that couldn't tell a NACK from another error, and
that was very unusual. And a potential problem for applications as well.

Tested with my Odroid-U3.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/platform/s5p-cec/exynos_hdmi_cecctrl.c b/drivers/media/platform/s5p-cec/exynos_hdmi_cecctrl.c
index 1edf667d562a..146ae6f25cdb 100644
--- a/drivers/media/platform/s5p-cec/exynos_hdmi_cecctrl.c
+++ b/drivers/media/platform/s5p-cec/exynos_hdmi_cecctrl.c
@@ -172,7 +172,8 @@ u32 s5p_cec_get_status(struct s5p_cec_dev *cec)
 {
 	u32 status = 0;

-	status = readb(cec->reg + S5P_CEC_STATUS_0);
+	status = readb(cec->reg + S5P_CEC_STATUS_0) & 0xf;
+	status |= (readb(cec->reg + S5P_CEC_TX_STAT1) & 0xf) << 4;
 	status |= readb(cec->reg + S5P_CEC_STATUS_1) << 8;
 	status |= readb(cec->reg + S5P_CEC_STATUS_2) << 16;
 	status |= readb(cec->reg + S5P_CEC_STATUS_3) << 24;
diff --git a/drivers/media/platform/s5p-cec/s5p_cec.c b/drivers/media/platform/s5p-cec/s5p_cec.c
index 9f92e90b99fc..316736610f2d 100644
--- a/drivers/media/platform/s5p-cec/s5p_cec.c
+++ b/drivers/media/platform/s5p-cec/s5p_cec.c
@@ -92,7 +92,10 @@ static irqreturn_t s5p_cec_irq_handler(int irq, void *priv)
 	dev_dbg(cec->dev, "irq received\n");

 	if (status & CEC_STATUS_TX_DONE) {
-		if (status & CEC_STATUS_TX_ERROR) {
+		if (status & CEC_STATUS_TX_NACK) {
+			dev_dbg(cec->dev, "CEC_STATUS_TX_NACK set\n");
+			cec->tx = STATE_NACK;
+		} else if (status & CEC_STATUS_TX_ERROR) {
 			dev_dbg(cec->dev, "CEC_STATUS_TX_ERROR set\n");
 			cec->tx = STATE_ERROR;
 		} else {
@@ -135,6 +138,12 @@ static irqreturn_t s5p_cec_irq_handler_thread(int irq, void *priv)
 		cec_transmit_done(cec->adap, CEC_TX_STATUS_OK, 0, 0, 0, 0);
 		cec->tx = STATE_IDLE;
 		break;
+	case STATE_NACK:
+		cec_transmit_done(cec->adap,
+			CEC_TX_STATUS_MAX_RETRIES | CEC_TX_STATUS_NACK,
+			0, 1, 0, 0);
+		cec->tx = STATE_IDLE;
+		break;
 	case STATE_ERROR:
 		cec_transmit_done(cec->adap,
 			CEC_TX_STATUS_MAX_RETRIES | CEC_TX_STATUS_ERROR,
diff --git a/drivers/media/platform/s5p-cec/s5p_cec.h b/drivers/media/platform/s5p-cec/s5p_cec.h
index 7015845c1caa..fd6804370d98 100644
--- a/drivers/media/platform/s5p-cec/s5p_cec.h
+++ b/drivers/media/platform/s5p-cec/s5p_cec.h
@@ -36,6 +36,7 @@
 #define CEC_STATUS_TX_TRANSFERRING	(1 << 1)
 #define CEC_STATUS_TX_DONE		(1 << 2)
 #define CEC_STATUS_TX_ERROR		(1 << 3)
+#define CEC_STATUS_TX_NACK		(1 << 4)
 #define CEC_STATUS_TX_BYTES		(0xFF << 8)
 #define CEC_STATUS_RX_RUNNING		(1 << 16)
 #define CEC_STATUS_RX_RECEIVING		(1 << 17)
@@ -56,6 +57,7 @@ enum cec_state {
 	STATE_IDLE,
 	STATE_BUSY,
 	STATE_DONE,
+	STATE_NACK,
 	STATE_ERROR
 };
