Return-path: <mchehab@localhost>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39112 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab1GLPjI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2011 11:39:08 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de,
	Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH 1/5] mt9m111: set inital return values to zero
Date: Tue, 12 Jul 2011 17:39:02 +0200
Message-Id: <1310485146-27759-1-git-send-email-m.grzeschik@pengutronix.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/media/video/mt9m111.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index ebebed9..f10dcf0 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -190,7 +190,7 @@ static struct mt9m111 *to_mt9m111(const struct i2c_client *client)
 
 static int reg_page_map_set(struct i2c_client *client, const u16 reg)
 {
-	int ret;
+	int ret = 0;
 	u16 page;
 	static int lastpage = -1;	/* PageMap cache value */
 
@@ -208,7 +208,7 @@ static int reg_page_map_set(struct i2c_client *client, const u16 reg)
 
 static int mt9m111_reg_read(struct i2c_client *client, const u16 reg)
 {
-	int ret;
+	int ret = 0;
 
 	ret = reg_page_map_set(client, reg);
 	if (!ret)
@@ -221,7 +221,7 @@ static int mt9m111_reg_read(struct i2c_client *client, const u16 reg)
 static int mt9m111_reg_write(struct i2c_client *client, const u16 reg,
 			     const u16 data)
 {
-	int ret;
+	int ret = 0;
 
 	ret = reg_page_map_set(client, reg);
 	if (!ret)
@@ -234,7 +234,7 @@ static int mt9m111_reg_write(struct i2c_client *client, const u16 reg,
 static int mt9m111_reg_set(struct i2c_client *client, const u16 reg,
 			   const u16 data)
 {
-	int ret;
+	int ret = 0;
 
 	ret = mt9m111_reg_read(client, reg);
 	if (ret >= 0)
@@ -245,7 +245,7 @@ static int mt9m111_reg_set(struct i2c_client *client, const u16 reg,
 static int mt9m111_reg_clear(struct i2c_client *client, const u16 reg,
 			     const u16 data)
 {
-	int ret;
+	int ret = 0;
 
 	ret = mt9m111_reg_read(client, reg);
 	return mt9m111_reg_write(client, reg, ret & ~data);
@@ -387,7 +387,7 @@ static int mt9m111_setfmt_yuv(struct i2c_client *client)
 static int mt9m111_enable(struct i2c_client *client)
 {
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
-	int ret;
+	int ret = 0;
 
 	ret = reg_set(RESET, MT9M111_RESET_CHIP_ENABLE);
 	if (!ret)
@@ -397,7 +397,7 @@ static int mt9m111_enable(struct i2c_client *client)
 
 static int mt9m111_reset(struct i2c_client *client)
 {
-	int ret;
+	int ret = 0;
 
 	ret = reg_set(RESET, MT9M111_RESET_RESET_MODE);
 	if (!ret)
@@ -452,7 +452,7 @@ static int mt9m111_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	struct v4l2_rect rect = a->c;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
-	int ret;
+	int ret = 0;
 
 	dev_dbg(&client->dev, "%s left=%d, top=%d, width=%d, height=%d\n",
 		__func__, rect.left, rect.top, rect.width, rect.height);
@@ -568,7 +568,7 @@ static int mt9m111_s_fmt(struct v4l2_subdev *sd,
 		.width	= mf->width,
 		.height	= mf->height,
 	};
-	int ret;
+	int ret = 0;
 
 	fmt = mt9m111_find_datafmt(mf->code, mt9m111_colour_fmts,
 				   ARRAY_SIZE(mt9m111_colour_fmts));
@@ -741,7 +741,7 @@ static struct soc_camera_ops mt9m111_ops = {
 static int mt9m111_set_flip(struct i2c_client *client, int flip, int mask)
 {
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
-	int ret;
+	int ret = 0;
 
 	if (mt9m111->context == HIGHPOWER) {
 		if (flip)
@@ -791,7 +791,7 @@ static int mt9m111_set_global_gain(struct i2c_client *client, int gain)
 static int mt9m111_set_autoexposure(struct i2c_client *client, int on)
 {
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
-	int ret;
+	int ret = 0;
 
 	if (on)
 		ret = reg_set(OPER_MODE_CTRL, MT9M111_OPMODE_AUTOEXPO_EN);
@@ -807,7 +807,7 @@ static int mt9m111_set_autoexposure(struct i2c_client *client, int on)
 static int mt9m111_set_autowhitebalance(struct i2c_client *client, int on)
 {
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
-	int ret;
+	int ret = 0;
 
 	if (on)
 		ret = reg_set(OPER_MODE_CTRL, MT9M111_OPMODE_AUTOWHITEBAL_EN);
@@ -868,7 +868,7 @@ static int mt9m111_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	const struct v4l2_queryctrl *qctrl;
-	int ret;
+	int ret = 0;
 
 	qctrl = soc_camera_find_qctrl(&mt9m111_ops, ctrl->id);
 	if (!qctrl)
@@ -945,7 +945,7 @@ static int mt9m111_resume(struct soc_camera_device *icd)
 static int mt9m111_init(struct i2c_client *client)
 {
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
-	int ret;
+	int ret = 0;
 
 	mt9m111->context = HIGHPOWER;
 	ret = mt9m111_enable(client);
@@ -969,7 +969,7 @@ static int mt9m111_video_probe(struct soc_camera_device *icd,
 {
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	s32 data;
-	int ret;
+	int ret = 0;
 
 	/*
 	 * We must have a parent by now. And it cannot be a wrong one.
@@ -1053,7 +1053,7 @@ static int mt9m111_probe(struct i2c_client *client,
 	struct soc_camera_device *icd = client->dev.platform_data;
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
 	struct soc_camera_link *icl;
-	int ret;
+	int ret = 0;
 
 	if (!icd) {
 		dev_err(&client->dev, "mt9m111: soc-camera data missing!\n");
-- 
1.7.5.4

