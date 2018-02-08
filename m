Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:42524 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750806AbeBHJmX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Feb 2018 04:42:23 -0500
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH 1/2] media: ov5645: Fix write_reg return code
Date: Thu,  8 Feb 2018 11:41:59 +0200
Message-Id: <1518082920-11309-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I2C transfer functions return number of successful operations (on success).

Do not return the received positive return code but instead return 0 on
success. The users of write_reg function already use this logic.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/i2c/ov5645.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
index d28845f..9755562 100644
--- a/drivers/media/i2c/ov5645.c
+++ b/drivers/media/i2c/ov5645.c
@@ -600,11 +600,13 @@ static int ov5645_write_reg(struct ov5645 *ov5645, u16 reg, u8 val)
 	regbuf[2] = val;
 
 	ret = i2c_master_send(ov5645->i2c_client, regbuf, 3);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(ov5645->dev, "%s: write reg error %d: reg=%x, val=%x\n",
 			__func__, ret, reg, val);
+		return ret;
+	}
 
-	return ret;
+	return 0;
 }
 
 static int ov5645_read_reg(struct ov5645 *ov5645, u16 reg, u8 *val)
-- 
2.7.4
