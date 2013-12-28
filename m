Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50234 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab3L1MQa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 07:16:30 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 11/24] tvp5150: make read operations atomic
Date: Sat, 28 Dec 2013 10:16:03 -0200
Message-Id: <1388232976-20061-12-git-send-email-mchehab@redhat.com>
In-Reply-To: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
References: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

Instead of using two I2C operations between write and read,
use just one i2c_transfer. That allows I2C mutexes to not
let any other I2C transfer between the two.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/i2c/tvp5150.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 89c0b13463b7..d6ba457fcf67 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -58,21 +58,19 @@ static int tvp5150_read(struct v4l2_subdev *sd, unsigned char addr)
 	struct i2c_client *c = v4l2_get_subdevdata(sd);
 	unsigned char buffer[1];
 	int rc;
+	struct i2c_msg msg[] = {
+		{ .addr = c->addr, .flags = 0,
+		  .buf = &addr, .len = 1 },
+		{ .addr = c->addr, .flags = I2C_M_RD,
+		  .buf = buffer, .len = 1 }
+	};
 
 	buffer[0] = addr;
 
-	rc = i2c_master_send(c, buffer, 1);
-	if (rc < 0) {
-		v4l2_err(sd, "i2c i/o error: rc == %d (should be 1)\n", rc);
-		return rc;
-	}
-
-	msleep(10);
-
-	rc = i2c_master_recv(c, buffer, 1);
-	if (rc < 0) {
-		v4l2_err(sd, "i2c i/o error: rc == %d (should be 1)\n", rc);
-		return rc;
+	rc = i2c_transfer(c->adapter, msg, 2);
+	if (rc < 0 || rc != 2) {
+		v4l2_err(sd, "i2c i/o error: rc == %d (should be 2)\n", rc);
+		return rc < 0 ? rc : -EIO;
 	}
 
 	v4l2_dbg(2, debug, sd, "tvp5150: read 0x%02x = 0x%02x\n", addr, buffer[0]);
-- 
1.8.3.1

