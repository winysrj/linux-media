Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:35270 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753124AbZEaDUC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 May 2009 23:20:02 -0400
Subject: Re: [PATCH][RESEND] Use correct sampling rate for TV/FM radio
From: hermann pitton <hermann-pitton@arcor.de>
To: Oldrich Jedlicka <oldium.pro@seznam.cz>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	LMML <linux-media@vger.kernel.org>
In-Reply-To: <200905290906.22853.oldium.pro@seznam.cz>
References: <200904142048.14713.oldium.pro@seznam.cz>
	 <200905281847.47995.oldium.pro@seznam.cz>
	 <1243554590.3769.47.camel@pc07.localdom.local>
	 <200905290906.22853.oldium.pro@seznam.cz>
Content-Type: text/plain
Date: Sun, 31 May 2009 05:11:22 +0200
Message-Id: <1243739482.3733.8.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Freitag, den 29.05.2009, 09:06 +0200 schrieb Oldrich Jedlicka: 
> Hi,
> 
> On Friday 29 of May 2009 at 01:49:50, hermann pitton wrote:
> > Hi,
> >
> > just some short notes.
> >
> > Am Donnerstag, den 28.05.2009, 18:47 +0200 schrieb Oldrich Jedlicka:
> > > On Wednesday 27 of May 2009 at 21:05:35, Mauro Carvalho Chehab wrote:
> > > > Em Sat, 23 May 2009 19:09:12 +0200
> > > >
> > > > Oldrich Jedlicka <oldium.pro@seznam.cz> escreveu:
> > > > > On Tuesday 19 of May 2009 at 19:54:18, Oldrich Jedlicka wrote:
> > > > > > On Tuesday 14 of April 2009 at 20:48:14, Oldrich Jedlicka wrote:
> > > > > > > Here is the fix for using the 32kHz sampling rate for TV and FM
> > > > > > > radio (ALSA). The TV uses 32kHz anyway (mode 0; 32kHz demdec on),
> > > > > > > radio works only with 32kHz (mode 1; 32kHz baseband). The ALSA
> > > > > > > wrongly reported 32kHz and 48kHz for everything (TV, radio,
> > > > > > > LINE1/2).
> > > > > > >
> > > > > > > Now it should be possible to just use the card without the need
> > > > > > > to change the capture rate from 48kHz to 32kHz. Enjoy :-)
> > > > >
> > > > > Hi Mauro,
> > > > >
> > > > > I put you on CC in my previous mail, but maybe it would be better to
> > > > > send it directly. So do you have any opinions about the approach
> > > > > described above/below?
> > > >
> > > > I did a look at saa713x datasheet. In thesis, it could be possible to
> > > > program the audio sampling rate divider for several rates including 32
> > > > kHz, 44.1 kHz and 48 kHz.
> > > >
> > > > However, I suspect that only MONO is supported with rates different
> > > > than 32 kHz, since it is said there that AM/FM requires a nominal audio
> > > > sample of 32 kHz, and that NICAM nominal audio sample rate is 32 kHz.
> > > >
> > > > So, IMO, the right patch is just to allow samplings at 32 kHz
> > >
> > > Hi Mauro,
> > >
> > > I'm not good in programming the SAA7134, but I also have the SAA713x
> > > manual :-).
> >
> > If you have the programming manual, not what is for free download but
> > under NDA, you should find exact register settings for 48kHZ stereo over
> > DMA TV sound, if possible at all.
> 
> I have something that is called "SAA7133; SAA7135 PCI audio and video 
> broadcast decoder", Preliminary version, 2003 Sep 09. I've found it on the 
> internet in 2006.
> 
> > > I don't know if the NICAM mode is used for LINE1/LINE2, but if not - and
> > > if it uses the Video-lock mode - it can (or could) operate in 44.1kHz and
> > > 48kHz too.
> >
> > NICAM, on all TV standards that support it, is always at the second
> > soundcarrier. So input must be SIF to isolate the SSIF and decode it
> > from there with the nicam decoder. (amux TV)
> >
> > > The manual talks about Video-mode and here is the note, that the FM/AM
> > > sound decoring requires a nominal audio sample rate of 32kHz. The code
> > > (saa7134-alsa.c) sets to use 32kHz for radio, it is not configurable - so
> > > this is where my patch applies.
> >
> > For all analog audio out from tuner the sampling rate is 32 kHz. That is
> > correct.
> >
> > > The Video-lock mode can use 32kHz, 44.1kHz and 48kHz. The NICAM can use
> > > only the 32kHz. From the code (again the saa7134-alsa.c) the TV sets to
> > > use the DEMDEC 32kHz mode and is not configurable - again my patch
> > > applies.
> > >
> > > So my only question is about the LINE1/LINE2, I do not understand the
> > > coding of SAA713x as much to be able to say anything about the mode of
> > > operation for LINE1/LINE2. Maybe somebody wants to use the 48kHz whenever
> > > possible on LINE1/LINE2 (quality reasons), so maybe limiting it there
> > > isn't good - I don't know, if it is possible to use it.
> >
> > Gerd had working 48kHz audio sampling rate from external audio LINE
> > inputs on his saa7134-oss, at least on the saa7134 chip.
> >
> > This is not working anymore on saa7134-alsa.
> >
> > He was also the opinion, that 48kHz stereo TV sound is not possible over
> > DMA too. IIRC, on broadcast level 32kHz is already up sampled.
> >
> > A limiting factor might also be, that we can't differentiate between
> > saa7133, saa7135 and saa7131e. There are such chip comparing tables I
> > don't have at hand at the moment.
> 
> I cannot find anything specific to setting the DMA for TV in the document, 
> only about the audio clock generation. In NICAM mode (whatever it means) the 
> nominal sample rate is 32kHz. The frequency 32kHz can operate in two modes - 
> with/without DEMDEC enabled (I don't know what the DEMDEC is). The code for 
> TV in saa7134-alsa.c (I only guess, because the register address is 
> completely different) uses the 32kHz with DEMDEC enabled (0x00 for 
> SIF_SAMPLE_FREQ). The LINE1/LINE2 code sets the frequency to 32kHz+DEMDEC 
> disabled (0x01) or 48kHz (0x03). There should be a possibility to set 44.1kHz 
> (0x02) too, but it is not used.

NCIAM is digital audio at SSIF and locked with 32kHz sample size to
video at broadcast level. Needs DEMDEC/SIF input to the NICAM decoder.

DemDec is demodulation decoding/decimation at SIF level using
appropriate filters etc. to recover the audio subcarriers. Type of audio
is signaled by pilot tones. In saa7134-tvaudio runs a kernelthread for
auto detecting the type of broadcast. It is different for saa7134 and
saa7133/35/31e. The saa7133 for System M can do only 32kHz from SIF for
sure and that is one more reason for your patch.

> One of the lines (LINE1/LINE2) captures the radio, but the radio requires 
> 32kHz (it is the LINE1/LINE2 branch in code - it uses mode 0x01, I don't know 
> if the mode 0x00 can be used).

Radio stereo sound comes from the tuners to one of the LINE in pairs.
The saa7133/35/31e can decode also the radio IF, but a different radio
IF filter at 7.5 MHz is used. We do this on cards having amux TV for
radio. The saa7134 can't do that. The saa7130 can also not decode TV
sound from SIF input and has only mono from tuners.

> I tried to use the 48kHz for the composite input (digital camera) and it 
> doesn't work for me too.

:(

On saa7134-oss rate=48000 was an insmod option and propagated through
put_user. If an app calls for 48000 on saa7134-alsa it seems to do
exactly nothing. 

That 0x02 44.1 kHz was left away, likely has a very simple explanation.
You can down sample easily by software to it. One can also up sample
from 32 kHz, but that will of course not add the missing spectrum.

> The rest is covered in a big cloud, I don't know much about DMA programming 
> nor about the SAA713x programming. The document is not clear to me, it has a 
> lot of tables and not much text in between.

You seem to have the more interesting part of the documentation and
after Gerd Hartmut had the NDAs and did the fixes, currently not active,
but since very old, it also might contain bugs.

> But if the frequency other than 32kHz simply doesn't work, ALSA should report 
> only 32kHz (at least for now). I can provide a simple patch for that, if 
> nobody complains.

All fine, but we should not start to hide bugs/uncertainties we obviously have.

So, until then, for me it seems better to keep it buggy for now.

Cheers,
Hermann
 

