Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1LJ6EM-00024D-Tg
	for linux-dvb@linuxtv.org; Sat, 03 Jan 2009 14:07:56 +0100
Received: by ey-out-2122.google.com with SMTP id 25so680616eya.17
	for <linux-dvb@linuxtv.org>; Sat, 03 Jan 2009 05:07:51 -0800 (PST)
Date: Sat, 3 Jan 2009 14:04:17 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Mike Martin <redtux1@googlemail.com>
In-Reply-To: <ecc841d80901030346g738bde61rd3b529274d5fb69b@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0901031304510.32128@ybpnyubfg.ybpnyqbznva>
References: <ecc841d80901022041w72031858pc9b7bf6b6cb199fb@mail.gmail.com>
	<alpine.DEB.2.00.0901031058380.32128@ybpnyubfg.ybpnyqbznva>
	<ecc841d80901030346g738bde61rd3b529274d5fb69b@mail.gmail.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Is it posible to view digital teletext
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Sat, 3 Jan 2009, Mike Martin wrote:

> Well it is DVB teletext ie:through DVB-T not satelite of any description

Then it is probably MHEG, at least for the BBC, where
Ceefax, as I understand it, is only present on the
analogue services, and will disappear altogether at
the end of DSO.


> This is the output of dvbtune -i

Unfortunately, these utilities do not appear to parse
the associated data services.  You want to use
`dvbsnoop' on the PMT PID...


> <description tag="0x48" type="1" provider_name="five" service_name="FIVER" />

> May be being very thick, but there is nothing that stands out

I think you see, in order, video, the two audio
channels, and then DVB subtitles.


> ouput from quickscan (from libdvb) gives
>       CHANNEL ID 0 NAME "Five" PNAME "five" SATID 3e8 TPID 3e8 SID
> 3242 TYPE 0 VPID 1781 APID 1782 APID 1783 PCRPID 1781 SUBPID 1786
> I'm guessing this would be the right PID
> TPID 3e8

Not sure, but I don't think so -- SAT-ID and TP-ID seem
to be like satellite and transponder ID respectively, and
following, service ID, Video PID, 2x Audio PID, PCR, then
DVB subtitles.  No mention of MHEG or DVB text here.

If anything, I'd expect TTXPID to have a number above
between the audio PIDs and the subtitle PID, say, 1784 or
more likely 1785, as many broadcasters follow a rather
predictable numbering pattern for the different PIDs.


Try `dvbsnoop' om service ID 3242 (not sure what PMT ID
it would have, as I'm not able to receive UK DVB-T under
normal circumstances).  I'll post some satellite `dvbsnoop'
output on a channel with MHEG and TTX PIDs below.


> > Check out `redbutton-download' and `redbutton-browser'
> > for an application that can display MHEG pages, as sent

Also, redbutton-download doesn't need to know the PIDs as
it figures them out itself, all you need to do is tune to
the channel of interest.

I'm not an expert on rb-download, and can't remember the
exact steps I needed to view Red Button text for the BBC
TV and Radio services any more...


Over satellite, BBC One London has PMT PID 261, which is
parsed as follows:

First, the raw hexdump of the first packet.  There are
some readable identifiers below:  OTV OpenTV, used
by BSkyB; VID for the video stream, FSAT for Freesat
which uses MHEG; NAR for narrative commentary for the
visually impaired, SUB for subtitles, and the like...
------------------------------------------------------------
TS-Packet: 00000001   PID: 261 (0x0105), Length: 188 (0x00bc)
from file: /mnt/sys/Partial_Transport_Streams/bbc-one-OPERA-25.Dec.2008-21h.ts
------------------------------------------------------------
  0000:  47 41 05 1c 00 02 b2 31  18 9d eb 00 00 f3 88 f0   GA.....1........
  0010:  05 0e 03 da 95 60 02 f3  88 f0 17 0e 03 c1 35 51   .....`........5Q
  0020:  06 01 04 52 01 01 0f 04  4f 54 56 00 fe 04 56 49   ...R....OTV...VI
  0030:  44 00 03 f3 89 f0 1a 0e  03 c1 35 51 0a 04 65 6e   D.........5Q..en
  0040:  67 00 0f 04 4f 54 56 00  fe 04 41 55 44 31 52 01   g...OTV...AUD1R.
  0050:  02 03 f3 8a f0 1a 0e 03  c1 35 51 0a 04 4e 41 52   .........5Q..NAR
  0060:  00 0f 04 4f 54 56 00 fe  04 41 55 44 32 52 01 07   ...OTV...AUD2R..
  0070:  06 f3 8b f0 20 0e 03 c1  35 51 56 0a 65 6e 67 09   .... ...5QV.eng.
  0080:  00 65 6e 67 10 88 0f 04  4f 54 56 00 fe 04 53 55   .eng....OTV...SU
  0090:  42 00 52 01 04 05 ef 00  f0 11 0e 03 c1 35 51 5f   B.R..........5Q_
  00a0:  04 46 53 41 54 d1 01 07  52 01 51 05 ef 01 f0 12   .FSAT...R.Q.....
  00b0:  0e 03 c1 35 51 5f 04 46  53 41 54 d1               ...5Q_.FSAT.


Stripping away most of the content, I'll focus on the
PIDs pointed to by these packets, and in particular, the
data services used for Digital Teletext / BBCi / Red Button
services.

    TS sub-decoding (4 packet(s) stored for PID 0x0105):
    =====================================================
        PID:  261 (0x0105)
        Table_ID: 2 (0x02)  [= Program Map Table (PMT)]
        Program_number: 6301 (0x189d)

        PCR PID: 5000 (0x1388)

            Stream_type: 2 (0x02)  [= ITU-T Rec. H.262 | ISO/IEC 13818-2 Video | ISO/IEC 11172-2 constr. parameter video stream]
            Elementary_PID: 5000 (0x1388)

                  Descriptor-data:
                       0000:  4f 54 56 00                                        OTV.

                  Descriptor-data:
                       0000:  56 49 44 00                                        VID.


            Stream_type: 3 (0x03)  [= ISO/IEC 11172 Audio]
            Elementary_PID: 5001 (0x1389)

            Stream_type: 3 (0x03)  [= ISO/IEC 11172 Audio]
            Elementary_PID: 5002 (0x138a)
                     ISO639_language_code:  NAR

            Stream_type: 6 (0x06)  [= ITU-T Rec. H.222.0 | ISO/IEC 13818-1 PES packets containing private data]
            Elementary_PID: 5003 (0x138b)
                  DVB-DescriptorTag: 86 (0x56)  [= teletext_descriptor]
                     ISO639_language_code:  eng
                     Teletext_type: 1 (0x01)  [= initial teletext page]
                     Teletext_magazine_number: 1 (0x01)
                     Teletext_page_number: 0 (0x00)

                     Teletext_type: 2 (0x02)  [= teletext subtitle page]
                     Teletext_magazine_number: 0 (0x00)
                     Teletext_page_number: 136 (0x88)


Here is the DVB Teletext sent out, which over satellite is
only used for a handful of pages, mostly stating you need
to use the Red Button or TEXT for full UK service.


                  Descriptor-data:
                       0000:  53 55 42 00                                        SUB.

This is tagged as subtitles; I'm not sure whether OpenTV/Sky
make use of teletext subtitles or DVB subtitles.  Some
consumer receivers I have support both when available, and
below you'll see the standard DVB subtitles also tagged as
OpenTV SUB...



            Stream_type: 5 (0x05)  [= ITU-T Rec. H.222.0 | ISO/IEC 13818-1 private sections]
            Elementary_PID: 3840 (0x0f00)

            Stream_type: 5 (0x05)  [= ITU-T Rec. H.222.0 | ISO/IEC 13818-1 private sections]
            Elementary_PID: 3841 (0x0f01)


PIDs 3840 and 3841 are used by Freesat.



            Stream_type: 5 (0x05)  [= ITU-T Rec. H.222.0 | ISO/IEC 13818-1 private sections]
            Elementary_PID: 2308 (0x0904)
                  Descriptor-data:
                       0000:  4f 54 56 00                                        OTV.
                  Descriptor-data:
                       0000:  54 58 54 00                                        TXT.

If you ask me, this is the PID used by OpenTV for text...



            Stream_type: 5 (0x05)  [= ITU-T Rec. H.222.0 | ISO/IEC 13818-1 private sections]
            Elementary_PID: 3842 (0x0f02)
                  PrivateDataSpecifier: 1179861332 (0x46534154)  [= >>ERROR: not (yet) defined... Report!<<]

Another PID in the 38xx range.  The hex 46 53 41 54 is seen
above as F S A T, and, voila, Freesat.  (This is an older
`dvbsnoop' from before Freesat came into being)



            Stream_type: 5 (0x05)  [= ITU-T Rec. H.222.0 | ISO/IEC 13818-1 private sections]
            Elementary_PID: 3843 (0x0f03)


Another Freesat ID.


            Stream_type: 5 (0x05)  [= ITU-T Rec. H.222.0 | ISO/IEC 13818-1 private sections]
            Elementary_PID: 2310 (0x0906)
                  Descriptor-data:
                       0000:  4f 54 56 00                                        OTV.


PIDs of 23xx generally refer to OpenTV data services.


Skipping a bunch...


            Stream_type: 11 (0x0b)  [= ISO/IEC 13818-6 DSM-CC U-N Messages]
            Elementary_PID: 3846 (0x0f06)
            Stream_type: 11 (0x0b)  [= ISO/IEC 13818-6 DSM-CC U-N Messages]
            Elementary_PID: 3847 (0x0f07)

These are probably part of the MHEG data stream, maybe
[snip]

            Stream_type: 11 (0x0b)  [= ISO/IEC 13818-6 DSM-CC U-N Messages]
            Elementary_PID: 3848 (0x0f08)
            Stream_type: 11 (0x0b)  [= ISO/IEC 13818-6 DSM-CC U-N Messages]
            Elementary_PID: 3849 (0x0f09)



            Stream_type: 6 (0x06)  [= ITU-T Rec. H.222.0 | ISO/IEC 13818-1 PES packets containing private data]
            Elementary_PID: 5004 (0x138c)
                  DVB-DescriptorTag: 89 (0x59)  [= subtitling_descriptor]
                       ISO639_language_code:  eng
                     Subtitling_type: 16 (0x10)  [= DVB subtitles (normal) with no monitor aspect ratio critical]

                  Descriptor-data:
                       0000:  53 55 42 31                                        SUB1


And there you have the basics of what dvbsnoop shows you
for the PMT PID of BBC One via satellite, which include
about half a dozen additional PIDs each for Freesat and
OpenTV services, and which are likely not to be parsed by
the two utilities you tried.


Naturally the DVB-T service of the BBC is somewhat different
than this DVB-S service, but I suspect that if you use
`dvbsnoop', you'll get more details than you want to know
about what interactive services are offered.

Note that the Sky version of `FIVER' only contains
subtitles on the teletext PID -- whether the same is true
for terrestrial FIVER, I do not know...  Additionally, the
Sky version of FIVER has no DVB subtitle PID, whilst as
part of the addition to Freesat, all the major broadcasters
got sparkling new DVB subtitle PIDs, which mostly work
(while it appears that the +1 versions of More4 and E4
DVB subs are broken for some time).

Only `Five' in its regional variants, and not fiver, fiveUS,
or the timeshifted versions, have a non-subtitle teletext
service, so presumably only Five on Freeview will have a
teletext service comparable to Ceefax, as opposed to MHEG-
based digital text.


barry bouwsma
long-winded

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
