Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1KOcaz-0002Bm-4t
	for linux-dvb@linuxtv.org; Thu, 31 Jul 2008 20:09:50 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Ben Johnson <ben_v_johnson@hotmail.com>
In-Reply-To: <BLU117-W36B61F5A42625A378CA7D7A17C0@phx.gbl>
References: <mailman.0.1217068026.17467.linux-dvb@linuxtv.org>
	<BLU117-W36B61F5A42625A378CA7D7A17C0@phx.gbl>
Date: Thu, 31 Jul 2008 20:03:32 +0200
Message-Id: <1217527412.3272.24.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Please - can't someone help -
	saa7134-input	Avermedia Super 007 Support (Remote)
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

Hi Ben,

Am Donnerstag, den 31.07.2008, 19:48 +1000 schrieb Ben Johnson:
> Hi
> 
> I sent in this a few days ago, but no one has been able to help yet.
> Please can someone help me.
> 

if this card also has no IR decoder chip on board, like the analog only
ones, then Mauro seems to have a solution.

Plaese be patient, he is not free in what is on top of his todo list.

Else for simple gpio remotes we have instructions on the v4l wiki at
linutv.org. If it has an IR controller, you can look up other Avermedia
cards and remotes also at the http://www.bttv-gallery.de

If already known, then you simply add the card to the gpio remotes in
saa7134-cards.c and accordingly in saa7134-input.c.

An example for a solution without IR controller chip is the patch for
the recent Asus PC-39 remote. This has an unknown transmitter chip and a
3.3 Volts only receiver talking some sort of RC5. A potential deadlock,
if irqs are delayed, was fixed later.

Cheers,
Hermann


________________________________________________________________________
> 
> Hi
> 
> I am a complete newbie looking for help getting the Remote for an
> Avermedia Super 007 (Digital only) working.  After looking around I
> believe that adding support should only require adding a new case to
> the (dev->board) switch in the saa7134-input.c file titled:
> 
> SAA7134_BOARD_AVERMEDIA_SUPER_007
> 
> Questions:
> 1.  Is this forum the right place to be asking these questions? If
> not, where is please?
> 2.  Should adding the relevant information to the saa7134-input.c file
> for an otherwise supported saa7134 dvb-t card result in the remote
> being supported?
> 3. If so, how do I determine what information needs to be supplied.
> ie:
>  - are the ir_codes_avermedia appropriate for this card
>  - how do you tell what the mask_keycode and mask_keydown should be?
>  - how do you work out the appropriate polling interval
>  - what part does saa_setb play in all this.
> 
> I have the card working and am able to upload any supported
> information needed.
> 
> Thanks in advance for your help - BVJ.
> 
> My New Box:
> 2.6.24-19-generic x86_64 GNU/Linux (Mythbuntu 8.04 fully patched)
> AMD Athalon X2 64 B4850
> Gigabyte MA78GM-S2H with AMD 780 Northbridge & ATI HD 3200 Graphics
> Avermedia Super 007 (Digital Only) saa7133 & tda8290
> 
> LSPCI output:
> 03:06.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135
> Video Broadcast Decoder (rev d1)
>     Subsystem: Avermedia Technologies Inc Unknown device f01d
>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B-
>     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 32 (21000ns min, 8000ns max)
>     Interrupt: pin A routed to IRQ 20
>     Region 0: Memory at fdcff000 (32-bit, non-prefetchable) [size=2K]
>     Capabilities: [40] Power Management version 2
>         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>         Status: D0 PME-Enable- DSel=0 DScale=1 PME-
> 00: 31 11 33 71 06 00 90 02 d1 00 80 04 00 20 00 00
> 10: 00 f0 cf fd 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 61 14 1d f0
> 30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 54 20
> 40: 01 00 02 06 00 20 00 1c 00 00 00 00 00 00 00 00
> 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> 
> DMESG output:
> 
> [   47.222507] Linux video capture interface: v2.00
> [   47.407888] saa7130/34: v4l2 driver version 0.2.14 loaded
> [   47.407972] saa7133[0]: found at 0000:03:06.0, rev: 209, irq: 20,
> latency: 32, mmio: 0xfdcff000
> [   47.407979] saa7133[0]: subsystem: 1461:f01d, board: Avermedia
> Super 007 [card=117,autodetected]
> [   47.407988] saa7133[0]: board init: gpio is 40000
> [   47.542574] saa7133[0]: i2c eeprom 00: 61 14 1d f0 54 20 1c 00 43
> 43 a9 1c 55 d2 b2 92
> [   47.542581] saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff
> ff ff ff ff ff ff ff
> [   47.542586] saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 43 88
> ff 00 55 ff ff ff ff
> [   47.542590] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   47.542595] saa7133[0]: i2c eeprom 40: ff 21 00 c0 96 10 03 02 15
> 16 ff ff ff ff ff ff
> [   47.542599] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   47.542603] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   47.542607] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> 
> [   47.932906] tuner 1-004b: chip found @ 0x96 (saa7133[0])
> [   47.981769] tda8290 1-004b: setting tuner address to 60
> [   48.084618] tuner 1-004b: type set to tda8290+75a
> [   48.132535] tda8290 1-004b: setting tuner address to 60
> [   48.236347] tuner 1-004b: type set to tda8290+75a
> [   48.239259] saa7133[0]: registered device video0 [v4l2]
> [   48.239278] saa7133[0]: registered device vbi0
> [   48.330034] saa7134 ALSA driver for DMA sound loaded
> [   48.330064] saa7133[0]/alsa: saa7133[0] at 0xfdcff000 irq 20
> registered as card -2
> [   48.356488] DVB: registering new adapter (saa7133[0])
> [   48.356494] DVB: registering frontend 0 (Philips TDA10046H
> DVB-T)...
> [   48.428950] tda1004x: setting up plls for 48MHz sampling clock
> [   48.712424] tda1004x: found firmware revision 20 -- ok
> 
> 
> 
> ______________________________________________________________________


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
