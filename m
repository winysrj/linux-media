Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.sissa.it ([147.122.11.135]:49186 "EHLO smtp.sissa.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084AbZBJT7G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 14:59:06 -0500
From: Nicola Soranzo <nsoranzo@tiscali.it>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] em28xx: Codign style fixes and a typo correction
Date: Tue, 10 Feb 2009 20:59:05 +0100
References: <200902091750.45091.nsoranzo@tiscali.it> <20090209194910.22015d34@pedra.chehab.org>
In-Reply-To: <20090209194910.22015d34@pedra.chehab.org>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902102059.05536.nsoranzo@tiscali.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alle lunedì 09 febbraio 2009, hai scritto:
> On Mon, 9 Feb 2009 17:50:44 +0100
> Nicola Soranzo <nsoranzo@tiscali.it> wrote:
> > Lots of codign style fixes and a typo correction for em28xx.
> >
> > Priority: low
> >
> > Signed-off-by: Nicola Soranzo <nsoranzo@tiscali.it>
> >
> > ---
> > diff -r 71e5a36634ea linux/drivers/media/video/em28xx/em28xx-audio.c
> > --- a/linux/drivers/media/video/em28xx/em28xx-audio.c	Mon Feb 02 10:33:31
> > 2009 +0100
> > +++ b/linux/drivers/media/video/em28xx/em28xx-audio.c	Mon Feb 09 12:47:13
> > 2009 +0100
> > @@ -264,8 +264,7 @@
> >  }
> >
> >  #if LINUX_VERSION_CODE <= KERNEL_VERSION(2, 6, 16)
> > -static int snd_pcm_alloc_vmalloc_buffer(snd_pcm_substream_t *subs,
> > -					size_t size)
> > +static int snd_pcm_alloc_vmalloc_buffer(snd_pcm_substream_t *subs,
> > size_t size)
>
> Please, prefer, instead, something like:
> +static int snd_pcm_alloc_vmalloc_buffer(snd_pcm_substream_t *subs,
> 					 size_t size)

This part was line wrapped by KMail (I've changed its setting as suggested), the original was:

diff -r 9cb19f080660 linux/drivers/media/video/em28xx/em28xx-audio.c
--- a/linux/drivers/media/video/em28xx/em28xx-audio.c	Tue Feb 10 05:26:05 2009 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx-audio.c	Tue Feb 10 20:33:23 2009 +0100
@@ -264,8 +264,7 @@ static int em28xx_cmd(struct em28xx *dev
 }
 
 #if LINUX_VERSION_CODE <= KERNEL_VERSION(2, 6, 16)
-static int snd_pcm_alloc_vmalloc_buffer(snd_pcm_substream_t *subs,
-					size_t size)
+static int snd_pcm_alloc_vmalloc_buffer(snd_pcm_substream_t *subs, size_t size)
 #else
 static int snd_pcm_alloc_vmalloc_buffer(struct snd_pcm_substream *subs,
 					size_t size)

The function definition is <= 80 characters, so I've put it on one line. Do you
anyway prefer the second parameter on the other line for consistency?

Thanks for the review, I've fixed all other required changes and I will send 
the new version later.

Nicola

