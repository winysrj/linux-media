Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55284 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163AbcBETK3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2016 14:10:29 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 4/8] [media] tvp5150: store dev id and rom version
Date: Fri,  5 Feb 2016 16:09:54 -0300
Message-Id: <1454699398-8581-5-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1454699398-8581-1-git-send-email-javier@osg.samsung.com>
References: <1454699398-8581-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Not all tvp5150 variants support the same, for example some have an
internal signal generator that can output a black screen.

So the device id and rom version have to be stored in the driver's
state to know what variant is a given device.

While being there, remove some redundant comments about the device
version since there is already calls to v4l2_info() with that info.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/i2c/tvp5150.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index c7eeb59a999b..093ff80f944c 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -49,6 +49,9 @@ struct tvp5150 {
 	u32 output;
 	int enable;
 
+	u16 dev_id;
+	u16 rom_ver;
+
 	enum v4l2_mbus_type mbus_type;
 };
 
@@ -1180,8 +1183,6 @@ static int tvp5150_detect_version(struct tvp5150 *core)
 	struct v4l2_subdev *sd = &core->sd;
 	struct i2c_client *c = v4l2_get_subdevdata(sd);
 	unsigned int i;
-	u16 dev_id;
-	u16 rom_ver;
 	u8 regs[4];
 	int res;
 
@@ -1196,23 +1197,25 @@ static int tvp5150_detect_version(struct tvp5150 *core)
 		regs[i] = res;
 	}
 
-	dev_id = (regs[0] << 8) | regs[1];
-	rom_ver = (regs[2] << 8) | regs[3];
+	core->dev_id = (regs[0] << 8) | regs[1];
+	core->rom_ver = (regs[2] << 8) | regs[3];
 
 	v4l2_info(sd, "tvp%04x (%u.%u) chip found @ 0x%02x (%s)\n",
-		  dev_id, regs[2], regs[3], c->addr << 1, c->adapter->name);
+		  core->dev_id, regs[2], regs[3], c->addr << 1,
+		  c->adapter->name);
 
-	if (dev_id == 0x5150 && rom_ver == 0x0321) { /* TVP51510A */
+	if (core->dev_id == 0x5150 && core->rom_ver == 0x0321) {
 		v4l2_info(sd, "tvp5150a detected.\n");
-	} else if (dev_id == 0x5150 && rom_ver == 0x0400) { /* TVP5150AM1 */
+	} else if (core->dev_id == 0x5150 && core->rom_ver == 0x0400) {
 		v4l2_info(sd, "tvp5150am1 detected.\n");
 
 		/* ITU-T BT.656.4 timing */
 		tvp5150_write(sd, TVP5150_REV_SELECT, 0);
-	} else if (dev_id == 0x5151 && rom_ver == 0x0100) { /* TVP5151 */
+	} else if (core->dev_id == 0x5151 && core->rom_ver == 0x0100) {
 		v4l2_info(sd, "tvp5151 detected.\n");
 	} else {
-		v4l2_info(sd, "*** unknown tvp%04x chip detected.\n", dev_id);
+		v4l2_info(sd, "*** unknown tvp%04x chip detected.\n",
+			  core->dev_id);
 	}
 
 	return 0;
-- 
2.5.0

