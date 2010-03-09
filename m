Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870Ab0CINPr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Mar 2010 08:15:47 -0500
Message-ID: <4B9649FC.8030002@redhat.com>
Date: Tue, 09 Mar 2010 10:15:40 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Catimimi <catimimi@orange.fr>
CC: linux-media@vger.kernel.org
Subject: Re: [patch] em28xx : Terratec Cinergy Hybrid T USB XS FR is now really
 working.
References: <4B8E1770.4000006@orange.fr>
In-Reply-To: <4B8E1770.4000006@orange.fr>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michel,

Catimimi wrote:
> Hi,
> 
> As I told you earlier, my previous patch was not working with a 64 bits
> kernel.
> So forget it.
> 
> 
> I now succed in running Cinergy Hybrid T USB XS FR with 32 and 64bits
> kernels.
> One problem remains, because of msp3400 driver, I don't have sound in
> analog mode.
> I'am still working on that problem.

First of all, as your previous patch got applied already at -git, you should
be sending us a diff patch against it (as the one enclosed), and not a complete
patch.

Also, please always send us patches with your Signed-off-by line as stated at kernel
Documentation/SubmittingPatches file.

With respect to msp3400, one of the things you may need to do is to change the i2s
speed, as msp3400 support two different speeds. If you use it with a wrong speed, you
won't listen the audio. 

There are two valid values: 1024000 and 2048000. The default is 1024000.

So, if your board uses 2048000 speed on i2s, you'll need to add this:

        case EM2880_BOARD_TERRATEC_HYBRID_XS_FR:
		dev->i2s_speed = 2048000;

to em28xx_pre_card_setup().

If the GPIO's for analog are ok, this should be enough to have audio working on it.

-- 

Cheers,
Mauro

---
 drivers/media/video/em28xx/em28xx-cards.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- work.orig/drivers/media/video/em28xx/em28xx-cards.c
+++ work/drivers/media/video/em28xx/em28xx-cards.c
@@ -170,6 +170,18 @@ static struct em28xx_reg_seq pinnacle_hy
 	{	-1,		-1,	-1,		-1},
 };
 
+static struct em28xx_reg_seq terratec_cinergy_USB_XS_analog[] = {
+	{EM28XX_R08_GPIO,	0x6d,	~EM_GPIO_4,	10},
+	{EM2880_R04_GPO,	0x00,	0xff,		10},
+	{ -1,			-1,	-1,		-1},
+};
+
+static struct em28xx_reg_seq terratec_cinergy_USB_XS_digital[] = {
+	{EM28XX_R08_GPIO,	0x6e,	~EM_GPIO_4,	10},
+	{EM2880_R04_GPO,	0x08,	0xff,		10},
+	{ -1,			-1,	-1,		-1},
+};
+
 /* eb1a:2868 Reddo DVB-C USB TV Box
    GPIO4 - CU1216L NIM
    Other GPIOs seems to be don't care. */
@@ -750,22 +762,22 @@ struct em28xx_board em28xx_boards[] = {
 		.tuner_gpio   = default_tuner_gpio,
 		.decoder      = EM28XX_TVP5150,
 		.has_dvb      = 1,
-		.dvb_gpio     = default_digital,
+		.dvb_gpio     = terratec_cinergy_USB_XS_digital,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
 			.vmux     = TVP5150_COMPOSITE0,
 			.amux     = EM28XX_AMUX_VIDEO,
-			.gpio     = default_analog,
+			.gpio     = terratec_cinergy_USB_XS_analog,
 		}, {
 			.type     = EM28XX_VMUX_COMPOSITE1,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
-			.gpio     = default_analog,
+			.gpio     = terratec_cinergy_USB_XS_analog,
 		}, {
 			.type     = EM28XX_VMUX_SVIDEO,
 			.vmux     = TVP5150_SVIDEO,
 			.amux     = EM28XX_AMUX_LINE_IN,
-			.gpio     = default_analog,
+			.gpio     = terratec_cinergy_USB_XS_analog,
 		} },
 	},
 	[EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900] = {
@@ -2118,6 +2130,7 @@ static void em28xx_setup_xc3028(struct e
 		ctl->demod = XC3028_FE_ZARLINK456;
 		break;
 	case EM2880_BOARD_TERRATEC_HYBRID_XS:
+	case EM2880_BOARD_TERRATEC_HYBRID_XS_FR:
 	case EM2881_BOARD_PINNACLE_HYBRID_PRO:
 		ctl->demod = XC3028_FE_ZARLINK456;
 		break;
