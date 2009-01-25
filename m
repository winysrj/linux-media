Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:57379 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbZAYWZk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2009 17:25:40 -0500
Received: by qyk4 with SMTP id 4so6193194qyk.13
        for <linux-media@vger.kernel.org>; Sun, 25 Jan 2009 14:25:38 -0800 (PST)
Date: Sun, 25 Jan 2009 20:25:33 -0200
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [patch review] em28xx: correct mailing list
Message-ID: <20090125202533.5c839e53@gmail.com>
In-Reply-To: <1232854594.21610.7.camel@tux.localhost>
References: <1232854594.21610.7.camel@tux.localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alexey,

  Applied, thanks.

Cheers,
Douglas

On Sun, 25 Jan 2009 06:36:33 +0300
Alexey Klimov <klimov.linux@gmail.com> wrote:

> Hello all
> I'm not sure is this patch really suitable.
> But looks that main development mail-list moved to linux-media..
> 
> ---
> Correct mailing list in 3 places in em28xx-cards.c
> Move to linux-media on vger.kernel.org.
> 
> Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
> --
> diff -r 6a6eb9efc6cd linux/drivers/media/video/em28xx/em28xx-cards.c
> --- a/linux/drivers/media/video/em28xx/em28xx-cards.c	Fri Jan
> 23 22:35:12 2009 -0200 +++
> b/linux/drivers/media/video/em28xx/em28xx-cards.c	Sun Jan 25
> 06:28:10 2009 +0300 @@ -1679,7 +1679,7 @@ em28xx_errdev("If the board
> were missdetected, " "please email this log to:\n");
>  			em28xx_errdev("\tV4L Mailing List "
> -				      "
> <video4linux-list@redhat.com>\n");
> +				      "
> <linux-media@vger.kernel.org>\n"); em28xx_errdev("Board detected as
> %s\n", em28xx_boards[dev->model].name);
>  
> @@ -1711,7 +1711,7 @@
>  			em28xx_errdev("If the board were
> missdetected, " "please email this log to:\n");
>  			em28xx_errdev("\tV4L Mailing List "
> -				      "
> <video4linux-list@redhat.com>\n");
> +				      "
> <linux-media@vger.kernel.org>\n"); em28xx_errdev("Board detected as
> %s\n", em28xx_boards[dev->model].name);
>  
> @@ -1724,7 +1724,7 @@
>  	em28xx_errdev("You may try to use card=<n> insmod option to "
>  		      "workaround that.\n");
>  	em28xx_errdev("Please send an email with this log to:\n");
> -	em28xx_errdev("\tV4L Mailing List
> <video4linux-list@redhat.com>\n");
> +	em28xx_errdev("\tV4L Mailing List
> <linux-media@vger.kernel.org>\n"); em28xx_errdev("Board eeprom hash
> is 0x%08lx\n", dev->hash); em28xx_errdev("Board i2c devicelist hash
> is 0x%08lx\n", dev->i2c_hash); 
> 
> 
