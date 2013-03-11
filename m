Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3423 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab3CKLqu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:46:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 16/42] go7007: switch to standard tuner/i2c subdevs.
Date: Mon, 11 Mar 2013 12:45:54 +0100
Message-Id: <a5f72624c6412dc0a7e4ef04f5e49316cae53a15.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Instead of using the wis-* drivers we now use the standard 'proper' subdev
drivers.

The board configuration tables now also list the possible audio inputs,
this will be used later to implement audio inputs.

Special mention deserves a little change in set_capture_size() where the
height passed to s_mbus_fmt is doubled: that is because the saa7115 driver
expects to see the frame height, not the field height as the wis_saa7115
driver did.

Another change is that the tuner input is moved from last to the first
input, which is consistent with the common practice in other video drivers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/Kconfig          |   77 ++---------------
 drivers/staging/media/go7007/Makefile         |   12 ---
 drivers/staging/media/go7007/go7007-driver.c  |   29 +++++--
 drivers/staging/media/go7007/go7007-i2c.c     |    1 -
 drivers/staging/media/go7007/go7007-priv.h    |   18 +++-
 drivers/staging/media/go7007/go7007-usb.c     |  112 +++++++++++++++++--------
 drivers/staging/media/go7007/go7007-v4l2.c    |   18 +++-
 drivers/staging/media/go7007/saa7134-go7007.c |    2 +-
 8 files changed, 135 insertions(+), 134 deletions(-)

diff --git a/drivers/staging/media/go7007/Kconfig b/drivers/staging/media/go7007/Kconfig
index 7dfb281..da32031 100644
--- a/drivers/staging/media/go7007/Kconfig
+++ b/drivers/staging/media/go7007/Kconfig
@@ -8,6 +8,12 @@ config VIDEO_GO7007
 	select VIDEO_TVEEPROM
 	select SND_PCM
 	select CRC32
+	select VIDEO_SONY_BTF_MPX if MEDIA_SUBDRV_AUTOSELECT
+	select VIDEO_SAA711X if MEDIA_SUBDRV_AUTOSELECT
+	select VIDEO_TW2804 if MEDIA_SUBDRV_AUTOSELECT
+	select VIDEO_TW9903 if MEDIA_SUBDRV_AUTOSELECT
+	select VIDEO_OV7640 if MEDIA_SUBDRV_AUTOSELECT
+	select VIDEO_UDA1342 if MEDIA_SUBDRV_AUTOSELECT
 	default N
 	---help---
 	  This is a video4linux driver for the WIS GO7007 MPEG
@@ -36,74 +42,3 @@ config VIDEO_GO7007_USB_S2250_BOARD
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called s2250
-
-config VIDEO_GO7007_OV7640
-	tristate "OV7640 subdev support"
-	depends on VIDEO_GO7007
-	default N
-	---help---
-	  This is a video4linux driver for the OV7640 sub-device.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called wis-ov7640
-
-config VIDEO_GO7007_SAA7113
-	tristate "SAA7113 subdev support"
-	depends on VIDEO_GO7007
-	default N
-	---help---
-	  This is a video4linux driver for the SAA7113 sub-device.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called wis-saa7113
-
-config VIDEO_GO7007_SAA7115
-	tristate "SAA7115 subdev support"
-	depends on VIDEO_GO7007
-	default N
-	---help---
-	  This is a video4linux driver for the SAA7115 sub-device.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called wis-saa7115
-
-config VIDEO_GO7007_TW9903
-	tristate "TW9903 subdev support"
-	depends on VIDEO_GO7007
-	default N
-	---help---
-	  This is a video4linux driver for the TW9903 sub-device.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called wis-tw9903
-
-config VIDEO_GO7007_UDA1342
-	tristate "UDA1342 subdev support"
-	depends on VIDEO_GO7007
-	default N
-	---help---
-	  This is a video4linux driver for the UDA1342 sub-device.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called wis-uda1342
-
-config VIDEO_GO7007_SONY_TUNER
-	tristate "Sony tuner subdev support"
-	depends on VIDEO_GO7007
-	default N
-	---help---
-	  This is a video4linux driver for the Sony Tuner sub-device.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called wis-sony-tuner
-
-config VIDEO_GO7007_TW2804
-	tristate "TW2804 subdev support"
-	depends on VIDEO_GO7007
-	default N
-	---help---
-	  This is a video4linux driver for the TW2804 sub-device.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called wis-tw2804
-
diff --git a/drivers/staging/media/go7007/Makefile b/drivers/staging/media/go7007/Makefile
index 3fdbef5..5bed78b 100644
--- a/drivers/staging/media/go7007/Makefile
+++ b/drivers/staging/media/go7007/Makefile
@@ -1,18 +1,6 @@
-#obj-m += go7007.o go7007-usb.o snd-go7007.o wis-saa7115.o wis-tw9903.o \
-		wis-uda1342.o wis-sony-tuner.o wis-saa7113.o wis-ov7640.o \
-		wis-tw2804.o
-
-
 obj-$(CONFIG_VIDEO_GO7007) += go7007.o
 obj-$(CONFIG_VIDEO_GO7007_USB) += go7007-usb.o
 obj-$(CONFIG_VIDEO_GO7007_USB_S2250_BOARD) += s2250.o s2250-loader.o
-obj-$(CONFIG_VIDEO_GO7007_SAA7113) += wis-saa7113.o
-obj-$(CONFIG_VIDEO_GO7007_OV7640) += wis-ov7640.o
-obj-$(CONFIG_VIDEO_GO7007_SAA7115) += wis-saa7115.o
-obj-$(CONFIG_VIDEO_GO7007_TW9903) += wis-tw9903.o
-obj-$(CONFIG_VIDEO_GO7007_UDA1342) += wis-uda1342.o
-obj-$(CONFIG_VIDEO_GO7007_SONY_TUNER) += wis-sony-tuner.o
-obj-$(CONFIG_VIDEO_GO7007_TW2804) += wis-tw2804.o
 
 go7007-y := go7007-v4l2.o go7007-driver.o go7007-i2c.o go7007-fw.o \
 		snd-go7007.o
diff --git a/drivers/staging/media/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
index 2e5be70..09d0ef4 100644
--- a/drivers/staging/media/go7007/go7007-driver.c
+++ b/drivers/staging/media/go7007/go7007-driver.c
@@ -35,7 +35,6 @@
 #include <media/v4l2-common.h>
 
 #include "go7007-priv.h"
-#include "wis-i2c.h"
 
 /*
  * Wait for an interrupt to be delivered from the GO7007SB and return
@@ -200,6 +199,7 @@ static int init_i2c_module(struct i2c_adapter *adapter, const struct go_i2c *con
 {
 	struct go7007 *go = i2c_get_adapdata(adapter);
 	struct v4l2_device *v4l2_dev = &go->v4l2_dev;
+	struct v4l2_subdev *sd;
 	struct i2c_board_info info;
 
 	memset(&info, 0, sizeof(info));
@@ -207,8 +207,14 @@ static int init_i2c_module(struct i2c_adapter *adapter, const struct go_i2c *con
 	info.addr = i2c->addr;
 	info.flags = i2c->flags;
 
-	if (v4l2_i2c_new_subdev_board(v4l2_dev, adapter, &info, NULL))
+	sd = v4l2_i2c_new_subdev_board(v4l2_dev, adapter, &info, NULL);
+	if (sd) {
+		if (i2c->is_video)
+			go->sd_video = sd;
+		if (i2c->is_audio)
+			go->sd_audio = sd;
 		return 0;
+	}
 
 	printk(KERN_INFO "go7007: probing for module i2c:%s failed\n", i2c->type);
 	return -EINVAL;
@@ -222,7 +228,7 @@ static int init_i2c_module(struct i2c_adapter *adapter, const struct go_i2c *con
  *
  * Must NOT be called with the hw_lock held.
  */
-int go7007_register_encoder(struct go7007 *go)
+int go7007_register_encoder(struct go7007 *go, unsigned num_i2c_devs)
 {
 	int i, ret;
 
@@ -246,11 +252,22 @@ int go7007_register_encoder(struct go7007 *go)
 		go->i2c_adapter_online = 1;
 	}
 	if (go->i2c_adapter_online) {
-		for (i = 0; i < go->board_info->num_i2c_devs; ++i)
+		for (i = 0; i < num_i2c_devs; ++i)
 			init_i2c_module(&go->i2c_adapter, &go->board_info->i2c_devs[i]);
+
+		if (go->tuner_type >= 0) {
+			struct tuner_setup setup = {
+				.addr = ADDR_UNSET,
+				.type = go->tuner_type,
+				.mode_mask = T_ANALOG_TV,
+			};
+
+			v4l2_device_call_all(&go->v4l2_dev, 0, tuner,
+				s_type_addr, &setup);
+		}
 		if (go->board_id == GO7007_BOARDID_ADLINK_MPG24)
-			i2c_clients_command(&go->i2c_adapter,
-				DECODER_SET_CHANNEL, &go->channel_number);
+			v4l2_subdev_call(go->sd_video, video, s_routing,
+					0, 0, go->channel_number + 1);
 	}
 	if (go->board_info->flags & GO7007_BOARD_HAS_AUDIO) {
 		go->audio_enabled = 1;
diff --git a/drivers/staging/media/go7007/go7007-i2c.c b/drivers/staging/media/go7007/go7007-i2c.c
index 1d0a400..74f25e0 100644
--- a/drivers/staging/media/go7007/go7007-i2c.c
+++ b/drivers/staging/media/go7007/go7007-i2c.c
@@ -28,7 +28,6 @@
 #include <linux/uaccess.h>
 
 #include "go7007-priv.h"
-#include "wis-i2c.h"
 
 /********************* Driver for on-board I2C adapter *********************/
 
diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
index b9ebdfb..898eb5b 100644
--- a/drivers/staging/media/go7007/go7007-priv.h
+++ b/drivers/staging/media/go7007/go7007-priv.h
@@ -90,16 +90,23 @@ struct go7007_board_info {
 	int num_i2c_devs;
 	struct go_i2c {
 		const char *type;
-		int id;
+		int is_video:1;
+		int is_audio:1;
 		int addr;
 		u32 flags;
-	} i2c_devs[4];
+	} i2c_devs[5];
 	int num_inputs;
 	struct {
 		int video_input;
-		int audio_input;
+		int audio_index;
 		char *name;
 	} inputs[4];
+	int video_config;
+	int num_aud_inputs;
+	struct {
+		int audio_input;
+		char *name;
+	} aud_inputs[3];
 };
 
 struct go7007_hpi_ops {
@@ -178,9 +185,12 @@ struct go7007 {
 	int streaming;
 	int in_use;
 	int audio_enabled;
+	struct v4l2_subdev *sd_video;
+	struct v4l2_subdev *sd_audio;
 
 	/* Video input */
 	int input;
+	int aud_input;
 	enum { GO7007_STD_NTSC, GO7007_STD_PAL, GO7007_STD_OTHER } standard;
 	int sensor_framerate;
 	int width;
@@ -268,7 +278,7 @@ int go7007_read_addr(struct go7007 *go, u16 addr, u16 *data);
 int go7007_read_interrupt(struct go7007 *go, u16 *value, u16 *data);
 int go7007_boot_encoder(struct go7007 *go, int init_i2c);
 int go7007_reset_encoder(struct go7007 *go);
-int go7007_register_encoder(struct go7007 *go);
+int go7007_register_encoder(struct go7007 *go, unsigned num_i2c_devs);
 int go7007_start_encoder(struct go7007 *go);
 void go7007_parse_video_stream(struct go7007 *go, u8 *buf, int length);
 struct go7007 *go7007_alloc(struct go7007_board_info *board,
diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index b44f9b1..5e3e5a0 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -26,11 +26,11 @@
 #include <linux/usb.h>
 #include <linux/i2c.h>
 #include <asm/byteorder.h>
-#include <media/tvaudio.h>
+#include <media/saa7115.h>
 #include <media/tuner.h>
+#include <media/uda1342.h>
 
 #include "go7007-priv.h"
-#include "wis-i2c.h"
 
 static unsigned int assume_endura;
 module_param(assume_endura, int, 0644);
@@ -93,9 +93,9 @@ static struct go7007_usb_board board_matrix_ii = {
 		.num_i2c_devs	 = 1,
 		.i2c_devs	 = {
 			{
-				.type	= "wis_saa7115",
-				.id	= I2C_DRIVERID_WIS_SAA7115,
+				.type	= "saa7115",
 				.addr	= 0x20,
+				.is_video = 1,
 			},
 		},
 		.num_inputs	 = 2,
@@ -109,6 +109,7 @@ static struct go7007_usb_board board_matrix_ii = {
 				.name		= "S-Video",
 			},
 		},
+		.video_config	= SAA7115_IDQ_IS_DEFAULT,
 	},
 };
 
@@ -130,9 +131,9 @@ static struct go7007_usb_board board_matrix_reload = {
 		.num_i2c_devs	 = 1,
 		.i2c_devs	 = {
 			{
-				.type	= "wis_saa7113",
-				.id	= I2C_DRIVERID_WIS_SAA7113,
+				.type	= "saa7115",
 				.addr	= 0x25,
+				.is_video = 1,
 			},
 		},
 		.num_inputs	 = 2,
@@ -146,6 +147,7 @@ static struct go7007_usb_board board_matrix_reload = {
 				.name		= "S-Video",
 			},
 		},
+		.video_config	= SAA7115_IDQ_IS_DEFAULT,
 	},
 };
 
@@ -168,30 +170,31 @@ static struct go7007_usb_board board_star_trek = {
 		.num_i2c_devs	 = 1,
 		.i2c_devs	 = {
 			{
-				.type	= "wis_saa7115",
-				.id	= I2C_DRIVERID_WIS_SAA7115,
+				.type	= "saa7115",
 				.addr	= 0x20,
+				.is_video = 1,
 			},
 		},
 		.num_inputs	 = 2,
 		.inputs		 = {
+		/*	{
+		 *		.video_input	= 3,
+		 *		.audio_index	= AUDIO_TUNER,
+		 *		.name		= "Tuner",
+		 *	},
+		 */
 			{
 				.video_input	= 1,
-			/*	.audio_input	= AUDIO_EXTERN, */
+			/*	.audio_index	= AUDIO_EXTERN, */
 				.name		= "Composite",
 			},
 			{
 				.video_input	= 8,
-			/*	.audio_input	= AUDIO_EXTERN, */
+			/*	.audio_index	= AUDIO_EXTERN, */
 				.name		= "S-Video",
 			},
-		/*	{
-		 *		.video_input	= 3,
-		 *		.audio_input	= AUDIO_TUNER,
-		 *		.name		= "Tuner",
-		 *	},
-		 */
 		},
+		.video_config	= SAA7115_IDQ_IS_DEFAULT,
 	},
 };
 
@@ -211,41 +214,60 @@ static struct go7007_usb_board board_px_tv402u = {
 		.audio_bclk_div	 = 8,
 		.audio_main_div	 = 2,
 		.hpi_buffer_cap  = 7,
-		.num_i2c_devs	 = 3,
+		.num_i2c_devs	 = 5,
 		.i2c_devs	 = {
 			{
-				.type	= "wis_saa7115",
-				.id	= I2C_DRIVERID_WIS_SAA7115,
+				.type	= "saa7115",
 				.addr	= 0x20,
+				.is_video = 1,
 			},
 			{
-				.type	= "wis_uda1342",
-				.id	= I2C_DRIVERID_WIS_UDA1342,
+				.type	= "uda1342",
 				.addr	= 0x1a,
+				.is_audio = 1,
 			},
 			{
-				.type	= "wis_sony_tuner",
-				.id	= I2C_DRIVERID_WIS_SONY_TUNER,
+				.type	= "tuner",
 				.addr	= 0x60,
 			},
+			{
+				.type	= "tuner",
+				.addr	= 0x43,
+			},
+			{
+				.type	= "sony-btf-mpx",
+				.addr	= 0x44,
+			},
 		},
 		.num_inputs	 = 3,
 		.inputs		 = {
 			{
+				.video_input	= 3,
+				.audio_index	= 0,
+				.name		= "Tuner",
+			},
+			{
 				.video_input	= 1,
-				.audio_input	= TVAUDIO_INPUT_EXTERN,
+				.audio_index	= 1,
 				.name		= "Composite",
 			},
 			{
 				.video_input	= 8,
-				.audio_input	= TVAUDIO_INPUT_EXTERN,
+				.audio_index	= 1,
 				.name		= "S-Video",
 			},
+		},
+		.video_config	= SAA7115_IDQ_IS_DEFAULT,
+		.num_aud_inputs	 = 2,
+		.aud_inputs	 = {
 			{
-				.video_input	= 3,
-				.audio_input	= TVAUDIO_INPUT_TUNER,
+				.audio_input	= UDA1342_IN2,
 				.name		= "Tuner",
 			},
+			{
+				.audio_input	= UDA1342_IN1,
+				.name		= "Line In",
+			},
 		},
 	},
 };
@@ -272,8 +294,7 @@ static struct go7007_usb_board board_xmen = {
 		.num_i2c_devs	  = 1,
 		.i2c_devs	  = {
 			{
-				.type	= "wis_ov7640",
-				.id	= I2C_DRIVERID_WIS_OV7640,
+				.type	= "ov7640",
 				.addr	= 0x21,
 			},
 		},
@@ -305,8 +326,8 @@ static struct go7007_usb_board board_matrix_revolution = {
 		.num_i2c_devs	 = 1,
 		.i2c_devs	 = {
 			{
-				.type	= "wis_tw9903",
-				.id	= I2C_DRIVERID_WIS_TW9903,
+				.type	= "tw9903",
+				.is_video = 1,
 				.addr	= 0x44,
 			},
 		},
@@ -395,10 +416,10 @@ static struct go7007_usb_board board_adlink_mpg24 = {
 		.num_i2c_devs	 = 1,
 		.i2c_devs	 = {
 			{
-				.type	= "wis_tw2804",
-				.id	= I2C_DRIVERID_WIS_TW2804,
+				.type	= "tw2804",
 				.addr	= 0x00, /* yes, really */
 				.flags  = I2C_CLIENT_TEN,
+				.is_video = 1,
 			},
 		},
 		.num_inputs	 = 1,
@@ -428,8 +449,9 @@ static struct go7007_usb_board board_sensoray_2250 = {
 		.i2c_devs	 = {
 			{
 				.type	= "s2250",
-				.id	= I2C_DRIVERID_S2250,
 				.addr	= 0x43,
+				.is_video = 1,
+				.is_audio = 1,
 			},
 		},
 		.num_inputs	 = 2,
@@ -443,6 +465,21 @@ static struct go7007_usb_board board_sensoray_2250 = {
 				.name		= "S-Video",
 			},
 		},
+		.num_aud_inputs	 = 3,
+		.aud_inputs	 = {
+			{
+				.audio_input	= 0,
+				.name		= "Line In",
+			},
+			{
+				.audio_input	= 1,
+				.name		= "Mic",
+			},
+			{
+				.audio_input	= 2,
+				.name		= "Mic Boost",
+			},
+		},
 	},
 };
 
@@ -972,6 +1009,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
 	struct go7007_usb *usb;
 	struct go7007_usb_board *board;
 	struct usb_device *usbdev = interface_to_usbdev(intf);
+	unsigned num_i2c_devs;
 	char *name;
 	int video_pipe, i, v_urb_len;
 
@@ -1126,6 +1164,8 @@ static int go7007_usb_probe(struct usb_interface *intf,
 		}
 	}
 
+	num_i2c_devs = go->board_info->num_i2c_devs;
+
 	/* Probe the tuner model on the TV402U */
 	if (go->board_id == GO7007_BOARDID_PX_TV402U_ANY) {
 		u8 data[3];
@@ -1145,12 +1185,14 @@ static int go7007_usb_probe(struct usb_interface *intf,
 		case 2:
 			go->board_id = GO7007_BOARDID_PX_TV402U_JP;
 			go->tuner_type = TUNER_SONY_BTF_PK467Z;
+			num_i2c_devs -= 2;
 			strncpy(go->name, "Plextor PX-TV402U-JP",
 					sizeof(go->name));
 			break;
 		case 3:
 			go->board_id = GO7007_BOARDID_PX_TV402U_NA;
 			go->tuner_type = TUNER_SONY_BTF_PB463Z;
+			num_i2c_devs -= 2;
 			strncpy(go->name, "Plextor PX-TV402U-NA",
 					sizeof(go->name));
 			break;
@@ -1180,7 +1222,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
 
 	/* Do any final GO7007 initialization, then register the
 	 * V4L2 and ALSA interfaces */
-	if (go7007_register_encoder(go) < 0)
+	if (go7007_register_encoder(go, num_i2c_devs) < 0)
 		goto initfail;
 
 	/* Allocate the URBs and buffers for receiving the video stream */
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index e115132..bab4a31 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -37,7 +37,6 @@
 
 #include "go7007.h"
 #include "go7007-priv.h"
-#include "wis-i2c.h"
 
 /* Temporary defines until accepted in v4l-dvb */
 #ifndef V4L2_MPEG_STREAM_TYPE_MPEG_ELEM
@@ -264,6 +263,7 @@ static int set_capture_size(struct go7007 *go, struct v4l2_format *fmt, int try)
 			mbus_fmt.height = height;
 			go->encoder_v_halve = 1;
 		}
+		mbus_fmt.height *= 2;
 		call_all(&go->v4l2_dev, video, s_mbus_fmt, &mbus_fmt);
 	} else {
 		if (width <= sensor_width / 4) {
@@ -1184,9 +1184,9 @@ static int vidioc_enum_input(struct file *file, void *priv,
 	strncpy(inp->name, go->board_info->inputs[inp->index].name,
 			sizeof(inp->name));
 
-	/* If this board has a tuner, it will be the last input */
+	/* If this board has a tuner, it will be the first input */
 	if ((go->board_info->flags & GO7007_BOARD_HAS_TUNER) &&
-			inp->index == go->board_info->num_inputs - 1)
+			inp->index == 0)
 		inp->type = V4L2_INPUT_TYPE_TUNER;
 	else
 		inp->type = V4L2_INPUT_TYPE_CAMERA;
@@ -1223,7 +1223,17 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int input)
 
 	go->input = input;
 
-	return call_all(&go->v4l2_dev, video, s_routing, input, 0, 0);
+	v4l2_subdev_call(go->sd_video, video, s_routing,
+			go->board_info->inputs[input].video_input, 0,
+			go->board_info->video_config);
+	if (go->board_info->num_aud_inputs) {
+		int aud_input = go->board_info->inputs[input].audio_index;
+
+		v4l2_subdev_call(go->sd_audio, audio, s_routing,
+			go->board_info->aud_inputs[aud_input].audio_input, 0, 0);
+		go->aud_input = aud_input;
+	}
+	return 0;
 }
 
 static int vidioc_g_tuner(struct file *file, void *priv,
diff --git a/drivers/staging/media/go7007/saa7134-go7007.c b/drivers/staging/media/go7007/saa7134-go7007.c
index cf7c34a..e037a39 100644
--- a/drivers/staging/media/go7007/saa7134-go7007.c
+++ b/drivers/staging/media/go7007/saa7134-go7007.c
@@ -468,7 +468,7 @@ static int saa7134_go7007_init(struct saa7134_dev *dev)
 
 	/* Do any final GO7007 initialization, then register the
 	 * V4L2 and ALSA interfaces */
-	if (go7007_register_encoder(go) < 0)
+	if (go7007_register_encoder(go, go->board_info->num_i2c_devs) < 0)
 		goto initfail;
 	dev->empress_dev = go->video_dev;
 	video_set_drvdata(dev->empress_dev, go);
-- 
1.7.10.4

