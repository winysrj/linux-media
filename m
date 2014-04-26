Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:56245 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbaDZUVr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Apr 2014 16:21:47 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: zzam@gentoo.org, crope@iki.fi, xpert-reactos@gmx.de
Subject: [PATCH 2/3] cx231xx: Add [2040:b130] Hauppauge WinTV 930C-hd 1113xx
Date: Sat, 26 Apr 2014 22:21:19 +0200
Message-Id: <1398543680-21374-2-git-send-email-zzam@gentoo.org>
In-Reply-To: <1398543680-21374-1-git-send-email-zzam@gentoo.org>
References: <1398543680-21374-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reading eeprom works
Analog is untested

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/usb/cx231xx/Kconfig          |  1 +
 drivers/media/usb/cx231xx/cx231xx-avcore.c |  1 +
 drivers/media/usb/cx231xx/cx231xx-cards.c  | 92 ++++++++++++++++++++++++++++++
 drivers/media/usb/cx231xx/cx231xx-core.c   |  3 +
 drivers/media/usb/cx231xx/cx231xx-dvb.c    | 34 +++++++++++
 drivers/media/usb/cx231xx/cx231xx.h        |  1 +
 6 files changed, 132 insertions(+)

diff --git a/drivers/media/usb/cx231xx/Kconfig b/drivers/media/usb/cx231xx/Kconfig
index f14c5e8..036454e 100644
--- a/drivers/media/usb/cx231xx/Kconfig
+++ b/drivers/media/usb/cx231xx/Kconfig
@@ -47,6 +47,7 @@ config VIDEO_CX231XX_DVB
 	select DVB_MB86A20S if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_LGDT3305 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_TDA18271C2DD if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_SI2165 if MEDIA_SUBDRV_AUTOSELECT
 
 	---help---
 	  This adds support for DVB cards based on the
diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
index 89de00b..a428c10 100644
--- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
@@ -352,6 +352,7 @@ int cx231xx_afe_update_power_control(struct cx231xx *dev,
 	case CX231XX_BOARD_CNXT_RDU_253S:
 	case CX231XX_BOARD_CNXT_VIDEO_GRABBER:
 	case CX231XX_BOARD_HAUPPAUGE_EXETER:
+	case CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx:
 	case CX231XX_BOARD_HAUPPAUGE_USBLIVE2:
 	case CX231XX_BOARD_PV_PLAYTV_USB_HYBRID:
 	case CX231XX_BOARD_HAUPPAUGE_USB2_FM_PAL:
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 2ee03e4..ba4c4cb 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -704,6 +704,45 @@ struct cx231xx_board cx231xx_boards[] = {
 			}
 		},
 	},
+	[CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx] = {
+		.name = "Hauppauge WinTV 930C-HD (1113xx)",
+		.tuner_type = TUNER_NXP_TDA18271,
+		.tuner_addr = 0x60,
+		.tuner_gpio = RDE250_XCV_TUNER,
+		.tuner_sif_gpio = 0x05,
+		.tuner_scl_gpio = 0x1a,
+		.tuner_sda_gpio = 0x1b,
+		.decoder = CX231XX_AVDECODER,
+		.output_mode = OUT_MODE_VIP11,
+		.demod_xfer_mode = 0,
+		.ctl_pin_status_mask = 0xFFFFFFC4,
+		.agc_analog_digital_select_gpio = 0x0c,
+		.gpio_pin_status_mask = 0x4001000,
+		.tuner_i2c_master = 1,
+		.demod_i2c_master = 2,
+		.has_dvb = 1,
+		.demod_addr = 0x0e,
+		.norm = V4L2_STD_PAL,
+
+		.input = {{
+			.type = CX231XX_VMUX_TELEVISION,
+			.vmux = CX231XX_VIN_3_1,
+			.amux = CX231XX_AMUX_VIDEO,
+			.gpio = NULL,
+		}, {
+			.type = CX231XX_VMUX_COMPOSITE1,
+			.vmux = CX231XX_VIN_2_1,
+			.amux = CX231XX_AMUX_LINE_IN,
+			.gpio = NULL,
+		}, {
+			.type = CX231XX_VMUX_SVIDEO,
+			.vmux = CX231XX_VIN_1_1 |
+				(CX231XX_VIN_1_2 << 8) |
+				CX25840_SVIDEO_ON,
+			.amux = CX231XX_AMUX_LINE_IN,
+			.gpio = NULL,
+		} },
+	},
 };
 const unsigned int cx231xx_bcount = ARRAY_SIZE(cx231xx_boards);
 
@@ -733,6 +772,8 @@ struct usb_device_id cx231xx_id_table[] = {
 	 .driver_info = CX231XX_BOARD_HAUPPAUGE_USB2_FM_NTSC},
 	{USB_DEVICE(0x2040, 0xb120),
 	 .driver_info = CX231XX_BOARD_HAUPPAUGE_EXETER},
+	{USB_DEVICE(0x2040, 0xb130),
+	 .driver_info = CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx},
 	{USB_DEVICE(0x2040, 0xb140),
 	 .driver_info = CX231XX_BOARD_HAUPPAUGE_EXETER},
 	{USB_DEVICE(0x2040, 0xc200),
@@ -886,6 +927,48 @@ static void cx231xx_config_tuner(struct cx231xx *dev)
 
 }
 
+static int read_eeprom(struct cx231xx *dev, u8 *eedata, int len)
+{
+	int ret = 0;
+	u8 addr = 0xa0 >> 1;
+	u8 start_offset = 0;
+	int len_todo = len;
+	u8 *eedata_cur = eedata;
+	int i;
+	struct i2c_msg msg_write = { .addr = addr, .flags = 0,
+		.buf = &start_offset, .len = 1 };
+	struct i2c_msg msg_read = { .addr = addr, .flags = I2C_M_RD };
+
+	/* mutex_lock(&dev->i2c_lock); */
+	cx231xx_enable_i2c_port_3(dev, false);
+
+	/* start reading at offset 0 */
+	ret = i2c_transfer(&dev->i2c_bus[1].i2c_adap, &msg_write, 1);
+
+	while (len_todo > 0) {
+		msg_read.len = (len_todo > 64) ? 64 : len_todo;
+		msg_read.buf = eedata_cur;
+
+		ret = i2c_transfer(&dev->i2c_bus[1].i2c_adap, &msg_read, 1);
+
+		eedata_cur += msg_read.len;
+		len_todo -= msg_read.len;
+	}
+
+	cx231xx_enable_i2c_port_3(dev, true);
+	/* mutex_unlock(&dev->i2c_lock); */
+
+	for (i = 0; i < len; i++) {
+		if (0 == (i % 16))
+			printk(KERN_INFO "%s: i2c eeprom %02x:", dev->name, i);
+		printk(KERN_CONT " %02x", eedata[i]);
+		if (15 == (i % 16))
+			printk(KERN_CONT "\n");
+	}
+
+	return 0;
+}
+
 void cx231xx_card_setup(struct cx231xx *dev)
 {
 
@@ -917,6 +1000,15 @@ void cx231xx_card_setup(struct cx231xx *dev)
 		else
 			cx231xx_config_tuner(dev);
 	}
+
+	if (dev->model == CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx) {
+		struct tveeprom tvee;
+		static u8 eeprom[256];
+		read_eeprom(dev, eeprom, sizeof(eeprom));
+		tveeprom_hauppauge_analog(&dev->i2c_bus[1].i2c_client,
+					  &tvee, eeprom + 0xc0);
+	}
+
 }
 
 /*
diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index 4ba3ce0..513194a 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -726,6 +726,7 @@ int cx231xx_set_mode(struct cx231xx *dev, enum cx231xx_mode set_mode)
 			errCode = cx231xx_set_agc_analog_digital_mux_select(dev, 1);
 			break;
 		case CX231XX_BOARD_HAUPPAUGE_EXETER:
+		case CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx:
 			errCode = cx231xx_set_power_mode(dev,
 						POLARIS_AVMODE_DIGITAL);
 			break;
@@ -744,6 +745,7 @@ int cx231xx_set_mode(struct cx231xx *dev, enum cx231xx_mode set_mode)
 		case CX231XX_BOARD_CNXT_RDE_253S:
 		case CX231XX_BOARD_CNXT_RDU_253S:
 		case CX231XX_BOARD_HAUPPAUGE_EXETER:
+		case CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx:
 		case CX231XX_BOARD_PV_PLAYTV_USB_HYBRID:
 		case CX231XX_BOARD_HAUPPAUGE_USB2_FM_PAL:
 		case CX231XX_BOARD_HAUPPAUGE_USB2_FM_NTSC:
@@ -1379,6 +1381,7 @@ int cx231xx_dev_init(struct cx231xx *dev)
 	case CX231XX_BOARD_CNXT_RDE_253S:
 	case CX231XX_BOARD_CNXT_RDU_253S:
 	case CX231XX_BOARD_HAUPPAUGE_EXETER:
+	case CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx:
 	case CX231XX_BOARD_PV_PLAYTV_USB_HYBRID:
 	case CX231XX_BOARD_HAUPPAUGE_USB2_FM_PAL:
 	case CX231XX_BOARD_HAUPPAUGE_USB2_FM_NTSC:
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 4504bc6..d367796 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -32,6 +32,7 @@
 #include "tda18271.h"
 #include "s5h1411.h"
 #include "lgdt3305.h"
+#include "si2165.h"
 #include "mb86a20s.h"
 
 MODULE_DESCRIPTION("driver for cx231xx based DVB cards");
@@ -151,6 +152,12 @@ static struct tda18271_config pv_tda18271_config = {
 	.small_i2c = TDA18271_03_BYTE_CHUNK_INIT,
 };
 
+static const struct si2165_config hauppauge_930C_HD_1113xx_si2165_config = {
+	.i2c_addr	= 0x64,
+	.chip_mode	= SI2165_MODE_PLL_XTAL,
+	.ref_freq_MHz	= 16,
+};
+
 static inline void print_err_status(struct cx231xx *dev, int packet, int status)
 {
 	char *errmsg = "Unknown";
@@ -704,6 +711,33 @@ static int dvb_init(struct cx231xx *dev)
 			   &hcw_tda18271_config);
 		break;
 
+	case CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx:
+
+		printk(KERN_INFO "%s: looking for tuner / demod on i2c bus: %d\n",
+		       __func__, i2c_adapter_id(&dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap));
+
+		dev->dvb->frontend = dvb_attach(si2165_attach,
+			&hauppauge_930C_HD_1113xx_si2165_config,
+			&dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap
+			);
+
+		if (dev->dvb->frontend == NULL) {
+			printk(DRIVER_NAME
+			       ": Failed to attach SI2165 front end\n");
+			result = -EINVAL;
+			goto out_free;
+		}
+
+		dev->dvb->frontend->ops.i2c_gate_ctrl = 0;
+
+		/* define general-purpose callback pointer */
+		dvb->frontend->callback = cx231xx_tuner_callback;
+
+		dvb_attach(tda18271_attach, dev->dvb->frontend,
+			   0x60, &dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
+			   &hcw_tda18271_config);
+		break;
+
 	case CX231XX_BOARD_PV_PLAYTV_USB_HYBRID:
 	case CX231XX_BOARD_KWORLD_UB430_USB_HYBRID:
 
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index babca7f..a6373ba 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -73,6 +73,7 @@
 #define CX231XX_BOARD_ELGATO_VIDEO_CAPTURE_V2 16
 #define CX231XX_BOARD_OTG102 17
 #define CX231XX_BOARD_KWORLD_UB445_USB_HYBRID 18
+#define CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx 19
 
 /* Limits minimum and default number of buffers */
 #define CX231XX_MIN_BUF                 4
-- 
1.9.0

