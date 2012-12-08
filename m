Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:36634 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab2LHPUl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2012 10:20:41 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so545656eaa.19
        for <linux-media@vger.kernel.org>; Sat, 08 Dec 2012 07:20:40 -0800 (PST)
Message-ID: <50C35AD1.3040000@googlemail.com>
Date: Sat, 08 Dec 2012 16:20:49 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Matthew Gyurgyik <matthew@pyther.net>
CC: Antti Palosaari <crope@iki.fi>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50B67851.2010808@googlemail.com> <50B69037.3080205@pyther.net> <50B6967C.9070801@iki.fi> <50B6C2DF.4020509@pyther.net> <50B6C530.4010701@iki.fi> <50B7B768.5070008@googlemail.com> <50B80FBB.5030208@pyther.net> <50BB3F2C.5080107@googlemail.com> <50BB6451.7080601@iki.fi> <50BB8D72.8050803@googlemail.com> <50BCEC60.4040206@googlemail.com> <50BD5CC3.1030100@pyther.net> <CAGoCfiyNrHS9TpmOk8FKhzzViNCxazKqAOmG0S+DMRr3AQ8Gbg@mail.gmail.com> <50BD6310.8000808@pyther.net> <CAGoCfiwr88F3TW9Q_Pk7B_jTf=N9=Zn6rcERSJ4tV75sKyyRMw@mail.gmail.com> <50BE65F0.8020303@googlemail.com> <50BEC253.4080006@pyther.net> <50BF3F9A.3020803@iki.fi> <50BFBE39.90901@pyther.net> <50BFC445.6020305@iki.fi> <50BFCBBB.5090407@pyther.net> <50BFECEA.9060808@iki.fi> <50BFFFF6.1000204@pyther.net> <50C11301.10205@googlemail.com> <50C12302.80603@pyther.net> <50C34628.5030407@googlemail.com> <50C34A50.6000207@pyther.net>
In-Reply-To: <50C34A50.6000207@pyther.net>
Content-Type: multipart/mixed;
 boundary="------------040307010701020402010403"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040307010701020402010403
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Am 08.12.2012 15:10, schrieb Matthew Gyurgyik:
> On 12/08/2012 08:52 AM, Frank Sch�fer wrote:
>>> I lied, it works! I must have forgotten to do run make modules_install
>>> or something! This patch accurately states my current code changes:
>>> http://pyther.net/a/digivox_atsc/diff-Dec-06-v1.patch
>> Great, that's a big one step forward.
>>
>> Based on this (your) patch, could you please verify that ist was really
>> the adding of
>>
>>      {0x0d,            0x42, 0xff,   0},
>>
>> to struct em28xx_reg_seq msi_digivox_atsc ? The tests before this change
>> were all made with a wrong combination of configuration values for the
>> LGDT3305...
> I have commented that line out and from some basic testing, it doesn't
> appear to change anything. I can still tune and watch a channel, scan
> still fails.

Ok, thanks. So the USB log was right and the bridge setup should be
complete, except that the remote control doesn't work yet...

Could you please test the patch in the attachment ?
Changes from V3:
- use the correct demodulator configuration
- changed the remote control map to RC_MAP_KWORLD_315U (same as DIGIVOX
III but without NEC extended address byte)
- switched from the KWorld std_map for the tuner to a custom one. For
QAM, I selected the values from the log and for atsc I took the standard
values from the tda18271 driver.

Regards,
Frank

>
> Thanks,
> Matthew


--------------040307010701020402010403
Content-Type: text/x-patch;
 name="0001-Experimental-patch-for-the-MSI-DIGIVOX-ATSC-V4.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename*0="0001-Experimental-patch-for-the-MSI-DIGIVOX-ATSC-V4.patch"

>From bbd130b18bedc2801f6c5a359779b1ad31654924 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Date: Sat, 8 Dec 2012 16:19:01 +0100
Subject: [PATCH] Experimental patch for the 'MSI DIGIVOX ATSC' V4

---
 drivers/media/usb/em28xx/em28xx-cards.c |   30 ++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx-dvb.c   |   47 +++++++++++++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx.h       |    1 +
 3 Dateien geändert, 78 Zeilen hinzugefügt(+)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 619bffb..8ec1e42 100644
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
+		.ir_codes     = RC_MAP_KWORLD_315U,		/* just a guess from looking at the picture */
+		.xclk         = EM28XX_XCLK_FREQUENCY_12MHZ,
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
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 63f2e70..603b344 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -263,6 +263,18 @@ static struct lgdt3305_config em2870_lgdt3304_dev = {
 	.qam_if_khz         = 4000,
 };
 
+static struct lgdt3305_config em2874_lgdt3305_dev = {
+	.i2c_addr           = 0x0e,
+	.demod_chip         = LGDT3305,
+	.spectral_inversion = 1,
+	.rf_agc_loop        = 0,
+	.mpeg_mode          = LGDT3305_MPEG_SERIAL,
+	.tpclk_edge         = LGDT3305_TPCLK_FALLING_EDGE,
+	.tpvalid_polarity   = LGDT3305_TP_VALID_HIGH,
+	.vsb_if_khz         = 3250,		/* not confirmed with a USB log */
+	.qam_if_khz         = 4000,
+};
+
 static struct s921_config sharp_isdbt = {
 	.demod_address = 0x30 >> 1
 };
@@ -290,6 +302,15 @@ static struct tda18271_std_map kworld_a340_std_map = {
 		      .if_lvl = 1, .rfagc_top = 0x37, },
 };
 
+static struct tda18271_std_map msi_digivox_atsc_std_map = {
+	/* TODO => taken from struct tda18271_std_map tda18271c2_std_map in tda18271-maps.c */
+	.atsc_6   = { .if_freq = 3250, .agc_mode = 3, .std = 4,
+		      .if_lvl = 1, .rfagc_top = 0x37, }, /* EP3[4:0] 0x1c */
+	/* TODO => values from the USB log, is this qam_6 ? */
+	.qam_6    = { .if_freq = 4000, .agc_mode = 3, .std = 5,
+		      .if_lvl = 0, .rfagc_top = 0x37, },
+};
+
 static struct tda18271_config kworld_a340_config = {
 	.std_map           = &kworld_a340_std_map,
 };
@@ -713,6 +734,14 @@ static struct tda18271_config em28xx_cxd2820r_tda18271_config = {
 	.gate = TDA18271_GATE_DIGITAL,
 };
 
+static struct tda18271_config em28xx_lgdt3305_tda18271_config = {
+	.std_map = &msi_digivox_atsc_std_map,		/* TODO / EXPERIMENTAL */
+	.gate = TDA18271_GATE_DIGITAL,
+	.output_opt = TDA18271_OUTPUT_LT_OFF,
+/*	.rf_cal_on_startup = 1,		*/	/* needed ??? */
+/*	.delay_cal = 1,			*/	/* needed ??? */
+};
+
 static const struct tda10071_config em28xx_tda10071_config = {
 	.i2c_address = 0x55, /* (0xaa >> 1) */
 	.i2c_wr_max = 64,
@@ -1235,6 +1264,24 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			goto out_free;
 		}
 		break;
+	case EM2874_BOARD_MSI_DIGIVOX_ATSC:
+		dvb->fe[0] = dvb_attach(lgdt3305_attach,
+					   &em2874_lgdt3305_dev,
+					   &dev->i2c_adap);
+		if (dvb->fe[0]) {
+			/* FE 0 attach tuner */
+			if (!dvb_attach(tda18271_attach,
+					dvb->fe[0],
+					0x60,
+					&dev->i2c_adap,
+					&em28xx_lgdt3305_tda18271_config)) {
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


--------------040307010701020402010403--
