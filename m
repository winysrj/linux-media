Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n231tqRD018768
	for <video4linux-list@redhat.com>; Mon, 2 Mar 2009 20:55:52 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n231tah6019147
	for <video4linux-list@redhat.com>; Mon, 2 Mar 2009 20:55:36 -0500
Date: Mon, 2 Mar 2009 22:55:09 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Vitaly Wool <vital@embeddedalley.com>
Message-ID: <20090302225509.4603d580@pedra.chehab.org>
In-Reply-To: <49ABF405.9090005@embeddedalley.com>
References: <49ABF405.9090005@embeddedalley.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] em28xx: enable Compro VideoMate ForYou sound
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

On Mon, 02 Mar 2009 17:58:13 +0300
Vitaly Wool <vital@embeddedalley.com> wrote:

> --- linux-next.orig/drivers/media/video/em28xx/em28xx-core.c	2009-03-02 17:50:40.000000000 +0300
> +++ linux-next/drivers/media/video/em28xx/em28xx-core.c	2009-03-02 17:51:16.000000000 +0300
> @@ -353,6 +353,7 @@
>  {
>  	int ret;
>  	u8 input;
> +	int do_mute = 0;
>  
>  	if (dev->board.is_em2800) {
>  		if (dev->ctl_ainput == EM28XX_AMUX_VIDEO)
> @@ -378,6 +379,16 @@
>  		}
>  	}
>  
> +	if (dev->mute || input != EM28XX_AUDIO_SRC_TUNER)
> +		do_mute = 1;
> +
> +	if (dev->board.mute_gpio && do_mute)
> +		em28xx_gpio_set(dev, dev->board.mute_gpio);
> +
> +	if (dev->board.unmute_gpio && !do_mute)
> +		em28xx_gpio_set(dev, dev->board.unmute_gpio);
> +
> +
>  	ret = em28xx_write_reg_bits(dev, EM28XX_R0E_AUDIOSRC, input, 0xc0);
>  	if (ret < 0)
>  		return ret;

This part of the patch doesn't seem correct. We should call the mute gpio only
if dev->mute, since the mute condition has nothing to do with the selected input.

So, IMO, the above logic should be something like:

if (dev->mute)
	em28xx_gpio_set(dev, dev->board.mute_gpio);
else
	em28xx_gpio_set(dev, INPUT(dev->ctl_input)->gpio);

Some care should be taken, since the input gpio's are currently being set by
em28xx_set_mode().

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
