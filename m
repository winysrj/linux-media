Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:32976 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbZBGSxc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Feb 2009 13:53:32 -0500
Received: by fg-out-1718.google.com with SMTP id 16so780447fgg.17
        for <linux-media@vger.kernel.org>; Sat, 07 Feb 2009 10:53:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0901291222020.11385@ybpnyubfg.ybpnyqbznva>
References: <alpine.DEB.2.00.0901231745330.15516@ybpnyubfg.ybpnyqbznva>
	 <alpine.DEB.2.00.0901232241530.15738@ybpnyubfg.ybpnyqbznva>
	 <19a3b7a80901261228v393f5fcbv7559b573c0ca1539@mail.gmail.com>
	 <alpine.DEB.2.00.0901262214200.15738@ybpnyubfg.ybpnyqbznva>
	 <497EC855.7050301@to-st.de>
	 <19a3b7a80901270237n761240bbn2627f782ddbffa29@mail.gmail.com>
	 <497EF972.6090207@to-st.de>
	 <alpine.DEB.2.00.0901271748160.15738@ybpnyubfg.ybpnyqbznva>
	 <19a3b7a80901290232p3b2dd1a1y42f7276dedfebf43@mail.gmail.com>
	 <alpine.DEB.2.00.0901291222020.11385@ybpnyubfg.ybpnyqbznva>
Date: Sat, 7 Feb 2009 19:53:30 +0100
Message-ID: <19a3b7a80902071053j2a428517vca07611cf16b882c@mail.gmail.com>
Subject: Re: [linux-dvb] Upcoming DVB-T channel changes for HH (Hamburg)
From: Christoph Pfister <christophpfister@gmail.com>
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
Cc: linux-media@vger.kernel.org, Tobias Stoeber <tobi@to-st.de>,
	"DVB mailin' list thingy" <linux-dvb@linuxtv.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry for the late answer,

2009/1/29 BOUWSMA Barry <freebeer.bouwsma@gmail.com>:
> On Thu, 29 Jan 2009, Christoph Pfister wrote:
>
>> > I intend to take Christoph's files and massage them to add
>> > bits of info, reviewing the info by hand, adding missing info
>
>> I don't mind adding those further bits. They need to be after the main
>> block in the file, so that they don't get overwritten when those files
>> are updated e.g. because of a new pdf.
>
> Hmm, actually, the first thing I was planning to do would be
> to sort the entries by, for lack of a better term, provider.
> That is, roughly, ARD multiplex when appropriate, ZDFmobil,
> and regional Dritte multiplex everywhere, and in selected
> regions, the remaining of the seven assigned GE06 allocations
> or, in short, private providers.
>
> This is intended to provide an overview of these allocations
> and the particular sites where they can be found, as well as
> to handle the potential cases of frequency re-use in widely-
> separated areas between two muxes with incompatible
> parameters -- how often this will occur, I cannot say, as I
> do not yet have a complete overview.
>
> This also can help the case of Tobi, who would prefer to use
> two or three transmitter-site files, in that it would be easy
> to see which frequencies would be ``local'' (shades of Royston
> Vasey here, ``You'll Never Leave'').
>
> But I'm not sure how well this would work with a PDF-skimming
> application...

I see some possible ways to deal with this. The one I already
mentioned is to separate the auto-generated and the manual part of a
file. You could provide further information about the transmitters
with comments in the second part of the file. If you want to relax the
constraints, you could allow re-ordering of the transmitters either
within the auto-generated section or within the whole file (in this
case you need to mark the individual transmitters). Actually I don't
care about the arrangement, as long as there are machine-implementable
rules for the update.

<snip>

> And to Christoph, the danger, as I'm sure you know, of
> pulling from a PDF or other single source of information,
> is that those will not always be infallible, as we've seen
> with a centre-frequency ending in `3' and paste-errors
> for Hamburg between VHF and UHF parameters, as well as
> absent info for the specific cases of the frequency change
> in HH; or for BW, the change planned for Aalen plus the
> to-be-in-service status of Bad Mergentheim.

They've updated their file and the mapping between channel numbers and
frequencies are fixed. So I consider it as a good base point (I need
only some fractions of a second to generate updated files :), will
commit them soon). The additions are up to people who know more about
the story ...

> I suppose I ought to write the originator of the PDF to
> point out errors, but I suspect I'll get at best a reply
> from TV Licensing saying they have no record of me in
> their database and that as a non-resident, I have no
> grounds for criticism of their offering and I should
> stick to the programmes for which I pay the license fee.
> (How else can I explain the years-running errors in
> linking of teletext pages, that are again changed to
> errors when those pages are relocated?  ZDF, I'm looking
> at you for failing to list your extended programme guide
> following ttx page 380...)
>
>
>
> Oops, off-topic again.
>
>
>> They shouldn't be too excessive,

I meant the number of transmitters, not the size of the file.

> Oh dear.  The question is, how do I skate the thin line
> between providing too much information, and failing to
> include useful information?  I guess, it depends on your
> interest.  If all you care about are just the frequencies,
> and if I were to say to you `ERP' you would say, ``Oh, do
> excuse yourself, you glutton'', then the existing files are
> fine.  But if you need transmitter sites and info to
> help you orient whatever antenna you use, or are otherwise
> technically inclined, then perhaps I do not provide enough
> info...  I'll have to rely on the feedback of others for
> this, sad to say, being myself a technical geek...
>
>
>> but for example I prefer if you add the Leipzip transponder
>> to the de-whatever file instead of creating a new de-Leipzig file, so
>
> No worries, I'd add additional information to both the
> appropriate Bundesland, as well as to de-Leipzig.  Wait,
> I just updated overnight, and de-Leipzig no longer exists!
> Aieee!@  Good thing I made a backup copy of that directory
> before I updated

hg has a good memory as well :)

>> this point shouldn't cause trouble to you. People don't have to scan
>> every day, so it doesn't hurt if the scan time is increased by some
>
> Another thing  that I don't include is the precise channel
> layout, as this can churn over time -- particularly with the
> private local (non-RTL/Pro7Sat1) multiplexes, as participants
> drop out, go bankrupt, lose their licenses, or whatever; or
> when a national or regional PSB makes small adjustments.
>
> After all, the results of the scan, if correct, will show
> who is present...
>
> Of course, terms such as `ZDFmobil' may not immediately
> ring bells with the general public as including 3sat, or
> `arte' typically meaning the ARD multiplex, but these may
> be the same people who complain they can't see their quiz
> call-in shows on the ARD mux, and they know that next time
> they will win for sure, guaranteed, if they can stop staring
> at the topless announcer long enough to dial the number which
> will cost just as much as the last thousands of times they
> tried that week...
>
>
>
> Ah yes, looking at Bayern, there is an overlap between
> the uncommon private multiplexes.  I've read that Pro7Sat1
> is considering ways to increase bitrate to make available
> AC3 audio together with higher quality video; this may be
> a switch to 64QAM, a reduction of the guard interval, or
> lowering the FEC error correction, which would make those
> parameters incompatible with the others -- and I'll need
> to manually add the transmitting sites to get an overview
> of where it can be received.
>
>
> Anyway, many thanks to Christoph for merging that info
> into convenient files, and I'll post -- if only for the
> benefit of the zero who care -- the fascinating info that
> I can find based on that.
>
>
> barry bouwsma
> still writes too much, about nothing

Christoph
