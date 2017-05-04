Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:35505 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754056AbdEDPU0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 May 2017 11:20:26 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH] [media] tc358743: fix register i2c_rd/wr function fix
Date: Thu,  4 May 2017 17:20:17 +0200
Message-Id: <20170504152017.3696-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The below mentioned fix contains a small but severe bug,
fix it to make the driver work again.

Fixes: 3538aa6ecfb2 ("[media] tc358743: fix register i2c_rd/wr functions")
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tc358743.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index acef4eca269f1..3251cba89e8f6 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -223,7 +223,7 @@ static void i2c_wr8(struct v4l2_subdev *sd, u16 reg, u8 val)
 static void i2c_wr8_and_or(struct v4l2_subdev *sd, u16 reg,
 		u8 mask, u8 val)
 {
-	i2c_wrreg(sd, reg, (i2c_rdreg(sd, reg, 2) & mask) | val, 2);
+	i2c_wrreg(sd, reg, (i2c_rdreg(sd, reg, 1) & mask) | val, 1);
 }
 
 static u16 i2c_rd16(struct v4l2_subdev *sd, u16 reg)
-- 
2.11.0
