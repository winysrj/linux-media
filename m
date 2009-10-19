Return-path: <linux-media-owner@vger.kernel.org>
Received: from web25601.mail.ukl.yahoo.com ([217.12.10.160]:36937 "HELO
	web25601.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757838AbZJSXQW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Oct 2009 19:16:22 -0400
Message-ID: <640894.16785.qm@web25601.mail.ukl.yahoo.com>
References: <340263.68846.qm@web25604.mail.ukl.yahoo.com>  <20091020042913.1d3609d7@caramujo.chehab.org> <d9def9db0910191240g163f04aau631ec481ec6bdf70@mail.gmail.com>
Date: Mon, 19 Oct 2009 23:16:26 +0000 (GMT)
From: Romont Sylvain <psgman24@yahoo.fr>
Subject: Re : ISDB-T tuner
To: Markus Rechberger <mrechberger@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <d9def9db0910191240g163f04aau631ec481ec6bdf70@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you for your answer!

What do you mean by "Hybrid"?

My tuner is not a USB tuner... (PCI-E)

Here the lspci:
01:00.0 Multimedia controller: Fujitsu Limited. Device 2030 (rev 01)
        Subsystem: Device 1718:0020                                 
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx- 
        Latency: 0, Cache Line Size: 64 bytes                                                                
        Interrupt: pin A routed to IRQ 10                                                                    
        Region 0: Memory at cfdfc000 (64-bit, prefetchable) [size=16K]                                       
        Region 2: Memory at f9bffc00 (32-bit, non-prefetchable) [size=128]                                   
        Capabilities: <access denied>   

Please help me to make it working! lol

Thank you very much!



----- Message d'origine ----
De : Markus Rechberger <mrechberger@gmail.com>
� : Mauro Carvalho Chehab <mchehab@infradead.org>
Cc : Romont Sylvain <psgman24@yahoo.fr>; linux-media@vger.kernel.org
Envoy� le : Mar 20 Octobre 2009, 4 h 40 min 00 s
Objet : Re: ISDB-T tuner

On Mon, Oct 19, 2009 at 9:29 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> Hi Romont,
>
> Em Mon, 19 Oct 2009 12:16:30 +0000 (GMT)
> Romont Sylvain <psgman24@yahoo.fr> escreveu:
>
>> Hello!
>>
>> I actually live in Japan, I try to make working a tuner card ISDB-T with
>> linux. I searched a lot in internet but I find nothing....
>> How can I make it working?
>> My tuner card is a Pixela PIXDT090-PE0
>> in picture here:  http://bbsimg01.kakaku.com/images/bbs/000/208/208340_m.jpg
>>
>> Thank you for your help!!!
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

Here we can add that we also have fully working Hybrid/ISDB-T USB
fullseg devices for Linux already, just in case someone is interested
in it.
Feel free to contact me to get some more information about it. The
driver works from Linux 2.6.15 on (easy installation everywhere
without compiling).

Best Regards,
Markus



      
