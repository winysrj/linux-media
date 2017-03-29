Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36668 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932160AbdC2Qn2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 12:43:28 -0400
Received: by mail-wr0-f195.google.com with SMTP id k6so3304060wre.3
        for <linux-media@vger.kernel.org>; Wed, 29 Mar 2017 09:43:26 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org
Cc: liplianin@netup.ru, rjkm@metzlerbros.de, crope@iki.fi
Subject: [PATCH v3 12/13] [media] ddbridge: add i2c_read_regs()
Date: Wed, 29 Mar 2017 18:43:12 +0200
Message-Id: <20170329164313.14636-13-d.scheller.oss@gmail.com>
In-Reply-To: <20170329164313.14636-1-d.scheller.oss@gmail.com>
References: <20170329164313.14636-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Adds new i2c_read_regs() function and make i2c_read_reg() wrap into this
with len=1. Required for the tuner_tda18212_ping() and XO2 handling
functions (part of the Sony CXD28xx support patch series).

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 340cff0..acb9cbe 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -54,15 +54,21 @@ static int i2c_read(struct i2c_adapter *adapter, u8 adr, u8 *val)
 	return (i2c_transfer(adapter, msgs, 1) == 1) ? 0 : -1;
 }
 
-static int i2c_read_reg(struct i2c_adapter *adapter, u8 adr, u8 reg, u8 *val)
+static int i2c_read_regs(struct i2c_adapter *adapter,
+			 u8 adr, u8 reg, u8 *val, u8 len)
 {
 	struct i2c_msg msgs[2] = {{.addr = adr,  .flags = 0,
 				   .buf  = &reg, .len   = 1 },
 				  {.addr = adr,  .flags = I2C_M_RD,
-				   .buf  = val,  .len   = 1 } };
+				   .buf  = val,  .len   = len } };
 	return (i2c_transfer(adapter, msgs, 2) == 2) ? 0 : -1;
 }
 
+static int i2c_read_reg(struct i2c_adapter *adapter, u8 adr, u8 reg, u8 *val)
+{
+	return i2c_read_regs(adapter, adr, reg, val, 1);
+}
+
 static int i2c_read_reg16(struct i2c_adapter *adapter, u8 adr,
 			  u16 reg, u8 *val)
 {
-- 
2.10.2
