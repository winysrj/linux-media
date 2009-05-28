Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.seznam.cz ([77.75.72.43]:41169 "EHLO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756105AbZE1QsM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2009 12:48:12 -0400
From: Oldrich Jedlicka <oldium.pro@seznam.cz>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH][RESEND] Use correct sampling rate for TV/FM radio
Date: Thu, 28 May 2009 18:47:47 +0200
Cc: LMML <linux-media@vger.kernel.org>
References: <200904142048.14713.oldium.pro@seznam.cz> <200905231909.12817.oldium.pro@seznam.cz> <20090527160535.683eae6e@pedra.chehab.org>
In-Reply-To: <20090527160535.683eae6e@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905281847.47995.oldium.pro@seznam.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 27 of May 2009 at 21:05:35, Mauro Carvalho Chehab wrote:
> Em Sat, 23 May 2009 19:09:12 +0200
>
> Oldrich Jedlicka <oldium.pro@seznam.cz> escreveu:
> > On Tuesday 19 of May 2009 at 19:54:18, Oldrich Jedlicka wrote:
> > > On Tuesday 14 of April 2009 at 20:48:14, Oldrich Jedlicka wrote:
> > > > Here is the fix for using the 32kHz sampling rate for TV and FM radio
> > > > (ALSA). The TV uses 32kHz anyway (mode 0; 32kHz demdec on), radio
> > > > works only with 32kHz (mode 1; 32kHz baseband). The ALSA wrongly
> > > > reported 32kHz and 48kHz for everything (TV, radio, LINE1/2).
> > > >
> > > > Now it should be possible to just use the card without the need to
> > > > change the capture rate from 48kHz to 32kHz. Enjoy :-)
> >
> > Hi Mauro,
> >
> > I put you on CC in my previous mail, but maybe it would be better to send
> > it directly. So do you have any opinions about the approach described
> > above/below?
>
> I did a look at saa713x datasheet. In thesis, it could be possible to
> program the audio sampling rate divider for several rates including 32 kHz,
> 44.1 kHz and 48 kHz.
>
> However, I suspect that only MONO is supported with rates different than 32
> kHz, since it is said there that AM/FM requires a nominal audio sample of
> 32 kHz, and that NICAM nominal audio sample rate is 32 kHz.
>
> So, IMO, the right patch is just to allow samplings at 32 kHz

Hi Mauro,

I'm not good in programming the SAA7134, but I also have the SAA713x 
manual :-).

I don't know if the NICAM mode is used for LINE1/LINE2, but if not - and if it 
uses the Video-lock mode - it can (or could) operate in 44.1kHz and 48kHz 
too.

The manual talks about Video-mode and here is the note, that the FM/AM sound 
decoring requires a nominal audio sample rate of 32kHz. The code 
(saa7134-alsa.c) sets to use 32kHz for radio, it is not configurable - so 
this is where my patch applies.

The Video-lock mode can use 32kHz, 44.1kHz and 48kHz. The NICAM can use only 
the 32kHz. From the code (again the saa7134-alsa.c) the TV sets to use the 
DEMDEC 32kHz mode and is not configurable - again my patch applies.

So my only question is about the LINE1/LINE2, I do not understand the coding 
of SAA713x as much to be able to say anything about the mode of operation for 
LINE1/LINE2. Maybe somebody wants to use the 48kHz whenever possible on 
LINE1/LINE2 (quality reasons), so maybe limiting it there isn't good - I 
don't know, if it is possible to use it.
 
Cheers,
Oldrich.
