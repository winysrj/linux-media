Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.47.9]:58500 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936859AbdCXQs2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 12:48:28 -0400
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, mchehab@kernel.org,
        linux-kernel@vger.kernel.org, Jose Abreu <Jose.Abreu@synopsys.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH 2/8] [media] staging: st-cec: Use cec_get_drvdata()
Date: Fri, 24 Mar 2017 16:47:53 +0000
Message-Id: <4630ddce3d8ca27e4f6addeda17e11b08f345a1a.1490373499.git.joabreu@synopsys.com>
In-Reply-To: <cover.1490373499.git.joabreu@synopsys.com>
References: <cover.1490373499.git.joabreu@synopsys.com>
In-Reply-To: <cover.1490373499.git.joabreu@synopsys.com>
References: <cover.1490373499.git.joabreu@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use helper function to get driver private data from CEC
adapter.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 drivers/staging/media/st-cec/stih-cec.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/st-cec/stih-cec.c b/drivers/staging/media/st-cec/stih-cec.c
index 3c25638..521206d 100644
--- a/drivers/staging/media/st-cec/stih-cec.c
+++ b/drivers/staging/media/st-cec/stih-cec.c
@@ -133,7 +133,7 @@ struct stih_cec {
 
 static int stih_cec_adap_enable(struct cec_adapter *adap, bool enable)
 {
-	struct stih_cec *cec = adap->priv;
+	struct stih_cec *cec = cec_get_drvdata(adap);
 
 	if (enable) {
 		/* The doc says (input TCLK_PERIOD * CEC_CLK_DIV) = 0.1ms */
@@ -189,7 +189,7 @@ static int stih_cec_adap_enable(struct cec_adapter *adap, bool enable)
 
 static int stih_cec_adap_log_addr(struct cec_adapter *adap, u8 logical_addr)
 {
-	struct stih_cec *cec = adap->priv;
+	struct stih_cec *cec = cec_get_drvdata(adap);
 	u32 reg = readl(cec->regs + CEC_ADDR_TABLE);
 
 	reg |= 1 << logical_addr;
@@ -205,7 +205,7 @@ static int stih_cec_adap_log_addr(struct cec_adapter *adap, u8 logical_addr)
 static int stih_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
 				  u32 signal_free_time, struct cec_msg *msg)
 {
-	struct stih_cec *cec = adap->priv;
+	struct stih_cec *cec = cec_get_drvdata(adap);
 	int i;
 
 	/* Copy message into registers */
-- 
1.9.1
