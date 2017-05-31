Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34824 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750869AbdEaJcK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 05:32:10 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: matrandg@cisco.com, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] tc358743: Handle return value of clk_prepare_enable
Date: Wed, 31 May 2017 15:01:54 +0530
Message-Id: <b9e9170128e5a3de5c8697fd1f15ee0540ddaf31.1496216367.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

clk_prepare_enable() can fail here and we must check its return value.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/i2c/tc358743.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index acef4ec..0b30f7b 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1730,7 +1730,11 @@ static int tc358743_probe_of(struct tc358743_state *state)
 
 	state->bus = endpoint->bus.mipi_csi2;
 
-	clk_prepare_enable(refclk);
+	ret = clk_prepare_enable(refclk);
+	if (ret) {
+		dev_err(dev, "Failed! to enable clock\n");
+		goto free_endpoint;
+	}
 
 	state->pdata.refclk_hz = clk_get_rate(refclk);
 	state->pdata.ddc5v_delay = DDC5V_DELAY_100_MS;
-- 
1.9.1
