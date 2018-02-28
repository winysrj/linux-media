Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:60146 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752484AbeB1KrN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Feb 2018 05:47:13 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Thierry Reding <treding@nvidia.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for v4.16] tegra-cec: reset rx_buf_cnt when start bit detected
Message-ID: <305c2a00-ada2-7e47-201c-0c9ce892e859@xs4all.nl>
Date: Wed, 28 Feb 2018 11:47:07 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If a start bit is detected, then reset the receive buffer counter to 0.

This ensures that no stale data is in the buffer if a message is
broken off midstream due to e.g. a Low Drive condition and then
retransmitted.

The only Rx interrupts we need to listen to are RX_REGISTER_FULL (i.e.
a valid byte was received) and RX_START_BIT_DETECTED (i.e. a new
message starts and we need to reset the counter).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: <stable@vger.kernel.org>      # for v4.15 and up
---
 drivers/media/platform/tegra-cec/tegra_cec.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/tegra-cec/tegra_cec.c b/drivers/media/platform/tegra-cec/tegra_cec.c
index 92f93a880015..aba488cd0e64 100644
--- a/drivers/media/platform/tegra-cec/tegra_cec.c
+++ b/drivers/media/platform/tegra-cec/tegra_cec.c
@@ -172,16 +172,13 @@ static irqreturn_t tegra_cec_irq_handler(int irq, void *data)
 		}
 	}

-	if (status & (TEGRA_CEC_INT_STAT_RX_REGISTER_OVERRUN |
-		      TEGRA_CEC_INT_STAT_RX_BUS_ANOMALY_DETECTED |
-		      TEGRA_CEC_INT_STAT_RX_START_BIT_DETECTED |
-		      TEGRA_CEC_INT_STAT_RX_BUS_ERROR_DETECTED)) {
+	if (status & TEGRA_CEC_INT_STAT_RX_START_BIT_DETECTED) {
 		cec_write(cec, TEGRA_CEC_INT_STAT,
-			  (TEGRA_CEC_INT_STAT_RX_REGISTER_OVERRUN |
-			   TEGRA_CEC_INT_STAT_RX_BUS_ANOMALY_DETECTED |
-			   TEGRA_CEC_INT_STAT_RX_START_BIT_DETECTED |
-			   TEGRA_CEC_INT_STAT_RX_BUS_ERROR_DETECTED));
-	} else if (status & TEGRA_CEC_INT_STAT_RX_REGISTER_FULL) {
+			  TEGRA_CEC_INT_STAT_RX_START_BIT_DETECTED);
+		cec->rx_done = false;
+		cec->rx_buf_cnt = 0;
+	}
+	if (status & TEGRA_CEC_INT_STAT_RX_REGISTER_FULL) {
 		u32 v;

 		cec_write(cec, TEGRA_CEC_INT_STAT,
@@ -255,7 +252,7 @@ static int tegra_cec_adap_enable(struct cec_adapter *adap, bool enable)
 		  TEGRA_CEC_INT_MASK_TX_BUS_ANOMALY_DETECTED |
 		  TEGRA_CEC_INT_MASK_TX_FRAME_TRANSMITTED |
 		  TEGRA_CEC_INT_MASK_RX_REGISTER_FULL |
-		  TEGRA_CEC_INT_MASK_RX_REGISTER_OVERRUN);
+		  TEGRA_CEC_INT_MASK_RX_START_BIT_DETECTED);

 	cec_write(cec, TEGRA_CEC_HW_CONTROL, TEGRA_CEC_HWCTRL_TX_RX_MODE);
 	return 0;
-- 
2.14.1
