Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.seznam.cz ([77.75.72.43]:20400 "EHLO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbZE2HGj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 May 2009 03:06:39 -0400
From: Oldrich Jedlicka <oldium.pro@seznam.cz>
To: hermann pitton <hermann-pitton@arcor.de>
Subject: Re: [PATCH][RESEND] Use correct sampling rate for TV/FM radio
Date: Fri, 29 May 2009 09:06:22 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	LMML <linux-media@vger.kernel.org>
References: <200904142048.14713.oldium.pro@seznam.cz> <200905281847.47995.oldium.pro@seznam.cz> <1243554590.3769.47.camel@pc07.localdom.local>
In-Reply-To: <1243554590.3769.47.camel@pc07.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905290906.22853.oldium.pro@seznam.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Friday 29 of May 2009 at 01:49:50, hermann pitton wrote:
> Hi,
>
> just some short notes.
>
> Am Donnerstag, den 28.05.2009, 18:47 +0200 schrieb Oldrich Jedlicka:
> > On Wednesday 27 of May 2009 at 21:05:35, Mauro Carvalho Chehab wrote:
> > > Em Sat, 23 May 2009 19:09:12 +0200
> > >
> > > Oldrich Jedlicka <oldium.pro@seznam.cz> escreveu:
> > > > On Tuesday 19 of May 2009 at 19:54:18, Oldrich Jedlicka wrote:
> > > > > On Tuesday 14 of April 2009 at 20:48:14, Oldrich Jedlicka wrote:
> > > > > > Here is the fix for using the 32kHz sampling rate for TV and FM
> > > > > > radio (ALSA). The TV uses 32kHz anyway (mode 0; 32kHz demdec on),
> > > > > > radio works only with 32kHz (mode 1; 32kHz baseband). The ALSA
> > > > > > wrongly reported 32kHz and 48kHz for everything (TV, radio,
> > > > > > LINE1/2).
> > > > > >
> > > > > > Now it should be possible to just use the card without the need
> > > > > > to change the capture rate from 48kHz to 32kHz. Enjoy :-)
> > > >
> > > > Hi Mauro,
> > > >
> > > > I put you on CC in my previous mail, but maybe it would be better to
> > > > send it directly. So do you have any opinions about the approach
> > > > described above/below?
> > >
> > > I did a look at saa713x datasheet. In thesis, it could be possible to
> > > program the audio sampling rate divider for several rates including 32
> > > kHz, 44.1 kHz and 48 kHz.
> > >
> > > However, I suspect that only MONO is supported with rates different
> > > than 32 kHz, since it is said there that AM/FM requires a nominal audio
> > > sample of 32 kHz, and that NICAM nominal audio sample rate is 32 kHz.
> > >
> > > So, IMO, the right patch is just to allow samplings at 32 kHz
> >
> > Hi Mauro,
> >
> > I'm not good in programming the SAA7134, but I also have the SAA713x
> > manual :-).
>
> If you have the programming manual, not what is for free download but
> under NDA, you should find exact register settings for 48kHZ stereo over
> DMA TV sound, if possible at all.

I have something that is called "SAA7133; SAA7135 PCI audio and video 
broadcast decoder", Preliminary version, 2003 Sep 09. I've found it on the 
internet in 2006.

> > I don't know if the NICAM mode is used for LINE1/LINE2, but if not - and
> > if it uses the Video-lock mode - it can (or could) operate in 44.1kHz and
> > 48kHz too.
>
> NICAM, on all TV standards that support it, is always at the second
> soundcarrier. So input must be SIF to isolate the SSIF and decode it
> from there with the nicam decoder. (amux TV)
>
> > The manual talks about Video-mode and here is the note, that the FM/AM
> > sound decoring requires a nominal audio sample rate of 32kHz. The code
> > (saa7134-alsa.c) sets to use 32kHz for radio, it is not configurable - so
> > this is where my patch applies.
>
> For all analog audio out from tuner the sampling rate is 32 kHz. That is
> correct.
>
> > The Video-lock mode can use 32kHz, 44.1kHz and 48kHz. The NICAM can use
> > only the 32kHz. From the code (again the saa7134-alsa.c) the TV sets to
> > use the DEMDEC 32kHz mode and is not configurable - again my patch
> > applies.
> >
> > So my only question is about the LINE1/LINE2, I do not understand the
> > coding of SAA713x as much to be able to say anything about the mode of
> > operation for LINE1/LINE2. Maybe somebody wants to use the 48kHz whenever
> > possible on LINE1/LINE2 (quality reasons), so maybe limiting it there
> > isn't good - I don't know, if it is possible to use it.
>
> Gerd had working 48kHz audio sampling rate from external audio LINE
> inputs on his saa7134-oss, at least on the saa7134 chip.
>
> This is not working anymore on saa7134-alsa.
>
> He was also the opinion, that 48kHz stereo TV sound is not possible over
> DMA too. IIRC, on broadcast level 32kHz is already up sampled.
>
> A limiting factor might also be, that we can't differentiate between
> saa7133, saa7135 and saa7131e. There are such chip comparing tables I
> don't have at hand at the moment.

I cannot find anything specific to setting the DMA for TV in the document, 
only about the audio clock generation. In NICAM mode (whatever it means) the 
nominal sample rate is 32kHz. The frequency 32kHz can operate in two modes - 
with/without DEMDEC enabled (I don't know what the DEMDEC is). The code for 
TV in saa7134-alsa.c (I only guess, because the register address is 
completely different) uses the 32kHz with DEMDEC enabled (0x00 for 
SIF_SAMPLE_FREQ). The LINE1/LINE2 code sets the frequency to 32kHz+DEMDEC 
disabled (0x01) or 48kHz (0x03). There should be a possibility to set 44.1kHz 
(0x02) too, but it is not used.

One of the lines (LINE1/LINE2) captures the radio, but the radio requires 
32kHz (it is the LINE1/LINE2 branch in code - it uses mode 0x01, I don't know 
if the mode 0x00 can be used).

I tried to use the 48kHz for the composite input (digital camera) and it 
doesn't work for me too.

The rest is covered in a big cloud, I don't know much about DMA programming 
nor about the SAA713x programming. The document is not clear to me, it has a 
lot of tables and not much text in between.

But if the frequency other than 32kHz simply doesn't work, ALSA should report 
only 32kHz (at least for now). I can provide a simple patch for that, if 
nobody complains.

Cheers,
Oldrich.
