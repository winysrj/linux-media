Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:51951 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933915AbeFRK3n (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 06:29:43 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
CC: <devicetree@vger.kernel.org>, <linux-media@vger.kernel.org>,
        "Hugues Fruchet" <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v2 3/3] media: ov5640: add support of module orientation
Date: Mon, 18 Jun 2018 12:29:19 +0200
Message-ID: <1529317759-28657-4-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1529317759-28657-1-git-send-email-hugues.fruchet@st.com>
References: <1529317759-28657-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support of module being physically mounted upside down.
In this case, mirror and flip are enabled to fix captured images
orientation.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/i2c/ov5640.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 41039e5..5529b14 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -215,6 +215,7 @@ struct ov5640_dev {
 	struct regulator_bulk_data supplies[OV5640_NUM_SUPPLIES];
 	struct gpio_desc *reset_gpio;
 	struct gpio_desc *pwdn_gpio;
+	bool   upside_down;
 
 	/* lock to protect all members below */
 	struct mutex lock;
@@ -2222,6 +2223,8 @@ static int ov5640_set_ctrl_light_freq(struct ov5640_dev *sensor, int value)
 static int ov5640_set_ctrl_hflip(struct ov5640_dev *sensor, int value)
 {
 	/*
+	 * If sensor is mounted upside down, mirror logic is inversed.
+	 *
 	 * Sensor is a BSI (Back Side Illuminated) one,
 	 * so image captured is physically mirrored.
 	 * This is why mirror logic is inversed in
@@ -2235,11 +2238,14 @@ static int ov5640_set_ctrl_hflip(struct ov5640_dev *sensor, int value)
 	 */
 	return ov5640_mod_reg(sensor, OV5640_REG_TIMING_TC_REG21,
 			      BIT(2) | BIT(1),
-			      (!value) ? (BIT(2) | BIT(1)) : 0);
+			      (!(value ^ sensor->upside_down)) ?
+			      (BIT(2) | BIT(1)) : 0);
 }
 
 static int ov5640_set_ctrl_vflip(struct ov5640_dev *sensor, int value)
 {
+	/* If sensor is mounted upside down, flip logic is inversed */
+
 	/*
 	 * TIMING TC REG20:
 	 * - [2]:	ISP vflip
@@ -2247,7 +2253,8 @@ static int ov5640_set_ctrl_vflip(struct ov5640_dev *sensor, int value)
 	 */
 	return ov5640_mod_reg(sensor, OV5640_REG_TIMING_TC_REG20,
 			      BIT(2) | BIT(1),
-			      value ? (BIT(2) | BIT(1)) : 0);
+			      (value ^ sensor->upside_down) ?
+			      (BIT(2) | BIT(1)) : 0);
 }
 
 static int ov5640_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
@@ -2625,6 +2632,7 @@ static int ov5640_probe(struct i2c_client *client,
 	struct fwnode_handle *endpoint;
 	struct ov5640_dev *sensor;
 	struct v4l2_mbus_framefmt *fmt;
+	u32 rotation;
 	int ret;
 
 	sensor = devm_kzalloc(dev, sizeof(*sensor), GFP_KERNEL);
@@ -2650,6 +2658,22 @@ static int ov5640_probe(struct i2c_client *client,
 
 	sensor->ae_target = 52;
 
+	/* optional indication of physical rotation of sensor */
+	ret = fwnode_property_read_u32(of_fwnode_handle(client->dev.of_node),
+				       "rotation", &rotation);
+	if (!ret) {
+		switch (rotation) {
+		case 180:
+			sensor->upside_down = true;
+			/* fall through */
+		case 0:
+			break;
+		default:
+			dev_warn(dev, "%u degrees rotation is not supported, ignoring...\n",
+				 rotation);
+		}
+	}
+
 	endpoint = fwnode_graph_get_next_endpoint(dev_fwnode(&client->dev),
 						  NULL);
 	if (!endpoint) {
-- 
1.9.1
