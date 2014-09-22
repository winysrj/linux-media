Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:38736 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbaIVEcf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 00:32:35 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com, crope@iki.fi
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH] cx231xx: use i2c mux instead of own switching
Date: Mon, 22 Sep 2014 06:30:33 +0200
Message-Id: <1411360233-5627-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There no longer is port switching unrelated to any access.
The 4 (3 external and 1 internal) i2c busses can now be specified directly
via symbolic constants.

The handling of the i2c_clients and the bus scanning could be improved,
so that the new muxed busses also have i2c_clients for direct usage and are
automatically scanned.

This patch should be tested for more of the affected devices to make
sure it is correct.

To get rid of lines greater 80 columns one could save the tuner and
demod i2c_adap in local variables.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/usb/cx231xx/Kconfig          |  1 +
 drivers/media/usb/cx231xx/cx231xx-avcore.c | 17 ------
 drivers/media/usb/cx231xx/cx231xx-cards.c  | 85 ++++++++++++++----------------
 drivers/media/usb/cx231xx/cx231xx-core.c   | 34 ++++++++++--
 drivers/media/usb/cx231xx/cx231xx-dvb.c    | 42 +++++++--------
 drivers/media/usb/cx231xx/cx231xx-i2c.c    | 17 ++++++
 drivers/media/usb/cx231xx/cx231xx-input.c  |  2 +-
 drivers/media/usb/cx231xx/cx231xx.h        |  5 +-
 8 files changed, 113 insertions(+), 90 deletions(-)

diff --git a/drivers/media/usb/cx231xx/Kconfig b/drivers/media/usb/cx231xx/Kconfig
index 569aa29..173c0e2 100644
--- a/drivers/media/usb/cx231xx/Kconfig
+++ b/drivers/media/usb/cx231xx/Kconfig
@@ -7,6 +7,7 @@ config VIDEO_CX231XX
 	select VIDEOBUF_VMALLOC
 	select VIDEO_CX25840
 	select VIDEO_CX2341X
+	select I2C_MUX
 
 	---help---
 	  This is a video4linux driver for Conexant 231xx USB based TV cards.
diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
index 51872b9..fcdbb4b 100644
--- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
@@ -1270,8 +1270,6 @@ int cx231xx_enable_i2c_port_3(struct cx231xx *dev, bool is_port_3)
 	int status = 0;
 	bool current_is_port_3;
 
-	if (dev->board.dont_use_port_3)
-		is_port_3 = false;
 	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER,
 				       PWR_CTL_EN, value, 4);
 	if (status < 0)
@@ -1288,9 +1286,6 @@ int cx231xx_enable_i2c_port_3(struct cx231xx *dev, bool is_port_3)
 	else
 		value[0] &= ~I2C_DEMOD_EN;
 
-	cx231xx_info("Changing the i2c master port to %d\n",
-		     is_port_3 ?  3 : 1);
-
 	status = cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
 					PWR_CTL_EN, value, 4);
 
@@ -2317,9 +2312,6 @@ int cx231xx_set_power_mode(struct cx231xx *dev, enum AV_MODE mode)
 		}
 
 		if (dev->board.tuner_type != TUNER_ABSENT) {
-			/* Enable tuner */
-			cx231xx_enable_i2c_port_3(dev, true);
-
 			/* reset the Tuner */
 			if (dev->board.tuner_gpio)
 				cx231xx_gpio_set(dev, dev->board.tuner_gpio);
@@ -2384,15 +2376,6 @@ int cx231xx_set_power_mode(struct cx231xx *dev, enum AV_MODE mode)
 		}
 
 		if (dev->board.tuner_type != TUNER_ABSENT) {
-			/*
-			 * Enable tuner
-			 *	Hauppauge Exeter seems to need to do something different!
-			 */
-			if (dev->model == CX231XX_BOARD_HAUPPAUGE_EXETER)
-				cx231xx_enable_i2c_port_3(dev, false);
-			else
-				cx231xx_enable_i2c_port_3(dev, true);
-
 			/* reset the Tuner */
 			if (dev->board.tuner_gpio)
 				cx231xx_gpio_set(dev, dev->board.tuner_gpio);
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 791f00c..2f71f08 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -104,8 +104,8 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = 1,
-		.demod_i2c_master = 2,
+		.tuner_i2c_master = I2C_3,
+		.demod_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x02,
 		.norm = V4L2_STD_PAL,
@@ -144,8 +144,8 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = 1,
-		.demod_i2c_master = 2,
+		.tuner_i2c_master = I2C_3,
+		.demod_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x32,
 		.norm = V4L2_STD_NTSC,
@@ -184,8 +184,8 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x1c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = 1,
-		.demod_i2c_master = 2,
+		.tuner_i2c_master = I2C_3,
+		.demod_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x02,
 		.norm = V4L2_STD_PAL,
@@ -225,8 +225,8 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x1c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = 1,
-		.demod_i2c_master = 2,
+		.tuner_i2c_master = I2C_3,
+		.demod_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x02,
 		.norm = V4L2_STD_PAL,
@@ -262,7 +262,6 @@ struct cx231xx_board cx231xx_boards[] = {
 		.norm = V4L2_STD_PAL,
 		.no_alt_vanc = 1,
 		.external_av = 1,
-		.dont_use_port_3 = 1,
 		/* Actually, it has a 417, but it isn't working correctly.
 		 * So set to 0 for now until someone can manage to get this
 		 * to work reliably. */
@@ -297,8 +296,8 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = 1,
-		.demod_i2c_master = 2,
+		.tuner_i2c_master = I2C_3,
+		.demod_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x02,
 		.norm = V4L2_STD_PAL,
@@ -325,8 +324,8 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = 1,
-		.demod_i2c_master = 2,
+		.tuner_i2c_master = I2C_3,
+		.demod_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x32,
 		.norm = V4L2_STD_NTSC,
@@ -353,8 +352,8 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = 1,
-		.demod_i2c_master = 2,
+		.tuner_i2c_master = I2C_1,
+		.demod_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x0e,
 		.norm = V4L2_STD_NTSC,
@@ -390,7 +389,6 @@ struct cx231xx_board cx231xx_boards[] = {
 		.norm = V4L2_STD_NTSC,
 		.no_alt_vanc = 1,
 		.external_av = 1,
-		.dont_use_port_3 = 1,
 		.input = {{
 			.type = CX231XX_VMUX_COMPOSITE1,
 			.vmux = CX231XX_VIN_2_1,
@@ -418,9 +416,9 @@ struct cx231xx_board cx231xx_boards[] = {
 		.tuner_scl_gpio = -1,
 		.tuner_sda_gpio = -1,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = 2,
-		.demod_i2c_master = 1,
-		.ir_i2c_master = 2,
+		.tuner_i2c_master = I2C_2,
+		.demod_i2c_master = I2C_3,
+		.ir_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x10,
 		.norm = V4L2_STD_PAL_M,
@@ -456,9 +454,9 @@ struct cx231xx_board cx231xx_boards[] = {
 		.tuner_scl_gpio = -1,
 		.tuner_sda_gpio = -1,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = 2,
-		.demod_i2c_master = 1,
-		.ir_i2c_master = 2,
+		.tuner_i2c_master = I2C_2,
+		.demod_i2c_master = I2C_3,
+		.ir_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x10,
 		.norm = V4L2_STD_NTSC_M,
@@ -494,9 +492,9 @@ struct cx231xx_board cx231xx_boards[] = {
 		.tuner_scl_gpio = -1,
 		.tuner_sda_gpio = -1,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = 2,
-		.demod_i2c_master = 1,
-		.ir_i2c_master = 2,
+		.tuner_i2c_master = I2C_2,
+		.demod_i2c_master = I2C_3,
+		.ir_i2c_master = I2C_2,
 		.rc_map_name = RC_MAP_PIXELVIEW_002T,
 		.has_dvb = 1,
 		.demod_addr = 0x10,
@@ -532,7 +530,6 @@ struct cx231xx_board cx231xx_boards[] = {
 		.norm = V4L2_STD_NTSC,
 		.no_alt_vanc = 1,
 		.external_av = 1,
-		.dont_use_port_3 = 1,
 
 		.input = {{
 				.type = CX231XX_VMUX_COMPOSITE1,
@@ -587,7 +584,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = 1,
+		.tuner_i2c_master = I2C_3,
 		.norm = V4L2_STD_PAL,
 
 		.input = {{
@@ -622,7 +619,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = 1,
+		.tuner_i2c_master = I2C_3,
 		.norm = V4L2_STD_NTSC,
 
 		.input = {{
@@ -656,7 +653,6 @@ struct cx231xx_board cx231xx_boards[] = {
 		.norm = V4L2_STD_NTSC,
 		.no_alt_vanc = 1,
 		.external_av = 1,
-		.dont_use_port_3 = 1,
 		.input = {{
 			.type = CX231XX_VMUX_COMPOSITE1,
 			.vmux = CX231XX_VIN_2_1,
@@ -683,7 +679,6 @@ struct cx231xx_board cx231xx_boards[] = {
 		.norm = V4L2_STD_NTSC,
 		.no_alt_vanc = 1,
 		.external_av = 1,
-		.dont_use_port_3 = 1,
 		/*.has_417 = 1, */
 		/* This board is believed to have a hardware encoding chip
 		 * supporting mpeg1/2/4, but as the 417 is apparently not
@@ -718,8 +713,8 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = 1,
-		.demod_i2c_master = 2,
+		.tuner_i2c_master = I2C_3,
+		.demod_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x0e,
 		.norm = V4L2_STD_PAL,
@@ -757,8 +752,8 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = 1,
-		.demod_i2c_master = 2,
+		.tuner_i2c_master = I2C_3,
+		.demod_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x0e,
 		.norm = V4L2_STD_PAL,
@@ -991,12 +986,10 @@ static int read_eeprom(struct cx231xx *dev, u8 *eedata, int len)
 	struct i2c_msg msg_write = { .addr = addr, .flags = 0,
 		.buf = &start_offset, .len = 1 };
 	struct i2c_msg msg_read = { .addr = addr, .flags = I2C_M_RD };
-
-	/* mutex_lock(&dev->i2c_lock); */
-	cx231xx_enable_i2c_port_3(dev, false);
+	struct i2c_adapter *i2c_adap = cx231xx_get_i2c_adap(dev, I2C_1);
 
 	/* start reading at offset 0 */
-	ret = i2c_transfer(&dev->i2c_bus[1].i2c_adap, &msg_write, 1);
+	ret = i2c_transfer(i2c_adap, &msg_write, 1);
 	if (ret < 0) {
 		cx231xx_err("Can't read eeprom\n");
 		return ret;
@@ -1006,7 +999,7 @@ static int read_eeprom(struct cx231xx *dev, u8 *eedata, int len)
 		msg_read.len = (len_todo > 64) ? 64 : len_todo;
 		msg_read.buf = eedata_cur;
 
-		ret = i2c_transfer(&dev->i2c_bus[1].i2c_adap, &msg_read, 1);
+		ret = i2c_transfer(i2c_adap, &msg_read, 1);
 		if (ret < 0) {
 			cx231xx_err("Can't read eeprom\n");
 			return ret;
@@ -1015,9 +1008,6 @@ static int read_eeprom(struct cx231xx *dev, u8 *eedata, int len)
 		len_todo -= msg_read.len;
 	}
 
-	cx231xx_enable_i2c_port_3(dev, true);
-	/* mutex_unlock(&dev->i2c_lock); */
-
 	for (i = 0; i + 15 < len; i += 16)
 		cx231xx_info("i2c eeprom %02x: %*ph\n", i, 16, &eedata[i]);
 
@@ -1036,7 +1026,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
 	/* request some modules */
 	if (dev->board.decoder == CX231XX_AVDECODER) {
 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
-					&dev->i2c_bus[0].i2c_adap,
+					cx231xx_get_i2c_adap(dev, I2C_0),
 					"cx25840", 0x88 >> 1, NULL);
 		if (dev->sd_cx25840 == NULL)
 			cx231xx_info("cx25840 subdev registration failure\n");
@@ -1047,7 +1037,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
 	/* Initialize the tuner */
 	if (dev->board.tuner_type != TUNER_ABSENT) {
 		dev->sd_tuner = v4l2_i2c_new_subdev(&dev->v4l2_dev,
-						    &dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
+						    cx231xx_get_i2c_adap(dev, dev->board.tuner_i2c_master),
 						    "tuner",
 						    dev->tuner_addr, NULL);
 		if (dev->sd_tuner == NULL)
@@ -1062,9 +1052,14 @@ void cx231xx_card_setup(struct cx231xx *dev)
 		{
 			struct tveeprom tvee;
 			static u8 eeprom[256];
+			struct i2c_client i2c_client;
+
+			memset(&i2c_client, 0, sizeof(i2c_client));
+			strcpy(i2c_client.name, "cx231xx eeprom reader");
+			i2c_client.adapter = cx231xx_get_i2c_adap(dev, I2C_1);
 
 			read_eeprom(dev, eeprom, sizeof(eeprom));
-			tveeprom_hauppauge_analog(&dev->i2c_bus[1].i2c_client,
+			tveeprom_hauppauge_analog(&i2c_client,
 						&tvee, eeprom + 0xc0);
 			break;
 		}
diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index 180103e..75078e1 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/vmalloc.h>
+#include <linux/i2c-mux.h>
 #include <media/v4l2-common.h>
 #include <media/tuner.h>
 
@@ -1265,6 +1266,15 @@ void cx231xx_start_TS1(struct cx231xx *dev)
 			TS1_CFG_REG, val, 4);
 }
 /* EXPORT_SYMBOL_GPL(cx231xx_start_TS1); */
+
+static int cx231xx_i2c_mux_select(struct i2c_adapter *adap,
+			void *mux_dev, u32 chan_id)
+{
+	struct cx231xx *dev = mux_dev;
+
+	return cx231xx_enable_i2c_port_3(dev, chan_id);
+}
+
 /*****************************************************************
 *             Device Init/UnInit functions                       *
 ******************************************************************/
@@ -1300,6 +1310,21 @@ int cx231xx_dev_init(struct cx231xx *dev)
 	cx231xx_i2c_register(&dev->i2c_bus[1]);
 	cx231xx_i2c_register(&dev->i2c_bus[2]);
 
+	dev->i2c_mux_adap_1 = i2c_add_mux_adapter(&dev->i2c_bus[1].i2c_adap,
+				&dev->i2c_bus[1].i2c_client.dev,
+				dev, 0,
+				0 /* chan_id */,
+				0 /* class */,
+				&cx231xx_i2c_mux_select,
+				NULL);
+	dev->i2c_mux_adap_3 = i2c_add_mux_adapter(&dev->i2c_bus[1].i2c_adap,
+				&dev->i2c_bus[1].i2c_client.dev,
+				dev, 0,
+				1 /* chan_id */,
+				0 /* class */,
+				&cx231xx_i2c_mux_select,
+				NULL);
+
 	/* init hardware */
 	/* Note : with out calling set power mode function,
 	afe can not be set up correctly */
@@ -1404,9 +1429,7 @@ int cx231xx_dev_init(struct cx231xx *dev)
 	if (dev->board.has_dvb)
 		cx231xx_set_alt_setting(dev, INDEX_TS1, 0);
 
-	/* set the I2C master port to 3 on channel 1 */
-	errCode = cx231xx_enable_i2c_port_3(dev, true);
-
+	errCode = 0;
 	return errCode;
 }
 EXPORT_SYMBOL_GPL(cx231xx_dev_init);
@@ -1414,6 +1437,11 @@ EXPORT_SYMBOL_GPL(cx231xx_dev_init);
 void cx231xx_dev_uninit(struct cx231xx *dev)
 {
 	/* Un Initialize I2C bus */
+	i2c_del_mux_adapter(dev->i2c_mux_adap_3);
+	dev->i2c_mux_adap_3 = NULL;
+	i2c_del_mux_adapter(dev->i2c_mux_adap_1);
+	dev->i2c_mux_adap_1 = NULL;
+
 	cx231xx_i2c_unregister(&dev->i2c_bus[2]);
 	cx231xx_i2c_unregister(&dev->i2c_bus[1]);
 	cx231xx_i2c_unregister(&dev->i2c_bus[0]);
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 6c7b5e2..c692a5b 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -266,11 +266,7 @@ static int start_streaming(struct cx231xx_dvb *dvb)
 
 	if (dev->USE_ISO) {
 		cx231xx_info("DVB transfer mode is ISO.\n");
-		mutex_lock(&dev->i2c_lock);
-		cx231xx_enable_i2c_port_3(dev, false);
 		cx231xx_set_alt_setting(dev, INDEX_TS1, 4);
-		cx231xx_enable_i2c_port_3(dev, true);
-		mutex_unlock(&dev->i2c_lock);
 		rc = cx231xx_set_mode(dev, CX231XX_DIGITAL_MODE);
 		if (rc < 0)
 			return rc;
@@ -378,7 +374,7 @@ static int attach_xc5000(u8 addr, struct cx231xx *dev)
 	struct xc5000_config cfg;
 
 	memset(&cfg, 0, sizeof(cfg));
-	cfg.i2c_adap = &dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap;
+	cfg.i2c_adap = cx231xx_get_i2c_adap(dev, dev->board.tuner_i2c_master);
 	cfg.i2c_addr = addr;
 
 	if (!dev->dvb->frontend) {
@@ -609,7 +605,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		dev->dvb->frontend = dvb_attach(s5h1432_attach,
 					&dvico_s5h1432_config,
-					&dev->i2c_bus[dev->board.demod_i2c_master].i2c_adap);
+					cx231xx_get_i2c_adap(dev, dev->board.demod_i2c_master));
 
 		if (dev->dvb->frontend == NULL) {
 			printk(DRIVER_NAME
@@ -622,7 +618,7 @@ static int dvb_init(struct cx231xx *dev)
 		dvb->frontend->callback = cx231xx_tuner_callback;
 
 		if (!dvb_attach(xc5000_attach, dev->dvb->frontend,
-			       &dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
+			       cx231xx_get_i2c_adap(dev, dev->board.tuner_i2c_master),
 			       &cnxt_rde250_tunerconfig)) {
 			result = -EINVAL;
 			goto out_free;
@@ -634,7 +630,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		dev->dvb->frontend = dvb_attach(s5h1411_attach,
 					       &xc5000_s5h1411_config,
-					       &dev->i2c_bus[dev->board.demod_i2c_master].i2c_adap);
+					       cx231xx_get_i2c_adap(dev, dev->board.demod_i2c_master));
 
 		if (dev->dvb->frontend == NULL) {
 			printk(DRIVER_NAME
@@ -647,7 +643,7 @@ static int dvb_init(struct cx231xx *dev)
 		dvb->frontend->callback = cx231xx_tuner_callback;
 
 		if (!dvb_attach(xc5000_attach, dev->dvb->frontend,
-			       &dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
+			       cx231xx_get_i2c_adap(dev, dev->board.tuner_i2c_master),
 			       &cnxt_rdu250_tunerconfig)) {
 			result = -EINVAL;
 			goto out_free;
@@ -657,7 +653,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		dev->dvb->frontend = dvb_attach(s5h1432_attach,
 					&dvico_s5h1432_config,
-					&dev->i2c_bus[dev->board.demod_i2c_master].i2c_adap);
+					cx231xx_get_i2c_adap(dev, dev->board.demod_i2c_master));
 
 		if (dev->dvb->frontend == NULL) {
 			printk(DRIVER_NAME
@@ -670,7 +666,7 @@ static int dvb_init(struct cx231xx *dev)
 		dvb->frontend->callback = cx231xx_tuner_callback;
 
 		if (!dvb_attach(tda18271_attach, dev->dvb->frontend,
-			       0x60, &dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
+			       0x60, cx231xx_get_i2c_adap(dev, dev->board.tuner_i2c_master),
 			       &cnxt_rde253s_tunerconfig)) {
 			result = -EINVAL;
 			goto out_free;
@@ -681,7 +677,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		dev->dvb->frontend = dvb_attach(s5h1411_attach,
 					       &tda18271_s5h1411_config,
-					       &dev->i2c_bus[dev->board.demod_i2c_master].i2c_adap);
+					       cx231xx_get_i2c_adap(dev, dev->board.demod_i2c_master));
 
 		if (dev->dvb->frontend == NULL) {
 			printk(DRIVER_NAME
@@ -694,7 +690,7 @@ static int dvb_init(struct cx231xx *dev)
 		dvb->frontend->callback = cx231xx_tuner_callback;
 
 		if (!dvb_attach(tda18271_attach, dev->dvb->frontend,
-			       0x60, &dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
+			       0x60, cx231xx_get_i2c_adap(dev, dev->board.tuner_i2c_master),
 			       &cnxt_rde253s_tunerconfig)) {
 			result = -EINVAL;
 			goto out_free;
@@ -703,11 +699,11 @@ static int dvb_init(struct cx231xx *dev)
 	case CX231XX_BOARD_HAUPPAUGE_EXETER:
 
 		printk(KERN_INFO "%s: looking for tuner / demod on i2c bus: %d\n",
-		       __func__, i2c_adapter_id(&dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap));
+		       __func__, i2c_adapter_id(cx231xx_get_i2c_adap(dev, dev->board.tuner_i2c_master)));
 
 		dev->dvb->frontend = dvb_attach(lgdt3305_attach,
 						&hcw_lgdt3305_config,
-						&dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap);
+						cx231xx_get_i2c_adap(dev, dev->board.tuner_i2c_master));
 
 		if (dev->dvb->frontend == NULL) {
 			printk(DRIVER_NAME
@@ -720,7 +716,7 @@ static int dvb_init(struct cx231xx *dev)
 		dvb->frontend->callback = cx231xx_tuner_callback;
 
 		dvb_attach(tda18271_attach, dev->dvb->frontend,
-			   0x60, &dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
+			   0x60, cx231xx_get_i2c_adap(dev, dev->board.tuner_i2c_master),
 			   &hcw_tda18271_config);
 		break;
 
@@ -728,7 +724,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		dev->dvb->frontend = dvb_attach(si2165_attach,
 			&hauppauge_930C_HD_1113xx_si2165_config,
-			&dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap
+			cx231xx_get_i2c_adap(dev, dev->board.tuner_i2c_master)
 			);
 
 		if (dev->dvb->frontend == NULL) {
@@ -745,7 +741,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		dvb_attach(tda18271_attach, dev->dvb->frontend,
 			0x60,
-			&dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
+			cx231xx_get_i2c_adap(dev, dev->board.tuner_i2c_master),
 			&hcw_tda18271_config);
 
 		dev->cx231xx_reset_analog_tuner = NULL;
@@ -761,7 +757,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		dev->dvb->frontend = dvb_attach(si2165_attach,
 			&pctv_quatro_stick_1114xx_si2165_config,
-			&dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap
+			cx231xx_get_i2c_adap(dev, dev->board.tuner_i2c_master)
 			);
 
 		if (dev->dvb->frontend == NULL) {
@@ -786,7 +782,7 @@ static int dvb_init(struct cx231xx *dev)
 		request_module("si2157");
 
 		client = i2c_new_device(
-			&dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
+			cx231xx_get_i2c_adap(dev, dev->board.tuner_i2c_master),
 			&info);
 		if (client == NULL || client->dev.driver == NULL) {
 			dvb_frontend_detach(dev->dvb->frontend);
@@ -811,11 +807,11 @@ static int dvb_init(struct cx231xx *dev)
 	case CX231XX_BOARD_KWORLD_UB430_USB_HYBRID:
 
 		printk(KERN_INFO "%s: looking for demod on i2c bus: %d\n",
-		       __func__, i2c_adapter_id(&dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap));
+		       __func__, i2c_adapter_id(cx231xx_get_i2c_adap(dev, dev->board.tuner_i2c_master)));
 
 		dev->dvb->frontend = dvb_attach(mb86a20s_attach,
 						&pv_mb86a20s_config,
-						&dev->i2c_bus[dev->board.demod_i2c_master].i2c_adap);
+						cx231xx_get_i2c_adap(dev, dev->board.demod_i2c_master));
 
 		if (dev->dvb->frontend == NULL) {
 			printk(DRIVER_NAME
@@ -828,7 +824,7 @@ static int dvb_init(struct cx231xx *dev)
 		dvb->frontend->callback = cx231xx_tuner_callback;
 
 		dvb_attach(tda18271_attach, dev->dvb->frontend,
-			   0x60, &dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
+			   0x60, cx231xx_get_i2c_adap(dev, dev->board.tuner_i2c_master),
 			   &pv_tda18271_config);
 		break;
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index 7c0f797..c8b0dbe 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -539,3 +539,20 @@ int cx231xx_i2c_unregister(struct cx231xx_i2c *bus)
 	i2c_del_adapter(&bus->i2c_adap);
 	return 0;
 }
+
+struct i2c_adapter *cx231xx_get_i2c_adap(struct cx231xx *dev, int i2c_port)
+{
+	switch (i2c_port) {
+	case I2C_0:
+		return &dev->i2c_bus[0].i2c_adap;
+	case I2C_1:
+		return dev->i2c_mux_adap_1;
+	case I2C_2:
+		return &dev->i2c_bus[2].i2c_adap;
+	case I2C_3:
+		return dev->i2c_mux_adap_3;
+	default:
+		return NULL;
+	}
+}
+EXPORT_SYMBOL_GPL(cx231xx_get_i2c_adap);
diff --git a/drivers/media/usb/cx231xx/cx231xx-input.c b/drivers/media/usb/cx231xx/cx231xx-input.c
index 05f0434..a42f7d5 100644
--- a/drivers/media/usb/cx231xx/cx231xx-input.c
+++ b/drivers/media/usb/cx231xx/cx231xx-input.c
@@ -100,7 +100,7 @@ int cx231xx_ir_init(struct cx231xx *dev)
 	ir_i2c_bus = cx231xx_boards[dev->model].ir_i2c_master;
 	dev_dbg(&dev->udev->dev, "Trying to bind ir at bus %d, addr 0x%02x\n",
 		ir_i2c_bus, info.addr);
-	dev->ir_i2c_client = i2c_new_device(&dev->i2c_bus[ir_i2c_bus].i2c_adap, &info);
+	dev->ir_i2c_client = i2c_new_device(cx231xx_get_i2c_adap(dev, ir_i2c_bus), &info);
 
 	return 0;
 }
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index aeb1bf4..0acecce 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -367,7 +367,6 @@ struct cx231xx_board {
 	unsigned int valid:1;
 	unsigned int no_alt_vanc:1;
 	unsigned int external_av:1;
-	unsigned int dont_use_port_3:1;
 
 	unsigned char xclk, i2c_speed;
 
@@ -628,6 +627,9 @@ struct cx231xx {
 
 	/* I2C adapters: Master 1 & 2 (External) & Master 3 (Internal only) */
 	struct cx231xx_i2c i2c_bus[3];
+	struct i2c_adapter *i2c_mux_adap_1;
+	struct i2c_adapter *i2c_mux_adap_3;
+
 	unsigned int xc_fw_load_done:1;
 	/* locks */
 	struct mutex gpio_i2c_lock;
@@ -754,6 +756,7 @@ int cx231xx_reset_analog_tuner(struct cx231xx *dev);
 void cx231xx_do_i2c_scan(struct cx231xx *dev, struct i2c_client *c);
 int cx231xx_i2c_register(struct cx231xx_i2c *bus);
 int cx231xx_i2c_unregister(struct cx231xx_i2c *bus);
+struct i2c_adapter *cx231xx_get_i2c_adap(struct cx231xx *dev, int i2c_port);
 
 /* Internal block control functions */
 int cx231xx_read_i2c_master(struct cx231xx *dev, u8 dev_addr, u16 saddr,
-- 
2.1.1

