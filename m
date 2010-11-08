Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:56832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022Ab0KHP7M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Nov 2010 10:59:12 -0500
Message-ID: <4CD81E4C.8000106@redhat.com>
Date: Mon, 08 Nov 2010 13:59:08 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?M=E1rcio_Ara=FAjo_Alves?= <froooozen@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [RFC PATCH] cx231xx: Add support for Kworld UB430 AF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This device seems to be close to Pixelview design. Probably, the remote controller
is different.

Also, AGC selection doesn't seem to use any GPIO writing, at least from the logs
I got from Márcio.

Reported by: Márcio Araújo Alves <froooozen@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

---

PS.: This patch is to be applied against staging/for_v2.6.38 branch at the main tree:
	http://git.linuxtv.org/media_tree.git?a=shortlog;h=refs/heads/staging/for_v2.6.38

Márcio,

Could you please test it? It would be wonderful if you could test the new IR support. You
should uncomment the code bellow (commented with #if 0), and, eventually, you'll need to
play with RC keymaps.

I'd appreciate if you could send me some parsed logs for both analog and digital
modes. I've improved the cx231xx-specific parser at v4l-apps, in order to catch GPIO
changes. So far, I didn't get any trial to change GPIO bits on your logs (nor on my logs with 
Pixelview).

When I have more time, I'll try to do more tests on it.

 drivers/media/dvb/dvb-usb/dvb-usb-ids.h     |    1 
 drivers/media/video/cx231xx/cx231xx-cards.c |   48 ++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

--- patchwork.orig/drivers/media/video/cx231xx/cx231xx-cards.c
+++ patchwork/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -435,6 +435,52 @@ struct cx231xx_board cx231xx_boards[] = 
 			.gpio = 0,
 		} },
 	},
+	[CX231XX_BOARD_KWORLD_U430_AF] = {
+		.name = "Kworld UB430-AF",
+		.tuner_type = TUNER_NXP_TDA18271,
+		.tuner_addr = 0x60,
+		.decoder = CX231XX_AVDECODER,
+		.output_mode = OUT_MODE_VIP11,
+		.demod_xfer_mode = 0,
+		.ctl_pin_status_mask = 0xFFFFFFC4,
+		.agc_analog_digital_select_gpio = 0xffff,
+		.tuner_sif_gpio = -1,
+		.tuner_scl_gpio = -1,
+		.tuner_sda_gpio = -1,
+		.gpio_pin_status_mask = 0x4001000,
+		.tuner_i2c_master = 2,
+		.demod_i2c_master = 1,
+#if 0
+		/*
+		 * FIXME: it is very likely that this device uses an I2C
+		 * remote controller. Not sure if it will use the same
+		 * i2c addr as Pixelview, or what's the keycode map.
+		 */
+		.ir_i2c_master = 2,
+		.rc_map = RC_MAP_KWORLD_315U,
+#endif
+		.has_dvb = 1,
+		.demod_addr = 0x10,
+		.norm = V4L2_STD_PAL_M,
+		.input = {{
+			.type = CX231XX_VMUX_TELEVISION,
+			.vmux = CX231XX_VIN_3_1,
+			.amux = CX231XX_AMUX_VIDEO,
+			.gpio = 0,
+		}, {
+			.type = CX231XX_VMUX_COMPOSITE1,
+			.vmux = CX231XX_VIN_2_1,
+			.amux = CX231XX_AMUX_LINE_IN,
+			.gpio = 0,
+		}, {
+			.type = CX231XX_VMUX_SVIDEO,
+			.vmux = CX231XX_VIN_1_1 |
+				(CX231XX_VIN_1_2 << 8) |
+				CX25840_SVIDEO_ON,
+			.amux = CX231XX_AMUX_LINE_IN,
+			.gpio = 0,
+		} },
+	},
 };
 const unsigned int cx231xx_bcount = ARRAY_SIZE(cx231xx_boards);
 
@@ -464,6 +510,8 @@ struct usb_device_id cx231xx_id_table[] 
 	 .driver_info = CX231XX_BOARD_HAUPPAUGE_USBLIVE2},
 	{USB_DEVICE_VER(USB_VID_PIXELVIEW, USB_PID_PIXELVIEW_SBTVD, 0x4000, 0x4001),
 	 .driver_info = CX231XX_BOARD_PV_PLAYTV_USB_HYBRID},
+	{USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_UB430_AF),
+	 .driver_info = CX231XX_BOARD_KWORLD_U430_AF},
 	{},
 };
 
--- patchwork.orig/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ patchwork/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -130,6 +130,7 @@
 #define USB_PID_KWORLD_PC160_2T				0xc160
 #define USB_PID_KWORLD_PC160_T				0xc161
 #define USB_PID_KWORLD_UB383_T				0xe383
+#define USB_PID_KWORLD_UB430_AF				0xe424
 #define USB_PID_KWORLD_VSTREAM_COLD			0x17de
 #define USB_PID_KWORLD_VSTREAM_WARM			0x17df
 #define USB_PID_TERRATEC_CINERGY_T_USB_XE		0x0055
