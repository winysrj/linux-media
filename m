Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:45698 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966642AbdCXQst (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 12:48:49 -0400
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, mchehab@kernel.org,
        linux-kernel@vger.kernel.org, Jose Abreu <Jose.Abreu@synopsys.com>
Subject: [PATCH 6/8] [media] i2c: adv7842: Use cec_get_drvdata()
Date: Fri, 24 Mar 2017 16:47:57 +0000
Message-Id: <943ae2eb7185a1ec2a2a9b063dcb88418e2b1fc0.1490373500.git.joabreu@synopsys.com>
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
 drivers/media/i2c/adv7842.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 2d61f0c..303effd 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -2250,7 +2250,7 @@ static void adv7842_cec_isr(struct v4l2_subdev *sd, bool *handled)
 
 static int adv7842_cec_adap_enable(struct cec_adapter *adap, bool enable)
 {
-	struct adv7842_state *state = adap->priv;
+	struct adv7842_state *state = cec_get_drvdata(adap);
 	struct v4l2_subdev *sd = &state->sd;
 
 	if (!state->cec_enabled_adap && enable) {
@@ -2279,7 +2279,7 @@ static int adv7842_cec_adap_enable(struct cec_adapter *adap, bool enable)
 
 static int adv7842_cec_adap_log_addr(struct cec_adapter *adap, u8 addr)
 {
-	struct adv7842_state *state = adap->priv;
+	struct adv7842_state *state = cec_get_drvdata(adap);
 	struct v4l2_subdev *sd = &state->sd;
 	unsigned int i, free_idx = ADV7842_MAX_ADDRS;
 
@@ -2334,7 +2334,7 @@ static int adv7842_cec_adap_log_addr(struct cec_adapter *adap, u8 addr)
 static int adv7842_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
 				     u32 signal_free_time, struct cec_msg *msg)
 {
-	struct adv7842_state *state = adap->priv;
+	struct adv7842_state *state = cec_get_drvdata(adap);
 	struct v4l2_subdev *sd = &state->sd;
 	u8 len = msg->len;
 	unsigned int i;
-- 
1.9.1
