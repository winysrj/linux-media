Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51867 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526Ab0CWG7n (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Mar 2010 02:59:43 -0400
Date: Tue, 23 Mar 2010 07:59:42 +0100
Message-ID: <s5hwrx3a5gh.wl%tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Dan Carpenter <error27@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch v2] cx231xx: card->driver "Conexant cx231xx Audio" too long
In-Reply-To: <20100322153909.GC23411@bicker>
References: <20100319114957.GQ5331@bicker>
	<s5hr5ncxvm9.wl%tiwai@suse.de>
	<20100322153909.GC23411@bicker>
MIME-Version: 1.0 (generated by SEMI 1.14.6 - "Maruoka")
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At Mon, 22 Mar 2010 18:39:09 +0300,
Dan Carpenter wrote:
> 
> card->driver is 15 characters and a NULL, the original code could 
> cause a buffer overflow.
>  
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> In version 2, I used a better name that Takashi Iwai suggested.

Acked-by: Takashi Iwai <tiwai@suse.de>

Could you fix em28xx in the same way, too?


thanks,

Takashi

> diff --git a/drivers/media/video/cx231xx/cx231xx-audio.c b/drivers/media/video/cx231xx/cx231xx-audio.c
> index 7793d60..7cae95a 100644
> --- a/drivers/media/video/cx231xx/cx231xx-audio.c
> +++ b/drivers/media/video/cx231xx/cx231xx-audio.c
> @@ -495,7 +495,7 @@ static int cx231xx_audio_init(struct cx231xx *dev)
>  	pcm->info_flags = 0;
>  	pcm->private_data = dev;
>  	strcpy(pcm->name, "Conexant cx231xx Capture");
> -	strcpy(card->driver, "Conexant cx231xx Audio");
> +	strcpy(card->driver, "Cx231xx-Audio");
>  	strcpy(card->shortname, "Cx231xx Audio");
>  	strcpy(card->longname, "Conexant cx231xx Audio");
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
