Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay2.synopsys.com ([198.182.60.111]:45694 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966634AbdCXQsp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 12:48:45 -0400
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, mchehab@kernel.org,
        linux-kernel@vger.kernel.org, Jose Abreu <Jose.Abreu@synopsys.com>
Subject: [PATCH 4/8] [media] i2c: adv7511: Use cec_get_drvdata()
Date: Fri, 24 Mar 2017 16:47:55 +0000
Message-Id: <6d2e79b9deb31b9c1d396d121127c98b6ab01f2d.1490373499.git.joabreu@synopsys.com>
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
 drivers/media/i2c/adv7511.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 8c9e289..ccc4786 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -734,7 +734,7 @@ static int adv7511_s_power(struct v4l2_subdev *sd, int on)
 #if IS_ENABLED(CONFIG_VIDEO_ADV7511_CEC)
 static int adv7511_cec_adap_enable(struct cec_adapter *adap, bool enable)
 {
-	struct adv7511_state *state = adap->priv;
+	struct adv7511_state *state = cec_get_drvdata(adap);
 	struct v4l2_subdev *sd = &state->sd;
 
 	if (state->i2c_cec == NULL)
@@ -769,7 +769,7 @@ static int adv7511_cec_adap_enable(struct cec_adapter *adap, bool enable)
 
 static int adv7511_cec_adap_log_addr(struct cec_adapter *adap, u8 addr)
 {
-	struct adv7511_state *state = adap->priv;
+	struct adv7511_state *state = cec_get_drvdata(adap);
 	struct v4l2_subdev *sd = &state->sd;
 	unsigned int i, free_idx = ADV7511_MAX_ADDRS;
 
@@ -824,7 +824,7 @@ static int adv7511_cec_adap_log_addr(struct cec_adapter *adap, u8 addr)
 static int adv7511_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
 				     u32 signal_free_time, struct cec_msg *msg)
 {
-	struct adv7511_state *state = adap->priv;
+	struct adv7511_state *state = cec_get_drvdata(adap);
 	struct v4l2_subdev *sd = &state->sd;
 	u8 len = msg->len;
 	unsigned int i;
-- 
1.9.1
