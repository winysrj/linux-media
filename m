Return-path: <linux-media-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:40222 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbZA0Qu6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 11:50:58 -0500
Received: by ug-out-1314.google.com with SMTP id 39so235476ugf.37
        for <linux-media@vger.kernel.org>; Tue, 27 Jan 2009 08:50:56 -0800 (PST)
Date: Tue, 27 Jan 2009 17:50:44 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Tobias Stoeber <tobi@to-st.de>
cc: linux-media@vger.kernel.org,
	DVB mailin' list thingy <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Upcoming DVB-T channel changes for HH (Hamburg)
In-Reply-To: <497EF972.6090207@to-st.de>
Message-ID: <alpine.DEB.2.00.0901271748160.15738@ybpnyubfg.ybpnyqbznva>
References: <alpine.DEB.2.00.0901231745330.15516@ybpnyubfg.ybpnyqbznva> <497A27F7.8020201@to-st.de> <alpine.DEB.2.00.0901232241530.15738@ybpnyubfg.ybpnyqbznva> <19a3b7a80901261228v393f5fcbv7559b573c0ca1539@mail.gmail.com> <alpine.DEB.2.00.0901262214200.15738@ybpnyubfg.ybpnyqbznva>
 <497EC855.7050301@to-st.de> <19a3b7a80901270237n761240bbn2627f782ddbffa29@mail.gmail.com> <497EF972.6090207@to-st.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Salü, Tobias...

On Tue, 27 Jan 2009, Tobias Stoeber wrote:

> You are right. 562 MHz as nominal frequency is correct, because for 

> It's just a centre frequency used for tuning purposes. The DVB-T signal 
> should (ideally) use a 8 MHz width space from 559.25 MHz to 567.25 MHz 
> for Ch 32.

Is this correct, or should the range be from 558 to 566MHz,
apart from locations (such as the UK and Australia) where an
offset may be used?

I'd assume the 1,25MHz offset you list is due to the use of
analogue suppressed sideband, where the actual carrier to
be modulated would be, for E21: 21   471.250; the sound
carrier at some offset to this which I don't remember, not
having interest much in the many different analogue norms...


> Looking through your files in the zip archive, it rose some questions in 
> my mind:
> 
> a) is it really useful to have scan files by federal state (Bundesland)?

Maybe.  It's better, in my mind, than the existing case of
individual sites, which again, may or may not cover the case
of nearby areas.

I'm trying to decide if a de-all type of file would make any
sense, and how to go about it, because I'm dissatisfied with
the current state of de-Wherever files.

In the case of ch-all, it makes sense, because it's a simple
case of generally a single multiplex per language region, based
on the GE06 frequency allocations, in a smaller geographic area.


> Just let me explain with an example. I live in Sachsen-Anhalt on the 
> north of the Harz Mountains area. To effectivly ("best") use DVB-T I do 
> combine both transmitters in Sachsen-Anhalt (Mt. Brocken) and from 
> Niedersachsen (Braunschweig). This is because some channels are only 

I've posted in the past my suggestion for a de-BW file, made
by hand, which tries to address this issue, as well as provide
an overview for anyone trying to make sense of the frequencies
and broadcast policies, as well as to help with antenna
orientation, towerspotting, or anything else that might interest
me, in a single location.

Have you seen this file?  If not, would you care to find it in
the archives (or I'll mail you a copy) and tell me what you
think of it?


> => I personally would prefer to stay with or alternatively provide a 
> region based file, so I could look up and combine the regions of 
> interest. What do you think?

A Bundesland-based set of files is a region-based set, or can
you better describe the regions you are thinking of?  In any
case, due to the nature of overlap, there will always be edge
cases regardless of region, bar island nations or those where
penetration is not aimed at close to 100%...

The division by Bundesland works also because of different
management in each Land, which plays out in channel assignments,
SFNs, and common use of a particular modulation, I am seeing by
the overview presented in the first pdf file.


> b) Conflicting information
> 
> In your "Sachsen-Anhalt" scanfile you list on Ch 24 the ARD multiplex 
> with (Halle-Stadt):
> 
> T 498000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
> # CH24: Das Erste, arte, Phoenix, EinsFestival
> 
> which is for a large part of Sachsen-Anhalt useless (we can't receive 
> that), as we actually receive on Ch 24 (from Braunschweig)
> 
> T 498000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
> # CH24: RTL, RTL II, Super RTL, VOX

I intend to take Christoph's files and massage them to add
bits of info, reviewing the info by hand, adding missing info
and generally trying to come up with something like the BW
file I created.

But I want feedback about that file too, rather than to have
my changes be rejected after I've done the review and work.


> => Does it matter, e.g. would instead of the unreceivable Ch24 from 
> Halle-Stadt the Braunschweig Ch24 be found? (I did not test this).

This all depends on the device.  At least some of my tuners
effectively will lock a signal as if I've specified `AUTO'
in place of everything, even when what I specify is wrong.

In reality, when I've been in a new location and done a scan
without knowing transmitter site details, I've just used a
general purpose scanfile I've created which goes from 474 in
8MHz steps up to 850 or so, like
### Kanal 68 UHF
T 850000000 8MHz AUTO AUTO AUTO AUTO AUTO AUTO


> c) You clearly missed out some information. I noticed for instance Ch 37 
> in Leipzig (Sachsen) which is the "Leipzig 1" multiplex

> On the other hand I doubt, that it would be a useful entry into a 
> "Sachsen" scanfile because reception is limited to the area of the city 
> of Lepzig.

For cases like this, I don't know if it's better to have
a separate de-Leipzig file as today, plus something covering
a larger region.  I would argue the case for keeping, say,
de-Stuttgart but losing everything else in favour of de-BW;
however, at least two locations there do not just list the
local transmitter frequencies (Ravensburg and Mannheim) but list
out-of-Bundesland frequencies (the Privates from FFM for the
latter, and austrian and maybe swiss frequencies receivable
around the Bodensee in the former).

That is, for the largest well-known cities, go ahead and keep
them, simply because they are so large.  Also if their situation
includes something to make them unique, be it the presence of
private multiplexes or special projects, which so far would not
yet include Stuttgart.


But that's just my idea, and really, I would like to hear
what you think of the contents of my de-BW file, as the
single bit of feedback I got on it was negative.


Adé,
barry bowusma
maw, the innernet's broke again...
