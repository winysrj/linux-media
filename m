Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:52576 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757424Ab2IRMWw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 08:22:52 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <julia.lawall@lip6.fr>,
	Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv4 4/6] media: Convert struct i2c_msg initialization to C99 format
Date: Tue, 18 Sep 2012 17:52:34 +0530
Message-ID: <1347970956-11158-5-git-send-email-shubhrajyoti@ti.com>
In-Reply-To: <1347970956-11158-1-git-send-email-shubhrajyoti@ti.com>
References: <1347970956-11158-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert the struct i2c_msg initialization to C99 format. This makes
maintaining and editing the code simpler. Also helps once other fields
like transferred are added in future.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/media/i2c/msp3400-driver.c |   40 ++++++++++++++++++++++++++++++-----
 1 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/msp3400-driver.c b/drivers/media/i2c/msp3400-driver.c
index aeb22be..766305f 100644
--- a/drivers/media/i2c/msp3400-driver.c
+++ b/drivers/media/i2c/msp3400-driver.c
@@ -119,12 +119,31 @@ int msp_reset(struct i2c_client *client)
 	static u8 write[3]     = { I2C_MSP_DSP + 1, 0x00, 0x1e };
 	u8 read[2];
 	struct i2c_msg reset[2] = {
-		{ client->addr, I2C_M_IGNORE_NAK, 3, reset_off },
-		{ client->addr, I2C_M_IGNORE_NAK, 3, reset_on  },
+		{
+			.addr = client->addr,
+			.flags = I2C_M_IGNORE_NAK,
+			.len = 3,
+			.buf = reset_off
+		},
+		{
+			.addr = client->addr,
+			.flags = I2C_M_IGNORE_NAK,
+			.len = 3,
+			.buf = reset_on
+		},
 	};
 	struct i2c_msg test[2] = {
-		{ client->addr, 0,        3, write },
-		{ client->addr, I2C_M_RD, 2, read  },
+		{
+			.addr = client->addr,
+			.len = 3,
+			.buf = write
+		},
+		{
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = 2,
+			.buf = read
+		},
 	};
 
 	v4l_dbg(3, msp_debug, client, "msp_reset\n");
@@ -143,8 +162,17 @@ static int msp_read(struct i2c_client *client, int dev, int addr)
 	u8 write[3];
 	u8 read[2];
 	struct i2c_msg msgs[2] = {
-		{ client->addr, 0,        3, write },
-		{ client->addr, I2C_M_RD, 2, read  }
+		{
+			.addr = client->addr,
+			.len = 3,
+			.buf = write
+		},
+		{
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = 2,
+			.buf = read
+		}
 	};
 
 	write[0] = dev + 1;
-- 
1.7.5.4

