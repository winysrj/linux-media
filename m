Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:52397 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbZCQDnC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 23:43:02 -0400
Received: by ewy25 with SMTP id 25so3716558ewy.37
        for <linux-media@vger.kernel.org>; Mon, 16 Mar 2009 20:42:59 -0700 (PDT)
Date: Tue, 17 Mar 2009 04:42:44 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: wk <handygewinnspiel@gmx.de>
cc: benjamin.zores@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] add new frequency table for Strasbourg, France
In-Reply-To: <49BEB20A.1030209@gmx.de>
Message-ID: <alpine.DEB.2.00.0903170237550.4176@ybpnyubfg.ybpnyqbznva>
References: <49BBEFC3.5070901@gmail.com> <alpine.DEB.2.00.0903160803030.4176@ybpnyubfg.ybpnyqbznva> <49BE9B50.5050506@gmail.com> <49BEB20A.1030209@gmx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 16 Mar 2009, wk wrote:

> Benjamin Zores wrote:
> > BOUWSMA Barry wrote:
> > 
> > > First, every frequency is given an offset from the nominal centre
> > > frequency of the 8MHz envelope.  I am aware this is common in the
> > > UK where the switchover is happening gradually so as not to
> > > interfere with adjacent analogue services, and I also know that
> > > last I checked, the number of french analogue services I could
> > > receive weakly had dropped, but at least one was still visible.
> > 
> > These were discovered through w_scan application.

Then there must be something ``wrong'' with `w_scan' making
incorrect assumptions about the data which it's parsing.

It would be too easy for me to look at the source of `w_scan'
and see what it might be doing wrong.  Too easy.  So of course,
I'd rather do something else, like look at the raw data it's
using -- the NIT data of the french muxen, in case there is
something within that being processed in error.

The fact that while germany makes much use of SFNs which need
to transmit coördinated frequencies and data, while each site
in france uses different frequencies from its neighbours,
would mean that any NIT data would need to be generated
individually for each transmitter site, unless the entire
pool of available frequencies allocated to france (or to the
particular mux operator/composition) is listed within the
NIT table from a central site, which is then distributed to
all the transmitters.

For me to see the NIT contents, I'd have to ask the original
poster if it would be possible to make a short recording of
PID 16 on each of the five or six frequencies in use from
Nordheim (these would be chans 22-47-48-51-61-69 based on
data I downloaded in 2006), and either mail them to me, or
run `dvbsnoop -s ts -tssubdecode -if /name/of/recorded.ts 16'
to get a text parsing of the NIT table contents.

Usually three seconds is enough to see at least one full set
of NIT data, though sometimes ten or more seconds would be
needed.

This will give me the other half of what `w_scan' is working
on, something which I am not able at present to see myself.


> > > +T 482167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> > > 
> If that information was found by w_scan, that information was found by parsing
> the NIT ot this channel.

This data is correct.  It's the other mangled data from the
german SFNs that is incorrect, and without looking at the
`w_scan' code until later, I have a couple ideas about what
it could be doing wrong.


> Since in Germany no transmitter uses any freq offsets, the information comes
> from the French one.
> And for France finding that freq offsets is quite normal.

I did notice that a few scanfiles other than uk-foo did
include such offsets.  I agree that the frequencies listed
in the initial scan files should be as accurate as possible
with technical details -- I presume the BNetzA data is based
on the nominal assigned allocations rather than the (perhaps
temporary?) current practice.

Which makes me wonder, as these offsets are used in the case
of a simulcast phase, will they still remain in effect after
analogue switchoff, or will they be dropped at the time when
powers of the DVB-T broadcasts will be increased?


What has disturbed me is how this offset has been applied
across the board by `w_scan', as have the guard interval and
modulation type (with one exception), to the received german
frequencies, yet the NIT data from said german frequencies
appears nowhere.  In particular, the ZDFmobil mux:

> +T 570167000 8MHz 2/3 NONE QAM16 8k 1/32 NONE
   wrong^^^^^^  ok  ok      correct!  WRONG

Here is what one sees with `dvbsnoop' on the NIT data, which
appears that it's generated for each SFN Cell, as opposed to
being centrally generated once:
(working my way backwards from bottom to the top)
A list of frequencies used by ZDFmobil...
                  DVB-DescriptorTag: 98 (0x62)  [= frequency_list_descriptor]
                  descriptor_length: 101 (0x65)
                  reserved_1: 63 (0x3f)
                  coding_type: 3 (0x03)  [= terrestrial]
                     Centre_frequency: 02d34440  (= 474000.000 kHz)
                     Centre_frequency: 02df7940  (= 482000.000 kHz)
[...]
                     Centre_frequency: 04a32240  (= 778000.000 kHz)

A list of Cell IDs and frequencies (the same frequency is shared
by distant cells)...
                  DVB-DescriptorTag: 109 (0x6d)  [= cell_frequency_list_descriptor]
                  descriptor_length: 40 (0x28)
                  Cell:
                     cell_id: 515 (0x0203)
                     Center frequency: 0x0365c040 (= 570000.000 kHz)
                     subcell_info_loop_length: 0 (0x00)
                  Cell:
                     cell_id: 560 (0x0230)
                     Center frequency: 0x038a5f40 (= 594000.000 kHz)
                     subcell_info_loop_length: 0 (0x00)
[...]

Modulation for the particular Cell of interest:
                  Center frequency: 0x0365c040 (= 570000.000 kHz)
                  Bandwidth: 0 (0x00)  [= 8 MHz]
                  priority: 1 (0x01)  [= HP (high priority) or Non-hierarch.]
[...]
                  Constellation: 1 (0x01)  [= 16-QAM]
                  Hierarchy information: 0 (0x00)  [= non-hierarchical (native interleaver)]
                  Code_rate_HP_stream: 1 (0x01)  [= 2/3]
                  Code_rate_LP_stream: 0 (0x00)  [= 1/2]
                  Guard_interval: 3 (0x03)  [= 1/4]
                  Transmission_mode: 1 (0x01)  [= 8k mode]
                  Other_frequency_flag: 1 (0x01)
                  reserved_2: 4294967295 (0xffffffff)

A list of Service IDs...
Geographic info for each Cell ID...
               DVB-DescriptorTag: 108 (0x6c)  [= cell_list_descriptor]
               descriptor_length: 58 (0x3a)
               Cell:
                  cell_id: 515 (0x0203)
                  cell_latitude: 18841 (0x4999)  [= 51.748 degree]
                  cell_longitude: 2169 (0x0879)  [= 11.914 degree]
                  cell_extend_of_latitude: 545 (0x0221)  [= 1.496 degree]
                  cell_extend_of_longitude: 710 (0x02c6)  [= 3.900 degree]
                  subcell_info_loop_length: 0 (0x00)
[...]
Note that the Cell ID does not match the ``SFN-Kenner'' in the
BNetzA data, which is BW00837 for this particular ZDFmobil SFN.
               Cell:
                  cell_id: 519 (0x0207)
                  cell_latitude: 17233 (0x4351)  [= 47.331 degree]
                  cell_longitude: 1304 (0x0518)  [= 7.163 degree]
                  cell_extend_of_latitude: 667 (0x029b)  [= 1.831 degree]
                  cell_extend_of_longitude: 333 (0x014d)  [= 1.829 degree]
                  subcell_info_loop_length: 0 (0x00)
I believe this is the particular SFN which can be received in
Strasbourg, with the given lat+long. coördinates placing the
start of the cell somewhere in the area of Basel -- the
details for Baden Baden Fremserberg are something like
48N45'10" 08E12'08" 525+174m, more or less.

As you see, an independent parsing of the 570MHz NIT data will
in no way be able to come up with the incorrect guard interval
shown several screens above.  Similarly, the frequency offset.

The other thing about a frequency offset in use at Nordheim, is
the adjacent german channels without offset, so that if I were
to believe the offset of all the french channels, in the case
where they are adjacent to a nearby german channel, there would
be some frequency overlap in theory -- I don't know exactly how
much of the allocated 8MHz bandwidth is actually used by the
COFDM carriers:

+T 682167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
+T 690167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
+T 698167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE <= SWR mux Baden Baden
 wrong^^^^^^          wrong^^^^^ wrong^^
+T 714167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
+T 722167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE <= ARD mux Freiburg

+T 786167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE <= ARD mux Baden Baden
+T 794167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE

The last is not a problem with the offset, as it would just
increase the separation between the two -- Baden Baden does
not employ the offset.

What I'm wanting to say here, is that while I'll gladly
accept that the use of an offset by the french transmitters
on some frequencies may well be, I would expect that the
above adjacent channels would not use such an offset.

Also, that I can't trust the `w_scan' output, as it's clearly
botched the german channels in all cases, and I'd rather see
the raw or `dvbsnoop'ified NIT tables in their entirety (no
guarantee they'll be correct, though -- it's interesting to
me that the SWR NIT table gives data for the mythical 730MHz
channel, those presently in service being ### SWR-BW multiplex; 
K39, K40, K41, K49, K50 -- also listed are
                     Centre_frequency: 03104d40  (= 514000.000 kHz)
                     Centre_frequency: 03aefe40  (= 618000.000 kHz)
                     Centre_frequency: 03bb3340  (= 626000.000 kHz)
                     Centre_frequency: 03c76840  (= 634000.000 kHz)
                     Centre_frequency: 04291040  (= 698000.000 kHz)
The same is true for the ARD mux:  the listed frequency is not
correct for that actually tuned, and the list of frequencies is
out of date (missing some, as well as some not in use).  Both
these muxen are assembled by SWR, while the ZDFmobil mux is
national.  Who should be the recipient of the pointy finger of
blame, I cannot say, but I imagine this would wreak havoc with
any scanning application without human input.

There should be a closing parenthesis on the above, but now
that I look at it, it seems important enough not to be
footnoted into oblivion, and I need to dig out my recordings
from 2006 and see if the SWR/ARD NIT tables have changed at
all since then.

Carry on...


Anyway, to the original poster, Benjamin, can you make a short
recording of, oh, say, ten seconds, of just PID 16 of only the
five or six french muxen which you receive, and somehow deliver
them to me?  File sizes should be something like
-rw-r--r--   1 beer  666      19552 2009-03-17 03:21 zdf-fs-DVB_T-17.Mar.2009-03h.ts
-rw-r--r--   1 beer  666      26696 2009-03-17 04:07 bw-fs-DVB_T-17.Mar.2009-04h.ts
-rw-r--r--   1 beer  666       7332 2009-03-17 04:13 ard-fs-DVB_T-17.Mar.2009-04h.ts
(that's five seconds, or 30 secs for SWR)

If you need a commandline to do this, just ask -- I use a
script with the german parameters, sort of like
/home/beer/bin/dvbstream  ${DVB_T}  -T  \
    -f 570000000   -I 0   -qam 16  -gi 4  -cr 2_3    -bw 8  -tm 8  \
    -crlp 1_2   -hy NONE   \
    -o:${RECROOT:-/opt}/Partial_Transport_Streams/zdf-fs-DVB_T-${DATE}.ts  \
    0  16 $*

merci vielmal

barry bouwsma
