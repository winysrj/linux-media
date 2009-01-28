Return-path: <linux-media-owner@vger.kernel.org>
Received: from ayden.softclick-it.de ([217.160.202.102]:34608 "EHLO
	ayden.softclick-it.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbZA1MyT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2009 07:54:19 -0500
Message-ID: <498055A4.2090106@to-st.de>
Date: Wed, 28 Jan 2009 13:55:00 +0100
From: Tobias Stoeber <tobi@to-st.de>
Reply-To: tobi@to-st.de
MIME-Version: 1.0
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
CC: linux-media@vger.kernel.org,
	"DVB mailin' list thingy" <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Upcoming DVB-T channel changes for HH (Hamburg)
References: <alpine.DEB.2.00.0901231745330.15516@ybpnyubfg.ybpnyqbznva> <497A27F7.8020201@to-st.de> <alpine.DEB.2.00.0901232241530.15738@ybpnyubfg.ybpnyqbznva> <19a3b7a80901261228v393f5fcbv7559b573c0ca1539@mail.gmail.com> <alpine.DEB.2.00.0901262214200.15738@ybpnyubfg.ybpnyqbznva> <497EC855.7050301@to-st.de> <19a3b7a80901270237n761240bbn2627f782ddbffa29@mail.gmail.com> <497EF972.6090207@to-st.de> <alpine.DEB.2.00.0901271748160.15738@ybpnyubfg.ybpnyqbznva>
In-Reply-To: <alpine.DEB.2.00.0901271748160.15738@ybpnyubfg.ybpnyqbznva>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

BOUWSMA Barry schrieb:
>>It's just a centre frequency used for tuning purposes. The DVB-T signal 
>>should (ideally) use a 8 MHz width space from 559.25 MHz to 567.25 MHz 
>>for Ch 32.
> 
> Is this correct, or should the range be from 558 to 566MHz,
> apart from locations (such as the UK and Australia) where an
> offset may be used?

Well, you may be right ... I recalled that from former norms (analogue) 
and the fact, that the digital channels were expected to use the 
existing boundaries.

Looking at e.g.

http://www.kathrein.de/en/hfc/techn-infos/download/TA-163-164.pdf

it seems, that you are correct (or how to you read the info in the pdf?).

> I'd assume the 1,25MHz offset you list is due to the use of
> analogue suppressed sideband, where the actual carrier to
> be modulated would be, for E21: 21   471.250; the sound
> carrier at some offset to this which I don't remember, not
> having interest much in the many different analogue norms...

Yes, see above.

>>Looking through your files in the zip archive, it rose some questions in 
>>my mind:
>>
>>a) is it really useful to have scan files by federal state (Bundesland)?
> 
> Maybe.  It's better, in my mind, than the existing case of
> individual sites, which again, may or may not cover the case
> of nearby areas.

Well, the old style of de-transmitter_region scan file had the charme, 
that it is easier (at least for me) to select the transmitter sites in 
my direct surrounding and I've no real use of de-federal_state.

Take a large geographical area like Niedersachsen, so you come to the 
conclusion, that in most areas you won't need the overwhelming majority 
of entries in de-Niedersachsen (because transmitters are to far away), 
but you will in most cases need entries from the de-federal_state files.

But don't mind. The work of Christoph to generate de-federal_state files 
(from quite recent data) will help a lot, because some of 
de-transmitter_region where a bit outdated or not present at all.

> I'm trying to decide if a de-all type of file would make any
> sense, and how to go about it, because I'm dissatisfied with
> the current state of de-Wherever files.

Hmmm.... :-/

> I've posted in the past my suggestion for a de-BW file, made
> by hand, which tries to address this issue, as well as provide
> an overview for anyone trying to make sense of the frequencies
> and broadcast policies, as well as to help with antenna
> orientation, towerspotting, or anything else that might interest
> me, in a single location.
> 
> Have you seen this file?  If not, would you care to find it in
> the archives (or I'll mail you a copy) and tell me what you
> think of it?

Well, I had to look in may list archive, but did find it (your posting 
from 02 Dec 2008). First, I looks like a lot of wrok, especially because 
  this area not only benefits from other federal staes but also from 
France and Switzerland.

>>=> I personally would prefer to stay with or alternatively provide a 
>>region based file, so I could look up and combine the regions of 
>>interest. What do you think?
> 
> A Bundesland-based set of files is a region-based set, or can
> you better describe the regions you are thinking of?  In any
> case, due to the nature of overlap, there will always be edge
> cases regardless of region, bar island nations or those where
> penetration is not aimed at close to 100%...

I actually meant scan files for specific DVB-T region like de-Berlin, 
de-Munich, de-Nuernberg etc.

> For cases like this, I don't know if it's better to have
> a separate de-Leipzig file as today, plus something covering
> a larger region.  I would argue the case for keeping, say,
> de-Stuttgart but losing everything else in favour of de-BW;
> however, at least two locations there do not just list the
> local transmitter frequencies (Ravensburg and Mannheim) but list
> out-of-Bundesland frequencies (the Privates from FFM for the
> latter, and austrian and maybe swiss frequencies receivable
> around the Bodensee in the former).

In case of Leipzig this is certainly true and there may be other regions 
where there are some "special cases".

> But that's just my idea, and really, I would like to hear
> what you think of the contents of my de-BW file, as the
> single bit of feedback I got on it was negative.

Well, as a (mostly?) complete collection of all transmitting sites that 
could possibly be received, it's good work, that I would appreciate.

On the other hand, I am not so good in geography, so that I would have 
to use some sort of map to find out, what distances are between my 
location in Baden-Wuerttemberg (lets for instance say Ulm or Biberach) 
and the out of area sites. I would say, that for Biberach additonally 
sites from Bavaria (Bayern) or Switzerland may be correct.

I like it, could imagine to do a similar file at least for my Bundesland.

Interestingly you also list the height above see level and antenne 
height of the BW sites.

Ideally one would have the data, which ist displayed in the "reception 
forecast" maps (say location and technical data of transmitters sites + 
reception borders for indoor / outdoor / roof antenna) and about the 
topography, so that one could estimate for a given geographical location 
(retrieved by GPS or from a map oder Google), which transmitters may be 
in reach. ;o)

But I don't think, we will ever come up with the "definite" solution. A 
full auto-scan certainly really reveals, what is actually "receivable" 
... a more specific scan file will shorten scan time. In between there a 
not many solutions.

There are indeed so many factors in real life, that play a role 
regarding DVB-T reception (and scanning), like type and placement of 
antenna, sensitivity of the tuner etc. ... which are in fact not a 
problem of either auto scan nor a scan file  :-/

What a frustrating situation, isn't it? :o(

Best regards, Tobias

