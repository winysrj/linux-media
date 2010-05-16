Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:51606 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab0EPRCo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 May 2010 13:02:44 -0400
Received: by ewy8 with SMTP id 8so1499373ewy.28
        for <linux-media@vger.kernel.org>; Sun, 16 May 2010 10:02:42 -0700 (PDT)
From: Jarkko Nikula <jhnikula@gmail.com>
To: linux-media@vger.kernel.org
Cc: Jarkko Nikula <jhnikula@gmail.com>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCH] si4713: Fix oops when si4713_platform_data is marked as __initdata
Date: Sun, 16 May 2010 20:04:26 +0300
Message-Id: <1274029466-17456-1-git-send-email-jhnikula@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver can cause an oops if si4713_platform_data holding pointer to
set_power function is marked as __initdata and when trying to power up the
chip after booting e.g. with 'v4l2-ctl -d /dev/radio0 --set-ctrl=mute=0'.

This happens because the sdev->platform_data doesn't point to valid data
anymore after kernel is initialized.

Fix this by taking local copy of si4713_platform_data->set_power. Add also
NULL check for this function pointer.

Signed-off-by: Jarkko Nikula <jhnikula@gmail.com>
Cc: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 drivers/media/radio/si4713-i2c.c |   15 +++++++++------
 drivers/media/radio/si4713-i2c.h |    2 +-
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/media/radio/si4713-i2c.c b/drivers/media/radio/si4713-i2c.c
index ab63dd5..cf9858d 100644
--- a/drivers/media/radio/si4713-i2c.c
+++ b/drivers/media/radio/si4713-i2c.c
@@ -369,7 +369,8 @@ static int si4713_powerup(struct si4713_device *sdev)
 	if (sdev->power_state)
 		return 0;
 
-	sdev->platform_data->set_power(1);
+	if (sdev->set_power)
+		sdev->set_power(1);
 	err = si4713_send_command(sdev, SI4713_CMD_POWER_UP,
 					args, ARRAY_SIZE(args),
 					resp, ARRAY_SIZE(resp),
@@ -383,8 +384,8 @@ static int si4713_powerup(struct si4713_device *sdev)
 
 		err = si4713_write_property(sdev, SI4713_GPO_IEN,
 						SI4713_STC_INT | SI4713_CTS);
-	} else {
-		sdev->platform_data->set_power(0);
+	} else if (sdev->set_power) {
+		sdev->set_power(0);
 	}
 
 	return err;
@@ -411,7 +412,8 @@ static int si4713_powerdown(struct si4713_device *sdev)
 		v4l2_dbg(1, debug, &sdev->sd, "Power down response: 0x%02x\n",
 				resp[0]);
 		v4l2_dbg(1, debug, &sdev->sd, "Device in reset mode\n");
-		sdev->platform_data->set_power(0);
+		if (sdev->set_power)
+			sdev->set_power(0);
 		sdev->power_state = POWER_OFF;
 	}
 
@@ -1959,6 +1961,7 @@ static int si4713_probe(struct i2c_client *client,
 					const struct i2c_device_id *id)
 {
 	struct si4713_device *sdev;
+	struct si4713_platform_data *pdata = client->dev.platform_data;
 	int rval;
 
 	sdev = kzalloc(sizeof *sdev, GFP_KERNEL);
@@ -1968,12 +1971,12 @@ static int si4713_probe(struct i2c_client *client,
 		goto exit;
 	}
 
-	sdev->platform_data = client->dev.platform_data;
-	if (!sdev->platform_data) {
+	if (!pdata) {
 		v4l2_err(&sdev->sd, "No platform data registered.\n");
 		rval = -ENODEV;
 		goto free_sdev;
 	}
+	sdev->set_power = pdata->set_power;
 
 	v4l2_i2c_subdev_init(&sdev->sd, client, &si4713_subdev_ops);
 
diff --git a/drivers/media/radio/si4713-i2c.h b/drivers/media/radio/si4713-i2c.h
index faf8cff..d1af889 100644
--- a/drivers/media/radio/si4713-i2c.h
+++ b/drivers/media/radio/si4713-i2c.h
@@ -220,7 +220,7 @@ struct si4713_device {
 	/* private data structures */
 	struct mutex mutex;
 	struct completion work;
-	struct si4713_platform_data *platform_data;
+	int (*set_power)(int power);
 	struct rds_info rds_info;
 	struct limiter_info limiter_info;
 	struct pilot_info pilot_info;
-- 
1.7.1

