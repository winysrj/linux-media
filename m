Return-path: <linux-media-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:4564 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbZAWKZ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2009 05:25:28 -0500
Received: by ug-out-1314.google.com with SMTP id 39so613105ugf.37
        for <linux-media@vger.kernel.org>; Fri, 23 Jan 2009 02:25:25 -0800 (PST)
Date: Fri, 23 Jan 2009 11:25:16 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Daniel Dalton <d.dalton@iinet.net.au>
cc: linux-media@vger.kernel.org,
	DVB mailin' list thingy <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] getting started with msi tv card
In-Reply-To: <alpine.DEB.2.00.0901222327370.13623@ybpnyubfg.ybpnyqbznva>
Message-ID: <alpine.DEB.2.00.0901230956260.13623@ybpnyubfg.ybpnyqbznva>
References: <20090120091952.GB6792@debian-hp.lan> <4975B5F1.7000306@iki.fi> <20090120220701.GB4150@debian-hp.lan> <49765448.8060108@iki.fi> <20090121003915.GA6120@debian-hp.lan> <4977088F.5080505@iki.fi> <20090122092844.GB14123@debian-hp.lan>
 <alpine.DEB.2.00.0901222327370.13623@ybpnyubfg.ybpnyqbznva>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

G'day Daniel, I just came up with a couple more ideas that
could be worth mentioning, that you can keep in mind for the
future...

On Fri, 23 Jan 2009, BOUWSMA Barry wrote:

> The other output format is `pids', and here's that from
> back in 2006, before the use of the second audio channel
> on the german broadcasters became widespread (last year):
> 
> ZDF                      (0x6d66) 01: PCR == V   V 0x006e A 0x0078  \
> (deu) 0x0079 (2ch) TT 0x0082 AC3 0x007d
> 
> Here PID 0x79 is tagged as `2ch' (it's NAR for the Beeb),
> and covers both audiodescription and occasional original-
> language (mostly english language) broadcasts without
> overdubbing.  This was before DVB subtitles were introduced.
> 
> Oh, here's an old BBC `pids' output, also including subtitles:
> 
> BBC 1 London             (0x189d) 01: PCR == V   V 0x1388 A 0x1389  \
> (eng) 0x138a (NAR) TT 0x138b SUB 0x138c

Now, I want to mention in detail the TT (teletext) and SUB
(subtitle) services, at least, how they are implemented in
this part of europe -- other parts of the world will likely
be different, but my purpose is to throw around ideas in the
hope that something will stick to the ceiling and be interesting
and possibly useful.

I mentioned that I find the nearly 100% penetration of subtitles
to be quite useful to me personally, although it and in-field
signing are intended for people whose hearing is not so good
as mine, but whose vision is intact.

The subtitles are sent in both a selected teletext page, as
well as a separate DVB-subtitle stream.  Unfortunately, the
support that `mplayer' has for DVB subtitles last I knew, is,
well, bad to none, and basically requires completely rewriting
that bit.  `xine' worked better some months ago, but at that
time had some timing problems.

Anyway, as I understand it, DVB subtitles are sent as bitmaps,
which unfortunately makes it difficult for you to use them.
This also explains the difference in appearance between the
BBC subtitles and those of ITV.  However, I haven't seen
mangled fonts due to transmission errors, while I have seen
incorrect yet properly-formed characters at times.  So my
understanding of DVB subtitles is far from complete or correct.


Standard teletext, as was introduced with analogue transmissions
as part of the vertical blanking interval, has been carried
over to DVB broadcasts.  In the case of the BBC, this is mostly
limited to subtitles on page 888, while the german services I've
mentioned offer full text services, occasionally including
subtitles, but on a limited set of programmes.  Only the ZDF
has both teletext and DVB subtitles at present, of the german
public broadcasters.  These DVB subtitle fonts again differ in
appearance from any of the british public broadcasters.

In the UK, the move has been away from conventional teletext
with the introduction of digital services, replacing it with
an MHEG-based service.  In germany, there has been a push to
supplement regular teletext with an MHP-based service, but for
lack of interest and readily-available hardware, this has
pretty much died out or stagnated.

I seem to recall that in Australia, use is made of an MHEG
service.  I don't know if a regular teletext service is
available -- you will see this in the results, when you have
a tuner capable of scanning.


Now, ideally, a teletext service, being text-based, can be
trivially converted to braille or spoken.  I'm not sure about
the MHEG services, as they seem to place more importance on
the on-screen appearance, yet they do use a TrueType font.

Anyway, while conventional teletext is not simple ASCII-like,
it is based on a hamming of a limited character set which can
be converted back to a standard 128- or 256-character set
font, and of course the normal characters can be displayed as
braille.

Now, here is an example of some of the useful information
to be found on a full teletext service, to show that, if it
were available to you, you might find it interesting.  This
is a page giving inter-bank exchange rates from the Euro to
your own currency, and is meant as an example (it's in german,
but should be trivial to understand)

                    /GIP  IG*** PHOENIX Mi 21.01.09 18:01:45
                         PHOENIX.text                   2/2
                         Devisenkurse
                     Letzte Datenabfrage        Diff.  Kurs-
                     21.01.09, 18:00 Uhr        Vortag zeit

                     USA....... (USD)   1,2857  -0,20% 17:59
                     GB........ (GBP)   0,9369  +0,94% 17:59
                     Schweiz... (CHF)   1,4767  -0,13% 17:59
                     Japan..... (JPY) 112,9800  -2,35% 17:59

                     Kanada.... (CAD)   1,6365  +0,37% 17:59
                     Südafrika. (ZAR)  13,0970  -1,05% 17:50
                     Hongkong.. (HKD)   9,9990  +0,07% 17:49
                     Singapur.. (SGD)   1,9401  -0,13% 17:50
                     Australien (AUD)   1,9804  -0,23% 17:59
                     Neuseeland (NZD)   2,4637  -0,78% 17:49
                     Indien.... (INR)  63,3633  +0,36% 17:49
                     China..... (CNY)   8,8013  +0,03% 17:15
                     Mexiko.... (MXN)  17,9189  -0,85% 17:49
                     Argentin.. (ARS)   4,4618  +0,33% 17:16
                     Brasilien. (BRL)   3,0380  -0,73% 17:54

                                             Sortenkurse ->

(reproduced without permission, sorry)

Unfortunately, relatively few programmes are sent with any
subtitles, and I'm having to dig deeply in my snapshots of
teletext pages to find an example I can show, instead of
                    //   X G*** PHOENIX Mi 21.01.09 18:01:38
                                        KEINE UNTERTITEL
(no subtitles)


More unfortunately, I've just verified that my utility is not
recognizing and writing to disk the subtitles that are currently
being broadcast on page 150 by one particular broadcaster, so it's 
back to the coding for me...  Meaning, I can't paste an example here.

However, my point is that if this type of service is broadcast
in your area, you may find it interesting and useful, as you
would be able to make use of the text content within.


Just an idea which I had...



By the way, I don't know how foreign non-english-language films
would be handled by your broadcasters.  In general, the text-
based subtitles are not sent when there are on-screen subtitles,
for example, when the BBC screens a film in its native language
and subtitles.  That means that, for example, the film ``Lola
Rennt'' was sent out with the primary audio channel containing
the original german, and no teletext subtitles, with the
translation into english appearing as part of the video
signal, meaning that you can't make use of it, nor could you
make use of the audio (if you understand german, then substitute
french, portuguese, japanese, or some other language which has
been broadcast as original-with-subtitles).  Other broadcasters
tend to dub everything of serious commercial value into the
native language with the same limited number of voice talent,
so the issue of original audio versus subtitles doesn't come up.
The cultural channel `arte' is somewhat an exception, where via
the different satellite positions you might find dubbed german,
dubbed french, and original english, subtitles in french or
german, or original language broadcasts in the `trash' series
of cinematic gems with on-screen subtitles in either french or
german, keeping out those audience members unable to understand
the original and unable to see the on-screen subtitles...


barry bouwsma
