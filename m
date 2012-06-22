Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:37016 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab2FVUDc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 16:03:32 -0400
Received: by gglu4 with SMTP id u4so1870774ggl.19
        for <linux-media@vger.kernel.org>; Fri, 22 Jun 2012 13:03:31 -0700 (PDT)
Message-ID: <4FE4CF8F.4050306@gmail.com>
Date: Fri, 22 Jun 2012 17:03:27 -0300
From: Ariel Mammoli <cmammoli@gmail.com>
Reply-To: admin@vpisa.com.ar
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: Tuner NOGANET NG-PTV FM
References: <4FE4BC43.9070100@gmail.com> <CALF0-+VM902A0x+TNXB1qe_jhKcYOs6ti1hMZBsTuTe6Ucmpeg@mail.gmail.com> <4FE4C2BE.2060301@gmail.com> <CALF0-+V430u34yv8arUsN=N5Vh-cJs=7JJdiaEH_OonarJ065g@mail.gmail.com> <4FE4CA11.5030208@gmail.com> <CALF0-+X4gHGogHWaHUHMRGXbK5JjGZ0hgLOGRVMQx-QXV15tGg@mail.gmail.com>
In-Reply-To: <CALF0-+X4gHGogHWaHUHMRGXbK5JjGZ0hgLOGRVMQx-QXV15tGg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ezequiel;

El vie 22 jun 2012 16:54:52 ART, Ezequiel Garcia ha escrito:
> Hi Ariel,
>
> On Fri, Jun 22, 2012 at 4:40 PM, Ariel Mammoli <cmammoli@gmail.com> wrote:
>> Hello again Ezequiel,
>>
>> El vie 22 jun 2012 16:16:51 ART, Ezequiel Garcia ha escrito:
>>> Hi Ariel,
>>>
>>> Please don't drop linux-media from Cc.
>>>
>>> On Fri, Jun 22, 2012 at 4:08 PM, Ariel Mammoli <cmammoli@gmail.com> wrote:
>>>> Hi Ezequiel,
>>>>
>>>> El vie 22 jun 2012 15:51:02 ART, Ezequiel Garcia ha escrito:
>>>>> Hi Ariel,
>>>>>
>>>>> On Fri, Jun 22, 2012 at 3:41 PM, Ariel Mammoli <cmammoli@gmail.com> wrote:
>>>>>>
>>>>>> I have a tuner NOGANET "NG-FM PTV" which has the Philips chip 7134.
>>>>>> I have reviewed the list of values several times but can not find it.
>>>>>> What are the correct values to configure the module saa7134?
>>>>>>
>>>>>
>>>>> That's a PCI card, right? PCI are identified by subvendor  and subdevice IDs.
>>>>>
>>>>> Can you tell us those IDs for your card?
>>>>>
>>>>> Regards,
>>>>> Ezequiel.
>>>>
>>>> Indeed it is a PCI card. Below are the data:
>>>> 04:05.0 Multimedia controller [0480]: Philips Semiconductors SAA7130
>>>> Video Broadcast Decoder [1131:7130] (rev 01)
>>>>
>>>
>>> I believe it is currently not supported under Linux.
>>>
>
> I was just looking here:
>
> http://linuxtv.org/wiki/index.php/Compro_VideoMate_S350
>
> and I think I gave you wrong information, sorry.
>
> Could you better *full* output of
>
> $ lspci -vvnn
>
> with the board connected?
>
> Sorry again for misdirections,
> Ezequiel.

No problem :) , here is the result of lspci-vvnn:

04:05.0 Multimedia controller [0480]: Philips Semiconductors SAA7130 
Video Broadcast Decoder [1131:7130] (rev 01)
	Subsystem: Philips Semiconductors SAA7130-based TV tuner card 
[1131:0000]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (3750ns min, 9500ns max)
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fbfffc00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [40] Power Management version 1
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: saa7134
	Kernel modules: saa7134

Regards,
Ariel.

