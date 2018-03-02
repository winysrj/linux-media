Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:46452 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1426315AbeCBOq6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2018 09:46:58 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: mchehab@s-opensource.com, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, g.liakhovetski@gmx.de, bhumirks@gmail.com,
        joe@perches.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org
Subject: [PATCH v2 01/11] media: tw9910: Re-order variables declaration
Date: Fri,  2 Mar 2018 15:46:33 +0100
Message-Id: <1520002003-10200-2-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1520002003-10200-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1520002003-10200-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Re-order variables declaration to respect 'reverse christmas tree'
ordering whenever possible.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/tw9910.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/tw9910.c b/drivers/media/i2c/tw9910.c
index cc648de..3a5e307 100644
--- a/drivers/media/i2c/tw9910.c
+++ b/drivers/media/i2c/tw9910.c
@@ -406,9 +406,9 @@ static void tw9910_reset(struct i2c_client *client)
 
 static int tw9910_power(struct i2c_client *client, int enable)
 {
-	int ret;
 	u8 acntl1;
 	u8 acntl2;
+	int ret;
 
 	if (enable) {
 		acntl1 = 0;
@@ -428,8 +428,8 @@ static int tw9910_power(struct i2c_client *client, int enable)
 static const struct tw9910_scale_ctrl *tw9910_select_norm(v4l2_std_id norm,
 							  u32 width, u32 height)
 {
-	const struct tw9910_scale_ctrl *scale;
 	const struct tw9910_scale_ctrl *ret = NULL;
+	const struct tw9910_scale_ctrl *scale;
 	__u32 diff = 0xffffffff, tmp;
 	int size, i;
 
@@ -462,8 +462,8 @@ static int tw9910_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct tw9910_priv *priv = to_tw9910(client);
-	u8 val;
 	int ret;
+	u8 val;
 
 	if (!enable) {
 		switch (priv->revision) {
@@ -512,10 +512,10 @@ static int tw9910_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct tw9910_priv *priv = to_tw9910(client);
-	const unsigned int hact = 720;
 	const unsigned int hdelay = 15;
-	unsigned int vact;
+	const unsigned int hact = 720;
 	unsigned int vdelay;
+	unsigned int vact;
 	int ret;
 
 	if (!(norm & (V4L2_STD_NTSC | V4L2_STD_PAL)))
@@ -760,8 +760,8 @@ static int tw9910_get_fmt(struct v4l2_subdev *sd,
 			  struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *format)
 {
-	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct tw9910_priv *priv = to_tw9910(client);
 
 	if (format->pad)
@@ -813,8 +813,8 @@ static int tw9910_set_fmt(struct v4l2_subdev *sd,
 			  struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *format)
 {
-	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct tw9910_priv *priv = to_tw9910(client);
 	const struct tw9910_scale_ctrl *scale;
 
@@ -852,8 +852,8 @@ static int tw9910_set_fmt(struct v4l2_subdev *sd,
 static int tw9910_video_probe(struct i2c_client *client)
 {
 	struct tw9910_priv *priv = to_tw9910(client);
-	s32 id;
 	int ret;
+	s32 id;
 
 	/*
 	 * tw9910 only use 8 or 16 bit bus width
@@ -949,10 +949,9 @@ static int tw9910_probe(struct i2c_client *client,
 			const struct i2c_device_id *did)
 
 {
-	struct tw9910_priv		*priv;
-	struct tw9910_video_info	*info;
-	struct i2c_adapter		*adapter =
-		to_i2c_adapter(client->dev.parent);
+	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
+	struct tw9910_video_info *info;
+	struct tw9910_priv *priv;
 	int ret;
 
 	if (!client->dev.platform_data) {
-- 
2.7.4
