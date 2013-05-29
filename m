Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2292 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965705Ab3E2LBP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:01:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCHv1 18/38] media/i2c: remove g_chip_ident op.
Date: Wed, 29 May 2013 12:59:51 +0200
Message-Id: <1369825211-29770-19-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is no longer needed since the core now handles this through DBG_G_CHIP_INFO.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Andy Walls <awalls@md.metrocast.net>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 drivers/media/i2c/ad9389b.c              |   21 +-----
 drivers/media/i2c/adv7170.c              |   13 ----
 drivers/media/i2c/adv7175.c              |    9 ---
 drivers/media/i2c/adv7180.c              |   10 ---
 drivers/media/i2c/adv7183.c              |   22 -------
 drivers/media/i2c/adv7343.c              |   10 ---
 drivers/media/i2c/adv7393.c              |   10 ---
 drivers/media/i2c/adv7604.c              |   18 -----
 drivers/media/i2c/ak881x.c               |   34 +---------
 drivers/media/i2c/bt819.c                |   14 ----
 drivers/media/i2c/bt856.c                |    9 ---
 drivers/media/i2c/bt866.c                |   13 ----
 drivers/media/i2c/cs5345.c               |   17 -----
 drivers/media/i2c/cs53l32a.c             |   10 ---
 drivers/media/i2c/cx25840/cx25840-core.c |   14 ----
 drivers/media/i2c/ks0127.c               |   16 -----
 drivers/media/i2c/m52790.c               |   15 -----
 drivers/media/i2c/msp3400-driver.c       |   10 ---
 drivers/media/i2c/mt9m032.c              |    9 +--
 drivers/media/i2c/mt9p031.c              |    1 -
 drivers/media/i2c/mt9v011.c              |   24 -------
 drivers/media/i2c/noon010pc30.c          |    1 -
 drivers/media/i2c/ov7640.c               |    1 -
 drivers/media/i2c/ov7670.c               |   17 -----
 drivers/media/i2c/saa6588.c              |    9 ---
 drivers/media/i2c/saa7110.c              |    9 ---
 drivers/media/i2c/saa7115.c              |  105 ++++++++++++++----------------
 drivers/media/i2c/saa7127.c              |   47 +++++--------
 drivers/media/i2c/saa717x.c              |    7 --
 drivers/media/i2c/saa7185.c              |    9 ---
 drivers/media/i2c/saa7191.c              |   10 ---
 drivers/media/i2c/tda9840.c              |   13 ----
 drivers/media/i2c/tea6415c.c             |   13 ----
 drivers/media/i2c/tea6420.c              |   13 ----
 drivers/media/i2c/ths7303.c              |   25 +------
 drivers/media/i2c/tvaudio.c              |    9 ---
 drivers/media/i2c/tvp514x.c              |    1 -
 drivers/media/i2c/tvp5150.c              |   24 -------
 drivers/media/i2c/tvp7002.c              |   34 ----------
 drivers/media/i2c/tw2804.c               |    1 -
 drivers/media/i2c/upd64031a.c            |   17 -----
 drivers/media/i2c/upd64083.c             |   17 -----
 drivers/media/i2c/vp27smpx.c             |    9 ---
 drivers/media/i2c/vpx3220.c              |   14 ----
 drivers/media/i2c/vs6624.c               |   22 -------
 drivers/media/i2c/wm8739.c               |    9 ---
 drivers/media/i2c/wm8775.c               |    9 ---
 47 files changed, 73 insertions(+), 671 deletions(-)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index ade1fec..ba4364d 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -32,7 +32,6 @@
 #include <linux/workqueue.h>
 #include <linux/v4l2-dv-timings.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
 #include <media/ad9389b.h>
@@ -343,10 +342,6 @@ static const struct v4l2_ctrl_ops ad9389b_ctrl_ops = {
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int ad9389b_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	reg->val = ad9389b_rd(sd, reg->reg & 0xff);
 	reg->size = 1;
 	return 0;
@@ -354,22 +349,11 @@ static int ad9389b_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *
 
 static int ad9389b_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	ad9389b_wr(sd, reg->reg & 0xff, reg->val & 0xff);
 	return 0;
 }
 #endif
 
-static int ad9389b_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_AD9389B, 0);
-}
-
 static int ad9389b_log_status(struct v4l2_subdev *sd)
 {
 	struct ad9389b_state *state = get_ad9389b_state(sd);
@@ -596,7 +580,6 @@ static int ad9389b_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 
 static const struct v4l2_subdev_core_ops ad9389b_core_ops = {
 	.log_status = ad9389b_log_status,
-	.g_chip_ident = ad9389b_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = ad9389b_g_register,
 	.s_register = ad9389b_s_register,
@@ -1303,8 +1286,8 @@ static int ad9389b_remove(struct i2c_client *client)
 /* ----------------------------------------------------------------------- */
 
 static struct i2c_device_id ad9389b_id[] = {
-	{ "ad9389b", V4L2_IDENT_AD9389B },
-	{ "ad9889b", V4L2_IDENT_AD9389B },
+	{ "ad9389b", 0 },
+	{ "ad9889b", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, ad9389b_id);
diff --git a/drivers/media/i2c/adv7170.c b/drivers/media/i2c/adv7170.c
index d07689d..04bb297 100644
--- a/drivers/media/i2c/adv7170.c
+++ b/drivers/media/i2c/adv7170.c
@@ -36,7 +36,6 @@
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 
 MODULE_DESCRIPTION("Analog Devices ADV7170 video encoder driver");
 MODULE_AUTHOR("Maxim Yevtyushkin");
@@ -317,19 +316,8 @@ static int adv7170_s_fmt(struct v4l2_subdev *sd,
 	return ret;
 }
 
-static int adv7170_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_ADV7170, 0);
-}
-
 /* ----------------------------------------------------------------------- */
 
-static const struct v4l2_subdev_core_ops adv7170_core_ops = {
-	.g_chip_ident = adv7170_g_chip_ident,
-};
-
 static const struct v4l2_subdev_video_ops adv7170_video_ops = {
 	.s_std_output = adv7170_s_std_output,
 	.s_routing = adv7170_s_routing,
@@ -339,7 +327,6 @@ static const struct v4l2_subdev_video_ops adv7170_video_ops = {
 };
 
 static const struct v4l2_subdev_ops adv7170_ops = {
-	.core = &adv7170_core_ops,
 	.video = &adv7170_video_ops,
 };
 
diff --git a/drivers/media/i2c/adv7175.c b/drivers/media/i2c/adv7175.c
index eaefa50..b88f3b3 100644
--- a/drivers/media/i2c/adv7175.c
+++ b/drivers/media/i2c/adv7175.c
@@ -32,7 +32,6 @@
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 
 MODULE_DESCRIPTION("Analog Devices ADV7175 video encoder driver");
 MODULE_AUTHOR("Dave Perks");
@@ -355,13 +354,6 @@ static int adv7175_s_fmt(struct v4l2_subdev *sd,
 	return ret;
 }
 
-static int adv7175_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_ADV7175, 0);
-}
-
 static int adv7175_s_power(struct v4l2_subdev *sd, int on)
 {
 	if (on)
@@ -375,7 +367,6 @@ static int adv7175_s_power(struct v4l2_subdev *sd, int on)
 /* ----------------------------------------------------------------------- */
 
 static const struct v4l2_subdev_core_ops adv7175_core_ops = {
-	.g_chip_ident = adv7175_g_chip_ident,
 	.init = adv7175_init,
 	.s_power = adv7175_s_power,
 };
diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 04ee1d4..5a42715 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -27,7 +27,6 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
-#include <media/v4l2-chip-ident.h>
 #include <linux/mutex.h>
 
 #define ADV7180_INPUT_CONTROL_REG			0x00
@@ -272,14 +271,6 @@ static int adv7180_g_input_status(struct v4l2_subdev *sd, u32 *status)
 	return ret;
 }
 
-static int adv7180_g_chip_ident(struct v4l2_subdev *sd,
-				struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_ADV7180, 0);
-}
-
 static int adv7180_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 {
 	struct adv7180_state *state = to_state(sd);
@@ -404,7 +395,6 @@ static const struct v4l2_subdev_video_ops adv7180_video_ops = {
 };
 
 static const struct v4l2_subdev_core_ops adv7180_core_ops = {
-	.g_chip_ident = adv7180_g_chip_ident,
 	.s_std = adv7180_s_std,
 };
 
diff --git a/drivers/media/i2c/adv7183.c b/drivers/media/i2c/adv7183.c
index 7c48e22..980815d 100644
--- a/drivers/media/i2c/adv7183.c
+++ b/drivers/media/i2c/adv7183.c
@@ -28,7 +28,6 @@
 #include <linux/videodev2.h>
 
 #include <media/adv7183.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 
@@ -481,25 +480,9 @@ static int adv7183_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-static int adv7183_g_chip_ident(struct v4l2_subdev *sd,
-		struct v4l2_dbg_chip_ident *chip)
-{
-	int rev;
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	/* 0x11 for adv7183, 0x13 for adv7183b */
-	rev = adv7183_read(sd, ADV7183_IDENT);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_ADV7183, rev);
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int adv7183_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	reg->val = adv7183_read(sd, reg->reg & 0xff);
 	reg->size = 1;
 	return 0;
@@ -507,10 +490,6 @@ static int adv7183_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *
 
 static int adv7183_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	adv7183_write(sd, reg->reg & 0xff, reg->val & 0xff);
 	return 0;
 }
@@ -525,7 +504,6 @@ static const struct v4l2_subdev_core_ops adv7183_core_ops = {
 	.g_std = adv7183_g_std,
 	.s_std = adv7183_s_std,
 	.reset = adv7183_reset,
-	.g_chip_ident = adv7183_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = adv7183_g_register,
 	.s_register = adv7183_s_register,
diff --git a/drivers/media/i2c/adv7343.c b/drivers/media/i2c/adv7343.c
index 9fc2b98..7606218 100644
--- a/drivers/media/i2c/adv7343.c
+++ b/drivers/media/i2c/adv7343.c
@@ -28,7 +28,6 @@
 
 #include <media/adv7343.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 
 #include "adv7343_regs.h"
@@ -311,21 +310,12 @@ static int adv7343_s_ctrl(struct v4l2_ctrl *ctrl)
 	return -EINVAL;
 }
 
-static int adv7343_g_chip_ident(struct v4l2_subdev *sd,
-				struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_ADV7343, 0);
-}
-
 static const struct v4l2_ctrl_ops adv7343_ctrl_ops = {
 	.s_ctrl = adv7343_s_ctrl,
 };
 
 static const struct v4l2_subdev_core_ops adv7343_core_ops = {
 	.log_status = adv7343_log_status,
-	.g_chip_ident = adv7343_g_chip_ident,
 	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
 	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
 	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
diff --git a/drivers/media/i2c/adv7393.c b/drivers/media/i2c/adv7393.c
index ec50509..558f191 100644
--- a/drivers/media/i2c/adv7393.c
+++ b/drivers/media/i2c/adv7393.c
@@ -33,7 +33,6 @@
 
 #include <media/adv7393.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 
 #include "adv7393_regs.h"
@@ -301,21 +300,12 @@ static int adv7393_s_ctrl(struct v4l2_ctrl *ctrl)
 	return -EINVAL;
 }
 
-static int adv7393_g_chip_ident(struct v4l2_subdev *sd,
-				struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_ADV7393, 0);
-}
-
 static const struct v4l2_ctrl_ops adv7393_ctrl_ops = {
 	.s_ctrl = adv7393_s_ctrl,
 };
 
 static const struct v4l2_subdev_core_ops adv7393_core_ops = {
 	.log_status = adv7393_log_status,
-	.g_chip_ident = adv7393_g_chip_ident,
 	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
 	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
 	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 5528cd1..1d675b5 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -38,7 +38,6 @@
 #include <linux/v4l2-dv-timings.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/adv7604.h>
 
 static int debug;
@@ -643,10 +642,6 @@ static void adv7604_inv_register(struct v4l2_subdev *sd)
 static int adv7604_g_register(struct v4l2_subdev *sd,
 					struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	reg->size = 1;
 	switch (reg->reg >> 8) {
 	case 0:
@@ -699,10 +694,6 @@ static int adv7604_g_register(struct v4l2_subdev *sd,
 static int adv7604_s_register(struct v4l2_subdev *sd,
 					const struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	switch (reg->reg >> 8) {
 	case 0:
 		io_write(sd, reg->reg & 0xff, reg->val & 0xff);
@@ -980,14 +971,6 @@ static int adv7604_s_ctrl(struct v4l2_ctrl *ctrl)
 	return -EINVAL;
 }
 
-static int adv7604_g_chip_ident(struct v4l2_subdev *sd,
-					struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_ADV7604, 0);
-}
-
 /* ----------------------------------------------------------------------- */
 
 static inline bool no_power(struct v4l2_subdev *sd)
@@ -1783,7 +1766,6 @@ static const struct v4l2_subdev_core_ops adv7604_core_ops = {
 	.s_ctrl = v4l2_subdev_s_ctrl,
 	.queryctrl = v4l2_subdev_queryctrl,
 	.querymenu = v4l2_subdev_querymenu,
-	.g_chip_ident = adv7604_g_chip_ident,
 	.interrupt_service_routine = adv7604_isr,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = adv7604_g_register,
diff --git a/drivers/media/i2c/ak881x.c b/drivers/media/i2c/ak881x.c
index b918c3f..fcd8a3f 100644
--- a/drivers/media/i2c/ak881x.c
+++ b/drivers/media/i2c/ak881x.c
@@ -16,7 +16,6 @@
 #include <linux/module.h>
 
 #include <media/ak881x.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 
@@ -33,7 +32,6 @@ struct ak881x {
 	struct v4l2_subdev subdev;
 	struct ak881x_pdata *pdata;
 	unsigned int lines;
-	int id;	/* DEVICE_ID code V4L2_IDENT_AK881X code from v4l2-chip-ident.h */
 	char revision;	/* DEVICE_REVISION content */
 };
 
@@ -62,36 +60,15 @@ static struct ak881x *to_ak881x(const struct i2c_client *client)
 	return container_of(i2c_get_clientdata(client), struct ak881x, subdev);
 }
 
-static int ak881x_g_chip_ident(struct v4l2_subdev *sd,
-			       struct v4l2_dbg_chip_ident *id)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct ak881x *ak881x = to_ak881x(client);
-
-	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
-		return -EINVAL;
-
-	if (id->match.addr != client->addr)
-		return -ENODEV;
-
-	id->ident	= ak881x->id;
-	id->revision	= ak881x->revision;
-
-	return 0;
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int ak881x_g_register(struct v4l2_subdev *sd,
 			     struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0x26)
+	if (reg->reg > 0x26)
 		return -EINVAL;
 
-	if (reg->match.addr != client->addr)
-		return -ENODEV;
-
 	reg->val = reg_read(client, reg->reg);
 
 	if (reg->val > 0xffff)
@@ -105,12 +82,9 @@ static int ak881x_s_register(struct v4l2_subdev *sd,
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0x26)
+	if (reg->reg > 0x26)
 		return -EINVAL;
 
-	if (reg->match.addr != client->addr)
-		return -ENODEV;
-
 	if (reg_write(client, reg->reg, reg->val) < 0)
 		return -EIO;
 
@@ -229,7 +203,6 @@ static int ak881x_s_stream(struct v4l2_subdev *sd, int enable)
 }
 
 static struct v4l2_subdev_core_ops ak881x_subdev_core_ops = {
-	.g_chip_ident	= ak881x_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= ak881x_g_register,
 	.s_register	= ak881x_s_register,
@@ -274,10 +247,7 @@ static int ak881x_probe(struct i2c_client *client,
 
 	switch (data) {
 	case 0x13:
-		ak881x->id = V4L2_IDENT_AK8813;
-		break;
 	case 0x14:
-		ak881x->id = V4L2_IDENT_AK8814;
 		break;
 	default:
 		dev_err(&client->dev,
diff --git a/drivers/media/i2c/bt819.c b/drivers/media/i2c/bt819.c
index ee9ed67..ae1eac0 100644
--- a/drivers/media/i2c/bt819.c
+++ b/drivers/media/i2c/bt819.c
@@ -36,7 +36,6 @@
 #include <linux/videodev2.h>
 #include <linux/slab.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 #include <media/bt819.h>
 
@@ -57,7 +56,6 @@ struct bt819 {
 	unsigned char reg[32];
 
 	v4l2_std_id norm;
-	int ident;
 	int input;
 	int enable;
 };
@@ -373,14 +371,6 @@ static int bt819_s_ctrl(struct v4l2_ctrl *ctrl)
 	return 0;
 }
 
-static int bt819_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
-{
-	struct bt819 *decoder = to_bt819(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, decoder->ident, 0);
-}
-
 /* ----------------------------------------------------------------------- */
 
 static const struct v4l2_ctrl_ops bt819_ctrl_ops = {
@@ -388,7 +378,6 @@ static const struct v4l2_ctrl_ops bt819_ctrl_ops = {
 };
 
 static const struct v4l2_subdev_core_ops bt819_core_ops = {
-	.g_chip_ident = bt819_g_chip_ident,
 	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
 	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
 	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
@@ -435,15 +424,12 @@ static int bt819_probe(struct i2c_client *client,
 	switch (ver & 0xf0) {
 	case 0x70:
 		name = "bt819a";
-		decoder->ident = V4L2_IDENT_BT819A;
 		break;
 	case 0x60:
 		name = "bt817a";
-		decoder->ident = V4L2_IDENT_BT817A;
 		break;
 	case 0x20:
 		name = "bt815a";
-		decoder->ident = V4L2_IDENT_BT815A;
 		break;
 	default:
 		v4l2_dbg(1, debug, sd,
diff --git a/drivers/media/i2c/bt856.c b/drivers/media/i2c/bt856.c
index 7e50111..7fc163d 100644
--- a/drivers/media/i2c/bt856.c
+++ b/drivers/media/i2c/bt856.c
@@ -36,7 +36,6 @@
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 
 MODULE_DESCRIPTION("Brooktree-856A video encoder driver");
 MODULE_AUTHOR("Mike Bernson & Dave Perks");
@@ -177,17 +176,9 @@ static int bt856_s_routing(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int bt856_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_BT856, 0);
-}
-
 /* ----------------------------------------------------------------------- */
 
 static const struct v4l2_subdev_core_ops bt856_core_ops = {
-	.g_chip_ident = bt856_g_chip_ident,
 	.init = bt856_init,
 };
 
diff --git a/drivers/media/i2c/bt866.c b/drivers/media/i2c/bt866.c
index 9355b92..a8bf10f 100644
--- a/drivers/media/i2c/bt866.c
+++ b/drivers/media/i2c/bt866.c
@@ -36,7 +36,6 @@
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 
 MODULE_DESCRIPTION("Brooktree-866 video encoder driver");
 MODULE_AUTHOR("Mike Bernson & Dave Perks");
@@ -175,26 +174,14 @@ static int bt866_s_routing(struct v4l2_subdev *sd,
 	bt866_write(client, 0xdc, val);
 #endif
 
-static int bt866_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_BT866, 0);
-}
-
 /* ----------------------------------------------------------------------- */
 
-static const struct v4l2_subdev_core_ops bt866_core_ops = {
-	.g_chip_ident = bt866_g_chip_ident,
-};
-
 static const struct v4l2_subdev_video_ops bt866_video_ops = {
 	.s_std_output = bt866_s_std_output,
 	.s_routing = bt866_s_routing,
 };
 
 static const struct v4l2_subdev_ops bt866_ops = {
-	.core = &bt866_core_ops,
 	.video = &bt866_video_ops,
 };
 
diff --git a/drivers/media/i2c/cs5345.c b/drivers/media/i2c/cs5345.c
index 2661757..34b76a9 100644
--- a/drivers/media/i2c/cs5345.c
+++ b/drivers/media/i2c/cs5345.c
@@ -24,7 +24,6 @@
 #include <linux/videodev2.h>
 #include <linux/slab.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 
 MODULE_DESCRIPTION("i2c device driver for cs5345 Audio ADC");
@@ -99,10 +98,6 @@ static int cs5345_s_ctrl(struct v4l2_ctrl *ctrl)
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int cs5345_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	reg->size = 1;
 	reg->val = cs5345_read(sd, reg->reg & 0x1f);
 	return 0;
@@ -110,22 +105,11 @@ static int cs5345_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *r
 
 static int cs5345_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	cs5345_write(sd, reg->reg & 0x1f, reg->val & 0xff);
 	return 0;
 }
 #endif
 
-static int cs5345_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_CS5345, 0);
-}
-
 static int cs5345_log_status(struct v4l2_subdev *sd)
 {
 	u8 v = cs5345_read(sd, 0x09) & 7;
@@ -148,7 +132,6 @@ static const struct v4l2_ctrl_ops cs5345_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops cs5345_core_ops = {
 	.log_status = cs5345_log_status,
-	.g_chip_ident = cs5345_g_chip_ident,
 	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
 	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
 	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
diff --git a/drivers/media/i2c/cs53l32a.c b/drivers/media/i2c/cs53l32a.c
index 1082fb7..27400c1 100644
--- a/drivers/media/i2c/cs53l32a.c
+++ b/drivers/media/i2c/cs53l32a.c
@@ -28,7 +28,6 @@
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 
 MODULE_DESCRIPTION("i2c device driver for cs53l32a Audio ADC");
@@ -104,14 +103,6 @@ static int cs53l32a_s_ctrl(struct v4l2_ctrl *ctrl)
 	return -EINVAL;
 }
 
-static int cs53l32a_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client,
-			chip, V4L2_IDENT_CS53l32A, 0);
-}
-
 static int cs53l32a_log_status(struct v4l2_subdev *sd)
 {
 	struct cs53l32a_state *state = to_state(sd);
@@ -130,7 +121,6 @@ static const struct v4l2_ctrl_ops cs53l32a_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops cs53l32a_core_ops = {
 	.log_status = cs53l32a_log_status,
-	.g_chip_ident = cs53l32a_g_chip_ident,
 	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
 	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
 	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index b81e32f..6fbdad4 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -45,7 +45,6 @@
 #include <linux/delay.h>
 #include <linux/math64.h>
 #include <media/v4l2-common.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/cx25840.h>
 
 #include "cx25840-core.h"
@@ -1662,8 +1661,6 @@ static int cx25840_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	reg->size = 1;
 	reg->val = cx25840_read(client, reg->reg & 0x0fff);
 	return 0;
@@ -1673,8 +1670,6 @@ static int cx25840_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_regi
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	cx25840_write(client, reg->reg & 0x0fff, reg->val & 0xff);
 	return 0;
 }
@@ -1934,14 +1929,6 @@ static int cx25840_reset(struct v4l2_subdev *sd, u32 val)
 	return 0;
 }
 
-static int cx25840_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
-{
-	struct cx25840_state *state = to_state(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, state->id, state->rev);
-}
-
 static int cx25840_log_status(struct v4l2_subdev *sd)
 {
 	struct cx25840_state *state = to_state(sd);
@@ -5047,7 +5034,6 @@ static const struct v4l2_ctrl_ops cx25840_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops cx25840_core_ops = {
 	.log_status = cx25840_log_status,
-	.g_chip_ident = cx25840_g_chip_ident,
 	.g_ctrl = v4l2_subdev_g_ctrl,
 	.s_ctrl = v4l2_subdev_s_ctrl,
 	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
diff --git a/drivers/media/i2c/ks0127.c b/drivers/media/i2c/ks0127.c
index c722776..b5223e8 100644
--- a/drivers/media/i2c/ks0127.c
+++ b/drivers/media/i2c/ks0127.c
@@ -42,7 +42,6 @@
 #include <linux/videodev2.h>
 #include <linux/slab.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 #include "ks0127.h"
 
 MODULE_DESCRIPTION("KS0127 video decoder driver");
@@ -200,7 +199,6 @@ struct adjust {
 struct ks0127 {
 	struct v4l2_subdev sd;
 	v4l2_std_id	norm;
-	int		ident;
 	u8 		regs[256];
 };
 
@@ -371,12 +369,9 @@ static void ks0127_and_or(struct v4l2_subdev *sd, u8 reg, u8 and_v, u8 or_v)
 ****************************************************************************/
 static void ks0127_init(struct v4l2_subdev *sd)
 {
-	struct ks0127 *ks = to_ks0127(sd);
 	u8 *table = reg_defaults;
 	int i;
 
-	ks->ident = V4L2_IDENT_KS0127;
-
 	v4l2_dbg(1, debug, sd, "reset\n");
 	msleep(1);
 
@@ -397,7 +392,6 @@ static void ks0127_init(struct v4l2_subdev *sd)
 
 
 	if ((ks0127_read(sd, KS_STAT) & 0x80) == 0) {
-		ks->ident = V4L2_IDENT_KS0122S;
 		v4l2_dbg(1, debug, sd, "ks0122s found\n");
 		return;
 	}
@@ -408,7 +402,6 @@ static void ks0127_init(struct v4l2_subdev *sd)
 		break;
 
 	case 9:
-		ks->ident = V4L2_IDENT_KS0127B;
 		v4l2_dbg(1, debug, sd, "ks0127B Revision A found\n");
 		break;
 
@@ -646,18 +639,9 @@ static int ks0127_g_input_status(struct v4l2_subdev *sd, u32 *status)
 	return ks0127_status(sd, status, NULL);
 }
 
-static int ks0127_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct ks0127 *ks = to_ks0127(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, ks->ident, 0);
-}
-
 /* ----------------------------------------------------------------------- */
 
 static const struct v4l2_subdev_core_ops ks0127_core_ops = {
-	.g_chip_ident = ks0127_g_chip_ident,
 	.s_std = ks0127_s_std,
 };
 
diff --git a/drivers/media/i2c/m52790.c b/drivers/media/i2c/m52790.c
index 3eeb546..bf47635 100644
--- a/drivers/media/i2c/m52790.c
+++ b/drivers/media/i2c/m52790.c
@@ -29,7 +29,6 @@
 #include <linux/videodev2.h>
 #include <media/m52790.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 
 MODULE_DESCRIPTION("i2c device driver for m52790 A/V switch");
 MODULE_AUTHOR("Hans Verkuil");
@@ -83,10 +82,7 @@ static int m52790_s_routing(struct v4l2_subdev *sd,
 static int m52790_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
 {
 	struct m52790_state *state = to_state(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	if (reg->reg != 0)
 		return -EINVAL;
 	reg->size = 1;
@@ -97,10 +93,7 @@ static int m52790_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *r
 static int m52790_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
 	struct m52790_state *state = to_state(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	if (reg->reg != 0)
 		return -EINVAL;
 	state->input = reg->val & 0x0303;
@@ -110,13 +103,6 @@ static int m52790_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_regis
 }
 #endif
 
-static int m52790_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_M52790, 0);
-}
-
 static int m52790_log_status(struct v4l2_subdev *sd)
 {
 	struct m52790_state *state = to_state(sd);
@@ -132,7 +118,6 @@ static int m52790_log_status(struct v4l2_subdev *sd)
 
 static const struct v4l2_subdev_core_ops m52790_core_ops = {
 	.log_status = m52790_log_status,
-	.g_chip_ident = m52790_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = m52790_g_register,
 	.s_register = m52790_s_register,
diff --git a/drivers/media/i2c/msp3400-driver.c b/drivers/media/i2c/msp3400-driver.c
index ae92c20..8190fec 100644
--- a/drivers/media/i2c/msp3400-driver.c
+++ b/drivers/media/i2c/msp3400-driver.c
@@ -570,15 +570,6 @@ static int msp_s_i2s_clock_freq(struct v4l2_subdev *sd, u32 freq)
 	return 0;
 }
 
-static int msp_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
-{
-	struct msp_state *state = to_state(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, state->ident,
-			(state->rev1 << 16) | state->rev2);
-}
-
 static int msp_log_status(struct v4l2_subdev *sd)
 {
 	struct msp_state *state = to_state(sd);
@@ -651,7 +642,6 @@ static const struct v4l2_ctrl_ops msp_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops msp_core_ops = {
 	.log_status = msp_log_status,
-	.g_chip_ident = msp_g_chip_ident,
 	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
 	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
 	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
diff --git a/drivers/media/i2c/mt9m032.c b/drivers/media/i2c/mt9m032.c
index cca704e..846b15f 100644
--- a/drivers/media/i2c/mt9m032.c
+++ b/drivers/media/i2c/mt9m032.c
@@ -554,10 +554,8 @@ static int mt9m032_g_register(struct v4l2_subdev *sd,
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
 	int val;
 
-	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
+	if (reg->reg > 0xff)
 		return -EINVAL;
-	if (reg->match.addr != client->addr)
-		return -ENODEV;
 
 	val = mt9m032_read(client, reg->reg);
 	if (val < 0)
@@ -575,12 +573,9 @@ static int mt9m032_s_register(struct v4l2_subdev *sd,
 	struct mt9m032 *sensor = to_mt9m032(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
 
-	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
+	if (reg->reg > 0xff)
 		return -EINVAL;
 
-	if (reg->match.addr != client->addr)
-		return -ENODEV;
-
 	return mt9m032_write(client, reg->reg, reg->val);
 }
 #endif
diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index bf49899..fe34148 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -25,7 +25,6 @@
 #include <linux/videodev2.h>
 
 #include <media/mt9p031.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
diff --git a/drivers/media/i2c/mt9v011.c b/drivers/media/i2c/mt9v011.c
index 141919b..f74698c 100644
--- a/drivers/media/i2c/mt9v011.c
+++ b/drivers/media/i2c/mt9v011.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <asm/div64.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 #include <media/mt9v011.h>
 
@@ -407,11 +406,6 @@ static int mt9v011_s_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt
 static int mt9v011_g_register(struct v4l2_subdev *sd,
 			      struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
-
 	reg->val = mt9v011_read(sd, reg->reg & 0xff);
 	reg->size = 2;
 
@@ -421,29 +415,12 @@ static int mt9v011_g_register(struct v4l2_subdev *sd,
 static int mt9v011_s_register(struct v4l2_subdev *sd,
 			      const struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
-
 	mt9v011_write(sd, reg->reg & 0xff, reg->val & 0xffff);
 
 	return 0;
 }
 #endif
 
-static int mt9v011_g_chip_ident(struct v4l2_subdev *sd,
-				struct v4l2_dbg_chip_ident *chip)
-{
-	u16 version;
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	version = mt9v011_read(sd, R00_MT9V011_CHIP_VERSION);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_MT9V011,
-					  version);
-}
-
 static int mt9v011_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct mt9v011 *core =
@@ -485,7 +462,6 @@ static struct v4l2_ctrl_ops mt9v011_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops mt9v011_core_ops = {
 	.reset = mt9v011_reset,
-	.g_chip_ident = mt9v011_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = mt9v011_g_register,
 	.s_register = mt9v011_s_register,
diff --git a/drivers/media/i2c/noon010pc30.c b/drivers/media/i2c/noon010pc30.c
index 2284b02..271d0b7 100644
--- a/drivers/media/i2c/noon010pc30.c
+++ b/drivers/media/i2c/noon010pc30.c
@@ -19,7 +19,6 @@
 #include <linux/slab.h>
 #include <linux/regulator/consumer.h>
 #include <media/noon010pc30.h>
-#include <media/v4l2-chip-ident.h>
 #include <linux/videodev2.h>
 #include <linux/module.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/i2c/ov7640.c b/drivers/media/i2c/ov7640.c
index 5e117ab..faa64ba 100644
--- a/drivers/media/i2c/ov7640.c
+++ b/drivers/media/i2c/ov7640.c
@@ -20,7 +20,6 @@
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 #include <linux/slab.h>
 
 MODULE_DESCRIPTION("OmniVision ov7640 sensor driver");
diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index b030279..e8a1ce2 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -17,7 +17,6 @@
 #include <linux/delay.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-mediabus.h>
 #include <media/ov7670.h>
@@ -1462,23 +1461,12 @@ static const struct v4l2_ctrl_ops ov7670_ctrl_ops = {
 	.g_volatile_ctrl = ov7670_g_volatile_ctrl,
 };
 
-static int ov7670_g_chip_ident(struct v4l2_subdev *sd,
-		struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_OV7670, 0);
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int ov7670_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	unsigned char val = 0;
 	int ret;
 
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	ret = ov7670_read(sd, reg->reg & 0xff, &val);
 	reg->val = val;
 	reg->size = 1;
@@ -1487,10 +1475,6 @@ static int ov7670_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *r
 
 static int ov7670_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	ov7670_write(sd, reg->reg & 0xff, reg->val & 0xff);
 	return 0;
 }
@@ -1499,7 +1483,6 @@ static int ov7670_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_regis
 /* ----------------------------------------------------------------------- */
 
 static const struct v4l2_subdev_core_ops ov7670_core_ops = {
-	.g_chip_ident = ov7670_g_chip_ident,
 	.reset = ov7670_reset,
 	.init = ov7670_init,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
diff --git a/drivers/media/i2c/saa6588.c b/drivers/media/i2c/saa6588.c
index 729e78d..70bc72e 100644
--- a/drivers/media/i2c/saa6588.c
+++ b/drivers/media/i2c/saa6588.c
@@ -33,7 +33,6 @@
 
 #include <media/saa6588.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 
 
 /* insmod options */
@@ -443,17 +442,9 @@ static int saa6588_s_tuner(struct v4l2_subdev *sd, const struct v4l2_tuner *vt)
 	return 0;
 }
 
-static int saa6588_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_SAA6588, 0);
-}
-
 /* ----------------------------------------------------------------------- */
 
 static const struct v4l2_subdev_core_ops saa6588_core_ops = {
-	.g_chip_ident = saa6588_g_chip_ident,
 	.ioctl = saa6588_ioctl,
 };
 
diff --git a/drivers/media/i2c/saa7110.c b/drivers/media/i2c/saa7110.c
index e4026aa..532105d 100644
--- a/drivers/media/i2c/saa7110.c
+++ b/drivers/media/i2c/saa7110.c
@@ -35,7 +35,6 @@
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 
 MODULE_DESCRIPTION("Philips SAA7110 video decoder driver");
@@ -352,13 +351,6 @@ static int saa7110_s_ctrl(struct v4l2_ctrl *ctrl)
 	return 0;
 }
 
-static int saa7110_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_SAA7110, 0);
-}
-
 /* ----------------------------------------------------------------------- */
 
 static const struct v4l2_ctrl_ops saa7110_ctrl_ops = {
@@ -366,7 +358,6 @@ static const struct v4l2_ctrl_ops saa7110_ctrl_ops = {
 };
 
 static const struct v4l2_subdev_core_ops saa7110_core_ops = {
-	.g_chip_ident = saa7110_g_chip_ident,
 	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
 	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
 	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index 4daa81c..90c43f3 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -46,7 +46,6 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/saa7115.h>
 #include <asm/div64.h>
 
@@ -63,6 +62,16 @@ module_param(debug, bool, 0644);
 MODULE_PARM_DESC(debug, "Debug level (0-1)");
 
 
+enum saa711x_model {
+	SAA7111A,
+	SAA7111,
+	SAA7113,
+	GM7113C,
+	SAA7114,
+	SAA7115,
+	SAA7118,
+};
+
 struct saa711x_state {
 	struct v4l2_subdev sd;
 	struct v4l2_ctrl_handler hdl;
@@ -80,7 +89,7 @@ struct saa711x_state {
 	int radio;
 	int width;
 	int height;
-	u32 ident;
+	enum saa711x_model ident;
 	u32 audclk_freq;
 	u32 crystal_freq;
 	bool ucgc;
@@ -111,10 +120,10 @@ static inline int saa711x_write(struct v4l2_subdev *sd, u8 reg, u8 value)
 /* Sanity routine to check if a register is present */
 static int saa711x_has_reg(const int id, const u8 reg)
 {
-	if (id == V4L2_IDENT_SAA7111)
+	if (id == SAA7111)
 		return reg < 0x20 && reg != 0x01 && reg != 0x0f &&
 		       (reg < 0x13 || reg > 0x19) && reg != 0x1d && reg != 0x1e;
-	if (id == V4L2_IDENT_SAA7111A)
+	if (id == SAA7111A)
 		return reg < 0x20 && reg != 0x01 && reg != 0x0f &&
 		       reg != 0x14 && reg != 0x18 && reg != 0x19 &&
 		       reg != 0x1d && reg != 0x1e;
@@ -127,18 +136,18 @@ static int saa711x_has_reg(const int id, const u8 reg)
 		return 0;
 
 	switch (id) {
-	case V4L2_IDENT_GM7113C:
+	case GM7113C:
 		return reg != 0x14 && (reg < 0x18 || reg > 0x1e) && reg < 0x20;
-	case V4L2_IDENT_SAA7113:
+	case SAA7113:
 		return reg != 0x14 && (reg < 0x18 || reg > 0x1e) && (reg < 0x20 || reg > 0x3f) &&
 		       reg != 0x5d && reg < 0x63;
-	case V4L2_IDENT_SAA7114:
+	case SAA7114:
 		return (reg < 0x1a || reg > 0x1e) && (reg < 0x20 || reg > 0x2f) &&
 		       (reg < 0x63 || reg > 0x7f) && reg != 0x33 && reg != 0x37 &&
 		       reg != 0x81 && reg < 0xf0;
-	case V4L2_IDENT_SAA7115:
+	case SAA7115:
 		return (reg < 0x20 || reg > 0x2f) && reg != 0x65 && (reg < 0xfc || reg > 0xfe);
-	case V4L2_IDENT_SAA7118:
+	case SAA7118:
 		return (reg < 0x1a || reg > 0x1d) && (reg < 0x20 || reg > 0x22) &&
 		       (reg < 0x26 || reg > 0x28) && reg != 0x33 && reg != 0x37 &&
 		       (reg < 0x63 || reg > 0x7f) && reg != 0x81 && reg < 0xf0;
@@ -955,14 +964,14 @@ static void saa711x_set_v4lstd(struct v4l2_subdev *sd, v4l2_std_id std)
 	// This works for NTSC-M, SECAM-L and the 50Hz PAL variants.
 	if (std & V4L2_STD_525_60) {
 		v4l2_dbg(1, debug, sd, "decoder set standard 60 Hz\n");
-		if (state->ident == V4L2_IDENT_GM7113C)
+		if (state->ident == GM7113C)
 			saa711x_writeregs(sd, gm7113c_cfg_60hz_video);
 		else
 			saa711x_writeregs(sd, saa7115_cfg_60hz_video);
 		saa711x_set_size(sd, 720, 480);
 	} else {
 		v4l2_dbg(1, debug, sd, "decoder set standard 50 Hz\n");
-		if (state->ident == V4L2_IDENT_GM7113C)
+		if (state->ident == GM7113C)
 			saa711x_writeregs(sd, gm7113c_cfg_50hz_video);
 		else
 			saa711x_writeregs(sd, saa7115_cfg_50hz_video);
@@ -978,8 +987,8 @@ static void saa711x_set_v4lstd(struct v4l2_subdev *sd, v4l2_std_id std)
 	011 NTSC N (3.58MHz)            PAL M (3.58MHz)
 	100 reserved                    NTSC-Japan (3.58MHz)
 	*/
-	if (state->ident <= V4L2_IDENT_SAA7113 ||
-	    state->ident == V4L2_IDENT_GM7113C) {
+	if (state->ident <= SAA7113 ||
+	    state->ident == GM7113C) {
 		u8 reg = saa711x_read(sd, R_0E_CHROMA_CNTL_1) & 0x8f;
 
 		if (std == V4L2_STD_PAL_M) {
@@ -998,9 +1007,8 @@ static void saa711x_set_v4lstd(struct v4l2_subdev *sd, v4l2_std_id std)
 		/* restart task B if needed */
 		int taskb = saa711x_read(sd, R_80_GLOBAL_CNTL_1) & 0x10;
 
-		if (taskb && state->ident == V4L2_IDENT_SAA7114) {
+		if (taskb && state->ident == SAA7114)
 			saa711x_writeregs(sd, saa7115_cfg_vbi_on);
-		}
 
 		/* switch audio mode too! */
 		saa711x_s_clock_freq(sd, state->audclk_freq);
@@ -1022,7 +1030,7 @@ static void saa711x_set_lcr(struct v4l2_subdev *sd, struct v4l2_sliced_vbi_forma
 
 #else
 	/* SAA7113 and SAA7118 also should support VBI - Need testing */
-	if (state->ident != V4L2_IDENT_SAA7115)
+	if (state->ident != SAA7115)
 		return;
 #endif
 
@@ -1244,14 +1252,14 @@ static int saa711x_s_routing(struct v4l2_subdev *sd,
 			     u32 input, u32 output, u32 config)
 {
 	struct saa711x_state *state = to_state(sd);
-	u8 mask = (state->ident <= V4L2_IDENT_SAA7111A) ? 0xf8 : 0xf0;
+	u8 mask = (state->ident <= SAA7111A) ? 0xf8 : 0xf0;
 
 	v4l2_dbg(1, debug, sd, "decoder set input %d output %d\n",
 		input, output);
 
 	/* saa7111/3 does not have these inputs */
-	if ((state->ident <= V4L2_IDENT_SAA7113 ||
-	     state->ident == V4L2_IDENT_GM7113C) &&
+	if ((state->ident <= SAA7113 ||
+	     state->ident == GM7113C) &&
 	    (input == SAA7115_COMPOSITE4 ||
 	     input == SAA7115_COMPOSITE5)) {
 		return -EINVAL;
@@ -1266,7 +1274,7 @@ static int saa711x_s_routing(struct v4l2_subdev *sd,
 	state->input = input;
 
 	/* saa7111 has slightly different input numbering */
-	if (state->ident <= V4L2_IDENT_SAA7111A) {
+	if (state->ident <= SAA7111A) {
 		if (input >= SAA7115_COMPOSITE4)
 			input -= 2;
 		/* saa7111 specific */
@@ -1289,13 +1297,13 @@ static int saa711x_s_routing(struct v4l2_subdev *sd,
 			(state->input >= SAA7115_SVIDEO0 ? 0x80 : 0x0));
 
 	state->output = output;
-	if (state->ident == V4L2_IDENT_SAA7114 ||
-			state->ident == V4L2_IDENT_SAA7115) {
+	if (state->ident == SAA7114 ||
+			state->ident == SAA7115) {
 		saa711x_write(sd, R_83_X_PORT_I_O_ENA_AND_OUT_CLK,
 				(saa711x_read(sd, R_83_X_PORT_I_O_ENA_AND_OUT_CLK) & 0xfe) |
 				(state->output & 0x01));
 	}
-	if (state->ident > V4L2_IDENT_SAA7111A) {
+	if (state->ident > SAA7111A) {
 		if (config & SAA7115_IDQ_IS_DEFAULT)
 			saa711x_write(sd, R_85_I_PORT_SIGNAL_POLAR, 0x20);
 		else
@@ -1308,7 +1316,7 @@ static int saa711x_s_gpio(struct v4l2_subdev *sd, u32 val)
 {
 	struct saa711x_state *state = to_state(sd);
 
-	if (state->ident > V4L2_IDENT_SAA7111A)
+	if (state->ident > SAA7111A)
 		return -EINVAL;
 	saa711x_write(sd, 0x11, (saa711x_read(sd, 0x11) & 0x7f) |
 		(val ? 0x80 : 0));
@@ -1398,7 +1406,7 @@ static int saa711x_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
 
 	reg1f = saa711x_read(sd, R_1F_STATUS_BYTE_2_VD_DEC);
 
-	if (state->ident == V4L2_IDENT_SAA7115) {
+	if (state->ident == SAA7115) {
 		reg1e = saa711x_read(sd, R_1E_STATUS_BYTE_1_VD_DEC);
 
 		v4l2_dbg(1, debug, sd, "Status byte 1 (0x1e)=0x%02x\n", reg1e);
@@ -1449,7 +1457,7 @@ static int saa711x_g_input_status(struct v4l2_subdev *sd, u32 *status)
 	int reg1f;
 
 	*status = V4L2_IN_ST_NO_SIGNAL;
-	if (state->ident == V4L2_IDENT_SAA7115)
+	if (state->ident == SAA7115)
 		reg1e = saa711x_read(sd, R_1E_STATUS_BYTE_1_VD_DEC);
 	reg1f = saa711x_read(sd, R_1F_STATUS_BYTE_2_VD_DEC);
 	if ((reg1f & 0xc1) == 0x81 && (reg1e & 0xc0) == 0x80)
@@ -1460,10 +1468,6 @@ static int saa711x_g_input_status(struct v4l2_subdev *sd, u32 *status)
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int saa711x_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	reg->val = saa711x_read(sd, reg->reg & 0xff);
 	reg->size = 1;
 	return 0;
@@ -1471,23 +1475,11 @@ static int saa711x_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *
 
 static int saa711x_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	saa711x_write(sd, reg->reg & 0xff, reg->val & 0xff);
 	return 0;
 }
 #endif
 
-static int saa711x_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
-{
-	struct saa711x_state *state = to_state(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, state->ident, 0);
-}
-
 static int saa711x_log_status(struct v4l2_subdev *sd)
 {
 	struct saa711x_state *state = to_state(sd);
@@ -1496,7 +1488,7 @@ static int saa711x_log_status(struct v4l2_subdev *sd)
 	int vcr;
 
 	v4l2_info(sd, "Audio frequency: %d Hz\n", state->audclk_freq);
-	if (state->ident != V4L2_IDENT_SAA7115) {
+	if (state->ident != SAA7115) {
 		/* status for the saa7114 */
 		reg1f = saa711x_read(sd, R_1F_STATUS_BYTE_2_VD_DEC);
 		signalOk = (reg1f & 0xc1) == 0x81;
@@ -1547,7 +1539,6 @@ static const struct v4l2_ctrl_ops saa711x_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops saa711x_core_ops = {
 	.log_status = saa711x_log_status,
-	.g_chip_ident = saa711x_g_chip_ident,
 	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
 	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
 	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
@@ -1650,21 +1641,21 @@ static int saa711x_detect_chip(struct i2c_client *client,
 			if (chip_ver[0] & 0xf0) {
 				snprintf(name, CHIP_VER_SIZE, "saa711%ca", chip_id);
 				v4l_info(client, "saa7111a variant found\n");
-				return V4L2_IDENT_SAA7111A;
+				return SAA7111A;
 			}
-			return V4L2_IDENT_SAA7111;
+			return SAA7111;
 		case '3':
-			return V4L2_IDENT_SAA7113;
+			return SAA7113;
 		case '4':
-			return V4L2_IDENT_SAA7114;
+			return SAA7114;
 		case '5':
-			return V4L2_IDENT_SAA7115;
+			return SAA7115;
 		case '8':
-			return V4L2_IDENT_SAA7118;
+			return SAA7118;
 		default:
 			v4l2_info(client,
 				  "WARNING: Philips/NXP chip unknown - Falling back to saa7111\n");
-			return V4L2_IDENT_SAA7111;
+			return SAA7111;
 		}
 	}
 
@@ -1695,7 +1686,7 @@ static int saa711x_detect_chip(struct i2c_client *client,
 			"It seems to be a %s chip (%*ph) @ 0x%x.\n",
 			name, 16, chip_ver, client->addr << 1);
 
-		return V4L2_IDENT_GM7113C;
+		return GM7113C;
 	}
 
 	/* Chip was not discovered. Return its ID and don't bind */
@@ -1774,19 +1765,19 @@ static int saa711x_probe(struct i2c_client *client,
 	/* init to 60hz/48khz */
 	state->crystal_freq = SAA7115_FREQ_24_576_MHZ;
 	switch (state->ident) {
-	case V4L2_IDENT_SAA7111:
-	case V4L2_IDENT_SAA7111A:
+	case SAA7111:
+	case SAA7111A:
 		saa711x_writeregs(sd, saa7111_init);
 		break;
-	case V4L2_IDENT_GM7113C:
-	case V4L2_IDENT_SAA7113:
+	case GM7113C:
+	case SAA7113:
 		saa711x_writeregs(sd, saa7113_init);
 		break;
 	default:
 		state->crystal_freq = SAA7115_FREQ_32_11_MHZ;
 		saa711x_writeregs(sd, saa7115_init_auto_input);
 	}
-	if (state->ident > V4L2_IDENT_SAA7111A)
+	if (state->ident > SAA7111A)
 		saa711x_writeregs(sd, saa7115_init_misc);
 	saa711x_set_v4lstd(sd, V4L2_STD_NTSC);
 	v4l2_ctrl_handler_setup(hdl);
diff --git a/drivers/media/i2c/saa7127.c b/drivers/media/i2c/saa7127.c
index d9c3881..264b755 100644
--- a/drivers/media/i2c/saa7127.c
+++ b/drivers/media/i2c/saa7127.c
@@ -54,7 +54,6 @@
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/saa7127.h>
 
 static int debug;
@@ -251,10 +250,15 @@ static struct i2c_reg_value saa7127_init_config_50hz_secam[] = {
  **********************************************************************
  */
 
+enum saa712x_model {
+	SAA7127,
+	SAA7129,
+};
+
 struct saa7127_state {
 	struct v4l2_subdev sd;
 	v4l2_std_id std;
-	u32 ident;
+	enum saa712x_model ident;
 	enum saa7127_input_type input_type;
 	enum saa7127_output_type output_type;
 	int video_enable;
@@ -482,7 +486,7 @@ static int saa7127_set_std(struct v4l2_subdev *sd, v4l2_std_id std)
 		inittab = saa7127_init_config_60hz;
 		state->reg_61 = SAA7127_60HZ_DAC_CONTROL;
 
-	} else if (state->ident == V4L2_IDENT_SAA7129 &&
+	} else if (state->ident == SAA7129 &&
 		   (std & V4L2_STD_SECAM) &&
 		   !(std & (V4L2_STD_625_50 & ~V4L2_STD_SECAM))) {
 
@@ -517,7 +521,7 @@ static int saa7127_set_output_type(struct v4l2_subdev *sd, int output)
 		break;
 
 	case SAA7127_OUTPUT_TYPE_COMPOSITE:
-		if (state->ident == V4L2_IDENT_SAA7129)
+		if (state->ident == SAA7129)
 			state->reg_2d = 0x20;	/* CVBS only */
 		else
 			state->reg_2d = 0x08;	/* 00001000 CVBS only, RGB DAC's off (high impedance mode) */
@@ -525,7 +529,7 @@ static int saa7127_set_output_type(struct v4l2_subdev *sd, int output)
 		break;
 
 	case SAA7127_OUTPUT_TYPE_SVIDEO:
-		if (state->ident == V4L2_IDENT_SAA7129)
+		if (state->ident == SAA7129)
 			state->reg_2d = 0x18;	/* Y + C */
 		else
 			state->reg_2d = 0xff;   /*11111111  croma -> R, luma -> CVBS + G + B */
@@ -543,7 +547,7 @@ static int saa7127_set_output_type(struct v4l2_subdev *sd, int output)
 		break;
 
 	case SAA7127_OUTPUT_TYPE_BOTH:
-		if (state->ident == V4L2_IDENT_SAA7129)
+		if (state->ident == SAA7129)
 			state->reg_2d = 0x38;
 		else
 			state->reg_2d = 0xbf;
@@ -661,10 +665,6 @@ static int saa7127_s_vbi_data(struct v4l2_subdev *sd, const struct v4l2_sliced_v
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int saa7127_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	reg->val = saa7127_read(sd, reg->reg & 0xff);
 	reg->size = 1;
 	return 0;
@@ -672,23 +672,11 @@ static int saa7127_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *
 
 static int saa7127_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	saa7127_write(sd, reg->reg & 0xff, reg->val & 0xff);
 	return 0;
 }
 #endif
 
-static int saa7127_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
-{
-	struct saa7127_state *state = to_state(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, state->ident, 0);
-}
-
 static int saa7127_log_status(struct v4l2_subdev *sd)
 {
 	struct saa7127_state *state = to_state(sd);
@@ -708,7 +696,6 @@ static int saa7127_log_status(struct v4l2_subdev *sd)
 
 static const struct v4l2_subdev_core_ops saa7127_core_ops = {
 	.log_status = saa7127_log_status,
-	.g_chip_ident = saa7127_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = saa7127_g_register,
 	.s_register = saa7127_s_register,
@@ -777,10 +764,10 @@ static int saa7127_probe(struct i2c_client *client,
 		if (saa7127_read(sd, SAA7129_REG_FADE_KEY_COL2) == 0xaa) {
 			saa7127_write(sd, SAA7129_REG_FADE_KEY_COL2,
 					read_result);
-			state->ident = V4L2_IDENT_SAA7129;
+			state->ident = SAA7129;
 			strlcpy(client->name, "saa7129", I2C_NAME_SIZE);
 		} else {
-			state->ident = V4L2_IDENT_SAA7127;
+			state->ident = SAA7127;
 			strlcpy(client->name, "saa7127", I2C_NAME_SIZE);
 		}
 	}
@@ -804,7 +791,7 @@ static int saa7127_probe(struct i2c_client *client,
 		saa7127_set_input_type(sd, SAA7127_INPUT_TYPE_NORMAL);
 	saa7127_set_video_enable(sd, 1);
 
-	if (state->ident == V4L2_IDENT_SAA7129)
+	if (state->ident == SAA7129)
 		saa7127_write_inittab(sd, saa7129_init_config_extra);
 	return 0;
 }
@@ -825,10 +812,10 @@ static int saa7127_remove(struct i2c_client *client)
 
 static struct i2c_device_id saa7127_id[] = {
 	{ "saa7127_auto", 0 },	/* auto-detection */
-	{ "saa7126", V4L2_IDENT_SAA7127 },
-	{ "saa7127", V4L2_IDENT_SAA7127 },
-	{ "saa7128", V4L2_IDENT_SAA7129 },
-	{ "saa7129", V4L2_IDENT_SAA7129 },
+	{ "saa7126", SAA7127 },
+	{ "saa7127", SAA7127 },
+	{ "saa7128", SAA7129 },
+	{ "saa7129", SAA7129 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, saa7127_id);
diff --git a/drivers/media/i2c/saa717x.c b/drivers/media/i2c/saa717x.c
index 330a04c..401ca11 100644
--- a/drivers/media/i2c/saa717x.c
+++ b/drivers/media/i2c/saa717x.c
@@ -977,10 +977,6 @@ static int saa717x_s_video_routing(struct v4l2_subdev *sd,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int saa717x_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	reg->val = saa717x_read(sd, reg->reg);
 	reg->size = 1;
 	return 0;
@@ -988,12 +984,9 @@ static int saa717x_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *
 
 static int saa717x_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	u16 addr = reg->reg & 0xffff;
 	u8 val = reg->val & 0xff;
 
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	saa717x_write(sd, addr, val);
 	return 0;
 }
diff --git a/drivers/media/i2c/saa7185.c b/drivers/media/i2c/saa7185.c
index e95a0ed..f56c1c8 100644
--- a/drivers/media/i2c/saa7185.c
+++ b/drivers/media/i2c/saa7185.c
@@ -32,7 +32,6 @@
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 
 MODULE_DESCRIPTION("Philips SAA7185 video encoder driver");
 MODULE_AUTHOR("Dave Perks");
@@ -285,17 +284,9 @@ static int saa7185_s_routing(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int saa7185_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_SAA7185, 0);
-}
-
 /* ----------------------------------------------------------------------- */
 
 static const struct v4l2_subdev_core_ops saa7185_core_ops = {
-	.g_chip_ident = saa7185_g_chip_ident,
 	.init = saa7185_init,
 };
 
diff --git a/drivers/media/i2c/saa7191.c b/drivers/media/i2c/saa7191.c
index 84f7899..08dcaec 100644
--- a/drivers/media/i2c/saa7191.c
+++ b/drivers/media/i2c/saa7191.c
@@ -22,7 +22,6 @@
 #include <linux/videodev2.h>
 #include <linux/i2c.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 
 #include "saa7191.h"
 
@@ -567,18 +566,9 @@ static int saa7191_g_input_status(struct v4l2_subdev *sd, u32 *status)
 }
 
 
-static int saa7191_g_chip_ident(struct v4l2_subdev *sd,
-		struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_SAA7191, 0);
-}
-
 /* ----------------------------------------------------------------------- */
 
 static const struct v4l2_subdev_core_ops saa7191_core_ops = {
-	.g_chip_ident = saa7191_g_chip_ident,
 	.g_ctrl = saa7191_g_ctrl,
 	.s_ctrl = saa7191_s_ctrl,
 	.s_std = saa7191_s_std,
diff --git a/drivers/media/i2c/tda9840.c b/drivers/media/i2c/tda9840.c
index 3f12662..fbdff8b 100644
--- a/drivers/media/i2c/tda9840.c
+++ b/drivers/media/i2c/tda9840.c
@@ -31,7 +31,6 @@
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 
 MODULE_AUTHOR("Michael Hunold <michael@mihu.de>");
 MODULE_DESCRIPTION("tda9840 driver");
@@ -145,26 +144,14 @@ static int tda9840_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *t)
 	return 0;
 }
 
-static int tda9840_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_TDA9840, 0);
-}
-
 /* ----------------------------------------------------------------------- */
 
-static const struct v4l2_subdev_core_ops tda9840_core_ops = {
-	.g_chip_ident = tda9840_g_chip_ident,
-};
-
 static const struct v4l2_subdev_tuner_ops tda9840_tuner_ops = {
 	.s_tuner = tda9840_s_tuner,
 	.g_tuner = tda9840_g_tuner,
 };
 
 static const struct v4l2_subdev_ops tda9840_ops = {
-	.core = &tda9840_core_ops,
 	.tuner = &tda9840_tuner_ops,
 };
 
diff --git a/drivers/media/i2c/tea6415c.c b/drivers/media/i2c/tea6415c.c
index 52ebc38..bbe1a99 100644
--- a/drivers/media/i2c/tea6415c.c
+++ b/drivers/media/i2c/tea6415c.c
@@ -33,7 +33,6 @@
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 #include "tea6415c.h"
 
 MODULE_AUTHOR("Michael Hunold <michael@mihu.de>");
@@ -119,25 +118,13 @@ static int tea6415c_s_routing(struct v4l2_subdev *sd,
 	return ret;
 }
 
-static int tea6415c_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_TEA6415C, 0);
-}
-
 /* ----------------------------------------------------------------------- */
 
-static const struct v4l2_subdev_core_ops tea6415c_core_ops = {
-	.g_chip_ident = tea6415c_g_chip_ident,
-};
-
 static const struct v4l2_subdev_video_ops tea6415c_video_ops = {
 	.s_routing = tea6415c_s_routing,
 };
 
 static const struct v4l2_subdev_ops tea6415c_ops = {
-	.core = &tea6415c_core_ops,
 	.video = &tea6415c_video_ops,
 };
 
diff --git a/drivers/media/i2c/tea6420.c b/drivers/media/i2c/tea6420.c
index 1f86974..30a8d75 100644
--- a/drivers/media/i2c/tea6420.c
+++ b/drivers/media/i2c/tea6420.c
@@ -33,7 +33,6 @@
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 #include "tea6420.h"
 
 MODULE_AUTHOR("Michael Hunold <michael@mihu.de>");
@@ -90,25 +89,13 @@ static int tea6420_s_routing(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int tea6420_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_TEA6420, 0);
-}
-
 /* ----------------------------------------------------------------------- */
 
-static const struct v4l2_subdev_core_ops tea6420_core_ops = {
-	.g_chip_ident = tea6420_g_chip_ident,
-};
-
 static const struct v4l2_subdev_audio_ops tea6420_audio_ops = {
 	.s_routing = tea6420_s_routing,
 };
 
 static const struct v4l2_subdev_ops tea6420_ops = {
-	.core = &tea6420_core_ops,
 	.audio = &tea6420_audio_ops,
 };
 
diff --git a/drivers/media/i2c/ths7303.c b/drivers/media/i2c/ths7303.c
index 65853ee..709c29b 100644
--- a/drivers/media/i2c/ths7303.c
+++ b/drivers/media/i2c/ths7303.c
@@ -26,7 +26,6 @@
 #include <linux/slab.h>
 
 #include <media/ths7303.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-device.h>
 
 #define THS7303_CHANNEL_1	1
@@ -212,15 +211,6 @@ static int ths7303_s_dv_timings(struct v4l2_subdev *sd,
 	return ths7303_config(sd);
 }
 
-static int ths7303_g_chip_ident(struct v4l2_subdev *sd,
-				struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct ths7303_state *state = to_state(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, state->driver_data, 0);
-}
-
 static const struct v4l2_subdev_video_ops ths7303_video_ops = {
 	.s_stream	= ths7303_s_stream,
 	.s_std_output	= ths7303_s_std_output,
@@ -232,11 +222,6 @@ static const struct v4l2_subdev_video_ops ths7303_video_ops = {
 static int ths7303_g_register(struct v4l2_subdev *sd,
 			      struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
-
 	reg->size = 1;
 	reg->val = ths7303_read(sd, reg->reg);
 	return 0;
@@ -245,11 +230,6 @@ static int ths7303_g_register(struct v4l2_subdev *sd,
 static int ths7303_s_register(struct v4l2_subdev *sd,
 			      const struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
-
 	ths7303_write(sd, reg->reg, reg->val);
 	return 0;
 }
@@ -336,7 +316,6 @@ static int ths7303_log_status(struct v4l2_subdev *sd)
 }
 
 static const struct v4l2_subdev_core_ops ths7303_core_ops = {
-	.g_chip_ident = ths7303_g_chip_ident,
 	.log_status = ths7303_log_status,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = ths7303_g_register,
@@ -422,8 +401,8 @@ static int ths7303_remove(struct i2c_client *client)
 }
 
 static const struct i2c_device_id ths7303_id[] = {
-	{"ths7303", V4L2_IDENT_THS7303},
-	{"ths7353", V4L2_IDENT_THS7353},
+	{"ths7303", 0},
+	{"ths7353", 0},
 	{},
 };
 
diff --git a/drivers/media/i2c/tvaudio.c b/drivers/media/i2c/tvaudio.c
index fc69e9c..3813540 100644
--- a/drivers/media/i2c/tvaudio.c
+++ b/drivers/media/i2c/tvaudio.c
@@ -38,7 +38,6 @@
 
 #include <media/tvaudio.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 
 #include <media/i2c-addr.h>
@@ -1838,13 +1837,6 @@ static int tvaudio_s_frequency(struct v4l2_subdev *sd, const struct v4l2_frequen
 	return 0;
 }
 
-static int tvaudio_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_TVAUDIO, 0);
-}
-
 static int tvaudio_log_status(struct v4l2_subdev *sd)
 {
 	struct CHIPSTATE *chip = to_state(sd);
@@ -1863,7 +1855,6 @@ static const struct v4l2_ctrl_ops tvaudio_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops tvaudio_core_ops = {
 	.log_status = tvaudio_log_status,
-	.g_chip_ident = tvaudio_g_chip_ident,
 	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
 	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
 	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index 7438e01..b5c17eb 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -39,7 +39,6 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-mediabus.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 #include <media/tvp514x.h>
 #include <media/media-entity.h>
diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index b3cf266..bef5282 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <media/v4l2-device.h>
 #include <media/tvp5150.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 
 #include "tvp5150_reg.h"
@@ -1031,29 +1030,11 @@ static int tvp5150_g_sliced_fmt(struct v4l2_subdev *sd, struct v4l2_sliced_vbi_f
 	return 0;
 }
 
-static int tvp5150_g_chip_ident(struct v4l2_subdev *sd,
-				struct v4l2_dbg_chip_ident *chip)
-{
-	int rev;
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	rev = tvp5150_read(sd, TVP5150_ROM_MAJOR_VER) << 8 |
-	      tvp5150_read(sd, TVP5150_ROM_MINOR_VER);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_TVP5150,
-					  rev);
-}
-
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int tvp5150_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
 {
 	int res;
 
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	res = tvp5150_read(sd, reg->reg & 0xff);
 	if (res < 0) {
 		v4l2_err(sd, "%s: failed with error = %d\n", __func__, res);
@@ -1067,10 +1048,6 @@ static int tvp5150_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *
 
 static int tvp5150_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	tvp5150_write(sd, reg->reg & 0xff, reg->val & 0xff);
 	return 0;
 }
@@ -1094,7 +1071,6 @@ static const struct v4l2_subdev_core_ops tvp5150_core_ops = {
 	.log_status = tvp5150_log_status,
 	.s_std = tvp5150_s_std,
 	.reset = tvp5150_reset,
-	.g_chip_ident = tvp5150_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = tvp5150_g_register,
 	.s_register = tvp5150_s_register,
diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index f339e6f..c2d0280 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -32,7 +32,6 @@
 #include <linux/v4l2-dv-timings.h>
 #include <media/tvp7002.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
 #include "tvp7002_reg.h"
@@ -533,29 +532,6 @@ static inline void tvp7002_write_err(struct v4l2_subdev *sd, u8 reg,
 }
 
 /*
- * tvp7002_g_chip_ident() - Get chip identification number
- * @sd: ptr to v4l2_subdev struct
- * @chip: ptr to v4l2_dbg_chip_ident struct
- *
- * Obtains the chip's identification number.
- * Returns zero or -EINVAL if read operation fails.
- */
-static int tvp7002_g_chip_ident(struct v4l2_subdev *sd,
-					struct v4l2_dbg_chip_ident *chip)
-{
-	u8 rev;
-	int error;
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	error = tvp7002_read(sd, TVP7002_CHIP_REV, &rev);
-
-	if (error < 0)
-		return error;
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_TVP7002, rev);
-}
-
-/*
  * tvp7002_write_inittab() - Write initialization values
  * @sd: ptr to v4l2_subdev struct
  * @regs: ptr to i2c_reg_value struct
@@ -741,13 +717,9 @@ static int tvp7002_query_dv_timings(struct v4l2_subdev *sd,
 static int tvp7002_g_register(struct v4l2_subdev *sd,
 						struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	u8 val;
 	int ret;
 
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
-
 	ret = tvp7002_read(sd, reg->reg & 0xff, &val);
 	reg->val = val;
 	return ret;
@@ -764,11 +736,6 @@ static int tvp7002_g_register(struct v4l2_subdev *sd,
 static int tvp7002_s_register(struct v4l2_subdev *sd,
 						const struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
-
 	return tvp7002_write(sd, reg->reg & 0xff, reg->val & 0xff);
 }
 #endif
@@ -933,7 +900,6 @@ tvp7002_set_pad_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 
 /* V4L2 core operation handlers */
 static const struct v4l2_subdev_core_ops tvp7002_core_ops = {
-	.g_chip_ident = tvp7002_g_chip_ident,
 	.log_status = tvp7002_log_status,
 	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
 	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
diff --git a/drivers/media/i2c/tw2804.c b/drivers/media/i2c/tw2804.c
index 41a5c9b..f58607d 100644
--- a/drivers/media/i2c/tw2804.c
+++ b/drivers/media/i2c/tw2804.c
@@ -23,7 +23,6 @@
 #include <linux/slab.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 
 #define TW2804_REG_AUTOGAIN		0x02
diff --git a/drivers/media/i2c/upd64031a.c b/drivers/media/i2c/upd64031a.c
index 13a4cf8..d248e6a 100644
--- a/drivers/media/i2c/upd64031a.c
+++ b/drivers/media/i2c/upd64031a.c
@@ -27,7 +27,6 @@
 #include <linux/videodev2.h>
 #include <linux/slab.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/upd64031a.h>
 
 /* --------------------- read registers functions define -------------------- */
@@ -147,13 +146,6 @@ static int upd64031a_s_routing(struct v4l2_subdev *sd,
 	return upd64031a_s_frequency(sd, NULL);
 }
 
-static int upd64031a_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_UPD64031A, 0);
-}
-
 static int upd64031a_log_status(struct v4l2_subdev *sd)
 {
 	v4l2_info(sd, "Status: SA00=0x%02x SA01=0x%02x\n",
@@ -164,10 +156,6 @@ static int upd64031a_log_status(struct v4l2_subdev *sd)
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int upd64031a_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	reg->val = upd64031a_read(sd, reg->reg & 0xff);
 	reg->size = 1;
 	return 0;
@@ -175,10 +163,6 @@ static int upd64031a_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register
 
 static int upd64031a_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	upd64031a_write(sd, reg->reg & 0xff, reg->val & 0xff);
 	return 0;
 }
@@ -188,7 +172,6 @@ static int upd64031a_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_re
 
 static const struct v4l2_subdev_core_ops upd64031a_core_ops = {
 	.log_status = upd64031a_log_status,
-	.g_chip_ident = upd64031a_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = upd64031a_g_register,
 	.s_register = upd64031a_s_register,
diff --git a/drivers/media/i2c/upd64083.c b/drivers/media/i2c/upd64083.c
index e296639..3a152ce 100644
--- a/drivers/media/i2c/upd64083.c
+++ b/drivers/media/i2c/upd64083.c
@@ -27,7 +27,6 @@
 #include <linux/videodev2.h>
 #include <linux/slab.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/upd64083.h>
 
 MODULE_DESCRIPTION("uPD64083 driver");
@@ -122,10 +121,6 @@ static int upd64083_s_routing(struct v4l2_subdev *sd,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int upd64083_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	reg->val = upd64083_read(sd, reg->reg & 0xff);
 	reg->size = 1;
 	return 0;
@@ -133,22 +128,11 @@ static int upd64083_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register
 
 static int upd64083_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	upd64083_write(sd, reg->reg & 0xff, reg->val & 0xff);
 	return 0;
 }
 #endif
 
-static int upd64083_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_UPD64083, 0);
-}
-
 static int upd64083_log_status(struct v4l2_subdev *sd)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -165,7 +149,6 @@ static int upd64083_log_status(struct v4l2_subdev *sd)
 
 static const struct v4l2_subdev_core_ops upd64083_core_ops = {
 	.log_status = upd64083_log_status,
-	.g_chip_ident = upd64083_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = upd64083_g_register,
 	.s_register = upd64083_s_register,
diff --git a/drivers/media/i2c/vp27smpx.c b/drivers/media/i2c/vp27smpx.c
index 208a095..6a3a3ff 100644
--- a/drivers/media/i2c/vp27smpx.c
+++ b/drivers/media/i2c/vp27smpx.c
@@ -29,7 +29,6 @@
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 
 MODULE_DESCRIPTION("vp27smpx driver");
 MODULE_AUTHOR("Hans Verkuil");
@@ -112,13 +111,6 @@ static int vp27smpx_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	return 0;
 }
 
-static int vp27smpx_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_VP27SMPX, 0);
-}
-
 static int vp27smpx_log_status(struct v4l2_subdev *sd)
 {
 	struct vp27smpx_state *state = to_state(sd);
@@ -132,7 +124,6 @@ static int vp27smpx_log_status(struct v4l2_subdev *sd)
 
 static const struct v4l2_subdev_core_ops vp27smpx_core_ops = {
 	.log_status = vp27smpx_log_status,
-	.g_chip_ident = vp27smpx_g_chip_ident,
 	.s_std = vp27smpx_s_std,
 };
 
diff --git a/drivers/media/i2c/vpx3220.c b/drivers/media/i2c/vpx3220.c
index f02e74b..4c57d8a 100644
--- a/drivers/media/i2c/vpx3220.c
+++ b/drivers/media/i2c/vpx3220.c
@@ -27,7 +27,6 @@
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 
 MODULE_DESCRIPTION("vpx3220a/vpx3216b/vpx3214c video decoder driver");
@@ -49,7 +48,6 @@ struct vpx3220 {
 	unsigned char reg[255];
 
 	v4l2_std_id norm;
-	int ident;
 	int input;
 	int enable;
 };
@@ -442,14 +440,6 @@ static int vpx3220_s_ctrl(struct v4l2_ctrl *ctrl)
 	return -EINVAL;
 }
 
-static int vpx3220_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
-{
-	struct vpx3220 *decoder = to_vpx3220(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, decoder->ident, 0);
-}
-
 /* ----------------------------------------------------------------------- */
 
 static const struct v4l2_ctrl_ops vpx3220_ctrl_ops = {
@@ -457,7 +447,6 @@ static const struct v4l2_ctrl_ops vpx3220_ctrl_ops = {
 };
 
 static const struct v4l2_subdev_core_ops vpx3220_core_ops = {
-	.g_chip_ident = vpx3220_g_chip_ident,
 	.init = vpx3220_init,
 	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
 	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
@@ -528,7 +517,6 @@ static int vpx3220_probe(struct i2c_client *client,
 	ver = i2c_smbus_read_byte_data(client, 0x00);
 	pn = (i2c_smbus_read_byte_data(client, 0x02) << 8) +
 		i2c_smbus_read_byte_data(client, 0x01);
-	decoder->ident = V4L2_IDENT_VPX3220A;
 	if (ver == 0xec) {
 		switch (pn) {
 		case 0x4680:
@@ -536,11 +524,9 @@ static int vpx3220_probe(struct i2c_client *client,
 			break;
 		case 0x4260:
 			name = "vpx3216b";
-			decoder->ident = V4L2_IDENT_VPX3216B;
 			break;
 		case 0x4280:
 			name = "vpx3214c";
-			decoder->ident = V4L2_IDENT_VPX3214C;
 			break;
 		}
 	}
diff --git a/drivers/media/i2c/vs6624.c b/drivers/media/i2c/vs6624.c
index d2209a3..25bdd93 100644
--- a/drivers/media/i2c/vs6624.c
+++ b/drivers/media/i2c/vs6624.c
@@ -27,7 +27,6 @@
 #include <linux/types.h>
 #include <linux/videodev2.h>
 
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-mediabus.h>
@@ -722,25 +721,9 @@ static int vs6624_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-static int vs6624_g_chip_ident(struct v4l2_subdev *sd,
-		struct v4l2_dbg_chip_ident *chip)
-{
-	int rev;
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	rev = (vs6624_read(sd, VS6624_FW_VSN_MAJOR) << 8)
-		| vs6624_read(sd, VS6624_FW_VSN_MINOR);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_VS6624, rev);
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int vs6624_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	reg->val = vs6624_read(sd, reg->reg & 0xffff);
 	reg->size = 1;
 	return 0;
@@ -748,10 +731,6 @@ static int vs6624_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *r
 
 static int vs6624_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (!v4l2_chip_match_i2c_client(client, &reg->match))
-		return -EINVAL;
 	vs6624_write(sd, reg->reg & 0xffff, reg->val & 0xff);
 	return 0;
 }
@@ -762,7 +741,6 @@ static const struct v4l2_ctrl_ops vs6624_ctrl_ops = {
 };
 
 static const struct v4l2_subdev_core_ops vs6624_core_ops = {
-	.g_chip_ident = vs6624_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = vs6624_g_register,
 	.s_register = vs6624_s_register,
diff --git a/drivers/media/i2c/wm8739.c b/drivers/media/i2c/wm8739.c
index ac3faa7..3be73f6 100644
--- a/drivers/media/i2c/wm8739.c
+++ b/drivers/media/i2c/wm8739.c
@@ -29,7 +29,6 @@
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 
 MODULE_DESCRIPTION("wm8739 driver");
@@ -160,13 +159,6 @@ static int wm8739_s_clock_freq(struct v4l2_subdev *sd, u32 audiofreq)
 	return 0;
 }
 
-static int wm8739_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_WM8739, 0);
-}
-
 static int wm8739_log_status(struct v4l2_subdev *sd)
 {
 	struct wm8739_state *state = to_state(sd);
@@ -184,7 +176,6 @@ static const struct v4l2_ctrl_ops wm8739_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops wm8739_core_ops = {
 	.log_status = wm8739_log_status,
-	.g_chip_ident = wm8739_g_chip_ident,
 	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
 	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
 	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
diff --git a/drivers/media/i2c/wm8775.c b/drivers/media/i2c/wm8775.c
index 75ded82..3f584a7 100644
--- a/drivers/media/i2c/wm8775.c
+++ b/drivers/media/i2c/wm8775.c
@@ -33,7 +33,6 @@
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 #include <media/wm8775.h>
 
@@ -158,13 +157,6 @@ static int wm8775_s_ctrl(struct v4l2_ctrl *ctrl)
 	return -EINVAL;
 }
 
-static int wm8775_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_WM8775, 0);
-}
-
 static int wm8775_log_status(struct v4l2_subdev *sd)
 {
 	struct wm8775_state *state = to_state(sd);
@@ -188,7 +180,6 @@ static const struct v4l2_ctrl_ops wm8775_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops wm8775_core_ops = {
 	.log_status = wm8775_log_status,
-	.g_chip_ident = wm8775_g_chip_ident,
 	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
 	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
 	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
-- 
1.7.10.4

