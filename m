Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KkNFu-0004yz-2P
	for linux-dvb@linuxtv.org; Mon, 29 Sep 2008 20:13:59 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K7Y00AC7YM79ZF0@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Mon, 29 Sep 2008 14:13:23 -0400 (EDT)
Date: Mon, 29 Sep 2008 14:13:19 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20080929064749.08B2E1642A6@ws1-4.us4.outblaze.com>
To: Marek Marek <albatrosmwdvb@yahoo.com>
Message-id: <48E11ABF.3040601@linuxtv.org>
MIME-version: 1.0
References: <20080929064749.08B2E1642A6@ws1-4.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org, stev391@email.com
Subject: Re: [linux-dvb] Compro VideoMate E600F analog PCIe TV/FM capture
	card
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

stev391@email.com wrote:
>> I have Compro VideoMate E600F analog PCIe TV/FM capture card with MPEG II A/V Encoder. I use 
>> Gentoo 2008.0 with 2.6.25-gentoo-r7 x86_64 kernel. There's no any support for this card on the 
>> V4L/DVB repository yet, so anybody help me?
>>
>> lspci -vvnn
>> 02:00.0 Multimedia video controller [0400]: Conexant Device [14f1:8852] (rev 02)
>>          Subsystem: Compro Technology, Inc. Device [185b:e800]
>>          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- 
>> FastB2B- DisINTx-
>>          Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- 
>> <PERR- INTx-
>>          Latency: 0, Cache Line Size: 4 bytes
>>          Interrupt: pin A routed to IRQ 5
>>          Region 0: Memory at fd600000 (64-bit, non-prefetchable) [size=2M]
>>          Capabilities: [40] Express (v1) Endpoint, MSI 00
>>                  DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>>                          ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
>>                  DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>>                          RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>                          MaxPayload 128 bytes, MaxReadReq 512 bytes
>>                  DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
>>                  LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <2us, L1 <4us
>>                          ClockPM- Suprise- LLActRep- BwNot-
>>                  LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>                          ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                  LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- 
>> ABWMgmt-
>>          Capabilities: [80] Power Management version 2
>>                  Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
>>                  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>          Capabilities: [90] Vital Product Data <?>
>>          Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
>>                  Address: 0000000000000000  Data: 0000
>>          Capabilities: [100] Advanced Error Reporting <?>
>>          Capabilities: [200] Virtual Channel <?>
>>
>> dmesg
>> cx23885 driver version 0.0.1 loaded
>> ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
>> cx23885[0]: Your board isn't known (yet) to the driver.  You can
>> cx23885[0]: try to pick one of the existing card configs via
>> cx23885[0]: card=<n> insmod option.  Updating to the latest
>> cx23885[0]: version might help as well.
>> cx23885[0]: Here is a list of valid choices for the card=<n> insmod option:
>> cx23885[0]:    card=0 -> UNKNOWN/GENERIC
>> cx23885[0]:    card=1 -> Hauppauge WinTV-HVR1800lp
>> cx23885[0]:    card=2 -> Hauppauge WinTV-HVR1800
>> cx23885[0]:    card=3 -> Hauppauge WinTV-HVR1250
>> cx23885[0]:    card=4 -> DViCO FusionHDTV5 Express
>> cx23885[0]:    card=5 -> Hauppauge WinTV-HVR1500Q
>> cx23885[0]:    card=6 -> Hauppauge WinTV-HVR1500
>> cx23885[0]:    card=7 -> Hauppauge WinTV-HVR1200
>> cx23885[0]:    card=8 -> Hauppauge WinTV-HVR1700
>> cx23885[0]:    card=9 -> Hauppauge WinTV-HVR1400
>> cx23885[0]:    card=10 -> DViCO FusionHDTV7 Dual Express
>> cx23885[0]:    card=11 -> DViCO FusionHDTV DVB-T Dual Express
>> cx23885[0]:    card=12 -> Leadtek Winfast PxDVR3200 H
>> CORE cx23885[0]: subsystem: 185b:e800, board: UNKNOWN/GENERIC [card=0,autodetected]
>> cx23885[0]: i2c bus 0 registered
>> cx23885[0]: i2c bus 1 registered
>> cx23885[0]: i2c bus 2 registered
>> cx23885_dev_checkrevision() Hardware revision = 0xb0
>> cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xfd600000
>> PCI: Setting latency timer of device 0000:02:00.0 to 64
>>
>> Conexant CX23885-13Z PCIe A/V Decoder
>> Conexant CX23417-11Z MPEG II A/V Encoder
>> XCeive XC2028ACQ Video Tuner
>>
>> Detailed specification is on http://linuxtv.org/wiki/index.php/Compro_VideoMate_E600F
>>
>> Thanks for any help.
>>
>> Marek Wasilow
>>
>> PS: Sorry for my poor english...
>  
> Marek,
> 
> At the moment there no support for this card (As you have found out already).
> 
> No one has mentioned adding support for this card yet.  However you have already started gathering the required items for adding support (as on the wiki page)
> 
> See the other VideoMate cards in the wiki for what else is required.  I have added support to the DVB side of the other VideoMate cards in a patch.  However due to some of the items in the patch that worked, but cannot be explained, this patch has not been incorporated to the main DVB drivers.
> 
> I do intend in the future to look at the analog side of these cards.  However the Leadtek PVR3200H will be the first that I will get the analog going on.  However I have been very busy lately and have not had a chance to look into.
> 
> Other items that you could include on the wiki page:
> * eeprom dump (read this http://www.linuxtv.org/pipermail/linux-dvb/2008-September/028529.html)
> * regspy dump of all registers in all states (It is Steven Toths DScaler Regspy version that you require)
> * i2c scan see the other Compro VideoMate wiki pages.
> 
> Thanks again for creating the wiki page and contacting the mailing list.  When I get around to adding support I will try to remember your email address, if not just check the mailing list.  If you want to add support check out the http://linuxtv.org/hg/~stoth/cx23885-audio/ add look at the recent changes.  This will give you an idea of what is required.

Marek, Mauro has sent me your email details directly. I replied to with 
some detailed instructions which you never replied to. I then received 
your second email asking for information, which I replied to again.

You obviously didn't see either email. I asked Mauro to forward my 
emails to you directly, thinking that perhaps your ISP blacklisted my ISP.

You never got any of these emails?

- Steve



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
