Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:64589 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab3HUI37 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 04:29:59 -0400
From: Dinesh Ram <dinram@cisco.com>
To: linux-media@vger.kernel.org
Cc: eduardo.valentin@nokia.com, Dinesh Ram <dinram@cisco.com>
Subject: [RFC PATCH 2/5] si4713 : Modified i2c driver to handle cases where interrupts are not used
Date: Wed, 21 Aug 2013 10:19:48 +0200
Message-Id: <8a1ad18ca85291b65983d10dd9231a280b32e74f.1377073025.git.dinram@cisco.com>
In-Reply-To: <1377073191-29197-1-git-send-email-dinram@cisco.com>
References: <1377073191-29197-1-git-send-email-dinram@cisco.com>
In-Reply-To: <714c16de2d45c2ccfc2fc94b2770bbd00bfeb977.1377073025.git.dinram@cisco.com>
References: <714c16de2d45c2ccfc2fc94b2770bbd00bfeb977.1377073025.git.dinram@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Checks have been introduced at several places in the code to test if an interrupt is set or not.
For devices which do not use the interrupt, to get a valid response, within a specified timeout,
the device is polled instead.

Signed-off-by: Dinesh Ram <dinram@cisco.com>
---
 drivers/media/radio/si4713/si4713.c | 110 ++++++++++++++++++++----------------
 drivers/media/radio/si4713/si4713.h |   1 +
 2 files changed, 63 insertions(+), 48 deletions(-)

diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
index 14bc8a3..c7fa896 100644
--- a/drivers/media/radio/si4713/si4713.c
+++ b/drivers/media/radio/si4713/si4713.c
@@ -27,7 +27,6 @@
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/gpio.h>
-#include <linux/regulator/consumer.h>
 #include <linux/module.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
@@ -213,6 +212,7 @@ static int si4713_send_command(struct si4713_device *sdev, const u8 command,
 				u8 response[], const int respn, const int usecs)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
+	unsigned long until_jiffies;
 	u8 data1[MAX_ARGS + 1];
 	int err;
 
@@ -228,30 +228,39 @@ static int si4713_send_command(struct si4713_device *sdev, const u8 command,
 	if (err != argn + 1) {
 		v4l2_err(&sdev->sd, "Error while sending command 0x%02x\n",
 			command);
-		return (err > 0) ? -EIO : err;
+		return err < 0 ? err : -EIO;
 	}
 
+	until_jiffies = jiffies + usecs_to_jiffies(usecs) + 1;
+
 	/* Wait response from interrupt */
-	if (!wait_for_completion_timeout(&sdev->work,
+	if (client->irq) {
+		if (!wait_for_completion_timeout(&sdev->work,
 				usecs_to_jiffies(usecs) + 1))
-		v4l2_warn(&sdev->sd,
+			v4l2_warn(&sdev->sd,
 				"(%s) Device took too much time to answer.\n",
 				__func__);
-
-	/* Then get the response */
-	err = i2c_master_recv(client, response, respn);
-	if (err != respn) {
-		v4l2_err(&sdev->sd,
-			"Error while reading response for command 0x%02x\n",
-			command);
-		return (err > 0) ? -EIO : err;
 	}
 
-	DBG_BUFFER(&sdev->sd, "Response", response, respn);
-	if (check_command_failed(response[0]))
-		return -EBUSY;
+	do {
+		err = i2c_master_recv(client, response, respn);
+		if (err != respn) {
+			v4l2_err(&sdev->sd,
+					"Error %d while reading response for command 0x%02x\n",
+					err, command);
+			return err < 0 ? err : -EIO;
+		}
 
-	return 0;
+		DBG_BUFFER(&sdev->sd, "Response", response, respn);
+		if (!check_command_failed(response[0]))
+			return 0;
+	
+		if (client->irq)
+			return -EBUSY;
+		msleep(1);
+	} while (jiffies <= until_jiffies);
+
+	return -EBUSY;
 }
 
 /*
@@ -344,14 +353,15 @@ static int si4713_write_property(struct si4713_device *sdev, u16 prop, u16 val)
  */
 static int si4713_powerup(struct si4713_device *sdev)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
 	int err;
 	u8 resp[SI4713_PWUP_NRESP];
 	/*
 	 * 	.First byte = Enabled interrupts and boot function
 	 * 	.Second byte = Input operation mode
 	 */
-	const u8 args[SI4713_PWUP_NARGS] = {
-		SI4713_PWUP_CTSIEN | SI4713_PWUP_GPO2OEN | SI4713_PWUP_FUNC_TX,
+	u8 args[SI4713_PWUP_NARGS] = {
+		SI4713_PWUP_GPO2OEN | SI4713_PWUP_FUNC_TX,
 		SI4713_PWUP_OPMOD_ANALOG,
 	};
 
@@ -369,18 +379,22 @@ static int si4713_powerup(struct si4713_device *sdev)
 		gpio_set_value(sdev->gpio_reset, 1);
 	}
 
+	if (client->irq)
+		args[0] |= SI4713_PWUP_CTSIEN;
+
 	err = si4713_send_command(sdev, SI4713_CMD_POWER_UP,
 					args, ARRAY_SIZE(args),
 					resp, ARRAY_SIZE(resp),
 					TIMEOUT_POWER_UP);
-
+	
 	if (!err) {
 		v4l2_dbg(1, debug, &sdev->sd, "Powerup response: 0x%02x\n",
 				resp[0]);
 		v4l2_dbg(1, debug, &sdev->sd, "Device in power up mode\n");
 		sdev->power_state = POWER_ON;
 
-		err = si4713_write_property(sdev, SI4713_GPO_IEN,
+		if (client->irq)
+			err = si4713_write_property(sdev, SI4713_GPO_IEN,
 						SI4713_STC_INT | SI4713_CTS);
 	} else {
 		if (gpio_is_valid(sdev->gpio_reset))
@@ -447,7 +461,7 @@ static int si4713_checkrev(struct si4713_device *sdev)
 	if (rval < 0)
 		return rval;
 
-	if (resp[1] == SI4713_PRODUCT_NUMBER) {
+	if (resp[1] == SI4713_PRODUCT_NUMBER) { 
 		v4l2_info(&sdev->sd, "chip found @ 0x%02x (%s)\n",
 				client->addr << 1, client->adapter->name);
 	} else {
@@ -465,33 +479,34 @@ static int si4713_checkrev(struct si4713_device *sdev)
  */
 static int si4713_wait_stc(struct si4713_device *sdev, const int usecs)
 {
-	int err;
+	struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
 	u8 resp[SI4713_GET_STATUS_NRESP];
-
-	/* Wait response from STC interrupt */
-	if (!wait_for_completion_timeout(&sdev->work,
-			usecs_to_jiffies(usecs) + 1))
-		v4l2_warn(&sdev->sd,
-			"%s: device took too much time to answer (%d usec).\n",
-				__func__, usecs);
-
-	/* Clear status bits */
-	err = si4713_send_command(sdev, SI4713_CMD_GET_INT_STATUS,
-					NULL, 0,
-					resp, ARRAY_SIZE(resp),
-					DEFAULT_TIMEOUT);
-
-	if (err < 0)
-		goto exit;
-
-	v4l2_dbg(1, debug, &sdev->sd,
-			"%s: status bits: 0x%02x\n", __func__, resp[0]);
-
-	if (!(resp[0] & SI4713_STC_INT))
-		err = -EIO;
-
-exit:
-	return err;
+	unsigned long start_jiffies = jiffies;
+	int err;
+	
+ 	if (client->irq &&
+	    !wait_for_completion_timeout(&sdev->work, usecs_to_jiffies(usecs) + 1))
+ 		v4l2_warn(&sdev->sd,
+ 			"(%s) Device took too much time to answer.\n", __func__);
+			
+	for (;;) {
+		/* Clear status bits */
+		err = si4713_send_command(sdev, SI4713_CMD_GET_INT_STATUS,
+				NULL, 0,
+				resp, ARRAY_SIZE(resp),
+				DEFAULT_TIMEOUT);
+
+		if (err >= 0) {
+			v4l2_dbg(1, debug, &sdev->sd,
+					"%s: status bits: 0x%02x\n", __func__, resp[0]);
+
+			if (resp[0] & SI4713_STC_INT)
+				return 0;
+		}
+		if (jiffies_to_usecs(jiffies - start_jiffies) > usecs)
+			return -EIO;
+		msleep(3);
+	}
 }
 
 /*
@@ -1024,7 +1039,6 @@ static int si4713_initialize(struct si4713_device *sdev)
 	if (rval < 0)
 		return rval;
 
-
 	sdev->frequency = DEFAULT_FREQUENCY;
 	sdev->stereo = 1;
 	sdev->tune_rnl = DEFAULT_TUNE_RNL;
diff --git a/drivers/media/radio/si4713/si4713.h b/drivers/media/radio/si4713/si4713.h
index 25cdea2..1410cd2 100644
--- a/drivers/media/radio/si4713/si4713.h
+++ b/drivers/media/radio/si4713/si4713.h
@@ -15,6 +15,7 @@
 #ifndef SI4713_I2C_H
 #define SI4713_I2C_H
 
+#include <linux/regulator/consumer.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
 #include <media/si4713.h>
-- 
1.8.4.rc2

