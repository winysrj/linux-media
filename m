Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1PGJ4nB005638
	for <video4linux-list@redhat.com>; Wed, 25 Feb 2009 11:19:04 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n1PGImDw012744
	for <video4linux-list@redhat.com>; Wed, 25 Feb 2009 11:18:48 -0500
Date: Wed, 25 Feb 2009 10:18:12 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Vitaly Wool <vital@embeddedalley.com>
Message-ID: <20090225101812.212fabbe@caramujo.chehab.org>
In-Reply-To: <49A567D9.80805@embeddedalley.com>
References: <49A3A61F.30509@embeddedalley.com>
	<20090224234205.7a5ca4ca@pedra.chehab.org>
	<49A53CB9.1040109@embeddedalley.com>
	<20090225090728.7f2b0673@caramujo.chehab.org>
	<49A567D9.80805@embeddedalley.com>
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

On Wed, 25 Feb 2009 18:46:33 +0300
Vitaly Wool <vital@embeddedalley.com> wrote:

> Mauro,
> 
> Mauro Carvalho Chehab wrote:
> 
> > Ok, so if everything else is properly configured on em28xx, you should have
> > audio working. 
> >
> > I've just committed a patch that should automatically load tvaudio for your
> > board. Could you please test it?
> it looks like I've got the sound coming out of the board with the following piece of hackery:
> 
> diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
> index eee8d01..55bcf42 100644
> --- a/drivers/media/video/em28xx/em28xx-core.c
> +++ b/drivers/media/video/em28xx/em28xx-core.c
> @@ -406,6 +406,24 @@ int em28xx_audio_analog_set(struct em28xx *dev)
>  	int ret, i;
>  	u8 xclk;
>  
> +	if (dev->i2c_tvaudio_client) {
> +		char c;
> +		switch (dev->ctl_ainput) {
> +		case 0:
> +			c = 0xfd;
> +			break;
> +		case 1:
> +			c = 0xfc;
> +			break;
> +		default:
> +			c = 0xfe;
> +			break;
> +		}
> +		if (dev->mute)
> +			c = 0xfe;
> +		return em28xx_write_regs(dev, 0x08, &c, 1);
> +	}

Ah, so, it needs gpio setups per input. This is supported by the driver. You
just need to add a .gpio entry just like what he have for
EM2882_BOARD_TERRATEC_HYBRID_XS.

> diff --git a/drivers/media/video/em28xx/em28xx-i2c.c b/drivers/media/video/em28xx/em28xx-i2c.c
> index 2dab43d..55e5a2e 100644
> --- a/drivers/media/video/em28xx/em28xx-i2c.c
> +++ b/drivers/media/video/em28xx/em28xx-i2c.c
> @@ -510,12 +510,21 @@ static int attach_inform(struct i2c_client *client)
>  		dprintk1(1, "attach_inform: tvp5150 detected.\n");
>  		break;
>  
> +	case 0xb0:
> +		dprintk1(1, "attach_inform: tda9874 detected\n");
> +		dprintk1(1, "driver id %d\n", client->driver->id);
> +		dev->i2c_tvaudio_client = client;
> +		if (!dev->tuner_addr)
> +			dev->tuner_addr = client->addr;
> +		break;
> +

The above is not needed, and it is wrong to touch at tuner_addr. It would ok to
just add a printk there to inform that tvaudio were connected.

> @@ -554,6 +563,7 @@ static char *i2c_devs[128] = {
>  	[0x80 >> 1] = "msp34xx",
>  	[0x88 >> 1] = "msp34xx",
>  	[0xa0 >> 1] = "eeprom",
> +	[0xb0 >> 1] = "tvaudio",
>  	[0xb8 >> 1] = "tvp5150a",
>  	[0xba >> 1] = "tvp5150a",
>  	[0xc0 >> 1] = "tuner (analog)",

instead of tvaudio, please use tda9874. there are other audio devices on 0xb0 address.

> diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
> index efd6415..5f7f4da 100644
> --- a/drivers/media/video/em28xx/em28xx-video.c
> +++ b/drivers/media/video/em28xx/em28xx-video.c
> @@ -540,6 +540,13 @@ static void video_mux(struct em28xx *dev, int index)
>  			&route);
>  	}
>  
> +	if (dev->i2c_tvaudio_client) {
> +		route.input = dev->ctl_ainput;
> +		route.output = 0;
> +		em28xx_i2c_call_clients(dev, VIDIOC_INT_S_AUDIO_ROUTING,
> +			&route);
> +	}
> +
>  	em28xx_audio_analog_set(dev);
>  }

Ok, this is needed. After my patch, the test should be:
	if (dev->board.adecoder != EM28XX_NOADECODER)

This will be generic enough to work with other devices with audio decoders. We
are currently working with another em28xx that has a yet unsupported audio
chip. I suspect that the list of audio chips will need to be increased. So, it
is better to have a more generic support to allow loading other audio decoders.

> diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
> index 100f90a..c263f5d 100644
> --- a/drivers/media/video/em28xx/em28xx-cards.c
> +++ b/drivers/media/video/em28xx/em28xx-cards.c
> @@ -1248,7 +1248,7 @@ struct em28xx_board em28xx_boards[] = {
>  		.input        = { {
>  			.type     = EM28XX_VMUX_TELEVISION,
>  			.vmux     = TVP5150_COMPOSITE0,
> -			.amux     = EM28XX_AMUX_LINE_IN,
> +			.amux     = EM28XX_AMUX_VIDEO,
>  		}, {
>  			.type     = EM28XX_VMUX_SVIDEO,
>  			.vmux     = TVP5150_SVIDEO,

The actual value for amux will depend on your mixer chip, if there is any.
Could you provide your full em28xx log? Let's see if it will detect EM202 or
another AC97 chip.

> Please note the .amux change; my bad it wasn't right from the bery beginning. However, just changing it
> doesn't make things work, either with your latest patch or without it. Changes in em28xx_audio_analog_set are 
> apparently what matter. but I'm not sure.
> 
> The other thing is that even with this patch, I'm getting more noise than TV sound. That might be related to
> some TDA9874 programming needed and not done, but I'm not sure here either.

It may be due to that wrong change on em28xx-i2c.

IMO, it would be better if you could do a patch with the remaining changes. 

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
