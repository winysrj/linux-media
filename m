Return-path: <linux-media-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:62901 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbZA2Nt0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 08:49:26 -0500
Received: by ug-out-1314.google.com with SMTP id 39so376790ugf.37
        for <linux-media@vger.kernel.org>; Thu, 29 Jan 2009 05:49:22 -0800 (PST)
Date: Thu, 29 Jan 2009 14:48:29 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Christoph Pfister <christophpfister@gmail.com>
cc: linux-media@vger.kernel.org, Tobias Stoeber <tobi@to-st.de>,
	DVB mailin' list thingy <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Upcoming DVB-T channel changes for HH (Hamburg)
In-Reply-To: <19a3b7a80901290232p3b2dd1a1y42f7276dedfebf43@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0901291222020.11385@ybpnyubfg.ybpnyqbznva>
References: <alpine.DEB.2.00.0901231745330.15516@ybpnyubfg.ybpnyqbznva>  <497A27F7.8020201@to-st.de>  <alpine.DEB.2.00.0901232241530.15738@ybpnyubfg.ybpnyqbznva>  <19a3b7a80901261228v393f5fcbv7559b573c0ca1539@mail.gmail.com>  <alpine.DEB.2.00.0901262214200.15738@ybpnyubfg.ybpnyqbznva>
  <497EC855.7050301@to-st.de>  <19a3b7a80901270237n761240bbn2627f782ddbffa29@mail.gmail.com>  <497EF972.6090207@to-st.de>  <alpine.DEB.2.00.0901271748160.15738@ybpnyubfg.ybpnyqbznva> <19a3b7a80901290232p3b2dd1a1y42f7276dedfebf43@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 29 Jan 2009, Christoph Pfister wrote:

> > I intend to take Christoph's files and massage them to add
> > bits of info, reviewing the info by hand, adding missing info

> I don't mind adding those further bits. They need to be after the main
> block in the file, so that they don't get overwritten when those files
> are updated e.g. because of a new pdf.

Hmm, actually, the first thing I was planning to do would be
to sort the entries by, for lack of a better term, provider.
That is, roughly, ARD multiplex when appropriate, ZDFmobil,
and regional Dritte multiplex everywhere, and in selected
regions, the remaining of the seven assigned GE06 allocations
or, in short, private providers.

This is intended to provide an overview of these allocations
and the particular sites where they can be found, as well as
to handle the potential cases of frequency re-use in widely-
separated areas between two muxes with incompatible
parameters -- how often this will occur, I cannot say, as I
do not yet have a complete overview.

This also can help the case of Tobi, who would prefer to use
two or three transmitter-site files, in that it would be easy
to see which frequencies would be ``local'' (shades of Royston
Vasey here, ``You'll Never Leave'').

But I'm not sure how well this would work with a PDF-skimming
application...


As a concrete example, what I would create, would look like:

# DVB-T Sachsen-Anhalt
# Created from http://www.ueberallfernsehen.de/data/senderliste_25_11_2008.pdf
# mercilessly mangled by hand, please file in /dev/null
# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy

### ZDFmobil multiplex; E22, E30, E31
T 482000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE # CH22 Halle
T 546000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE # CH30 Brocken, Magdeburg, Wittenberg
T 554000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE # CH31 Dequede

### MDR-S-A multiplex; E34, E35, E38
T 578000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE # CH34 Brocken, Dequede, Magdeburg
T 586000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE # CH35 Halle
T 610000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE # CH38 Wittenberg

### ARD multiplex; E24, E29, E41
T 498000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE # CH24 Halle, Wittenberg
T 538000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE # CH29 Brocken, Magdeburg
T 634000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE # CH41 Dequede

(This also can make it somewhat more 80-column-friendly, for
at least some regions)


Tobi, if I may ask you -- I have seen use made of, for example,
`K21' in german web fora to refer to the frequency spanned by
470 to 478MHz, while in swiss web fora, I often see `E21' for
the same.  I know that `K' can be both seen as `Kanal' (channel)
and `Kabel' (cable), while I would guess that `E' refers to
Europe, to differ the 8MHz spacing from that of, say, Australia
or some other land whose name I can't remember but which sort
of features prominently in parts of Thee Interweb.

But in my experience, cable-TV frequencies by channel number
do not always match over-the-air frequencies for that channel.
Are you familiar with the `E' usage, can you tell me if there
is an accepted international usage that covers all languages,
as my attempts to search `e' in g00gle were not impressive...

Thanks...


Anyway, with the above, after I pull out a map, I can say,
oh, this group of transmitters (probably) forms a SFN for
ZDF, and that group covers mdr, and so on.  That overview
was one of the things I was trying to obtain earlier, and
will be when I really work on Sachsen-Anhalt.


And to Christoph, the danger, as I'm sure you know, of
pulling from a PDF or other single source of information,
is that those will not always be infallible, as we've seen
with a centre-frequency ending in `3' and paste-errors
for Hamburg between VHF and UHF parameters, as well as
absent info for the specific cases of the frequency change
in HH; or for BW, the change planned for Aalen plus the
to-be-in-service status of Bad Mergentheim.

I suppose I ought to write the originator of the PDF to
point out errors, but I suspect I'll get at best a reply
from TV Licensing saying they have no record of me in
their database and that as a non-resident, I have no
grounds for criticism of their offering and I should
stick to the programmes for which I pay the license fee.
(How else can I explain the years-running errors in
linking of teletext pages, that are again changed to
errors when those pages are relocated?  ZDF, I'm looking
at you for failing to list your extended programme guide
following ttx page 380...)



Oops, off-topic again.


> They shouldn't be too excessive,

Oh dear.  The question is, how do I skate the thin line
between providing too much information, and failing to
include useful information?  I guess, it depends on your
interest.  If all you care about are just the frequencies,
and if I were to say to you `ERP' you would say, ``Oh, do
excuse yourself, you glutton'', then the existing files are
fine.  But if you need transmitter sites and info to
help you orient whatever antenna you use, or are otherwise
technically inclined, then perhaps I do not provide enough
info...  I'll have to rely on the feedback of others for
this, sad to say, being myself a technical geek...


> but for example I prefer if you add the Leipzip transponder
> to the de-whatever file instead of creating a new de-Leipzig file, so

No worries, I'd add additional information to both the
appropriate Bundesland, as well as to de-Leipzig.  Wait,
I just updated overnight, and de-Leipzig no longer exists!
Aieee!@  Good thing I made a backup copy of that directory
before I updated


> this point shouldn't cause trouble to you. People don't have to scan
> every day, so it doesn't hurt if the scan time is increased by some

Another thing  that I don't include is the precise channel
layout, as this can churn over time -- particularly with the
private local (non-RTL/Pro7Sat1) multiplexes, as participants
drop out, go bankrupt, lose their licenses, or whatever; or
when a national or regional PSB makes small adjustments.

After all, the results of the scan, if correct, will show
who is present...

Of course, terms such as `ZDFmobil' may not immediately
ring bells with the general public as including 3sat, or
`arte' typically meaning the ARD multiplex, but these may
be the same people who complain they can't see their quiz
call-in shows on the ARD mux, and they know that next time
they will win for sure, guaranteed, if they can stop staring
at the topless announcer long enough to dial the number which
will cost just as much as the last thousands of times they
tried that week...



Ah yes, looking at Bayern, there is an overlap between
the uncommon private multiplexes.  I've read that Pro7Sat1
is considering ways to increase bitrate to make available
AC3 audio together with higher quality video; this may be
a switch to 64QAM, a reduction of the guard interval, or
lowering the FEC error correction, which would make those
parameters incompatible with the others -- and I'll need
to manually add the transmitting sites to get an overview
of where it can be received.


Anyway, many thanks to Christoph for merging that info
into convenient files, and I'll post -- if only for the
benefit of the zero who care -- the fascinating info that
I can find based on that.


barry bouwsma
still writes too much, about nothing
