Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:58509 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936880AbdCXQsh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 12:48:37 -0400
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, mchehab@kernel.org,
        linux-kernel@vger.kernel.org, Jose Abreu <Jose.Abreu@synopsys.com>
Subject: [PATCH 5/8] [media] i2c: adv7604: Use cec_get_drvdata()
Date: Fri, 24 Mar 2017 16:47:56 +0000
Message-Id: <0ed0990bceae6ed517eeb8744f4593cbeadce2ab.1490373499.git.joabreu@synopsys.com>
In-Reply-To: <cover.1490373499.git.joabreu@synopsys.com>
References: <cover.1490373499.git.joabreu@synopsys.com>
In-Reply-To: <cover.1490373499.git.joabreu@synopsys.com>
References: <cover.1490373499.git.joabreu@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use helper function to get driver private data from CEC
adapter.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index d8bf435..f1fa9ce 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2050,7 +2050,7 @@ static void adv76xx_cec_isr(struct v4l2_subdev *sd, bool *handled)
 
 static int adv76xx_cec_adap_enable(struct cec_adapter *adap, bool enable)
 {
-	struct adv76xx_state *state = adap->priv;
+	struct adv76xx_state *state = cec_get_drvdata(adap);
 	struct v4l2_subdev *sd = &state->sd;
 
 	if (!state->cec_enabled_adap && enable) {
@@ -2080,7 +2080,7 @@ static int adv76xx_cec_adap_enable(struct cec_adapter *adap, bool enable)
 
 static int adv76xx_cec_adap_log_addr(struct cec_adapter *adap, u8 addr)
 {
-	struct adv76xx_state *state = adap->priv;
+	struct adv76xx_state *state = cec_get_drvdata(adap);
 	struct v4l2_subdev *sd = &state->sd;
 	unsigned int i, free_idx = ADV76XX_MAX_ADDRS;
 
@@ -2135,7 +2135,7 @@ static int adv76xx_cec_adap_log_addr(struct cec_adapter *adap, u8 addr)
 static int adv76xx_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
 				     u32 signal_free_time, struct cec_msg *msg)
 {
-	struct adv76xx_state *state = adap->priv;
+	struct adv76xx_state *state = cec_get_drvdata(adap);
 	struct v4l2_subdev *sd = &state->sd;
 	u8 len = msg->len;
 	unsigned int i;
-- 
1.9.1
