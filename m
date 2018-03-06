Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35085 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750817AbeCFQjT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2018 11:39:19 -0500
Received: by mail-wm0-f67.google.com with SMTP id x7so23390750wmc.0
        for <linux-media@vger.kernel.org>; Tue, 06 Mar 2018 08:39:19 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at
Subject: [PATCH 2/4] [media] ngene: add I2C_FUNC_I2C to the I2C interface functionality
Date: Tue,  6 Mar 2018 17:39:11 +0100
Message-Id: <20180306163913.1519-3-d.scheller.oss@gmail.com>
In-Reply-To: <20180306163913.1519-1-d.scheller.oss@gmail.com>
References: <20180306163913.1519-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Report I2C_FUNC_I2C in .functionality() aswell. The I2C interface can
handle this fine and even is required for all I2C client drivers that
utilise the regmap API which are used from within the ngene driver.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/pci/ngene/ngene-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ngene/ngene-i2c.c b/drivers/media/pci/ngene/ngene-i2c.c
index 3004947f300b..092d46c2a3a9 100644
--- a/drivers/media/pci/ngene/ngene-i2c.c
+++ b/drivers/media/pci/ngene/ngene-i2c.c
@@ -147,7 +147,7 @@ static int ngene_i2c_master_xfer(struct i2c_adapter *adapter,
 
 static u32 ngene_i2c_functionality(struct i2c_adapter *adap)
 {
-	return I2C_FUNC_SMBUS_EMUL;
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
 }
 
 static const struct i2c_algorithm ngene_i2c_algo = {
-- 
2.16.1
