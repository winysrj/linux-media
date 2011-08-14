Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm3-vm4.bullet.mail.ne1.yahoo.com ([98.138.91.163]:29788 "HELO
	nm3-vm4.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752623Ab1HNAjf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Aug 2011 20:39:35 -0400
Message-ID: <1313282374.97725.YahooMailClassic@web121715.mail.ne1.yahoo.com>
Date: Sat, 13 Aug 2011 17:39:34 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: PCTV 290e nanostick and remote control support
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4E46FB3C.7060402@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--- On Sat, 13/8/11, Antti Palosaari <crope@iki.fi> wrote:
> Remote is already supported, but from the 3.1 or maybe 3.2
> (I am not sure if Mauro was hurry to sent it 3.1).

Hi,

This appears to be the diff from 3.1 that adds RC support:

--- linux-3.0/drivers/media/video/em28xx/em28xx-cards.c.orig	2011-08-13 20:37:26.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-cards.c	2011-08-14 00:34:59.000000000 +0100
@@ -1773,13 +1773,13 @@
 	/* 2013:024f PCTV Systems nanoStick T2 290e.
 	 * Empia EM28174, Sony CXD2820R and NXP TDA18271HD/C2 */
 	[EM28174_BOARD_PCTV_290E] = {
+		.name          = "PCTV nanoStick T2 290e",
 		.i2c_speed      = EM2874_I2C_SECONDARY_BUS_SELECT |
 			EM28XX_I2C_CLK_WAIT_ENABLE | EM28XX_I2C_FREQ_100_KHZ,
-		.xclk          = EM28XX_XCLK_FREQUENCY_12MHZ,
-		.name          = "PCTV Systems nanoStick T2 290e",
 		.tuner_type    = TUNER_ABSENT,
 		.tuner_gpio    = pctv_290e,
 		.has_dvb       = 1,
+		.ir_codes      = RC_MAP_PINNACLE_PCTV_HD,
 	},
 };
 const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);
--- linux-3.0/drivers/media/video/em28xx/em28xx-input.c.orig	2011-08-14 00:30:57.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-input.c	2011-08-14 00:31:20.000000000 +0100
@@ -372,6 +372,7 @@
 		ir->get_key = default_polling_getkey;
 		break;
 	case CHIP_ID_EM2874:
+	case CHIP_ID_EM28174:
 		ir->get_key = em2874_polling_getkey;
 		em28xx_write_regs(dev, EM2874_R50_IR_CONFIG, &ir_config, 1);
 		break;

It certainly creates a new /dev/input/event? node, and allows me to program all but *one* button on the handset: the "OK" button. At this early stage, it would seem unlikely that this particular button is faulty. Could there be an error in the IR code configuration, please?

Or maybe someone else *does* have a PCTV 290e device where the OK button works?

Thanks,
Chris

