Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.189])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1L1kkD-00018R-Ct
	for linux-dvb@linuxtv.org; Sun, 16 Nov 2008 17:45:08 +0100
Received: by nf-out-0910.google.com with SMTP id g13so1107533nfb.11
	for <linux-dvb@linuxtv.org>; Sun, 16 Nov 2008 08:45:00 -0800 (PST)
Date: Sun, 16 Nov 2008 17:44:30 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: linux-dvb@linuxtv.org
Message-ID: <alpine.DEB.2.00.0811161441270.6408@ybpnyubfg.ybpnyqbznva>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1091934717-1226853882=:6408"
Subject: [linux-dvb] scanfile for Bundesland Baden-Wuerttemberg, Germany
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1091934717-1226853882=:6408
Content-Type: TEXT/PLAIN; charset=US-ASCII

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


### Regional frequency list Baden-Wuerttemberg.  Stand 05.11.2008, barry bouwsma
###  known updates needed within 6 months at least (Aalen, Bad Mergentheim)

### In southwestern Germany, there are typically three frequencies in use
### at each transmitter site, with 50kW.  Horizontal polarisation is used.
### There are no repeater/filler transmitters at present or currently planned.
### UHF frequencies only are used; the bitrate per multiplex is 13,27Mbit/sec,
### reflecting parameters based on a large coverage area and the potential
### for Single-Frequency Networks covering a yet larger area in some regions.

### ZDFmobil multiplex; K21, K22, K23, K33
T 474000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K21 Heidelberg
T 482000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K22 Donaueschingen, Raichberg, Ravensburg, Ulm
T 490000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K23 Stuttgart, Aalen, Waldenburg
T 570000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K33 Baden Baden, Brandenkopf, Freiburg, Hochrhein, Pforzheim
### SWR-BW multiplex; K39, K40, K41, K49, K50
T 618000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K39 Brandenkopf, Freiburg, Hochrhein
T 626000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K40 Raichberg, Ravensburg, Ulm
T 634000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K41 Donaueschingen
T 698000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K49 Baden Baden, Heidelberg, Pforzheim
T 706000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K50 Stuttgart, Aalen, Waldenburg
### ARD multiplex; K26, K43, K52, K54, K60; K53->K59
T 514000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K26 Stuttgart, Waldenburg
T 650000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K43 Raichberg, Ravensburg, Ulm
T 722000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K52 Brandenkopf, Freiburg, Hochrhein
T 738000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K54 Donaueschingen
T 786000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K60 Baden Baden, Heidelberg, Pforzheim
T 730000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K53 Aalen, until early 2009
T 778000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K59 Aalen starting 2009

###  Transmitter locations and multiplex frequencies:
###   Geographic data hopefully in degrees min sec, taken from several sources,
###   followed by antenna base height in metres above sea level, plus either
###   antenna mast height or height of centre of antenna array -- due to the
###   variety of sources as well as antenna modifications, may not be precise.
###   Also, official-seeming sources don't quite match other data I've found, so
###   you probably don't want to use this to set your ICBM coordinates for less
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
###   Bergalingen-Jungholz, above Bad Saeckingen: 47N36'12" 07E56'56" 800+184m
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


### In many areas, it is possible to receive transmissions from adjacent lands.
### The following frequencies are listed for convenience, but commented
### out to speed normal scanning, so that if you know you are near a following
### location, you can uncomment just that location and tune those frequencies.
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
### A DVB-H multiplex (MUX D) exists too; a regional (MUX C) not at this time
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
# T 730000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K53 -- temp included in B-W
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
# T 730000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE	# K53 -- temp included in B-W
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


--8323328-1091934717-1226853882=:6408
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=de-Baden-Wuerttemberg
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.00.0811161744300.6408@ybpnyubfg.ybpnyqbznva>
Content-Description: scanfile for Baden-Wuerttemberg Germany and nearby areas
Content-Disposition: attachment; filename=de-Baden-Wuerttemberg

IyMjIFJlZ2lvbmFsIGZyZXF1ZW5jeSBsaXN0IEJhZGVuLVd1ZXJ0dGVtYmVy
Zy4gIFN0YW5kIDA1LjExLjIwMDgsIGJhcnJ5IGJvdXdzbWENCiMjIyAga25v
d24gdXBkYXRlcyBuZWVkZWQgd2l0aGluIDYgbW9udGhzIGF0IGxlYXN0IChB
YWxlbiwgQmFkIE1lcmdlbnRoZWltKQ0KDQojIyMgSW4gc291dGh3ZXN0ZXJu
IEdlcm1hbnksIHRoZXJlIGFyZSB0eXBpY2FsbHkgdGhyZWUgZnJlcXVlbmNp
ZXMgaW4gdXNlDQojIyMgYXQgZWFjaCB0cmFuc21pdHRlciBzaXRlLCB3aXRo
IDUwa1cuICBIb3Jpem9udGFsIHBvbGFyaXNhdGlvbiBpcyB1c2VkLg0KIyMj
IFRoZXJlIGFyZSBubyByZXBlYXRlci9maWxsZXIgdHJhbnNtaXR0ZXJzIGF0
IHByZXNlbnQgb3IgY3VycmVudGx5IHBsYW5uZWQuDQojIyMgVUhGIGZyZXF1
ZW5jaWVzIG9ubHkgYXJlIHVzZWQ7IHRoZSBiaXRyYXRlIHBlciBtdWx0aXBs
ZXggaXMgMTMsMjdNYml0L3NlYywNCiMjIyByZWZsZWN0aW5nIHBhcmFtZXRl
cnMgYmFzZWQgb24gYSBsYXJnZSBjb3ZlcmFnZSBhcmVhIGFuZCB0aGUgcG90
ZW50aWFsDQojIyMgZm9yIFNpbmdsZS1GcmVxdWVuY3kgTmV0d29ya3MgY292
ZXJpbmcgYSB5ZXQgbGFyZ2VyIGFyZWEgaW4gc29tZSByZWdpb25zLg0KDQoj
IyMgWkRGbW9iaWwgbXVsdGlwbGV4OyBLMjEsIEsyMiwgSzIzLCBLMzMNClQg
NDc0MDAwMDAwIDhNSHogMi8zIE5PTkUgUUFNMTYgOGsgMS80IE5PTkUJIyBL
MjEgSGVpZGVsYmVyZw0KVCA0ODIwMDAwMDAgOE1IeiAyLzMgTk9ORSBRQU0x
NiA4ayAxLzQgTk9ORQkjIEsyMiBEb25hdWVzY2hpbmdlbiwgUmFpY2hiZXJn
LCBSYXZlbnNidXJnLCBVbG0NClQgNDkwMDAwMDAwIDhNSHogMi8zIE5PTkUg
UUFNMTYgOGsgMS80IE5PTkUJIyBLMjMgU3R1dHRnYXJ0LCBBYWxlbiwgV2Fs
ZGVuYnVyZw0KVCA1NzAwMDAwMDAgOE1IeiAyLzMgTk9ORSBRQU0xNiA4ayAx
LzQgTk9ORQkjIEszMyBCYWRlbiBCYWRlbiwgQnJhbmRlbmtvcGYsIEZyZWli
dXJnLCBIb2NocmhlaW4sIFBmb3J6aGVpbQ0KIyMjIFNXUi1CVyBtdWx0aXBs
ZXg7IEszOSwgSzQwLCBLNDEsIEs0OSwgSzUwDQpUIDYxODAwMDAwMCA4TUh6
IDIvMyBOT05FIFFBTTE2IDhrIDEvNCBOT05FCSMgSzM5IEJyYW5kZW5rb3Bm
LCBGcmVpYnVyZywgSG9jaHJoZWluDQpUIDYyNjAwMDAwMCA4TUh6IDIvMyBO
T05FIFFBTTE2IDhrIDEvNCBOT05FCSMgSzQwIFJhaWNoYmVyZywgUmF2ZW5z
YnVyZywgVWxtDQpUIDYzNDAwMDAwMCA4TUh6IDIvMyBOT05FIFFBTTE2IDhr
IDEvNCBOT05FCSMgSzQxIERvbmF1ZXNjaGluZ2VuDQpUIDY5ODAwMDAwMCA4
TUh6IDIvMyBOT05FIFFBTTE2IDhrIDEvNCBOT05FCSMgSzQ5IEJhZGVuIEJh
ZGVuLCBIZWlkZWxiZXJnLCBQZm9yemhlaW0NClQgNzA2MDAwMDAwIDhNSHog
Mi8zIE5PTkUgUUFNMTYgOGsgMS80IE5PTkUJIyBLNTAgU3R1dHRnYXJ0LCBB
YWxlbiwgV2FsZGVuYnVyZw0KIyMjIEFSRCBtdWx0aXBsZXg7IEsyNiwgSzQz
LCBLNTIsIEs1NCwgSzYwOyBLNTMtPks1OQ0KVCA1MTQwMDAwMDAgOE1IeiAy
LzMgTk9ORSBRQU0xNiA4ayAxLzQgTk9ORQkjIEsyNiBTdHV0dGdhcnQsIFdh
bGRlbmJ1cmcNClQgNjUwMDAwMDAwIDhNSHogMi8zIE5PTkUgUUFNMTYgOGsg
MS80IE5PTkUJIyBLNDMgUmFpY2hiZXJnLCBSYXZlbnNidXJnLCBVbG0NClQg
NzIyMDAwMDAwIDhNSHogMi8zIE5PTkUgUUFNMTYgOGsgMS80IE5PTkUJIyBL
NTIgQnJhbmRlbmtvcGYsIEZyZWlidXJnLCBIb2NocmhlaW4NClQgNzM4MDAw
MDAwIDhNSHogMi8zIE5PTkUgUUFNMTYgOGsgMS80IE5PTkUJIyBLNTQgRG9u
YXVlc2NoaW5nZW4NClQgNzg2MDAwMDAwIDhNSHogMi8zIE5PTkUgUUFNMTYg
OGsgMS80IE5PTkUJIyBLNjAgQmFkZW4gQmFkZW4sIEhlaWRlbGJlcmcsIFBm
b3J6aGVpbQ0KVCA3MzAwMDAwMDAgOE1IeiAyLzMgTk9ORSBRQU0xNiA4ayAx
LzQgTk9ORQkjIEs1MyBBYWxlbiwgdW50aWwgZWFybHkgMjAwOQ0KVCA3Nzgw
MDAwMDAgOE1IeiAyLzMgTk9ORSBRQU0xNiA4ayAxLzQgTk9ORQkjIEs1OSBB
YWxlbiBzdGFydGluZyAyMDA5DQoNCiMjIyAgVHJhbnNtaXR0ZXIgbG9jYXRp
b25zIGFuZCBtdWx0aXBsZXggZnJlcXVlbmNpZXM6DQojIyMgICBHZW9ncmFw
aGljIGRhdGEgaG9wZWZ1bGx5IGluIGRlZ3JlZXMgbWluIHNlYywgdGFrZW4g
ZnJvbSBzZXZlcmFsIHNvdXJjZXMsDQojIyMgICBmb2xsb3dlZCBieSBhbnRl
bm5hIGJhc2UgaGVpZ2h0IGluIG1ldHJlcyBhYm92ZSBzZWEgbGV2ZWwsIHBs
dXMgZWl0aGVyDQojIyMgICBhbnRlbm5hIG1hc3QgaGVpZ2h0IG9yIGhlaWdo
dCBvZiBjZW50cmUgb2YgYW50ZW5uYSBhcnJheSAtLSBkdWUgdG8gdGhlDQoj
IyMgICB2YXJpZXR5IG9mIHNvdXJjZXMgYXMgd2VsbCBhcyBhbnRlbm5hIG1v
ZGlmaWNhdGlvbnMsIG1heSBub3QgYmUgcHJlY2lzZS4NCiMjIyAgIEFsc28s
IG9mZmljaWFsLXNlZW1pbmcgc291cmNlcyBkb24ndCBxdWl0ZSBtYXRjaCBv
dGhlciBkYXRhIEkndmUgZm91bmQsIHNvDQojIyMgICB5b3UgcHJvYmFibHkg
ZG9uJ3Qgd2FudCB0byB1c2UgdGhpcyB0byBzZXQgeW91ciBJQ0JNIGNvb3Jk
aW5hdGVzIGZvciBsZXNzDQojIyMgICB0aGFuIG11bHRpLW1lZ2F0b25uZSBw
YXlsb2FkcyBqdXN0IG5vdywgd2l0aG91dCByZXNlYXJjaGluZyB5b3Vyc2Vs
Zi4NCiMjIw0KIyMjCQkJCQlBUkQJWkRGCVNXUg0KIyMjICBBYWxlbgkJCQk1
My0+NTkJMjMJNTANCiMjIyAgIEZsZXhuZXIsIFdhc3NlcmFsZmluZ2VuOgkJ
NDhONTEnMzkiIDEwRTA4JzE1IiA3MjIrMTQwbQ0KIyMjICBCYWRlbi1CYWRl
bgkJCTYwCTMzCTQ5DQojIyMgICBGcmVtc2VyYmVyZzoJCQk0OE40NScxMCIg
MDhFMTInMDgiIDUyNSsxNzRtDQojIyMgIEJyYW5kZW5rb3BmCQkJNTIJMzMJ
MzkNCiMjIyAgIE4gb2YgSGF1c2FjaCAoU2Nod2FyendhbGRiYWhuKToJNDhO
MjAnMTgiIDA4RTA5JzEyIiA5MzArMTI1bQ0KIyMjICBEb25hdWVzY2hpbmdl
bgkJCTU0CTIyCTQxDQojIyMgICBIdWVmaW5nZW46CQkJNDdONTMnMTciIDA4
RTM0JzM3IiA5MTcrMTI5bQ0KIyMjICBGcmVpYnVyZyBpbSBCcmVpc2dhdQkJ
NTIJMzMJMzkNCiMjIyAgIFRvdGVua29wZiwgVm9ndHNidXJnL0thaXNlcnN0
dWhsOgk0OE4wNCc1MSIgMDdFNDAnMDkiIDU1NysxNTVtDQojIyMgIEhlaWRl
bGJlcmcJCQkJNjAJMjEJNDkNCiMjIyAgIEtvZW5pZ3N0dWhsOgkJCTQ5TjI0
JzE0IiAwOEU0Myc0MiIgNTYzKzgybQ0KIyMjICBIb2NocmhlaW4JCQkJNTIJ
MzMJMzkNCiMjIyAgIEJlcmdhbGluZ2VuLUp1bmdob2x6LCBhYm92ZSBCYWQg
U2FlY2tpbmdlbjogNDdOMzYnMTIiIDA3RTU2JzU2IiA4MDArMTg0bQ0KIyMj
ICBQZm9yemhlaW0JCQkJNjAJMzMJNDkNCiMjIyAgIFNjaG9lbWJlcmcgTGFu
Z2VuYnJhbmQ6CQk0OE40OCcyOCIgMDhFMzcnMjciIDcwNysxNDhtDQojIyMg
IFJhaWNoYmVyZwkJCQk0MwkyMgk0MA0KIyMjICAgQWxic3RhZHQgT25zdG1l
dHRpbmdlbiwgU1cgb2YgUmV1dGxpbmdlbjoJNDhOMTgnMjIiIDA4RTU5JzMy
IiA5NTQrMTM3bQ0KIyMjICBSYXZlbnNidXJnCQkJCTQzCTIyCTQwDQojIyMg
ICBIb2VjaHN0ZW4sIEdsYXNodWV0dGVuOgkJNDdONDknMTkiIDA5RTI5JzU4
IiA4MjkrMTcxbQ0KIyMjICBTdHV0dGdhcnQJCQkJMjYJMjMJNTANCiMjIyAg
IEZyYXVlbmtvcGY6CQkJNDhONDUnNDkiIDA5RTEyJzIxIiA0NjIrMTkybQ0K
IyMjICBVbG0JCQkJNDMJMjIJNDANCiMjIyAgIEVybWluZ2VuOgkJCQk0OE4y
MycyNSIgMDlONTMnNDUiIDY0MCsxNjJtDQojIyMgIFdhbGRlbmJ1cmcJCQkJ
MjYJMjMJNTANCiMjIyAgIEZyaWVkcmljaHNiZXJnLCBOVyBvZiBTY2h3YWVi
aXNjaCBIYWxsOiA0OU4xMScwNSIgMDlFMzknNTYiIDQ5OCsxNTBtDQoNCiMj
IyAgZnJvbSAyMDA5Og0KIyMjICBCYWQgTWVyZ2VudGhlaW0JCQk/DQojIyMg
ICBMb2VmZmVsc3RlbHplbiwgYW0gS2V0dGVyd2FsZDoJNDlOMzAnMzAiIDA5
RTQ3JzAxIiAzNTMrMTczbQ0KDQoNCiMjIyBJbiBtYW55IGFyZWFzLCBpdCBp
cyBwb3NzaWJsZSB0byByZWNlaXZlIHRyYW5zbWlzc2lvbnMgZnJvbSBhZGph
Y2VudCBsYW5kcy4NCiMjIyBUaGUgZm9sbG93aW5nIGZyZXF1ZW5jaWVzIGFy
ZSBsaXN0ZWQgZm9yIGNvbnZlbmllbmNlLCBidXQgY29tbWVudGVkDQojIyMg
b3V0IHRvIHNwZWVkIG5vcm1hbCBzY2FubmluZywgc28gdGhhdCBpZiB5b3Ug
a25vdyB5b3UgYXJlIG5lYXIgYSBmb2xsb3dpbmcNCiMjIyBsb2NhdGlvbiwg
eW91IGNhbiB1bmNvbW1lbnQganVzdCB0aGF0IGxvY2F0aW9uIGFuZCB0dW5l
IHRob3NlIGZyZXF1ZW5jaWVzLg0KIyMjDQojIyMgSXQncyBhbHNvIHBvc3Np
YmxlIHRoYXQgYWRkaXRpb25hbCBtb3JlIGRpc3RhbnQgdHJhbnNtaXR0ZXJz
IG1heQ0KIyMjIGJlIHJlY2VpdmVkIHRoYW4gdGhlIG5lYXJlc3Qgb25lcyBJ
J3ZlIGxpc3RlZCBidXQgaGF2ZSBub3QgY2hlY2tlZCwNCiMjIyBpbiBmYXZv
dXJhYmxlIGxvY2F0aW9ucyBvciB3aXRoIGEgd2VsbC1pbnN0YWxsZWQgcm9v
ZnRvcCBhbnRlbm5hLg0KIyMjIElmIHRoZXNlIGNhbiBiZSBhbHdheXMgcmVj
ZWl2ZWQgY2xlYXJseSBhbmQgZWFzaWx5LCBlc3BlY2lhbGx5IGlmIHRoZXkN
CiMjIyBhZGQgYWRkaXRpb25hbCBwcm9ncmFtbWluZyBub3JtYWxseSBub3Qg
cmVjZWl2ZWQsIHRoZXkgc2hvdWxkIGJlIGFkZGVkLg0KDQojIyMgSW4gdGhl
IHNvdXRoLCBhbG9uZyB0aGUgYm9yZGVyIHdpdGggU3dpdHplcmxhbmQsIG9u
ZSBtYXkgcmVjZWl2ZSB0aGUNCiMjIyBTaW5nbGUtRnJlcXVlbmN5IE5ldHdv
cmtzIHVzZWQuICBUaGVzZSBhcmUgYWxsIHNlbnQgd2l0aCBWRVJUSUNBTA0K
IyMjIHBvbGFyaXNhdGlvbiwgd2l0aCBhIG1peCBvZiBoaWdoLSBhbmQgbG93
LXBvd2VyIHRyYW5zbWl0dGVycy4NCiMjIyAgc2VlIGNoLUFsbA0KDQojIyMg
SW4gdGhlIHNvdXRod2VzdCwgbmVhciBCYXNlbCwgYSBmcmVuY2gtc3dpc3Mg
bXVsdGlwbGV4DQojIFQgNzU0MDAwMDAwIDhNSHogNS82IE5PTkUgUUFNMTYg
OGsgMS80IE5PTkUJIyBLNTYNCg0KIyMjIFN0YXJ0aW5nIGZyb20gdGhlIHNv
dXRod2VzdCwgdGhlIGdlcm1hbi1zd2lzcyBtdWx0aXBsZXggY2FuIGJlIHJl
Y2VpdmVkDQojIyMgb3ZlciB0aHJlZSBmcmVxdWVuY2llcyAoYWxzbyBzaGFy
ZWQgYnkgRFZCLUggaW4gcGFydCksIGZyb20gd2VzdCB0byBlYXN0DQojIFQg
NTU0MDAwMDAwIDhNSHogNS82IE5PTkUgUUFNMTYgOGsgMS80IE5PTkUJIyBL
MzENCiMgVCA1NjIwMDAwMDAgOE1IeiA1LzYgTk9ORSBRQU0xNiA4ayAxLzQg
Tk9ORQkjIEszMg0KIyBUIDU3ODAwMDAwMCA4TUh6IDUvNiBOT05FIFFBTTE2
IDhrIDEvNCBOT05FCSMgSzM0DQoNCiMjIyBJbiB0aGUgc291dGhlYXN0LCBv
bmUgbWF5IHJlY2VpdmUgdHdvIEF1c3RyaWFuIG11bHRpcGxleGVzLCBmcm9t
IHRoZQ0KIyMjIGhpZ2gtcG93ZXIgUGZhZW5kZXIuICBUcmFuc21pc3Npb25z
IGhvcml6b250YWwNCiMjIyBBIERWQi1IIG11bHRpcGxleCAoTVVYIEQpIGV4
aXN0cyB0b287IGEgcmVnaW9uYWwgKE1VWCBDKSBub3QgYXQgdGhpcyB0aW1l
DQojIyMgIHNlZSBhdC1PZmZpY2lhbA0KIyBUIDQ3NDAwMDAwMCA4TUh6IDMv
NCBOT05FIFFBTTE2IDhrIDEvNCBOT05FCSMgSzIxDQojIFQgNDk4MDAwMDAw
IDhNSHogMy80IE5PTkUgUUFNMTYgOGsgMS80IE5PTkUJIyBLMjQNCg0KIyMj
IEFsb25nIHRoZSBlYXN0IGFuZCBub3J0aGVhc3QsIG9uZSBtYXkgcmVjZWl2
ZSB0aGUgaGlnaC1wb3dlciB0cmFzbWl0dGVycw0KIyMjIGZyb20gQmF5ZXJu
LCB3aXRoIHRocmVlIG11bHRpcGxleGVzIHNpbWlsYXIgdG8gdGhlIGxvY2Fs
IGNvbnRlbnQuDQojIyMgTmVhcmJ5IHRyYW5zbWl0dGVycyBhcmUgaG9yaXpv
bnRhbC4gIExpc3RlZCBzb3V0aCB0byBub3J0aHdlc3QuDQojIyMJCQkJCUFS
RAlaREYJQlIoL1NXUikNCiMjIyAgR3J1ZW50ZW4gKEJheWVybikJCQk0NQky
OAk0Ng0KIyBUIDUzMDAwMDAwMCA4TUh6IDIvMyBOT05FIFFBTTE2IDhrIDEv
NCBOT05FCSMgSzI4DQojIFQgNjY2MDAwMDAwIDhNSHogMi8zIE5PTkUgUUFN
MTYgOGsgMS80IE5PTkUJIyBLNDUNCiMgVCA2NzQwMDAwMDAgOE1IeiAyLzMg
Tk9ORSBRQU0xNiA4ayAxLzQgTk9ORQkjIEs0Ng0KIyMjICBIb2hlbnBlaXNz
ZW5iZXJnIChCYXllcm4pID8JNDcJMjgJNTMNCiMgVCA2ODIwMDAwMDAgOE1I
eiAyLzMgTk9ORSBRQU0xNiA4ayAxLzQgTk9ORQkjIEs0Nw0KIyBUIDczMDAw
MDAwMCA4TUh6IDIvMyBOT05FIFFBTTE2IDhrIDEvNCBOT05FCSMgSzUzIC0t
IHRlbXAgaW5jbHVkZWQgaW4gQi1XDQojIyMgIEF1Z3NidXJnKEhvcikJCQkz
Ngk0NAkyNQ0KIyBUIDUwNjAwMDAwMCA4TUh6IDIvMyBOT05FIFFBTTE2IDhr
IDEvNCBOT05FCSMgSzI1DQojIFQgNTk0MDAwMDAwIDhNSHogMi8zIE5PTkUg
UUFNMTYgOGsgMS80IE5PTkUJIyBLMzYNCiMgVCA2NTgwMDAwMDAgOE1IeiAy
LzMgTk9ORSBRQU0xNiA4ayAxLzQgTk9ORQkjIEs0NA0KIyMjICBIZXNzZWxi
ZXJnCQkJCTU1CTQ0CTQ3DQojIyMgICsgQnVldHRlbGJlcmcJCQk1NQl4CTQ3
DQojIFQgNjU4MDAwMDAwIDhNSHogMi8zIE5PTkUgUUFNMTYgOGsgMS80IE5P
TkUJIyBLNDQNCiMgVCA2ODIwMDAwMDAgOE1IeiAyLzMgTk9ORSBRQU0xNiA4
ayAxLzQgTk9ORQkjIEs0Nw0KIyBUIDc0NjAwMDAwMCA4TUh6IDIvMyBOT05F
IFFBTTE2IDhrIDEvNCBOT05FCSMgSzU1DQojIyMgIFd1ZXJ6YnVyZwkJCQkx
MAkyNQk0NQ0KIyBUIDIxMjUwMDAwMCA3TUh6IDMvNCBOT05FIFFBTTE2IDhr
IDEvNCBOT05FCSMgSzEwDQojIFQgNTA2MDAwMDAwIDhNSHogMi8zIE5PTkUg
UUFNMTYgOGsgMS80IE5PTkUJIyBLMjUNCiMgVCA2NjYwMDAwMDAgOE1IeiAy
LzMgTk9ORSBRQU0xNiA4ayAxLzQgTk9ORQkjIEs0NQ0KIyMjICBQZmFmZmVu
YmVyZwkJCTM2CTI1CTQ2DQojIFQgNTA2MDAwMDAwIDhNSHogMi8zIE5PTkUg
UUFNMTYgOGsgMS80IE5PTkUJIyBLMjUNCiMgVCA1OTQwMDAwMDAgOE1IeiAy
LzMgTk9ORSBRQU0xNiA4ayAxLzQgTk9ORQkjIEszNg0KIyBUIDY3NDAwMDAw
MCA4TUh6IDIvMyBOT05FIFFBTTE2IDhrIDEvNCBOT05FCSMgSzQ2DQoNCiMj
IyBJbiB0aGUgbm9ydGh3ZXN0LCBvbmUgbWF5IHJlY2VpdmUgaGlnaC1wb3dl
ciB0cmFuc21pdHRlcnMgZnJvbSBIZXNzZW4NCiMjIyB0byB0aGUgbm9ydGgs
IG9yIFJoZWlubGFuZC1QZmFseiB0byB0aGUgd2VzdCwgY29udGVudCBzaW1p
bGFyLg0KIyMjCQkJCQlBUkQJWkRGCUhSL1NXUg0KIyMjICBXdWVyemJlcmcv
T2RlbndhbGQoSG9yKSAoSGVzc2VuKQkzNwkyMQk1Mw0KIyMjIChJcyBpdCBw
b3NzaWJsZSB0byByZWNlaXZlIHRoZSB2ZXJ0aWNhbCBSaGVpbi1NYWluIG11
bHRpcGxleGVzLA0KIyMjIGluY2x1ZGluZyBwcml2YXRlIGNvbW1lcmNpYWwg
YnJvYWRjYXN0ZXJzIG90aGVyd2lzZSBub3Qgc2Vlbj8pDQojIFQgNDc0MDAw
MDAwIDhNSHogMi8zIE5PTkUgUUFNMTYgOGsgMS80IE5PTkUJIyBLMjEgLS0g
aW5jbHVkZWQgaW4gQi1XDQojIFQgNjAyMDAwMDAwIDhNSHogMi8zIE5PTkUg
UUFNMTYgOGsgMS80IE5PTkUJIyBLMzcNCiMgVCA3MzAwMDAwMDAgOE1IeiAy
LzMgTk9ORSBRQU0xNiA4ayAxLzQgTk9ORQkjIEs1MyAtLSB0ZW1wIGluY2x1
ZGVkIGluIEItVw0KIyMjICBXZWluYmlldChIb3IpIChSLVApCQk0NChTV1It
UlApDQojIFQgNjU4MDAwMDAwIDhNSHogMi8zIE5PTkUgUUFNMTYgOGsgMS80
IE5PTkUJIyBLNDQgKFNGTiBSLVApDQoNCiMjIyBJbiB0aGUgd2VzdCB0byBz
b3V0aHdlc3QsIG9uZSBtYXkgcmVjZWl2ZSBhIG51bWJlciBvZiBicm9hZGNh
c3RzIGZyb20NCiMjIyB0aGUgQWxzYWNlIGluIEZyYW5jZS4gIFRoZXNlIGFy
ZSBob3Jpem9udGFsbHkgcG9sYXJpc2VkLg0KIyMjICBTdHJhc2JvdXJnIE5v
cmRoZWltCTIyLTQ3LTQ4LTUxLTYxLTY5DQojIEFDSFRVTkchICBmaWxlIGZy
LVN0cmFzYm91cmcgY29udGFpbnMgbm8gY29udGVudCEgIEZJWE1FIQ0KIyMj
IG5lZWQgdG8gdmVyaWZ5IEZFQyAyLzMgKyBHSSAxLzMyIChNRk4pLCBmaXgg
ZnJlcXMNCiMgVCA0ODIwMDAwMDAgOE1IeiAyLzMgTk9ORSBRQU02NCA4ayAx
LzMyIE5PTkUJIyBLMjINCiMgVCA2ODIwMDAwMDAgOE1IeiAyLzMgTk9ORSBR
QU02NCA4ayAxLzMyIE5PTkUJIyBLNDcNCiMgVCA2OTAwMDAwMDAgOE1IeiAy
LzMgTk9ORSBRQU02NCA4ayAxLzMyIE5PTkUJIyBLNDgNCiMgVCA3MTQwMDAw
MDAgOE1IeiAyLzMgTk9ORSBRQU02NCA4ayAxLzMyIE5PTkUJIyBLNTENCiMg
VCA3OTQwMDAwMDAgOE1IeiAyLzMgTk9ORSBRQU02NCA4ayAxLzMyIE5PTkUJ
IyBLNjENCiMgVCA4NTgwMDAwMDAgOE1IeiAyLzMgTk9ORSBRQU02NCA4ayAx
LzMyIE5PTkUJIyBLNjkNCg0KIyMjICBNdWxob3VzZQkJMzdICTUzSAk1NEgJ
NTVICTY1SAk2NkgNCiMjIyBzZWUgZnItTXVsaG91c2UNCiMgVCA3MzAwMDAw
MDAgOE1IeiAyLzMgTk9ORSBRQU02NCA4ayAxLzMyIE5PTkUJIyBLNTMNCiMg
VCA3NDYwMDAwMDAgOE1IeiAyLzMgTk9ORSBRQU02NCA4ayAxLzMyIE5PTkUJ
IyBLNTUNCiMgVCA3MzgwMDAwMDAgOE1IeiAyLzMgTk9ORSBRQU02NCA4ayAx
LzMyIE5PTkUJIyBLNTQNCiMgVCA2MDIwMDAwMDAgOE1IeiAyLzMgTk9ORSBR
QU02NCA4ayAxLzMyIE5PTkUJIyBLMzcNCiMgVCA4MzQwMDAwMDAgOE1IeiAy
LzMgTk9ORSBRQU02NCA4ayAxLzMyIE5PTkUJIyBLNjYNCiMgVCA4MjYwMDAw
MDAgOE1IeiAyLzMgTk9ORSBRQU02NCA4ayAxLzMyIE5PTkUJIyBLNjUNCg0K
DQo=

--8323328-1091934717-1226853882=:6408
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--8323328-1091934717-1226853882=:6408--
