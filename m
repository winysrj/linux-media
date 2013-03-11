Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3004 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab3CKLrQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:47:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 40/42] go7007-loader: add support for the other devices and move fw files
Date: Mon, 11 Mar 2013 12:46:18 +0100
Message-Id: <58a2576d00b817fa77a6c9d84456420c15aa9925.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for the other devices that need to load the boot firmware.
All firmware files are now placed in a single go7007 directory.

Also remove the device_extension_s stuff: this is clearly a left-over from
the olden days.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/go7007-driver.c  |    4 +-
 drivers/staging/media/go7007/go7007-loader.c  |  131 ++++++++++---------------
 drivers/staging/media/go7007/go7007-usb.c     |   22 ++---
 drivers/staging/media/go7007/saa7134-go7007.c |    3 +-
 4 files changed, 68 insertions(+), 92 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
index 0fd3f10..4378223 100644
--- a/drivers/staging/media/go7007/go7007-driver.c
+++ b/drivers/staging/media/go7007/go7007-driver.c
@@ -90,7 +90,7 @@ EXPORT_SYMBOL(go7007_read_addr);
 static int go7007_load_encoder(struct go7007 *go)
 {
 	const struct firmware *fw_entry;
-	char fw_name[] = "go7007fw.bin";
+	char fw_name[] = "go7007/go7007fw.bin";
 	void *bounce;
 	int fw_len, rv = 0;
 	u16 intr_val, intr_data;
@@ -126,7 +126,7 @@ static int go7007_load_encoder(struct go7007 *go)
 	return rv;
 }
 
-MODULE_FIRMWARE("go7007fw.bin");
+MODULE_FIRMWARE("go7007/go7007fw.bin");
 
 /*
  * Boot the encoder and register the I2C adapter if requested.  Do the
diff --git a/drivers/staging/media/go7007/go7007-loader.c b/drivers/staging/media/go7007/go7007-loader.c
index 730a4f8..4ce53d6 100644
--- a/drivers/staging/media/go7007/go7007-loader.c
+++ b/drivers/staging/media/go7007/go7007-loader.c
@@ -22,86 +22,67 @@
 #include <linux/firmware.h>
 #include <cypress_firmware.h>
 
-#define S2250_LOADER_FIRMWARE	"s2250_loader.fw"
-#define S2250_FIRMWARE		"2250.fw"
-
-typedef struct device_extension_s {
-    struct kref     kref;
-    int minor;
-    struct usb_device *usbdev;
-} device_extension_t, *pdevice_extension_t;
-
-#define USB_go7007_loader_MAJOR 240
-#define USB_go7007_loader_MINOR_BASE 0
-#define MAX_DEVICES 256
-
-static pdevice_extension_t go7007_dev_table[MAX_DEVICES];
-static DEFINE_MUTEX(go7007_dev_table_mutex);
+struct fw_config {
+	u16 vendor;
+	u16 product;
+	const char * const fw_name1;
+	const char * const fw_name2;
+};
 
-#define to_go7007_loader_dev_common(d) container_of(d, device_extension_t, kref)
-static void go7007_loader_delete(struct kref *kref)
-{
-	pdevice_extension_t s = to_go7007_loader_dev_common(kref);
-	go7007_dev_table[s->minor] = NULL;
-	kfree(s);
-}
+struct fw_config fw_configs[] = {
+	{ 0x1943, 0xa250, "go7007/s2250-1.fw", "go7007/s2250-2.fw" },
+	{ 0x093b, 0xa002, "go7007/px-m402u.fw", NULL },
+	{ 0x093b, 0xa004, "go7007/px-tv402u.fw", NULL },
+	{ 0x0eb1, 0x6666, "go7007/lr192.fw", NULL },
+	{ 0x0eb1, 0x6668, "go7007/wis-startrek.fw", NULL },
+	{ 0, 0, NULL, NULL }
+};
+MODULE_FIRMWARE("go7007/s2250-1.fw");
+MODULE_FIRMWARE("go7007/s2250-2.fw");
+MODULE_FIRMWARE("go7007/px-m402u.fw");
+MODULE_FIRMWARE("go7007/px-tv402u.fw");
+MODULE_FIRMWARE("go7007/lr192.fw");
+MODULE_FIRMWARE("go7007/wis-startrek.fw");
 
 static int go7007_loader_probe(struct usb_interface *interface,
 				const struct usb_device_id *id)
 {
 	struct usb_device *usbdev;
-	int minor, ret;
-	pdevice_extension_t s = NULL;
 	const struct firmware *fw;
+	u16 vendor, product;
+	const char *fw1, *fw2;
+	int ret;
+	int i;
 
 	usbdev = usb_get_dev(interface_to_usbdev(interface));
-	if (!usbdev) {
-		dev_err(&interface->dev, "Enter go7007_loader_probe failed\n");
-		return -1;
-	}
-	dev_info(&interface->dev, "vendor id 0x%x, device id 0x%x devnum:%d\n",
-		 usbdev->descriptor.idVendor, usbdev->descriptor.idProduct,
-		 usbdev->devnum);
+	if (!usbdev)
+		goto failed2;
 
 	if (usbdev->descriptor.bNumConfigurations != 1) {
 		dev_err(&interface->dev, "can't handle multiple config\n");
-		return -1;
-	}
-	mutex_lock(&go7007_dev_table_mutex);
-
-	for (minor = 0; minor < MAX_DEVICES; minor++) {
-		if (go7007_dev_table[minor] == NULL)
-			break;
+		return -ENODEV;
 	}
 
-	if (minor < 0 || minor >= MAX_DEVICES) {
-		dev_err(&interface->dev, "Invalid minor: %d\n", minor);
-		goto failed;
-	}
-
-	/* Allocate dev data structure */
-	s = kmalloc(sizeof(device_extension_t), GFP_KERNEL);
-	if (s == NULL)
-		goto failed;
-
-	go7007_dev_table[minor] = s;
+	vendor = le16_to_cpu(usbdev->descriptor.idVendor);
+	product = le16_to_cpu(usbdev->descriptor.idProduct);
 
-	dev_info(&interface->dev,
-		 "Device %d on Bus %d Minor %d\n",
-		 usbdev->devnum, usbdev->bus->busnum, minor);
+	for (i = 0; fw_configs[i].fw_name1; i++)
+		if (fw_configs[i].vendor == vendor &&
+		    fw_configs[i].product == product)
+			break;
 
-	memset(s, 0, sizeof(device_extension_t));
-	s->usbdev = usbdev;
-	dev_info(&interface->dev, "loading go7007-loader\n");
+	/* Should never happen */
+	if (fw_configs[i].fw_name1 == NULL)
+		goto failed2;
 
-	kref_init(&(s->kref));
+	fw1 = fw_configs[i].fw_name1;
+	fw2 = fw_configs[i].fw_name2;
 
-	mutex_unlock(&go7007_dev_table_mutex);
+	dev_info(&interface->dev, "loading firmware %s\n", fw1);
 
-	if (request_firmware(&fw, S2250_LOADER_FIRMWARE, &usbdev->dev)) {
+	if (request_firmware(&fw, fw1, &usbdev->dev)) {
 		dev_err(&interface->dev,
-			"unable to load firmware from file \"%s\"\n",
-			S2250_LOADER_FIRMWARE);
+			"unable to load firmware from file \"%s\"\n", fw1);
 		goto failed2;
 	}
 	ret = usbv2_cypress_load_firmware(usbdev, fw, CYPRESS_FX2);
@@ -111,10 +92,12 @@ static int go7007_loader_probe(struct usb_interface *interface,
 		goto failed2;
 	}
 
-	if (request_firmware(&fw, S2250_FIRMWARE, &usbdev->dev)) {
+	if (fw2 == NULL)
+		return 0;
+
+	if (request_firmware(&fw, fw2, &usbdev->dev)) {
 		dev_err(&interface->dev,
-			"unable to load firmware from file \"%s\"\n",
-			S2250_FIRMWARE);
+			"unable to load firmware from file \"%s\"\n", fw2);
 		goto failed2;
 	}
 	ret = usbv2_cypress_load_firmware(usbdev, fw, CYPRESS_FX2);
@@ -123,31 +106,25 @@ static int go7007_loader_probe(struct usb_interface *interface,
 		dev_err(&interface->dev, "firmware download failed\n");
 		goto failed2;
 	}
-
-	usb_set_intfdata(interface, s);
 	return 0;
 
-failed:
-	mutex_unlock(&go7007_dev_table_mutex);
 failed2:
-	if (s)
-		kref_put(&(s->kref), go7007_loader_delete);
-
 	dev_err(&interface->dev, "probe failed\n");
-	return -1;
+	return -ENODEV;
 }
 
 static void go7007_loader_disconnect(struct usb_interface *interface)
 {
-	pdevice_extension_t s;
 	dev_info(&interface->dev, "disconnect\n");
-	s = usb_get_intfdata(interface);
 	usb_set_intfdata(interface, NULL);
-	kref_put(&(s->kref), go7007_loader_delete);
 }
 
 static const struct usb_device_id go7007_loader_ids[] = {
-	{USB_DEVICE(0x1943, 0xa250)},
+	{ USB_DEVICE(0x1943, 0xa250) },
+	{ USB_DEVICE(0x093b, 0xa002) },
+	{ USB_DEVICE(0x093b, 0xa004) },
+	{ USB_DEVICE(0x0eb1, 0x6666) },
+	{ USB_DEVICE(0x0eb1, 0x6668) },
 	{}                          /* Terminating entry */
 };
 
@@ -163,7 +140,5 @@ static struct usb_driver go7007_loader_driver = {
 module_usb_driver(go7007_loader_driver);
 
 MODULE_AUTHOR("");
-MODULE_DESCRIPTION("firmware loader for go7007 USB devices");
+MODULE_DESCRIPTION("firmware loader for go7007-usb");
 MODULE_LICENSE("GPL v2");
-MODULE_FIRMWARE(S2250_LOADER_FIRMWARE);
-MODULE_FIRMWARE(S2250_FIRMWARE);
diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index 2a1cda2..bd23d7d 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -76,7 +76,7 @@ struct go7007_usb {
 static struct go7007_usb_board board_matrix_ii = {
 	.flags		= GO7007_USB_EZUSB,
 	.main_info	= {
-		.firmware	 = "go7007tv.bin",
+		.firmware	 = "go7007/go7007tv.bin",
 		.flags		 = GO7007_BOARD_HAS_AUDIO |
 					GO7007_BOARD_USE_ONBOARD_I2C,
 		.audio_flags	 = GO7007_AUDIO_I2S_MODE_1 |
@@ -117,7 +117,7 @@ static struct go7007_usb_board board_matrix_ii = {
 static struct go7007_usb_board board_matrix_reload = {
 	.flags		= GO7007_USB_EZUSB,
 	.main_info	= {
-		.firmware	 = "go7007tv.bin",
+		.firmware	 = "go7007/go7007tv.bin",
 		.flags		 = GO7007_BOARD_HAS_AUDIO |
 					GO7007_BOARD_USE_ONBOARD_I2C,
 		.audio_flags	 = GO7007_AUDIO_I2S_MODE_1 |
@@ -155,7 +155,7 @@ static struct go7007_usb_board board_matrix_reload = {
 static struct go7007_usb_board board_star_trek = {
 	.flags		= GO7007_USB_EZUSB | GO7007_USB_EZUSB_I2C,
 	.main_info	= {
-		.firmware	 = "go7007tv.bin",
+		.firmware	 = "go7007/go7007tv.bin",
 		.flags		 = GO7007_BOARD_HAS_AUDIO, /* |
 					GO7007_BOARD_HAS_TUNER, */
 		.sensor_flags	 = GO7007_SENSOR_656 |
@@ -203,7 +203,7 @@ static struct go7007_usb_board board_star_trek = {
 static struct go7007_usb_board board_px_tv402u = {
 	.flags		= GO7007_USB_EZUSB | GO7007_USB_EZUSB_I2C,
 	.main_info	= {
-		.firmware	 = "go7007tv.bin",
+		.firmware	 = "go7007/go7007tv.bin",
 		.flags		 = GO7007_BOARD_HAS_AUDIO |
 					GO7007_BOARD_HAS_TUNER,
 		.sensor_flags	 = GO7007_SENSOR_656 |
@@ -278,7 +278,7 @@ static struct go7007_usb_board board_px_tv402u = {
 static struct go7007_usb_board board_xmen = {
 	.flags		= 0,
 	.main_info	= {
-		.firmware	  = "go7007tv.bin",
+		.firmware	  = "go7007/go7007tv.bin",
 		.flags		  = GO7007_BOARD_USE_ONBOARD_I2C,
 		.hpi_buffer_cap   = 0,
 		.sensor_flags	  = GO7007_SENSOR_VREF_POLAR,
@@ -313,7 +313,7 @@ static struct go7007_usb_board board_xmen = {
 static struct go7007_usb_board board_matrix_revolution = {
 	.flags		= GO7007_USB_EZUSB,
 	.main_info	= {
-		.firmware	 = "go7007tv.bin",
+		.firmware	 = "go7007/go7007tv.bin",
 		.flags		 = GO7007_BOARD_HAS_AUDIO |
 					GO7007_BOARD_USE_ONBOARD_I2C,
 		.audio_flags	 = GO7007_AUDIO_I2S_MODE_1 |
@@ -351,7 +351,7 @@ static struct go7007_usb_board board_matrix_revolution = {
 static struct go7007_usb_board board_lifeview_lr192 = {
 	.flags		= GO7007_USB_EZUSB,
 	.main_info	= {
-		.firmware	 = "go7007tv.bin",
+		.firmware	 = "go7007/go7007tv.bin",
 		.flags		 = GO7007_BOARD_HAS_AUDIO |
 					GO7007_BOARD_USE_ONBOARD_I2C,
 		.audio_flags	 = GO7007_AUDIO_I2S_MODE_1 |
@@ -379,7 +379,7 @@ static struct go7007_usb_board board_lifeview_lr192 = {
 static struct go7007_usb_board board_endura = {
 	.flags		= 0,
 	.main_info	= {
-		.firmware	 = "go7007tv.bin",
+		.firmware	 = "go7007/go7007tv.bin",
 		.flags		 = 0,
 		.audio_flags	 = GO7007_AUDIO_I2S_MODE_1 |
 					GO7007_AUDIO_I2S_MASTER |
@@ -404,7 +404,7 @@ static struct go7007_usb_board board_endura = {
 static struct go7007_usb_board board_adlink_mpg24 = {
 	.flags		= 0,
 	.main_info	= {
-		.firmware	 = "go7007tv.bin",
+		.firmware	 = "go7007/go7007tv.bin",
 		.flags		 = GO7007_BOARD_USE_ONBOARD_I2C,
 		.audio_flags	 = GO7007_AUDIO_I2S_MODE_1 |
 					GO7007_AUDIO_I2S_MASTER |
@@ -437,7 +437,7 @@ static struct go7007_usb_board board_adlink_mpg24 = {
 static struct go7007_usb_board board_sensoray_2250 = {
 	.flags		= GO7007_USB_EZUSB | GO7007_USB_EZUSB_I2C,
 	.main_info	= {
-		.firmware	 = "go7007tv.bin",
+		.firmware	 = "go7007/go7007tv.bin",
 		.audio_flags	 = GO7007_AUDIO_I2S_MODE_1 |
 					GO7007_AUDIO_I2S_MASTER |
 					GO7007_AUDIO_WORD_16,
@@ -486,7 +486,7 @@ static struct go7007_usb_board board_sensoray_2250 = {
 	},
 };
 
-MODULE_FIRMWARE("go7007tv.bin");
+MODULE_FIRMWARE("go7007/go7007tv.bin");
 
 static const struct usb_device_id go7007_usb_id_table[] = {
 	{
diff --git a/drivers/staging/media/go7007/saa7134-go7007.c b/drivers/staging/media/go7007/saa7134-go7007.c
index f51f42e..daa8c02 100644
--- a/drivers/staging/media/go7007/saa7134-go7007.c
+++ b/drivers/staging/media/go7007/saa7134-go7007.c
@@ -74,7 +74,7 @@ static inline struct saa7134_go7007 *to_state(struct v4l2_subdev *sd)
 }
 
 static struct go7007_board_info board_voyager = {
-	.firmware	 = "go7007tv.bin",
+	.firmware	 = "go7007/go7007tv.bin",
 	.flags		 = 0,
 	.sensor_flags	 = GO7007_SENSOR_656 |
 				GO7007_SENSOR_VALID_ENABLE |
@@ -93,6 +93,7 @@ static struct go7007_board_info board_voyager = {
 		},
 	},
 };
+MODULE_FIRMWARE("go7007/go7007tv.bin");
 
 /********************* Driver for GPIO HPI interface *********************/
 
-- 
1.7.10.4

