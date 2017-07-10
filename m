Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:33846 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753173AbdGJPMb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 11:12:31 -0400
Received: by mail-wr0-f194.google.com with SMTP id k67so25523889wrc.1
        for <linux-media@vger.kernel.org>; Mon, 10 Jul 2017 08:12:30 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, garsilva@embeddedor.com
Subject: [PATCH] [media] ddbridge: constify i2c_algorithm structure
Date: Mon, 10 Jul 2017 17:12:27 +0200
Message-Id: <20170710151227.15616-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Original patch and issue identified by Gustavo A. R. Silva
<garsilva@embeddedor.com> via [1] using Coccinelle. While at it, even
mark the struct static again since it isn't referenced anywhere else.

[1] http://www.spinics.net/lists/linux-media/msg118221.html

Cc: Gustavo A. R. Silva <garsilva@embeddedor.com>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-i2c.c b/drivers/media/pci/ddbridge/ddbridge-i2c.c
index 22b2543da4ca..3d0aefe05cec 100644
--- a/drivers/media/pci/ddbridge/ddbridge-i2c.c
+++ b/drivers/media/pci/ddbridge/ddbridge-i2c.c
@@ -212,7 +212,7 @@ static u32 ddb_i2c_functionality(struct i2c_adapter *adap)
 	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
 }
 
-struct i2c_algorithm ddb_i2c_algo = {
+static const struct i2c_algorithm ddb_i2c_algo = {
 	.master_xfer   = ddb_i2c_master_xfer,
 	.functionality = ddb_i2c_functionality,
 };
-- 
2.13.0
