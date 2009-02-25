Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1PIYD7O024375
	for <video4linux-list@redhat.com>; Wed, 25 Feb 2009 13:34:13 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n1PIXwTW025152
	for <video4linux-list@redhat.com>; Wed, 25 Feb 2009 13:33:58 -0500
Date: Wed, 25 Feb 2009 15:33:23 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Vitaly Wool <vital@embeddedalley.com>
Message-ID: <20090225153323.66778ad2@caramujo.chehab.org>
In-Reply-To: <49A57BD4.6040209@embeddedalley.com>
References: <49A3A61F.30509@embeddedalley.com>
	<20090224234205.7a5ca4ca@pedra.chehab.org>
	<49A53CB9.1040109@embeddedalley.com>
	<20090225090728.7f2b0673@caramujo.chehab.org>
	<49A567D9.80805@embeddedalley.com>
	<20090225101812.212fabbe@caramujo.chehab.org>
	<49A57BD4.6040209@embeddedalley.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, em28xx@mcentral.de
Subject: Re: em28xx: Compro VideoMate For You sound problems
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Wed, 25 Feb 2009 20:11:48 +0300
Vitaly Wool <vital@embeddedalley.com> wrote:

> Mauro Carvalho Chehab wrote:
> 
> >
> > IMO, it would be better if you could do a patch with the remaining changes. 
> after doing the mods you'd suggested I found out that the noise started coming out after the em28xx module loading
> stops when em28xx_set_audio_source() is executed. Don't I need to add some tweaks there as well?

See bellow.
> 
> The patch is now looking the following way:

It seems that we are close to have a patch for it ;) I have just a few comments/suggestions.

> 
> diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
> index 100f90a..f300e74 100644
> --- a/drivers/media/video/em28xx/em28xx-cards.c
> +++ b/drivers/media/video/em28xx/em28xx-cards.c
> @@ -1245,14 +1245,17 @@ struct em28xx_board em28xx_boards[] = {
>  		.tda9887_conf = TDA9887_PRESENT,
>  		.decoder      = EM28XX_TVP5150,
>  		.adecoder     = EM28XX_TVAUDIO,
> +		.tuner_gpio   = default_tuner_gpio,

You don't need a tuner gpio. This is used basically by xc3028 based devices, in
order to reset it during software upload.

Instead, we should add another gpio here, for mute. This should be called in a
place where we can remove the unwanted noise (e. g. at the beginning of the
device setup logic), and when mute is selected by the audio functions.

>  		.input        = { {
>  			.type     = EM28XX_VMUX_TELEVISION,
>  			.vmux     = TVP5150_COMPOSITE0,
> -			.amux     = EM28XX_AMUX_LINE_IN,
> +			.amux     = EM28XX_AMUX_VIDEO,
> +			.gpio     = default_analog,
>  		}, {
>  			.type     = EM28XX_VMUX_SVIDEO,
>  			.vmux     = TVP5150_SVIDEO,
>  			.amux     = EM28XX_AMUX_LINE_IN,
> +			.gpio     = default_analog,
>  		} },
>  	},

On your first patches, you were using different values for .gpio (0xfd?). You
should use the value you found on your windows driver, since enabling more
gpio's than needed could generate some troubles on certain devices.

>  	[EM2860_BOARD_KAIOMY_TVNPC_U2] = {
> diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
> index eee8d01..b5b2396 100644
> --- a/drivers/media/video/em28xx/em28xx-core.c
> +++ b/drivers/media/video/em28xx/em28xx-core.c
> @@ -354,6 +354,7 @@ static int em28xx_set_audio_source(struct em28xx *dev)
>  	int ret;
>  	u8 input;
>  
> +	printk("%s: entered\n", __func__);

(I'm assuming that you'll either convert it into a dprintk or remove the above line on the final patch)

>  	default:
>  		if (!dev->tuner_addr)
>  			dev->tuner_addr = client->addr;
>  
>  		dprintk1(1, "attach inform: detected I2C address %x\n",
>  				client->addr << 1);
> +		dprintk1(1, "driver id %d\n", client->driver->id);

I liked this. However, this will likely be removed soon, since the i2c
maintainer intends to remove the driver->id. Well, for now, let's keep it.



Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
