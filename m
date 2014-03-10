Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48726 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbaCJXOz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 19:14:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 44/48] adv7604: Support hot-plug detect control through a GPIO
Date: Tue, 11 Mar 2014 00:15:55 +0100
Message-Id: <1394493359-14115-45-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for optional GPIO-controlled HPD pins in addition to the
ADV7604-specific hotplug notifier.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/adv7604.c | 37 +++++++++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 0c81c72..7f70c6f 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -28,6 +28,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/gpio/consumer.h>
 #include <linux/i2c.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -135,6 +136,8 @@ struct adv7604_state {
 	const struct adv7604_chip_info *info;
 	struct adv7604_platform_data pdata;
 
+	struct gpio_desc *hpd_gpio[4];
+
 	struct v4l2_subdev sd;
 	struct media_pad pads[ADV7604_PAD_MAX];
 	unsigned int source_pad;
@@ -598,6 +601,20 @@ static inline int edid_write_block(struct v4l2_subdev *sd,
 	return err;
 }
 
+static void adv7604_set_hpd(struct adv7604_state *state, unsigned int hpd)
+{
+	unsigned int i;
+
+	for (i = 0; i < state->info->num_dv_ports; ++i) {
+		if (IS_ERR(state->hpd_gpio[i]))
+			continue;
+
+		gpiod_set_value_cansleep(state->hpd_gpio[i], hpd & BIT(i));
+	}
+
+	v4l2_subdev_notify(&state->sd, ADV7604_HOTPLUG, &hpd);
+}
+
 static void adv7604_delayed_work_enable_hotplug(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
@@ -607,7 +624,7 @@ static void adv7604_delayed_work_enable_hotplug(struct work_struct *work)
 
 	v4l2_dbg(2, debug, sd, "%s: enable hotplug\n", __func__);
 
-	v4l2_subdev_notify(sd, ADV7604_HOTPLUG, (void *)&state->edid.present);
+	adv7604_set_hpd(state, state->edid.present);
 }
 
 static inline int hdmi_read(struct v4l2_subdev *sd, u8 reg)
@@ -2010,7 +2027,6 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edi
 	struct adv7604_state *state = to_state(sd);
 	const struct adv7604_chip_info *info = state->info;
 	int spa_loc;
-	int tmp = 0;
 	int err;
 	int i;
 
@@ -2021,7 +2037,7 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edi
 	if (edid->blocks == 0) {
 		/* Disable hotplug and I2C access to EDID RAM from DDC port */
 		state->edid.present &= ~(1 << edid->pad);
-		v4l2_subdev_notify(sd, ADV7604_HOTPLUG, (void *)&state->edid.present);
+		adv7604_set_hpd(state, state->edid.present);
 		rep_write_clr_set(sd, info->edid_enable_reg, 0x0f, state->edid.present);
 
 		/* Fall back to a 16:9 aspect ratio */
@@ -2045,7 +2061,7 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edi
 
 	/* Disable hotplug and I2C access to EDID RAM from DDC port */
 	cancel_delayed_work_sync(&state->delayed_work_enable_hotplug);
-	v4l2_subdev_notify(sd, ADV7604_HOTPLUG, (void *)&tmp);
+	adv7604_set_hpd(state, 0);
 	rep_write_clr_set(sd, info->edid_enable_reg, 0x0f, 0x00);
 
 	spa_loc = get_edid_spa_location(edid->edid);
@@ -2641,6 +2657,19 @@ static int adv7604_probe(struct i2c_client *client,
 		return -ENODEV;
 	}
 	state->pdata = *pdata;
+
+	/* Request GPIOs. */
+	for (i = 0; i < state->info->num_dv_ports; ++i) {
+		state->hpd_gpio[i] =
+			devm_gpiod_get_index(&client->dev, "hpd", i);
+		if (IS_ERR(state->hpd_gpio[i]))
+			continue;
+
+		gpiod_set_value_cansleep(state->hpd_gpio[i], 0);
+
+		v4l_info(client, "Handling HPD %u GPIO\n", i);
+	}
+
 	state->timings = cea640x480;
 	state->format = adv7604_format_info(state, V4L2_MBUS_FMT_YUYV8_2X8);
 
-- 
1.8.3.2

