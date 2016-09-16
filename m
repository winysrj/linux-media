Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26428 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753446AbcIPKRh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 06:17:37 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH 1/1] ad5820: Fix sparse warning
Date: Fri, 16 Sep 2016 13:16:30 +0300
Message-Id: <1474020990-25295-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use a type with explicit endianness in machine to big endian conversion.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/ad5820.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
index fd4c5f6..044da88 100644
--- a/drivers/media/i2c/ad5820.c
+++ b/drivers/media/i2c/ad5820.c
@@ -65,16 +65,17 @@ static int ad5820_write(struct ad5820_device *coil, u16 data)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&coil->subdev);
 	struct i2c_msg msg;
+	__be16 be_data;
 	int r;
 
 	if (!client->adapter)
 		return -ENODEV;
 
-	data = cpu_to_be16(data);
+	be_data = cpu_to_be16(data);
 	msg.addr  = client->addr;
 	msg.flags = 0;
 	msg.len   = 2;
-	msg.buf   = (u8 *)&data;
+	msg.buf   = (u8 *)&be_data;
 
 	r = i2c_transfer(client->adapter, &msg, 1);
 	if (r < 0) {
-- 
2.7.4

