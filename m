Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53718 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbbKLJ6x (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2015 04:58:53 -0500
Date: Thu, 12 Nov 2015 07:58:47 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Walter Cheuk <wwycheuk@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] tv tuner max2165 driver: extend frequency range
Message-ID: <20151112075847.2d268bc7@recife.lan>
In-Reply-To: <CABUpJt-mTeKkOnhk-ADv-5TJqhx-tRwPoKOQ2a7GJTM34Jz2Eg@mail.gmail.com>
References: <CABUpJt-mTeKkOnhk-ADv-5TJqhx-tRwPoKOQ2a7GJTM34Jz2Eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 22 Oct 2015 12:18:58 +0800
Walter Cheuk <wwycheuk@gmail.com> escreveu:

> Extend the frequency range to cover Hong Kong's digital TV
> broadcasting, which should be the whole UHF; RTHK TV uses 802MHz and
> is not covered currently. Tested on my TV tuner card "MyGica X8558
> Pro".
> 
> Signed-off-by: Walter Cheuk <wwycheuk@gmail.com>
> 
> ---
> 
> --- media/drivers/media/tuners/max2165.c.orig 2015-10-22
> 12:01:24.867254181 +0800
> +++ media/drivers/media/tuners/max2165.c 2015-10-22 12:02:05.706640982 +0800
> @@ -385,7 +385,7 @@ static const struct dvb_tuner_ops max216

Your e-mailer corrupted the patch: it broke long lines and mangled with
tabs and whitespaces.

>   .info = {
>   .name           = "Maxim MAX2165",
>   .frequency_min  = 470000000,
> - .frequency_max  = 780000000,
> + .frequency_max  = 868000000,
>   .frequency_step =     50000,
>   },
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
