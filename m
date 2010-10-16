Return-path: <mchehab@pedra>
Received: from smtp20.orange.fr ([193.252.22.31]:7601 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429Ab0JPRmZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Oct 2010 13:42:25 -0400
Message-ID: <4CB9E3E9.2020106@orange.fr>
Date: Sat, 16 Oct 2010 19:42:01 +0200
From: Catimimi <catimimi@orange.fr>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Catimimi <catimimi@libertysurf.fr>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Terratec Cinergy Hybrid T USB XS FR
References: <4CAA2BE6.1050302@libertysurf.fr> <4CB9103E.6020104@redhat.com>
In-Reply-To: <4CB9103E.6020104@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------070506050903020805000103"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------070506050903020805000103
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit

Le 16/10/2010 04:38, Mauro Carvalho Chehab a écrit :
> Em 04-10-2010 16:32, Catimimi escreveu:
>   
>>  New gpio definitions.
>> XC3028_FE_ZARLINK456 was not loaded.
>>
>> Signed-off-by: Michel Garnier<catimimi@libertysurf.fr>
>>
>> ---
>>
>> diff -Nru v4l-dvb-1da5fed5c8b2-orig/linux/drivers/media/video/em28xx/em28xx-cards.c v4l-dvb-1da5fed5c8b2-new/linux/drivers/media/video/em28xx/em28xx-cards.c
>> --- v4l-dvb-1da5fed5c8b2-orig/linux/drivers/media/video/em28xx/em28xx-cards.c    2010-09-19 07:23:09.000000000 +0200
>> +++ v4l-dvb-1da5fed5c8b2-new/linux/drivers/media/video/em28xx/em28xx-cards.c    2010-10-04 19:05:11.000000000 +0200
>> @@ -200,6 +200,18 @@
>>      {    -1,        -1,    -1,        -1},
>>  };
>>
>> +static struct em28xx_reg_seq terratec_cinergy_USB_XS_analog[] = {
>> +    {EM28XX_R08_GPIO,    0x6d,    ~EM_GPIO_4,    10},
>> +    {EM2880_R04_GPO,    0x00,    0xff,        10},
>> +    { -1,            -1,    -1,        -1},
>> +};
>> +
>> +static struct em28xx_reg_seq terratec_cinergy_USB_XS_digital[] = {
>> +    {EM28XX_R08_GPIO,    0x6e,    ~EM_GPIO_4,    10},
>> +    {EM2880_R04_GPO,    0x08,    0xff,        10},
>> +    { -1,            -1,    -1,        -1},
>> +};
>> +
>>  /* eb1a:2868 Reddo DVB-C USB TV Box
>>     GPIO4 - CU1216L NIM
>>     Other GPIOs seems to be don't care. */
>> @@ -824,22 +836,22 @@
>>          .tuner_gpio   = default_tuner_gpio,
>>          .decoder      = EM28XX_TVP5150,
>>          .has_dvb      = 1,
>> -        .dvb_gpio     = default_digital,
>> +        .dvb_gpio     = terratec_cinergy_USB_XS_digital,
>>          .input        = { {
>>              .type     = EM28XX_VMUX_TELEVISION,
>>              .vmux     = TVP5150_COMPOSITE0,
>>              .amux     = EM28XX_AMUX_VIDEO,
>> -            .gpio     = default_analog,
>> +            .gpio     = terratec_cinergy_USB_XS_analog,
>>          }, {
>>              .type     = EM28XX_VMUX_COMPOSITE1,
>>              .vmux     = TVP5150_COMPOSITE1,
>>              .amux     = EM28XX_AMUX_LINE_IN,
>> -            .gpio     = default_analog,
>> +            .gpio     = terratec_cinergy_USB_XS_analog,
>>          }, {
>>              .type     = EM28XX_VMUX_SVIDEO,
>>              .vmux     = TVP5150_SVIDEO,
>>              .amux     = EM28XX_AMUX_LINE_IN,
>> -            .gpio     = default_analog,
>> +            .gpio     = terratec_cinergy_USB_XS_analog,
>>          } },
>>      },
>>      [EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900] = {
>> @@ -2259,6 +2271,7 @@
>>          ctl->demod = XC3028_FE_ZARLINK456;
>>          break;
>>      case EM2880_BOARD_TERRATEC_HYBRID_XS:
>> +    case EM2880_BOARD_TERRATEC_HYBRID_XS_FR:
>>     
> Hmm... do you have a different device, right? Please, don't change the entries
> of the original Hybrid XS, or it will cause a regression for the others. Instead,
> create another entry describing your board.
>
> Also, please use tabs for indent. A tab in Linux have 8 spaces, and not four.
>
>   
>>      case EM2881_BOARD_PINNACLE_HYBRID_PRO:
>>          ctl->demod = XC3028_FE_ZARLINK456;
>>          break;
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>     
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> ,
>   
Hello

I didn't change the entries of original Hybrid XS. I created new entries
which I use for XS_FR.
These new entries were necessaries for a good working with 64 bits kernels.
So there is no regression.

In order to be clear I renamed the new entries to XS_FR.

OK for the tabs, the mail agents converted them to spaces, so I include
a file.

My last proposal is :

New gpio definitions
XC3028_FE_ZARLINK456 was not loaded.

Signed-off-by: Michel Garnier<catimimi@libertysurfhel

Regards
Michel.







--------------070506050903020805000103
Content-Type: text/x-patch;
 name="Terratec_cynergy_hybrid_usb_xs_fr2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Terratec_cynergy_hybrid_usb_xs_fr2.patch"

diff -ru v4l-dvb-1da5fed5c8b2-old/linux/drivers/media/video/em28xx/em28xx-cards.c v4l-dvb-1da5fed5c8b2-new/linux/drivers/media/video/em28xx/em28xx-cards.c
--- v4l-dvb-1da5fed5c8b2-old/linux/drivers/media/video/em28xx/em28xx-cards.c	2010-03-04 06:49:46.000000000 +0100
+++ v4l-dvb-1da5fed5c8b2-new/linux/drivers/media/video/em28xx/em28xx-cards.c	2010-03-05 21:16:36.000000000 +0100
@@ -200,6 +200,18 @@
 	{	-1,		-1,	-1,		-1},
 };
 
+static struct em28xx_reg_seq terratec_cinergy_USB_XS_FR_analog[] = {
+	{EM28XX_R08_GPIO,	0x6d,	~EM_GPIO_4,	10},
+	{EM2880_R04_GPO,	0x00,	0xff,		10},
+	{ -1,			-1,	-1,		-1},
+};
+
+static struct em28xx_reg_seq terratec_cinergy_USB_XS_FR_digital[] = {
+	{EM28XX_R08_GPIO,	0x6e,	~EM_GPIO_4,	10},
+	{EM2880_R04_GPO,	0x08,	0xff,		10},
+	{ -1,			-1,	-1,		-1},
+};
+
 /* eb1a:2868 Reddo DVB-C USB TV Box
    GPIO4 - CU1216L NIM
    Other GPIOs seems to be don't care. */
@@ -824,22 +836,22 @@
 		.tuner_gpio   = default_tuner_gpio,
 		.decoder      = EM28XX_TVP5150,
 		.has_dvb      = 1,
-		.dvb_gpio     = default_digital,
+		.dvb_gpio     = terratec_cinergy_USB_XS_FR_digital,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
 			.vmux     = TVP5150_COMPOSITE0,
 			.amux     = EM28XX_AMUX_VIDEO,
-			.gpio     = default_analog,
+			.gpio     = terratec_cinergy_USB_XS_FR_analog,
 		}, {
 			.type     = EM28XX_VMUX_COMPOSITE1,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
-			.gpio     = default_analog,
+			.gpio     = terratec_cinergy_USB_XS_FR_analog,
 		}, {
 			.type     = EM28XX_VMUX_SVIDEO,
 			.vmux     = TVP5150_SVIDEO,
 			.amux     = EM28XX_AMUX_LINE_IN,
-			.gpio     = default_analog,
+			.gpio     = terratec_cinergy_USB_XS_FR_analog,
 		} },
 	},
 	[EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900] = {
@@ -2259,6 +2271,7 @@
 		ctl->demod = XC3028_FE_ZARLINK456;
 		break;
 	case EM2880_BOARD_TERRATEC_HYBRID_XS:
+	case EM2880_BOARD_TERRATEC_HYBRID_XS_FR:
 	case EM2881_BOARD_PINNACLE_HYBRID_PRO:
 		ctl->demod = XC3028_FE_ZARLINK456;
 		break;

--------------070506050903020805000103--


