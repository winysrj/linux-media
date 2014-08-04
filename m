Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56224 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbaHDE3u (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Aug 2014 00:29:50 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 9/9] ddbridge: fix I2C adapter capabilities
Date: Mon,  4 Aug 2014 07:29:31 +0300
Message-Id: <1407126571-21629-9-git-send-email-crope@iki.fi>
In-Reply-To: <1407126571-21629-1-git-send-email-crope@iki.fi>
References: <1407126571-21629-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is I2C adapter, not SMBUS, which could do some simple SMBUS
operations. Report is as a I2C capable too. Wrong reported type
causes RegMap to fail write multiple registers using I2C register
address auto-increment.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/pci/ddbridge/ddbridge-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-i2c.c b/drivers/media/pci/ddbridge/ddbridge-i2c.c
index 6845d2a..121a12b 100644
--- a/drivers/media/pci/ddbridge/ddbridge-i2c.c
+++ b/drivers/media/pci/ddbridge/ddbridge-i2c.c
@@ -163,7 +163,7 @@ static int ddb_i2c_master_xfer(struct i2c_adapter *adapter,
 
 static u32 ddb_i2c_functionality(struct i2c_adapter *adap)
 {
-	return I2C_FUNC_SMBUS_EMUL;
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
 }
 
 struct i2c_algorithm ddb_i2c_algo = {
-- 
http://palosaari.fi/

