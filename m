Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:35518 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbcGTAEQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 20:04:16 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: lars@metafoo.de
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 04/10] media: adv7180: add support for NEWAVMODE
Date: Tue, 19 Jul 2016 17:03:31 -0700
Message-Id: <1468973017-17647-5-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1468973017-17647-1-git-send-email-steve_longerbeam@mentor.com>
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
 <1468973017-17647-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parse the optional v4l2 endpoint DT node. If the V4L2_MBUS_NEWAVMODE
parallel bus flag is set, configure the BT.656 bus in NEWAVMODE.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/media/i2c/adv7180.c | 47 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index cb83ebb..667931e9 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -31,6 +31,7 @@
 #include <media/v4l2-event.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-of.h>
 #include <linux/mutex.h>
 #include <linux/delay.h>
 
@@ -106,6 +107,7 @@
 #define ADV7180_REG_SHAP_FILTER_CTL_1	0x0017
 #define ADV7180_REG_CTRL_2		0x001d
 #define ADV7180_REG_VSYNC_FIELD_CTL_1	0x0031
+#define ADV7180_VSYNC_FIELD_CTL_1_NEWAVMODE 0x02
 #define ADV7180_REG_MANUAL_WIN_CTL_1	0x003d
 #define ADV7180_REG_MANUAL_WIN_CTL_2	0x003e
 #define ADV7180_REG_MANUAL_WIN_CTL_3	0x003f
@@ -214,6 +216,7 @@ struct adv7180_state {
 	struct mutex		mutex; /* mutual excl. when accessing chip */
 	int			irq;
 	v4l2_std_id		curr_norm;
+	bool			newavmode;
 	bool			powered;
 	bool			streaming;
 	u8			input;
@@ -740,6 +743,8 @@ static int adv7180_g_mbus_config(struct v4l2_subdev *sd,
 		 */
 		cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_PCLK_SAMPLE_RISING |
 				 V4L2_MBUS_DATA_ACTIVE_HIGH;
+		if (state->newavmode)
+			cfg->flags |= V4L2_MBUS_NEWAVMODE;
 		cfg->type = V4L2_MBUS_BT656;
 	}
 
@@ -864,9 +869,15 @@ static int adv7180_init(struct adv7180_state *state)
 	if (ret < 0)
 		return ret;
 
-	/* Manually set V bit end position in NTSC mode */
-	return adv7180_write(state, ADV7180_REG_NTSC_V_BIT_END,
-					ADV7180_NTSC_V_BIT_END_MANUAL_NVEND);
+	if (!state->newavmode) {
+		/* Manually set V bit end position in NTSC mode */
+		ret = adv7180_write(state, ADV7180_REG_NTSC_V_BIT_END,
+				    ADV7180_NTSC_V_BIT_END_MANUAL_NVEND);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
 }
 
 static int adv7180_set_std(struct adv7180_state *state, unsigned int std)
@@ -1217,6 +1228,13 @@ static int init_device(struct adv7180_state *state)
 	if (ret)
 		goto out_unlock;
 
+	if (state->newavmode) {
+		ret = adv7180_write(state, ADV7180_REG_VSYNC_FIELD_CTL_1,
+				    ADV7180_VSYNC_FIELD_CTL_1_NEWAVMODE);
+		if (ret < 0)
+			goto out_unlock;
+	}
+
 	ret = adv7180_program_std(state);
 	if (ret)
 		goto out_unlock;
@@ -1257,6 +1275,27 @@ out_unlock:
 	return ret;
 }
 
+static void adv7180_of_parse(struct adv7180_state *state)
+{
+	struct i2c_client *client = state->client;
+	struct device_node *np = client->dev.of_node;
+	struct device_node *endpoint;
+	struct v4l2_of_endpoint	ep;
+
+	endpoint = of_graph_get_next_endpoint(np, NULL);
+	if (!endpoint) {
+		v4l_warn(client, "endpoint node not found\n");
+		return;
+	}
+
+	v4l2_of_parse_endpoint(endpoint, &ep);
+	of_node_put(endpoint);
+
+	if (ep.bus_type == V4L2_MBUS_BT656 &&
+	    ep.bus.parallel.flags & V4L2_MBUS_NEWAVMODE)
+		state->newavmode = true;
+}
+
 static int adv7180_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
@@ -1279,6 +1318,8 @@ static int adv7180_probe(struct i2c_client *client,
 	state->field = V4L2_FIELD_INTERLACED;
 	state->chip_info = (struct adv7180_chip_info *)id->driver_data;
 
+	adv7180_of_parse(state);
+
 	if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2) {
 		state->csi_client = i2c_new_dummy(client->adapter,
 				ADV7180_DEFAULT_CSI_I2C_ADDR);
-- 
1.9.1

