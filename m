Return-path: <linux-media-owner@vger.kernel.org>
Received: from av7-1-sn3.vrr.skanova.net ([81.228.9.181]:50525 "EHLO
	av7-1-sn3.vrr.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbZIVJ2L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2009 05:28:11 -0400
Message-ID: <4AB893BA.4080400@mocean-labs.com>
Date: Tue, 22 Sep 2009 11:07:06 +0200
From: =?ISO-8859-1?Q?Richard_R=F6jfors?=
	<richard.rojfors@mocean-labs.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Subject: [PATCH 3/4] adv7180: Support checking standard via interrupts
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the I2C device provides an interrupt it is registered and the standard
is updated via interrupts rather than polling.

Since I2C communication is needed, the interrupt handler fires off a
work which will check the new standard, and store it in the internal
structure.

To handle mutual exclusion a mutex is introduced.

Signed-off-by: Richard Röjfors <richard.rojfors@mocean-labs.com>
---
diff --git a/drivers/media/video/adv7180.c b/drivers/media/video/adv7180.c
index 8b199a8..d9e897d 100644
--- a/drivers/media/video/adv7180.c
+++ b/drivers/media/video/adv7180.c
@@ -27,6 +27,7 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
+#include <linux/mutex.h>

 #define DRIVER_NAME "adv7180"

@@ -48,9 +49,14 @@
 #define ADV7180_INPUT_CONTROL_PAL_SECAM			0xe0
 #define ADV7180_INPUT_CONTROL_PAL_SECAM_PED		0xf0

-#define ADV7180_AUTODETECT_ENABLE_REG	0x07
-#define ADV7180_AUTODETECT_DEFAULT	0x7f
+#define ADV7180_EXTENDED_OUTPUT_CONTROL_REG		0x04
+#define ADV7180_EXTENDED_OUTPUT_CONTROL_NTSCDIS		0xC5

+#define ADV7180_AUTODETECT_ENABLE_REG			0x07
+#define ADV7180_AUTODETECT_DEFAULT			0x7f
+
+#define ADV7180_ADI_CTRL_REG				0x0e
+#define ADV7180_ADI_CTRL_IRQ_SPACE			0x20

 #define ADV7180_STATUS1_REG				0x10
 #define ADV7180_STATUS1_IN_LOCK		0x01
@@ -67,9 +73,28 @@
 #define ADV7180_IDENT_REG 0x11
 #define ADV7180_ID_7180 0x18

+#define ADV7180_ICONF1_ADI		0x40
+#define ADV7180_ICONF1_ACTIVE_LOW	0x01
+#define ADV7180_ICONF1_PSYNC_ONLY	0x10
+#define ADV7180_ICONF1_ACTIVE_TO_CLR	0xC0
+
+#define ADV7180_IRQ1_LOCK	0x01
+#define ADV7180_IRQ1_UNLOCK	0x02
+#define ADV7180_ISR1_ADI	0x42
+#define ADV7180_ICR1_ADI	0x43
+#define ADV7180_IMR1_ADI	0x44
+#define ADV7180_IMR2_ADI	0x48
+#define ADV7180_IRQ3_AD_CHANGE	0x08
+#define ADV7180_ISR3_ADI	0x4A
+#define ADV7180_ICR3_ADI	0x4B
+#define ADV7180_IMR3_ADI	0x4C
+#define ADV7180_IMR4_ADI	0x50

 struct adv7180_state {
 	struct v4l2_subdev	sd;
+	struct work_struct	work;
+	struct mutex		mutex; /* mutual excl. when accessing chip */
+	int			irq;
 	v4l2_std_id		curr_norm;
 	bool			autodetect;
 };
@@ -153,19 +178,30 @@ static inline struct adv7180_state *to_state(struct v4l2_subdev *sd)
 static int adv7180_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
 {
 	struct adv7180_state *state = to_state(sd);
-	int err = 0;
+	int err = mutex_lock_interruptible(&state->mutex);
+	if (err)
+		return err;

-	if (!state->autodetect)
+	/* when we are interrupt driven we know the state */
+	if (!state->autodetect || state->irq > 0)
 		*std = state->curr_norm;
 	else
 		err = __adv7180_status(v4l2_get_subdevdata(sd), NULL, std);

+	mutex_unlock(&state->mutex);
 	return err;
 }

 static int adv7180_g_input_status(struct v4l2_subdev *sd, u32 *status)
 {
-	return __adv7180_status(v4l2_get_subdevdata(sd), status, NULL);
+	struct adv7180_state *state = to_state(sd);
+	int ret = mutex_lock_interruptible(&state->mutex);
+	if (ret)
+		return ret;
+
+	ret = __adv7180_status(v4l2_get_subdevdata(sd), status, NULL);
+	mutex_unlock(&state->mutex);
+	return ret;
 }

 static int adv7180_g_chip_ident(struct v4l2_subdev *sd,
@@ -180,7 +216,9 @@ static int adv7180_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 {
 	struct adv7180_state *state = to_state(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	int ret;
+	int ret = mutex_lock_interruptible(&state->mutex);
+	if (ret)
+		return ret;

 	/* all standards -> autodetect */
 	if (std == V4L2_STD_ALL) {
@@ -190,6 +228,7 @@ static int adv7180_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 		if (ret < 0)
 			goto out;

+		__adv7180_status(client, NULL, &state->curr_norm);
 		state->autodetect = true;
 	} else {
 		ret = v4l2_std_to_adv7180(std);
@@ -206,6 +245,7 @@ static int adv7180_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 	}
 	ret = 0;
 out:
+	mutex_unlock(&state->mutex);
 	return ret;
 }

@@ -224,6 +264,39 @@ static const struct v4l2_subdev_ops adv7180_ops = {
 	.video = &adv7180_video_ops,
 };

+static void adv7180_work(struct work_struct *work)
+{
+	struct adv7180_state *state = container_of(work, struct adv7180_state,
+		work);
+	struct i2c_client *client = v4l2_get_subdevdata(&state->sd);
+	u8 isr3;
+
+	mutex_lock(&state->mutex);
+	i2c_smbus_write_byte_data(client, ADV7180_ADI_CTRL_REG,
+		ADV7180_ADI_CTRL_IRQ_SPACE);
+	isr3 = i2c_smbus_read_byte_data(client, ADV7180_ISR3_ADI);
+	/* clear */
+	i2c_smbus_write_byte_data(client, ADV7180_ICR3_ADI, isr3);
+	i2c_smbus_write_byte_data(client, ADV7180_ADI_CTRL_REG, 0);
+
+	if (isr3 & ADV7180_IRQ3_AD_CHANGE && state->autodetect)
+		__adv7180_status(client, NULL, &state->curr_norm);
+	mutex_unlock(&state->mutex);
+
+	enable_irq(state->irq);
+}
+
+static irqreturn_t adv7180_irq(int irq, void *devid)
+{
+	struct adv7180_state *state = devid;
+
+	schedule_work(&state->work);
+
+	disable_irq_nosync(state->irq);
+
+	return IRQ_HANDLED;
+}
+
 /*
  * Generic i2c probe
  * concerning the addresses: i2c wants 7 bit (without the r/w bit), so '>>1'
@@ -244,33 +317,111 @@ static int adv7180_probe(struct i2c_client *client,
 			client->addr << 1, client->adapter->name);

 	state = kzalloc(sizeof(struct adv7180_state), GFP_KERNEL);
-	if (state == NULL)
-		return -ENOMEM;
+	if (state == NULL) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	state->irq = client->irq;
+	INIT_WORK(&state->work, adv7180_work);
+	mutex_init(&state->mutex);
 	state->autodetect = true;
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &adv7180_ops);

 	/* Initialize adv7180 */
-	/* enable autodetection */
+	/* Enable autodetection */
 	ret = i2c_smbus_write_byte_data(client, ADV7180_INPUT_CONTROL_REG,
 		ADV7180_INPUT_CONTROL_AD_PAL_BG_NTSC_J_SECAM);
-	if (ret > 0)
-		ret = i2c_smbus_write_byte_data(client,
-			ADV7180_AUTODETECT_ENABLE_REG,
-			ADV7180_AUTODETECT_DEFAULT);
-	if (ret < 0) {
-		printk(KERN_ERR DRIVER_NAME
-			": Failed to communicate to chip: %d\n", ret);
-		return ret;
+	if (ret < 0)
+		goto err_unreg_subdev;
+
+	ret = i2c_smbus_write_byte_data(client, ADV7180_AUTODETECT_ENABLE_REG,
+		ADV7180_AUTODETECT_DEFAULT);
+	if (ret < 0)
+		goto err_unreg_subdev;
+
+	/* ITU-R BT.656-4 compatible */
+	ret = i2c_smbus_write_byte_data(client,
+		ADV7180_EXTENDED_OUTPUT_CONTROL_REG,
+		ADV7180_EXTENDED_OUTPUT_CONTROL_NTSCDIS);
+	if (ret < 0)
+		goto err_unreg_subdev;
+
+	/* read current norm */
+	__adv7180_status(client, NULL, &state->curr_norm);
+
+	/* register for interrupts */
+	if (state->irq > 0) {
+		ret = request_irq(state->irq, adv7180_irq, 0, DRIVER_NAME,
+			state);
+		if (ret)
+			goto err_unreg_subdev;
+
+		ret = i2c_smbus_write_byte_data(client, ADV7180_ADI_CTRL_REG,
+			ADV7180_ADI_CTRL_IRQ_SPACE);
+		if (ret < 0)
+			goto err_unreg_subdev;
+
+		/* config the Interrupt pin to be active low */
+		ret = i2c_smbus_write_byte_data(client, ADV7180_ICONF1_ADI,
+			ADV7180_ICONF1_ACTIVE_LOW | ADV7180_ICONF1_PSYNC_ONLY);
+		if (ret < 0)
+			goto err_unreg_subdev;
+
+		ret = i2c_smbus_write_byte_data(client, ADV7180_IMR1_ADI, 0);
+		if (ret < 0)
+			goto err_unreg_subdev;
+
+		ret = i2c_smbus_write_byte_data(client, ADV7180_IMR2_ADI, 0);
+		if (ret < 0)
+			goto err_unreg_subdev;
+
+		/* enable AD change interrupts interrupts */
+		ret = i2c_smbus_write_byte_data(client, ADV7180_IMR3_ADI,
+			ADV7180_IRQ3_AD_CHANGE);
+		if (ret < 0)
+			goto err_unreg_subdev;
+
+		ret = i2c_smbus_write_byte_data(client, ADV7180_IMR4_ADI, 0);
+		if (ret < 0)
+			goto err_unreg_subdev;
+
+		ret = i2c_smbus_write_byte_data(client, ADV7180_ADI_CTRL_REG,
+			0);
+		if (ret < 0)
+			goto err_unreg_subdev;
 	}

 	return 0;
+
+err_unreg_subdev:
+	mutex_destroy(&state->mutex);
+	v4l2_device_unregister_subdev(sd);
+	kfree(state);
+err:
+	printk(KERN_ERR DRIVER_NAME ": Failed to probe: %d\n", ret);
+	return ret;
 }

 static int adv7180_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct adv7180_state *state = to_state(sd);
+
+	if (state->irq > 0) {
+		free_irq(client->irq, state);
+		if (cancel_work_sync(&state->work)) {
+			/*
+			 * Work was pending, therefore we need to enable
+			 * IRQ here to balance the disable_irq() done in the
+			 * interrupt handler.
+			 */
+			enable_irq(state->irq);
+		}
+	}

+	mutex_destroy(&state->mutex);
 	v4l2_device_unregister_subdev(sd);
 	kfree(to_state(sd));
 	return 0;
