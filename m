Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:59126 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753090AbdLGMlh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Dec 2017 07:41:37 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v3 2/5] media: ov5640: check chip id
Date: Thu, 7 Dec 2017 13:40:50 +0100
Message-ID: <1512650453-24476-3-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1512650453-24476-1-git-send-email-hugues.fruchet@st.com>
References: <1512650453-24476-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Verify that chip identifier is correct when probing.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/i2c/ov5640.c | 95 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 79 insertions(+), 16 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 61071f5..9f031f3 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1547,24 +1547,58 @@ static void ov5640_reset(struct ov5640_dev *sensor)
 	usleep_range(5000, 10000);
 }
 
-static int ov5640_set_power(struct ov5640_dev *sensor, bool on)
+static int ov5640_set_power_on(struct ov5640_dev *sensor)
 {
-	int ret = 0;
+	struct i2c_client *client = sensor->i2c_client;
+	int ret;
 
-	if (on) {
-		clk_prepare_enable(sensor->xclk);
+	ret = clk_prepare_enable(sensor->xclk);
+	if (ret) {
+		dev_err(&client->dev, "%s: failed to enable clock\n",
+			__func__);
+		return ret;
+	}
 
-		ret = regulator_bulk_enable(OV5640_NUM_SUPPLIES,
-					    sensor->supplies);
-		if (ret)
-			goto xclk_off;
+	ret = regulator_bulk_enable(OV5640_NUM_SUPPLIES,
+				    sensor->supplies);
+	if (ret) {
+		dev_err(&client->dev, "%s: failed to enable regulators\n",
+			__func__);
+		goto xclk_off;
+	}
+
+	ov5640_reset(sensor);
+	ov5640_power(sensor, true);
+
+	ret = ov5640_init_slave_id(sensor);
+	if (ret)
+		goto power_off;
+
+	return 0;
+
+power_off:
+	ov5640_power(sensor, false);
+	regulator_bulk_disable(OV5640_NUM_SUPPLIES, sensor->supplies);
+xclk_off:
+	clk_disable_unprepare(sensor->xclk);
+	return ret;
+}
+
+static void ov5640_set_power_off(struct ov5640_dev *sensor)
+{
+	ov5640_power(sensor, false);
+	regulator_bulk_disable(OV5640_NUM_SUPPLIES, sensor->supplies);
+	clk_disable_unprepare(sensor->xclk);
+}
 
-		ov5640_reset(sensor);
-		ov5640_power(sensor, true);
+static int ov5640_set_power(struct ov5640_dev *sensor, bool on)
+{
+	int ret = 0;
 
-		ret = ov5640_init_slave_id(sensor);
+	if (on) {
+		ret = ov5640_set_power_on(sensor);
 		if (ret)
-			goto power_off;
+			return ret;
 
 		ret = ov5640_restore_mode(sensor);
 		if (ret)
@@ -1586,10 +1620,7 @@ static int ov5640_set_power(struct ov5640_dev *sensor, bool on)
 	}
 
 power_off:
-	ov5640_power(sensor, false);
-	regulator_bulk_disable(OV5640_NUM_SUPPLIES, sensor->supplies);
-xclk_off:
-	clk_disable_unprepare(sensor->xclk);
+	ov5640_set_power_off(sensor);
 	return ret;
 }
 
@@ -2202,6 +2233,34 @@ static int ov5640_get_regulators(struct ov5640_dev *sensor)
 				       sensor->supplies);
 }
 
+static int ov5640_check_chip_id(struct ov5640_dev *sensor)
+{
+	struct i2c_client *client = sensor->i2c_client;
+	int ret = 0;
+	u16 chip_id;
+
+	ret = ov5640_set_power_on(sensor);
+	if (ret)
+		return ret;
+
+	ret = ov5640_read_reg16(sensor, OV5640_REG_CHIP_ID, &chip_id);
+	if (ret) {
+		dev_err(&client->dev, "%s: failed to read chip identifier\n",
+			__func__);
+		goto power_off;
+	}
+
+	if (chip_id != 0x5640) {
+		dev_err(&client->dev, "%s: wrong chip identifier, expected 0x5640, got 0x%x\n",
+			__func__, chip_id);
+		ret = -ENXIO;
+	}
+
+power_off:
+	ov5640_set_power_off(sensor);
+	return ret;
+}
+
 static int ov5640_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
@@ -2284,6 +2343,10 @@ static int ov5640_probe(struct i2c_client *client,
 
 	mutex_init(&sensor->lock);
 
+	ret = ov5640_check_chip_id(sensor);
+	if (ret)
+		goto entity_cleanup;
+
 	ret = ov5640_init_controls(sensor);
 	if (ret)
 		goto entity_cleanup;
-- 
1.9.1
