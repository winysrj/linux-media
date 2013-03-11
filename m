Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2004 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab3CKLqx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:46:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 15/42] go7007: i2c initialization changes for tw2804
Date: Mon, 11 Mar 2013 12:45:53 +0100
Message-Id: <3c76a3818b822080196b255e88d139ca6e08140c.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Volokh Konstantin <volokh84@gmail.com>

Do i2c initialization via struct item as tw2804 has a 0x00 i2c address,
so we need to use the I2C_CLIENT_TEN flag for validity.

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/go7007-driver.c |   20 +++++++++++---------
 drivers/staging/media/go7007/go7007-priv.h   |    3 ++-
 drivers/staging/media/go7007/go7007-usb.c    |    1 +
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
index 6695091..2e5be70 100644
--- a/drivers/staging/media/go7007/go7007-driver.c
+++ b/drivers/staging/media/go7007/go7007-driver.c
@@ -196,18 +196,22 @@ int go7007_reset_encoder(struct go7007 *go)
 /*
  * Attempt to instantiate an I2C client by ID, probably loading a module.
  */
-static int init_i2c_module(struct i2c_adapter *adapter, const char *type,
-			   int addr)
+static int init_i2c_module(struct i2c_adapter *adapter, const struct go_i2c *const i2c)
 {
 	struct go7007 *go = i2c_get_adapdata(adapter);
 	struct v4l2_device *v4l2_dev = &go->v4l2_dev;
+	struct i2c_board_info info;
 
-	if (v4l2_i2c_new_subdev(v4l2_dev, adapter, type, addr, NULL))
+	memset(&info, 0, sizeof(info));
+	strlcpy(info.type, i2c->type, sizeof(info.type));
+	info.addr = i2c->addr;
+	info.flags = i2c->flags;
+
+	if (v4l2_i2c_new_subdev_board(v4l2_dev, adapter, &info, NULL))
 		return 0;
 
-	dev_info(&adapter->dev,
-		 "go7007: probing for module i2c:%s failed\n", type);
-	return -1;
+	printk(KERN_INFO "go7007: probing for module i2c:%s failed\n", i2c->type);
+	return -EINVAL;
 }
 
 /*
@@ -243,9 +247,7 @@ int go7007_register_encoder(struct go7007 *go)
 	}
 	if (go->i2c_adapter_online) {
 		for (i = 0; i < go->board_info->num_i2c_devs; ++i)
-			init_i2c_module(&go->i2c_adapter,
-					go->board_info->i2c_devs[i].type,
-					go->board_info->i2c_devs[i].addr);
+			init_i2c_module(&go->i2c_adapter, &go->board_info->i2c_devs[i]);
 		if (go->board_id == GO7007_BOARDID_ADLINK_MPG24)
 			i2c_clients_command(&go->i2c_adapter,
 				DECODER_SET_CHANNEL, &go->channel_number);
diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
index b58c394..b9ebdfb 100644
--- a/drivers/staging/media/go7007/go7007-priv.h
+++ b/drivers/staging/media/go7007/go7007-priv.h
@@ -88,10 +88,11 @@ struct go7007_board_info {
 	int audio_bclk_div;
 	int audio_main_div;
 	int num_i2c_devs;
-	struct {
+	struct go_i2c {
 		const char *type;
 		int id;
 		int addr;
+		u32 flags;
 	} i2c_devs[4];
 	int num_inputs;
 	struct {
diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index 3333a8f..b44f9b1 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -398,6 +398,7 @@ static struct go7007_usb_board board_adlink_mpg24 = {
 				.type	= "wis_tw2804",
 				.id	= I2C_DRIVERID_WIS_TW2804,
 				.addr	= 0x00, /* yes, really */
+				.flags  = I2C_CLIENT_TEN,
 			},
 		},
 		.num_inputs	 = 1,
-- 
1.7.10.4

