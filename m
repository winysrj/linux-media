Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:53544 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbZAZXYo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jan 2009 18:24:44 -0500
Received: by ey-out-2122.google.com with SMTP id 22so1362493eye.37
        for <linux-media@vger.kernel.org>; Mon, 26 Jan 2009 15:24:42 -0800 (PST)
Date: Tue, 27 Jan 2009 00:24:33 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Christoph Pfister <christophpfister@gmail.com>
cc: linux-media@vger.kernel.org,
	DVB mailin' list wozzit <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Upcoming DVB-T channel changes for HH (Hamburg)
In-Reply-To: <19a3b7a80901261228v393f5fcbv7559b573c0ca1539@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0901262214200.15738@ybpnyubfg.ybpnyqbznva>
References: <alpine.DEB.2.00.0901231745330.15516@ybpnyubfg.ybpnyqbznva> <497A27F7.8020201@to-st.de> <alpine.DEB.2.00.0901232241530.15738@ybpnyubfg.ybpnyqbznva> <19a3b7a80901261228v393f5fcbv7559b573c0ca1539@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 26 Jan 2009, Christoph Pfister wrote:

> > On Fri, 23 Jan 2009, Tobias Stöber wrote:
> >> There is a complete listing including parameters from "in area" and also
> >> "out of area" (but with reception in the area) transmitters at
> >> http://www.ueberallfernsehen.de/data/senderliste_25_11_2008.pdf

> I've quickly built a collection of scan files according to this
> document - do you mind having a look at them (although the change that
> will happen in Hamburg sometime and possibly other changes that
> happened since 25th November aren't considered yet)?

Certainly.

Just as a background, for the one or zero persons who care,
the situation in germany can be vaguely described thus:

There exist national public service, regional public service,
national/regional private commercial, and local broadcasters.

In general, the local and private broadcasters focus their
attention on large markets (Berlin, Frankfurt/Main, Hamburg,
München, and so on), and are not to be found so much outside
these limited regions -- with exceptions, like in Oberbayern
from the Wendelstein, but while the public service broadcasters
have a remit to reach the general population, the private
broadcasters have chosen to focus their financial investment
in those markets where they can reach a larger audience
share for little investment.  That is, the RTL and Pro7Sat1
families can be seen in, say, Hamburg, but far from these
metro areas, you are pretty much limited to a subset of the
public broadcasters.


Of the national and regional public broadcasters, the DVB-T
situation can be pretty much described as thusly...

There is a truly national broadcaster, the second german
broadcaster, ZDF, which has a multiplex known as ZDFmobil
which is available nationally, and is identical whether
received in Flensburg or Passau (hey, no heckling, that was
a beloved train ride for me years ago).

The other nominally national broadcaster, ARD, known as the
first german broadcaster ("Das Erste"), suffers regionalisation
both through a local identity in a particular Bundesland,
as well as a regional DVB-T multiplex management that does
not always translate well to match those of neighbouring
lands.

This regionalisation is due to sub-management by a third
party, which, perhaps as a super-regional manager, is
responsible for more than one Bundesland (for our original
case of Hamburg, this would be NDR, together with its
daughter Radio Bremen).  These `third parties' taken
together form that first german broadcaster, as well as
having their own distinct regional identities.


The practical example of this would be that while one
can see the same content via ZDFmobil anywhere, the
so-called ARD multiplex may contain, by region, EinsPlus
or EinsFestival, or perhaps in that region, that regional
manager's so-called ``Dritte'' (third, after ARD being
first and ZDF being second) programme.


In other words, nationally, one can receive the ZDF
multiplex, plus two others, which will depend on how
the regional management has decided to configure their
multiplexes.  Services such as Phoenix and `arte' will
be available nationally, while the `dritte' multiplex
will contain a selection of out-of-area regionals of
interest due to geography or whatever.


Now, while ZDF has a unified national service, the same
is not necessarily true for what you can receive in
a selected Bundesland.  For example, in Hessen, depending
on where you are, you may be able to receive the local
programming from the nearest Bundesland; in the south
of Bayern you can see SWR Baden-Württemberg but temporarily
not Hessen (or the DVB-H which replaced it), while in
the north you will instead see `mdr', although you may
have previously received SWR, which is the reason that
Bad Mergentheim in BaWü, near the border, will need its
own DVB-T transmitter sometime this year.


Now, anyway, for the zero readers who care, that's my
summary of german public broadcasters approach to DVB-T.
I'm happy to be corrected, because I'm an outsider.


So, anyway, there's been forces to cause merging of the
different regional broadcasters; NDR covers several
Bundesländer, with Radio Bremen retaining a bit of
independence; SWR has engulfed SWF and pretty-much-
identical-save-for-a-few-half-hour-bits-here-and-there
programming can be seen on SWR-RP, SWR-BW, and even
SR from the Saarland.  This can probably be seen by
looking at the different frequency plans, although I
am too lazy and disinterested to do so now.  Anyway,
the Genève frequency allocations look to be based on
geographical locations, independent of the regional
broadcast administrator responsible.


What am I saying by all this tripe?  Well, there is a
regional frequency allocation that is presently used
by the public service broadcasters, but so far has
seen spotty adoption by the local and commercial
broadcasters apart from a handful of larger metro
regions, leaving most of the land by area dependent
upon satellite reception for these programmes.


Anyway, now that I have digressed in an attempt to
show that I can claim to know what I'm talking about
even after a few beers, here's my feedback:

The following seems wrong, because of the problem I
noted in the message to which you replied:

# DVB-T Hamburg
# Created from http://ueberallfernsehen.de/data/dvb-t_deutschland_stand_25.11.08.pdf
# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
T 205500000 8MHz 3/4 NONE QAM16 8k 1/8 NONE
T 490000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
T 490000000 8MHz 2/3 NONE QAM16 8k 1/8 NONE
T 530000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
T 546000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
T 546000000 8MHz 2/3 NONE QAM16 8k 1/8 NONE
T 570000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
T 570000000 8MHz 2/3 NONE QAM16 8k 1/8 NONE
T 626000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
T 626000000 8MHz 2/3 NONE QAM16 8k 1/8 NONE
T 674000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
T 674000000 8MHz 2/3 NONE QAM16 8k 1/8 NONE
T 754000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE

You should notice the duplicated frequencies but with
differing guard interval values.  I suspect that 1/8
is correct for a few more weeks at the single VHF
frequency, but I believe that 1/4 is the correct
value for all duplicated UHF frequencies.

In Niedersachsen, this frequency value leaped out at
me as being wrong:

T 563000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE


These problems are no doubt due to errors in the
original source from which you snarfed the data.
I suppose I could write a mail to be ignored to the
responsible parties...


As an end-user (fnarr), some feedback:

I find comments including consumer-channel-number
very helpful, particularly when correct, so that I
don't have to refer to a lookup table when comparing
a particular scanfile to press releases or other
consumer-focussed propaganda, given that these almost
exclusively give only the channel number.  That is,
grabbing a random file, and pardon any linewrap...

T 538000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE # CH29: ARD Das Erste, 
EinsFestival, arte, Phoenix (TSMB/MDR1.1)
T 546000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE # CH30: 3sat, 
ZDFDoku/KIKA, ZDF, ZDFInfo (ZDF)
T 578000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE # CH34: MDR S-ANHALT, 
rbb Brandenburg, WDR Koeln, NDR FS NDS (TSMB/MDR2.2)

...the listed channel numbers complement the frequency
information and match the majority of what I would
find online or in print media.


Now, as far as changes since Nov.2008, when a good number
of government drones were running about proclaiming that
the digital switchover was complete, well, they weren't
quite right, but anyhow...

There haven't been, as far as I know, any changes since
november.  There are planned changes to one multiplex
frequency in Aalen (BW) and introduction of a new DVB-T
site in Bad Mergentheim (BW) and Garmisch-Partenkirchen
(BY), if not more, and eventually, abandoning present
VHF frequencies, seen in Berlin, parts of Bayern, and as
noted, Hamburg, for example.


If I ever get around to a more detailed study of each
Bundesland, I'll offer more feedback, although I haven't
received any concerning my proposed enhancements to B-W
some months ago, so it may not matter...


Anyway, thanks for your work in merging these; that has
cut out a good bit of time I'd spend doing this by hand.


barry bouwsma
loser
