Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:56533 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349Ab2JYFCo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 01:02:44 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-media@vger.kernel.org>
CC: <hans.verkuil@cisco.com>, Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH] adv7604: convert struct i2c_msg initialization to C99 format
Date: Thu, 25 Oct 2012 10:32:36 +0530
Message-ID: <1351141356-3093-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert the struct i2c_msg initialization to C99 format. This makes
maintaining and editing the code simpler. Also helps once other fields
like transferred are added in future.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/media/i2c/adv7604.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 109bc9b..89fc854 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -403,9 +403,19 @@ static inline int edid_read_block(struct v4l2_subdev *sd, unsigned len, u8 *val)
 	struct i2c_client *client = state->i2c_edid;
 	u8 msgbuf0[1] = { 0 };
 	u8 msgbuf1[256];
-	struct i2c_msg msg[2] = { { client->addr, 0, 1, msgbuf0 },
-				  { client->addr, 0 | I2C_M_RD, len, msgbuf1 }
-				};
+	struct i2c_msg msg[2] = {
+		{
+			.addr = client->addr,
+			.len = 1,
+			.buf = msgbuf0
+		},
+		{
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = len,
+			.buf = msgbuf1
+		},
+	};
 
 	if (i2c_transfer(client->adapter, msg, 2) < 0)
 		return -EIO;
-- 
1.7.5.4

