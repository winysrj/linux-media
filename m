Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:59413 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab1BOUqs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Feb 2011 15:46:48 -0500
Message-ID: <4D5AE633.3020704@infradead.org>
Date: Tue, 15 Feb 2011 18:46:43 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Vitaly Makarov <vit.macarrow@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Non-portable code in em28XX driver
References: <AANLkTin8=arSRg3VLVEUmTRdYt3FzGeBZS6wvu8iEZYo@mail.gmail.com> <AANLkTi=4K9YM=_pVycMw0721YV_f+XR52OPb36ePED3Q@mail.gmail.com>
In-Reply-To: <AANLkTi=4K9YM=_pVycMw0721YV_f+XR52OPb36ePED3Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 15-02-2011 17:16, Vitaly Makarov escreveu:
> Dear Mauro,
> In your patch 12406 to v4l-dvb dev tree there is a small problem:
> --
> 
> diff -r 13a35e80e987 -r 8f9eee4fd803
> linux/drivers/media/video/em28xx/em28xx-core.c
> --- a/linux/drivers/media/video/em28xx/em28xx-core.c    Fri Aug 07 18:43:00
> 2009 -0300
> +++ b/linux/drivers/media/video/em28xx/em28xx-core.c    Sat Aug 08 03:14:55
> 2009 -0300
> @@ -720,7 +720,10 @@
>  {
>         int width, height;
>         width = norm_maxw(dev);
> -       height = norm_maxh(dev) >> 1;
> +       height = norm_maxh(dev);
> +
> +       if (!dev->progressive)
> +               height >>= norm_maxh(dev);
> 
>         em28xx_set_outfmt(dev);
> 
> --
> In the line "height >>= norm_maxh(dev)" undefined behavior has been
> introduced. There is an attempt to shift the number to a big number of
> bits which is not defined by C standard and leads to unpredictable
> results. For example it will work on Intel because there it will
> translate to no shift at all which seems to be unexpected as well. But
> if you enable global optimization or compile this code for ARM the
> result will be 0.
> It seems like this line should look like "height = norm_maxh(dev) >> 1"

Yes, I suspect so. Could you please make us a patch for it?

Thanks!
Mauro
