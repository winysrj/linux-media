Return-path: <linux-media-owner@vger.kernel.org>
Received: from softlayer.compulab.co.il ([50.23.254.55]:42526 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab2FMMcP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 08:32:15 -0400
From: Dmitry Lifshitz <lifshitz@compulab.co.il>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org,
	Dmitry Lifshitz <lifshitz@compulab.co.il>,
	Igor Grinberg <grinberg@compulab.co.il>
Subject: [PATCH] tvp5150: fix kernel crash if chip is unavailable
Date: Wed, 13 Jun 2012 14:49:30 +0300
Message-Id: <1339588170-11411-1-git-send-email-lifshitz@compulab.co.il>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tvp5150 driver probe function doesn't check if the chip is present.
Thus the driver can be loaded without having a device.
This is dangerous and can cause kernel crash like this:

Kernel BUG at c03c0964 [verbose debug info unavailable]
Internal error: Oops - BUG: 0 [#1] PREEMPT ARM
Modules linked in:
CPU: 0    Tainted: G        W     (3.4.0-cm-t3730+ #2)
PC is at media_entity_create_link+0xe4/0xf4
LR is at isp_register_entities+0x228/0x2f4
pc : [<c03c0964>]    lr : [<c03f3b30>]    psr: 60000013
sp : cf02de50  ip : 00000000  fp : c079405c
r10: 00000000  r9 : 00000000  r8 : cf33c800
r7 : c0794834  r6 : 00000000  r5 : 00000000  r4 : cf365b48
r3 : 00000000  r2 : cf365b48  r1 : 00000000  r0 : cf33c800
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 10c5387d  Table: 80004019  DAC: 00000015
Process swapper (pid: 1, stack limit = 0xcf02c2f0)
Stack: (0xcf02de50 to 0xcf02e000)
de40:                                     cf360000 cf366f28 cf366218 c0794834
de60: cf365b48 00000000 cf33c800 c03f3b30 00000000 00000000 cf360890 cf3668a0
de80: 00000003 cf360000 c0785a58 00000000 cf360528 00000000 00000000 00003fff
dea0: cf360500 c03f4cdc c06cc1f4 cf360000 c0785a58 c0d27808 c07d55ec c0785a58
dec0: c031f0e0 c07d55ec c0776900 000000bb 00000000 c032040c c03203f4 c031ef0c
dee0: c0785a58 c07d55ec c0785a8c c031f0e0 c075e670 c031f0c8 cf02deb8 c0785a58
df00: c07d55ec c031f174 c07d55ec 00000000 cf02df18 c031d7a0 cf01d4a8 cf068b10
df20: 00000000 c07d55ec c07c74d0 cf34bcc0 00000000 c031ded8 c0672340 c054cd38
df40: 00000000 c07e68c0 c07d55ec 00000000 00000000 c075e670 c0776900 000000bb
df60: 00000000 c031f770 c07e68c0 00000007 c07e68c0 00000000 c075e670 c0008790
df80: 000000bb 00000006 00000006 c066e650 cf02dfa4 c07689b8 c07689b8 00000007
dfa0: c07e68c0 c073f2e8 c07689c0 000000bb 00000000 c073f2bc 00000006 00000006
dfc0: c073f2e8 00000000 c077649c c077649c c00150cc 00000013 00000000 00000000
dfe0: 00000000 c073f3cc cf02dfe8 00000000 c073f368 c00150cc 00000000 00000000
[<c03c0964>] (media_entity_create_link+0xe4/0xf4) from [<c03f3b30>] (isp_register_entities+0x228/0x2f4)
[<c03f3b30>] (isp_register_entities+0x228/0x2f4) from [<c03f4cdc>] (isp_probe+0x7ac/0x9b8)
[<c03f4cdc>] (isp_probe+0x7ac/0x9b8) from [<c032040c>] (platform_drv_probe+0x18/0x1c)
[<c032040c>] (platform_drv_probe+0x18/0x1c) from [<c031ef0c>] (really_probe+0x64/0x1d8)
[<c031ef0c>] (really_probe+0x64/0x1d8) from [<c031f0c8>] (driver_probe_device+0x48/0x60)
[<c031f0c8>] (driver_probe_device+0x48/0x60) from [<c031f174>] (__driver_attach+0x94/0x98)
[<c031f174>] (__driver_attach+0x94/0x98) from [<c031d7a0>] (bus_for_each_dev+0x54/0x80)
[<c031d7a0>] (bus_for_each_dev+0x54/0x80) from [<c031ded8>] (bus_add_driver+0xac/0x2a8)
[<c031ded8>] (bus_add_driver+0xac/0x2a8) from [<c031f770>] (driver_register+0x78/0x180)
[<c031f770>] (driver_register+0x78/0x180) from [<c0008790>] (do_one_initcall+0x34/0x184)
[<c0008790>] (do_one_initcall+0x34/0x184) from [<c073f2bc>] (do_basic_setup+0x9c/0xc8)
[<c073f2bc>] (do_basic_setup+0x9c/0xc8) from [<c073f3cc>] (kernel_init+0x64/0xec)
[<c073f3cc>] (kernel_init+0x64/0xec) from [<c00150cc>] (kernel_thread_exit+0x0/0x8)
Code: e1c812b6 e8bd87f0 e7f001f2 eafffffe (e7f001f2)
---[ end trace 3ed3c618b26ff3e8 ]---
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

This patch fixes the tvp5150_read() function to return an error in case
the I2C transaction fails.
tvp5150_probe() and other relevant driver callbacks changed to check the
status of the I2C read operations.
In case of a read error throw an error message with v4l2_err()
instead of v4l2_dbg().

Signed-off-by: Dmitry Lifshitz <lifshitz@compulab.co.il>
Signed-off-by: Igor Grinberg <grinberg@compulab.co.il>
---
 drivers/media/video/tvp5150.c |   95 +++++++++++++++++++++++++++++------------
 1 files changed, 67 insertions(+), 28 deletions(-)

diff --git a/drivers/media/video/tvp5150.c b/drivers/media/video/tvp5150.c
index b786742..40e2641 100644
--- a/drivers/media/video/tvp5150.c
+++ b/drivers/media/video/tvp5150.c
@@ -61,13 +61,20 @@ static int tvp5150_read(struct v4l2_subdev *sd, unsigned char addr)
 	int rc;
 
 	buffer[0] = addr;
-	if (1 != (rc = i2c_master_send(c, buffer, 1)))
-		v4l2_dbg(0, debug, sd, "i2c i/o error: rc == %d (should be 1)\n", rc);
+
+	rc = i2c_master_send(c, buffer, 1);
+	if (rc < 0) {
+		v4l2_err(sd, "i2c i/o error: rc == %d (should be 1)\n", rc);
+		return rc;
+	}
 
 	msleep(10);
 
-	if (1 != (rc = i2c_master_recv(c, buffer, 1)))
-		v4l2_dbg(0, debug, sd, "i2c i/o error: rc == %d (should be 1)\n", rc);
+	rc = i2c_master_recv(c, buffer, 1);
+	if (rc < 0) {
+		v4l2_err(sd, "i2c i/o error: rc == %d (should be 1)\n", rc);
+		return rc;
+	}
 
 	v4l2_dbg(2, debug, sd, "tvp5150: read 0x%02x = 0x%02x\n", addr, buffer[0]);
 
@@ -279,6 +286,11 @@ static inline void tvp5150_selmux(struct v4l2_subdev *sd)
 	 * For Composite and TV, it should be the reverse
 	 */
 	val = tvp5150_read(sd, TVP5150_MISC_CTL);
+	if (val < 0) {
+		v4l2_err(sd, "%s: failed with error = %d\n", __func__, val);
+		return;
+	}
+
 	if (decoder->input == TVP5150_SVIDEO)
 		val = (val & ~0x40) | 0x10;
 	else
@@ -676,6 +688,7 @@ static int tvp5150_get_vbi(struct v4l2_subdev *sd,
 	v4l2_std_id std = decoder->norm;
 	u8 reg;
 	int pos, type = 0;
+	int i, ret = 0;
 
 	if (std == V4L2_STD_ALL) {
 		v4l2_err(sd, "VBI can't be configured without knowing number of lines\n");
@@ -690,13 +703,17 @@ static int tvp5150_get_vbi(struct v4l2_subdev *sd,
 
 	reg = ((line - 6) << 1) + TVP5150_LINE_MODE_INI;
 
-	pos = tvp5150_read(sd, reg) & 0x0f;
-	if (pos < 0x0f)
-		type = regs[pos].type.vbi_type;
-
-	pos = tvp5150_read(sd, reg + 1) & 0x0f;
-	if (pos < 0x0f)
-		type |= regs[pos].type.vbi_type;
+	for (i = 0; i <= 1; i++) {
+		ret = tvp5150_read(sd, reg + i);
+		if (ret < 0) {
+			v4l2_err(sd, "%s: failed with error = %d\n",
+				 __func__, ret);
+			return 0;
+		}
+		pos = ret & 0x0f;
+		if (pos < 0x0f)
+			type |= regs[pos].type.vbi_type;
+	}
 
 	return type;
 }
@@ -1031,13 +1048,21 @@ static int tvp5150_g_chip_ident(struct v4l2_subdev *sd,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int tvp5150_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
 {
+	int res;
+
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	reg->val = tvp5150_read(sd, reg->reg & 0xff);
+	res = tvp5150_read(sd, reg->reg & 0xff);
+	if (res < 0) {
+		v4l2_err(sd, "%s: failed with error = %d\n", __func__, ret);
+		return res;
+	}
+
+	reg->val = res;
 	reg->size = 1;
 	return 0;
 }
@@ -1126,7 +1151,8 @@ static int tvp5150_probe(struct i2c_client *c,
 {
 	struct tvp5150 *core;
 	struct v4l2_subdev *sd;
-	u8 msb_id, lsb_id, msb_rom, lsb_rom;
+	int tvp5150_id[4];
+	int i, res;
 
 	/* Check if the adapter supports the needed features */
 	if (!i2c_check_functionality(c->adapter,
@@ -1139,26 +1165,37 @@ static int tvp5150_probe(struct i2c_client *c,
 	}
 	sd = &core->sd;
 	v4l2_i2c_subdev_init(sd, c, &tvp5150_ops);
+
+	/* 
+	 * Read consequent registers - TVP5150_MSB_DEV_ID, TVP5150_LSB_DEV_ID,
+	 * TVP5150_ROM_MAJOR_VER, TVP5150_ROM_MINOR_VER 
+	 */
+	for (i = 0; i < 4; i++) {
+		res = tvp5150_read(sd, TVP5150_MSB_DEV_ID + i);
+		if (res < 0)
+			goto free_core;
+		tvp5150_id[i] = res;
+	}
+
 	v4l_info(c, "chip found @ 0x%02x (%s)\n",
 		 c->addr << 1, c->adapter->name);
 
-	msb_id = tvp5150_read(sd, TVP5150_MSB_DEV_ID);
-	lsb_id = tvp5150_read(sd, TVP5150_LSB_DEV_ID);
-	msb_rom = tvp5150_read(sd, TVP5150_ROM_MAJOR_VER);
-	lsb_rom = tvp5150_read(sd, TVP5150_ROM_MINOR_VER);
-
-	if (msb_rom == 4 && lsb_rom == 0) { /* Is TVP5150AM1 */
-		v4l2_info(sd, "tvp%02x%02xam1 detected.\n", msb_id, lsb_id);
+	if (tvp5150_id[2] == 4 && tvp5150_id[3] == 0) { /* Is TVP5150AM1 */
+		v4l2_info(sd, "tvp%02x%02xam1 detected.\n",
+			  tvp5150_id[0], tvp5150_id[1]);
 
 		/* ITU-T BT.656.4 timing */
 		tvp5150_write(sd, TVP5150_REV_SELECT, 0);
 	} else {
-		if (msb_rom == 3 || lsb_rom == 0x21) { /* Is TVP5150A */
-			v4l2_info(sd, "tvp%02x%02xa detected.\n", msb_id, lsb_id);
+		/* Is TVP5150A */
+		if (tvp5150_id[2] == 3 || tvp5150_id[3] == 0x21) {
+			v4l2_info(sd, "tvp%02x%02xa detected.\n",
+				  tvp5150_id[2], tvp5150_id[3]);
 		} else {
 			v4l2_info(sd, "*** unknown tvp%02x%02x chip detected.\n",
-					msb_id, lsb_id);
-			v4l2_info(sd, "*** Rom ver is %d.%d\n", msb_rom, lsb_rom);
+				  tvp5150_id[2], tvp5150_id[3]);
+			v4l2_info(sd, "*** Rom ver is %d.%d\n",
+				  tvp5150_id[2], tvp5150_id[3]);
 		}
 	}
 
@@ -1177,11 +1214,9 @@ static int tvp5150_probe(struct i2c_client *c,
 			V4L2_CID_HUE, -128, 127, 1, 0);
 	sd->ctrl_handler = &core->hdl;
 	if (core->hdl.error) {
-		int err = core->hdl.error;
-
+		res = core->hdl.error;
 		v4l2_ctrl_handler_free(&core->hdl);
-		kfree(core);
-		return err;
+		goto free_core;
 	}
 	v4l2_ctrl_handler_setup(&core->hdl);
 
@@ -1197,6 +1232,10 @@ static int tvp5150_probe(struct i2c_client *c,
 	if (debug > 1)
 		tvp5150_log_status(sd);
 	return 0;
+
+free_core:
+	kfree(core);
+	return res;
 }
 
 static int tvp5150_remove(struct i2c_client *c)
-- 
1.7.5.4

