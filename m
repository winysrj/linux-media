Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39177 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741AbZJTCkR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Oct 2009 22:40:17 -0400
Date: Tue, 20 Oct 2009 11:39:30 +0900
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Romont Sylvain <psgman24@yahoo.fr>
Cc: linux-media@vger.kernel.org
Subject: Re: Re : ISDB-T tuner
Message-ID: <20091020113930.1721958e@caramujo.chehab.org>
In-Reply-To: <565364.54329.qm@web25604.mail.ukl.yahoo.com>
References: <340263.68846.qm@web25604.mail.ukl.yahoo.com>
	<20091020042913.1d3609d7@caramujo.chehab.org>
	<565364.54329.qm@web25604.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 19 Oct 2009 23:11:48 +0000 (GMT)
Romont Sylvain <psgman24@yahoo.fr> escreveu:

> Thanks for your answer!!
> please find me somebody for make working my tuner! lol

For it to work, a developer will need a similar board, and, ideally, having the
chipset datasheets. I'm trying to contact some vendors while here to see if we can
find a way for adding more support on Linux. It would be nice if japanese linux
communities could also try to help on this process.

As I'm living on an ISDB-T Country (Brazil), I'll probably buy some hardware
from myself and try to do some code on my very limited spare time, if I think I'll have
some chance of writing a driver on a short window. Currently, my attributions as the
maintainer is consuming much more time that I wanted, preventing me to have much time
for coding.

> here, in japan, in 2011 the analog TV will stop and only Digital TV will work, the don't stop to speak about it in Tv and newspaper!
> So lot of people buy new TV or TV card for computer (like me) and almost all of thess Digital tuner card have the same tuner than mine!
> I know lot of people don't use linux because of this.....
> If it's working, use it with MythTV is VERY cool!

We'll need some changes at the applications to fully support ISDB-T, as there
are some new API parameters that may need to be used on some situations.

> 
> Thank you for your help!
> 
> PS:I have this with the command lspci:
> 01:00.0 Multimedia controller: Fujitsu Limited. Device 2030 (rev 01)
>         Subsystem: Device 1718:0020                                 
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx- 
>         Latency: 0, Cache Line Size: 64 bytes                                                                
>         Interrupt: pin A routed to IRQ 10                                                                    
>         Region 0: Memory at cfdfc000 (64-bit, prefetchable) [size=16K]                                       
>         Region 2: Memory at f9bffc00 (32-bit, non-prefetchable) [size=128]                                   
>         Capabilities: <access denied>   
> 
> PS2: Here my Tuner card:
> http://www.pixela.co.jp/products/tv_capture/pix_dt090_pe0/spec.html
> 
> 
> 
> ----- Message d'origine ----
> De : Mauro Carvalho Chehab <mchehab@infradead.org>
> À : Romont Sylvain <psgman24@yahoo.fr>
> Cc : linux-media@vger.kernel.org
> Envoyé le : Mar 20 Octobre 2009, 4 h 29 min 13 s
> Objet : Re: ISDB-T tuner
> 
> Hi Romont,
> 
> Em Mon, 19 Oct 2009 12:16:30 +0000 (GMT)
> Romont Sylvain <psgman24@yahoo.fr> escreveu:
> 
> > Hello!
> > 
> > I actually live in Japan, I try to make working a tuner card ISDB-T with
> > linux. I searched a lot in internet but I find nothing....
> > How can I make it working?
> > My tuner card is a Pixela PIXDT090-PE0
> > in picture here:  http://bbsimg01.kakaku.com/images/bbs/000/208/208340_m.jpg
> > 
> > Thank you for your help!!!
> 
> Unfortunately, only the Earthsoft PC1 board and the boards with dibcom 80xx USB
> boards are currently supported. In the case of Dibcom, it can support several
> different devices, but we may need to add the proper USB ID for the board at the driver.
> 
> I'm in Japan during this week for the Kernel Summit and Japan Linux Symposium.
> 
> One of objectives I'm expecting from this trip is to get more people involved on
> creating more drivers for ISDB and other Asian digital video standards.
> 
> 
> 
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
>       




Cheers,
Mauro
