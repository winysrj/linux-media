Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-236.synserver.de ([212.40.185.236]:1101 "EHLO
	smtp-out-129.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753288AbaCJRFL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 13:05:11 -0400
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
	linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2] [media] adv7180: Add support for power down
Date: Mon, 10 Mar 2014 18:05:39 +0100
Message-Id: <1394471139-2569-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The adv7180 has a low power mode in which the analog and the digital processing
section are shut down. Implement the s_power callback to let bridge drivers put
the part into low power mode when not needed.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
Changes since v1:
    * Set powered to true in probe() since the part is powered on when it comes
      out of reset
    * Avoid use ofgoto in adv7180_s_power
---
 drivers/media/i2c/adv7180.c | 52 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 42 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 623cec5..9cfc9a3 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -127,6 +127,7 @@ struct adv7180_state {
 	int			irq;
 	v4l2_std_id		curr_norm;
 	bool			autodetect;
+	bool			powered;
 	u8			input;
 };
 #define to_adv7180_sd(_ctrl) (&container_of(_ctrl->handler,		\
@@ -311,6 +312,37 @@ out:
 	return ret;
 }
 
+static int adv7180_set_power(struct adv7180_state *state,
+	struct i2c_client *client, bool on)
+{
+	u8 val;
+
+	if (on)
+		val = ADV7180_PWR_MAN_ON;
+	else
+		val = ADV7180_PWR_MAN_OFF;
+
+	return i2c_smbus_write_byte_data(client, ADV7180_PWR_MAN_REG, val);
+}
+
+static int adv7180_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct adv7180_state *state = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int ret;
+
+	ret = mutex_lock_interruptible(&state->mutex);
+	if (ret)
+		return ret;
+
+	ret = adv7180_set_power(state, client, on);
+	if (ret == 0)
+		state->powered = on;
+
+	mutex_unlock(&state->mutex);
+	return ret;
+}
+
 static int adv7180_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct v4l2_subdev *sd = to_adv7180_sd(ctrl);
@@ -441,6 +473,7 @@ static const struct v4l2_subdev_video_ops adv7180_video_ops = {
 
 static const struct v4l2_subdev_core_ops adv7180_core_ops = {
 	.s_std = adv7180_s_std,
+	.s_power = adv7180_s_power,
 };
 
 static const struct v4l2_subdev_ops adv7180_ops = {
@@ -587,6 +620,7 @@ static int adv7180_probe(struct i2c_client *client,
 	state->irq = client->irq;
 	mutex_init(&state->mutex);
 	state->autodetect = true;
+	state->powered = true;
 	state->input = 0;
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &adv7180_ops);
@@ -640,13 +674,10 @@ static const struct i2c_device_id adv7180_id[] = {
 static int adv7180_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	int ret;
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct adv7180_state *state = to_state(sd);
 
-	ret = i2c_smbus_write_byte_data(client, ADV7180_PWR_MAN_REG,
-					ADV7180_PWR_MAN_OFF);
-	if (ret < 0)
-		return ret;
-	return 0;
+	return adv7180_set_power(state, client, false);
 }
 
 static int adv7180_resume(struct device *dev)
@@ -656,10 +687,11 @@ static int adv7180_resume(struct device *dev)
 	struct adv7180_state *state = to_state(sd);
 	int ret;
 
-	ret = i2c_smbus_write_byte_data(client, ADV7180_PWR_MAN_REG,
-					ADV7180_PWR_MAN_ON);
-	if (ret < 0)
-		return ret;
+	if (state->powered) {
+		ret = adv7180_set_power(state, client, true);
+		if (ret)
+			return ret;
+	}
 	ret = init_device(client, state);
 	if (ret < 0)
 		return ret;
-- 
1.8.0

