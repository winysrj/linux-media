Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39623 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab2LCSP5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2012 13:15:57 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so1219242bkw.19
        for <linux-media@vger.kernel.org>; Mon, 03 Dec 2012 10:15:56 -0800 (PST)
Message-ID: <50BCEC60.4040206@googlemail.com>
Date: Mon, 03 Dec 2012 19:16:00 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Matthew Gyurgyik <matthew@pyther.net>,
	Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50B67851.2010808@googlemail.com> <50B69037.3080205@pyther.net> <50B6967C.9070801@iki.fi> <50B6C2DF.4020509@pyther.net> <50B6C530.4010701@iki.fi> <50B7B768.5070008@googlemail.com> <50B80FBB.5030208@pyther.net> <50BB3F2C.5080107@googlemail.com> <50BB6451.7080601@iki.fi> <50BB8D72.8050803@googlemail.com>
In-Reply-To: <50BB8D72.8050803@googlemail.com>
Content-Type: multipart/mixed;
 boundary="------------020502060209070308060300"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020502060209070308060300
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Am 02.12.2012 18:18, schrieb Frank Schäfer:
> Am 02.12.2012 15:23, schrieb Antti Palosaari:
>> On 12/02/2012 01:44 PM, Frank Schäfer wrote:
>>> Am 30.11.2012 02:45, schrieb Matthew Gyurgyik:
>>>> On 11/29/2012 02:28 PM, Frank Schäfer wrote:
>>>>> Matthew, stay tuned but be patient. ;) Regards, Frank
>>>> Sure thing, just let me know what you need me to do!
>>>>
>>> Ok, please test the attached experimental patch and post the dmesg
>>> output.
>>>
>>> Open questions:
>>> - setting of EM2874 register 0x0f (XCLK): the Windows doesn't touch this
>>> register, so the default value seems to be used.
>>>    The patch adds 2 debugging lines to find out the default which
>>> default
>>> value the em2874 uses.
>>>    For now, I've set this to 12MHz, because the picture shows a 12MHz
>>> oszillator.
>>> - meaning of the gpio sequence / gpio lines assignment (see comments in
>>> the patch).
>>> - remote control support: looking at the product picture on the MSI
>>> website,
>>>    the remote control could be the same as sues by the Digivox III. But
>>> that's just a guess.
>>> - LGDT3305 configuration: a few parameters can not be taken form the USB
>>> log. Will ask the author of the driver for help.
>>>
>>> But let's do things step by step and see what happens with the patch.
>>>
>>> Regards,
>>> Frank
>>>
>> Hello
>> I looked the patch quickly and here are the findings:
>> I2C addresses are in "8-bit" format. Will not work. Example for tuner,
>> 0xc0 should be 0x60. Same for the demod. Due to that, no worth to test
>> patch. I2C addresses are normally 7-bit, but "unofficial" 8-bit
>> notation is also used widely. em28xx uses official notation as almost
>> all other media drivers.
> Argh, yeah, I didn't check that. The mixed usage of 7 and 8 bit
> notations is a mess.
>
>> You are using tda18271c2dd tuner driver. I recommended to change to
>> the other driver named tda18271. tda18271c2dd is very bad choice in
>> that case as it discards all the I2C error without any error logging
>> and just silently ignores. I remember case when I used that tuner
>> driver for one em28xx + drx-k combination and wasted very many hours
>> trying to get it working due to missing error logging :/
> Ok, thanks. So we have two drivers for the same chip and tda18271c2dd is
> deprecated ? Can both drivers handle both chip models ?
> I thought tda18271c2dd is for the c2 model of the chip and tda18271 for
> the "normal" model...
> I also wonder why tda18271 is in media/tuners while tda18271c2dd is in
> media/dvb-frontends ?
>
>> Don't care XCLK register, it most likely will just as it is. There is
>> many EM2874 boards already supported.
>>
>> 12MHz clock is correct and it is seen from the hardware. Generally
>> 12MHz xtal is used very often for USB (device to device) as it is
>> suitable reference clock.
> Likely. But XCLK register also controls a few other things (e.g. remote
> control settings) and the em28xx driver overwrites the default register
> content in any case.
> So let's see what dmesg tells us.
>
>> According to comments, GPIO7 is used when streaming is started /
>> stopped. It is about 99% sure LOCK LED :)
>>
>> When you look sniffs and see some GPIO is changed for example just
>> before and after tuner communication you could make assumption it does
>> have something to do with tuner (example tuner hw reset / standby).
> That's possible, but on the other hand, there is a delay of 20ms after
> GPIO_7. That shouldn't be necessary for a LED.
> Any idea what GPIO_0 is ? it is to set to high (50ms delay afterwards)
> when the first chunk of data is read from the eeprom and set back to low
> afterwards.
>
>> You should look used intermediate frequencies from the tuner driver
>> and configure demod according to that. OK, 3-4 MHz sounds very
>> reasonable low-IF values used with tda18271. tda18271 driver supports
>> also get IF callback, but demod driver not. That callback allows
>> automatically configure correct IF according to what tuner uses.
>> Anyhow, in that case you must ensure those manually from tuner driver
>> as demod driver does not support get IF. IF is *critical*, if it is
>> wrong then nothing works (because demodulator does not get signal from
>> tuner).
> Ok, that means the 'qam_if_khz' and 'vsb_if_khz' in struct
> lgdt3305_config are mandatory values and must be set manually.
> Looking into the tda18271 driver, vsb_if_khz should be set to 3250.
> That's what the other em28xx board uses, too.
>
> I will send an updated version of the patch soon. Thanks for your comments.

Here is v2 of the patch (attached).

Antti, could you please take a look at the std_map for the tuner ?
I'm not sure what the correct and complete map is.

For a first test, I've selected the same std_map as used with the KWorld
A340 (LGDT3304 + TDA18271 C1/C2):

static struct tda18271_std_map kworld_a340_std_map = {
    .atsc_6   = { .if_freq = 3250, .agc_mode = 3, .std = 0,
              .if_lvl = 1, .rfagc_top = 0x37, },
    .qam_6    = { .if_freq = 4000, .agc_mode = 3, .std = 1,
              .if_lvl = 1, .rfagc_top = 0x37, },
};


These are the relevant tda18271 register values the taken from Matthews
USB-log:

EP3 (0x05): 0x1d
EP4 (0x06): 0x60
EB22 (0x25): 0x37

The LGDT3305 is configured for QAM and IF=4000kHz, which leads to a
tda18271_std_map_item with

{
 .if_freq = 4000,
 .agc_mode = 3,
 .std = 5,
 .fm_rfn = 0,
 .if_lvl = 0,
 .rfagc_top = 0x37,
 }

According to the datasheet and tda18271-maps.c, this should be qam_6,
qam_7 or qam_8.

Do we need further USB-logs from the Windows driver ?
And if yes, do you have any advice for Matthew how to create them ?

Regards,
Frank


> Regards,
> Frank
>
>> regards
>> Antti
>>


--------------020502060209070308060300
Content-Type: text/x-patch;
 name="0001-Experimental-patch-for-the-MSI-DIGIVOX-ATSC-V2.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename*0="0001-Experimental-patch-for-the-MSI-DIGIVOX-ATSC-V2.patch"

>From f685b93b20544afd700943aa7622d59da18fba1b Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Date: Mon, 3 Dec 2012 18:28:50 +0100
Subject: [PATCH] Experimental patch for the 'MSI DIGIVOX ATSC' V2

---
 drivers/media/usb/em28xx/em28xx-cards.c |   37 ++++++++++++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx-dvb.c   |   38 +++++++++++++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx.h       |    1 +
 3 Dateien geÃ¤ndert, 76 Zeilen hinzugefÃ¼gt(+)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 619bffb..c626aac 100644
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
@@ -2963,6 +2993,13 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 	dev->em28xx_read_reg_req = em28xx_read_reg_req;
 	dev->board.is_em2800 = em28xx_boards[dev->model].is_em2800;
 
+int regval = em28xx_read_reg(dev, 0x0b);
+pr_err("EM28XX DEBUG: reg 0x0B (UNKNOWN): 0x%02x\n", regval);
+regval = em28xx_read_reg(dev, 0x0d);
+pr_err("EM28XX DEBUG: reg 0x0D (UNKNOWN): 0x%02x\n", regval);
+regval = em28xx_read_reg(dev, EM28XX_R0F_XCLK);
+pr_err("EM28XX DEBUG: reg 0x0F (EM28XX_R0F_XCLK): 0x%02x\n", regval);
+
 	em28xx_set_model(dev);
 
 	/* Set the default GPO/GPIO for legacy devices */
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 63f2e70..8e00a30 100644
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
+	.tpclk_edge         = LGDT3305_TPCLK_RISING_EDGE,
+	.tpvalid_polarity   = LGDT3305_TP_VALID_HIGH,
+	.vsb_if_khz         = 3250,		/* not confirmed with a USB log */
+	.qam_if_khz         = 4000,
+};
+
 static struct s921_config sharp_isdbt = {
 	.demod_address = 0x30 >> 1
 };
@@ -713,6 +725,14 @@ static struct tda18271_config em28xx_cxd2820r_tda18271_config = {
 	.gate = TDA18271_GATE_DIGITAL,
 };
 
+static struct tda18271_config em28xx_lgdt3305_tda18271_config = {
+	.std_map = &kworld_a340_std_map,		/* TODO / EXPERIMENTAL */
+	.gate = TDA18271_GATE_DIGITAL,
+	.output_opt = TDA18271_OUTPUT_LT_OFF,
+/*	.rf_cal_on_startup = 1,		*/	/* needed ??? */
+/*	.delay_cal = 1,			*/	/* needed ??? */
+};
+
 static const struct tda10071_config em28xx_tda10071_config = {
 	.i2c_address = 0x55, /* (0xaa >> 1) */
 	.i2c_wr_max = 64,
@@ -1235,6 +1255,24 @@ static int em28xx_dvb_init(struct em28xx *dev)
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



--------------020502060209070308060300--
