Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38027 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761924AbZE0TFl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2009 15:05:41 -0400
Date: Wed, 27 May 2009 16:05:35 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Oldrich Jedlicka <oldium.pro@seznam.cz>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH][RESEND] Use correct sampling rate for TV/FM radio
Message-ID: <20090527160535.683eae6e@pedra.chehab.org>
In-Reply-To: <200905231909.12817.oldium.pro@seznam.cz>
References: <200904142048.14713.oldium.pro@seznam.cz>
	<200905191954.19097.oldium.pro@seznam.cz>
	<200905231909.12817.oldium.pro@seznam.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 23 May 2009 19:09:12 +0200
Oldrich Jedlicka <oldium.pro@seznam.cz> escreveu:

> On Tuesday 19 of May 2009 at 19:54:18, Oldrich Jedlicka wrote:
> > On Tuesday 14 of April 2009 at 20:48:14, Oldrich Jedlicka wrote:
> > > Here is the fix for using the 32kHz sampling rate for TV and FM radio
> > > (ALSA). The TV uses 32kHz anyway (mode 0; 32kHz demdec on), radio works
> > > only with 32kHz (mode 1; 32kHz baseband). The ALSA wrongly reported 32kHz
> > > and 48kHz for everything (TV, radio, LINE1/2).
> > >
> > > Now it should be possible to just use the card without the need to change
> > > the capture rate from 48kHz to 32kHz. Enjoy :-)
> >
> 
> Hi Mauro,
> 
> I put you on CC in my previous mail, but maybe it would be better to send it 
> directly. So do you have any opinions about the approach described 
> above/below?

I did a look at saa713x datasheet. In thesis, it could be possible to program
the audio sampling rate divider for several rates including 32 kHz, 44.1 kHz
and 48 kHz.

However, I suspect that only MONO is supported with rates different than 32
kHz, since it is said there that AM/FM requires a nominal audio sample of
32 kHz, and that NICAM nominal audio sample rate is 32 kHz.

So, IMO, the right patch is just to allow samplings at 32 kHz



Cheers,
Mauro
