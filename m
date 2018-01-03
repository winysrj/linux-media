Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam03on0054.outbound.protection.outlook.com ([104.47.42.54]:43985
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750997AbeACQ5Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 Jan 2018 11:57:24 -0500
From: Fabio Estevam <fabio.estevam@nxp.com>
To: <mchehab@kernel.org>
CC: <sakari.ailus@linux.intel.com>, <slongerbeam@gmail.com>,
        <linux-media@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>
Subject: [PATCH] media: ov5640: Check the return value from clk_prepare_enable()
Date: Wed, 3 Jan 2018 14:57:07 -0200
Message-ID: <1514998627-23843-1-git-send-email-fabio.estevam@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

clk_prepare_enable() may fail, so we should better check its return value
and propagate it in the case of error.

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
 drivers/media/i2c/ov5640.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index c89ed66..fd93b14 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1552,7 +1552,9 @@ static int ov5640_set_power(struct ov5640_dev *sensor, bool on)
 	int ret = 0;
 
 	if (on) {
-		clk_prepare_enable(sensor->xclk);
+		ret = clk_prepare_enable(sensor->xclk);
+		if (ret)
+			return ret;
 
 		ret = regulator_bulk_enable(OV5640_NUM_SUPPLIES,
 					    sensor->supplies);
-- 
2.7.4
