Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:36482 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab3K0Wqs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Nov 2013 17:46:48 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MWY007021XZ7OB0@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 27 Nov 2013 17:46:47 -0500 (EST)
Date: Wed, 27 Nov 2013 20:46:42 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libdvbv5: dvb_table_pat_init is leaking memory
Message-id: <20131127204642.05ddaac5@samsung.com>
In-reply-to: <20131127203121.78baf121@infradead.org>
References: <CAJxGH09uZhZ0m4GcpAF4moURp18hPmBh5cOP_ZHoNxAaadL_XQ@mail.gmail.com>
 <20131127203121.78baf121@infradead.org>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 27 Nov 2013 20:31:21 -0200
Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:

> Hi Gregor,
> 
> Em Wed, 27 Nov 2013 22:55:32 +0100
> Gregor Jasny <gjasny@googlemail.com> escreveu:
> 
> > Hello,
> > 
> > Coverity noticed that dvb_table_pat_init leaks the reallocated memory
> > stored in pat:
> > http://git.linuxtv.org/v4l-utils.git/blob/HEAD:/lib/libdvbv5/descriptors/pat.c#l26
> > 
> > Mauro, could you please check?
> 
> On my tests with Valgrind, I'm not noticing any memory leak there, at
> least on the very latest version I pushed today[1].
> 
> I tested here with DVB-T, DVB-T2, DVB-S, DVB-S2 and DVB-C.
> 
> I didn't test the current version yet with ATSC or ISDB-T. Those are
> on my todo list. I'll likely do ATSC test today or tomorrow.
> 
> ISDB-T test might take some time, as I'm having some troubles to test it
> here those days.
> 
> That's said, I would love to get rid of that realloc() on PAT, but this
> would break the existing userspace interface. So, such change, if done,
> would require some care, as at least tvdaemon relies on it.
> 
> Regards,
> Mauro
> 
> [1] Not sure if you noticed, but I added ~80 patches for it today.

Gregor,

After looking into it inside coverity, I suspect that coverity is 
complaining because the code is:

	pat = some_function(pat, size);

E. g. it is not understanding that realloc takes the original pointer
as an entry, and returns a pointer to the newer pointer with the bigger
size.

So, it thinks that the first memory allocated for pat is not visible
anymore, and it will leak.

FYI, this is the result of a DVB-C scanning (35 frequencies, each with its
own PAT table):

==16035== Memcheck, a memory error detector
==16035== Copyright (C) 2002-2012, and GNU GPL'd, by Julian Seward et al.
==16035== Using Valgrind-3.8.1 and LibVEX; rerun with -h for copyright info
==16035== Command: ./utils/dvb/dvbv5-scan -I channel /home/mchehab/dvbc-teste
==16035== 
ERROR    command BANDWIDTH_HZ (5) not found during retrieve
INFO     Scanning frequency #1 573000000
Lock   (0x1f) Quality= Poor Signal= 100.00% C/N= 36.40dB UCB= 36535 postBER= 1.34x10^-3 PER= 4.78x10^-3
==16035== Warning: noted but unhandled ioctl 0x6f2a with no size/direction hints
==16035==    This could cause spurious value errors to appear.
==16035==    See README_MISSING_SYSCALL_OR_IOCTL for guidance on writing a proper wrapper.
==16035== Warning: noted but unhandled ioctl 0x6f2a with no size/direction hints
==16035==    This could cause spurious value errors to appear.
==16035==    See README_MISSING_SYSCALL_OR_IOCTL for guidance on writing a proper wrapper.
==16035== Warning: noted but unhandled ioctl 0x6f2a with no size/direction hints
==16035==    This could cause spurious value errors to appear.
==16035==    See README_MISSING_SYSCALL_OR_IOCTL for guidance on writing a proper wrapper.
INFO     Service SBT, provider (null): digital television
INFO     Service Globo, provider Globo: digital television
INFO     Service Record, provider (null): digital television
INFO     Service Band, provider (null): digital television
INFO     Service LBV - Rede Mundial, provider (null): digital television
INFO     Service Cartoon Network, provider (null): digital television
INFO     Service TNT, provider (null): digital television
INFO     Service Boomerang, provider (null): digital television
INFO     Service NET Games, provider (null): digital television
INFO     Service NET Música, provider (null): digital television
INFO     Service Pagode, provider (null): digital radio
INFO     Service Axé, provider (null): digital radio
INFO     Service Festa, provider (null): digital radio
INFO     Service Trilhas Sonoras, provider (null): digital radio
INFO     Service Rádio Globo RJ, provider (null): digital radio
INFO     Service 01070138, provider (null): user defined
INFO     Service 01070238, provider (null): user defined
INFO     New transponder/channel found: #2: 717000000
INFO     New transponder/channel found: #3: 723000000
INFO     New transponder/channel found: #4: 549000000
INFO     New transponder/channel found: #5: 555000000
INFO     New transponder/channel found: #6: 561000000
INFO     New transponder/channel found: #7: 567000000
INFO     New transponder/channel found: #8: 435000000
INFO     New transponder/channel found: #9: 441000000
INFO     New transponder/channel found: #10: 447000000
INFO     New transponder/channel found: #11: 453000000
INFO     New transponder/channel found: #12: 459000000
INFO     New transponder/channel found: #13: 465000000
INFO     New transponder/channel found: #14: 471000000
INFO     New transponder/channel found: #15: 579000000
INFO     New transponder/channel found: #16: 585000000
INFO     New transponder/channel found: #17: 591000000
INFO     New transponder/channel found: #18: 597000000
INFO     New transponder/channel found: #19: 603000000
INFO     New transponder/channel found: #20: 609000000
INFO     New transponder/channel found: #21: 615000000
INFO     New transponder/channel found: #22: 621000000
INFO     New transponder/channel found: #23: 627000000
INFO     New transponder/channel found: #24: 633000000
INFO     New transponder/channel found: #25: 639000000
INFO     New transponder/channel found: #26: 681000000
INFO     New transponder/channel found: #27: 651000000
INFO     New transponder/channel found: #28: 693000000
INFO     New transponder/channel found: #29: 699000000
INFO     New transponder/channel found: #30: 687000000
INFO     New transponder/channel found: #31: 657000000
INFO     New transponder/channel found: #32: 663000000
INFO     New transponder/channel found: #33: 669000000
INFO     New transponder/channel found: #34: 705000000
INFO     New transponder/channel found: #35: 711000000
INFO     Scanning frequency #2 717000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 27.80dB UCB= 36583 postBER= 3.14x10^-3 PER= 0
INFO     Service Polishop, provider (null): digital television
INFO     Service NET, provider NET: digital television
INFO     Service ESPN+ HD, provider (null): digital television
INFO     Service Max HD, provider (null): digital television
INFO     Scanning frequency #3 723000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 35.60dB UCB= 36640 postBER= 3.14x10^-3 PER= 0
INFO     Service VH1 HD, provider (null): digital television
INFO     Service Warner HD, provider (null): digital television
INFO     Service Sony HD, provider (null): digital television
INFO     Scanning frequency #4 549000000
Lock   (0x1f) Quality= Poor Signal= 100.00% C/N= 36.30dB UCB= 36699 postBER= 3.14x10^-3 PER= 4.61x10^-3
INFO     Service + Globosat, provider + Globosat: digital television
INFO     Service Cinemax, provider Cinemax: digital television
INFO     Service TBS, provider TBS: digital television
INFO     Service AXN HD, provider AXN HD: digital television
INFO     Service Telecine Touch HD, provider Telecine Touch HD: digital television
INFO     Scanning frequency #5 555000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 36.30dB UCB= 36993 postBER= 3.14x10^-3 PER= 0
INFO     Service Gloob, provider Gloob: digital television
INFO     Service OFF, provider OFF: digital television
INFO     Service Disney Junior, provider Disney Junior: digital television
INFO     Service OFF HD, provider (null): digital television
INFO     Service Telecine Fun HD, provider Telecine Fun HD: digital television
INFO     Scanning frequency #6 561000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 36.20dB UCB= 37073 postBER= 3.14x10^-3 PER= 0
INFO     Service BBC HD, provider BBC HD: digital television
INFO     Service Fox Sports HD, provider Fox Sports HD: digital television
INFO     Service Disney Channel HD, provider Disney Channel HD: digital television
INFO     Scanning frequency #7 567000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 31.80dB UCB= 37119 postBER= 3.14x10^-3 PER= 0
INFO     Service BIS, provider BIS: digital television
INFO     Service BBC World News, provider (null): digital television
INFO     Service Record HD, provider Record HD: digital television
INFO     Service Multishow HD, provider (null): digital television
INFO     Scanning frequency #8 435000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 37.10dB UCB= 37263 postBER= 3.14x10^-3 PER= 0
INFO     Service Curta!, provider NET: digital television
INFO     Service Woohoo, provider NET: digital television
INFO     Service Arte 1, provider NET: digital television
INFO     Service Prime Box Brazil, provider NET: digital television
INFO     Service Globo News HD, provider (null): digital television
INFO     Service GNT HD, provider GNT HD: digital television
INFO     Scanning frequency #9 441000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 36.90dB UCB= 37464 postBER= 3.14x10^-3 PER= 0
INFO     Service Music Box Brazil, provider NET: digital television
INFO     Service PlayTV, provider NET: digital television
INFO     Service Gloob HD, provider Gloob HD: digital television
INFO     Service ESPN Brasil HD, provider ESPN Brasil HD: digital television
INFO     Scanning frequency #10 447000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 26.70dB UCB= 37718 postBER= 3.14x10^-3 PER= 0
INFO     Service ID HD, provider (null): digital television
INFO     Service Discovery HD, provider (null): digital television
INFO     Service Disc. Home & Health HD, provider (null): digital television
INFO     Scanning frequency #11 453000000
Lock   (0x1f) Quality= Poor Signal= 100.00% C/N= 34.70dB UCB= 37979 postBER= 3.14x10^-3 PER= 20.4x10^-3
INFO     Service SporTV2 HD, provider (null): digital television
INFO     Service SporTV HD, provider (null): digital television
INFO     Service Premiere FC HD 2, provider NET HD 3D: user defined
INFO     Scanning frequency #12 459000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 36.80dB UCB= 38051 postBER= 3.14x10^-3 PER= 0
INFO     Service Cultura HD, provider (null): digital television
INFO     Service Universal Channel HD, provider (null): digital television
INFO     Service Discovery Kids HD, provider (null): digital television
INFO     Scanning frequency #13 465000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 36.50dB UCB= 38078 postBER= 3.14x10^-3 PER= 0
INFO     Service ESPN HD , provider (null): digital television
INFO     Service HBO2 HD, provider (null): digital television
INFO     Service HBO Signature HD, provider (null): digital television
INFO     Scanning frequency #14 471000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 36.50dB UCB= 38164 postBER= 3.14x10^-3 PER= 0
INFO     Service Comedy Central, provider (null): digital television
INFO     Service Nick Jr., provider (null): digital television
INFO     Service MTV HD, provider (null): digital television
INFO     Service MGM HD, provider (null): digital television
INFO     Scanning frequency #15 579000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 36.70dB UCB= 38239 postBER= 3.14x10^-3 PER= 0
INFO     Service National Geographic, provider (null): digital television
INFO     Service AXN, provider (null): digital television
INFO     Service Sony, provider (null): digital television
INFO     Service Fox, provider (null): digital television
INFO     Service ESPN, provider (null): digital television
INFO     Service HBO, provider (null): digital television
INFO     Service HBO Plus, provider (null): digital television
INFO     Service Fox Sports, provider Fox Sports: digital television
INFO     Service Bloomberg, provider (null): digital television
INFO     Service Baladas Românticas, provider (null): digital radio
INFO     Service Anos 60, provider (null): digital radio
INFO     Service New Rock, provider (null): digital radio
INFO     Service Anos 90, provider (null): digital radio
INFO     Service Rádio Globo SP, provider (null): digital radio
WARNING  Service ID 934 not found on PMT!
INFO     Scanning frequency #16 585000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 36.70dB UCB= 38347 postBER= 3.14x10^-3 PER= 0
INFO     Service Cultura, provider (null): digital television
INFO     Service RedeTV!, provider (null): digital television
INFO     Service Shop Time, provider (null): digital television
INFO     Service Futura, provider (null): digital television
INFO     Service Discovery Kids, provider (null): digital television
INFO     Service Discovery Channel, provider (null): digital television
INFO     Service ID, provider (null): digital television
INFO     Service Disc. Home & Health, provider (null): digital television
INFO     Service Animal Planet, provider (null): digital television
INFO     Service Jovem Guarda, provider (null): digital radio
INFO     Service Bossa Nova, provider (null): digital radio
INFO     Service Latino, provider (null): digital radio
INFO     Service Jazz Clássico, provider (null): digital radio
INFO     Scanning frequency #17 591000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 35.80dB UCB= 38588 postBER= 3.14x10^-3 PER= 0
INFO     Service GNT, provider (null): digital television
INFO     Service Multishow, provider (null): digital television
INFO     Service Warner Channel, provider (null): digital television
INFO     Service Canal Brasil, provider (null): digital television
INFO     Service ESPN Brasil, provider (null): digital television
INFO     Service HBO 2, provider (null): digital television
INFO     Service Premiere FC, provider Premiere FC: user defined
INFO     Service RAI, provider (null): digital television
INFO     Service CNN International, provider (null): digital television
INFO     Service Anos 80, provider (null): digital radio
INFO     Service Blues, provider (null): digital radio
INFO     Service Rhythm & Blues, provider (null): digital radio
INFO     Service Standards, provider (null): digital radio
INFO     Scanning frequency #18 597000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 36.50dB UCB= 38727 postBER= 3.14x10^-3 PER= 0
INFO     Service TV Senado, provider (null): digital television
INFO     Service Rede Vida, provider (null): digital television
INFO     Service Disney XD, provider (null): digital television
INFO     Service Telecine Premium, provider (null): digital television
INFO     Service Telecine Cult, provider (null): digital television
INFO     Service Disney Channel, provider (null): digital television
INFO     Service Record News, provider (null): digital television
INFO     Service Canal Rural, provider (null): digital television
INFO     Service TV5, provider (null): digital television
INFO     Service Samba de Raiz, provider (null): digital radio
INFO     Service New Age, provider (null): digital radio
INFO     Service Jazz Contemporaneo, provider (null): digital radio
INFO     Service Música Clássica, provider (null): digital radio
INFO     Scanning frequency #19 603000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 36.10dB UCB= 38924 postBER= 3.14x10^-3 PER= 0
INFO     Service Globo News, provider (null): digital television
INFO     Service Universal Channel, provider (null): digital television
INFO     Service Nickelodeon, provider (null): digital television
INFO     Service Telecine Action, provider (null): digital television
INFO     Service Telecine Touch, provider (null): digital television
INFO     Service MTV (em HD no 525), provider (null): digital television
INFO     Service VH1, provider (null): digital television
INFO     Service Premiere FC, provider Premiere FC: user defined
INFO     Service Sexy Hot, provider (null): user defined
INFO     Service Rádio Kids, provider (null): digital radio
INFO     Service Forró, provider (null): digital radio
INFO     Service Lounge, provider (null): digital radio
INFO     Service Música Orquestrada, provider (null): digital radio
INFO     Scanning frequency #20 609000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 35.00dB UCB= 38992 postBER= 3.14x10^-3 PER= 0
INFO     Service NET Cidade, provider (null): digital television
INFO     Service Rede 21, provider (null): digital television
INFO     Service TV Justiça, provider (null): digital television
INFO     Service SporTV2, provider (null): digital television
INFO     Service SporTV, provider SporTV: digital television
INFO     Service FX, provider (null): digital television
INFO     Service The History Channel, provider (null): digital television
INFO     Service Fox Life, provider (null): digital television
INFO     Service DW, provider (null): digital television
INFO     Service Sertanejo, provider (null): digital radio
INFO     Service Rock Clássico, provider (null): digital radio
INFO     Service Reggae, provider (null): digital radio
INFO     Service Eletrônica, provider (null): digital radio
INFO     Service CBN, provider (null): digital radio
INFO     Scanning frequency #21 615000000
Lock   (0x1f) Quality= Poor Signal= 100.00% C/N= 32.10dB UCB= 39163 postBER= 1.07x10^-3 PER= 4.46x10^-3
INFO     Service Telecine Pipoca, provider (null): digital television
INFO     Service E!, provider (null): digital television
INFO     Service Discovery Science, provider (null): digital television
INFO     Service Discovery Civilization, provider (null): digital television
INFO     Service Discovery Turbo, provider (null): digital television
INFO     Service Combate, provider Combate: user defined
INFO     Service Premiere FC, provider Premiere FC: user defined
INFO     Service Premiere 24hs, provider Premiere 24hs: user defined
INFO     Service MPB, provider (null): digital radio
INFO     Service Anos 70, provider (null): digital radio
INFO     Service Disco, provider (null): digital radio
INFO     Service Gospel, provider (null): digital radio
INFO     Service Globo FM, provider (null): digital radio
INFO     Scanning frequency #22 621000000
Lock   (0x1f) Quality= Poor Signal= 100.00% C/N= 27.30dB UCB= 39314 postBER= 1.07x10^-3 PER= 3.94x10^-3
ERROR    dvb_read_section: no data read on pid 918 table 2
ERROR    error while reading the PMT table for service 0x0006
INFO     Service Gazeta, provider (null): digital television
INFO     Service Canal Universitário, provider (null): digital television
INFO     Service NET TV, provider (null): digital television
INFO     Service Max, provider (null): digital television
INFO     Service Max *, provider (null): digital television
INFO     Service Premiere FC, provider Premiere FC: user defined
INFO     Service ART Latino, provider (null): digital television
INFO     Service For Man, provider (null): user defined
INFO     Service NET3 (uso interno), provider (null): digital television
INFO     Scanning frequency #23 627000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 36.30dB UCB= 39644 postBER= 3.14x10^-3 PER= 0
INFO     Service TV Rá Tim Bum, provider (null): digital television
INFO     Service MGM, provider (null): digital television
INFO     Service HBO Family, provider (null): digital television
INFO     Service Max Prime, provider (null): digital television
INFO     Service HBO Plus *e, provider (null): digital television
INFO     Service HBO Signature, provider (null): digital television
INFO     Service Maxprime *e, provider (null): digital television
INFO     Service Bem Simples, provider (null): digital television
INFO     Service Mosaico Multijogos, provider Mosaico Multijogos: digital television
INFO     Scanning frequency #24 633000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 34.10dB UCB= 39657 postBER= 3.14x10^-3 PER= 0
INFO     Service NOW, provider NOW: digital television
INFO     Service NOW em Cartaz, provider (null): digital television
INFO     Service PPV01 Filmes, provider (null): user defined
INFO     Service PPV03 Filmes, provider (null): user defined
INFO     Service PPV04 Filmes, provider (null): user defined
INFO     Service PPV05 Filmes, provider (null): user defined
INFO     Service PPV06 Filmes, provider (null): user defined
INFO     Service NET Vendas pelo Controle, provider (null): digital television
INFO     Service Climatempo, provider (null): digital television
INFO     Service NET2 (uso interno), provider (null): digital television
INFO     Service Playboy TV, provider (null): user defined
INFO     Service Mosaico Variedades, provider (null): user defined
INFO     Service Mosaico Informação, provider (null): user defined
INFO     Service NET TV HD, provider NET TV HD: digital television
INFO     Scanning frequency #25 639000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 36.10dB UCB= 39877 postBER= 3.14x10^-3 PER= 0
INFO     Service A&E, provider (null): digital television
INFO     Service PPV02 Wide, provider (null): user defined
INFO     Service Premiere FC Interativo, provider (null): digital television
INFO     Service Premiere FC, provider Premiere FC: user defined
INFO     Service Studio Universal, provider (null): digital television
INFO     Service Portal ITV, provider (null): user defined
WARNING  Service ID 199 not found on PMT!
INFO     Scanning frequency #26 681000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 28.10dB UCB= 39916 postBER= 3.14x10^-3 PER= 0
INFO     Service TV Brasil, provider (null): digital television
INFO     Service Canal Comunitário, provider (null): digital television
INFO     Service Megapix, provider (null): digital television
INFO     Service Sony Spin, provider (null): digital television
INFO     Service TCM, provider (null): digital television
INFO     Service Syfy, provider (null): digital television
INFO     Service TLC, provider (null): digital television
INFO     Service NHK, provider (null): digital television
INFO     Service Private, provider (null): user defined
INFO     Scanning frequency #27 651000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 35.30dB UCB= 40167 postBER= 3.14x10^-3 PER= 0
INFO     Service Canal Comunitário, provider (null): digital television
INFO     Service Canal Comunitário JCI, provider (null): digital television
INFO     Service TV Canção Nova, provider (null): digital television
INFO     Service TV Câmara, provider (null): digital television
INFO     Service Canal Legislativo, provider (null): digital television
INFO     Service World Net, provider (null): digital television
INFO     Service TV Assembleia JCI, provider (null): digital television
INFO     Service Sesc TV, provider (null): digital television
INFO     Service Rede Gospel, provider (null): digital television
INFO     Scanning frequency #28 693000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 35.50dB UCB= 40361 postBER= 3.14x10^-3 PER= 0
INFO     Service Band Sports, provider (null): digital television
INFO     Service Band News, provider (null): digital television
INFO     Service Premiere FC, provider Premiere FC: user defined
INFO     Service Sextreme, provider (null): user defined
INFO     Service RFI, provider (null): digital radio
INFO     Service + Globosat HD, provider (null): digital television
INFO     Scanning frequency #29 699000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 36.80dB UCB= 40429 postBER= 3.14x10^-3 PER= 0
INFO     Service Glitz*, provider (null): digital television
INFO     Service Telecine Premium HD, provider (null): digital television
INFO     Service Premiere HD, provider Premiere HD: user defined
INFO     Scanning frequency #30 687000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 36.00dB UCB= 40661 postBER= 3.14x10^-3 PER= 0
INFO     Service NBR, provider (null): digital television
INFO     Service SporTV3, provider SporTV3: digital television
INFO     Service BIS HD, provider (null): digital television
INFO     Service Fox+NatGeo HD, provider (null): digital television
INFO     Scanning frequency #31 657000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 28.20dB UCB= 40734 postBER= 3.14x10^-3 PER= 0
INFO     Service NET1 (uso interno), provider (null): digital television
INFO     Service Telecine Pipoca HD, provider (null): digital television
INFO     Service HBO HD, provider (null): digital television
INFO     Service HBO Plus HD , provider (null): digital television
INFO     Scanning frequency #32 663000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 35.90dB UCB= 40904 postBER= 3.14x10^-3 PER= 0
INFO     Service Viva, provider (null): digital television
INFO     Service RedeTV! HD, provider (null): digital television
INFO     Service Band HD, provider (null): digital television
INFO     Scanning frequency #33 669000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 36.50dB UCB= 40963 postBER= 3.14x10^-3 PER= 0
INFO     Service Space, provider (null): digital television
INFO     Service Telecine Fun, provider (null): digital television
INFO     Service Globo HD, provider (null): digital television
INFO     Service Megapix HD, provider (null): digital television
INFO     Scanning frequency #34 705000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 36.70dB UCB= 41131 postBER= 3.14x10^-3 PER= 0
INFO     Service Discovery HD Theater, provider (null): digital television
INFO     Service NatGeo Wild HD, provider (null): digital television
INFO     Service TLC HD, provider (null): digital television
INFO     Scanning frequency #35 711000000
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 35.70dB UCB= 41192 postBER= 3.14x10^-3 PER= 0
INFO     Service TNT HD, provider (null): digital television
INFO     Service Space HD, provider (null): digital television
INFO     Service Telecine Action HD, provider (null): digital television
==16035== 
==16035== HEAP SUMMARY:
==16035==     in use at exit: 0 bytes in 0 blocks
==16035==   total heap usage: 14,113 allocs, 14,113 frees, 50,774,673 bytes allocated
==16035== 
==16035== All heap blocks were freed -- no leaks are possible
==16035== 
==16035== For counts of detected and suppressed errors, rerun with: -v
==16035== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 2 from 2)

No memory leaks.

On a few cases, dvbv5-scan (with uses those descriptors) report a single
memory leak:

==10032== 
==10032== HEAP SUMMARY:
==10032==     in use at exit: 120 bytes in 1 blocks
==10032==   total heap usage: 17,679 allocs, 17,678 frees, 67,013,335 bytes allocated
==10032== 
==10032== 120 bytes in 1 blocks are definitely lost in loss record 1 of 1
==10032==    at 0x4A0645D: malloc (in /usr/lib64/valgrind/vgpreload_memcheck-amd64-linux.so)
==10032==    by 0x3A2786D17D: getdelim (iogetdelim.c:66)
==10032==    by 0x4064B6: read_dvb_file (stdio.h:117)
==10032==    by 0x4016EC: main (dvbv5-scan.c:227)
==10032== 
==10032== LEAK SUMMARY:
==10032==    definitely lost: 120 bytes in 1 blocks
==10032==    indirectly lost: 0 bytes in 0 blocks
==10032==      possibly lost: 0 bytes in 0 blocks
==10032==    still reachable: 0 bytes in 0 blocks
==10032==         suppressed: 0 bytes in 0 blocks
==10032== 
==10032== For counts of detected and suppressed errors, rerun with: -v
==10032== ERROR SUMMARY: 1 errors from 1 contexts (suppressed: 2 from 2)

This is due to the usage of strtok(). It internally calls getdelim(). 

The getdelim() internally allocates a working buffer that it is 
freed/reallocated every time strtok is called. I didn't find any way yet
to free it, but this is not a big issue. I suspect that this is some
glibc sort of bug.

-- 

Cheers,
Mauro
