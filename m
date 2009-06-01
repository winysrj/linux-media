Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.imap4all.com ([213.201.213.161]:3219 "EHLO
	smtp.imap4all.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbZFAItK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Jun 2009 04:49:10 -0400
Message-ID: <4A2395FA.8090905@deckpoint.ch>
Date: Mon, 01 Jun 2009 10:48:58 +0200
From: Thomas Kernen <tkernen@deckpoint.ch>
MIME-Version: 1.0
To: Thomas Kernen <tkernen@deckpoint.ch>, linux-media@vger.kernel.org
Subject: [SOLVED] Re: Mystique SaTiX DVB-S2 & s2-liplianin & Ubuntu 9.04 64
 bit - modules load but tuning not successful
References: <4A211934.3010109@deckpoint.ch>
In-Reply-To: <4A211934.3010109@deckpoint.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thomas Kernen wrote:
> 
> Dear team,
> 
> I'm installing a Mystique SaTiX DVB-S2 PCI card (apparently an OEM 
> version of KNC DVB Station S2) in a box running Ubuntu 9.04 64bit. 
> (2.6.28-11-server #42-Ubuntu SMP Fri Apr 17 02:45:36 UTC 2009 x86_64 
> GNU/Linux)
> 
> I've pulled the latest s2-liplianin code from:
> http://mercurial.intuxication.org/hg/s2-liplianin
> 
> I was able to compile and the modules do load, but I don't seem to be 
> able to tune to anything. Note that I've only tried to tune to DVB-S 
> transponders for now.
> 
> lspci -vvv shows the following:
> 11:09.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
>     Subsystem: KNC One Device 0019
>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
> Stepping- SERR- FastB2B- DisINTx-
>     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>     Latency: 123 (3750ns min, 9500ns max)
>     Interrupt: pin A routed to IRQ 23
>     Region 0: Memory at d0220000 (32-bit, non-prefetchable) [size=512]
>     Kernel driver in use: budget_av
>     Kernel modules: budget-av
> 
>  From dmesg:
> [    9.796943] budget_av 0000:11:09.0: PCI INT A -> GSI 23 (level, low) 
> -> IRQ 23
> [    9.796972] saa7146: found saa7146 @ mem ffffc20001186000 (revision 
> 1, irq 23) (0x1894,0x0019).
> [    9.796976] saa7146 (0): dma buffer size 192512
> [    9.796977] DVB: registering new adapter (KNC1 DVB-S2)
> [    9.853417] adapter failed MAC signature check
> [    9.853419] encoded MAC from EEPROM was 
> ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
> [   10.162850] KNC1-1: MAC addr = 00:09:d6:65:2d:91
> [   10.300005] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting 
> for end of xfer
> [   10.424422] stb0899_attach: Attaching STB0899
> [   10.432541] tda8261_attach: Attaching TDA8261 8PSK/QPSK tuner
> [   10.432543] DVB: registering adapter 1 frontend 0 (STB0899 
> Multistandard)...
> [   10.432731] budget-av: ci interface initialised.
> 
> dvbsnoop shows the following:
> dvbsnoop V1.4.50 -- http://dvbsnoop.sourceforge.net/
> 
> ---------------------------------------------------------
> FrontEnd Info...
> ---------------------------------------------------------
> 
> Device: /dev/dvb/adapter1/frontend0
> 
> Basic capabilities:
>     Name: "STB0899 Multistandard"
>     Frontend-type:       QPSK (DVB-S)
>     Frequency (min):     950.000 MHz
>     Frequency (max):     2150.000 MHz
>     Frequency stepsiz:   0.000 MHz
>     Frequency tolerance: 0.000 MHz
>     Symbol rate (min):     1.000000 MSym/s
>     Symbol rate (max):     45.000000 MSym/s
>     Symbol rate tolerance: 0 ppm
>     Notifier delay: 0 ms
>     Frontend capabilities:
>         auto inversion
>         FEC AUTO
>         QPSK
> 
> Current parameters:
>     Frequency:  1776.000 MHz
>     Inversion:  AUTO
>     Symbol rate:  27.500000 MSym/s
>     FEC:  FEC AUTO
> 
> If I try to use scan-s2 I get the following output:
> 
> API major 5, minor 0
> ERROR: Cannot open rotor configuration file 'rotor.conf'.
> scanning /usr/share/dvb/dvb-s/Astra-19.2E
> using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
> initial transponder DVB-S  12551500 V 22000000 5/6 AUTO AUTO
> initial transponder DVB-S2 12551500 V 22000000 5/6 AUTO AUTO
> ----------------------------------> Using DVB-S
>  >>> tune to: 12551:vC56S0:S0.0W:22000:
> DiSEqC: uncommitted switch pos 0
> DiSEqC: e0 10 39 f0 00 00
> DiSEqC: switch pos 0, 13V, hiband (index 2)
> DiSEqC: e0 10 38 f1 00 00
> DVB-S IF freq is 1951500
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
> WARNING: >>> tuning failed!!!
>  >>> tune to: 12551:vC56S0:S0.0W:22000: (tuning failed)
> DiSEqC: uncommitted switch pos 0
> DiSEqC: e0 10 39 f0 00 00
> DiSEqC: switch pos 0, 13V, hiband (index 2)
> DiSEqC: e0 10 38 f1 00 00
> DVB-S IF freq is 1951500
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
> WARNING: >>> tuning failed!!!
> ----------------------------------> Using DVB-S2
>  >>> tune to: 12551:vC56S1:S0.0W:22000:
> DiSEqC: uncommitted switch pos 0
> DiSEqC: e0 10 39 f0 00 00
> DiSEqC: switch pos 0, 13V, hiband (index 2)
> DiSEqC: e0 10 38 f1 00 00
> DVB-S IF freq is 1951500
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
> WARNING: >>> tuning failed!!!
>  >>> tune to: 12551:vC56S1:S0.0W:22000: (tuning failed)
> DiSEqC: uncommitted switch pos 0
> DiSEqC: e0 10 39 f0 00 00
> DiSEqC: switch pos 0, 13V, hiband (index 2)
> DiSEqC: e0 10 38 f1 00 00
> DVB-S IF freq is 1951500
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
>  >>> tuning status == 0x00
> WARNING: >>> tuning failed!!!
> ERROR: initial tuning failed
> dumping lists (0 services)
> Done.
> 
> Note: Card and sat feed are known the work, I've tested it under Windows 
> without any issues and I have a Skystar 2 in this server that works fine.
> 
> Any suggestions what may be the issue and how I could solve it?
> 
> Thanks
> Thomas
> 

The issue had to do with an unsuccessful build of the modules from the 
s2-liplianin tree. Not due to the tree itself but an issue with the 
Ubuntu kernel version that had both the "generic" and "server" releases 
linked to.

I cleared up the environment (removed a bunch of packages) and then 
pulled the tree from http://linuxtv.org/hg/v4l-dvb and rebuilt the modules.

Now the card can tune without any issues. Next I need to get the CAM 
working.

Thomas





