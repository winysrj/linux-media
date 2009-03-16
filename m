Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:49416 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbZCPJH7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 05:07:59 -0400
Received: by ewy25 with SMTP id 25so3375302ewy.37
        for <linux-media@vger.kernel.org>; Mon, 16 Mar 2009 02:07:55 -0700 (PDT)
Date: Mon, 16 Mar 2009 10:07:46 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Benjamin Zores <benjamin.zores@gmail.com>
cc: linux-media@vger.kernel.org,
	Christoph Pfister <christophpfister@gmail.com>
Subject: Re: [PATCH] add new frequency table for Strasbourg, France
In-Reply-To: <49BBEFC3.5070901@gmail.com>
Message-ID: <alpine.DEB.2.00.0903160803030.4176@ybpnyubfg.ybpnyqbznva>
References: <49BBEFC3.5070901@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 14 Mar 2009, Benjamin Zores wrote:

> Attached patch updates the current dvb-t/fr-Strasbourg file with
> relevant transponders frequency values.

Hi,

I have a problem with some of these values.  Well, to be truthful,
all of these values.  I don't have a good 'net connection to be
able to check these things online at the moment, so I'm going to
have to go by some possibly-outdated downloads...

First, every frequency is given an offset from the nominal centre
frequency of the 8MHz envelope.  I am aware this is common in the
UK where the switchover is happening gradually so as not to
interfere with adjacent analogue services, and I also know that
last I checked, the number of french analogue services I could
receive weakly had dropped, but at least one was still visible.

I've also read in a forum that complete analogue switchoff is
planned Real Soon Now with a corresponding increase in ERP from
the Alsace transmitters, but I don't know details.

My mailer doesn't include the attachment in the reply, so I've
had to paste the lines below...

+T 482167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE

I have some recent german Bundesnetzagentur (BNetzA) data, and
this lists the Nordheim frequencies as
TVDRStrasbourg                    22   482.000KT
that is, no offset.  I still have not wrapped my head around
the meaning of the `KT' status field.  The rest of the fields
match what I predicted earlier (pasted from my file created
for the neighbouring part of germany):
### In the west to southwest, one may receive a number of broadcasts from
### the Alsace in France.  These are horizontally polarised.
###  Strasbourg Nordheim        22-47-48-51-61-69
# ACHTUNG!  file fr-Strasbourg contains no content!  FIXME!
### need to verify FEC 2/3 + GI 1/32 (MFN), fix freqs
# T 482000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE  # K22
# T 682000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE  # K47
# T 690000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE  # K48
# T 714000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE  # K51
# T 794000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE  # K61
# T 858000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE  # K69


Now, back to your diffs...

+T 570167000 8MHz 2/3 NONE QAM16 8k 1/32 NONE

This frequency looks very suspicious, as it is (without
the offset) in use with different parameters by a Single-
Frequency Network along the Hoch- and Oberrhein, including
a non-directional 50kW tower at the Totenkopf, Vogtsburg/
Kaiserstuhl, and somewhat closer at Baden Baden Fremserberg,
which should blast well into much of the Alsace.  Certainly,
when I was within walking distance of the Totenkopf but
within the Rhein valley, I had no problems receiving the
analogue french broadcasts with a simple indoor antenna.
These may have been from Colmar, much closer.

I can't imagine that the french would either try to
re-use this frequency or attempt to jam it...


+T 618167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE

My BNetzA data lists an additional frequency that neither
your list, nor mine, includes:
TVDRStrasbourg                    40   626.000K4
As I said, I don't know how to interpret the `K4' status
field to match up with today's reality.

Your frequency, however, is different, and matches a
second frequency used non-directionally from the
Totenkopf (but this time, not in a SFN with Baden Baden).
However, nearly all the modulation parameters bear no
similarity to the ones you give.

My BNetzA data lists another additional allocation:
TVDRStrasbourg                    46   674.000K4
This, like the above, is a 47dBW non-directional field,
with multiplex labels such as F___F__00428, which should
be situated 3 metres higher up the tower from the other
existing frequencies, all of which are directional with
about 40dBW, reduced by 6dBW -- somewhere I've saved graphs
of the directional pattern, but I can't find them now --
the reduced strength is usually towards germany.


+T 682167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
+T 690167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE

These match the BNetzA data, and my predictions, apart
from the offset.  The analogue BNetzA data lists two
frequencies for a `Strasbourg', one being for `Strasbourg
Port Du Rhin', with the geographic data and antenna data
matching the latter.  No analogue frequencies are presently
shown for the Alsace Strasbourg (or Elsaß, Straßburg), though
one is listed for Mulhouse, which is probably what I was
seeing a year or so ago, so I'm not sure whether an offset
is really needed, as I have not been paying much attention
to the process of switching on the digital, and eventually
switching off the remaining analogue frequencies in this
area...  (For example, Colmar is assigned digital frequencies
with vertical polarisation, directional, and about 20dBW less 
power toward germany, but I know only of Mulhouse and Strasbourg 
being in operation)


+T 698167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE

This is not listed in the BNetzA data, but tramples on
a multiplex out of Baden Baden (see 618MHz above with the
same content, except that the SFN MUX is BW00864 from
Baden Baden and BW00835 from Vogtsburg, which may be
reflected by different NIT contents).


+T 714167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE

This (apart from the offset) matches the BNetzA frequency
data.


+T 722167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE

Again, this frequency is in use from the Totenkopf, but
with very different parameters, and so is unlikely to be
reused for a MFN in so short a distance.


+T 786167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE

This frequency is in use with similar contents to the above
from the Fremserberg, with SFN MUX BW00865, or BW00840 from
Vogtsburg/Kaiserstuhl.


+T 794167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE

This matches the BNetzA data.  In addition, that data includes
an additional frequency in the range 61-69:
TVDRStrasbourg                    69   858.000AT
Again, with a different `AT' status.

I know that in some lands, the 61-69 range, or parts thereof,
are to be reassigned from DVB-T to something else, but with
all the different lands and plans, I can't remember the
details...



Sorry for the delay, and lack of checking against current
TNT sources, as well as quoting some Bundesnetzagentur data
without fully understanding the details.

barry bouwsma
