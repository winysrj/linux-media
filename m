Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:45066 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757800Ab2IRJvP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 05:51:15 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <julia.lawall@lip6.fr>,
	Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv2 3/6] media: Convert struct i2c_msg initialization to C99 format
Date: Tue, 18 Sep 2012 15:20:40 +0530
Message-ID: <1347961843-9376-4-git-send-email-shubhrajyoti@ti.com>
In-Reply-To: <1347961843-9376-1-git-send-email-shubhrajyoti@ti.com>
References: <1347961843-9376-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

        Convert the struct i2c_msg initialization to C99 format. This makes
        maintaining and editing the code simpler. Also helps once other fields
        like transferred are added in future.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/media/radio/radio-tea5764.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index 6b1fae3..41de676 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -151,8 +151,11 @@ int tea5764_i2c_read(struct tea5764_device *radio)
 	u16 *p = (u16 *) &radio->regs;
 
 	struct i2c_msg msgs[1] = {
-		{ radio->i2c_client->addr, I2C_M_RD, sizeof(radio->regs),
-			(void *)&radio->regs },
+		{	.addr = radio->i2c_client->addr,
+			.flags = I2C_M_RD,
+			.len = sizeof(radio->regs),
+			.buf = (void *)&radio->regs
+		},
 	};
 	if (i2c_transfer(radio->i2c_client->adapter, msgs, 1) != 1)
 		return -EIO;
@@ -167,7 +170,12 @@ int tea5764_i2c_write(struct tea5764_device *radio)
 	struct tea5764_write_regs wr;
 	struct tea5764_regs *r = &radio->regs;
 	struct i2c_msg msgs[1] = {
-		{ radio->i2c_client->addr, 0, sizeof(wr), (void *) &wr },
+		{
+			.addr = radio->i2c_client->addr,
+			.flags = 0,
+			.len = sizeof(wr),
+			.buf = (void *)&wr
+		},
 	};
 	wr.intreg  = r->intreg & 0xff;
 	wr.frqset  = __cpu_to_be16(r->frqset);
-- 
1.7.5.4

