Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755631Ab1LGMWV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Dec 2011 07:22:21 -0500
Message-ID: <4EDF5A76.5040106@redhat.com>
Date: Wed, 07 Dec 2011 10:22:14 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Eddi De Pieri <eddi@depieri.net>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Fredrik Lingvall <fredrik.lingvall@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: Hauppauge HVR-930C problems
References: <4ED929E7.2050808@gmail.com> <CAGoCfizgkfHJ-0YwcdTEQEhci=7eE7BTuSOj8KmMpLRhc4oqGg@mail.gmail.com> <CAKdnbx5vewR3bLvFD4DeGiOSa8AqP0hupVF2jf1w9xrizXYz1g@mail.gmail.com>
In-Reply-To: <CAKdnbx5vewR3bLvFD4DeGiOSa8AqP0hupVF2jf1w9xrizXYz1g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05-12-2011 21:37, Eddi De Pieri wrote:
> try using scan from dvb-apps and not w_scan.
>
> Actually It seems to me w_scan isn't compatible with this driver due
> some missing lock.

It works for me. The only parameter that it is mandatory is "-f c",
in order to use the DVB-C frontend, instead of DVB-T.

I've passed a few other parameters to speedup it (otherwise, it would
take hours, as it tries first QAM_64, on all possible symbol rates,
and then QAM_256).

Anyway:

$ w_scan -f c -S 13 -Q 1
w_scan version 20111011 (compiled for DVB API 5.3)
guessing country 'BR', use -c <country> to override
using settings for BRAZIL
DVB cable
DVB-C BR
frontend_type DVB-C, channellist 10
output format vdr-1.6
output charset 'UTF-8', use -C <charset> to override
Info: using DVB adapter auto detection.
	/dev/dvb/adapter0/frontend0 -> DVB-C "DRXK DVB-C": good :-)
	/dev/dvb/adapter0/frontend1 -> DVB-T "DRXK DVB-T": specified was DVB-C -> SEARCH NEXT ONE.
Using DVB-C frontend (adapter /dev/dvb/adapter0/frontend0)
-_-_-_-_ Getting frontend capabilities-_-_-_-_
Using DVB API 5.4
frontend 'DRXK DVB-C' supports
INVERSION_AUTO
QAM_AUTO not supported, trying QAM_256.
FEC_AUTO
FREQ (47.00MHz ... 862.00MHz)
SRATE (0.870MBd ... 11.700MBd)
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
searching QAM256...
57000: sr5217 (time: 00:01)
63000: sr5217 (time: 00:03)
69000: sr5217 (time: 00:06)
79000: sr5217 (time: 00:08)
85000: sr5217 (time: 00:11)
177000: sr5217 (time: 00:13)
183000: sr5217 (time: 00:16)
189000: sr5217 (time: 00:18)
195000: sr5217 (time: 00:21)
201000: sr5217 (time: 00:23)
207000: sr5217 (time: 00:26)
213000: sr5217 (time: 00:28)
123000: sr5217 (time: 00:31)
129000: sr5217 (time: 00:34)
135000: sr5217 (time: 00:36)
141000: sr5217 (time: 00:39)
147000: sr5217 (time: 00:41)
153000: sr5217 (time: 00:44)
159000: sr5217 (time: 00:46)
165000: sr5217 (time: 00:49)
171000: sr5217 (time: 00:51)
219000: sr5217 (time: 00:54)
225000: sr5217 (time: 00:56)
231000: sr5217 (time: 00:59)
237000: sr5217 (time: 01:01)
243000: sr5217 (time: 01:04)
249000: sr5217 (time: 01:07)
255000: sr5217 (time: 01:09)
261000: sr5217 (time: 01:12)
267000: sr5217 (time: 01:14)
273000: sr5217 (time: 01:17)
279000: sr5217 (time: 01:19)
285000: sr5217 (time: 01:22)
291000: sr5217 (time: 01:24)
297000: sr5217 (time: 01:27)
303000: sr5217 (time: 01:29)
309000: sr5217 (time: 01:32)
315000: sr5217 (time: 01:34)
321000: sr5217 (time: 01:37)
327000: sr5217 (time: 01:40)
333000: sr5217 (time: 01:42)
339000: sr5217 (time: 01:45)
345000: sr5217 (time: 01:47)
351000: sr5217 (time: 01:50)
357000: sr5217 (time: 01:52)
363000: sr5217 (time: 01:55)
369000: sr5217 (time: 01:57)
375000: sr5217 (time: 02:00)
381000: sr5217 (time: 02:02)
387000: sr5217 (time: 02:05)
393000: sr5217 (time: 02:08)
399000: sr5217 (time: 02:10)
405000: sr5217 (time: 02:13)
411000: sr5217 (time: 02:15)
417000: sr5217 (time: 02:18)
423000: sr5217 (time: 02:20)
429000: sr5217 (time: 02:23)
435000: sr5217 (time: 02:25)
441000: sr5217 (time: 02:28)
447000: sr5217 (time: 02:30)
453000: sr5217 (time: 02:33)
459000: sr5217 (time: 02:35)
465000: sr5217 (time: 02:38)
471000: sr5217 (time: 02:41)
477000: sr5217 (time: 02:43)
483000: sr5217 (time: 02:46)
489000: sr5217 (time: 02:48)
495000: sr5217 (time: 02:51)
501000: sr5217 (time: 02:53)
507000: sr5217 (time: 02:56)
513000: sr5217 (time: 02:58)
519000: sr5217 (time: 03:01)
525000: sr5217 (time: 03:03)
531000: sr5217 (time: 03:06)
537000: sr5217 (time: 03:08)
543000: sr5217 (time: 03:11)
549000: sr5217 (time: 03:14)
555000: sr5217 (time: 03:16)
561000: sr5217 (time: 03:19)
567000: sr5217 (time: 03:21)
573000: sr5217 (time: 03:24) (time: 03:25) signal ok:
	QAM_256  f = 573000 kHz S5217C999
	new transponder:
	   (QAM_256  f = 591000 kHz S5217C34)
	new transponder:
	   (QAM_256  f = 597000 kHz S5217C34)
	new transponder:
	   (QAM_256  f = 603000 kHz S5217C34)
	new transponder:
	   (QAM_256  f = 609000 kHz S5217C34)
	new transponder:
	   (QAM_256  f = 615000 kHz S5217C34)
	new transponder:
	   (QAM_256  f = 621000 kHz S5217C34)
	new transponder:
	   (QAM_256  f = 627000 kHz S5217C34)
	new transponder:
	   (QAM_256  f = 633000 kHz S5217C34)
	new transponder:
	   (QAM_256  f = 639000 kHz S5217C34)
	new transponder:
	   (QAM_256  f = 681000 kHz S5217C34)
	new transponder:
	   (QAM_256  f = 651000 kHz S5217C34)
	new transponder:
	   (QAM_256  f = 693000 kHz S5217C34)
	new transponder:
	   (QAM_256  f = 699000 kHz S5217C34)
	new transponder:
	   (QAM_256  f = 687000 kHz S5217C34)
	new transponder:
	   (QAM_256  f = 657000 kHz S5217C34)
	new transponder:
	   (QAM_256  f = 663000 kHz S5217C34)
	new transponder:
	   (QAM_256  f = 669000 kHz S5217C34)
	new transponder:
	   (QAM_256  f = 705000 kHz S5217C34)
	new transponder:
	   (QAM_256  f = 711000 kHz S5217C34)
	new transponder:
	   (QAM_256  f = 717000 kHz S5217C34)
	new transponder:
	   (QAM_256  f = 723000 kHz S5217C34)
	updating transponder:
	   (QAM_256  f = 573000 kHz S5217C999)
	to (QAM_256  f = 573000 kHz S5217C34)
	new transponder:
	   (QAM_256  f = 579000 kHz S5217C34)
	new transponder:
	   (QAM_256  f = 585000 kHz S5217C34)
579000: skipped (already known transponder)
585000: skipped (already known transponder)
591000: skipped (already known transponder)
597000: skipped (already known transponder)
603000: skipped (already known transponder)
609000: skipped (already known transponder)
615000: skipped (already known transponder)
621000: skipped (already known transponder)
627000: skipped (already known transponder)
633000: skipped (already known transponder)
639000: skipped (already known transponder)
645000: sr5217 (time: 03:36)
93000: sr5217 (time: 03:38)
99000: sr5217 (time: 03:41)
105000: sr5217 (time: 03:43)
111000: sr5217 (time: 03:46)
117000: sr5217 (time: 03:48)
651000: skipped (already known transponder)
657000: skipped (already known transponder)
663000: skipped (already known transponder)
669000: skipped (already known transponder)
675000: sr5217 (time: 03:51)
681000: skipped (already known transponder)
687000: skipped (already known transponder)
693000: skipped (already known transponder)
699000: skipped (already known transponder)
705000: skipped (already known transponder)
711000: skipped (already known transponder)
717000: skipped (already known transponder)
723000: skipped (already known transponder)
729000: sr5217 (time: 03:53)
735000: sr5217 (time: 03:56)
741000: sr5217 (time: 03:58)
747000: sr5217 (time: 04:01)
753000: sr5217 (time: 04:04)
759000: sr5217 (time: 04:06)
765000: sr5217 (time: 04:09)
771000: sr5217 (time: 04:11)
777000: sr5217 (time: 04:14)
783000: sr5217 (time: 04:16)
789000: sr5217 (time: 04:19)
795000: sr5217 (time: 04:21)
801000: sr5217 (time: 04:24)
807000: sr5217 (time: 04:26)
813000: sr5217 (time: 04:29)
819000: sr5217 (time: 04:31)
825000: sr5217 (time: 04:34)
831000: sr5217 (time: 04:37)
837000: sr5217 (time: 04:39)
843000: sr5217 (time: 04:42)
849000: sr5217 (time: 04:44)
tune to: QAM_256  f = 573000 kHz S5217C34
(time: 04:47) 	service = SBT ((null))
	service = Globo ((null))
	service = Record ((null))
	service = Band ((null))
	service = Cartoon Network ((null))
	service = TNT ((null))
	service = Boomerang ((null))
	service = DW-TV ((null))
	service = BBC World News ((null))
	service = NET Games ((null))
	service = NET Mœsica ((null))
	service = Pagode ((null))
	service = AxØ ((null))
	service = Festa ((null))
	service = Trilhas Sonoras ((null))
	service = Radio Multishow ((null))
	service = 01070136 ((null))
	service = 01070236 ((null))
tune to: QAM_256  f = 591000 kHz S5217C34
(time: 04:58) 	service = GNT ((null))
	service = Multishow ((null))
	service = Warner Channel ((null))
	service = Canal Brasil ((null))
	service = ESPN Brasil ((null))
	service = HBO2 ((null))
	service = Premiere FC ((null))
	service = RAI ((null))
	service = CNN International ((null))
	service = Anos 80 ((null))
	service = Blues ((null))
	service = Rhythm & Blues ((null))
	service = Standards ((null))
tune to: QAM_256  f = 597000 kHz S5217C34
(time: 05:09) 	service = TV Senado ((null))
	service = Rede Vida ((null))
	service = Canal Rural ((null))
	service = Disney XD ((null))
	service = Telecine Premium ((null))
	service = Telecine Cult ((null))
	service = Disney Channel ((null))
	service = Record News ((null))
	service = TV5 ((null))
	service = Samba de Raiz ((null))
	service = New Age ((null))
	service = Jazz Contemporaneo ((null))
	service = Mœsica ClÆssica ((null))
tune to: QAM_256  f = 603000 kHz S5217C34
(time: 05:20) 	service = Globo News ((null))
	service = Universal Channel ((null))
	service = Nickelodeon ((null))
	service = Telecine Action ((null))
	service = Telecine Touch ((null))
	service = VH1 Mega Hits ((null))
	service = VH1 ((null))
	service = Aquecimento BBB12 ((null))
	service = Sexy Hot ((null))
	service = RÆdio Kids ((null))
	service = Forrð ((null))
	service = Lounge ((null))
	service = Mœsica Orquestrada ((null))
tune to: QAM_256  f = 609000 kHz S5217C34
(time: 05:31) 	service = NET Cidade ((null))
	service = Rede Mundial ((null))
	service = Rede 21 ((null))
	service = TV JustiĿa ((null))
	service = SporTV2 ((null))
	service = SporTV ((null))
	service = FX ((null))
	service = The History Channel ((null))
	service = Fox Life ((null))
	service = Sertanejo ((null))
	service = Rock ClÆssico ((null))
	service = Reggae ((null))
	service = Eletrħnica ((null))
	service = CBN ((null))
tune to: QAM_256  f = 615000 kHz S5217C34
(time: 05:42) 	service = Telecine Pipoca ((null))
	service = E! ((null))
	service = Discovery Science ((null))
	service = Discovery Civilization ((null))
	service = Discovery Turbo ((null))
	service = Combate ((null))
	service = Premiere FC+ (Premiere FC+)
	service = Premiere 24hs ((null))
	service = Fox News ((null))
	service = MPB ((null))
	service = Anos 70 ((null))
	service = Disco ((null))
	service = Gospel ((null))
	service = Globo FM ((null))
tune to: QAM_256  f = 621000 kHz S5217C34
(time: 05:53) 	service = MTV ((null))
	service = Gazeta ((null))
	service = Canal UniversitÆrio ((null))
	service = NET TV ((null))
	service = Max ((null))
	service = Max * ((null))
	service = Premiere FC ((null))
	service = ART Latino ((null))
	service = For Man ((null))
	service = NET ((null))
tune to: QAM_256  f = 627000 kHz S5217C34
(time: 06:04) 	service = TV RÆ Tim Bum ((null))
	service = MGM ((null))
	service = HBO Family ((null))
	service = Max Prime ((null))
	service = HBO Plus *e ((null))
	service = HBO Family *e ((null))
	service = Maxprime *e ((null))
	service = Bem Simples ((null))
	service = Mosaico Multijogos ((null))
tune to: QAM_256  f = 633000 kHz S5217C34
(time: 06:15) 	service = NET ((null))
	service = PPV em Cartaz ((null))
	service = PPV01 Filmes ((null))
	service = PPV03 Filmes ((null))
	service = PPV04 Filmes ((null))
	service = PPV05 Filmes ((null))
	service = PPV06 Filmes ((null))
	service = Rede Gospel ((null))
	service = Canal de Vendas NET ((null))
	service = Climatempo ((null))
	service = Canal NET ((null))
	service = Playboy TV ((null))
tune to: QAM_256  f = 639000 kHz S5217C34
(time: 06:27) 	service = A&E ((null))
	service = PPV02 Wide ((null))
	service = PFC Interativo ((null))
	service = Premiere FC ((null))
	service = Studio Universal ((null))
	service = Portal ITV ((null))
	service = Interatividade ((null))
	service = Cartoon Games ((null))
	service = Venus ((null))
	service = History Channel HD ((null))
tune to: QAM_256  f = 681000 kHz S5217C34
(time: 06:39) 	service = Canal Comunitario ((null))
	service = World Net ((null))
	service = Megapix ((null))
	service = Sony Spin ((null))
	service = TCM ((null))
	service = Syfy ((null))
	service = TLC ((null))
	service = NHK ((null))
	service = Private ((null))
tune to: QAM_256  f = 651000 kHz S5217C34
(time: 06:50) 	service = Canal ComunitÆrio ((null))
	service = Canal ComunitÆrio JCI ((null))
	service = TV CanĿªo Nova ((null))
	service = TV CÐmara ((null))
	service = Canal Legislativo ((null))
	service = TV Brasil ((null))
	service = TV AssemblØia JCI ((null))
	service = SESCTV ((null))
	service = Mosaico Variedades ((null))
	service = Mosaico InformaĿªo ((null))
tune to: QAM_256  f = 693000 kHz S5217C34
(time: 07:01) 	service = Band Sports ((null))
	service = Band News ((null))
	service = Premiere FC ((null))
	service = Sextreme ((null))
	service = RFI ((null))
	service = Globosat HD ((null))
tune to: QAM_256  f = 699000 kHz S5217C34
(time: 07:12) 	service = Glitz* ((null))
	service = Telecine Premium HD ((null))
	service = Premiere 3D ((null))
tune to: QAM_256  f = 687000 kHz S5217C34
(time: 07:23) 	service = NBR ((null))
	service = Multishow HD ((null))
	service = Fox+NatGeo HD ((null))
tune to: QAM_256  f = 657000 kHz S5217C34
(time: 07:35) 	service = NET ((null))
	service = Telecine Pipoca HD ((null))
	service = HBO ((null))
	service = HBO HD ((null))
tune to: QAM_256  f = 663000 kHz S5217C34
(time: 07:46) 	service = Viva ((null))
	service = RedeTV! HD ((null))
	service = Band HD ((null))
tune to: QAM_256  f = 669000 kHz S5217C34
(time: 07:58) 	service = Space ((null))
	service = Telecine Fun ((null))
	service = Globo HD ((null))
	service = Megapix HD ((null))
tune to: QAM_256  f = 705000 kHz S5217C34
(time: 08:09) 	service = NatGeo Wild HD ((null))
	service = Discovery Theater HD ((null))
	service = TLC HD ((null))
tune to: QAM_256  f = 711000 kHz S5217C34
(time: 08:20) 	service = TNT HD ((null))
	service = Space HD ((null))
	service = Telecine Action HD ((null))
tune to: QAM_256  f = 717000 kHz S5217C34
(time: 08:31) 	service = NET (NET)
	service = ESPN HD ((null))
	service = Max HD ((null))
tune to: QAM_256  f = 723000 kHz S5217C34
(time: 08:42) 	service = VH1 HD ((null))
	service = Warner HD ((null))
	service = Sony HD ((null))
tune to: QAM_256  f = 579000 kHz S5217C34
(time: 08:53) 	service = National Geographic ((null))
	service = AXN ((null))
	service = Sony ((null))
	service = Fox ((null))
	service = ESPN ((null))
	service = HBO ((null))
	service = HBO Plus ((null))
	service = Speed ((null))
	service = Bloomberg ((null))
	service = Baladas RomÐnticas ((null))
	service = Anos 60 ((null))
	service = New Rock ((null))
	service = Anos 90 ((null))
	service = RÆdio Globo SP ((null))
WARNING: section too short: service_id == 0x3a6, section_length == 6, descriptors_loop_len == 0
tune to: QAM_256  f = 585000 kHz S5217C34
(time: 09:05) 	service = Cultura ((null))
	service = RedeTV! ((null))
	service = Shop Time ((null))
	service = Futura ((null))
	service = Discovery Kids ((null))
	service = Discovery Channel ((null))
	service = Liv ((null))
	service = Disc. Home & Health ((null))
	service = Animal Planet ((null))
	service = Natal ((null))
	service = Bossa Nova ((null))
	service = Latino ((null))
	service = Jazz ClÆssico ((null))
dumping lists (195 services)
SBT;(null):573000:M256:C:5217:256:257:0:0:4:20:141:0
Globo;(null):573000:M256:C:5217:584:305:0:0:5:20:141:0
Record;(null):573000:M256:C:5217:288:289:0:0:7:20:141:0
Band;(null):573000:M256:C:5217:272:273:0:0:13:20:141:0
Cartoon Network;(null):573000:M256:C:5217:320:321,322=por:0:1801,1802:46:20:141:0
TNT;(null):573000:M256:C:5217:336:337,338=por:0:1801,1802:48:20:141:0
Boomerang;(null):573000:M256:C:5217:352:353,354=por:0:1801,1802:57:20:141:0
DW-TV;(null):573000:M256:C:5217:368:369,1526=deu:0:1801,1802:144:20:141:0
BBC World News;(null):573000:M256:C:5217:384:385:0:1801,1802:152:20:141:0
Pagode;(null):573000:M256:C:5217:0:102:0:0:307:20:141:0
AxØ;(null):573000:M256:C:5217:0:101:0:0:309:20:141:0
Festa;(null):573000:M256:C:5217:0:103:0:0:326:20:141:0
Trilhas Sonoras;(null):573000:M256:C:5217:0:104:0:0:342:20:141:0
Radio Multishow;(null):573000:M256:C:5217:0:117:0:0:347:20:141:0
GNT;(null):591000:M256:C:5217:1120:1121:0:1801,1802:41:20:144:0
Multishow;(null):591000:M256:C:5217:1104:1105,1106=por:0:1801,1802:42:20:144:0
Warner Channel;(null):591000:M256:C:5217:120:0=por;121,122:0:1801,1802:47:20:144:0
Canal Brasil;(null):591000:M256:C:5217:1136:1137:0:1801,1802:66:20:144:0
ESPN Brasil;(null):591000:M256:C:5217:1072:1074:0:1801,1802:70:20:144:0
HBO2;(null):591000:M256:C:5217:1056:0=por;1057:0:1801,1802:73:20:144:0
Premiere FC;(null):591000:M256:C:5217:1152:2337:0:1801,1802:124:20:144:0
RAI;(null):591000:M256:C:5217:1040+60:1042:0:1801,1802:140:20:144:0
CNN International;(null):591000:M256:C:5217:1024:1025:0:1801,1802:153:20:144:0
Anos 80;(null):591000:M256:C:5217:0:114:0:0:318:20:144:0
Blues;(null):591000:M256:C:5217:0:115:0:0:333:20:144:0
Rhythm & Blues;(null):591000:M256:C:5217:0:116:0:0:334:20:144:0
Standards;(null):591000:M256:C:5217:0:113:0:0:335:20:144:0
TV Senado;(null):597000:M256:C:5217:3584:3585:0:0:16:20:145:0
Rede Vida;(null):597000:M256:C:5217:1296:1297:0:0:19:20:145:0
Canal Rural;(null):597000:M256:C:5217:1280:1281:0:0:35:20:145:0
Disney XD;(null):597000:M256:C:5217:1392:0=eng;1393,1394:0:1801,1802:56:20:145:0
Telecine Premium;(null):597000:M256:C:5217:1360:1362=5.1,1363=eng;1361:0:1801,1802:61:20:145:0
Telecine Cult;(null):597000:M256:C:5217:1376:1377:0:1801,1802:65:20:145:0
Disney Channel;(null):597000:M256:C:5217:1408:0=por;1409,1410:0:1801,1802:67:20:145:0
Record News;(null):597000:M256:C:5217:1312:1313:0:1801,1802:93:20:145:0
TV5;(null):597000:M256:C:5217:1760:1720:0:1801,1802:141:20:145:0
Samba de Raiz;(null):597000:M256:C:5217:0:133:0:0:308:20:145:0
New Age;(null):597000:M256:C:5217:0:136:0:0:329:20:145:0
Jazz Contemporaneo;(null):597000:M256:C:5217:0:135:0:0:337:20:145:0
Mœsica ClÆssica;(null):597000:M256:C:5217:0:134:0:0:338:20:145:0
Globo News;(null):603000:M256:C:5217:1632:1633:0:1801,1802:40:20:146:0
Universal Channel;(null):603000:M256:C:5217:1616:1617,1618=por:0:1801,1802:43:20:146:0
Nickelodeon;(null):603000:M256:C:5217:1568:1569,1570=por:0:1801,1802:44:20:146:0
Telecine Action;(null):603000:M256:C:5217:1536:1537,1538=por:0:1801,1802:62:20:146:0
Telecine Touch;(null):603000:M256:C:5217:1552:1553,1554=por:0:1801,1802:63:20:146:0
VH1 Mega Hits;(null):603000:M256:C:5217:1664:1665:0:0:88:20:146:0
VH1;(null):603000:M256:C:5217:1600:1601:0:1801,1802:89:20:146:0
Aquecimento BBB12;(null):603000:M256:C:5217:4660:4620,4622:0:1801,1802:126:20:146:0
Sexy Hot;(null):603000:M256:C:5217:1648:0=eng;1649:0:1801,1802:285:20:146:0
RÆdio Kids;(null):603000:M256:C:5217:0:139:0:0:305:20:146:0
Forrð;(null):603000:M256:C:5217:0:137:0:0:311:20:146:0
Lounge;(null):603000:M256:C:5217:0:138:0:0:328:20:146:0
Mœsica Orquestrada;(null):603000:M256:C:5217:0:140:0:0:339:20:146:0
NET Cidade;(null):609000:M256:C:5217:1792:1793:0:0:10:20:147:0
Rede Mundial;(null):609000:M256:C:5217:1824:1825:0:0:18:20:147:0
Rede 21;(null):609000:M256:C:5217:1840:1841:0:0:20:20:147:0
TV JustiĿa;(null):609000:M256:C:5217:289:290,291=por:0:0:21:20:147:0
SporTV2;(null):609000:M256:C:5217:1872:1873:0:1801,1802:38:20:147:0
SporTV;(null):609000:M256:C:5217:1856:1857:0:1801,1802:39:20:147:0
FX;(null):609000:M256:C:5217:1888:1889,1890=por:0:1801,1802:54:20:147:0
The History Channel;(null):609000:M256:C:5217:1920:0=por;1921,1922:0:1801,1802:82:20:147:0
Fox Life;(null):609000:M256:C:5217:1904:1905,1906=por:0:1801,1802:96:20:147:0
Sertanejo;(null):609000:M256:C:5217:0:141:0:0:310:20:147:0
Rock ClÆssico;(null):609000:M256:C:5217:0:39:0:0:320:20:147:0
Reggae;(null):609000:M256:C:5217:0:142:0:0:323:20:147:0
Eletrħnica;(null):609000:M256:C:5217:0:143:0:0:327:20:147:0
CBN;(null):609000:M256:C:5217:0:151:0:0:349:20:147:0
Telecine Pipoca;(null):615000:M256:C:5217:2096:2097,2098=por:0:1801,1802:64:20:148:0
E!;(null):615000:M256:C:5217:2112:0=eng;2113,2114:0:1801,1802:84:20:148:0
Discovery Science;(null):615000:M256:C:5217:2128:2129,2130=por:0:1801,1802:85:20:148:0
Discovery Civilization;(null):615000:M256:C:5217:2144:2145,2146=por:0:1801,1802:86:20:148:0
Discovery Turbo;(null):615000:M256:C:5217:2160:2161,2162=por:0:1801,1802:87:20:148:0
Combate;(null):615000:M256:C:5217:2048:2049:0:1801,1802:121:20:148:0
Premiere FC+;Premiere FC+:615000:M256:C:5217:2064:2065:0:1801,1802:122:20:148:0
Premiere 24hs;(null):615000:M256:C:5217:2080:2081:0:1801,1802:123:20:148:0
Fox News;(null):615000:M256:C:5217:2176:2177:0:0:151:20:148:0
MPB;(null):615000:M256:C:5217:0:39:0:0:304:20:148:0
Anos 70;(null):615000:M256:C:5217:0:146:0:0:317:20:148:0
Disco;(null):615000:M256:C:5217:0:147:0:0:322:20:148:0
Gospel;(null):615000:M256:C:5217:0:148:0:0:343:20:148:0
Globo FM;(null):615000:M256:C:5217:0:152:0:0:348:20:148:0
MTV;(null):621000:M256:C:5217:2320:2321:0:0:6:20:149:0
Gazeta;(null):621000:M256:C:5217:2352:2353:0:0:11:20:149:0
Canal UniversitÆrio;(null):621000:M256:C:5217:2304:2305:0:0:14:20:149:0
NET TV;(null):621000:M256:C:5217:2864:2865:0:0:37:20:149:0
Max;(null):621000:M256:C:5217:2400:0=por;2401,2402:0:1801,1802:75:20:149:0
Max *;(null):621000:M256:C:5217:2416:0=dub;2417,2418:0:1801,1802:79:20:149:0
Premiere FC;(null):621000:M256:C:5217:2368:33:0:1801,1802:125:20:149:0
ART Latino;(null):621000:M256:C:5217:519+37:720:0:1801,1802:145:20:149:0
For Man;(null):621000:M256:C:5217:2432:0=por;2433,2434:0:1801,1802:291:20:149:0
NET;(null):621000:M256:C:5217:2864+8191:2337:0:0:299:20:149:0
TV RÆ Tim Bum;(null):627000:M256:C:5217:2672:2673:0:0:29:20:150:0
MGM;(null):627000:M256:C:5217:2640:2641,2642=por:0:1801,1802:68:20:150:0
HBO Family;(null):627000:M256:C:5217:2560:0=dub;2561,2563:0:1801,1802:74:20:150:0
Max Prime;(null):627000:M256:C:5217:2608:0=por;2609,2610:0:1801,1802:76:20:150:0
HBO Plus *e;(null):627000:M256:C:5217:2592:0=eng;659,687:0:1801,1802:77:20:150:0
HBO Family *e;(null):627000:M256:C:5217:2624:138;2625,2626,2627:0:1801,1802:78:20:150:0
Maxprime *e;(null):627000:M256:C:5217:2576:0=spa;815,2579:0:1801,1802:80:20:150:0
Mosaico Multijogos;(null):627000:M256:C:5217:2688:4920,4922:0:0:130:20:150:0
Bem Simples;(null):627000:M256:C:5217:2656:0=por;2657:0:0:81:20:150:0
NET;(null):633000:M256:C:5217:2864:2865:0:0:1:20:151:0
PPV em Cartaz;(null):633000:M256:C:5217:2848:2849:0:0:100:20:151:0
PPV01 Filmes;(null):633000:M256:C:5217:2880:0=por;2881:0:1801,1802:101:20:151:0
PPV03 Filmes;(null):633000:M256:C:5217:2896:0=spa;2897:0:1801,1802:103:20:151:0
PPV04 Filmes;(null):633000:M256:C:5217:2912:0=por;2913,2914:0:1801,1802:104:20:151:0
PPV05 Filmes;(null):633000:M256:C:5217:2928:0=por;2929,2930:0:1801,1802:105:20:151:0
PPV06 Filmes;(null):633000:M256:C:5217:2944:0=por;2945,2946:0:1801,1802:106:20:151:0
Rede Gospel;(null):633000:M256:C:5217:2832:2833:0:0:137:20:151:0
Playboy TV;(null):633000:M256:C:5217:2816:2817:0:1801,1802:281:20:151:0
A&E;(null):639000:M256:C:5217:3168:0=por;3169,3170:0:1801,1802:83:20:152:0
PPV02 Wide;(null):639000:M256:C:5217:3088:0=por;3089:0:1801,1802:102:20:152:0
Premiere FC;(null):639000:M256:C:5217:2336:2337:0:0:127:20:152:0
Studio Universal;(null):639000:M256:C:5217:3152:3153:0:0:138:20:152:0
Venus;(null):639000:M256:C:5217:3200:3201:0:1801,1802:284:20:152:0
History Channel HD;(null):639000:M256:C:5217:3104:0:0:1801,1802:582:20:152:0
Canal Comunitario;(null):681000:M256:C:5217:2864:2865:0:0:25:20:153:0
World Net;(null):681000:M256:C:5217:3408:3409:0:0:26:20:153:0
Megapix;(null):681000:M256:C:5217:3440:3441,3442=por:0:1801,1802:58:20:153:0
Sony Spin;(null):681000:M256:C:5217:3376:0=por;3377,3378:0:1801,1802:90:20:153:0
TCM;(null):681000:M256:C:5217:3360:3361:0:1801,1802:91:20:153:0
Syfy;(null):681000:M256:C:5217:3344:3345,3346=por:0:1801,1802:92:20:153:0
TLC;(null):681000:M256:C:5217:1660:1632,1633=por:0:1801,1802:94:20:153:0
NHK;(null):681000:M256:C:5217:3456:3457:0:1801,1802:147:20:153:0
Private;(null):681000:M256:C:5217:3472:0:0:1801,1802:283:20:153:0
Canal ComunitÆrio;(null):651000:M256:C:5217:1328:1329:0:0:3:20:154:0
Canal ComunitÆrio JCI;(null):651000:M256:C:5217:384:785,8003=eng:0:0:9:20:154:0
TV CanĿªo Nova;(null):651000:M256:C:5217:8000:8001:0:0:12:20:154:0
TV CÐmara;(null):651000:M256:C:5217:3616:3617:0:0:15:20:154:0
Canal Legislativo;(null):651000:M256:C:5217:1808:1809:0:0:17:20:154:0
TV Brasil;(null):651000:M256:C:5217:36+3712:3713:0:0:22:20:154:0
TV AssemblØia JCI;(null):651000:M256:C:5217:3632:3633:0:0:27:20:154:0
SESCTV;(null):651000:M256:C:5217:3680:3681:0:0:136:20:154:0
Mosaico Variedades;(null):651000:M256:C:5217:3648:3649,3650=au1,3651=au3,3652=au5,3653=au7,3654=au9:0:0:400:20:154:0
Mosaico InformaĿªo;(null):651000:M256:C:5217:3664:3665,3666=au1,3667=au3,3668=au5,3669=au7,3670=au9:0:0:401:20:154:0
Band Sports;(null):693000:M256:C:5217:3872+279:3873:0:1801,1802:98:20:155:0
Band News;(null):693000:M256:C:5217:3856+128:3857:0:1801,1802:99:20:155:0
Premiere FC;(null):693000:M256:C:5217:2336:2337:0:0:128:20:155:0
Sextreme;(null):693000:M256:C:5217:3888:0=eng;3889:0:1801,1802:282:20:155:0
RFI;(null):693000:M256:C:5217:0:1842:0:0:352:20:155:0
Globosat HD;(null):693000:M256:C:5217:3840:3842:0:1802,1801:502:20:155:0
Glitz*;(null):699000:M256:C:5217:34:4113:0:1801,1802:95:20:156:0
Telecine Premium HD;(null):699000:M256:C:5217:4096:0:0:1801,1802:561:20:156:0
Premiere 3D;(null):699000:M256:C:5217:4144:4145:0:1801,1802:701:20:156:0
NBR;(null):687000:M256:C:5217:308+8190:256:0:0:23:20:157:0
Multishow HD;(null):687000:M256:C:5217:4352:4353:0:1801,1802:542:20:157:0
Fox+NatGeo HD;(null):687000:M256:C:5217:4368:0:0:1802,1801:550:20:157:0
Telecine Pipoca HD;(null):657000:M256:C:5217:4624:0:0:1801,1802:564:20:158:0
HBO;(null):657000:M256:C:5217:5697:0:0:1802,1801:571:20:158:0
HBO HD;(null):657000:M256:C:5217:5633:0:0:1801,1802:572:20:158:0
Viva;(null):663000:M256:C:5217:4864:4865:0:0:36:20:159:0
RedeTV! HD;(null):663000:M256:C:5217:4880+35:0:0:0:508:20:159:0
Band HD;(null):663000:M256:C:5217:4896+34:0:0:0:513:20:159:0
Space;(null):669000:M256:C:5217:5168:5169,5170=por:0:1801,1802:53:20:160:0
Telecine Fun;(null):669000:M256:C:5217:5152:5153,5154=por:0:1801,1802:59:20:160:0
Globo HD;(null):669000:M256:C:5217:273+256:0:0:0:505:20:160:0
Megapix HD;(null):669000:M256:C:5217:5136:0:0:1801,1802:558:20:160:0
Discovery Theater HD;(null):705000:M256:C:5217:5376:0:0:1801,1802:551:20:161:0
TLC HD;(null):705000:M256:C:5217:5392:0:0:1801,1802:552:20:161:0
NatGeo Wild HD;(null):705000:M256:C:5217:5408:0:0:1801,1802:533:20:161:0
Telecine Action HD;(null):711000:M256:C:5217:5664:0:0:1801,1802:562:20:162:0
TNT HD;(null):711000:M256:C:5217:5632:0:0:1801,1802:548:20:162:0
Space HD;(null):711000:M256:C:5217:5648:0:0:1801,1802:553:20:162:0
NET;NET:717000:M256:C:5217:5920:5921:0:0:154:20:163:0
ESPN HD;(null):717000:M256:C:5217:5904:5905:0:1801,1802:560:20:163:0
Max HD;(null):717000:M256:C:5217:5761:0:0:1801,1802:575:20:163:0
VH1 HD;(null):723000:M256:C:5217:6176:6177:0:0:526:20:164:0
Warner HD;(null):723000:M256:C:5217:6160:0:0:0:547:20:164:0
Sony HD;(null):723000:M256:C:5217:6144:0:0:1802,1801:549:20:164:0
National Geographic;(null):579000:M256:C:5217:512:513,514=por:0:0:33:20:142:0
AXN;(null):579000:M256:C:5217:560:0=por;561,562:0:1801,1802:34:20:142:0
Sony;(null):579000:M256:C:5217:576:0=bra;577,578:0:1801,1802:49:20:142:0
Fox;(null):579000:M256:C:5217:528:529,530=dub:0:1801,1802:50:20:142:0
ESPN;(null):579000:M256:C:5217:592:593,594=por:0:1801,1802:60:20:142:0
HBO;(null):579000:M256:C:5217:624:0=por;625,626:0:1801,1802:71:20:142:0
HBO Plus;(null):579000:M256:C:5217:640:0=dub;641,642:0:1801,1802:72:20:142:0
Speed;(null):579000:M256:C:5217:544:545,546=por:0:1801,1802:97:20:142:0
Bloomberg;(null):579000:M256:C:5217:608:609:0:1802,1801:150:20:142:0
Baladas RomÐnticas;(null):579000:M256:C:5217:0:106:0:0:315:20:142:0
Anos 60;(null):579000:M256:C:5217:0:107:0:0:316:20:142:0
New Rock;(null):579000:M256:C:5217:0:108:0:0:319:20:142:0
Anos 90;(null):579000:M256:C:5217:0:105:0:0:321:20:142:0
RÆdio Globo SP;(null):579000:M256:C:5217:0:118:0:0:350:20:142:0
Cultura;(null):585000:M256:C:5217:33+768:769:0:0:2:20:143:0
RedeTV!;(null):585000:M256:C:5217:800:801:0:0:8:20:143:0
Shop Time;(null):585000:M256:C:5217:784:785:0:0:31:20:143:0
Futura;(null):585000:M256:C:5217:816:817:0:0:32:20:143:0
Discovery Kids;(null):585000:M256:C:5217:864:865,866=por:0:1801,1802:45:20:143:0
Discovery Channel;(null):585000:M256:C:5217:848:849,850=por:0:1801,1802:51:20:143:0
Liv;(null):585000:M256:C:5217:832:834:0:1801,1802:52:20:143:0
Disc. Home & Health;(null):585000:M256:C:5217:880:881,882=por:0:1801,1802:55:20:143:0
Animal Planet;(null):585000:M256:C:5217:896:897,898=por:0:1801,1802:69:20:143:0
Natal;(null):585000:M256:C:5217:0:112:0:0:302:20:143:0
Bossa Nova;(null):585000:M256:C:5217:0:109:0:0:306:20:143:0
Latino;(null):585000:M256:C:5217:0:111:0:0:332:20:143:0
Jazz ClÆssico;(null):585000:M256:C:5217:0:110:0:0:336:20:143:0
Done.
