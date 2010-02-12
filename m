Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway03.websitewelcome.com ([69.93.205.23]:57464 "HELO
	gateway03.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751477Ab0BLCTu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2010 21:19:50 -0500
Received: from [66.15.212.169] (port=10302 helo=[10.140.5.12])
	by gator886.hostgator.com with esmtpsa (SSLv3:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <pete@sensoray.com>)
	id 1NfjT3-0005dZ-DE
	for linux-media@vger.kernel.org; Thu, 11 Feb 2010 18:33:09 -0600
Subject: [PATCH 1/5] go7007: driver id cleanup
From: Pete Eberlein <pete@sensoray.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 11 Feb 2010 16:32:52 -0800
Message-Id: <1265934772.4626.250.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pete Eberlein <pete@sensoray.com>

Removed the I2C_DRIVERID_WIS usage from the device configurations, since
the type parameter is all that is needed to probe the chip driver module.
Eventually wis-i2c.h will be removed.

Priority: normal

Signed-off-by: Pete Eberlein <pete@sensoray.com>

diff -r 690055993011 -r 2d2a250ca33b linux/drivers/staging/go7007/go7007-driver.c
--- a/linux/drivers/staging/go7007/go7007-driver.c	Sun Feb 07 22:26:10 2010 -0200
+++ b/linux/drivers/staging/go7007/go7007-driver.c	Wed Feb 10 11:25:59 2010 -0800
@@ -35,7 +35,6 @@
 #include <media/v4l2-common.h>
 
 #include "go7007-priv.h"
-#include "wis-i2c.h"
 
 /*
  * Wait for an interrupt to be delivered from the GO7007SB and return
@@ -191,51 +190,20 @@
  * Attempt to instantiate an I2C client by ID, probably loading a module.
  */
 static int init_i2c_module(struct i2c_adapter *adapter, const char *type,
-			   int id, int addr)
+			   int addr)
 {
 	struct go7007 *go = i2c_get_adapdata(adapter);
 	struct v4l2_device *v4l2_dev = &go->v4l2_dev;
-	char *modname;
 
-	switch (id) {
-	case I2C_DRIVERID_WIS_SAA7115:
-		modname = "wis-saa7115";
-		break;
-	case I2C_DRIVERID_WIS_SAA7113:
-		modname = "wis-saa7113";
-		break;
-	case I2C_DRIVERID_WIS_UDA1342:
-		modname = "wis-uda1342";
-		break;
-	case I2C_DRIVERID_WIS_SONY_TUNER:
-		modname = "wis-sony-tuner";
-		break;
-	case I2C_DRIVERID_WIS_TW9903:
-		modname = "wis-tw9903";
-		break;
-	case I2C_DRIVERID_WIS_TW2804:
-		modname = "wis-tw2804";
-		break;
-	case I2C_DRIVERID_WIS_OV7640:
-		modname = "wis-ov7640";
-		break;
-	case I2C_DRIVERID_S2250:
-		modname = "s2250";
-		break;
-	default:
-		modname = NULL;
-		break;
-	}
-
-	if (v4l2_i2c_new_subdev(v4l2_dev, adapter, modname, type, addr, NULL))
+	if (v4l2_i2c_new_subdev(v4l2_dev, adapter, type, type, addr, NULL))
 		return 0;
 
-	if (modname != NULL)
+	if (type != NULL)
 		printk(KERN_INFO
-			"go7007: probing for module %s failed\n", modname);
+			"go7007: probing for module %s failed\n", type);
 	else
 		printk(KERN_INFO
-			"go7007: sensor %u seems to be unsupported!\n", id);
+			"go7007: sensor seems to be unsupported!\n");
 	return -1;
 }
 
@@ -274,11 +242,16 @@
 		for (i = 0; i < go->board_info->num_i2c_devs; ++i)
 			init_i2c_module(&go->i2c_adapter,
 					go->board_info->i2c_devs[i].type,
-					go->board_info->i2c_devs[i].id,
 					go->board_info->i2c_devs[i].addr);
-		if (go->board_id == GO7007_BOARDID_ADLINK_MPG24)
-			i2c_clients_command(&go->i2c_adapter,
-				DECODER_SET_CHANNEL, &go->channel_number);
+		if (go->board_id == GO7007_BOARDID_ADLINK_MPG24) {
+			int channel = go->channel_number;
+			struct v4l2_priv_tun_config config = {
+				.tuner	= go->tuner_type,
+				.priv	= &channel,
+			};
+			v4l2_device_call_all(&go->v4l2_dev, 0, tuner, s_config,
+				&config);
+		}
 	}
 	if (go->board_info->flags & GO7007_BOARD_HAS_AUDIO) {
 		go->audio_enabled = 1;
diff -r 690055993011 -r 2d2a250ca33b linux/drivers/staging/go7007/go7007-priv.h
--- a/linux/drivers/staging/go7007/go7007-priv.h	Sun Feb 07 22:26:10 2010 -0200
+++ b/linux/drivers/staging/go7007/go7007-priv.h	Wed Feb 10 11:25:59 2010 -0800
@@ -90,7 +90,6 @@
 	int num_i2c_devs;
 	struct {
 		const char *type;
-		int id;
 		int addr;
 	} i2c_devs[4];
 	int num_inputs;
@@ -288,3 +287,14 @@
 /* snd-go7007.c */
 int go7007_snd_init(struct go7007 *go);
 int go7007_snd_remove(struct go7007 *go);
+
+/* Flag to indicate that the client needs to be accessed with SCCB semantics */
+/* We re-use the I2C_M_TEN value so the flag passes through the masks in the
+ * core I2C code.  Major kludge, but the I2C layer ain't exactly flexible. */
+#define	I2C_CLIENT_SCCB			0x10
+
+/* Sony tuner types */
+
+#define TUNER_SONY_BTF_PG472Z		200
+#define TUNER_SONY_BTF_PK467Z		201
+#define TUNER_SONY_BTF_PB463Z		202
diff -r 690055993011 -r 2d2a250ca33b linux/drivers/staging/go7007/go7007-usb.c
--- a/linux/drivers/staging/go7007/go7007-usb.c	Sun Feb 07 22:26:10 2010 -0200
+++ b/linux/drivers/staging/go7007/go7007-usb.c	Wed Feb 10 11:25:59 2010 -0800
@@ -29,7 +29,6 @@
 #include <media/tvaudio.h>
 
 #include "go7007-priv.h"
-#include "wis-i2c.h"
 
 static unsigned int assume_endura;
 module_param(assume_endura, int, 0644);
@@ -92,8 +91,7 @@
 		.num_i2c_devs	 = 1,
 		.i2c_devs	 = {
 			{
-				.type	= "wis_saa7115",
-				.id	= I2C_DRIVERID_WIS_SAA7115,
+				.type	= "saa7115",
 				.addr	= 0x20,
 			},
 		},
@@ -129,8 +127,7 @@
 		.num_i2c_devs	 = 1,
 		.i2c_devs	 = {
 			{
-				.type	= "wis_saa7113",
-				.id	= I2C_DRIVERID_WIS_SAA7113,
+				.type	= "saa7115",
 				.addr	= 0x25,
 			},
 		},
@@ -167,8 +164,7 @@
 		.num_i2c_devs	 = 1,
 		.i2c_devs	 = {
 			{
-				.type	= "wis_saa7115",
-				.id	= I2C_DRIVERID_WIS_SAA7115,
+				.type	= "saa7115",
 				.addr	= 0x20,
 			},
 		},
@@ -213,18 +209,15 @@
 		.num_i2c_devs	 = 3,
 		.i2c_devs	 = {
 			{
-				.type	= "wis_saa7115",
-				.id	= I2C_DRIVERID_WIS_SAA7115,
+				.type	= "saa7115",
 				.addr	= 0x20,
 			},
 			{
 				.type	= "wis_uda1342",
-				.id	= I2C_DRIVERID_WIS_UDA1342,
 				.addr	= 0x1a,
 			},
 			{
 				.type	= "wis_sony_tuner",
-				.id	= I2C_DRIVERID_WIS_SONY_TUNER,
 				.addr	= 0x60,
 			},
 		},
@@ -272,7 +265,6 @@
 		.i2c_devs	  = {
 			{
 				.type	= "wis_ov7640",
-				.id	= I2C_DRIVERID_WIS_OV7640,
 				.addr	= 0x21,
 			},
 		},
@@ -305,7 +297,6 @@
 		.i2c_devs	 = {
 			{
 				.type	= "wis_tw9903",
-				.id	= I2C_DRIVERID_WIS_TW9903,
 				.addr	= 0x44,
 			},
 		},
@@ -394,8 +385,7 @@
 		.num_i2c_devs	 = 1,
 		.i2c_devs	 = {
 			{
-				.type	= "wis_twTW2804",
-				.id	= I2C_DRIVERID_WIS_TW2804,
+				.type	= "wis_tw2804",
 				.addr	= 0x00, /* yes, really */
 			},
 		},
@@ -426,7 +416,6 @@
 		.i2c_devs	 = {
 			{
 				.type	= "s2250",
-				.id	= I2C_DRIVERID_S2250,
 				.addr	= 0x43,
 			},
 		},
diff -r 690055993011 -r 2d2a250ca33b linux/drivers/staging/go7007/wis-i2c.h
--- a/linux/drivers/staging/go7007/wis-i2c.h	Sun Feb 07 22:26:10 2010 -0200
+++ b/linux/drivers/staging/go7007/wis-i2c.h	Wed Feb 10 11:25:59 2010 -0800
@@ -25,11 +25,6 @@
 #define	I2C_DRIVERID_WIS_TW2804		0xf0f6
 #define	I2C_DRIVERID_S2250		0xf0f7
 
-/* Flag to indicate that the client needs to be accessed with SCCB semantics */
-/* We re-use the I2C_M_TEN value so the flag passes through the masks in the
- * core I2C code.  Major kludge, but the I2C layer ain't exactly flexible. */
-#define	I2C_CLIENT_SCCB			0x10
-
 /* Definitions for new video decoder commands */
 
 struct video_decoder_resolution {
@@ -38,10 +33,4 @@
 };
 
 #define	DECODER_SET_RESOLUTION	_IOW('d', 200, struct video_decoder_resolution)
-#define	DECODER_SET_CHANNEL	_IOW('d', 201, int)
-
-/* Sony tuner types */
-
-#define TUNER_SONY_BTF_PG472Z		200
-#define TUNER_SONY_BTF_PK467Z		201
-#define TUNER_SONY_BTF_PB463Z		202
+#define	DECODER_SET_CHANNEL	_IOW('d', 201, int)
diff -r 690055993011 -r 2d2a250ca33b linux/drivers/staging/go7007/wis-ov7640.c
--- a/linux/drivers/staging/go7007/wis-ov7640.c	Sun Feb 07 22:26:10 2010 -0200
+++ b/linux/drivers/staging/go7007/wis-ov7640.c	Wed Feb 10 11:25:59 2010 -0800
@@ -20,7 +20,7 @@
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 
-#include "wis-i2c.h"
+#include "go7007-priv.h"
 
 struct wis_ov7640 {
 	int brightness;
diff -r 690055993011 -r 2d2a250ca33b linux/drivers/staging/go7007/wis-sony-tuner.c
--- a/linux/drivers/staging/go7007/wis-sony-tuner.c	Sun Feb 07 22:26:10 2010 -0200
+++ b/linux/drivers/staging/go7007/wis-sony-tuner.c	Wed Feb 10 11:25:59 2010 -0800
@@ -23,7 +23,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 
-#include "wis-i2c.h"
+#include "go7007-priv.h"
 
 /* #define MPX_DEBUG */
 

