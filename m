Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44142 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbcAGMrI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jan 2016 07:47:08 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Enrico Butera <ebutera@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Eduard Gavin <egavinc@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH v2 01/10] [media] tvp5150: Restructure version detection
Date: Thu,  7 Jan 2016 09:46:41 -0300
Message-Id: <1452170810-32346-2-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1452170810-32346-1-git-send-email-javier@osg.samsung.com>
References: <1452170810-32346-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Move the version detection code to a separate function and restructure
it to prepare for TVP5151 support.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

Changes in v2: None

 drivers/media/i2c/tvp5150.c | 79 ++++++++++++++++++++++++++-------------------
 1 file changed, 45 insertions(+), 34 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index dda8b3c000cc..9e953e5a7ec9 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1105,13 +1105,53 @@ static const struct v4l2_subdev_ops tvp5150_ops = {
 			I2C Client & Driver
  ****************************************************************************/
 
+static int tvp5150_detect_version(struct tvp5150 *core)
+{
+	struct v4l2_subdev *sd = &core->sd;
+	struct i2c_client *c = v4l2_get_subdevdata(sd);
+	unsigned int i;
+	u16 dev_id;
+	u16 rom_ver;
+	u8 regs[4];
+	int res;
+
+	/*
+	 * Read consequent registers - TVP5150_MSB_DEV_ID, TVP5150_LSB_DEV_ID,
+	 * TVP5150_ROM_MAJOR_VER, TVP5150_ROM_MINOR_VER
+	 */
+	for (i = 0; i < 4; i++) {
+		res = tvp5150_read(sd, TVP5150_MSB_DEV_ID + i);
+		if (res < 0)
+			return res;
+		regs[i] = res;
+	}
+
+	dev_id = (regs[0] << 8) | regs[1];
+	rom_ver = (regs[2] << 8) | regs[3];
+
+	v4l2_info(sd, "tvp%04x (%u.%u) chip found @ 0x%02x (%s)\n",
+		  dev_id, regs[2], regs[3], c->addr << 1, c->adapter->name);
+
+	if (dev_id == 0x5150 && rom_ver == 0x0321) { /* TVP51510A */
+		v4l2_info(sd, "tvp5150a detected.\n");
+	} else if (dev_id == 0x5150 && rom_ver == 0x0400) { /* TVP5150AM1 */
+		v4l2_info(sd, "tvp5150am1 detected.\n");
+
+		/* ITU-T BT.656.4 timing */
+		tvp5150_write(sd, TVP5150_REV_SELECT, 0);
+	} else {
+		v4l2_info(sd, "*** unknown tvp%04x chip detected.\n", dev_id);
+	}
+
+	return 0;
+}
+
 static int tvp5150_probe(struct i2c_client *c,
 			 const struct i2c_device_id *id)
 {
 	struct tvp5150 *core;
 	struct v4l2_subdev *sd;
-	int tvp5150_id[4];
-	int i, res;
+	int res;
 
 	/* Check if the adapter supports the needed features */
 	if (!i2c_check_functionality(c->adapter,
@@ -1124,38 +1164,9 @@ static int tvp5150_probe(struct i2c_client *c,
 	sd = &core->sd;
 	v4l2_i2c_subdev_init(sd, c, &tvp5150_ops);
 
-	/* 
-	 * Read consequent registers - TVP5150_MSB_DEV_ID, TVP5150_LSB_DEV_ID,
-	 * TVP5150_ROM_MAJOR_VER, TVP5150_ROM_MINOR_VER 
-	 */
-	for (i = 0; i < 4; i++) {
-		res = tvp5150_read(sd, TVP5150_MSB_DEV_ID + i);
-		if (res < 0)
-			return res;
-		tvp5150_id[i] = res;
-	}
-
-	v4l_info(c, "chip found @ 0x%02x (%s)\n",
-		 c->addr << 1, c->adapter->name);
-
-	if (tvp5150_id[2] == 4 && tvp5150_id[3] == 0) { /* Is TVP5150AM1 */
-		v4l2_info(sd, "tvp%02x%02xam1 detected.\n",
-			  tvp5150_id[0], tvp5150_id[1]);
-
-		/* ITU-T BT.656.4 timing */
-		tvp5150_write(sd, TVP5150_REV_SELECT, 0);
-	} else {
-		/* Is TVP5150A */
-		if (tvp5150_id[2] == 3 || tvp5150_id[3] == 0x21) {
-			v4l2_info(sd, "tvp%02x%02xa detected.\n",
-				  tvp5150_id[0], tvp5150_id[1]);
-		} else {
-			v4l2_info(sd, "*** unknown tvp%02x%02x chip detected.\n",
-				  tvp5150_id[0], tvp5150_id[1]);
-			v4l2_info(sd, "*** Rom ver is %d.%d\n",
-				  tvp5150_id[2], tvp5150_id[3]);
-		}
-	}
+	res = tvp5150_detect_version(core);
+	if (res < 0)
+		return res;
 
 	core->norm = V4L2_STD_ALL;	/* Default is autodetect */
 	core->input = TVP5150_COMPOSITE1;
-- 
2.4.3

