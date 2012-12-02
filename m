Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34960 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab2LBLoj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Dec 2012 06:44:39 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so1083195eek.19
        for <linux-media@vger.kernel.org>; Sun, 02 Dec 2012 03:44:38 -0800 (PST)
Message-ID: <50BB3F2C.5080107@googlemail.com>
Date: Sun, 02 Dec 2012 12:44:44 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Matthew Gyurgyik <matthew@pyther.net>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50B67851.2010808@googlemail.com> <50B69037.3080205@pyther.net> <50B6967C.9070801@iki.fi> <50B6C2DF.4020509@pyther.net> <50B6C530.4010701@iki.fi> <50B7B768.5070008@googlemail.com> <50B80FBB.5030208@pyther.net>
In-Reply-To: <50B80FBB.5030208@pyther.net>
Content-Type: multipart/mixed;
 boundary="------------090903000705050306050007"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090903000705050306050007
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Am 30.11.2012 02:45, schrieb Matthew Gyurgyik:
> On 11/29/2012 02:28 PM, Frank Sch�fer wrote:
>> Matthew, stay tuned but be patient. ;) Regards, Frank
>
> Sure thing, just let me know what you need me to do!
>

Ok, please test the attached experimental patch and post the dmesg output.

Open questions:
- setting of EM2874 register 0x0f (XCLK): the Windows doesn't touch this
register, so the default value seems to be used.
  The patch adds 2 debugging lines to find out the default which default
value the em2874 uses.
  For now, I've set this to 12MHz, because the picture shows a 12MHz
oszillator.
- meaning of the gpio sequence / gpio lines assignment (see comments in
the patch).
- remote control support: looking at the product picture on the MSI website,
  the remote control could be the same as sues by the Digivox III. But
that's just a guess.
- LGDT3305 configuration: a few parameters can not be taken form the USB
log. Will ask the author of the driver for help.

But let's do things step by step and see what happens with the patch.

Regards,
Frank

--------------090903000705050306050007
Content-Type: text/x-patch;
 name="0001-Experimental-patch-for-the-MSI-DIGIVOX-ATSC-V1.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename*0="0001-Experimental-patch-for-the-MSI-DIGIVOX-ATSC-V1.patch"

>From 77012eb1462912f3ddc38b609bc826b37e55bf1d Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Date: Sun, 2 Dec 2012 11:19:20 +0100
Subject: [PATCH] Experimental patch for the 'MSI DIGIVOX ATSC' V1

---
 drivers/media/usb/em28xx/em28xx-cards.c |   33 +++++++++++++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx-dvb.c   |   30 ++++++++++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx.h       |    1 +
 3 Dateien geändert, 64 Zeilen hinzugefügt(+)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 619bffb..aea04d7 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -393,6 +393,21 @@ static struct em28xx_reg_seq pctv_520e[] = {
 	{             -1,   -1,   -1,  -1},
 };
 
+/* 0db0:8810 MSI DIGIVOX ATSC (HU345-Q)
+ * GPIO_0 - ??? (related to eeprom reading ?)
+ * GPIO_6 - ??? (TDA18271C2 or/and LGDT3305 reset ?)
+ * GPIO_7 - ??? (wakeup or stream enable ?)
+ */
+static struct em28xx_reg_seq msi_digivox_atsc[] = {
+	{EM2874_R80_GPIO, 0xff, 0xff,  50}, /* GPIO_0=1 */
+	{0x0d,            0xff, 0xff,   0},
+	{EM2874_R80_GPIO, 0xfe, 0xff,   0}, /* GPIO_0=0 */
+	{EM2874_R80_GPIO, 0xbe, 0xff, 135}, /* GPIO_6=0 */
+	{EM2874_R80_GPIO, 0xfe, 0xff, 135}, /* GPIO_6=1 */
+	{EM2874_R80_GPIO, 0x7e, 0xff,  20}, /* GPIO_7=0 */
+	{             -1,   -1,   -1,  -1},
+};
+
 /*
  *  Board definitions
  */
@@ -1988,6 +2003,19 @@ struct em28xx_board em28xx_boards[] = {
 				EM28XX_I2C_CLK_WAIT_ENABLE |
 				EM28XX_I2C_FREQ_400_KHZ,
 	},
+	/* 0db0:8810 MSI DIGIVOX ATSC (HU345-Q)
+	 * Empia EM2874B + TDA18271HDC2 + LGDT3305 */
+	[EM2874_BOARD_MSI_DIGIVOX_ATSC] = {
+		.name         = "MSI DIGIVOX ATSC",
+		.dvb_gpio     = msi_digivox_atsc,
+		.has_dvb      = 1,
+		.tuner_type   = TUNER_ABSENT,
+		.ir_codes     = RC_MAP_MSI_DIGIVOX_III,		/* just a guess from looking at the picture */
+		.xclk         = EM28XX_XCLK_FREQUENCY_12MHZ,	/* TODO */
+		.i2c_speed    = EM2874_I2C_SECONDARY_BUS_SELECT |
+				EM28XX_I2C_CLK_WAIT_ENABLE |
+				EM28XX_I2C_FREQ_100_KHZ,
+	},
 };
 const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);
 
@@ -2145,6 +2173,8 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM2884_BOARD_PCTV_510E },
 	{ USB_DEVICE(0x2013, 0x0251),
 			.driver_info = EM2884_BOARD_PCTV_520E },
+	{ USB_DEVICE(0x0db0, 0x8810),
+			.driver_info = EM2874_BOARD_MSI_DIGIVOX_ATSC },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, em28xx_id_table);
@@ -2963,6 +2993,9 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 	dev->em28xx_read_reg_req = em28xx_read_reg_req;
 	dev->board.is_em2800 = em28xx_boards[dev->model].is_em2800;
 
+int regval = em28xx_read_reg(dev, EM28XX_R0F_XCLK);
+pr_err("EM28XX DEBUG: default value of reg 0x0F (EM28XX_R0F_XCLK): 0x%02x\n", regval);
+
 	em28xx_set_model(dev);
 
 	/* Set the default GPO/GPIO for legacy devices */
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 63f2e70..240740b 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -263,6 +263,19 @@ static struct lgdt3305_config em2870_lgdt3304_dev = {
 	.qam_if_khz         = 4000,
 };
 
+static struct lgdt3305_config em2874_lgdt3305_dev = {
+	.i2c_addr           = 0x1c,
+	.demod_chip         = LGDT3305,
+/*	.deny_i2c_rptr      = 1,			*/	/* should we deny access to i2c gate ctrl ??? */
+	.spectral_inversion = 1,
+	.rf_agc_loop        = 0,
+	.mpeg_mode          = LGDT3305_MPEG_SERIAL,
+	.tpclk_edge         = LGDT3305_TPCLK_RISING_EDGE,
+	.tpvalid_polarity   = LGDT3305_TP_VALID_HIGH,
+/*	.vsb_if_khz         = 3250,			*/	/* nothing in the log, needed ? */
+/*	.qam_if_khz         = 4000,			*/	/* confirmed, needed ? */
+};
+
 static struct s921_config sharp_isdbt = {
 	.demod_address = 0x30 >> 1
 };
@@ -1235,6 +1248,23 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			goto out_free;
 		}
 		break;
+	case EM2874_BOARD_MSI_DIGIVOX_ATSC:
+		dvb->fe[0] = dvb_attach(lgdt3305_attach,
+					   &em2874_lgdt3305_dev,
+					   &dev->i2c_adap);
+		if (dvb->fe[0]) {
+			/* FE 0 attach tuner */
+			if (!dvb_attach(tda18271c2dd_attach,
+					dvb->fe[0],
+					&dev->i2c_adap,
+					0xc0)) {
+
+				dvb_frontend_detach(dvb->fe[0]);
+				result = -EINVAL;
+				goto out_free;
+			}
+		}
+		break;
 	default:
 		em28xx_errdev("/2: The frontend of your DVB/ATSC card"
 				" isn't supported yet\n");
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 86e90d8..3102ff3 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -129,6 +129,7 @@
 #define EM2884_BOARD_PCTV_510E                    85
 #define EM2884_BOARD_PCTV_520E                    86
 #define EM2884_BOARD_TERRATEC_HTC_USB_XS	  87
+#define EM2874_BOARD_MSI_DIGIVOX_ATSC		  88
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
-- 
1.7.10.4


--------------090903000705050306050007--
