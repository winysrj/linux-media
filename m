Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:45064 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757787Ab2IRJvN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 05:51:13 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <julia.lawall@lip6.fr>,
	Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv2 5/6] media: Convert struct i2c_msg initialization to C99 format
Date: Tue, 18 Sep 2012 15:20:42 +0530
Message-ID: <1347961843-9376-6-git-send-email-shubhrajyoti@ti.com>
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
 drivers/media/radio/saa7706h.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/saa7706h.c b/drivers/media/radio/saa7706h.c
index bb953ef..97cf867 100644
--- a/drivers/media/radio/saa7706h.c
+++ b/drivers/media/radio/saa7706h.c
@@ -199,8 +199,20 @@ static int saa7706h_get_reg16(struct v4l2_subdev *sd, u16 reg)
 	u8 buf[2];
 	int err;
 	u8 regaddr[] = {reg >> 8, reg};
-	struct i2c_msg msg[] = { {client->addr, 0, sizeof(regaddr), regaddr},
-				{client->addr, I2C_M_RD, sizeof(buf), buf} };
+	struct i2c_msg msg[] = {
+					{
+						.addr = client->addr,
+						.flags = 0,
+						.len = sizeof(regaddr),
+						.buf = regaddr
+					},
+					{
+						.addr = client->addr,
+						.flags = I2C_M_RD,
+						.len = sizeof(buf),
+						.buf = buf
+					}
+				};
 
 	err = saa7706h_i2c_transfer(client, msg, ARRAY_SIZE(msg));
 	if (err)
-- 
1.7.5.4

