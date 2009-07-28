Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55601 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZG1A2Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jul 2009 20:28:16 -0400
Date: Mon, 27 Jul 2009 21:28:11 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: acano@fastmail.fm
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] em28xx: enable usb audio for plextor px-tv100u
Message-ID: <20090727212811.5b7dc041@pedra.chehab.org>
In-Reply-To: <20090718173758.GA32708@localhost.localdomain>
References: <20090718173758.GA32708@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Acano,

Em Sat, 18 Jul 2009 13:37:58 -0400
acano@fastmail.fm escreveu:

> @@ -1950,6 +1950,10 @@ void em28xx_pre_card_setup(struct em28xx
>  		/* FIXME guess */
>  		/* Turn on analog audio output */
>  		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xfd);

This is legacy. While here, it is better to move the gpio setup it to the
proper place.

> +
> +		/* enable audio 12mhz i2s */
> +		em28xx_write_reg(dev, EM28XX_R0F_XCLK, 0xa7);

Instead of writing directly at xclk, the best is to initialize its value at
the boards struct.

> +		dev->i2s_speed = 2048000;
>  		break;
>  	case EM2861_BOARD_KWORLD_PVRTV_300U:
>  	case EM2880_BOARD_KWORLD_DVB_305U:
> diff -r 27ddf3fe0ed9 linux/drivers/media/video/em28xx/em28xx-video.c
> --- a/linux/drivers/media/video/em28xx/em28xx-video.c	Wed Jun 17 04:38:12 2009 +0000
> +++ b/linux/drivers/media/video/em28xx/em28xx-video.c	Sat Jul 18 13:32:04 2009 -0400
> @@ -1087,9 +1087,12 @@ static int vidioc_s_ctrl(struct file *fi
>  
>  	mutex_lock(&dev->lock);
>  
> -	if (dev->board.has_msp34xx)
> +	if (dev->board.has_msp34xx) {
> +		/*FIXME hack to unmute usb audio stream */
> +		em28xx_set_ctrl(dev, ctrl);

Hmm... this function were removed. In thesis, you shouldn't need to do anything
to unmute.

> +
>  		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_ctrl, ctrl);
> -	else {
> +	} else {
>  		rc = 1;
>  		for (i = 0; i < ARRAY_SIZE(em28xx_qctrl); i++) {
>  			if (ctrl->id == em28xx_qctrl[i].id) {

Could you please try the enclosed patch and see if this is enough to fix for
Plextor? If so, please send me a Tested-by: tag for me to add it at 2.6.31 fix
patches.

Cheers,
Mauro

em28xx: fix audio on Plextor PX-TV100U

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>


diff --git a/linux/drivers/media/video/em28xx/em28xx-cards.c b/linux/drivers/media/video/em28xx/em28xx-cards.c
--- a/linux/drivers/media/video/em28xx/em28xx-cards.c
+++ b/linux/drivers/media/video/em28xx/em28xx-cards.c
@@ -639,22 +639,27 @@ struct em28xx_board em28xx_boards[] = {
 	},
 	[EM2861_BOARD_PLEXTOR_PX_TV100U] = {
 		.name         = "Plextor ConvertX PX-TV100U",
-		.valid        = EM28XX_BOARD_NOT_VALIDATED,
 		.tuner_type   = TUNER_TNF_5335MF,
+		.xclk         = EM28XX_XCLK_I2S_MSB_TIMING |
+				EM28XX_XCLK_FREQUENCY_12MHZ,
 		.tda9887_conf = TDA9887_PRESENT,
 		.decoder      = EM28XX_TVP5150,
+		.has_msp34xx  = 1,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
 			.vmux     = TVP5150_COMPOSITE0,
 			.amux     = EM28XX_AMUX_LINE_IN,
+			.gpio     = pinnacle_hybrid_pro_analog,
 		}, {
 			.type     = EM28XX_VMUX_COMPOSITE1,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
+			.gpio     = pinnacle_hybrid_pro_analog,
 		}, {
 			.type     = EM28XX_VMUX_SVIDEO,
 			.vmux     = TVP5150_SVIDEO,
 			.amux     = EM28XX_AMUX_LINE_IN,
+			.gpio     = pinnacle_hybrid_pro_analog,
 		} },
 	},
 
@@ -1948,9 +1953,8 @@ void em28xx_pre_card_setup(struct em28xx
 	/* request some modules */
 	switch (dev->model) {
 	case EM2861_BOARD_PLEXTOR_PX_TV100U:
-		/* FIXME guess */
-		/* Turn on analog audio output */
-		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xfd);
+		/* Sets the msp34xx I2S speed */
+		dev->i2s_speed = 2048000;
 		break;
 	case EM2861_BOARD_KWORLD_PVRTV_300U:
 	case EM2880_BOARD_KWORLD_DVB_305U:




Cheers,
Mauro
