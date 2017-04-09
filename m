Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35845 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752322AbdDITid (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Apr 2017 15:38:33 -0400
Received: by mail-wm0-f67.google.com with SMTP id q125so6399346wmd.3
        for <linux-media@vger.kernel.org>; Sun, 09 Apr 2017 12:38:32 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: aospan@netup.ru, serjk@netup.ru, mchehab@kernel.org,
        linux-media@vger.kernel.org
Cc: rjkm@metzlerbros.de
Subject: [PATCH 01/19] [media] dvb-frontends/cxd2841er: remove kernel log spam in non-debug levels
Date: Sun,  9 Apr 2017 21:38:10 +0200
Message-Id: <20170409193828.18458-2-d.scheller.oss@gmail.com>
In-Reply-To: <20170409193828.18458-1-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

This moves the I2C debug dump into the preceding dev_dbg() call by
utilising the %*ph format macro and removes the call to
print_hex_debug_bytes().

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/cxd2841er.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 614bfb3..60d85ce 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -214,10 +214,8 @@ static void cxd2841er_i2c_debug(struct cxd2841er_priv *priv,
 				const u8 *data, u32 len)
 {
 	dev_dbg(&priv->i2c->dev,
-		"cxd2841er: I2C %s addr %02x reg 0x%02x size %d\n",
-		(write == 0 ? "read" : "write"), addr, reg, len);
-	print_hex_dump_bytes("cxd2841er: I2C data: ",
-		DUMP_PREFIX_OFFSET, data, len);
+		"cxd2841er: I2C %s addr %02x reg 0x%02x size %d data %*ph\n",
+		(write == 0 ? "read" : "write"), addr, reg, len, len, data);
 }
 
 static int cxd2841er_write_regs(struct cxd2841er_priv *priv,
-- 
2.10.2
