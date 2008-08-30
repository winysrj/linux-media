Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <owen.townend@gmail.com>) id 1KZRDy-0001Ru-Nt
	for linux-dvb@linuxtv.org; Sat, 30 Aug 2008 16:14:50 +0200
Received: by an-out-0708.google.com with SMTP id c18so198459anc.125
	for <linux-dvb@linuxtv.org>; Sat, 30 Aug 2008 07:14:42 -0700 (PDT)
Message-ID: <bb72339d0808300714k3393188en77f1fab735936e03@mail.gmail.com>
Date: Sun, 31 Aug 2008 00:14:41 +1000
From: "Owen Townend" <owen.townend@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <48B91E1B.8090408@interia.pl>
MIME-Version: 1.0
Content-Disposition: inline
References: <48B59989.4080004@interia.pl>
	<bb72339d0808282125g59a24920o6af8b41ccfa1f15c@mail.gmail.com>
	<48B7AB83.90802@farba.eu.org>
	<bb72339d0808290347l7732b608idaabad895c2488d7@mail.gmail.com>
	<48B82D09.60200@interia.pl>
	<bb72339d0808291856p487a3fc2p8333e3f16d135a6e@mail.gmail.com>
	<48B91E1B.8090408@interia.pl>
Subject: Re: [linux-dvb] saa7162. Aver saa7135 cards. User stupid questions.
	More or less.
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

2008/8/30  <mincho@interia.pl>:
>
>>
>> No worries, I'll add the info to the wiki.
>> Can you send through what distro you're using as well as the output of
>> `uname -a`. Also can you send `lspci -vvnn` instead of just `-vv` --
>
> Distro is Fedora 9 32bit.
>
> lspci -vvnn:
> 01:0a.0 Multimedia controller [0480]: Philips Semiconductors
> SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)
>         Subsystem: Avermedia Technologies Inc Unknown device [1461:2c05]
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 32
>         Interrupt: pin A routed to IRQ 7
>         Region 0: Memory at e4000000 (32-bit, non-prefetchable) [size=2K]
>         Capabilities: [40] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>         Kernel driver in use: saa7134
>         Kernel modules: saa7134
>
> uname -a:
> Linux mincho 2.6.25.14-108.fc9.i686 #1 SMP Mon Aug 4 14:08:11 EDT 2008
> i686 athlon i386 GNU/Linux
>
>
>> I'll create a separate page rather than add it on as the current page
>> name/link is specific to the A16AR.
>> (which it's not for the Hybrid+FM)
> Thats not Hybrid. Thats DVB-T 777 A16A-C.
> I asked about Hybrid A16D, because my card - that 777 is not described
> anywhere but works.
> Therefore I was not sure if Hybrid A16D description is up-to-date as 777
> A16A-C does not exist at all.
>
> Cheers
> Wieslaw

My apologies, I was just drawing a comparison to the hybrid.
Thanks for the information, I've created a page for the 777 A16A-C:
http://www.linuxtv.org/wiki/index.php/AVerMedia_AVerTV_DVB-T_777_(A16A-C)

If there's anything missing feel free to add it, or let me know and I can.
Next I, or someone, will have to add a patch to have it detected and
labeled correctly instead of 'Avermedia Technologies Inc Unknown
device'. As the card itself is working this shouldn't be too hard.

cheers,
Owen.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
