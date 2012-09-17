Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:34666 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756787Ab2IQPXA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 11:23:00 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <julia.lawall@lip6.fr>,
	Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH 1/6] media: Convert struct i2c_msg initialization to C99 format
Date: Mon, 17 Sep 2012 20:52:28 +0530
Message-ID: <1347895353-18090-2-git-send-email-shubhrajyoti@ti.com>
In-Reply-To: <1347895353-18090-1-git-send-email-shubhrajyoti@ti.com>
References: <1347895353-18090-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

        Convert the struct i2c_msg initialization to C99 format. This makes
        maintaining and editing the code simpler. Also helps once other fields
        like transferred are added in future.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/media/i2c/ks0127.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ks0127.c b/drivers/media/i2c/ks0127.c
index ee7ca2d..21fed53 100644
--- a/drivers/media/i2c/ks0127.c
+++ b/drivers/media/i2c/ks0127.c
@@ -319,8 +319,8 @@ static u8 ks0127_read(struct v4l2_subdev *sd, u8 reg)
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	char val = 0;
 	struct i2c_msg msgs[] = {
-		{ client->addr, 0, sizeof(reg), &reg },
-		{ client->addr, I2C_M_RD | I2C_M_NO_RD_ACK, sizeof(val), &val }
+		{ .addr = client->addr, .flags = 0, .len = sizeof(reg), .buf = &reg },
+		{ .addr = client->addr, .flags = I2C_M_RD | I2C_M_NO_RD_ACK, .len = sizeof(val), .buf = &val }
 	};
 	int ret;
 
-- 
1.7.5.4

