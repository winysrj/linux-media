Return-path: <linux-media-owner@vger.kernel.org>
Received: from joe.mail.tiscali.it ([213.205.33.54]:34500 "EHLO
	joe.mail.tiscali.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab0BIUyv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2010 15:54:51 -0500
Message-ID: <4B71CB52.4080109@gmail.com>
Date: Tue, 09 Feb 2010 21:53:38 +0100
From: "Andrea.Amorosi76@gmail.com" <Andrea.Amorosi76@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] em28xx: add Dikom DK300 hybrid USB tuner
References: <4AFE92ED.2060208@gmail.com> <4AFEAB15.9010509@gmail.com> <829197380911140634j49c05cd0s90aed57b9ae61436@mail.gmail.com> <4B71ACC8.600@gmail.com> <4B71B5BD.8090006@infradead.org>
In-Reply-To: <4B71B5BD.8090006@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab ha scritto:
> Andrea.Amorosi76@gmail.com wrote:
>> This patch add the Dikom DK300 hybrid usb card.
>>
>> The patch adds digital and analogue tv support.
>>
>> Not working: remote controller
> 
>> diff -r d6520e486ee6 linux/drivers/media/video/em28xx/em28xx-cards.c
>> --- a/linux/drivers/media/video/em28xx/em28xx-cards.c    Sat Jan 30
>> 01:27:34 2010 -0200
>> +++ b/linux/drivers/media/video/em28xx/em28xx-cards.c    Sat Jan 30
>> 18:04:13 2010 +0100
> 
> Your patch got mangled by Thunderbird. You should or use Asalted Patches
> plugin:
>         https://hg.mozilla.org/users/clarkbw_gnome.org/asalted-patches/
> 
> or use another emailer. Without the above plugin, long lines are broken,
> damaging your patch.
> 
> Cheers,
> Mauro
> 
Is it ok now?
Andrea

This patch add the Dikom DK300 hybrid usb card.

The patch adds digital and analogue tv support.

Not working: remote controller

To be done: it seems that with the proposed patch the digital
demodulator remains activated if the tuner is switched from digital to
analogue mode.
Workaorund is to unplug and replug the device when switching from
digital to analogue.
If someone can explain how to verify the gpio settings using the
usbsnoop, the above issue perhaps can be resolved.

Signed-off-by: Andrea Amorosi <Andrea.Amorosi76@gmail.com>

diff -r d6520e486ee6 linux/drivers/media/video/em28xx/em28xx-cards.c
--- a/linux/drivers/media/video/em28xx/em28xx-cards.c	Sat Jan 30 01:27:34 2010 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx-cards.c	Sat Jan 30 18:04:13 2010 +0100
@@ -245,6 +245,12 @@
  	{	-1,		-1,	-1,		-1},
  };

+static struct em28xx_reg_seq dikom_dk300_digital[] = {
+	{EM28XX_R08_GPIO,	0x6e,	~EM_GPIO_4,	10},
+	{EM2880_R04_GPO,	0x08,	0xff,		10},
+	{ -1,			-1,	-1,		-1},
+};
+

  /*
   *  Board definitions
@@ -1673,6 +1679,22 @@
  		.tuner_gpio    = reddo_dvb_c_usb_box,
  		.has_dvb       = 1,
  	},
+	[EM2882_BOARD_DIKOM_DK300] = {
+		.name         = "Dikom DK300",
+		.valid        = EM28XX_BOARD_NOT_VALIDATED,
+		.tuner_type   = TUNER_XC2028,
+		.tuner_gpio   = default_tuner_gpio,
+		.decoder      = EM28XX_TVP5150,
+		.mts_firmware = 1,
+		.has_dvb      = 1,
+		.dvb_gpio     = dikom_dk300_digital,
+		.input        = { {
+			.type     = EM28XX_VMUX_TELEVISION,
+			.vmux     = TVP5150_COMPOSITE0,
+			.amux     = EM28XX_AMUX_VIDEO,
+			.gpio     = default_analog,
+		} },
+	},
  };
  const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);

@@ -1812,6 +1834,7 @@
  	{0xcee44a99, EM2882_BOARD_EVGA_INDTUBE, TUNER_XC2028},
  	{0xb8846b20, EM2881_BOARD_PINNACLE_HYBRID_PRO, TUNER_XC2028},
  	{0x63f653bd, EM2870_BOARD_REDDO_DVB_C_USB_BOX, TUNER_ABSENT},
+	{0x4e913442, EM2882_BOARD_DIKOM_DK300, TUNER_XC2028},
  };

  /* I2C devicelist hash table for devices with generic USB IDs */
@@ -2168,6 +2191,7 @@
  		ctl->demod = XC3028_FE_DEFAULT;
  		break;
  	case EM2883_BOARD_KWORLD_HYBRID_330U:
+	case EM2882_BOARD_DIKOM_DK300:
  		ctl->demod = XC3028_FE_CHINA;
  		ctl->fname = XC2028_DEFAULT_FIRMWARE;
  		break;
@@ -2480,6 +2504,31 @@
  		em28xx_gpio_set(dev, dev->board.tuner_gpio);
  		em28xx_set_mode(dev, EM28XX_ANALOG_MODE);
  		break;
+
+/*
+		 * The Dikom DK300 is detected as an Kworld VS-DVB-T 323UR.
+		 *
+		 * This occurs because they share identical USB vendor and
+		 * product IDs.
+		 *
+		 * What we do here is look up the EEPROM hash of the Dikom
+		 * and if it is found then we decide that we do not have
+		 * a Kworld and reset the device to the Dikom instead.
+		 *
+		 * This solution is only valid if they do not share eeprom
+		 * hash identities which has not been determined as yet.
+		 */
+	case EM2882_BOARD_KWORLD_VS_DVBT:
+		if (!em28xx_hint_board(dev))
+			em28xx_set_model(dev);
+
+		/* In cases where we had to use a board hint, the call to
+		   em28xx_set_mode() in em28xx_pre_card_setup() was a no-op,
+		   so make the call now so the analog GPIOs are set properly
+		   before probing the i2c bus. */
+		em28xx_gpio_set(dev, dev->board.tuner_gpio);
+		em28xx_set_mode(dev, EM28XX_ANALOG_MODE);
+		break;
  	}

  #if defined(CONFIG_MODULES) && defined(MODULE)
diff -r d6520e486ee6 linux/drivers/media/video/em28xx/em28xx-dvb.c
--- a/linux/drivers/media/video/em28xx/em28xx-dvb.c	Sat Jan 30 01:27:34 2010 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx-dvb.c	Sat Jan 30 18:04:13 2010 +0100
@@ -504,6 +504,7 @@
  		break;
  	case EM2880_BOARD_TERRATEC_HYBRID_XS:
  	case EM2881_BOARD_PINNACLE_HYBRID_PRO:
+	case EM2882_BOARD_DIKOM_DK300:
  		dvb->frontend = dvb_attach(zl10353_attach,
  					   &em28xx_zl10353_xc3028_no_i2c_gate,
  					   &dev->i2c_adap);
diff -r d6520e486ee6 linux/drivers/media/video/em28xx/em28xx.h
--- a/linux/drivers/media/video/em28xx/em28xx.h	Sat Jan 30 01:27:34 2010 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx.h	Sat Jan 30 18:04:13 2010 +0100
@@ -112,6 +112,7 @@
  #define EM2861_BOARD_GADMEI_UTV330PLUS           72
  #define EM2870_BOARD_REDDO_DVB_C_USB_BOX          73
  #define EM2800_BOARD_VC211A			  74
+#define EM2882_BOARD_DIKOM_DK300		75

  /* Limits minimum and default number of buffers */
  #define EM28XX_MIN_BUF 4

