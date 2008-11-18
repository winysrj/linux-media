Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [211.115.112.228] (helo=wrg.co.kr)
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <steve.yoon@wrg.co.kr>) id 1L2NA3-00034A-Gb
	for linux-dvb@linuxtv.org; Tue, 18 Nov 2008 10:46:22 +0100
From: "steve yoon" <steve.yoon@wrg.co.kr>
To: <linux-dvb@linuxtv.org>
References: <mailman.1.1226919601.12477.linux-dvb@linuxtv.org>
Date: Tue, 18 Nov 2008 18:44:22 +0900
Message-ID: <003b01c94962$3c5fe530$630a1dac@blackedi0en62x>
MIME-Version: 1.0
In-Reply-To: <mailman.1.1226919601.12477.linux-dvb@linuxtv.org>
Subject: [linux-dvb] how to distinguish the camped stream was lying on DVB-T
	or DVB-H or DVB-T2?
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

Anybody who has an idea how to distinguish the camped stream was lying on
DVB-T or DVB-H or DVB-T2?
 
Thanks in advance.
 
Steve Yoon

-----Original Message-----
From: linux-dvb-bounces@linuxtv.org [mailto:linux-dvb-bounces@linuxtv.org]
On Behalf Of linux-dvb-request@linuxtv.org
Sent: Monday, November 17, 2008 8:00 PM
To: linux-dvb@linuxtv.org
Subject: linux-dvb Digest, Vol 46, Issue 19

Send linux-dvb mailing list submissions to
	linux-dvb@linuxtv.org

To subscribe or unsubscribe via the World Wide Web, visit
	http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
or, via email, send a message with subject or body 'help' to
	linux-dvb-request@linuxtv.org

You can reach the person managing the list at
	linux-dvb-owner@linuxtv.org

When replying, please edit your Subject line so it is more specific
than "Re: Contents of linux-dvb digest..."


Today's Topics:

   1. Re: channels.conf for ComHem Stockholm wanted (Anders Eriksson)
   2. scanfile for Bundesland Baden-Wuerttemberg, Germany
      (BOUWSMA Barry)
   3. Re: hvr 1400 (CityK)
   4. Re: Avermedia A312 (CityK)
   5. Re: [Bulk] [PATCH] [resent] Leadtek WinFast DTV-1800H support
      (CityK)
   6. Re: SAA7162 status (CityK)
   7. Re: SAA7162 status (VDR User)
   8. [PATCH] af9015: Add support for the Digittrade DVB-T	USB
      Stick remote (Alain Kalker)
   9. Re: [Bulk] [PATCH] [resent] Leadtek WinFast DTV-1800H	support
      (Miroslav  ?ustek )
  10. Attention em28xx users (Devin Heitmueller)


----------------------------------------------------------------------

Message: 1
Date: Sun, 16 Nov 2008 13:50:21 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Subject: Re: [linux-dvb] channels.conf for ComHem Stockholm wanted
To: reklam@holisticode.se
Cc: linux-dvb@linuxtv.org
Message-ID: <20081116125021.DAC8B93CC2B@tippex.mynet.homeunix.org>
Content-Type: text/plain; charset=us-ascii



I'm on ComHem/Linkoping and furiously trying to get my new Anysee E30CPlus
to
do something useful. If you can help me with that, I can for sure send you
some
channels.conf files.

First off, I'm unsure about the diff between dvbscan and w_scan as they 
produce different results. Is that expected?

So far, I've been able to get mplayer to play a few radio channels (P1 P2), 
and the ComHem channel. No "real" tv channels. :-(


I've got a "mediumHD" subscription with a (supposedly) unlocked sister 
card. That should give ca 20 TV channels and >30 Radio channels. Any ideas
as 
to where I should start looking? On the failing channels, mplayer seems to
end 
up in a loop with (from head):

COLLECT_SECTION: 
SKIP:
PARSE_PAT:
<~10 lines of "PROG">

And this repeats forever.

Let me know how to cook up that channels.conf file and I'll send it your
way.

/Anders 





------------------------------

Message: 2
Date: Sun, 16 Nov 2008 17:44:30 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
Subject: [linux-dvb] scanfile for Bundesland Baden-Wuerttemberg,
	Germany
To: linux-dvb@linuxtv.org
Message-ID: <alpine.DEB.2.00.0811161441270.6408@ybpnyubfg.ybpnyqbznva>
Content-Type: text/plain; charset="us-ascii"

I promised this two weeks ago; sorry for the delay...
Real Life has again reared its ugly head.


Here is a scanfile that covers all the announced frequencies
used in german Baden-Wuerttemberg, in the southwest of
Germany.  It is not final, due to last-minute announcements,
the technical details of which I have not yet uncovered.

While nearly all of B-W has gone digital, the original
plans to cease analogue broadcasts in the far northeast
(Bad Mergentheim and the Taubertal) have been put on hold
as in nearby Bayern, they have changed from carrying the
SWR broadcasts as part of their regional (Franken) mux,
to carrying mdr, leaving the Taubertal largely without
convenient reception of SWR via DVB-T.

As a result, sometime in 2009, an additional set of
multiplexes will go into service at Bad Mergentheim.
In addition, during the early part of the year, there
will be a frequency change at Aalen.  The latter is
known to me and included in this scanfile; the former
is not yet announced that I've found.


I've tried to include self-explanatory comments
within this scanfile for advanced use, meaning to
allow you to receive nearby broadcasts from other
regions, within this one scanfile, by uncommenting
possible transmitter frequencies near your region.
I've largely guessed this based on published coverage
maps and transmitter locations, without actually
trying to see hands-on what really can be seen from
all regions, so user feedback for things I may have
overlooked would be appreciated.

Alleged factual information within may not be totally
correct, but is intended for those without intimate
knowledge of geography and transmitter sites to locate
these transmitters and guess which might cover their
location for the sake of antenna orientation or
tower-spotting or whatever.


Again, sorry for not posting this before the switchover,
which happened on 05.Nov 2008.

barry bouwsma


In addition to a MIME file attachment for easy saving, here
it is as part of this message to allow easy feedback, comments,
ridicule, insults, degradation, complaints, harrassment, etc
to be sent my way

In particular, I've used `K##' to refer to a channel number
(short for `Kanal' and prevalent in german forum posts and
channel listings), while in other languages I've noted the use of
`E##' for over-the-air frequencies, `S##' for some CATV channels,
neither of which matches what I learned many decades ago as a
youth, where I had the choice of broadcasting my hand-cranked
wax cylinders over `AM' or `FM' or Morse-code spark gap 
transmitters...  So I should probably change this, if someone
can give me a pointer to the correct usages, thanks...


### Regional frequency list Baden-Wuerttemberg.  Stand 05.11.2008, barry
bouwsma
###  known updates needed within 6 months at least (Aalen, Bad Mergentheim)

### In southwestern Germany, there are typically three frequencies in use
### at each transmitter site, with 50kW.  Horizontal polarisation is used.
### There are no repeater/filler transmitters at present or currently
planned.
### UHF frequencies only are used; the bitrate per multiplex is
13,27Mbit/sec,
### reflecting parameters based on a large coverage area and the potential
### for Single-Frequency Networks covering a yet larger area in some
regions.

### ZDFmobil multiplex; K21, K22, K23, K33
T 474000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K21 Heidelberg
T 482000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K22 Donaueschingen,
Raichberg, Ravensburg, Ulm
T 490000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K23 Stuttgart, Aalen,
Waldenburg
T 570000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K33 Baden Baden,
Brandenkopf, Freiburg, Hochrhein, Pforzheim
### SWR-BW multiplex; K39, K40, K41, K49, K50
T 618000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K39 Brandenkopf, Freiburg,
Hochrhein
T 626000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K40 Raichberg, Ravensburg,
Ulm
T 634000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K41 Donaueschingen
T 698000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K49 Baden Baden,
Heidelberg, Pforzheim
T 706000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K50 Stuttgart, Aalen,
Waldenburg
### ARD multiplex; K26, K43, K52, K54, K60; K53->K59
T 514000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K26 Stuttgart, Waldenburg
T 650000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K43 Raichberg, Ravensburg,
Ulm
T 722000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K52 Brandenkopf, Freiburg,
Hochrhein
T 738000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K54 Donaueschingen
T 786000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K60 Baden Baden,
Heidelberg, Pforzheim
T 730000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K53 Aalen, until early
2009
T 778000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K59 Aalen starting 2009

###  Transmitter locations and multiplex frequencies:
###   Geographic data hopefully in degrees min sec, taken from several
sources,
###   followed by antenna base height in metres above sea level, plus either
###   antenna mast height or height of centre of antenna array -- due to the
###   variety of sources as well as antenna modifications, may not be
precise.
###   Also, official-seeming sources don't quite match other data I've
found, so
###   you probably don't want to use this to set your ICBM coordinates for
less
###   than multi-megatonne payloads just now, without researching yourself.
###
###					ARD	ZDF	SWR
###  Aalen				53->59	23	50
###   Flexner, Wasseralfingen:		48N51'39" 10E08'15" 722+140m
###  Baden-Baden			60	33	49
###   Fremserberg:			48N45'10" 08E12'08" 525+174m
###  Brandenkopf			52	33	39
###   N of Hausach (Schwarzwaldbahn):	48N20'18" 08E09'12" 930+125m
###  Donaueschingen			54	22	41
###   Huefingen:			47N53'17" 08E34'37" 917+129m
###  Freiburg im Breisgau		52	33	39
###   Totenkopf, Vogtsburg/Kaiserstuhl:	48N04'51" 07E40'09" 557+155m
###  Heidelberg				60	21	49
###   Koenigstuhl:			49N24'14" 08E43'42" 563+82m
###  Hochrhein				52	33	39
###   Bergalingen-Jungholz, above Bad Saeckingen: 47N36'12" 07E56'56"
800+184m
###  Pforzheim				60	33	49
###   Schoemberg Langenbrand:		48N48'28" 08E37'27" 707+148m
###  Raichberg				43	22	40
###   Albstadt Onstmettingen, SW of Reutlingen:	48N18'22" 08E59'32" 954+137m
###  Ravensburg				43	22	40
###   Hoechsten, Glashuetten:		47N49'19" 09E29'58" 829+171m
###  Stuttgart				26	23	50
###   Frauenkopf:			48N45'49" 09E12'21" 462+192m
###  Ulm				43	22	40
###   Ermingen:				48N23'25" 09N53'45" 640+162m
###  Waldenburg				26	23	50
###   Friedrichsberg, NW of Schwaebisch Hall: 49N11'05" 09E39'56" 498+150m

###  from 2009:
###  Bad Mergentheim			?
###   Loeffelstelzen, am Ketterwald:	49N30'30" 09E47'01" 353+173m


### In many areas, it is possible to receive transmissions from adjacent
lands.
### The following frequencies are listed for convenience, but commented
### out to speed normal scanning, so that if you know you are near a
following
### location, you can uncomment just that location and tune those
frequencies.
###
### It's also possible that additional more distant transmitters may
### be received than the nearest ones I've listed but have not checked,
### in favourable locations or with a well-installed rooftop antenna.
### If these can be always received clearly and easily, especially if they
### add additional programming normally not received, they should be added.

### In the south, along the border with Switzerland, one may receive the
### Single-Frequency Networks used.  These are all sent with VERTICAL
### polarisation, with a mix of high- and low-power transmitters.
###  see ch-All

### In the southwest, near Basel, a french-swiss multiplex
# T 754000000 8MHz 5/6 NONE QAM16 8k 1/4 NONE	# K56

### Starting from the southwest, the german-swiss multiplex can be received
### over three frequencies (also shared by DVB-H in part), from west to east
# T 554000000 8MHz 5/6 NONE QAM16 8k 1/4 NONE	# K31
# T 562000000 8MHz 5/6 NONE QAM16 8k 1/4 NONE	# K32
# T 578000000 8MHz 5/6 NONE QAM16 8k 1/4 NONE	# K34

### In the southeast, one may receive two Austrian multiplexes, from the
### high-power Pfaender.  Transmissions horizontal
### A DVB-H multiplex (MUX D) exists too; a regional (MUX C) not at this
time
###  see at-Official
# T 474000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE	# K21
# T 498000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE	# K24

### Along the east and northeast, one may receive the high-power trasmitters
### from Bayern, with three multiplexes similar to the local content.
### Nearby transmitters are horizontal.  Listed south to northwest.
###					ARD	ZDF	BR(/SWR)
###  Gruenten (Bayern)			45	28	46
# T 530000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K28
# T 666000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K45
# T 674000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K46
###  Hohenpeissenberg (Bayern) ?	47	28	53
# T 682000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K47
# T 730000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K53 -- temp included in
B-W
###  Augsburg(Hor)			36	44	25
# T 506000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K25
# T 594000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K36
# T 658000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K44
###  Hesselberg				55	44	47
###  + Buettelberg			55	x	47
# T 658000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K44
# T 682000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K47
# T 746000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K55
###  Wuerzburg				10	25	45
# T 212500000 7MHz 3/4 NONE QAM16 8k 1/4 NONE	# K10
# T 506000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K25
# T 666000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K45
###  Pfaffenberg			36	25	46
# T 506000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K25
# T 594000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K36
# T 674000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K46

### In the northwest, one may receive high-power transmitters from Hessen
### to the north, or Rheinland-Pfalz to the west, content similar.
###					ARD	ZDF	HR/SWR
###  Wuerzberg/Odenwald(Hor) (Hessen)	37	21	53
### (Is it possible to receive the vertical Rhein-Main multiplexes,
### including private commercial broadcasters otherwise not seen?)
# T 474000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K21 -- included in B-W
# T 602000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K37
# T 730000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K53 -- temp included in
B-W
###  Weinbiet(Hor) (R-P)		44(SWR-RP)
# T 658000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K44 (SFN R-P)

### In the west to southwest, one may receive a number of broadcasts from
### the Alsace in France.  These are horizontally polarised.
###  Strasbourg Nordheim	22-47-48-51-61-69
# ACHTUNG!  file fr-Strasbourg contains no content!  FIXME!
### need to verify FEC 2/3 + GI 1/32 (MFN), fix freqs
# T 482000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE	# K22
# T 682000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE	# K47
# T 690000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE	# K48
# T 714000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE	# K51
# T 794000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE	# K61
# T 858000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE	# K69

###  Mulhouse		37H	53H	54H	55H	65H	66H
### see fr-Mulhouse
# T 730000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE	# K53
# T 746000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE	# K55
# T 738000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE	# K54
# T 602000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE	# K37
# T 834000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE	# K66
# T 826000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE	# K65

-------------- next part --------------
### Regional frequency list Baden-Wuerttemberg.  Stand 05.11.2008, barry
bouwsma
###  known updates needed within 6 months at least (Aalen, Bad Mergentheim)

### In southwestern Germany, there are typically three frequencies in use
### at each transmitter site, with 50kW.  Horizontal polarisation is used.
### There are no repeater/filler transmitters at present or currently
planned.
### UHF frequencies only are used; the bitrate per multiplex is
13,27Mbit/sec,
### reflecting parameters based on a large coverage area and the potential
### for Single-Frequency Networks covering a yet larger area in some
regions.

### ZDFmobil multiplex; K21, K22, K23, K33
T 474000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K21 Heidelberg
T 482000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K22 Donaueschingen,
Raichberg, Ravensburg, Ulm
T 490000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K23 Stuttgart, Aalen,
Waldenburg
T 570000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K33 Baden Baden,
Brandenkopf, Freiburg, Hochrhein, Pforzheim
### SWR-BW multiplex; K39, K40, K41, K49, K50
T 618000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K39 Brandenkopf, Freiburg,
Hochrhein
T 626000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K40 Raichberg, Ravensburg,
Ulm
T 634000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K41 Donaueschingen
T 698000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K49 Baden Baden,
Heidelberg, Pforzheim
T 706000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K50 Stuttgart, Aalen,
Waldenburg
### ARD multiplex; K26, K43, K52, K54, K60; K53->K59
T 514000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K26 Stuttgart, Waldenburg
T 650000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K43 Raichberg, Ravensburg,
Ulm
T 722000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K52 Brandenkopf, Freiburg,
Hochrhein
T 738000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K54 Donaueschingen
T 786000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K60 Baden Baden,
Heidelberg, Pforzheim
T 730000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K53 Aalen, until early
2009
T 778000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K59 Aalen starting 2009

###  Transmitter locations and multiplex frequencies:
###   Geographic data hopefully in degrees min sec, taken from several
sources,
###   followed by antenna base height in metres above sea level, plus either
###   antenna mast height or height of centre of antenna array -- due to the
###   variety of sources as well as antenna modifications, may not be
precise.
###   Also, official-seeming sources don't quite match other data I've
found, so
###   you probably don't want to use this to set your ICBM coordinates for
less
###   than multi-megatonne payloads just now, without researching yourself.
###
###					ARD	ZDF	SWR
###  Aalen				53->59	23	50
###   Flexner, Wasseralfingen:		48N51'39" 10E08'15" 722+140m
###  Baden-Baden			60	33	49
###   Fremserberg:			48N45'10" 08E12'08" 525+174m
###  Brandenkopf			52	33	39
###   N of Hausach (Schwarzwaldbahn):	48N20'18" 08E09'12" 930+125m
###  Donaueschingen			54	22	41
###   Huefingen:			47N53'17" 08E34'37" 917+129m
###  Freiburg im Breisgau		52	33	39
###   Totenkopf, Vogtsburg/Kaiserstuhl:	48N04'51" 07E40'09" 557+155m
###  Heidelberg				60	21	49
###   Koenigstuhl:			49N24'14" 08E43'42" 563+82m
###  Hochrhein				52	33	39
###   Bergalingen-Jungholz, above Bad Saeckingen: 47N36'12" 07E56'56"
800+184m
###  Pforzheim				60	33	49
###   Schoemberg Langenbrand:		48N48'28" 08E37'27" 707+148m
###  Raichberg				43	22	40
###   Albstadt Onstmettingen, SW of Reutlingen:	48N18'22" 08E59'32" 954+137m
###  Ravensburg				43	22	40
###   Hoechsten, Glashuetten:		47N49'19" 09E29'58" 829+171m
###  Stuttgart				26	23	50
###   Frauenkopf:			48N45'49" 09E12'21" 462+192m
###  Ulm				43	22	40
###   Ermingen:				48N23'25" 09N53'45" 640+162m
###  Waldenburg				26	23	50
###   Friedrichsberg, NW of Schwaebisch Hall: 49N11'05" 09E39'56" 498+150m

###  from 2009:
###  Bad Mergentheim			?
###   Loeffelstelzen, am Ketterwald:	49N30'30" 09E47'01" 353+173m


### In many areas, it is possible to receive transmissions from adjacent
lands.
### The following frequencies are listed for convenience, but commented
### out to speed normal scanning, so that if you know you are near a
following
### location, you can uncomment just that location and tune those
frequencies.
###
### It's also possible that additional more distant transmitters may
### be received than the nearest ones I've listed but have not checked,
### in favourable locations or with a well-installed rooftop antenna.
### If these can be always received clearly and easily, especially if they
### add additional programming normally not received, they should be added.

### In the south, along the border with Switzerland, one may receive the
### Single-Frequency Networks used.  These are all sent with VERTICAL
### polarisation, with a mix of high- and low-power transmitters.
###  see ch-All

### In the southwest, near Basel, a french-swiss multiplex
# T 754000000 8MHz 5/6 NONE QAM16 8k 1/4 NONE	# K56

### Starting from the southwest, the german-swiss multiplex can be received
### over three frequencies (also shared by DVB-H in part), from west to east
# T 554000000 8MHz 5/6 NONE QAM16 8k 1/4 NONE	# K31
# T 562000000 8MHz 5/6 NONE QAM16 8k 1/4 NONE	# K32
# T 578000000 8MHz 5/6 NONE QAM16 8k 1/4 NONE	# K34

### In the southeast, one may receive two Austrian multiplexes, from the
### high-power Pfaender.  Transmissions horizontal
### A DVB-H multiplex (MUX D) exists too; a regional (MUX C) not at this
time
###  see at-Official
# T 474000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE	# K21
# T 498000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE	# K24

### Along the east and northeast, one may receive the high-power trasmitters
### from Bayern, with three multiplexes similar to the local content.
### Nearby transmitters are horizontal.  Listed south to northwest.
###					ARD	ZDF	BR(/SWR)
###  Gruenten (Bayern)			45	28	46
# T 530000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K28
# T 666000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K45
# T 674000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K46
###  Hohenpeissenberg (Bayern) ?	47	28	53
# T 682000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K47
# T 730000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K53 -- temp included in
B-W
###  Augsburg(Hor)			36	44	25
# T 506000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K25
# T 594000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K36
# T 658000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K44
###  Hesselberg				55	44	47
###  + Buettelberg			55	x	47
# T 658000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K44
# T 682000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K47
# T 746000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K55
###  Wuerzburg				10	25	45
# T 212500000 7MHz 3/4 NONE QAM16 8k 1/4 NONE	# K10
# T 506000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K25
# T 666000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K45
###  Pfaffenberg			36	25	46
# T 506000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K25
# T 594000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K36
# T 674000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K46

### In the northwest, one may receive high-power transmitters from Hessen
### to the north, or Rheinland-Pfalz to the west, content similar.
###					ARD	ZDF	HR/SWR
###  Wuerzberg/Odenwald(Hor) (Hessen)	37	21	53
### (Is it possible to receive the vertical Rhein-Main multiplexes,
### including private commercial broadcasters otherwise not seen?)
# T 474000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K21 -- included in B-W
# T 602000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K37
# T 730000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K53 -- temp included in
B-W
###  Weinbiet(Hor) (R-P)		44(SWR-RP)
# T 658000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K44 (SFN R-P)

### In the west to southwest, one may receive a number of broadcasts from
### the Alsace in France.  These are horizontally polarised.
###  Strasbourg Nordheim	22-47-48-51-61-69
# ACHTUNG!  file fr-Strasbourg contains no content!  FIXME!
### need to verify FEC 2/3 + GI 1/32 (MFN), fix freqs
# T 482000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE	# K22
# T 682000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE	# K47
# T 690000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE	# K48
# T 714000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE	# K51
# T 794000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE	# K61
# T 858000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE	# K69

###  Mulhouse		37H	53H	54H	55H	65H	66H
### see fr-Mulhouse
# T 730000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE	# K53
# T 746000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE	# K55
# T 738000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE	# K54
# T 602000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE	# K37
# T 834000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE	# K66
# T 826000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE	# K65



------------------------------

Message: 3
Date: Sun, 16 Nov 2008 12:38:33 -0500
From: CityK <cityk@rogers.com>
Subject: Re: [linux-dvb] hvr 1400
To: djamil <djamil@djamil.net>
Cc: linux-dvb@linuxtv.org
Message-ID: <49205A99.5050902@rogers.com>
Content-Type: text/plain; charset=ISO-8859-1

djamil wrote:
> hello  again
>
> gents, i wrote in 96 the first X11 application to drive a radio card
> in florida ...
>
> so can anyone tell me about spying proramms under windows to reverse
> engeneer what wintv does ant the drivers
>
> so i can get analog working in linux ?
>
> best regards

Hi again,

I missed your earlier thread (
http://marc.info/?l=linux-dvb&m=122530861931653&w=2 ), but as you know
from it, this is a cx23885 based device.

There have been a couple reports of success with NTSC analogue with that
part I believe.  Anyway, read through these two threads which will
likely provided some direction:

* http://marc.info/?l=linux-dvb&m=122238944905049&w=2
* http://marc.info/?l=linux-dvb&m=122169029925610&w=2

There is a post from today that might be of interest too:
* http://marc.info/?l=linux-dvb&m=122682215128088&w=2






------------------------------

Message: 4
Date: Sun, 16 Nov 2008 13:22:07 -0500
From: CityK <cityk@rogers.com>
Subject: Re: [linux-dvb] Avermedia A312
To: "daniel.perzynski" <daniel.perzynski@aster.pl>,
	linux-dvb@linuxtv.org
Message-ID: <492064CF.1010007@rogers.com>
Content-Type: text/plain; charset=iso-8859-2

daniel.perzynski wrote:
> Thanks for the info. I'm in the process of gathering those hi res
> pictures but not only for A312 but also for A301 and A321 models. Then
> I will update the wiki for them. A301 is very similar to A312 from
> windows driver inf file point of view and is supported under Linux by
> Avermedia A828 driver. Unfortunately adding A312 device id to the
> source code of A828 driver didn't help.
>
> What is concerning mini pci having usb interface I can say only that on
> Avermedia webpage that card is in Mini PCI & Mini Card category.

Thanks Daniel. ... not sure why your reply didn't make it onto the list
(as you did indeed cc it in), anyway, I've included it above.  Cheers





------------------------------

Message: 5
Date: Sun, 16 Nov 2008 13:27:40 -0500
From: CityK <cityk@rogers.com>
Subject: Re: [linux-dvb] [Bulk] [PATCH] [resent] Leadtek WinFast
	DTV-1800H support
To: Miroslav ?ustek <sustmidown@centrum.cz>
Cc: linux-dvb@linuxtv.org
Message-ID: <4920661C.9020601@rogers.com>
Content-Type: text/plain; charset=UTF-8

Miroslav ?ustek wrote:
> Hello,
>
> Here is patch for Leadtek WinFast DTV-1800H.
> It enables support for digital TV, analogue TV and radio.
> I have already sent it here, but as I am newbie the patch wasn't
> compatible with "Linux Kernel Coding Style".
>
> That's probably the reason why the patch hasn't been pushed
> into the repository yet.
>   

Likely something much more benign -- simply overlooked or hasn't been
spotted yet ... (I believe Mauro is pretty  busy recently and, in
general, traffic on the lists is way down :(  ).

> Now the patch meets the LKCS requirements.
> (checked using: linux/scripts/checkpatch.pl)
>
> Thanks for the advice.
> I hope everything is correct now.

Mauro will want you to add your "signed of by "  ... for further details
see: http://linuxtv.org/hg/v4l-dvb/file/0f7686e28ff5/README.patches



------------------------------

Message: 6
Date: Sun, 16 Nov 2008 13:29:26 -0500
From: CityK <cityk@rogers.com>
Subject: Re: [linux-dvb] SAA7162 status
To: James Le Cuirot <chewi@aura-online.co.uk>
Cc: linux-dvb@linuxtv.org
Message-ID: <49206686.1080209@rogers.com>
Content-Type: text/plain; charset=us-ascii

James Le Cuirot wrote:
> Hi guys,
>
> Any news on SAA7162? I know this is asked fairly often but it's been a
> couple of months since the last update. I did read that NXP are trying
> to gauge the amount of user interest. Well here is one Linux user who
> would buy such a card very soon if a working driver became available. I
> am also pondering about DVB-S2/T2 but I guess DVB-S/T isn't going away
> in the UK just yet. :)
>
>   

Best I can give you is this:
http://marc.info/?l=linux-video&m=122662096530211&w=2



------------------------------

Message: 7
Date: Sun, 16 Nov 2008 10:40:16 -0800
From: "VDR User" <user.vdr@gmail.com>
Subject: Re: [linux-dvb] SAA7162 status
To: CityK <cityk@rogers.com>
Cc: linux-dvb@linuxtv.org
Message-ID:
	<a3ef07920811161040y5b92454ave310224490e6e273@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1

I'm waiting for saa716x drivers as well.  Hopefully we'll see some
progress with them soon.  I know Manu had been working on it but not
sure how far along they are, and no clue how far Steven Toth got.



------------------------------

Message: 8
Date: Sun, 16 Nov 2008 20:14:20 +0100
From: Alain Kalker <miki@dds.nl>
Subject: [linux-dvb] [PATCH] af9015: Add support for the Digittrade
	DVB-T	USB Stick remote
To: linux-dvb@linuxtv.org
Message-ID:
	<c01a6fbc461724bf209d.1226862860@miki-debian.ensch1.ov.home.nl>
Content-Type: text/plain; charset="us-ascii"

From: Alain Kalker <miki@dds.nl>

Adds support for the Digittrade DVB-T USB Stick remote.
As the Digittrade USB stick identifies itself as a generic Afatech AF9015
device, the remote cannot be autodetected. To enable it, add the following
to /etc/modprobe.d/dvb-usb-af9015 or /etc/modprobe.conf:

options dvb-usb-af9015 remote=4

Priority: normal

Signed-off-by: Alain Kalker <miki@dds.nl>

diff -r 0f7686e28ff5 -r c01a6fbc4617
linux/drivers/media/dvb/dvb-usb/af9015.c
--- a/linux/drivers/media/dvb/dvb-usb/af9015.c	Sun Nov 16 09:05:06 2008
-0200
+++ b/linux/drivers/media/dvb/dvb-usb/af9015.c	Sun Nov 16 20:08:07 2008
+0100
@@ -738,6 +738,16 @@
 				  af9015_ir_table_mygictv;
 				af9015_config.ir_table_size =
 				  ARRAY_SIZE(af9015_ir_table_mygictv);
+				break;
+			case AF9015_REMOTE_DIGITTRADE_DVB_T:
+				af9015_properties[i].rc_key_map =
+				  af9015_rc_keys_digittrade;
+				af9015_properties[i].rc_key_map_size =
+				  ARRAY_SIZE(af9015_rc_keys_digittrade);
+				af9015_config.ir_table =
+				  af9015_ir_table_digittrade;
+				af9015_config.ir_table_size =
+				  ARRAY_SIZE(af9015_ir_table_digittrade);
 				break;
 			}
 		} else {
diff -r 0f7686e28ff5 -r c01a6fbc4617
linux/drivers/media/dvb/dvb-usb/af9015.h
--- a/linux/drivers/media/dvb/dvb-usb/af9015.h	Sun Nov 16 09:05:06 2008
-0200
+++ b/linux/drivers/media/dvb/dvb-usb/af9015.h	Sun Nov 16 20:08:07 2008
+0100
@@ -123,6 +123,7 @@
 	AF9015_REMOTE_A_LINK_DTU_M,
 	AF9015_REMOTE_MSI_DIGIVOX_MINI_II_V3,
 	AF9015_REMOTE_MYGICTV_U718,
+	AF9015_REMOTE_DIGITTRADE_DVB_T,
 };
 
 /* Leadtek WinFast DTV Dongle Gold */
@@ -596,4 +597,67 @@
 	0x03, 0xfc, 0x03, 0xfc, 0x0e, 0x05, 0x00,
 };
 
+/* Digittrade DVB-T USB Stick */
+static struct dvb_usb_rc_key af9015_rc_keys_digittrade[] = {
+	{ 0x01, 0x0f, KEY_LAST },	/* RETURN */
+	{ 0x05, 0x17, KEY_TEXT },	/* TELETEXT */
+	{ 0x01, 0x08, KEY_EPG },	/* EPG */
+	{ 0x05, 0x13, KEY_POWER },	/* POWER */
+	{ 0x01, 0x09, KEY_ZOOM },	/* FULLSCREEN */
+	{ 0x00, 0x40, KEY_AUDIO },	/* DUAL SOUND */
+	{ 0x00, 0x2c, KEY_PRINT },	/* SNAPSHOT */
+	{ 0x05, 0x16, KEY_SUBTITLE },	/* SUBTITLE */
+	{ 0x00, 0x52, KEY_CHANNELUP },	/* CH Up */
+	{ 0x00, 0x51, KEY_CHANNELDOWN },/* Ch Dn */
+	{ 0x00, 0x57, KEY_VOLUMEUP },	/* Vol Up */
+	{ 0x00, 0x56, KEY_VOLUMEDOWN },	/* Vol Dn */
+	{ 0x01, 0x10, KEY_MUTE },	/* MUTE */
+	{ 0x00, 0x27, KEY_0 },
+	{ 0x00, 0x1e, KEY_1 },
+	{ 0x00, 0x1f, KEY_2 },
+	{ 0x00, 0x20, KEY_3 },
+	{ 0x00, 0x21, KEY_4 },
+	{ 0x00, 0x22, KEY_5 },
+	{ 0x00, 0x23, KEY_6 },
+	{ 0x00, 0x24, KEY_7 },
+	{ 0x00, 0x25, KEY_8 },
+	{ 0x00, 0x26, KEY_9 },
+	{ 0x01, 0x17, KEY_PLAYPAUSE },	/* TIMESHIFT */
+	{ 0x01, 0x15, KEY_RECORD },	/* RECORD */
+	{ 0x03, 0x13, KEY_PLAY },	/* PLAY */
+	{ 0x01, 0x16, KEY_STOP },	/* STOP */
+	{ 0x01, 0x13, KEY_PAUSE },	/* PAUSE */
+};
+
+static u8 af9015_ir_table_digittrade[] = {
+	0x00, 0xff, 0x06, 0xf9, 0x13, 0x05, 0x00,
+	0x00, 0xff, 0x4d, 0xb2, 0x17, 0x01, 0x00,
+	0x00, 0xff, 0x1f, 0xe0, 0x2c, 0x00, 0x00,
+	0x00, 0xff, 0x0a, 0xf5, 0x15, 0x01, 0x00,
+	0x00, 0xff, 0x0e, 0xf1, 0x16, 0x01, 0x00,
+	0x00, 0xff, 0x09, 0xf6, 0x09, 0x01, 0x00,
+	0x00, 0xff, 0x01, 0xfe, 0x08, 0x01, 0x00,
+	0x00, 0xff, 0x05, 0xfa, 0x10, 0x01, 0x00,
+	0x00, 0xff, 0x02, 0xfd, 0x56, 0x00, 0x00,
+	0x00, 0xff, 0x40, 0xbf, 0x57, 0x00, 0x00,
+	0x00, 0xff, 0x19, 0xe6, 0x52, 0x00, 0x00,
+	0x00, 0xff, 0x17, 0xe8, 0x51, 0x00, 0x00,
+	0x00, 0xff, 0x10, 0xef, 0x0f, 0x01, 0x00,
+	0x00, 0xff, 0x54, 0xab, 0x27, 0x00, 0x00,
+	0x00, 0xff, 0x1b, 0xe4, 0x1e, 0x00, 0x00,
+	0x00, 0xff, 0x11, 0xee, 0x1f, 0x00, 0x00,
+	0x00, 0xff, 0x15, 0xea, 0x20, 0x00, 0x00,
+	0x00, 0xff, 0x12, 0xed, 0x21, 0x00, 0x00,
+	0x00, 0xff, 0x16, 0xe9, 0x22, 0x00, 0x00,
+	0x00, 0xff, 0x4c, 0xb3, 0x23, 0x00, 0x00,
+	0x00, 0xff, 0x48, 0xb7, 0x24, 0x00, 0x00,
+	0x00, 0xff, 0x04, 0xfb, 0x25, 0x00, 0x00,
+	0x00, 0xff, 0x00, 0xff, 0x26, 0x00, 0x00,
+	0x00, 0xff, 0x1e, 0xe1, 0x13, 0x03, 0x00,
+	0x00, 0xff, 0x1a, 0xe5, 0x13, 0x01, 0x00,
+	0x00, 0xff, 0x03, 0xfc, 0x17, 0x05, 0x00,
+	0x00, 0xff, 0x0d, 0xf2, 0x16, 0x05, 0x00,
+	0x00, 0xff, 0x1d, 0xe2, 0x40, 0x00, 0x00,
+};
+
 #endif



------------------------------

Message: 9
Date: Sun, 16 Nov 2008 21:28:17 +0100
From: "Miroslav  ?ustek " <sustmidown@centrum.cz>
Subject: Re: [linux-dvb] [Bulk] [PATCH] [resent] Leadtek WinFast
	DTV-1800H	support
To: <cityk@rogers.com>
Cc: linux-dvb@linuxtv.org
Message-ID: <200811162128.22108@centrum.cz>
Content-Type: text/plain; charset="utf-8"

CityK wrote:
>Miroslav ?ustek wrote:
>> Hello,
>>
>> Here is patch for Leadtek WinFast DTV-1800H.
>> It enables support for digital TV, analogue TV and radio.
>> I have already sent it here, but as I am newbie the patch wasn't
>> compatible with "Linux Kernel Coding Style".
>>
>> That's probably the reason why the patch hasn't been pushed
>> into the repository yet.
>>   
>
>Likely something much more benign -- simply overlooked or hasn't been
>spotted yet ... (I believe Mauro is pretty  busy recently and, in
>general, traffic on the lists is way down :(  ).
>
>> Now the patch meets the LKCS requirements.
>> (checked using: linux/scripts/checkpatch.pl)
>>
>> Thanks for the advice.
>> I hope everything is correct now.
>
>Mauro will want you to add your "signed of by "  ... for further details
>see: http://linuxtv.org/hg/v4l-dvb/file/0f7686e28ff5/README.patches
>

New (signed) patch attached.
Third time and last time. :)

-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: text/x-patch
Size: 5002 bytes
Desc: not available
Url :
http://www.linuxtv.org/pipermail/linux-dvb/attachments/20081116/f54b9876/att
achment-0001.bin 

------------------------------

Message: 10
Date: Sun, 16 Nov 2008 18:06:47 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
Subject: [linux-dvb] Attention em28xx users
To: Linux-dvb <linux-dvb@linuxtv.org>, V4L
	<video4linux-list@redhat.com>
Message-ID:
	<412bdbff0811161506j3566ad4dsae09a3e1d7559e3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1

Hello there,

Over the last few days I have been been pushing a number of
fixes/improvements into the mainline em28xx driver.  These include
remote control fixes, em2874 device support, and other cleanups.  I
look forward to continuing to improve the driver now that Empia has
been so kind to provide me with datasheets.

One concern about the mainline em28xx driver expressed has to do with
device support.  There are many, many devices out there, and I need
help ensuring that they work properly with the driver.  Now is the
time for users who have non-working em28xx-based devices to come
forward.

I am willing to debug any ATSC/NTSC em28xx based device a user cannot
get to work under Linux, for the cost of shipping me the device for
one week (I'll pay return shipping).  We're at the point now where
most of them are pretty easy to get working, but I cannot afford to
buy every $50 device out there.

The only condition I'm restricting this to at this point is the em28xx
based device needs to have pre-existing chipset support for the other
components (such as the video decoder, demodulator, and tuner).
However, this does represent a vast majority of the em28xx based
devices out there.  Also, I'm keeping it to ATSC/NTSC because I don't
have any access to a DVB based signal.

Users of em28xx based devices that want to see them supported:  Now is
the time to contact me.  If you're interested, please email me the
product name, the list of chips in the device, and I will work with
you to get it supported.

Regards,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller



------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

End of linux-dvb Digest, Vol 46, Issue 19
*****************************************


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
