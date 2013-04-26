Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756826Ab3DZMta (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Apr 2013 08:49:30 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: =?UTF-8?q?Jon=20Arne=20J=C3=B8rgensen?= <jonarne@jonarne.no>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] saa7115: move the autodetection code out of the probe function
Date: Fri, 26 Apr 2013 09:49:16 -0300
Message-Id: <1366980557-23077-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366980557-23077-1-git-send-email-mchehab@redhat.com>
References: <1366980557-23077-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we're now seeing other variants from chinese clones, like
gm1113c, we'll need to add more bits at the detection code.

So, move it into a separate function.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/i2c/saa7115.c | 133 +++++++++++++++++++++++++++-----------------
 1 file changed, 83 insertions(+), 50 deletions(-)

diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index 52c717d..2bc8b72 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1573,46 +1573,103 @@ static const struct v4l2_subdev_ops saa711x_ops = {
 
 /* ----------------------------------------------------------------------- */
 
+/**
+ * saa711x_detect_chip - Detects the saa711x (or clone) variant
+ * @client:		I2C client structure;
+ * @id:			I2C device ID structure;
+ * @name:		Name of the device to be filled.
+ * @size:		Size of the name var.
+ *
+ * Detects the Philips/NXP saa711x chip, or some clone of it.
+ * if 'id' is NULL or id->driver_data is equal to 1, it auto-probes
+ * the analog demod.
+ * If the tuner is not found, it returns -ENODEV.
+ * If auto-detection is disabled and the tuner doesn't match what it was
+ *	requred, it returns -EINVAL and fills 'name'.
+ * If the chip is found, it returns the chip ID and fills 'name'.
+ */
+static int saa711x_detect_chip(struct i2c_client *client,
+			       const struct i2c_device_id *id,
+			       char *name, unsigned size)
+{
+	char chip_ver[size - 1];
+	char chip_id;
+	int i;
+	int autodetect;
+
+	autodetect = !id || id->driver_data == 1;
+
+	/* Read the chip version register */
+	for (i = 0; i < size - 1; i++) {
+		i2c_smbus_write_byte_data(client, 0, i);
+		chip_ver[i] = i2c_smbus_read_byte_data(client, 0);
+		name[i] = (chip_ver[i] & 0x0f) + '0';
+		if (name[i] > '9')
+			name[i] += 'a' - '9' - 1;
+	}
+	name[i] = '\0';
+
+	/* Check if it is a Philips/NXP chip */
+	if (!memcmp(name + 1, "f711", 4)) {
+		chip_id = name[5];
+		snprintf(name, size, "saa711%c", chip_id);
+
+		if (!autodetect && strcmp(name, id->name))
+			return -EINVAL;
+
+		switch (chip_id) {
+		case '1':
+			if (chip_ver[0] & 0xf0) {
+				snprintf(name, size, "saa711%ca", chip_id);
+				v4l_info(client, "saa7111a variant found\n");
+				return V4L2_IDENT_SAA7111A;
+			}
+			return V4L2_IDENT_SAA7111;
+		case '3':
+			return V4L2_IDENT_SAA7113;
+		case '4':
+			return V4L2_IDENT_SAA7114;
+		case '5':
+			return V4L2_IDENT_SAA7115;
+		case '8':
+			return V4L2_IDENT_SAA7118;
+		default:
+			v4l2_info(client,
+				  "WARNING: Philips/NXP chip unknown - Falling back to saa7111\n");
+			return V4L2_IDENT_SAA7111;
+		}
+	}
+
+	/* Chip was not discovered. Return its ID and don't bind */
+	v4l_dbg(1, debug, client, "chip %*ph @ 0x%x is unknown.\n",
+		16, chip_ver, client->addr << 1);
+	return -ENODEV;
+}
+
 static int saa711x_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
 	struct saa711x_state *state;
 	struct v4l2_subdev *sd;
 	struct v4l2_ctrl_handler *hdl;
-	int i;
+	int ident;
 	char name[17];
-	char chip_id;
-	int autodetect = !id || id->driver_data == 1;
 
 	/* Check if the adapter supports the needed features */
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -EIO;
 
-	for (i = 0; i < 0x0f; i++) {
-		i2c_smbus_write_byte_data(client, 0, i);
-		name[i] = (i2c_smbus_read_byte_data(client, 0) & 0x0f) + '0';
-		if (name[i] > '9')
-			name[i] += 'a' - '9' - 1;
-	}
-	name[i] = '\0';
-
-	chip_id = name[5];
-
-	/* Check whether this chip is part of the saa711x series */
-	if (memcmp(name + 1, "f711", 4)) {
-		v4l_dbg(1, debug, client, "chip found @ 0x%x (ID %s) does not match a known saa711x chip.\n",
-			client->addr << 1, name);
+	ident = saa711x_detect_chip(client, id, name, sizeof(name));
+	if (ident == -EINVAL) {
+		/* Chip exists, but doesn't match */
+		v4l_warn(client, "found %s while %s was expected\n",
+			 name, id->name);
 		return -ENODEV;
 	}
+	if (ident < 0)
+		return ident;
 
-	/* Safety check */
-	if (!autodetect && id->name[6] != chip_id) {
-		v4l_warn(client, "found saa711%c while %s was expected\n",
-			 chip_id, id->name);
-	}
-	snprintf(client->name, sizeof(client->name), "saa711%c", chip_id);
-	v4l_info(client, "saa711%c found (%s) @ 0x%x (%s)\n", chip_id, name,
-		 client->addr << 1, client->adapter->name);
+	strlcpy(client->name, name, sizeof(client->name));
 
 	state = kzalloc(sizeof(struct saa711x_state), GFP_KERNEL);
 	if (state == NULL)
@@ -1649,31 +1706,7 @@ static int saa711x_probe(struct i2c_client *client,
 	state->output = SAA7115_IPORT_ON;
 	state->enable = 1;
 	state->radio = 0;
-	switch (chip_id) {
-	case '1':
-		state->ident = V4L2_IDENT_SAA7111;
-		if (saa711x_read(sd, R_00_CHIP_VERSION) & 0xf0) {
-			v4l_info(client, "saa7111a variant found\n");
-			state->ident = V4L2_IDENT_SAA7111A;
-		}
-		break;
-	case '3':
-		state->ident = V4L2_IDENT_SAA7113;
-		break;
-	case '4':
-		state->ident = V4L2_IDENT_SAA7114;
-		break;
-	case '5':
-		state->ident = V4L2_IDENT_SAA7115;
-		break;
-	case '8':
-		state->ident = V4L2_IDENT_SAA7118;
-		break;
-	default:
-		state->ident = V4L2_IDENT_SAA7111;
-		v4l2_info(sd, "WARNING: Chip is not known - Falling back to saa7111\n");
-		break;
-	}
+	state->ident = ident;
 
 	state->audclk_freq = 48000;
 
-- 
1.8.1.4

