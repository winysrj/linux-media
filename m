Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:49865 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751735AbdGaLo1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Jul 2017 07:44:27 -0400
From: Rene Hickersberger <renehickersberger@gmx.net>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Rene Hickersberger <renehickersberger@gmx.net>
Subject: [PATCH] Staging: media: atomisp: i2c: gc0310: fixed brace coding style issue
Date: Mon, 31 Jul 2017 13:43:15 +0200
Message-Id: <20170731114315.8128-1-renehickersberger@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed a brace coding style issue.

Signed-off-by: Rene Hickersberger <renehickersberger@gmx.net>
---
 drivers/staging/media/atomisp/i2c/gc0310.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/gc0310.c b/drivers/staging/media/atomisp/i2c/gc0310.c
index 1ec616a..bec0c46 100644
--- a/drivers/staging/media/atomisp/i2c/gc0310.c
+++ b/drivers/staging/media/atomisp/i2c/gc0310.c
@@ -118,9 +118,8 @@ static int gc0310_write_reg(struct i2c_client *client, u16 data_length,
 	/* high byte goes out first */
 	*wreg = (u8)(reg & 0xff);
 
-	if (data_length == GC0310_8BIT) {
+	if (data_length == GC0310_8BIT)
 		data[1] = (u8)(val);
-	}
 
 	ret = gc0310_i2c_write(client, len, data);
 	if (ret)
-- 
2.9.3
