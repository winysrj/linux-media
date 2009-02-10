Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54594 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbZBJUGI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 15:06:08 -0500
Date: Tue, 10 Feb 2009 18:05:30 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Nicola Soranzo <nsoranzo@tiscali.it>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] em28xx: Codign style fixes and a typo correction
Message-ID: <20090210180530.37f710b6@pedra.chehab.org>
In-Reply-To: <200902102059.05536.nsoranzo@tiscali.it>
References: <200902091750.45091.nsoranzo@tiscali.it>
	<20090209194910.22015d34@pedra.chehab.org>
	<200902102059.05536.nsoranzo@tiscali.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 10 Feb 2009 20:59:05 +0100
Nicola Soranzo <nsoranzo@tiscali.it> wrote:

> Alle lunedì 09 febbraio 2009, hai scritto:
> > On Mon, 9 Feb 2009 17:50:44 +0100
> > Nicola Soranzo <nsoranzo@tiscali.it> wrote:
> > > Lots of codign style fixes and a typo correction for em28xx.
> > >
> > > Priority: low
> > >
> > > Signed-off-by: Nicola Soranzo <nsoranzo@tiscali.it>
> > >
> > > ---
> > > diff -r 71e5a36634ea linux/drivers/media/video/em28xx/em28xx-audio.c
> > > --- a/linux/drivers/media/video/em28xx/em28xx-audio.c	Mon Feb 02 10:33:31
> > > 2009 +0100
> > > +++ b/linux/drivers/media/video/em28xx/em28xx-audio.c	Mon Feb 09 12:47:13
> > > 2009 +0100
> > > @@ -264,8 +264,7 @@
> > >  }
> > >
> > >  #if LINUX_VERSION_CODE <= KERNEL_VERSION(2, 6, 16)
> > > -static int snd_pcm_alloc_vmalloc_buffer(snd_pcm_substream_t *subs,
> > > -					size_t size)
> > > +static int snd_pcm_alloc_vmalloc_buffer(snd_pcm_substream_t *subs,
> > > size_t size)
> >
> > Please, prefer, instead, something like:
> > +static int snd_pcm_alloc_vmalloc_buffer(snd_pcm_substream_t *subs,
> > 					 size_t size)
> 
> This part was line wrapped by KMail (I've changed its setting as suggested), the original was:

Ah, ok.

> diff -r 9cb19f080660 linux/drivers/media/video/em28xx/em28xx-audio.c
> --- a/linux/drivers/media/video/em28xx/em28xx-audio.c	Tue Feb 10 05:26:05 2009 -0200
> +++ b/linux/drivers/media/video/em28xx/em28xx-audio.c	Tue Feb 10 20:33:23 2009 +0100
> @@ -264,8 +264,7 @@ static int em28xx_cmd(struct em28xx *dev
>  }
>  
>  #if LINUX_VERSION_CODE <= KERNEL_VERSION(2, 6, 16)
> -static int snd_pcm_alloc_vmalloc_buffer(snd_pcm_substream_t *subs,
> -					size_t size)
> +static int snd_pcm_alloc_vmalloc_buffer(snd_pcm_substream_t *subs, size_t size)
>  #else
>  static int snd_pcm_alloc_vmalloc_buffer(struct snd_pcm_substream *subs,
>  					size_t size)
> 
> The function definition is <= 80 characters, so I've put it on one line. Do you
> anyway prefer the second parameter on the other line for consistency?

If it fits on 80 columns, IMO, the better is to keep it at the same line.

> Thanks for the review, I've fixed all other required changes and I will send 
> the new version later.

Ok, thanks!

Cheers,
Mauro
