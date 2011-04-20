Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:65121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857Ab1DTVn0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2011 17:43:26 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p3KLhQpg006394
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 20 Apr 2011 17:43:26 -0400
Received: from [10.11.11.9] (vpn-11-9.rdu.redhat.com [10.11.11.9])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p3KLhPAN024808
	for <linux-media@vger.kernel.org>; Wed, 20 Apr 2011 17:43:25 -0400
Message-ID: <4DAF537C.1000108@redhat.com>
Date: Wed, 20 Apr 2011 18:43:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] tm6000: add detection based on eeprom name
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On some situations, it is desired to use eeprom data to detect
the board type. This patch adds a logic for it and fixes 2 detection
issues:
	1) 10Moons UT-821 uses a generic Trident ID. Other boards
also share the same ID. So, better to use an alternative way for
it;
	2) Sometimes, HVR-900H is loaded with the default Trident
ID. This seems to be some hardware bug or race condition.

The new logic will only be enabled if the device is detected as
having a generic ID.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 146c7e8..6e51486 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -54,6 +54,11 @@
 #define TM6010_BOARD_BEHOLD_VOYAGER_LITE	15
 #define TM5600_BOARD_TERRATEC_GRABSTER		16
 
+#define is_generic(model) ((model == TM6000_BOARD_UNKNOWN) || \
+			   (model == TM5600_BOARD_GENERIC) || \
+			   (model == TM6000_BOARD_GENERIC) || \
+			   (model == TM6010_BOARD_GENERIC))
+
 #define TM6000_MAXBOARDS        16
 static unsigned int card[]     = {[0 ... (TM6000_MAXBOARDS - 1)] = UNSET };
 
@@ -64,6 +69,9 @@ static unsigned long tm6000_devused;
 
 struct tm6000_board {
 	char            *name;
+	char		eename[16];		/* EEPROM name */
+	unsigned	eename_size;		/* size of EEPROM name */
+	unsigned	eename_pos;		/* Position where it appears at ROM */
 
 	struct tm6000_capabilities caps;
 	enum            tm6000_inaudio aradio;
@@ -139,6 +147,9 @@ struct tm6000_board tm6000_boards[] = {
 	[TM5600_BOARD_10MOONS_UT821] = {
 		.name         = "10Moons UT 821",
 		.tuner_type   = TUNER_XC2028,
+		.eename       = { '1', '0', 'M', 'O', 'O', 'N', 'S', '5', '6', '0', '0', 0xff, 0x45, 0x5b},
+		.eename_size  = 14,
+		.eename_pos   = 0x14,
 		.type         = TM5600,
 		.tuner_addr   = 0xc2 >> 1,
 		.caps = {
@@ -205,6 +216,9 @@ struct tm6000_board tm6000_boards[] = {
 	},
 	[TM6010_BOARD_HAUPPAUGE_900H] = {
 		.name         = "Hauppauge WinTV HVR-900H / WinTV USB2-Stick",
+		.eename       = { 'H', 0, 'V', 0, 'R', 0, '9', 0, '0', 0, '0', 0, 'H', 0 },
+		.eename_size  = 14,
+		.eename_pos   = 0x42,
 		.tuner_type   = TUNER_XC2028, /* has a XC3028 */
 		.tuner_addr   = 0xc2 >> 1,
 		.demod_addr   = 0x1e >> 1,
@@ -370,7 +384,7 @@ struct tm6000_board tm6000_boards[] = {
 
 /* table of devices that work with this driver */
 struct usb_device_id tm6000_id_table[] = {
-	{ USB_DEVICE(0x6000, 0x0001), .driver_info = TM5600_BOARD_10MOONS_UT821 },
+	{ USB_DEVICE(0x6000, 0x0001), .driver_info = TM5600_BOARD_GENERIC },
 	{ USB_DEVICE(0x6000, 0x0002), .driver_info = TM6010_BOARD_GENERIC },
 	{ USB_DEVICE(0x06e1, 0xf332), .driver_info = TM6000_BOARD_ADSTECH_DUAL_TV },
 	{ USB_DEVICE(0x14aa, 0x0620), .driver_info = TM6000_BOARD_FREECOM_AND_SIMILAR },
@@ -729,16 +743,10 @@ static void tm6000_config_tuner(struct tm6000_core *dev)
 	}
 }
 
-static int tm6000_init_dev(struct tm6000_core *dev)
+static int fill_board_specific_data(struct tm6000_core *dev)
 {
-	struct v4l2_frequency f;
-	int rc = 0;
-
-	mutex_init(&dev->lock);
+	int rc;
 
-	mutex_lock(&dev->lock);
-
-	/* Initializa board-specific data */
 	dev->dev_type   = tm6000_boards[dev->model].type;
 	dev->tuner_type = tm6000_boards[dev->model].tuner_type;
 	dev->tuner_addr = tm6000_boards[dev->model].tuner_addr;
@@ -756,16 +764,80 @@ static int tm6000_init_dev(struct tm6000_core *dev)
 	/* initialize hardware */
 	rc = tm6000_init(dev);
 	if (rc < 0)
-		goto err;
+		return rc;
 
 	rc = v4l2_device_register(&dev->udev->dev, &dev->v4l2_dev);
 	if (rc < 0)
-		goto err;
+		return rc;
 
-	/* register i2c bus */
-	rc = tm6000_i2c_register(dev);
-	if (rc < 0)
-		goto err;
+	/* initialize hardware */
+	rc = tm6000_init(dev);
+
+	return rc;
+}
+
+
+static void use_alternative_detection_method(struct tm6000_core *dev)
+{
+	int i, model = -1;
+
+	if (!dev->eedata_size)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(tm6000_boards); i++) {
+		if (!tm6000_boards[i].eename_size)
+			continue;
+		if (dev->eedata_size < tm6000_boards[i].eename_pos +
+				       tm6000_boards[i].eename_size)
+			continue;
+
+		if (!memcmp(&dev->eedata[tm6000_boards[i].eename_pos],
+			    tm6000_boards[i].eename,
+			    tm6000_boards[i].eename_size)) {
+			model = i;
+			break;
+		}
+	}
+	if (model < 0) {
+		printk(KERN_INFO "Device has eeprom but is currently unknown\n");
+		return;
+	}
+
+	dev->model = model;
+
+	printk(KERN_INFO "Device identified via eeprom as %s (type = %d)\n",
+	       tm6000_boards[model].name, model);
+}
+
+static int tm6000_init_dev(struct tm6000_core *dev)
+{
+	struct v4l2_frequency f;
+	int rc = 0;
+
+	mutex_init(&dev->lock);
+	mutex_lock(&dev->lock);
+
+	if (!is_generic(dev->model)) {
+		rc = fill_board_specific_data(dev);
+		if (rc < 0)
+			goto err;
+
+		/* register i2c bus */
+		rc = tm6000_i2c_register(dev);
+		if (rc < 0)
+			goto err;
+	} else {
+		/* register i2c bus */
+		rc = tm6000_i2c_register(dev);
+		if (rc < 0)
+			goto err;
+
+		use_alternative_detection_method(dev);
+
+		rc = fill_board_specific_data(dev);
+		if (rc < 0)
+			goto err;
+	}
 
 	/* Default values for STD and resolutions */
 	dev->width = 720;
diff --git a/drivers/staging/tm6000/tm6000-i2c.c b/drivers/staging/tm6000/tm6000-i2c.c
index 18de474..8828c12 100644
--- a/drivers/staging/tm6000/tm6000-i2c.c
+++ b/drivers/staging/tm6000/tm6000-i2c.c
@@ -237,35 +237,36 @@ err:
 	return rc;
 }
 
-static int tm6000_i2c_eeprom(struct tm6000_core *dev,
-			     unsigned char *eedata, int len)
+static int tm6000_i2c_eeprom(struct tm6000_core *dev)
 {
 	int i, rc;
-	unsigned char *p = eedata;
+	unsigned char *p = dev->eedata;
 	unsigned char bytes[17];
 
 	dev->i2c_client.addr = 0xa0 >> 1;
+	dev->eedata_size = 0;
 
 	bytes[16] = '\0';
-	for (i = 0; i < len; ) {
-	*p = i;
-	rc = tm6000_i2c_recv_regs(dev, 0xa0, i, p, 1);
+	for (i = 0; i < sizeof(dev->eedata); ) {
+		*p = i;
+		rc = tm6000_i2c_recv_regs(dev, 0xa0, i, p, 1);
 		if (rc < 1) {
-			if (p == eedata)
+			if (p == dev->eedata)
 				goto noeeprom;
 			else {
 				printk(KERN_WARNING
 				"%s: i2c eeprom read error (err=%d)\n",
 				dev->name, rc);
 			}
-			return -1;
+			return -EINVAL;
 		}
+		dev->eedata_size++;
 		p++;
 		if (0 == (i % 16))
 			printk(KERN_INFO "%s: i2c eeprom %02x:", dev->name, i);
-		printk(" %02x", eedata[i]);
-		if ((eedata[i] >= ' ') && (eedata[i] <= 'z'))
-			bytes[i%16] = eedata[i];
+		printk(" %02x", dev->eedata[i]);
+		if ((dev->eedata[i] >= ' ') && (dev->eedata[i] <= 'z'))
+			bytes[i%16] = dev->eedata[i];
 		else
 			bytes[i%16] = '.';
 
@@ -280,15 +281,15 @@ static int tm6000_i2c_eeprom(struct tm6000_core *dev,
 		bytes[i%16] = '\0';
 		for (i %= 16; i < 16; i++)
 			printk("   ");
+		printk("  %s\n", bytes);
 	}
-	printk("  %s\n", bytes);
 
 	return 0;
 
 noeeprom:
 	printk(KERN_INFO "%s: Huh, no eeprom present (err=%d)?\n",
-		       dev->name, rc);
-	return rc;
+	       dev->name, rc);
+	return -EINVAL;
 }
 
 /* ----------------------------------------------------------- */
@@ -314,7 +315,6 @@ static const struct i2c_algorithm tm6000_algo = {
  */
 int tm6000_i2c_register(struct tm6000_core *dev)
 {
-	unsigned char eedata[256];
 	int rc;
 
 	dev->i2c_adap.owner = THIS_MODULE;
@@ -329,8 +329,7 @@ int tm6000_i2c_register(struct tm6000_core *dev)
 
 	dev->i2c_client.adapter = &dev->i2c_adap;
 	strlcpy(dev->i2c_client.name, "tm6000 internal", I2C_NAME_SIZE);
-
-	tm6000_i2c_eeprom(dev, eedata, sizeof(eedata));
+	tm6000_i2c_eeprom(dev);
 
 	return 0;
 }
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index 99ae50e..fdd6d30 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -167,6 +167,8 @@ struct tm6000_core {
 	int				model;		/* index in the device_data struct */
 	int				devno;		/* marks the number of this device */
 	enum tm6000_devtype		dev_type;	/* type of device */
+	unsigned char			eedata[256];	/* Eeprom data */
+	unsigned			eedata_size;	/* Size of the eeprom info */
 
 	v4l2_std_id                     norm;           /* Current norm */
 	int				width, height;	/* Selected resolution */
