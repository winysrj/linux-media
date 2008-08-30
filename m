Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.240])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <owen.townend@gmail.com>) id 1KZFho-00052q-TS
	for linux-dvb@linuxtv.org; Sat, 30 Aug 2008 03:56:59 +0200
Received: by an-out-0708.google.com with SMTP id c18so180856anc.125
	for <linux-dvb@linuxtv.org>; Fri, 29 Aug 2008 18:56:45 -0700 (PDT)
Message-ID: <bb72339d0808291856p487a3fc2p8333e3f16d135a6e@mail.gmail.com>
Date: Sat, 30 Aug 2008 11:56:44 +1000
From: "Owen Townend" <owen.townend@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <48B82D09.60200@interia.pl>
MIME-Version: 1.0
Content-Disposition: inline
References: <48B59989.4080004@interia.pl>
	<bb72339d0808282125g59a24920o6af8b41ccfa1f15c@mail.gmail.com>
	<48B7AB83.90802@farba.eu.org>
	<bb72339d0808290347l7732b608idaabad895c2488d7@mail.gmail.com>
	<48B82D09.60200@interia.pl>
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
>> Hey,
>>  If it's detecting and working as the 777 A16AR then it would make
>> sense to add it to the existing page, similar to the A16AR/A16D
>> Hybrid+FM Page.
>>  As to the first question, the 7162 development seemed to be still
>> progressing as of last month:
>>  http://article.gmane.org/gmane.linux.drivers.dvb/43048
> Hey, hey.
>
> Here are few pictures (slow link):
> ftp://farba.eu.org//download/AVER777A16A-C.zip
>
> lspci -vv:
> 01:0a.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135
> Video Broadcast Decoder (rev d1)
>         Subsystem: Avermedia Technologies Inc Unknown device 2c05
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
>
> And dmesg output:
> Aug 29 18:24:23 mincho kernel: saa7130/34: v4l2 driver version 0.2.14 loaded
> Aug 29 18:24:23 mincho kernel: saa7133[0]: found at 0000:01:0a.0, rev:
> 209, irq: 7, latency: 32, mmio: 0xe4000000
> Aug 29 18:24:23 mincho kernel: saa7133[0]: subsystem: 1461:2c05, board:
> AverTV DVB-T 777 [card=85,autodetected]
> Aug 29 18:24:23 mincho kernel: saa7133[0]: board init: gpio is 2e400
> Aug 29 18:24:23 mincho kernel: input: saa7134 IR (AverTV DVB-T 777) as
> /devices/pci0000:00/0000:00:08.0/0000:01:0a.0/input/input7
>
> Bag your pardon for writing to priv address.
>
> Cheers, cheers.
> --
> WK

No worries, I'll add the info to the wiki.
Can you send through what distro you're using as well as the output of
`uname -a`. Also can you send `lspci -vvnn` instead of just `-vv` --
It adds the numeric identifiers.

I'll create a separate page rather than add it on as the current page
name/link is specific to the A16AR.
(which it's not for the Hybrid+FM)

cheers,
Owen.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
